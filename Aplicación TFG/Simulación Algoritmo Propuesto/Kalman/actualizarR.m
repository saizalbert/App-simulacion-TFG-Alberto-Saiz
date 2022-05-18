function [R]=actualizarR(paramRadar,sph)
    %sph(2)=phi sph(3)=theta
    r=sph(1);
    phi=sph(2); 
    theta=sph(3);
    %Desviaciones típicas (a lo mejor habría que poner varianzas?)
    covarXTot=[sin(theta)*cos(phi)*paramRadar.sigmar r*cos(phi)*cos(theta)*paramRadar.sigmatheta r*sin(theta)*sin(phi)*paramRadar.sigmaphi];
    %sigmaX=rssq(sigmaXTot); 
    varX=sum(covarXTot.^2);
    covarYTot=[sin(theta)*sin(phi)*paramRadar.sigmar r*sin(phi)*cos(theta)*paramRadar.sigmatheta r*sin(theta)*cos(phi)*paramRadar.sigmaphi];
    %sigmaY=rssq(sigmaYTot);
    varY=sum(covarYTot.^2);
    covarZTot=[cos(theta)*paramRadar.sigmar r*sin(theta)*paramRadar.sigmatheta];
    %sigmaZ=rssq(sigmaZTot);
    varZ=sum(covarZTot.^2);
    %Covarianzas
    covarXYTot=[sin(theta)^2*cos(phi)*sin(phi)*paramRadar.sigmar^2 r^2*cos(theta)^2*cos(phi)*sin(phi)*paramRadar.sigmatheta^2 -r^2*sin(theta)^2*cos(phi)*sin(phi)*paramRadar.sigmaphi^2];
    %sigmaXY=sqrt(sum(sigmaXYTot));
    covarXY=sum(covarXYTot);
    covarXZTot=[sin(theta)*cos(phi)*cos(theta)*paramRadar.sigmar^2 -r*cos(theta)*cos(phi)*r*sin(theta)*paramRadar.sigmatheta^2];
    %sigmaXZ=sqrt(sum(sigmaXZTot)); 
    covarXZ=sum(covarXZTot);
    covarYZTot=[sin(theta)*sin(phi)*cos(theta)*paramRadar.sigmar^2 -r*cos(theta)*sin(phi)*r*sin(theta)*paramRadar.sigmatheta^2];
    %sigmaYZ=sqrt(sum(sigmaYZTot)); 
    covarYZ=sum(covarYZTot); 
    R=[varX covarXY covarXZ; covarXY varY covarYZ; covarXZ covarYZ varZ]; 
end 