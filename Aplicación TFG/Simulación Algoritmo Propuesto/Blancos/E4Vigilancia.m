function [blanco, N, modF]=E4Vigilancia(~)
 N=2;
 modF=2;
 blanco=cell(1,N);
 %% Blanco 1
 blanco{1}.modo=1;
 blanco{1}.r_i=190;
 blanco{1}.phi_i=0;
 blanco{1}.theta_i=10*pi/180;
 blanco{1}.vectorVel(1)=0;
 blanco{1}.vectorVel(2)=0;
 blanco{1}.vectorVel(3)=0;
 blanco{1}.modVel=rssq(blanco{1}.vectorVel);
 blanco{1}.vectorAcc=[0 0 0];
blanco{1}.w=0.0942;
 %% Blanco 2
 blanco{2}.modo=16;
 x_ini=-250;
 y_ini=-250;
 z_ini=550;
 pos_ini=cart2esf([x_ini y_ini z_ini]);
 blanco{2}.r_i=pos_ini(1);
 blanco{2}.phi_i=pos_ini(2);
 blanco{2}.theta_i=pos_ini(3);
 blanco{2}.v=13.468;
 blanco{2}.vectorVel(1)=0;
 blanco{2}.vectorVel(2)= blanco{2}.v;
 blanco{2}.vectorVel(3)=0;
 blanco{2}.modVel=rssq(blanco{1}.vectorVel);
 blanco{2}.vectorAcc=[0 0 0];

end 