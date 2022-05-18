function [v_rand]=mov_rand(param,pos,i)
v_rand=[ (pos(i,1)+randn*param.sigmar),  (pos(i,2) +randn*param.sigmaphi), (pos(i,3)+randn*param.sigmatheta)];
end 