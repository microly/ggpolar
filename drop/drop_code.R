### examples for StatPolar
#' library(tibble)
#' library(magrittr)
#' library(ggplot2)
#'
#' tibble(m = rep(c(1,3), 3),
#'        a = c(60, 60, 180, 180, 300, 300),
#'        g = rep(c(1,2,3), each = 2),
#'        x = 1,
#'        y = 0) %>%
#'     ggplot() +
#'         geom_line(aes(p_radius = m, p_theta = a,
#'                       polar_x = x, polar_y = y,
#'                       group = g),
#'                   stat = "polar") +
#'         geom_line(aes(p_radius = m, p_theta = a,
#'                       polar_x = x, polar_y = y, polar_theta0 = 10,
#'                       group = g),
#'                   stat = "polar", colour = "red") +
#'         geom_point(aes(x = 0, y = 0), data = NULL) +
#'         coord_equal()
#'
#' tibble(m = c(3, 3, 3, 3, 1, 1, 1, 1),
#'        a = c(0, 90, 180, 270, 45, 135, 225, 315),
#'        g = factor(c(1, 1, 1, 1, 2, 2, 2, 2))) %>%
#'     ggplot() + geom_polygon(aes(p_radius = m, p_theta = a, group = g, fill = g),
#'                             stat = "polar") +
#'     coord_equal()

