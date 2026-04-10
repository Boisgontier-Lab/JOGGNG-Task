JOGGNGStudyPartInfo_260407.xlsx contains the anonymized study participant information.
JOGGNG_Accelerometer_Data.csv contains the anonymized accelerometer data from participants.
run the extractPA.m file to produce figures for the scripts.

extractJOGGNG.m pulls the reaction time, error rates, and maximum hand speed from participants who performed the JOGGNG Task. 
Due to file size limitations of .kinarm files (approximately 40mb per file), the extractJOGGNG.m script is not executable in the current state. However, the JOGGNGStudyPartInfo_260407.xlsx file includes the reaction time, error rates that are used in extractPA.m to produce figures.
For access to .kinarm files, please email kayne.park@uottawa.ca

The GGIR package was used to extrapolate wear time and acceleration used for identifying physical activity level (sedentary, light, moderate, vigorous) from raw .gt3x files.
The script ggirStartKP_260407.R was used to run this analysis with parameters set specifically for older adults who wore the accelerometers only 10h/day for minimum 4days/week.
The .gt3x were too large to upload onto github. 
For acccess to .gt3x files, please email kayne.park@uottawa.ca
