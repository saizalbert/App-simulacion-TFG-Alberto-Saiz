function [v_circ]=mov_espiral(pos_ini,w,deltaK)
v_circ(1)=pos_ini(1)-deltaK*5; 
v_circ(3)=wrapTo2Pi(pos_ini(3)); 
v_circ(2)=wrapTo2Pi(pos_ini(2)+w*deltaK); 
end