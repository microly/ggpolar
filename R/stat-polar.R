#' Plot data in polar coordinates on a cartesian layer
#'
#' Data in polar coordinates can be drawn directly on this layer through two new aesthetics:
#' p_theta and p_radius. Data can also be translated and/or rotated through another three
#' new aesthetics: translate_x, translate_y and rotate.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#'
#' @section Details:
#' For the aesthetics p_theta and rotate, angles are in degrees, not radians.
#' For example, east is 0 and north is 90.
#'
#' @section Aesthetics:
#' stat_polar() understands the following aesthetics (required aesthetics are in bold):
#' \itemize{
#'   \item \strong{p_theta}
#'   \item \strong{p_radius}
#'   \item translate_x
#'   \item translate_y
#'   \item rotate
#'   \item group
#'   }
#' Learn more about setting these aesthetics in vignette("ggplot2-specs").
#'
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' polar_data <- data.frame(theta = c(0,120,240), radius = 1)
#' ggplot(polar_data) + stat_polar(aes(p_theta = theta, p_radius = radius))
#'
#' # I strongly recommend that use StatPolar rather than stat_polar().
#' # Because, with StatPolar, you can draw data in polar coordinates
#' # on the layers in ggplot2 and its extension packages only in two steps:
#' #   1.set stat to StatPolar (stat = "polar").
#' #   2.map the theta and radius to two new aesthetics: p_theta and p_radius.
#'
#' ggplot(polar_data, aes(p_theta = theta, p_radius = radius)) +
#'   geom_polygon(stat = "polar") +
#'   geom_path(stat = "polar", colour = "green", size = 3) +
#'   geom_point(stat = "polar", colour = "red", size = 6)
#'
#' # You can also translate and/or rotate the data through translate_x, translate_y
#' # and rotate.
#' ggplot(polar_data, aes(p_theta = theta, p_radius = radius)) +
#'   geom_polygon(aes(colour = "original"), stat = "polar", fill = NA) +
#'   geom_polygon(aes(colour = "rotate", rotate = 60),
#'                stat = "polar", fill = NA) +
#'   geom_polygon(aes(colour = "translate",
#'                translate_x = 2, translate_y = 2),
#'                stat = "polar", fill = NA) +
#'   geom_polygon(aes(colour = "translate + rotate",
#'                translate_x = 2, translate_y = 2, rotate = 60),
#'                stat = "polar", fill = NA) +
#'   scale_color_discrete(name = NULL) +
#'   scale_size(guide = NULL) +
#'   coord_equal()
#'
#' # ggpolar can also translate and rotate data in cartesian coordinates
#' # by providing 2 helper functions, xy_theta() and xy_radius():
#'
#' # cartesian coordinates
#' cartiesian_data <- data.frame(x = c(1,-1,-1,1), y = c(1,1,-1,-1))
#'
#' ggplot(cartiesian_data, aes(p_theta = xy_theta(x,y),
#'                             p_radius = xy_radius(x,y))) +
#'  geom_polygon(aes(fill = "original"), stat = "polar") +
#'  geom_polygon(aes(rotate = 45, translate_x = 2, translate_y = 2),
#'               stat = "polar") +
#'  scale_fill_discrete(name = NULL)
#'
#' # For more examples, see the vignette 'The complete guide for ggpolar'.
stat_polar <- function(mapping = NULL, data = NULL,
                          geom = "point", position = "identity",
                          ...,
                          show.legend = NA,
                          inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatPolar,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
    na.rm = FALSE,
    ...
    )
  )
}


#' @rdname stat_polar
#' @format NULL
#' @usage NULL
#' @export
StatPolar <- ggplot2::ggproto("StatPolar", ggplot2::Stat,
  required_aes = c("p_radius", "p_theta"),
  default_aes = ggplot2::aes(x = ggplot2::stat(x), y = ggplot2::stat(y),
                             translate_x = 0, translate_y = 0, rotate = 0),

  compute_group = function(data, scales) {
    polar_compute_group(data, "StatPolar")
    }
)
