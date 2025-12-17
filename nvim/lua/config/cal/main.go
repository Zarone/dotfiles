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
	file = filepath.Join(os.Getenv("HOME"), "Dropbox", "vimwiki", "To_Do.md")
	taskRe = regexp.MustCompile(`^- (\*{0,2})(\d{1,2}/\d{1,2}/\d{2})(?:\*{0,2}) (.+)$`)
)

type Task struct {
	Date      time.Time
	Text      string
	Important bool
}

type CalendarData struct {
	TasksByDay map[string][]Task
	Start      time.Time
	End        time.Time
	Today      time.Time
}

type Server struct {
	filePath   string
	mu         sync.Mutex
	fileLines  []string
	httpServer *http.Server
}

func NewServer(filePath string) *Server {
	return &Server{filePath: filePath}
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

func (s *Server) parseTasks() ([]Task, error) {
	s.mu.Lock()
	lines := append([]string(nil), s.fileLines...)
	s.mu.Unlock()

	var tasks []Task
	for _, line := range lines {
		if m := taskRe.FindStringSubmatch(line); m != nil {
			important := len(m[1]) > 0
			dateStr := m[2]
			text := m[3]
			if important {
				text = text[:len(text)-2]
			}

			date, err := time.Parse("1/2/06", dateStr)
			if err != nil {
				continue
			}
			tasks = append(tasks, Task{Date: date, Text: text, Important: important})
		}
	}
	return tasks, nil
}

var funcMap = template.FuncMap{
	"daysBetween": daysBetween,
}

// helper for template
func daysBetween(start, end time.Time) []time.Time {
	var days []time.Time
	for d := start; !d.After(end); d = d.AddDate(0, 0, 1) {
		days = append(days, d)
	}
	return days
}

func calendarBounds(start, end time.Time) (time.Time, time.Time) {
	// move start back to Sunday
	for start.Weekday() != time.Sunday {
		start = start.AddDate(0, 0, -1)
	}
	// move end forward to Saturday
	for end.Weekday() != time.Saturday {
		end = end.AddDate(0, 0, 1)
	}
	return start, end
}

var tmpl = template.Must(
	template.New("calendar").
		Funcs(funcMap).
		Parse(`
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<title>To Do Calendar</title>
	<style>
		body { font-family: system-ui; margin: 20px; }
		.calendar-container {
			max-height: 80vh; 
			overflow-y: auto; 
			border: 1px solid #ddd;
		}
		.calendar {
			display: grid; 
			grid-template-columns: repeat(7, 1fr); 
			gap: 6px;
		}
		.weekdays {
			display: grid;
			grid-template-columns: repeat(7, 1fr);
			background: #f8f8f8;
			font-weight: bold;
			text-align: center;
			position: sticky;
			top: 0;
			z-index: 10;
			border-bottom: 1px solid #ccc;
		}
		.day { 
			border: 1px solid #ccc; 
			min-height: 100px; 
			padding: 4px; 
			background: #fff;
			border-radius: 10px;
		}
		.today {
			background-color: rgb(207, 224, 230);
		}
		.day h4 { 
			margin: 0; 
			font-size: 0.9rem; 
		}
		.task { 
			font-size: 0.85rem; 
			margin-left: 6px; 
			padding-inline-start: 10px;
		}
		.important { 
			color: red; 
			font-weight: bold; 
		}
	</style>
</head>
<body>
<h1>🗓 To Do Calendar</h1>

<div class="calendar-container">
	<div class="weekdays">
		<div>Sun</div>
		<div>Mon</div>
		<div>Tue</div>
		<div>Wed</div>
		<div>Thu</div>
		<div>Fri</div>
		<div>Sat</div>
	</div>
	<div class="calendar">
		{{ $start := .Start }}
		{{ $end := .End }}
		{{ $tasks := .TasksByDay }}
		{{ $today := .Today.Format "2006-01-02" }}
		{{ range $d := daysBetween $start $end }}
			<div class="day {{ if eq ($d.Format "2006-01-02") $today }}today{{ end }}">
				<h4>{{ $d.Format "Jan 2" }}</h4>
				{{ with index $tasks ($d.Format "2006-01-02") }}
					<ul style="padding-inline-start: 10px;">
						{{ range . }}
							<li class="task {{ if .Important }}important{{ end }}">{{ .Text }}</li>
						{{ end }}
					</ul>
				{{ end }}
			</div>
		{{ end }}
	</div>
</div>

</body>
</html>
`))

func (s *Server) handleIndex(w http.ResponseWriter, r *http.Request) {
	if err := s.loadFile(); err != nil {
		http.Error(w, "cannot read file: "+err.Error(), 500)
		return
	}
	tasks, _ := s.parseTasks()

	if len(tasks) == 0 {
		http.Error(w, "no tasks found", 500)
		return
	}

	// group by date
	tasksByDay := make(map[string][]Task)
	now := time.Now()
	start := tasks[0].Date
	if now.Before(start) {
		start = now
	}

	end := tasks[0].Date
	for _, t := range tasks {
		key := t.Date.Format("2006-01-02")
		tasksByDay[key] = append(tasksByDay[key], t)
		if t.Date.Before(start) { start = t.Date }
		if t.Date.After(end) { end = t.Date }
	}
	start, end = calendarBounds(start, end)

	data := CalendarData{
		TasksByDay: tasksByDay,
		Start:      start,
		End:        end,
		Today:      time.Now(),
	}
	funcMap := template.FuncMap{"daysBetween": daysBetween}
	tmplWithFunc := tmpl.Funcs(funcMap)

	if err := tmplWithFunc.Execute(w, data); err != nil {
		log.Println("template error:", err)
	}
}

func (s *Server) handleShutdown(w http.ResponseWriter, r *http.Request) {
	fmt.Println("shutdown request")
	go func() {
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
		log.Fatalf("cannot read file %s: %v", file, err)
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", s.handleIndex)
	mux.HandleFunc("/shutdown", s.handleShutdown)

	addr := "127.0.0.1:5002"
	s.httpServer = &http.Server{Addr: addr, Handler: mux}

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		log.Printf("serving calendar at http://%s (file: %s)\n", addr, file)
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

