require("tools")

make_check <- function(srcpkg, dir = "./") {
   if (dir == "") dir <- "./"
   .libPaths("")
   options(repos = "http://CRAN.at.R-project.org")
   odir <- setwd(dir)

   pkg <- strsplit(srcpkg, "_")[[1]][1]

   cdir <- paste(pkg, "CRAN", sep = "_")
   ddir <- paste(pkg, "devel", sep = "_")

   if (!file.exists(cdir)) {
       dir.create(cdir)
   } else {
       system(paste("rm -rf", cdir))
       dir.create(cdir)
   }
   if (!file.exists(ddir)) {
       dir.create(ddir)
   } else {
       system(paste("rm -rf", ddir))
       dir.create(ddir)
   }
   file.copy(srcpkg, ddir)
   download.packages(pkg, repos = options("repos"), destdir = cdir)

   check_packages_in_dir(cdir, reverse = list(), Ncpus = 4)
   check_packages_in_dir(ddir, reverse = list(), Ncpus = 4)

   cat("\n\nReverse tests with CRAN package:\n")
   summarize_check_packages_in_dir_results(cdir, all = TRUE)
   summarize_check_packages_in_dir_timings(cdir, all = TRUE)

   cat("\n\nReverse tests with NEW package:\n")
   summarize_check_packages_in_dir_results(ddir, all = TRUE)
   summarize_check_packages_in_dir_timings(ddir, all = TRUE)

   cat("\n\nComparison of results:\n")
   check_packages_in_dir_changes(ddir, cdir, outputs = TRUE, sources = TRUE)
   # setwd(odir)
}

# package_dependencies("gamboostLSS", available.packages(), reverse = TRUE)
.owd <- setwd("../")
make_check(srcpkg = "gamboostLSS_2.0-0.tar.gz")
setwd(.owd)