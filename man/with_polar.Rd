% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/with-polar.R
\name{with_polar}
\alias{with_polar}
\title{with_polar}
\usage{
with_polar(..., interpolate = FALSE, supplement = FALSE, add_origin = FALSE)
}
\arguments{
\item{...}{}
}
\value{

}
\description{
with_polar
}
\examples{
library(ggplot2)

ggplot(data.frame(x = 1, y = 0:3 * 30)) +
  with_polar(geom_point(aes(p_radius = x, p_theta = y, polar_x = 1,
             polar_y = 1, polar_theta0 = 90))) +
  coord_equal()


# 'interpolate' mainly for geom_path(), geom_polygon()
# not for point     ! information of last point      ! single point

ggplot(data.frame(x = 2, y = 1:3 * 30), aes(p_radius = x, p_theta = y)) +
  with_polar(geom_polygon(fill = "green"), geom_path(colour = "yellow", size = 3),
             interpolate = T, supplement = F, add_origin = F) +
  geom_point(stat = "polar", colour = "red", size = 10) +
  coord_equal()


df <- tibble::tibble(x = c(0,1,1,0), y = c(0,0,1,1))
ggplot(df, aes(p_radius = xy_radius(x, y), p_theta = xy_theta(x, y))) +
  with_polar(geom_point(), ggforce::geom_shape(expand = unit(-0.1, 'npc'), radius = unit(0.1, 'npc')))


# do not work:
# ggplot() + with_polar(geom_sf())
# ggplot(tibble(x = 1:100), aes(x)) + with_polar(geom_histogram())
}
