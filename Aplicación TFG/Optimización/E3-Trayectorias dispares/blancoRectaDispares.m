function [blanco, N, modF]=blancoRectaChocantes(param)
    N=2;
    modF=2;
 blanco=cell(1,N);  
%% Blanco 1
 blanco{1}.modo=1;
     blanco{1}.r_i=600;
    blanco{1}.phi_i=pi/2;
    blanco{1}.theta_i=pi/4;
    blanco{1}.v=50;
    blanco{1}.w=0.015*2*pi;
    blanco{1}.vectorVel(1)=-6000/(param.periodoT*param.res);
    blanco{1}.vectorVel(2)=-6000/(param.periodoT*param.res);
    blanco{1}.vectorVel(3)=-3750/(param.periodoT*param.res);
    blanco{1}.escala=0.9/20;
    blanco{1}.vectorAcc=blanco{1}.escala*blanco{1}.vectorVel;
    blanco{1}.mode=1;
%% Blanco 2 
   blanco{2}.modo=2;
    x_ini=3000;
    y_ini=-4150;
    z_ini=4150;
    pos_ini=cart2esf([x_ini y_ini z_ini]);
     blanco{2}.r_i=pos_ini(1);
     blanco{2}.phi_i=pos_ini(2);
    blanco{2}.theta_i=pos_ini(3);
%     blanco{1}.r_i=6000;
%     blanco{1}.phi_i=pi/2;
%     blanco{1}.theta_i=pi/4;
    blanco{2}.v=50;
    blanco{2}.w=0.05*2*pi;
    blanco{2}.vectorVel(1)=-6000/(param.periodoT*param.res);
    blanco{2}.vectorVel(2)=-6000/(param.periodoT*param.res);
    blanco{2}.vectorVel(3)=-3750/(param.periodoT*param.res);
    blanco{2}.escala=0.9/20;
    blanco{2}.vectorAcc=blanco{1}.escala*blanco{1}.vectorVel;
    blanco{2}.mode=1;   
end 