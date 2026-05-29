# post_render.R -----------------------------------------------------------
# Runs automatically after `quarto render` (wired in _quarto.yml).
#
# Job: move PDF and DOCX outputs out of `docs/reports/` (the website folder)
# and into `manuscript/output/` (the paper folder). HTML stays in docs/ so
# GitHub Pages can serve it.
#
# Quarto sets QUARTO_PROJECT_OUTPUT_FILES to a newline-separated list of the
# files it just produced.

output_files <- Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES")
if (!nzchar(output_files)) quit(save = "no")

files <- strsplit(output_files, "\n", fixed = TRUE)[[1]]
files <- files[nzchar(files)]

dest_dir <- file.path("manuscript", "output")
dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)

moved <- character()
for (f in files) {
  if (!file.exists(f)) next
  ext <- tools::file_ext(f)
  if (ext %in% c("pdf", "docx")) {
    dest <- file.path(dest_dir, basename(f))
    if (file.copy(f, dest, overwrite = TRUE)) {
      file.remove(f)
      moved <- c(moved, dest)
    }
  }
}

if (length(moved) > 0) {
  message("post_render: moved ",
          paste(basename(moved), collapse = ", "),
          " -> ", dest_dir)
}
