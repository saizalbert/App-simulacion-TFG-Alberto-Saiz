function [blanco, N, modF]=blancoRectaAcelerada(param)
    N=1;
    modF=2;
 blanco=cell(1,N);
  %Blanco 1 
      blanco{1}.modo=9;
    x_ini=800;
    y_ini=-650;
    z_ini=800;
    pos_ini=cart2esf([x_ini y_ini z_ini]);
     blanco{1}.r_i=pos_ini(1);
     blanco{1}.phi_i=pos_ini(2);
    blanco{1}.theta_i=pos_ini(3);
%     blanco{1}.r_i=6000;
%     blanco{1}.phi_i=pi/2;
%     blanco{1}.theta_i=pi/4;
    blanco{1}.v=50;
    blanco{1}.w=0.05*2*pi;
    blanco{1}.vectorVel(1)=-20;
    blanco{1}.vectorVel(2)=-25;
    blanco{1}.vectorVel(3)=-1;
    blanco{1}.modVel=rssq(blanco{1}.vectorVel);
    blanco{1}.escala=0.5/20;
    blanco{1}.vectorAcc=blanco{1}.escala*blanco{1}.vectorVel;
    blanco{1}.mode=1;   
end 