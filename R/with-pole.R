# with_pole
# 1. !! do not handle sf
# 2. handle that has stat other than identity
# 3.
# TODO: x0, y0 can be param
# tibble(m = rep(c(1,3), 3),
#        a = c(60, 60, 180, 180, 300, 300),
#        g = rep(c(1,2,3), each = 2),
#        x = 1,
#        y = 2) %>%
#     ggplot() + geom_line(aes(module = m, angle = a,
#                              group = g),
#                          x0 = 1, y0 = 2,
#                          stat = "pole") +
#     geom_point(aes(x = 0, y = 0), data = NULL) +
#     coord_equal()
#
# 4.xuanzhuan and ping yi          can handle sf
#    with_pole(layer, nudge_angle, nudge_x0, nudge_y0)

