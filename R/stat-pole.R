#' StatPole
#'
#' @inheritParams ggplot2::stat_identity
#'
#' @export
StatPole <- ggplot2::ggproto("StatPole", Stat,
    required_aes = c("module", "angle"),
    default_aes = ggplot2::aes(x = ggplot2::stat(x), y = ggplot2::stat(y)),

    compute_group = function(data, scales) {
        x = pole_x(data$module, data$angle)
        y = pole_y(data$module, data$angle)

        data.frame(x = x, y = y)
    }
)



# tibble(m = rep(c(1,3), 3),
#        a = c(60, 60, 180, 180, 300, 300),
#        g = rep(c(1,2,3), each = 2)) %>%
#     ggplot() + geom_line(aes(module = m, angle = a, group = g),
#                          stat = "pole") +
#     geom_point(aes(x = 0, y = 0), data = NULL) +
#     coord_equal()
#
#
# tibble(m = c(3, 3, 3, 3, 1, 1, 1, 1),
#        a = c(0, 90, 180, 270, 45, 135, 225, 315),
#        g = factor(c(1, 1, 1, 1, 2, 2, 2, 2))) %>%
#     ggplot() + geom_polygon(aes(module = m, angle = a, group = g, fill = g),
#                             stat = "pole") +
#         coord_equal()




