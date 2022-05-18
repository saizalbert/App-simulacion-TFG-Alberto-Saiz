function [pos_radial]=mov_radial(pos ,v,deltaK)
    pos_radial(2)=pos(2); 
    pos_radial(3)=pos(3); 
    r=pos(1)-v*deltaK; 
    if r>0
        pos_radial(1)=r; 
    else 
        pos_radial(1)=0;
    end
    
end