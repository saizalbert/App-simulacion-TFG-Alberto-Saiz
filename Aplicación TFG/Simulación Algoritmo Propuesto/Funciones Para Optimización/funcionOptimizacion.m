function [blanco, kalman, errorRadar, errorKalman]=funcionOptimizacion(q,umbral,datosBlanco, inicialEscalaP, N,modF, param)
%% Simulación entorno inicial 
close all
%% Parámetros iniciales
umbral=ones(1,2)*umbral;
contActP=0;
blanco=datosBlanco;
%% Inicialización estructuras 
radar=cell(1,N);
errorRadar=cell(1,N);
kalman=cell(1,N);
trazas=cell(1,N);
%% Parámetros radar
paramRadar.pd=0.95;
paramRadar.contnodet=0;
paramRadar.det=false;
paramRadar.posNoDet=[];
%Parámetros desviación:
paramRadar.sigmar=1; %Resolución de 10 m 
%Asumiendo un ancho de haz de 10º en ambos planos, 10 veces menos, 1º
paramRadar.sigmaphi=1*pi/180;
paramRadar.sigmatheta=1*pi/180;
%Alguna forma de poder estimar en cartesianas?
paramRadar.sigmax=57^2; 
paramRadar.sigmay=39^2; 
paramRadar.sigmaz=40^2; 
info=[];
%% Sigmas de desviación típica de blanco
paramBlanco.sigmar=0.02;
paramBlanco.sigmaphi=0.01; 
paramBlanco.sigmatheta=0.01;
paramBlanco.tEstimado=70;
%% Asignación inicial
for i=1:N
blanco{i}.pos_ini=[blanco{i}.r_i blanco{i}.phi_i blanco{i}.theta_i]; %Vector de posición incial
%blanco{i}.movsph(1,:)=blanco{i}.pos_ini;
blanco{i}.movcart(1,:)=esf2cart(blanco{i}.pos_ini);
blanco{i}.movsph(1,:)=cart2esf(blanco{i}.movcart(1,:));
blanco{i}.pos_ini=blanco{i}.movsph(1,:);
%COMO JUSTIFICO EL DELTAX Y TAL 
radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmar;
radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmaphi;
radar{i}.detsph(1,:)=blanco{i}.pos_ini + randn*paramRadar.sigmatheta;
radar{i}.detcart(1,:)=esf2cart(radar{i}.detsph(1,:));

end 
for i=1:N
pos_sph(i,:)=blanco{i}.pos_ini; 
end
t=0;
tiempos(1)=0;

%% Trazas
% paramTrazas.numExtrapConf=3;  %Nº máximo de extrapolaciones permitidas en Trazas Firmes
% paramTrazas.numExtrapTent=2; %Nº máximo de extrapolaciones permitidas en Trazas Tentativas
paramTrazas.numExtrapConf=6;  %Nº máximo de extrapolaciones permitidas en Trazas Firmes
paramTrazas.numExtrapTent=8; %Nº máximo de extrapolaciones permitidas en Trazas Tentativas
paramTrazas.iniCalidad=3; %Inicial calidad
%paramTrazas.maxCal=10; %Valor de calidad máxima
paramTrazas.maxCal=15;
paramTrazas.promoEstablecida=5; %Valor de calidad para generar Traza Firme
paramTrazas.umbralDrop=3; %Valor de calidad mínima (umbral de drop
paramTrazas.actCalcorr=1; %Actualización de la calidad de Trazas
paramTrazas.actCalext=1; %Actualización de la calidad de Trazas
for i=1:N
trazas{i}.r=radar{i}.detsph(1); 
trazas{i}.phi=radar{i}.detsph(2);
trazas{i}.theta=radar{i}.detsph(3);
trazas{i}.x=radar{i}.detcart(1); 
trazas{i}.y=radar{i}.detcart(2);
trazas{i}.z=radar{i}.detcart(3);
trazas{i}.calidad=paramTrazas.iniCalidad;
trazas{i}.estado=1;
trazas{i}.extrapol=0;
trazas{i}.nueva=0;
trazas{i}.corr=0;
trazas{i}.cont=0;
trazas{i}.id=i;
%Inicialización Kalman
kalman{i}.X=asignacionInicialX(radar{i}.detcart,modF);
kalman{i}.historialX=[];
kalman{i}.historialVel=[];
kalman{i}.historialAcc=[];
kalman=asignacionHistorialX(kalman,modF,i);
kalman{i}.historialVel=[0 0 0]; 
kalman{i}.historialAcc=[0 0 0]; 
kalman{i}.historialXsph=cart2esf(kalman{i}.historialX);
%kalman{i}.P=P_ini;
kalman{i}.R=actualizarR(paramRadar,kalman{i}.historialXsph);
kalman{i}.id=i;
kalman{i}.relacionBlanco=true; 
kalman{i}.inicioTraza=1;
kalman{i}.distMah=0;
%kalman{i}.Sprox=S;
end
trazasActivas=1:N;
totalTrazas=N;
conjuntoCovarianzas=[];
trazasFiltradas=[];
%% Parametros iniciales Kalman
switch modF
    case 1
        deltaK=param.periodoT; %Primer valor estimado; 
        historialDelta(1)=deltaK;
        [F, GQGt]=paramKalman(modF, deltaK,q);
        H=[1 0 0 0 0 0; 0 0 1 0 0 0; 0 0 0 0 1 0]; 
        escala=1.5;  
        for i=1:N
            inicialP=ones(1,6)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{i}.R(1,1); 
            P_ini(3,3)=escala*kalman{i}.R(2,2); 
            P_ini(5,5)=escala*kalman{i}.R(3,3);
            kalman{i}.P=P_ini;
        end 
    case 2
        deltaK=param.periodoT; %Primer valor estimado; 
        historialDelta(1)=deltaK;
        [F, GQGt]=paramKalman(modF, deltaK,q);
        H=[1 0 0 0 0 0 0 0 0; 0 0 0 1 0 0 0 0 0; 0 0 0 0 0 0 1 0 0];
         escala=1.5;  
        for i=1:N
            %inicialP=ones(1,9)*inicialEscalaP;
            inicialP=ones(1,9)*inicialEscalaP;
            P_ini=diag(inicialP);
            P_ini=diag(inicialP);
            P_ini(1,1)=escala*kalman{i}.R(1,1); 
            P_ini(4,4)=escala*kalman{i}.R(2,2); 
            P_ini(7,7)=escala*kalman{i}.R(3,3);
            kalman{i}.P=P_ini;
        end 
    case 3 
        F=eye(3); 
        GQGt=eye(3); 
end 

%% Generación de figuras 
%figure('Position' ,[0 0 param.monitor(3) param.monitor(4)])
figure
%% Simulación del movimiento 
for i=2:param.res
t=tiempos(i-1) +param.periodoT;
tiempos(i)=t;
deltaK=tiempos(i)- tiempos(i-1);
[pos_sph,blanco]=movimiento(blanco,pos_sph,deltaK,t,N,paramBlanco,param);
for j=1:N
    pos_cart(j,:)=esf2cart(pos_sph(j,:));
    %Guardamos el historial
    blanco{j}.movsph(i,:)=pos_sph(j,:);
    blanco{j}.movcart(i,:)=pos_cart(j,:);
end

%if 1
if i<15 || paramRadar.pd-rand>0 || i==param.res 
for j=1:N
    radar{j}.detsph(i,1)=pos_sph(j,1) + randn*paramRadar.sigmar;
    radar{j}.detsph(i,2)=pos_sph(j,2) + randn*paramRadar.sigmaphi;
    radar{j}.detsph(i,3)=pos_sph(j,3) + randn*paramRadar.sigmatheta;
    radar{j}.detcart(i,:)=esf2cart(radar{j}.detsph(i,:));
end 
paramRadar.det=true;
paramTrazas.haExtrapolado=0; 
else %NO ha habido detección
    paramRadar.contnodet=paramRadar.contnodet+1; 
    paramRadar.posNoDet(end+1)=i;
    paramTrazas.haExtrapolado=1;
    for j=trazasActivas
    %Extrapolación
    X_extrapol=F*kalman{j}.X;
    kalman{j}.X=X_extrapol;
    [kalman]=asignacionHistorialX(kalman,modF,j);
    kalman{j}.historialXsph(end+1,:)=cart2esf(kalman{j}.historialX(end,:));
    kalman{j}.relacionBlanco(i)=true(1);
    trazas{j}.detcart(i,:)=kalman{j}.historialX(end,:); 
    trazas{j}.detsph(i,:)=cart2esf(kalman{j}.historialX(end,:));
    kalman{j}.distMah(end+1)=kalman{j}.distMah(end);
    
    radar{kalman{j}.id}.detcart(i,:)=trazas{j}.detcart(i,:); 
    radar{kalman{j}.id}.detsph(i,:)=trazas{j}.detsph(i,:);
    trazas{j}.corr=0; 
    end
    [trazas,trazasActivas,kalman]=gestionaTrazas(trazas, paramTrazas, trazasActivas,kalman); 
    continue;
end 

%Plot a trazas
for k=1:N
plotDet.r(k)=radar{k}.detsph(i,1);  
plotDet.phi(k)=radar{k}.detsph(i,2);  
plotDet.theta(k)=radar{k}.detsph(i,3); 
plotDet.x(k)=radar{k}.detcart(i,1);  
plotDet.y(k)=radar{k}.detcart(i,2); 
plotDet.z(k)=radar{k}.detcart(i,3);
plotDet.id(k)=i;
end

%Función que realiza la correlación de mahalanobis E INCLUYE EN
%TRAZAS LOS CAMBIOS DEBIDOS.
for k=trazasActivas 
    %kalman{k}.R=R_ini;
    kalman{k}.R=actualizarR(paramRadar,kalman{k}.historialXsph(end,:));
    kalman{k}.Sprox=H * kalman{k}.P * H' + kalman{k}.R; 
    kalman{k}.Xpredict=F*kalman{k}.X;
    %Reiniciamos las extrapolaciones
    trazas{k}.extrapol=0;
end 
[trazas,info,kalman,trazasActivas,totalTrazas]= mahalanobis(plotDet, trazas, kalman,P_ini,paramRadar,trazasActivas,totalTrazas,i,modF,info,umbral,inicialEscalaP);

%Gestionamos ciclo de vida trazas 
[trazas,trazasActivas,kalman]=gestionaTrazas(trazas,paramTrazas,trazasActivas,kalman);

% KALMAN

%Inicialización F y GQGt en k
for j=trazasActivas
    %Parámetros Kalman actualizables
    Z=[trazas{j}.x(end); trazas{j}.y(end); trazas{j}.z(end);];
    X=kalman{j}.X;
    P=kalman{j}.P;
    R=kalman{j}.R;
    [X,P] = kalman_fun(F,GQGt,P,H,R,Z,X);
    kalman{j}.X=X;
    kalman=asignacionHistorialX(kalman,modF,j);
    kalman{j}.historialXsph(end+1,:)=cart2esf(kalman{j}.historialX(end,:));
    kalman{j}.P=P;
    suma=sum(kalman{j}.P,'all');
    %disp("La suma de P es " +suma)
    if suma<15 
         kalman{j}.P=P*1.2;
         contActP=contActP+1;
    end 
    trazas{j}.x(end)=X(1); 
    trazas{j}.y(end)=X(3); 
    trazas{j}.z(end)=X(5); 
    kalman{j}.relacionBlanco(i)=true(1); 
end


end 
%% Funciones error respecto a radar 
for i=1:N
errorRadar{i}.sph=abs(blanco{i}.movsph-radar{i}.detsph);
errorRadar{i}.var_sph=mean((errorRadar{i}.sph).^2);
errorRadar{i}.desv_sph=sqrt(errorRadar{i}.var_sph);

errorRadar{i}.cart=abs(blanco{i}.movcart-radar{i}.detcart);
errorRadar{i}.var_cart=mean((errorRadar{i}.cart).^2);
errorRadar{i}.desv_cart=sqrt(errorRadar{i}.var_cart);
end 

%% Funciones error respecto Kalman 
for i=1:N
    errorKalman{i}.existeTraza=false;
end
for j=trazasActivas
    for i=1:N
    if kalman{j}.id==i
        errorKalman{i}.existeTraza=true;
        errorKalman{i}.idKalman=j;
        errorKalman{i}.refKalman=kalman{j}.inicioTraza:(kalman{j}.inicioTraza +length(kalman{j}.historialX(:,1))-1);
        errorKalman{i}.inicioTraza=kalman{j}.inicioTraza;
    end
    end
end
for i=1:N
if errorKalman{i}.existeTraza
        errorKalman{i}.cart=abs(blanco{i}.movcart(errorKalman{i}.refKalman,:)-kalman{errorKalman{i}.idKalman}.historialX);
        errorKalman{i}.sph=abs(blanco{i}.movsph(errorKalman{i}.refKalman,:)-kalman{errorKalman{i}.idKalman}.historialXsph);
        errorKalman{i}.var_cart=mean((errorKalman{i}.cart).^2);
        errorKalman{i}.desv_cart=sqrt(errorKalman{i}.var_cart);
        errorKalman{i}.var_sph=mean((errorKalman{i}.sph).^2);
        errorKalman{i}.desv_sph=sqrt(errorKalman{i}.var_sph);
        errorKalman{i}.mejora_cart=(errorRadar{i}.desv_cart-errorKalman{i}.desv_cart)./errorRadar{i}.desv_cart*100;
        errorKalman{i}.mejora_sph=(errorRadar{i}.desv_sph-errorKalman{i}.desv_sph)./errorRadar{i}.desv_sph*100;
        errorKalman{i}.precisionVel=abs(blanco{i}.vectorVel-kalman{errorKalman{i}.idKalman}.historialVel);
        errorKalman{i}.precisionAcc=abs(blanco{i}.vectorAcc-kalman{errorKalman{i}.idKalman}.historialAcc);
        errorKalman{i}.precisionVelFinal=(1-(errorKalman{i}.precisionVel(end,:)./abs(blanco{i}.vectorVel)))*100;
        errorKalman{i}.precisionAccFinal=(1-(errorKalman{i}.precisionAcc(end,:)./abs(blanco{i}.vectorAcc)))*100;
    else
       errorKalman{i}.existeTraza=false; 
       errorKalman{i}.inicioTraza=inf; 
end
end
end 
