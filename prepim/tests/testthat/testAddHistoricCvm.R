context("Calculating historic CVM")
suppressWarnings(library(tibble))
# Redirect all the noisy logger output to a file
flog.appender(appender.file("unit_tests.log"))

# --- Test datasets ------------------------------------------------------------

historicCpIn <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                        "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                        "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                        "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                        "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                        "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                        "2013", "2014", "2015", "2016"),
                             Value = c(72, 78, 82, 85, 94, 101, 102, 122, 139, 138, 171, 188, 193, 253, 293, 305,
                                       325, 446, 491, 511, 544, 520, 577, 581, 724, 837, 808, 828, 970,
                                       1040, 1067, 1112, 970, 1241, 1437, 1689, 1644, 1692, 1882, 1878,
                                       1657, 1519, 1540, 1598, 1278, 1401, 1291, 1511, 1488, 1291, NA,
                                       NA, NA, NA, NA, NA, NA)),
                          row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

historicDeflatorIn <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                              "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                              "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                              "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                              "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                              "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                              "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                              "2013", "2014", "2015", "2016"),
                                   Value = c(9.7, 10, 10.2,
                                             10.8, 11, 11.2, 11.6, 11.6, 12.1, 12.6, 13.5, 15, 16.8, 20.2,
                                             26.2, 33.1, 37.1, 39.1, 42.7, 51.1, 65.7, 75.3, 74.3, 74, 74.5,
                                             76.3, 78, 79.8, 87.9, 98.2, 101.1, 96, 88.1, 83.7, 84.1, 86.4,
                                             86.4, 86.4, 86.6, 90.9, 91.5, 93, 95, 97, 99.9, 100, 100.1, 99.9,
                                             99.7, 99.5, NA, NA, NA, NA, NA, NA, NA)),
                              row.names = c(NA,  -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

baCpIn <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                    "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                    "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                    "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                    "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                    "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                    "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                    "2013", "2014", "2015", "2016"),
                         Value = c(NA, NA, NA,
                                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                   NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                   NA, NA, 1992.89129292, 1978.80363278, 2027.13260731, 1874.00834359,
                                   1859.27058475, 1588.58765056, 1728.05060552, 1646.67390284, 1791.42060513,
                                   1566.1914848, 1814.55850175, 1991.26090244, 1619.98093158, 1969.6064445,
                                   1915.98504997, 1967.62383198, 2089.20463208, 2175.82974052, 2003.57976008,
                                   1781.7164519)),
                    row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

baCvmIn <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                     "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                     "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                     "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                     "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                     "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                     "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                     "2013", "2014", "2015", "2016"),
                          Value = c(NA, NA, NA,
                                    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                    NA, NA, 1871.910561, 1871.870481, 1887.201666, 1814.964482, 1783.93963,
                                    1524.419498, 1662.478637, 1590.092858, 1695.431656, 1460.135497,
                                    1942.656623, 2074.017376, 1505.301762, 1939.310194, 1905.291776,
                                    1982.35064, 2089.204582, 2241.288293, 1972.02823, 1635.479047)),
                     row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))


impliedDeflator <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                             "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                             "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                             "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                             "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                             "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                             "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                             "2013", "2014", "2015", "2016"),
                                  Value = c(NA, NA, NA,
                                            NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                            NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                                            NA, NA, 1.06462954718059, 1.0571263625691, 1.0741473176031, 1.03253168983502,
                                            1.04222730045523, 1.04209350027613, 1.03944229240643, 1.03558348467219,
                                            1.05661623032123, 1.07263434661913, 0.934060337924166, 0.960098466619597,
                                            1.07618350849974, 1.01562217874878, 1.00561240756124, 0.992571037775638,
                                            1.00000002397085, 0.970794229067077, 1.01599953266389, 1.08941563951446)),
                             row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

referencedDeflator <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                                "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                                "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                                "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                                "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                                "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                                "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                                "2013", "2014", "2015", "2016"),
                                     Value = c(0.119524382033006,
                                               0.123221012405161, 0.125685432653264, 0.133078693397574, 0.135543113645677,
                                               0.138007533893781, 0.142936374389987, 0.142936374389987, 0.149097425010245,
                                               0.155258475630503, 0.166348366746968, 0.184831518607742, 0.207011300840671,
                                               0.248906445058426, 0.322839052501522, 0.407861551061084, 0.457149956023148,
                                               0.48179415850418, 0.526153722970038, 0.629659373390374, 0.809562051501909,
                                               0.927854223410864, 0.915532122170348, 0.911835491798193, 0.917996542418451,
                                               0.94017632465138, 0.961123896760258, 0.983303678993187, 1.08311269904137,
                                               1.21003034181868, 1.24576443541618, 1.18292171908955, 1.08557711928947,
                                               1.0313598738312, 1.03628871432741, 1.06462954718059, 1.06462954718059,
                                               1.06462954718059, 1.0670939674287, 1.12007900276292, 1.12747226350723,
                                               1.145955415368, 1.17059961784903, 1.19524382033006, 1.23097791392756,
                                               1.23221012405161, 1.23344233417566, 1.23097791392756, 1.22851349367946,
                                               1.22604907343135, NA, NA, NA, NA, NA, NA, NA)),
                                row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

finalDeflator <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                           "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                           "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                           "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                           "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                           "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                           "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                           "2013", "2014", "2015", "2016"),
                                Value = c(0.119524382033006,
                                          0.123221012405161, 0.125685432653264, 0.133078693397574, 0.135543113645677,
                                          0.138007533893781, 0.142936374389987, 0.142936374389987, 0.149097425010245,
                                          0.155258475630503, 0.166348366746968, 0.184831518607742, 0.207011300840671,
                                          0.248906445058426, 0.322839052501522, 0.407861551061084, 0.457149956023148,
                                          0.48179415850418, 0.526153722970038, 0.629659373390374, 0.809562051501909,
                                          0.927854223410864, 0.915532122170348, 0.911835491798193, 0.917996542418451,
                                          0.94017632465138, 0.961123896760258, 0.983303678993187, 1.08311269904137,
                                          1.21003034181868, 1.24576443541618, 1.18292171908955, 1.08557711928947,
                                          1.0313598738312, 1.03628871432741, 1.06462954718059, 1.06462954718059,
                                          1.06462954718059, 1.0571263625691, 1.0741473176031, 1.03253168983502,
                                          1.04222730045523, 1.04209350027613, 1.03944229240643, 1.03558348467219,
                                          1.05661623032123, 1.07263434661913, 0.934060337924166, 0.960098466619597,
                                          1.07618350849974, 1.01562217874878, 1.00561240756124, 0.992571037775638,
                                          1.00000002397085, 0.970794229067077, 1.01599953266389, 1.08941563951446)),
                           row.names = c(NA, -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

historicCvmOut2 <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                                            "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                                            "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                                            "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                                            "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                                            "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                            "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                                            "2013", "2014", "2015", "2016"),
                                 Value = c(602.38755286028, 633.008920130678, 652.422466700799, 638.719826817517, 693.506276133843,
                                           731.84410408881, 713.604220306467, 853.52661644499, 932.276328651878,
                                           888.840364041856, 1027.96320363102, 1017.14253832964, 932.316251413468,
                                           1016.44615887955, 907.572977090863, 747.802775737303, 710.926460164733,
                                           925.706532816193, 933.187352981934, 811.549897603434, 671.968256158703,
                                           560.432864214854, 630.234577277498, 637.176338523777, 788.673994449511,
                                           890.258537737974, 840.682458030223, 842.059292250179, 895.567008731889,
                                           859.48257994661, 856.502216362872, 940.04529805731, 893.533939472566,
                                           1203.26573826268, 1386.67919483488, 1586.46733455116, 1544.19911071764,
                                           1589.28521614006, 1780.29804821652, 1748.36353377547, 1604.79336015804,
                                           1457.45558510751, 1477.79445855092, 1537.36288360986, 1234.08688813201,
                                           1325.93079662809, 1203.5788375313, 1617.66851524604, 1549.84103374218,
                                           1199.60953666696, NA, NA, NA, NA, NA, NA, NA)),
                            row.names = c(NA,  -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl", "data.frame"))

historicCvmOut <- structure(list(Period = c("1960", "1961", "1962", "1963", "1964",
                          "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972",
                          "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                          "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988",
                          "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996",
                          "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004",
                          "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
                          "2013", "2014", "2015", "2016"), Value = c(602.38755286028, 633.008920130678,
                                                                     652.422466700799, 638.719826817517, 693.506276133843, 731.84410408881,
                                                                     713.604220306467, 853.52661644499, 932.276328651878, 888.840364041856,
                                                                     1027.96320363102, 1017.14253832964, 932.316251413468, 1016.44615887955,
                                                                     907.572977090863, 747.802775737303, 710.926460164733, 925.706532816193,
                                                                     933.187352981934, 811.549897603434, 671.968256158703, 560.432864214854,
                                                                     630.234577277498, 637.176338523777, 788.673994449511, 890.258537737974,
                                                                     840.682458030223, 842.059292250179, 895.567008731889, 859.48257994661,
                                                                     856.502216362872, 940.04529805731, 893.533939472566, 1203.26573826268,
                                                                     1386.67919483488, 1586.46733455116, 1544.19911071764, 1871.910561,
                                                                     1871.870481, 1887.201666, 1814.964482, 1783.93963, 1524.419498,
                                                                     1662.478637, 1590.092858, 1695.431656, 1460.135497, 1942.656623,
                                                                     2074.017376, 1505.301762, 1939.310194, 1905.291776, 1982.35064,
                                                                     2089.204582, 2241.288293, 1972.02823, 1635.479047)), row.names = c(NA,
                                                                                                                                        -57L), .Names = c("Period", "Value"), class = c("tbl_df", "tbl",
                                                                                                                                                                                        "data.frame"))

# ------------------------------------------------------------------------------

# Test function for multiple series at once
test_that("addHistoricCvm can convert inputs to historic CVM.", {
  # Add key rows to test data (we need Sector/Industry/Asset codes)
  reqRows <- nrow(historicCpIn)
  keyCols <- data.frame(Sector = rep("S.14", reqRows),
                        Industry = rep("10", reqRows),
                        Asset = rep("TELECOMS", reqRows),
                        stringsAsFactors = FALSE)

  ref <- "1997"
  result <- addHistoricCvm(historicCp = cbind(historicCpIn, keyCols),
                                  historicDeflator = cbind(historicDeflatorIn, keyCols),
                                  baCp = cbind(baCpIn, keyCols),
                                  baCvm = cbind(baCvmIn, keyCols),
                                  linkPeriod = ref)
  expect_equal(result$Value, historicCvmOut$Value)
})


