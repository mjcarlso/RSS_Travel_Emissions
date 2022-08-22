
######### Air
# Air miles estimated from https://www.flightconnections.com/
# Assuming fuel type to be 100% Jet fuel rather than aviation gas
# https://afdc.energy.gov/data/10311 51.4pmpGGE
# https://www.eia.gov/totalenergy/data/monthly/archive/00352105.pdf Appendix A3
# https://afdc.energy.gov/fuels/equivalency_methodology.html 
# Tier 1 emissions calculations for air and road
# 2006 IPCC GL Vol. 2, Ch. 3: emission (kg) = fuel consumption (TJ) * emission factor (kg/TJ)
# CO2 EF = 71500 kg/TJ
# CH4 EF = .5 kg/TJ
# N2O EF = 2 kg/TJ
# NOx EF = 250 kg/TJ


######### Road
# Driving miles estimated from Google Maps
# Assumes everyone flying out of Denver is driving from Fort Collins to Denver Airport
# 2016 average fuel efficiency of light duty vehicles in the US https://www.bts.gov/content/average-fuel-efficiency-us-passenger-cars-and-light-trucks
#     9.4 kmpl - 22.1 mpg
# 2006 IPCC GL Vol. 2, Ch. 3: emissions = fuel consumption * emission factor
# Assuming fuel type to be 100% motor gasoline
# CO2 EF = 69300 kg/TJ
# Assuming vehicles to be low mileage light duty vehicle vintage 1995 or later
# CH4 EF = 3.8 kg/TJ
# N2O EF = 5.7 kg/TJ

# Uncertainty analysis not included

Travel<-read.csv("RSS_Travel_Data_Sheet.csv")
Travel$FY<-as.character(Travel$FY)

# Air miles to gallons
Travel$gfuelA<-Travel$Air_Miles_Used/51.4
# convert fuel to TJ (kerosene type jet fuel)
Travel$TJfuelA<-Travel$gfuelA/7.0323488045007E-9/1.0E12

# Road miles to gallons
Travel$gfuelR<-Travel$Car_Miles_Used/22.1
# convert fuel to TJ
Travel$TJfuelR<-Travel$gfuelR/7.5895567698846E-9/1.0E12


### CO2
#Air
Travel$co2A<-Travel$TJfuelA*71500

#Road
Travel$co2R<-Travel$TJfuelR*69300


### N2O
#Air
Travel$n2oA<-Travel$TJfuelA*2
  
#Road
Travel$n2oR<-Travel$TJfuelR*5.7


### CH4
#Air
Travel$ch4A<-Travel$TJfuelA*.5
  
#Road
Travel$ch4R<-Travel$TJfuelR*3.8

### NOx
#Air
Travel$noxA<-Travel$TJfuelA*250


#Total CO2 equivalents (kg)

Travel$Total_CO2e_by_Trip<-Travel$co2A+Travel$co2R+Travel$n2oA+Travel$n2oR+Travel$ch4A+Travel$ch4R+Travel$noxA

library(dplyr)

CO2e_by_FY<-Travel%>%
  group_by(FY)%>%
  summarise(CO2e = sum(Total_CO2e_by_Trip))
CO2e_by_FY



















