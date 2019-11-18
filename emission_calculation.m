close all
clear 
clc 

% tot distance travelled
tot_dist=1.78*10^8; %[km] demand based: 3.4837*10^6km; production based: 1.78*10^8 km
% tot biomass
tot_bio=1.6262*10^10; %[kg] demand based: 2.4412*10^8 kg; production based: 1.6262*10^10
% tot SNG volume
tot_SNG=2.58*10^9; %[m3] demand based: 5.7523*10^7 m3; production based: 2.58*10^9
tot_SNG_ft3=tot_SNG*35.3147; %[ft3]
n_SNG=2.58*10^9*10^3/22.4;
diesel=tot_dist/100*30*0.264172; %[gallon]

% emissions from driving and burning SNG
% BSIII standards, and 3 is kwh/km conversion factor 
CO=5.45*3*tot_dist; %g
NMHC=0.78*3*tot_dist; %g
NOx=5*3*tot_dist;
TPM=0.16*3*tot_dist;
CO2_SNG=53.12*10^3*(tot_SNG/28.3168); %g
CO2_NG=tot_SNG_ft3*1090*117*453.592; 
CO2_trans=diesel*22.38*453.592; %[g]
PM25=65.3*10^-3*tot_dist;
PM10=23*10^-3*tot_dist;

% emissions from burning
CO_b=34.7*tot_bio;%g
NMHC_b=4*tot_bio; %g
NOx_b=3.1*tot_bio;
TPM_b=13*tot_bio;
CO2_b=1460*tot_bio;
CO2_fossil=CO2_SNG*161.3/117; 
PM25_b=12.25*tot_bio;
PM10_b=3.7*tot_bio;




