function [E] = modelError(params) 
global sObject
K = params(1) ; 
T0 = params(2) ; 
T1 = params(3) ; 
T2 = params(4) ; 

G = tf(K,[T1*T2, (T2+T1),1], 'OutputDelay',T0); 
Gz = c2d(G,1); 

modelResponse = step(1:length(sObject),Gz); 

E = (sObject-modelResponse)'*(sObject-modelResponse); 
end