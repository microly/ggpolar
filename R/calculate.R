#' pole_x
#'
#' @param module a numeric
#' @param angle a numeric
#'
#' @return x
#' @export
#'
#' @examples
pole_x <- function(module, angle) {
    module * cospi(angle/180)
}


#' pole_y
#'
#' @param module a numeric
#' @param angle a numeric
#'
#' @return y
#' @export
#'
#' @examples
pole_y <- function(module, angle) {
    module * sinpi(angle/180)
}

