function [pos,blanco]=movimiento(blanco,pos,deltaK,t,N,paramBlanco,param)
for i=1:N
switch blanco{i}.modo
    case 1 %Mov circular
        pos(i,:)=mov_circ(pos(i,:), blanco{i}.w,deltaK);
    case 2 %Mov radial hacia 0.0
        %pos(i,:)=mov_radial(pos(i,:), blanco{i}.v,deltaK);
        vectorVelRad=-esf2cart(blanco{i}.pos_ini)/(param.periodoT*param.res); 
        blanco{i}.vectorVel=vectorVelRad; 
        blanco{i}.vectorAcc=[0 0 0]; 
        pos(i,:)=mov_recta(blanco{i}.pos_ini,vectorVelRad,t);
    case 3  %Mov aleatorio
        pos(i,:)=mov_rand(paramBlanco,pos,i); 
    case 4 %Mov circular con variaciones 
        pos(i,:)=mov_circ(pos(i,:), blanco{i}.w,deltaK);
        pos(i,2)=pos(i,2) +randn*paramBlanco.sigmaphi;
        pos(i,3)=pos(i,3) +randn*paramBlanco.sigmatheta;
        
    case 5  %Mov radial con variaciones
        pos(i,:)=mov_radial(pos(i,:), blanco{i}.v,deltaK);
%         vectorVelRad=-esf2cart(blanco{i}.pos_ini)/paramBlanco.tEstimado; 
%         pos(i,:)=mov_recta(blanco{i}.pos_ini,vectorVelRad,t);
        pos(i,2)=pos(i,2) +randn*paramBlanco.sigmaphi;
        pos(i,3)=pos(i,3) +randn*paramBlanco.sigmatheta;
    case 6 %Mov en recta
        pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK);
        blanco{i}.vectorAcc=[0 0 0];
    case 7 %Mov en recta con variaciones 
        aux=[randn*paramBlanco.sigmar randn*paramBlanco.sigmaphi randn*paramBlanco.sigmatheta];
        pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK)+aux; 
    case 8 %Caída libre 
        pos(i,:)=mov_caidaLibre(blanco{i}.pos_ini,t);
    case 9 %Movimiento recto uniformemente acelerado 
        pos(i,:)=mov_rectaAcelerado(blanco{i}.pos_ini,blanco{i}.vectorVel,blanco{i}.vectorAcc,t);
    case 10 %Movimiento recto uniformemente acelerado con variaciones
        aux=[randn*paramBlanco.sigmar randn*paramBlanco.sigmaphi randn*paramBlanco.sigmatheta];
        pos(i,:)=mov_rectaAcelerado(blanco{i}.pos_ini,blanco{i}.vectorVel,blanco{i}.vectorAcc,t)+aux; 
    case 11 %Variación circular yy 
        if mod(t,25)~=15
            blanco{i}.mode=~blanco{i}.mode;
        end 
        if blanco{i}.mode
            pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK);
        else 
            pos(i,:)=mov_circ(pos(i,:), blanco{i}.w,deltaK);
        end 
      
    case 12 %Cambios de vector velocidad y dirección
        if 0.6-rand>0
            pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK);
        else 
            blanco{i}.vectorVel(1)=blanco{i}.vectorVel(1) + rand_rango(-20,20);
            blanco{i}.vectorVel(2)=blanco{i}.vectorVel(2) + rand_rango(-20,20);
            blanco{i}.vectorVel(3)=blanco{i}.vectorVel(3) + rand_rango(-20,20);
            pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK);
        end 
    case 13 %Modo radial acelerado (Modo KAMIKAZE) 
%         pos(i,:)=mov_radialAcc(blanco{i}.pos_ini, blanco{i}.v,blanco{i}.a, t);
        vectorVelRad=-esf2cart(blanco{i}.pos_ini)*0.5/(param.periodoT*param.res); 
        vectorAccRad=0.15*vectorVelRad; 
        blanco{i}.vectorVel=vectorVelRad; 
        blanco{i}.vectorAcc=vectorAccRad; 
        pos(i,:)=mov_rectaAcelerado(blanco{i}.pos_ini,blanco{i}.vectorVel,blanco{i}.vectorAcc,t);
    case 14 %Tiro balístico 
        pos(i,:)=mov_tiroBalistico(blanco{i}.pos_ini,blanco{i}.vectorVel,param,t);
    case 15 %Espiral 
        pos(i,:)=mov_espiral(pos(i,:), blanco{i}.w,deltaK);
    case 16 %Perimetral 
        T=param.periodoT*param.res; 
        cambio=T/4;
        if (t>cambio && t<2*cambio)
            blanco{i}.vectorVel=[blanco{i}.v 0 0];
        elseif (t>2*cambio && t<3*cambio)
            blanco{i}.vectorVel=[0 -blanco{i}.v 0 ];
        elseif (t>3*cambio && t<4*cambio)
            blanco{i}.vectorVel=[-blanco{i}.v 0 0 ];
        end 
        pos(i,:)=mov_recta(pos(i,:),blanco{i}.vectorVel,deltaK); 
end
end
end