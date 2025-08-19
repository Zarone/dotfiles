package main

import (
	"context"
	"html/template"
	"log"
	"net/http"
	"os"
	"os/signal"
	"path/filepath"
	"regexp"
	"strings"
	"sync"
	"syscall"
	"time"
	"fmt"
)

var (
	// Adjust path to your markdown file here or pass via env var READING_FILE
	file = filepath.Join(os.Getenv("HOME"), "Dropbox", "vimwiki", "Research_Papers.md")
	lineRe      = regexp.MustCompile(`^- \[( |X)\] \[(.+?)\]\((.+?)\)`)
	client      = http.Client{Timeout: 6 * time.Second}
)

type Paper struct {
	Index     int
	Read      bool
	Title     string
	Link      string
	Authors   string
	Citations	*int
}

type PageData struct {
	Papers  []Paper
	Read		int
	Total		int
}

type citationCacheEntry struct {
	Count     *int
	Timestamp time.Time
}

type Server struct {
	filePath string

	// fileLines holds the raw markdown lines
	mu        sync.Mutex
	fileLines []string

	// citations cache
	cacheMu sync.Mutex
	cache   map[string]citationCacheEntry

	// HTTP server so we can shutdown
	httpServer *http.Server
}

func NewServer(filePath string) *Server {
	return &Server{
		filePath: filePath,
		cache:    make(map[string]citationCacheEntry),
	}
}

func (s *Server) loadFile() error {
	s.mu.Lock()
	defer s.mu.Unlock()
	b, err := os.ReadFile(s.filePath)
	if err != nil {
		return err
	}
	s.fileLines = strings.Split(string(b), "\n")
	return nil
}

// parse the fileLines and return papers in order
func (s *Server) parsePapers() ([]Paper, error) {
	s.mu.Lock()
	lines := append([]string(nil), s.fileLines...) // copy
	s.mu.Unlock()

	var papers []Paper
	idx := 0
	for i := 0; i < len(lines); i++ {
		line := lines[i]
		if m := lineRe.FindStringSubmatch(line); m != nil {
			read := m[1] == "X"
			title := m[2]
			link := m[3]
			authors := ""
			if i+1 < len(lines) {
				// next line might be "  - Authors"
				next := strings.TrimSpace(lines[i+1])
				if strings.HasPrefix(next, "- ") {
					authors = strings.TrimPrefix(next, "- ")
				} else {
					authors = next
				}
			}
			p := Paper{
				Index:   idx,
				Read:    read,
				Title:   title,
				Link:    link,
				Authors: authors,
			}
			// try to get citation from cache synchronously (fast) else nil
			if c := s.getCachedCitation(title); c != nil {
				p.Citations = c
			}
			papers = append(papers, p)
			idx++
		}
	}
	return papers, nil
}

// getCachedCitation returns cached value if TTL not expired, else nil
func (s *Server) getCachedCitation(title string) *int {
	s.cacheMu.Lock()
	defer s.cacheMu.Unlock()
	if e, ok := s.cache[title]; ok {
		if time.Since(e.Timestamp) < 24*time.Hour { // TTL 24h
			return e.Count
		}
		// expired; delete so next fetch refreshes
		delete(s.cache, title)
	}
	return nil
}

// fetchCitation queries Semantic Scholar for citationCount (best-effort)
// caches result (including nil) with timestamp to avoid hammering API.
func (s *Server) fetchCitation(title string) *int {
	// check cache again (avoid duplicate requests)
	if c := s.getCachedCitation(title); c != nil {
		return c
	}

	// Make request to Semantic Scholar graph search
	// API: https://api.semanticscholar.org/graph/v1/paper/search?query=...&limit=1&fields=citationCount
	// No API key required for basic usage, but mind rate limits.
	//url := "https://api.semanticscholar.org/graph/v1/paper/search"
	//req, _ := http.NewRequest("GET", url, nil)
	//q := req.URL.Query()
	//q.Set("query", title)
	//q.Set("limit", "1")
	//q.Set("fields", "citationCount")
	//req.URL.RawQuery = q.Encode()

	//resp, err := client.Do(req)
	//if err != nil {
		//// cache negative result for short TTL
		//s.cacheMu.Lock()
		//s.cache[title] = citationCacheEntry{Count: nil, Timestamp: time.Now()}
		//s.cacheMu.Unlock()
		//return nil
	//}
	//defer resp.Body.Close()
	//body, _ := io.ReadAll(resp.Body)
	//var dat struct {
		//Data []struct {
			//CitationCount int `json:"citationCount"`
		//} `json:"data"`
	//}
	//if err := json.Unmarshal(body, &dat); err != nil || len(dat.Data) == 0 {
		//s.cacheMu.Lock()
		//s.cache[title] = citationCacheEntry{Count: nil, Timestamp: time.Now()}
		//s.cacheMu.Unlock()
		//return nil
	//}
	//cnt := dat.Data[0].CitationCount
	//s.cacheMu.Lock()
	//s.cache[title] = citationCacheEntry{Count: &cnt, Timestamp: time.Now()}
	//s.cacheMu.Unlock()
	//return &cnt
	tmp := 0
	return &(tmp)
}

var tmpl = template.Must(template.New("index").Parse(`
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<title>Reading List</title>
	<script src="https://cdn.jsdelivr.net/npm/htmx.org@2.0.6/dist/htmx.min.js" integrity="sha384-Akqfrbj/HpNVo8k11SXBb6TlBWmXXlYQrCSqEWmyKJe+hDm3Z/B2WVG4smwBkRVm" crossorigin="anonymous"></script>
	<style>
		body { 
			font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; 
			margin: 0 2rem; 
			display: block;
		}
		.paper { 
			padding: 0.6rem 0; 
			border-bottom: 1px solid #eee; 
			display:flex; 
			gap:1rem; 
			align-items:center; 
		}
		.read { 
			color: #777; 
		}
		.btn { 
			border-radius:6px; 
			padding:6px 8px; 
			border: 1px solid #ccc; 
			background:#f7f7f7; 
			cursor:pointer; 
		}
		.meta { 
			color:#444; 
			font-size:0.9rem; 
		}
		.shutdown { 
			background:#e74c3c; 
			color:white; 
			border:none; 
			padding:8px 10px; 
			border-radius:6px; 
		}
		.shutdown:hover{
			background:#f75c4c; 
		}
		.list {
			height: 80vh;
			overflow-y: scroll;
		}
		.header {
			display: flex;
			align-items: center;
		}
	</style>
</head>

<body>

<div class="header">
	<form hx-post="/shutdown" hx-target="body">
		<button type="submit" class="shutdown">Stop Server</button>
	</form>
	<div style="padding:10px;">
		<p>Total Read: {{.Read}}/{{.Total}}</p>
	</div>
</div>

<h1>📚 Reading List</h1>

<div id="list" class="list">
	{{range $i, $p := .Papers}}
		<div class="paper" id="paper-{{$p.Index}}">
			<button class="btn">
				{{if $p.Read}}✅{{else}}⬜{{end}}
			</button>

			<div style="flex:1">
				<a href="{{$p.Link}}" class="{{if $p.Read}}read{{end}}">{{$p.Title}}</a>
				<div class="meta">{{$p.Authors}}
					{{if $p.Citations}} | Citations: {{$p.Citations}}{{end}}
				</div>
			</div>

		</div>
	{{end}}
</div>

</body>
</html>
`))

// Handler: GET /
func (s *Server) handleIndex(w http.ResponseWriter, r *http.Request) {
	// load fresh file, parse
	if err := s.loadFile(); err != nil {
		http.Error(w, "unable to read file: "+err.Error(), http.StatusInternalServerError)
		return
	}
	papers, _ := s.parsePapers()
	totalRead := 0
	for i := range papers {
		if papers[i].Read { totalRead++ }
		if papers[i].Citations == nil {
			title := papers[i].Title
			go func(t string) {
				if c := s.fetchCitation(t); c != nil {
					// No need to push update to client — user can reload — but we update cache
					_ = c
				}
			}(title)
		}
	}
	data := PageData{Papers: papers, Total: len(papers), Read: totalRead }
	if err := tmpl.Execute(w, data); err != nil {
		log.Println("tmpl error:", err)
	}
}


// Handler: POST /shutdown
func (s *Server) handleShutdown(w http.ResponseWriter, r *http.Request) {
	fmt.Println("shutdown request")
	go func() {
		// allow the HTTP response to complete before shutting down
		time.Sleep(200 * time.Millisecond)
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		if err := s.httpServer.Shutdown(ctx); err != nil {
			log.Printf("shutdown error: %v", err)
		}
	}()
	w.Write([]byte("shutting down"))
}

func main() {
	s := NewServer(file)
	if err := s.loadFile(); err != nil {
		log.Fatalf("cannot read reading file %s: %v", file, err)
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", s.handleIndex)
	mux.HandleFunc("/shutdown", s.handleShutdown)

	addr := "127.0.0.1:5001"
	s.httpServer = &http.Server{Addr: addr, Handler: mux}

	// graceful shutdown on SIGINT/SIGTERM
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		log.Printf("serving reading list at http://%s (file: %s)\n", addr, file)
		if err := s.httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("server error: %v", err)
		}
	}()

	<-stop
	log.Println("signal received, shutting down")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_ = s.httpServer.Shutdown(ctx)
}

