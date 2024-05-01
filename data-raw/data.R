library(tidyverse)

path <- here::here("data-raw/")

series <-
  tibble::tibble(sample = paste0("S", 1:5),
                 copies = c(100000L, 20000L, 4000L, 800L, 160L),
                 dilution = as.integer(100000L / copies))

wells <-
  tidyr::expand_grid(x = LETTERS[1:8], y = 1:12) |>
  dplyr::mutate(well = paste0(x, y)) |>
  dplyr::pull(well)

file1_raw_data <- readr::read_csv(file.path(path, "file1-dataset soy.csv"), col_types = "id")
file2_raw_data <- readr::read_csv(file.path(path, "file2-dataset soy+Isopropanol.csv"), col_types = "id")
file3_raw_data <- readr::read_csv(file.path(path, "file3-dataset soy+Tannic Acid.csv"), col_types = "id")

file1_data <-
  file1_raw_data |>
  dplyr::rename(cycle = 1L) |>
  tidyr::pivot_longer(cols = -1L,
                      names_to = "reaction",
                      values_to = "fluor") |>
  dplyr::mutate(sample = stringr::str_extract(reaction, "S\\d+")) |>
  dplyr::mutate(replicate = stringr::str_extract(reaction, "\\d+$")) |>
  dplyr::left_join(series, by = "sample") |>
  dplyr::mutate(
    sample_type = "std",
    plate = "soy",
    well = NA_character_,
    target = "Le1",
    dye = "SYBR"
  ) |>
  dplyr::transmute(plate,
                   well,
                   target,
                   dye,
                   inhibitor = "none",
                   sample,
                   sample_type,
                   replicate,
                   copies,
                   dilution,
                   cycle,
                   fluor) |>
  dplyr::arrange(plate, sample, replicate, copies, cycle)

file2_data <-
  file2_raw_data |>
  dplyr::rename(cycle = 1L) |>
  tidyr::pivot_longer(cols = -1L,
                      names_to = "reaction",
                      values_to = "fluor") |>
  dplyr::mutate(sample = stringr::str_extract(reaction, "S\\d+")) |>
  dplyr::mutate(replicate = stringr::str_extract(reaction, "\\d+$")) |>
  dplyr::left_join(series, by = "sample") |>
  dplyr::mutate(
    sample_type = "std",
    plate = "soy+isopropanol",
    well = NA_character_,
    target = "Le1",
    dye = "SYBR"
  ) |>
  dplyr::transmute(plate,
                   well,
                   target,
                   dye,
                   inhibitor = "isopropanol",
                   sample,
                   sample_type,
                   replicate,
                   copies,
                   dilution,
                   cycle,
                   fluor) |>
  dplyr::arrange(plate, sample, replicate, copies, cycle)

file3_data <-
  file3_raw_data |>
  dplyr::rename(cycle = 1L) |>
  tidyr::pivot_longer(cols = -1L,
                      names_to = "reaction",
                      values_to = "fluor") |>
  dplyr::mutate(sample = stringr::str_extract(reaction, "S\\d+")) |>
  dplyr::mutate(replicate = stringr::str_extract(reaction, "\\d+$")) |>
  dplyr::left_join(series, by = "sample") |>
  dplyr::mutate(
    sample_type = "std",
    plate = "soy+tannic acid",
    well = NA_character_,
    target = "Le1",
    dye = "SYBR"
  ) |>
  dplyr::transmute(plate,
                   well,
                   target,
                   dye,
                   inhibitor = "tannic acid",
                   sample,
                   sample_type,
                   replicate,
                   copies,
                   dilution,
                   cycle,
                   fluor) |>
  dplyr::arrange(plate, sample, replicate, copies, cycle)

lievens <-
  dplyr::bind_rows(file1_data,
                   file2_data,
                   file3_data) |>
  dplyr::mutate(
    plate = factor(plate, levels = c("soy", "soy+isopropanol", "soy+tannic acid")),
    well = factor(well, levels = wells),
    target = as.factor(target),
    dye = as.factor(dye),
    inhibitor = factor(inhibitor, levels = c("none", "isopropanol", "tannic acid")),
    sample = as.factor(sample),
    sample_type = as.factor(sample_type),
    replicate = as.factor(replicate)
  )

usethis::use_data(lievens, overwrite = TRUE)
