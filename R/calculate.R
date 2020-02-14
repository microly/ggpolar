#' polar_x
#'
#' @param radius a numeric
#' @param theta a numeric
#'
#' @return x
#' @export
#'
#' @examples
polar_x <- function(radius, theta) {
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
polar_y <- function(radius, theta) {
    radius * sinpi(theta/180)
}

