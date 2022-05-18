function [blanco, N, modF]=blancoCircular(param)
    N=1;
    modF=1;
 blanco=cell(1,N);
  %Blanco 1 
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
end 