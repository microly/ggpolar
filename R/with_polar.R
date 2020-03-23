# with_pole
# 1.
# TODO: x0, y0 can be param             modify mapping (aes)
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



# ggplot(data.frame(x = 1:3, y = 1:3, z = 1)) +
# with_polar(geom_line(aes(p_radius = x, p_theta = y)))

# ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10))))) +
# with_polar(stat_smooth(aes(p_radius = x, p_theta = y, polar_x = 10, polar_y = 10,
#            group = z, colour = z)))

# ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10)))),
#        aes(p_radius = x, p_theta = y, polar_x = 10, polar_y = 10,
#        group = z, colour = z)) + with_polar(stat_smooth())

# ggplot() + with_polar(geom_sf())

# ggplot(tibble(x = 1:100), aes(x)) + with_polar(geom_histogram())

# ggplot(faithful, aes(x = eruptions, y = waiting, p_radius = eruptions, p_theta = waiting)) +
# with_polar(geom_point(), geom_density_2d())
# 5: stat_contour(): Zero contours were generated
# 6: In min(x) : no non-missing arguments to min; returning Inf
# 7: In max(x) : no non-missing arguments to max; returning -Inf

# ggplot(faithful, aes(p_radius = eruptions, p_theta = waiting)) +
#    with_polar(geom_point(), geom_density_2d())
# Computation failed in `poled_stat()`:
# attempt to apply non-function

### VIP
# ggplot(faithfuld, aes(p_radius = eruptions, p_theta = waiting)) +
#    with_polar(stat_contour(aes(z = density)))
# 1: In isoband_z_matrix(data) : NAs introduced by coercion to integer range
# 2: Computation failed in `poled_stat()`: invalid 'ncol' value (too large or NA)


with_polar <- function(...) {
    x <- list(...)
    with_polar_impl(x)
}


with_polar_impl <- function(x) {
    UseMethod("with_polar_impl")
}


with_polar_impl.default <- function(x) {
    stop("with_polar() can't work with object of class `", class(x), ".\n",
        call. = FALSE)
}


with_polar_impl.list <- function(x) {

    l <- list()

    # for some reason lapply() version of this doesn't work
    for (i in seq_along(x)) {
        l[[i]] <- with_polar_impl(x[[i]])
    }

    if (length(l) == 1) return(l[[1]])
    l
}


with_polar_impl.Layer <- function(x) {

    parent_stat <- x$stat

    if (inherits(parent_stat, "StatPole")) return(x)

    if (inherits(parent_stat, "StatIdentity")) {
        x$stat <- StatPolar
        return(x)
    }

    if ((!aes_require_y(parent_stat)) || (!aes_require_y(parent_stat)))
        stop("with_polar() only can work with the layer that has a stat, of which
        the required_aes should include both of x and y!\n", call. = FALSE)

    ggproto(NULL, x, stat = poled_stat(parent_stat))
}


poled_stat <- function(parent_stat) {

    ggproto('PoledStat', parent_stat,
            required_aes = drop_xy(parent_stat$required_aes),
            #default_aes = aes_add_pole(parent_stat$default_aes),

            compute_group = function(data, scales, ...) {

                print(data)

                if (!is.null(data$x)) warning("with_polar() ignoring aes x!", call. = FALSE)
                if (!is.null(data$y)) warning("with_polar() ignoring aes y!", call. = FALSE)

                if (is.null(data$polar_x)) data$polar_x <- 0
                if (is.null(data$polar_y)) data$polar_y <- 0

                x = polar_x(data$p_radius, data$p_theta) + data$polar_x
                y = polar_y(data$p_radius, data$p_theta) + data$polar_y

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

