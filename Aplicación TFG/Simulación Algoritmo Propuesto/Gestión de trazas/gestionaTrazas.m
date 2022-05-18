function [trazas,trazasActivas,kalman]=gestionaTrazas(trazas,paramTrazas,trazasActivas,kalman)
for j=trazasActivas
    eliminada=false;
    %Aumentamos la calidad de la traza dependiendo de si se encuentra
    %correlada
    trazas{j}.calidad=trazas{j}.calidad +trazas{j}.corr*paramTrazas.actCalcorr; 
    %Comprobamos si la calidad supera el máximo
    if (trazas{j}.calidad>paramTrazas.maxCal)
        trazas{j}.calidad=paramTrazas.maxCal;
    end 
    %Comprobamos el paso de potencial a tentativa 
    if(trazas{j}.estado==1 && trazas{j}.corr)
        trazas{j}.estado=2; %Ahora es tentativa 
    end 
    %Comprobamos el paso de potencial a firme 
    if(trazas{j}.estado==2 && trazas{j}.calidad >= paramTrazas.promoEstablecida)
        trazas{j}.estado=3; %Ahora es firme 
    end 
    %Reducimos calidad de trazas NO correladas
    if(trazas{j}.corr==0 && trazas{j}.nueva == 0)
        trazas{j}.calidad=trazas{j}.calidad-paramTrazas.actCalext; 
    end 
    %Comprobamos extrapolaciones 
    if(trazas{j}.estado==3 && paramTrazas.haExtrapolado)
        trazas{j}.extrapol=trazas{j}.extrapol+1; 
    end 
    %Eliminamos las trazas potenciales no correladas, aquellas cuya calidad
    %alcanza umbralDrop o extrapolaConf y las tentativas cuya calidad es 0
    %o extrapola numExtrapTent
    if((true)&&((trazas{j}.estado==1 && trazas{j}.nueva == 0) || (trazas{j}.estado==3 && (trazas{j}.calidad<=paramTrazas.umbralDrop || trazas{j}.extrapol==paramTrazas.numExtrapConf)) || (trazas{j}.estado==2 && (trazas{j}.calidad==0 || trazas{j}.extrapol==paramTrazas.numExtrapTent))))
        trazas{j}=[];
        kalman{j}=[];
        auxIndice=find(trazasActivas==j);
        trazasActivas(auxIndice)=[];
        eliminada=true;
    end 
    if ~eliminada
    trazas{j}.corr=0;
    trazas{j}.nueva=0;
    end 
end 