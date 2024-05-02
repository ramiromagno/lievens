library(tidyverse)

path <- here::here("data-raw/")

series <-
  tibble::tibble(sample = paste0("S", 1:5),
                 copies = c(100000L, 20000L, 4000L, 800L, 160L),
                 dilution = as.integer(100000L / copies))

isopropanol_conc <-
  tibble::tibble(sample = paste0("S", 1:5),
                 inhibitor_conc = c(2.5, 0.5, 0.1, 0.02, 0.004))

# See section PCR reactions of original paper.
# ng / 25 uL
tannic_acid_conc <-
  tibble::tibble(sample = paste0("S", 1:5),
                 inhibitor_conc = c(5, 1, 0.2, 0.04, 0.08) / 25)

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
                   inhibitor_conc = 0,
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
  dplyr::left_join(isopropanol_conc, by = "sample") |>
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
                   inhibitor_conc,
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
  dplyr::left_join(tannic_acid_conc, by = "sample") |>
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
                   inhibitor_conc,
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
    replicate = factor(replicate, levels = 1:18)
  ) |>
  dplyr::arrange(plate, sample, replicate, copies, cycle)

usethis::use_data(lievens, overwrite = TRUE)
