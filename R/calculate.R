#' polar_x
#'
#' theta, 0-360, east is 0, anticlockwise
#'
#' @param radius a numeric
#' @param theta a numeric
#'
#' @return x
#' @export
#'
#' @examples
polar_x <- function(radius, theta) {
    radius * cospi(theta/180)
}


#' pole_y
#'
#' @param radius a numeric
#' @param theta a numeric
#'
#' @return y
#' @export
#'
#' @examples
polar_y <- function(radius, theta) {
    radius * sinpi(theta/180)
}





polar_compute_group <- function(data, name) {

    if (tibble::has_name(data, "x")) warning(paste0(name, " ignoring aes x!"), call. = FALSE)
    if (tibble::has_name(data, "y")) warning(paste0(name, " ignoring aes y!"), call. = FALSE)

    if (!tibble::has_name(data, "polar_x")) data$polar_x <- 0
    if (!tibble::has_name(data, "polar_y")) data$polar_y <- 0
    if (!tibble::has_name(data, "polar_theta0")) data$polar_theta0 <- 0

    x = polar_x(data$p_radius, (data$p_theta + data$polar_theta0)) + data$polar_x
    y = polar_y(data$p_radius, (data$p_theta + data$polar_theta0)) + data$polar_y

    data$x <- x
    data$y <- y

    data
}




polar_interpolate <- function(data, supplement, add_origin, x0 = NULL, y0 = NULL) {
    #TODO:
    # 1.x0, y0 control how to interpolate

    data_rt <- data %>% dplyr::select(p_radius, p_theta)
    if (supplement) data_rt <- dplyr::bind_rows(head(data_rt, 1), tail(data_rt, 1))

    data_drop_rt <- data %>% dplyr::select(-p_radius, -p_theta)
    if (supplement) data_drop_rt <- dplyr::bind_rows(head(data_drop_rt, 1), tail(data_drop_rt, 1))

    data_rt_interpolation <- data_rt %>%
        dplyr::rename(p_radius0 = p_radius, p_theta0 = p_theta) %>%
        dplyr::mutate(p_radius1 = dplyr::lead(p_radius0), p_theta1 = dplyr::lead(p_theta0),
               supplement = supplement) %>%
        purrr::pmap(polar_interpolate_impl) %>%
        tibble::tibble(rt = .)

    res <- dplyr::bind_cols(data_rt_interpolation, data_drop_rt) %>% tidyr::unnest(rt)

    if (add_origin) {
        df_orgin <- dplyr::bind_cols(data.frame(p_radius = 0, p_theta = 0),
                                     head(data_drop_rt, 1))
        res <- dplyr::bind_rows(res, df_orgin)
    }

    res
}


polar_interpolate_impl <- function(p_radius0, p_theta0, p_radius1, p_theta1,
                                   supplement) {

    if (is.na(p_radius1) || is.na(p_theta1))
        return(NULL)

    if (supplement) p_theta0 <- p_theta0 + 360

    n <- abs(p_theta1 - p_theta0) + 1
    data.frame(p_radius = seq(p_radius0, p_radius1, length.out = n),
               p_theta = seq(p_theta0, p_theta1, length.out = n))
}

