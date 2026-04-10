library(GGIR) 
GGIR(
  datadir = "C:/Users/apark2/Documents/rStuff/actiInputRaw", 
  outputdir = "C:/Users/apark2/Documents/rStuff/actiOutput",
  
  #thresholds for older adults based on two papers looking at enmo of hip worn actigraph
  #additional paper Skjødt et al, 2025 has other thresholds but age is much higher (75+)
  threshold.lig = 15, #light threshold for older adults from Sanders et al, 2019
  threshold.mod = 69, #moderate threshold for older adults from Sanders et al, 2019
  threshold.vig = 230, #vigorous threshold for older adults from Bamman et al, 2021
  
  #following code taken from https://wadpac.github.io/GGIR/articles/Cookbook.html 
  #accelerometer was not worn at night and removes nonwear from data
  HASPT.algo = "NotWorn",
  HASIB.algo = "NotWorn",
  
  windowsizes = c(5,900,5400), # set nonwear time (default = c(5,900,3600)) from 60 min -> 90 min for older adults
  includedaycrit = 10, # Number of valid hours necessary for a day to be included in the analysis. Default : 16
  do.imp = FALSE, # Do not impute nonwear because sensor was never worn 24/7
  HASPT.ignore.invalid = NA, # Treat nonwear as potential part of guider window
  ignorenonwear = FALSE, # Consider nonwear as potential sleep
  
  overwrite = TRUE # Whether to overwrite existing output files.
)

#Sanders, G. J., Boddy, L. M., Sparks, S. A., Curry, W. B., Roe, B., Kaehne, A., & Fairclough, S. J. (2019). Evaluation of wrist and hip sedentary behaviour and moderate-to-vigorous physical activity raw acceleration cutpoints in older adults. Journal of Sports Sciences, 37(11), 1270–1279. https://doi.org/10.1080/02640414.2018.1555904
#Bammann, K., Thomson, N. K., Albrecht, B. M., Buchan, D. S., & Easton, C. (2021). Generation and validation of ActiGraph GT3X+ accelerometer cut-points for assessing physical activity intensity in older adults. The OUTDOOR ACTIVE validation study. PLOS ONE, 16(6), e0252615. https://doi.org/10.1371/journal.pone.0252615
#Skjødt, M., Brønd, J. C., Tully, M. A., Tsai, L.-T., Koster, A., Visser, M., & Caserotti, P. (2025). Moderate and Vigorous Physical Activity Intensity Cut-Points for Hip-, Wrist-, Thigh-, and Lower Back Worn Accelerometer in Very Old Adults. Scandinavian Journal of Medicine & Science in Sports, 35(1), e70009. https://doi.org/10.1111/sms.70009

#look at rows AP to AT of part5 person summary WW for minutes worn, part 5 day summary for valid hours