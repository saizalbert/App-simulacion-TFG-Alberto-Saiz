function [pos_radial]=mov_radialAcc(pos ,v,a,deltaK)
    pos_radial(2)=pos(2); 
    pos_radial(3)=pos(3); 
    r=pos(1)-v*deltaK-a/2*deltaK^2; 
    if r>0
        pos_radial(1)=r; 
    else 
        pos_radial(1)=0;
    end
    
end