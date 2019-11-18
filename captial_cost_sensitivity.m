clear all
close all
clc

% cold gas efficiency
CGE=0.648;
% LHV of SNG 
LHV_SNG=44; %[MJ/m3]
% LHV of straw 
LHV_straw=16; %[MJ/kg]
% base plant scale
MWb=20;
% base tonnage per day
ton_day_b=MWb*86400*10^-3/(LHV_straw*CGE);
% base plant capital cost
p1=0.1;%percentage of change
p2=0.2;
Cap=zeros(5,2);
Cap2=zeros(3,2);
Cap(3,1)=23.1; %[M$]
Cap2(2,1)=23.1;
Cap(4,1)=23.1*(1+p1);
Cap(2,1)=23.1*(1-p1);
Cap(5,1)=23.1*(1+p2);
Cap2(3,1)=23.1*(1+p2);
Cap(1,1)=23.1*(1-p2);
Cap2(1,1)=23.1*(1-p2);
Cap(3,2)=61.7;
Cap2(2,2)=61.7;
Cap(4,2)=Cap(3,2)*(1+p1);
Cap(2,2)=Cap(3,2)*(1-p1);
Cap(5,2)=Cap(3,2)*(1+p2);
Cap2(3,2)=Cap2(2,2)*(1+p2);
Cap(1,2)=Cap(3,2)*(1-p2);
Cap2(1,2)=Cap2(2,2)*(1-p2);
MWb_handling=182*0.11;

MW=linspace(1,500,500)';
ton_day=MW.*86400*10^-3./(LHV_straw*CGE);
r=ton_day/ton_day_b;

% capital cost 
CapEx=zeros(500,2,3);
YI_reactor=zeros(4,3);
YI_reactor_2=zeros(4,3);
YI_aux_2=zeros(4,3);
YI_aux=zeros(4,3);

figure()
for i=1:3
    for j=1:500
    CapEx(j,1,i)=Cap2(i,1)*r(j)^0.68+Cap2(2,2)*r(j)^0.44;
    CapEx(j,2,i)=Cap2(2,1)*r(j)^0.68+Cap2(i,2)*r(j)^0.44;
    end
%     XI=[0,400,1500,max(ton_day)];
%     YI_reactor(:,i)=lsq_lut_piecewise(ton_day, CapEx(:,1,i),XI);
%     YI_aux(:,i)=lsq_lut_piecewise(ton_day, CapEx(:,2,i),XI);
    plot(ton_day,CapEx(:,1,i),'.',ton_day,CapEx(:,2,i),'.')
    
    hold on
end
xlabel("biomass consumption [ton/day]")
ylabel("capital expenditure [$M]")
legend('reactor -20%','auxilary -20%','baseline','baseline','reactor +20%','auxilary +20%');
set(gca,'FontSize',14)

figure()
subplot(2,2,1)
% reactor cost decrease 20% 
XI=[0,400,1500,max(ton_day)];
YI_reactor(:,1)=lsq_lut_piecewise(ton_day, CapEx(:,1,1),XI);
plot(ton_day,CapEx(:,1,1),'.',XI,YI_reactor(:,1),'+-')
xlabel("biomass consumption [ton/day]")
ylabel("capital expenditure [$M]")
title('reactor cost reduced by 20%')

coefficients1=polyfit([XI(1),XI(2)],[YI_reactor(1),YI_reactor(2)],1);
a1=round(coefficients1(1),2);
b1=round(coefficients1(2),2);

coefficients2=polyfit([XI(2),XI(3)],[YI_reactor(2),YI_reactor(3)],1);
a2=round(coefficients2(1),2);
b2=round(coefficients2(2),2);

coefficients3=polyfit([XI(3),XI(4)],[YI_reactor(3),YI_reactor(4)],1);
a3=round(coefficients3(1),2);
b3=round(coefficients3(2),2);

text(250,85,['y1=',num2str(a1),'x+',num2str(b1)],'color',[0.8500, 0.3250, 0.0980])
text(1150,200,['y2=',num2str(a2),'x+',num2str(b2)],'color',[0.8500, 0.3250, 0.0980])
text(2800,325,['y3=',num2str(a3),'x+',num2str(b3)],'color',[0.8500, 0.3250, 0.0980])

subplot(2,2,2)
%reactor increase by 20% 
XI=[0,400,1500,max(ton_day)];
YI_reactor_2(:,1)=lsq_lut_piecewise(ton_day, CapEx(:,1,3),XI);
plot(ton_day,CapEx(:,1,3),'.',XI,YI_reactor_2(:,1),'+-')
xlabel("biomass consumption [ton/day]")
ylabel("capital expenditure [$M]")
title('reactor cost increase by 20%')

coefficients12=polyfit([XI(1),XI(2)],[YI_reactor_2(1),YI_reactor_2(2)],1);
a12=round(coefficients12(1),2);
b12=round(coefficients12(2),2);

coefficients22=polyfit([XI(2),XI(3)],[YI_reactor_2(2),YI_reactor_2(3)],1);
a22=round(coefficients22(1),2);
b22=round(coefficients22(2),2);

coefficients32=polyfit([XI(3),XI(4)],[YI_reactor_2(3),YI_reactor_2(4)],1);
a32=round(coefficients32(1),2);
b32=round(coefficients32(2),2);

text(250,85,['y1=',num2str(a12),'x+',num2str(b12)],'color',[0.8500, 0.3250, 0.0980])
text(1150,240,['y2=',num2str(a22),'x+',num2str(b22)],'color',[0.8500, 0.3250, 0.0980])
text(2800,370,['y3=',num2str(a32),'x+',num2str(b32)],'color',[0.8500, 0.3250, 0.0980])

subplot(2,2,3)
%aux decrease by 20% 
XI=[0,400,1500,max(ton_day)];
YI_aux(:,1)=lsq_lut_piecewise(ton_day, CapEx(:,2,1),XI);
plot(ton_day,CapEx(:,2,1),'.',XI,YI_aux(:,1),'+-')
xlabel("biomass consumption [ton/day]")
ylabel("capital expenditure [$M]")
title('auxiallry decrease by 20%')

coefficients123=polyfit([XI(1),XI(2)],[YI_aux(1),YI_aux(2)],1);
a123=round(coefficients123(1),2);
b123=round(coefficients123(2),2);

coefficients223=polyfit([XI(2),XI(3)],[YI_aux(2),YI_aux(3)],1);
a223=round(coefficients223(1),2);
b223=round(coefficients223(2),2);

coefficients323=polyfit([XI(3),XI(4)],[YI_aux(3),YI_aux(4)],1);
a323=round(coefficients323(1),2);
b323=round(coefficients323(2),2);

text(250,70,['y1=',num2str(a123),'x+',num2str(b123)],'color',[0.8500, 0.3250, 0.0980])
text(1150,190,['y2=',num2str(a223),'x+',num2str(b223)],'color',[0.8500, 0.3250, 0.0980])
text(2800,310,['y3=',num2str(a323),'x+',num2str(b323)],'color',[0.8500, 0.3250, 0.0980])

subplot(2,2,4)
% the aux increase for 20% 
XI=[0,400,1500,max(ton_day)];
YI_aux_2(:,1)=lsq_lut_piecewise(ton_day, CapEx(:,2,3),XI);
plot(ton_day,CapEx(:,2,3),'.',XI,YI_aux_2(:,1),'+-')
xlabel("biomass consumption [ton/day]")
ylabel("capital expenditure [$M]")
title('auxiallry increase by 20%')

coefficients1234=polyfit([XI(1),XI(2)],[YI_aux_2(1),YI_aux_2(2)],1);
a1234=round(coefficients1234(1),2);
b1234=round(coefficients1234(2),2);

coefficients2234=polyfit([XI(2),XI(3)],[YI_aux_2(2),YI_aux_2(3)],1);
a2234=round(coefficients2234(1),2);
b2234=round(coefficients2234(2),2);

coefficients3234=polyfit([XI(3),XI(4)],[YI_aux_2(3),YI_aux_2(4)],1);
a3234=round(coefficients3234(1),2);
b3234=round(coefficients3234(2),2);

text(250,80,['y1=',num2str(a1234),'x+',num2str(b1234)],'color',[0.8500, 0.3250, 0.0980])
text(1150,240,['y2=',num2str(a2234),'x+',num2str(b2234)],'color',[0.8500, 0.3250, 0.0980])
text(2800,380,['y3=',num2str(a3234),'x+',num2str(b3234)],'color',[0.8500, 0.3250, 0.0980])


