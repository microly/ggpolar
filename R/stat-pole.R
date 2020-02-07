#' StatPole
#'
#' @inheritParams ggplot2::stat_identity
#'
#' @section Aesthetics:
#' new aes: radius, theta, x0, y0
#'
#' @export
StatPole <- ggplot2::ggproto("StatPole", Stat,
    required_aes = c("p_radius", "p_theta"),
    default_aes = ggplot2::aes(x = ggplot2::stat(x), y = ggplot2::stat(y),
                               pole_x = 0, pole_y = 0),

    compute_group = function(data, scales) {

        # print(data)

        if (!is.null(data$x)) warning("ignore aes x!")
        if (!is.null(data$y)) warning("ignore aes y!")

        if (is.null(data$pole_x)) data$pole_x <- 0
        if (is.null(data$pole_y)) data$pole_y <- 0

        x = pole_x(data$p_radius, data$p_theta) + data$pole_x
        y = pole_y(data$p_radius, data$p_theta) + data$pole_y

        data$x <- x
        data$y <- y

        data
    }
)



# tibble(m = rep(c(1,3), 3),
#        a = c(60, 60, 180, 180, 300, 300),
#        g = rep(c(1,2,3), each = 2),
#        x = 1,
#        y = 0) %>%
#     ggplot() + geom_line(aes(p_radius = m, p_theta = a, pole_x = x, pole_y = y,
#                              group = g),
#                          stat = "pole") +
#     geom_point(aes(x = 0, y = 0), data = NULL) +
#     coord_equal()
#
#
# tibble(m = c(3, 3, 3, 3, 1, 1, 1, 1),
#        a = c(0, 90, 180, 270, 45, 135, 225, 315),
#        g = factor(c(1, 1, 1, 1, 2, 2, 2, 2))) %>%
#     ggplot() + geom_polygon(aes(p_radius = m, p_theta = a, group = g, fill = g),
#                             stat = "pole") +
#         coord_equal()




