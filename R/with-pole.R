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



# ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10))))) +
# with_pole(stat_smooth(aes(p_radius = x, p_theta = y, pole_x = 10, pole_y = 10,
#            group = z, colour = z)))

# ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10)))),
#        aes(p_radius = x, p_theta = y, pole_x = 10, pole_y = 10,
#        group = z, colour = z)) + with_pole(stat_smooth())

# ggplot(data.frame(x = 1:3, y = 1:3, z = 1)) +
# with_pole(geom_line(aes(p_radius = x, p_theta = y)))



with_pole <- function(...) {
    x <- list(...)
    with_pole_impl(x)
}


with_pole_impl <- function(x) {
    UseMethod("with_pole_impl")
}


with_pole_impl.default <- function(x) {
    stop(
        "with_pole() can't work with object of class `", class(x), ".\n",
        call. = FALSE
    )
}


with_pole_impl.list <- function(x) {

    l <- list()

    # for some reason lapply() version of this doesn't work
    for (i in seq_along(x)) {
        l[[i]] <- with_pole_impl(x[[i]])
    }

    if (length(l) == 1) return(l[[1]])
    l
}


with_pole_impl.Layer <- function(x) {

    parent_stat <- x$stat

    if (inherits(parent_stat, "StatPole")) return(x)

    if (inherits(parent_stat, "StatIdentity")) {
        x$stat <- StatPole
        return(x)
    }

    ggproto(NULL, x, stat = poled_stat(parent_stat))
}


poled_stat <- function(parent_stat) {

    ggproto('PoledStat', parent_stat,
            required_aes = drop_xy(parent_stat$required_aes),
            #default_aes = aes_add_pole(parent_stat$default_aes),

            compute_group = function(data, scales, ...) {

                print(data)

                if (!is.null(data$x)) warning("ignore aes x!")
                if (!is.null(data$y)) warning("ignore aes y!")

                if (is.null(data$pole_x)) data$pole_x <- 0
                if (is.null(data$pole_y)) data$pole_y <- 0

                x = pole_x(data$p_radius, data$p_theta) + data$pole_x
                y = pole_y(data$p_radius, data$p_theta) + data$pole_y

                data$x <- x
                data$y <- y

                print(data)

                parent_stat$compute_group(data, scales, ...)
            },

            parameters = function(self, extra = FALSE) {
                # make sure we extract parameters of wrapped geom correctly
                parent_stat$parameters(extra)
            })
}


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
