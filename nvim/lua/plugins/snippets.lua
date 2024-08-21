local ls = require("luasnip")
local date = function() return {os.date('%B %d, %Y')} end

ls.add_snippets(nil, {
  tex = {

    ls.snippet({
      trig = "homework",
      namr = "Homework",
      dscr = "Template for LaTeX homework",
    }, {
      ls.text_node({
        "\\documentclass{article}",
        "\\usepackage[utf8]{inputenc}",
        "\\usepackage{amsmath, amssymb, amsthm}",
        "",
        "\\title{Homework}",
        "\\author{Zachary Alfano}",
        "\\date{"
      }),
      ls.function_node(date, {}),
      ls.text_node({
        "}",
        "",
        "\\begin{document}",
        "",
        "\\maketitle",
        "",
        "\\section*{Question 1}",
        "",
        "",
      }),
      ls.insert_node(0, "Enter text here..."),
      ls.text_node({
        "",
        "",
        "\\end{document}"
      })
    }),

    ls.snippet({
      trig = "mla",
      namr = "MLA Essay Template",
      dscr = "Template for MLA in LaTeX",
    }, {
      ls.text_node({
        "\\documentclass[12pt, letterpaper]{article}",
        "",
        "\\usepackage{mla}",
        "\\usepackage[style=mla]{biblatex}",
        "",
        "\\addbibresource{ref.bib}",
        "",
        "\\begin{document}",
        "  \\begin{mla}{Zachary}{Alfano}{Professor Name}{Course Name}{Due Date}{Title}",
        "",
        "    I am just adding text here to that the paragraph can go onto a new line. According to Einstein: $E=mc^2$ \\autocite[5]{einstein}.",
        "",
        "    ",
      }),
      ls.insert_node(0, "Enter text here..."),
      ls.text_node({
        "",
        "",
        "    \\begin{workscited}",
        "      \\printbibliography[heading=none]",
        "    \\end{workscited}",
        "",
        "  \\end{mla}",
        "\\end{document}",
      })
    }),

  },
})
