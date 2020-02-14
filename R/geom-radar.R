geom_radar_axis <- function(radius, theta = 0:7 *45, radius_start = 0,
                            mapping = NULL, data = NULL, ..., stat = "polar",
                            inherit.aes = FALSE) {

    # handle data
    if (!is.null(data)) warning("ignore param data!")

    if (length(radius) != 1 && length(radius) != length(theta) ) {
        stop("radius should be length one, or the same length of theta!")
    }
    radius_column <- purrr::map2(radius, radius_start, ~c(.x, .y)) %>% unlist()

    data_df <- data.frame(radius = radius_column,
                       theta = rep(theta, each = 2),
                       group = factor(rep(1:length(theta), each = 2)))

    # handle mapping
    mapping_add <- list(p_radius = sym("radius"),
                        p_theta = sym("theta"),
                        group = sym("group"))

    if (is.null(mapping)) {
        mapping_temp <- mapping_add
        class(mapping_temp) <- "uneval"
    } else {
        mapping <- unclass(mapping)

        if ("group" %in% names(mapping)) {
            warning("ignore aes group!")
            mapping$group <- NULL
        }

        mapping_temp <- c(mapping, mapping_add)
        class(mapping_temp) <- "uneval"
    }

    # handle stat
    if (stat != "polar") warning('other than "polar", ignore param stat!')

    # geom
    geom_path(
        mapping = mapping_temp,
        data = data_df,
        stat = "polar",
        ...,
        inherit.aes = inherit.aes
    )
}



#ggplot() + geom_radar_axis(radius = 1)


geom_radar_ring <- function(radius, polar_x = 0, polar_y = 0,
                            mapping = aes(), data = NULL,
                            ..., inherit.aes = FALSE) {

    # handle data
    if (!is.null(data)) warning("ignore param data!")

    data_sf <- st_point(x = c(pole_x, pole_y), dim = "XY") %>%
        st_sfc() %>% st_sf() %>%
        buffers(radius)


    # handle mapping
    # ignore geometry

    geom_sf(mapping = mapping, data = data_sf, inherit.aes = inherit.aes, ...)
}


# helper function
buffers <- function(x, dist) {

    dist_in <- dist

    purrr::map(dist, ~sf::st_buffer(x, .)) %>%
        do.call(rbind, .) %>%
        dplyr::mutate(dist = dist_in) %>%
        dplyr::arrange(desc(dist)) %>%
        dplyr::mutate(ring = factor(1:n()))
}



