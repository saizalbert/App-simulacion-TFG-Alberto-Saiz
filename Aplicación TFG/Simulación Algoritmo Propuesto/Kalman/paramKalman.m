function [F,GQGt] = paramKalman(modF, deltaK,q)  
switch modF
    case 1
        F=[1 deltaK 0 0 0 0; 0 1 0 0 0 0; 0 0 1 deltaK 0 0; 0 0 0 1 0 0; 0 0 0 0 1 deltaK; 0 0 0 0 0 1];
        BkBkt=[deltaK^4/4 deltaK^3/2; deltaK^3/2 deltaK^2]; 
        GQGt=zeros(6);
        GQGt(1:2,1:2)=q*BkBkt;
        GQGt(3:4,3:4)=q*BkBkt;
        GQGt(5:6,5:6)=q*BkBkt;
    case 2
        Ak=[1 deltaK 1/2*deltaK^2; 0 1 deltaK; 0 0 1]; 
        BkBkt=[deltaK^4/4 deltaK^3/2 deltaK^2/2; deltaK^3/2 deltaK^2 deltaK; deltaK^2/2 deltaK 1]; 
        F=zeros(9); 
        GQGt=zeros(9); 
        F(1:3,1:3)=Ak;
        F(4:6,4:6)=Ak;
        F(7:9,7:9)=Ak;
        GQGt(1:3,1:3)=q*BkBkt;
        GQGt(4:6,4:6)=q*BkBkt;
        GQGt(7:9,7:9)=q*BkBkt;
        
end 
end 

    
    