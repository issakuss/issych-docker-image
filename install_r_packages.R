args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  stop("Usage: Rscript install_r_packages.R <path_to_requirements.txt>")
}

file_path <- args[1]

if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

lines <- readLines(file_path)
lines <- lines[lines != "" & !grepl("^#", lines)]  # 空行・コメントを除く

for (line in lines) {
  if (grepl("==", line)) {
    parts <- strsplit(line, "==")[[1]]
    pkg <- trimws(parts[1])
    ver <- trimws(parts[2])
    if (!(pkg %in% rownames(installed.packages()))) {
      message(sprintf("Installing %s version %s", pkg, ver))
      remotes::install_version(pkg, version = ver, repos = "https://cloud.r-project.org")
    }
  } else {
    pkg <- trimws(line)
    if (!(pkg %in% rownames(installed.packages()))) {
      message(sprintf("Installing latest version of %s", pkg))
      install.packages(pkg, repos = "https://cloud.r-project.org")
    }
  }
}