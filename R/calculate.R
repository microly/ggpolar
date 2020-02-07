#' pole_x
#'
#' @param radius a numeric
#' @param theta a numeric
#'
#' @return x
#' @export
#'
#' @examples
pole_x <- function(radius, theta) {
    radius * cospi(theta/180)
}


#' pole_y
#'
#' @param radius a numeric
#' @param theta a numeric
#'
#' @return y
#' @export
#'
#' @examples
pole_y <- function(radius, theta) {
    radius * sinpi(theta/180)
}

