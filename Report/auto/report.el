(TeX-add-style-hook
 "report"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("minted" "cache=false")))
   (add-to-list 'LaTeX-verbatim-environments-local "minted")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art11"
    "bm"
    "cmap"
    "ctex"
    "cite"
    "color"
    "float"
    "xeCJK"
    "amsthm"
    "amsmath"
    "amssymb"
    "setspace"
    "geometry"
    "hyperref"
    "enumerate"
    "indentfirst"
    "yfonts"
    "pdfpages"
    "ulem"
    "minted")
   (TeX-add-symbols
    '("verilogcode" 1))
   (LaTeX-add-labels
    "sec:设计思路"
    "fig:openmips"
    "fig:openmips_min_sopc"
    "sec:创新之处"
    "sec:分支预测器"
    "sec:Cache"
    "sec:遇到问题"
    "sec:Cache问题"
    "sec:通讯问题"
    "sec:一些想法"
    "sec:特别感谢"))
 :latex)

