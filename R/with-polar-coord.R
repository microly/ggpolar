# fail:
# try reset geom::setup_data()   geom::draw_panel()
# cannot handle geom_histogram() in geom
# can try to reset coord





# work with:
# ggplot() + with_polar(geom_sf())
# ggplot(tibble(x = 1:100), aes(x)) + with_polar(geom_histogram())













with_polar_coord <- function(...) {
  x <- list(...)
  with_polar_coord_impl(x)
}

with_polar_coord_impl <- function(x) {
  UseMethod("with_polar_coord_impl")
}

with_polar_coord_impl.default <- function(x) {
  stop("with_polar_coord() cannot handle object of class `", class(x), "`", call. = FALSE)
}

with_polar_coord_impl.list <- function(x) {
  l <- list()
  # for some reason lapply() version of this doesn't work
  for (i in seq_along(x)) {
    l[[i]] <- with_polar_coord_impl(x[[i]])
  }
  if (length(l) == 1) return(l[[1]])
  l
}

with_polar_coord_impl.Layer <- function(x, ...) {
  parent_geom <- x$geom
  ggproto(NULL, x,
    geom = ggproto('GeomPolarizedCoord', parent_geom,

      setup_data = function(data, params) {
        data <- polar_setup_data(data)
        parent_geom$setup_data(data, params)
      },

      parameters = function(self, extra = FALSE) {
        # make sure we extract parameters of wrapped geom correctly
        parent_geom$parameters(extra)
      }
    )
  )
}


polar_setup_data <- function(data) {

  print(data)

  theta <- xy_theta(data$x, data$y)
  radius <- xy_radius(data$x, data$y)

  theta <- theta + 90
  radius <- radius + 10

  data$x <- polar_x(radius, theta)
  data$y <- polar_y(radius, theta)

  data
}





