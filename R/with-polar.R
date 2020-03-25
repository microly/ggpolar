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









#' with_polar
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' ggplot(data.frame(x = 2, y = 1:3 * 30), aes(p_radius = x, p_theta = y)) +
#'     with_polar(geom_line(), geom_point()) +
#'     coord_equal() + xlim(c(0, NA)) + ylim(c(0, NA))
#'
#' ggplot(data.frame(x = 2, y = 1:3 * 30), aes(p_radius = x, p_theta = y, polar_theta0 = -30)) +
#'     with_polar(geom_line(), geom_point()) +
#'     coord_equal() + xlim(c(0, NA)) + ylim(c(0, NA))
#'
#' ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10))))) +
#'     with_polar(stat_smooth(aes(p_radius = x, p_theta = y, polar_x = 10, polar_y = 10,
#'                                group = z, colour = z)))
#'
#' ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10))))) +
#'     with_polar(stat_smooth(aes(p_radius = x, p_theta = y, polar_x = 10, polar_y = 10,
#'                                polar_theta0 = 60,
#'                                group = z, colour = z)))
#'
#' ggplot(data.frame(x = 1:20, y = 1:20, z = factor(c(rep("1",10), rep("2",10)))),
#'        aes(p_radius = x, p_theta = y, polar_x = 10, polar_y = 10,
#'            group = z, colour = z)) + with_polar(stat_smooth())
#'
#' # do not work:
#' # ggplot() + with_polar(geom_sf())
#' # ggplot(tibble(x = 1:100), aes(x)) + with_polar(geom_histogram())
with_polar <- function(..., interpolate = FALSE, supplement = FALSE, add_origin = FALSE) {
    x <- list(...)
    with_polar_impl(x, interpolate = interpolate, supplement = supplement, add_origin = add_origin)
}


with_polar_impl <- function(x, interpolate, supplement, add_origin) {
    UseMethod("with_polar_impl")
}


with_polar_impl.default <- function(x, interpolate, supplement, add_origin) {
    stop("with_polar() can't work with object of class `", class(x), ".\n",
        call. = FALSE)
}


with_polar_impl.list <- function(x, interpolate, supplement, add_origin) {

    l <- list()

    # for some reason lapply() version of this doesn't work
    for (i in seq_along(x)) {
        l[[i]] <- with_polar_impl(x[[i]], interpolate = interpolate, supplement = supplement, add_origin = add_origin)
    }

    if (length(l) == 1) return(l[[1]])
    l
}






with_polar_impl.Layer <- function(x, interpolate, supplement, add_origin) {

    parent_stat <- x$stat

    if (inherits(parent_stat, "StatIdentity")) {
        if (interpolate) {
            x$stat <- ggplot2::ggproto("StatPolarInterpolation", StatPolar,
                                       compute_group = compute_group_interpolate(supplement = supplement,
                                                                                 add_origin = add_origin)
                                       )
        } else x$stat <- StatPolar
        return(x)
    }


    if (inherits(parent_stat, "StatPolar")) {
        if (interpolate) {
            x$stat <- ggplot2::ggproto("StatPolarInterpolation", StatPolar,
                                       compute_group = compute_group_interpolate(supplement = supplement,
                                                                                 add_origin = add_origin)
                                       )
        }
        return(x)
    }


    if ((!aes_require_y(parent_stat)) || (!aes_require_y(parent_stat)))
        stop("with_polar() only can work with the layer that has a stat, of which
        the required_aes should include both of x and y!\n", call. = FALSE)

    ggproto(NULL, x, stat = polarize_stat(parent_stat, interpolate = interpolate,
                                          supplement = supplement, add_origin = add_origin))
}


polarize_stat <- function(parent_stat, interpolate, supplement, add_origin) {

    ggproto('StatPolarized', parent_stat,
            required_aes = drop_xy(parent_stat$required_aes),
            #default_aes = aes_add_pole(parent_stat$default_aes),

            compute_group = function(data, scales, ...) {

                if (is.null(data$p_radius) || is.null(data$p_theta))
                    stop("with_polar() requires the following missing aesthetics: p_radius, p_theta")

                if (interpolate) {
                    data <- polar_interpolate(data, supplement = supplement, add_origin = add_origin)
                }

                data <- polar_compute_group(data, "with_polar()")

                parent_stat$compute_group(data, scales, ...)
            },

            parameters = function(self, extra = FALSE) {
                # make sure we extract parameters of wrapped geom correctly
                parent_stat$parameters(extra)
            })
}






compute_group_interpolate <- function(supplement, add_origin) {

    function(data, scales) {
        data <- polar_interpolate(data, supplement = supplement, add_origin = add_origin)
        polar_compute_group(data, "StatPolar")
    }
}



# mainly for geom_path(), geom_polygon()
# not for point     ! information of last point      ! single point

ggplot(data.frame(x = 2, y = 1:3 * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_polygon(fill = "green"), geom_path(colour = "yellow", size = 3),
               interpolate = T, supplement = F, add_origin = F) +
    geom_point(stat = "polar", colour = "red", size = 10) +
    coord_equal()


ggplot(data.frame(x = 1, y = 1:4 * 22.5, z = c("a", "a", "b", "b")),
       aes(p_radius = x, p_theta = y, colour = z)) +
    with_polar(geom_polygon(size = 3), geom_path(size = 6),
               interpolate = T, supplement = F, add_origin = T) +
    geom_point(stat = "polar", size = 10) +
    coord_equal()

ggplot(data.frame(x = 1, y = 1:4 * 22.5, z = c("a", "a", "b", "b")),
       aes(p_radius = x, p_theta = y, colour = z)) +
    with_polar(geom_polygon(size = 3), geom_path(size = 6),
               interpolate = T, supplement = T, add_origin = F) +
    geom_point(stat = "polar", size = 10) +
    coord_equal()


ggplot(data.frame(x = c(1,1,2,2), y = c(1,2,2,1) * 22.5),
       aes(p_radius = x, p_theta = y)) +
    with_polar(geom_polygon(size = 3), geom_path(size = 6),
               interpolate = T, supplement = T, add_origin = F) +
    geom_point(stat = "polar", size = 10) +
    coord_equal()


ggplot(data.frame(x = 2, y = 1:3 * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_point(stat = "polar", size = 1),
               interpolate = T, supplement = F, add_origin = F) +
    coord_equal()


ggplot(data.frame(x = 2, y = c(1,2,3) * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_smooth(),
               geom_point(stat = "polar", size = 2),
               interpolate = T, supplement = F, add_origin = F) +
    with_polar(geom_smooth(size = 6)) +
    geom_point(stat = "polar", size = 6) +
    coord_equal()



# work with StatPolar

ggplot(data.frame(x = 1, y = c(0,3) * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_path(stat = "polar"), interpolate = T)

ggplot(data.frame(x = 1, y = c(0,3) * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_path(), interpolate = T)


# work with Stat other than identity and StatPolar
# work with attention!

ggplot(data.frame(x = 10, y = c(1,2,3) * 30), aes(p_radius = x, p_theta = y)) +
    with_polar(geom_smooth(), geom_point(size = 6)) +
    with_polar(geom_smooth(),
               interpolate = T, supplement = F, add_origin = F) +
    with_polar(geom_point(stat = "polar", size = 1, colour = "red"),
               interpolate = T, supplement = F, add_origin = F)
