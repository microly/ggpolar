drop_xy <- function(aes) {
    aes[!(aes %in% c("x", "y"))]
    #c(aes[!(aes %in% c("x", "y"))], c("p_radius", "p_theta"))
}


# aes_add_pole <- function(aes) {
#
#     aes_new <- c(aes,
#                  ggplot2::aes(x = ggplot2::stat(x),
#                               y = ggplot2::stat(y),
#                               pole_x = 0, pole_y = 0))
#
#     class(aes_new) <- "uneval"
#
#     aes_new
# }


aes_require_x <- function(stat) {
    "x" %in% stat$required_aes
}


aes_require_y <- function(stat) {
    "y" %in% stat$required_aes
}




