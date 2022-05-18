function [blanco, N, modF]=E2TiroBalistico(param)
 N=1;
 modF=2;
 blanco=cell(1,N);
 T=param.periodoT*param.res; 
 %% Blanco 1
 blanco{1}.modo=14;
 angDisparo=45;
 blanco{1}.vectorVel(2)=0;
 blanco{1}.vectorVel(3)=(param.g*T)/(1-exp(-param.b*T))-param.g/param.b;
 blanco{1}.vectorVel(1)=blanco{1}.vectorVel(3)/sind(angDisparo)*cosd(angDisparo);
 x_ini=-10e3;
 y_ini=0;
 z_ini=0;
 pos_ini=cart2esf([x_ini y_ini z_ini]);
 blanco{1}.r_i=pos_ini(1);
 blanco{1}.phi_i=pos_ini(2);
 blanco{1}.theta_i=pos_ini(3);
 blanco{1}.escala=0.5/20;
 blanco{1}.vectorAcc=blanco{1}.escala*blanco{1}.vectorVel;
end 