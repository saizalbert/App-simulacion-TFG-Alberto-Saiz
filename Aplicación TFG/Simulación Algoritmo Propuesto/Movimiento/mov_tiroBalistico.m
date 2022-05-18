function [pos_recta]=mov_tiroBalistico(pos_ini,vectorVel, param,t)
    pos_inicart=esf2cart(pos_ini); 
    pos_cart(1)=(vectorVel(1)/param.b)*(1-exp(-param.b*t))-abs(pos_inicart(1));
    pos_cart(2)=0;
    pos_cart(3)=(1/param.b)*(param.g/param.b +vectorVel(3))*(1-exp(-param.b*t))-param.g*t/param.b; 
    pos_recta=cart2esf(pos_cart); 
    
end 