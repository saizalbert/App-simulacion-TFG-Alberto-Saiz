function [trazas, info,kalman,trazasActivas,totalTrazas] = mahalanobis(plotDet, trazas, kalman,P_ini,paramRadar,trazasActivas,totalTrazas,indexPpal,modF,info,umbral,inicialEscalaP)
%Inicializamos los parámetros
%dth=12.8; %Tres dimensiones: (nz=3) --> Pg=0.995-> dth=12.8
dth=umbral;
longTraza=length(trazasActivas); %Longitud de matriz de trazas
cont=0;%Contador para poner nuevas trazas potenciales
posNueva=inf;
%Comprobamos plot a plot si correla con alguna traza 
for i=1:length(plotDet.r)
    distMin=inf; %Distancia mínima para ver a qué traza es la que más se acerca
    posMin=0; %posición de la traza a la que más se acerca
    for m=1:longTraza
        k=trazasActivas(m);
        %De Kalman, 
        switch modF
            case 1
                dif=[kalman{k}.Xpredict(1)-plotDet.x(i); kalman{k}.Xpredict(3)-plotDet.y(i); kalman{k}.Xpredict(5)-plotDet.z(i)];
            case 2
                dif=[kalman{k}.Xpredict(1)-plotDet.x(i); kalman{k}.Xpredict(4)-plotDet.y(i); kalman{k}.Xpredict(7)-plotDet.z(i)];
        end
        distMah=sqrt(transpose(dif)*(kalman{k}.Sprox\dif)); %Fórmula Mahalanobis
        if ~isreal(distMah)
            disp("wtf")
        end
        if(distMah<distMin) %Para comprobar mínima 
            distMin=distMah; 
            posMin=k;
        end 
    end
    if(distMin<dth) %Si baja el umbral, se coloca en la traza que habíamos visto 
        %infotrazas.cont(posMin)=trazas.cont(posMin)+1;
        trazas{posMin}.r(end+1)=plotDet.r(i);
        trazas{posMin}.phi(end+1)=plotDet.phi(i);
        trazas{posMin}.theta(end+1)= plotDet.theta(i);
        trazas{posMin}.x(end+1)= plotDet.x(i);
        trazas{posMin}.y(end+1)= plotDet.y(i);
        trazas{posMin}.z(end+1)= plotDet.z(i);
        trazas{posMin}.corr=1;
        kalman{posMin}.distMah(end+1)=distMin;
    else %Si no cumple el umbral, inicializamos una nueva fila
        cont=cont+1;
        posNueva=totalTrazas+cont;
        %totalTrazas=totalTrazas+1; 
        trazas{posNueva}.r=plotDet.r(i);
        trazas{posNueva}.phi=plotDet.phi(i);
        trazas{posNueva}.theta=plotDet.theta(i);
        trazas{posNueva}.x=plotDet.x(i);
        trazas{posNueva}.y=plotDet.y(i);
        trazas{posNueva}.z=plotDet.z(i);
        trazas{posNueva}.corr=0;
        trazas{posNueva}.estado=1;
        trazas{posNueva}.calidad=3;
        trazas{posNueva}.extrapol=0;
        trazas{posNueva}.nueva=1;
        trazas{posNueva}.id=posNueva;
        trazasActivas(end+1)=posNueva;
        posIni=[plotDet.x(i) plotDet.y(i) plotDet.z(i)];
        kalman{posNueva}.X=asignacionInicialX(posIni,modF);
        kalman{posNueva}.historialX=[];
        kalman{posNueva}.historialVel=[];
        kalman{posNueva}.historialAcc=[];
        kalman=asignacionHistorialX(kalman,modF,posNueva);
        kalman{posNueva}.historialXsph=cart2esf(kalman{posNueva}.historialX);
        %kalman{posNueva}.P=P_ini;
        kalman{posNueva}.R=actualizarR(paramRadar,kalman{posNueva}.historialXsph);
        escala=1.5;
        switch modF
            case 1 
            inicialP=ones(1,6)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{posNueva}.R(1,1); 
            P_ini(3,3)=escala*kalman{posNueva}.R(2,2); 
            P_ini(5,5)=escala*kalman{posNueva}.R(3,3);
            kalman{posNueva}.P=P_ini;
            case 2
            inicialP=ones(1,9)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{posNueva}.R(1,1); 
            P_ini(4,4)=escala*kalman{posNueva}.R(2,2); 
            P_ini(7,7)=escala*kalman{posNueva}.R(3,3);
            kalman{posNueva}.P=P_ini;
        end 
        kalman{posNueva}.id=i; 
        kalman{posNueva}.relacionBlanco(indexPpal)=true(1); 
        kalman{posNueva}.inicioTraza=indexPpal-1; 
        kalman{posNueva}.distMah=distMin;
    end 
info(end+1,:)=[posMin, posNueva, longTraza, distMin];
totalTrazas=totalTrazas+cont; 
end

