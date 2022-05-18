function [blanco, N, modF]=E3Maniobrante(param)
 N=1;
 modF=1;
 blanco=cell(1,N);
 %% Blanco 1
 blanco{1}.modo=12;
 x_ini=1000;
 y_ini=-7000;
 z_ini=800;
 pos_ini=cart2esf([x_ini y_ini z_ini]);
 blanco{1}.r_i=pos_ini(1);
 blanco{1}.phi_i=pos_ini(2);
 blanco{1}.theta_i=pos_ini(3);
 blanco{1}.vectorVel(1)=-40;
 blanco{1}.vectorVel(2)=+35;
 blanco{1}.vectorVel(3)=-5;
 blanco{1}.modVel=rssq(blanco{1}.vectorVel);
 blanco{1}.vectorAcc=[0 0 0];

end 