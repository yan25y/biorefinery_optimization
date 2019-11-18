clear all 
close all 
clc 

%% total straw demand 

% population of proposed CGD regions
pop=[244044,834768,935316];
% SNG consumption per capita per month 
SNG_cons=2.38; %m3/month
% cold gas efficiency
CGE=0.648;
% LHV of SNG 
LHV_SNG=44; %[MJ/m3]
% LHV of straw 
LHV_straw=16; %[MJ/kg]
% total demand per year 
V_SNG=12*SNG_cons*sum(pop);% [m3/year]
V_SNG_h=V_SNG/(365*24);
mstraw=V_SNG*LHV_SNG/(CGE*LHV_straw); %[kg]
% tonage per hour 
mstraw_h=mstraw/(1000*365*24);
% plant scale 
Scale_tot=V_SNG*LHV_SNG/(365*24*60*60); %MW (MJ/s)
% amount of CO2 



%% Bathinda straw demand
V_SNG_1=12*SNG_cons*pop(1);% [m3/year]
mstraw1=V_SNG_1*LHV_SNG/(CGE*LHV_straw); %[kg]
% tonage per hour 
mstraw1_h=mstraw1/(1000*365*24);
Scale_1=V_SNG_1*LHV_SNG/(365*24*60*60);

%% Jalandhar straw demand 
V_SNG_2=12*SNG_cons*pop(2);% [m3/year]
mstraw2=V_SNG_2*LHV_SNG/(CGE*LHV_straw); %[kg]
% tonage per hour 
mstraw2_h=mstraw2/(1000*365*24);
Scale_2=V_SNG_2*LHV_SNG/(365*24*60*60);

%% Tarn taran 
V_SNG_3=12*SNG_cons*pop(3);% [m3/year]
mstraw3=V_SNG_3*LHV_SNG/(CGE*LHV_straw); %[kg]
% tonage per hour 
mstraw3_h=mstraw3/(1000*365*24);
Scale_3=V_SNG_3*LHV_SNG/(365*24*60*60);

%% 
Q=linspace(0,60,60);
Capex=8.71*Q.^0.6724*82231000;
Opex=0.73*Q.^0.6724*82231000;
plot(Q,Capex,Q,Opex)
xlabel("Plant Scale[t/h]")
ylabel("Cost[Rs]")
legend("CapEx","OpEx")

%% CO2 production during gasification 

% lower heating value MJ/m3
LHV_H2=10.3;
LHV_CO=12.6;
LHV_CO2=0;
LHV_CH4=35.9;
LHV_C2H4=59.5;
LHV_C3H6=87.5;
LHV_inert=0;

% gas fraction
f_H2=39.9/100;
f_CO=24/100;
f_CO2=19.9/100;
f_CH4=8.6/100;
f_C2H4=2/100;
f_C3H6=0.3/100;
f_inert=5.3/100; 

% solve for gas flow 
CGE_G=0.8;
LHV_pg=LHV_H2*f_H2+LHV_CO*f_CO+LHV_CO2*f_CO2+LHV_CH4*f_CH4+LHV_C2H4*f_C2H4+LHV_C3H6*f_C3H6+LHV_inert*f_inert;
syms vg 
eqn1=vg*LHV_pg/(LHV_straw*mstraw)==CGE_G;
gas=solve(eqn1,vg);
gas_tot=double(gas); % m3 
V_SYN=gas_tot*(0.421+0.246);%m3/year
V_HC=gas_tot*(0.13+2+0.19+0.001);
V_SYN_min=V_SYN/(365*24*60);%m3/min
rho_co2=1.98; %kg/m3
m_co2=gas_tot*f_CO2*rho_co2/1000; %t

%% CO2 emission and PM2.5 
% total biomass burned in Punjab state is 16.3 Mt according to the map
burned_tot=mstraw; %[kg]
co2_burning=burned_tot*1460; %[g]
TPM=burned_tot*13; %[g]
PM25=12.5*burned_tot;%[g]
PM10=3.7*burned_tot; %[g]

% BioSNG 
co2_SNG=53.12*10^3*(V_SNG/28.3168); %g
% for one plant for CGD regions
trans_d=3.4837*10^9;%[m]
PM10_SNG=65.3*10^-3*trans_d*10^-3; %[g]
PM25_SNG=23*10^-3*trans_d*10^-3;

%% cost breakdown 

c_grinding=2.47*0.133*1.14*mstraw_h*24/2140; %[$M]
c_drying=2.47*0.280*1.14*(mstraw_h*24/1100)^0.7; %[$M]
MW_bio=mstraw*LHV_straw/(365*24*60*60);%[MW]LHV
c_gasify=2.47*8.012*(MW_bio/100)^0.72; %[$M]
c_filter=2.47*1.935*(MW_bio/500)^0.7;
c_scrubbing=18.702*(V_SNG_h/135497)^0.65;
%energy needed to compress syngas gas
%initial pressure
P1=1*14.5038;%[psi]
%pressure after compression 
P2=16*14.5038;%[Psi]
%adiabatic compression coefficient
k=1.4;
%compression stages
N=6;
%volume flow rate
V=V_SYN_min*0.0283168; %[ft^3/min]
%compression horsepower
HP=144*N*P1*V*k/(33000*(k-1))*((P2/P1)^((k-1)/(N*k))-1);
%annual compression energy
MWe=HP*0.0007457;
c_compression=1.32*4.623*1.14*(MWe/5.44)^0.7;
c_olefin=2.47*0.003*1.14*(mstraw_h/65.77)^0.67;
c_HDS=2.47*0.003*1.14*(mstraw_h/65.77)^0.67;
co2_kgs=co2_SNG/(1000*365*24*60*60);
c_removal=2.47*16.109*1.14*(co2_kgs/12.62)^0.65;
V_SNG_s=V_SNG_h/(60*60);
c_ZnO=3*0.024*1.14*(V_SNG_s/8);
mstraw_s=mstraw_h*1000/(60*60); %[kg/s]
c_WGS=0.334*1.14*(mstraw_s/44.66)^0.54;
%production of hydrocarbons(need recalculation)
n_hc=7.0921e+04*876/(84000);%kmol/h
c_reformer=42.746*(n_hc/1277)^0.6;
%flow of gas into the first reactor
m_metha=V_SNG_s*0.9/0.65;
c_methanation=2.47*0.034*1.14*(m_metha/149.69)^0.67;
TIC=c_grinding+c_drying+c_gasify+c_filter+c_scrubbing+c_compression+c_olefin+c_HDS+c_removal+...
    c_ZnO+c_WGS+c_reformer;


