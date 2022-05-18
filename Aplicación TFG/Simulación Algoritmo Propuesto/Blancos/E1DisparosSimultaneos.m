function [blanco, N, modF]=E1DisparosSimultaneos(~)
 N=3;
 modF=1;
 blanco=cell(1,N);
 %% Blanco 1
 blanco{1}.modo=2;
 pos_ini=[8000, 0, pi/4];
 blanco{1}.r_i=pos_ini(1);
 blanco{1}.phi_i=pos_ini(2);
 blanco{1}.theta_i=pos_ini(3);
 %% Blanco 2 
 blanco{2}.modo=2;
 pos_ini=[8000, pi/3, pi/4];
 blanco{2}.r_i=pos_ini(1);
 blanco{2}.phi_i=pos_ini(2);
 blanco{2}.theta_i=pos_ini(3);
 %% Blanco 3
 blanco{3}.modo=2;
 pos_ini=[8000, 2*pi/3, pi/4];
 blanco{3}.r_i=pos_ini(1);
 blanco{3}.phi_i=pos_ini(2);
 blanco{3}.theta_i=pos_ini(3);
end 