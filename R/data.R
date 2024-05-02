#' qPCR data sets by Lievens et al. (2012)
#'
#' @description
#' One single tabular tidy data set in long format, encompassing three data sets
#' of five-point, five-fold dilution series: (i) without any inhibitor, (ii)
#' with isopropanol inhibition and (iii) with tannic acid inhibition. The target
#' amplicon consisted of a sequence within the soybean Lectin endogene. Please read
#' the Methods section of Lievens et al. (2012) for more experimental details.
#'
#' Each data set consists of a five-point, five-fold dilution series spanning an
#' amplicon copy number range from \eqn{100,000} down to \eqn{160}. Each
#' concentration is replicated 18 times. Each reaction has been amplified
#' through 60 cycles.
#'
#' ### Dilution series
#'
#' ```{r}
#' dplyr::filter(lievens, inhibitor == "none")
#' ```
#'
#' ### Isopropanol inhibition
#'
#' A series of reactions subjected to inhibition by isopropanol with
#' concentrations: 2.5, 0.5, 0.1, 0.02, and 0.004 % (v/v). Because samples have
#' been co-diluted, the initial copy numbers of the target amplicon also follow
#' the same five-fold progression in tandem: \eqn{100,000}, \eqn{20,000},
#' \eqn{4,000}, \eqn{800} and \eqn{160} copies.
#'
#' ```{r}
#' dplyr::filter(lievens, inhibitor == "isopropanol")
#' ```
#'
#' ### Tannic acid inhibition
#'
#' A series of reactions subjected to inhibition by tannic acid with
#' concentrations: 0.2, 0.04, 0.008, 0.0016 and 0.0032 ul/mL. Because samples
#' have been co-diluted, the initial copy numbers of the target amplicon also
#' follow the same five-fold progression in tandem: 100,000, 20,000, 4,000, 800
#' and 160.
#'
#' ```{r}
#' dplyr::filter(lievens, inhibitor == "tannic acid")
#' ```
#'
#' @format A [tibble][tibble::tibble-package] providing amplification curve data
#' in long format. Each row is for an amplification curve point.
#'
#' \describe{
#' \item{`plate`}{Plate identifier. There is one identifier for each of the four
#' data sets.}
#' \item{`well`}{Well identifier, i.e. the position within a PCR plate. This
#' information was not available from the original publication, thus all values
#' are `NA`.}
#' \item{`target`}{Target identifier. In all data sets the target is an amplicon
#' consisting of soybean Lectin endogene `"Le1"`.}
#' \item{`dye`}{Type of fluorescence dye, in this data set it is always SYBR
#' Green I master mix (Roche) (`"SYBR"`).}
#' \item{`inhibitor`}{Name of the molecule used as PCR inhibitor. In the case of
#' the dilution series the value is `"none"`.}
#' \item{`inhibitor_conc`}{Inhibitor concentration. Units are % (v/v) for
#' isopropanol, and ug/mL for tannic acid.}
#' \item{`sample`}{Name of the biological sample. Samples have a simple
#' consecutive identifier: S1, S2, ..., S5.}
#' \item{`sample_type`}{Sample type. All reactions are standard curves, i.e.
#' `"std"`.}
#' \item{`replicate`}{Replicate identifier.}
#' \item{`copies`}{Standard copy number of the amplicon.}
#' \item{`dilution`}{Dilution factor. Higher number means greater dilution, e.g.
#' `5` means a 1:5 (five-fold) dilution relative to most concentrated standard.}
#' \item{`cycle`}{PCR cycle.}
#' \item{`fluor`}{Raw fluorescence values.}
#' }
#'
#' @examples
#' lievens
#'
#' @source \doi{10.1093/nar/gkr775}
#' @name lievens
#' @keywords datasets
NULL
