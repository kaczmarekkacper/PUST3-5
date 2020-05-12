function [Gz] = approximateModel(s,index)

global sObject;
sObject = s ; 
fval = 200;
i = 0 ;
fun = @ modelError;
PopulationSize = 100;
options = optimoptions('ga','CrossoverFraction', 0.5,...
'MaxGenerations', 100, ...
'MaxStallGenerations', 50,...
'MigrationFraction', 0.5,...
'PopulationSize', PopulationSize, 'EliteCount', ceil(eval("0.1*PopulationSize"))); 
while fval > 0.34 && i < 30
[params, fval, exitflag, output] = ga (fun,4,[],[],[],[],[0,0,0,0],[],[],2,options)
Gs = tf(params(1),[params(3)*params(4),(params(4)+params(3)),1],'OutputDelay',params(2)) 
Gz = c2d(Gs,1)
i =  i + 1 ;
end
% y = step(1:151,Gz);
% figure
% stairs(y) 
% hold on
% plot(s)
% title(sprintf("Aproksymacja odpowiedzi skokowej $s_{%s}$",index),'interpreter','latex');
% xlabel('Czas','interpreter','latex') ;
% ylabel("Wyjscie obiektu i modelu",'interpreter','latex');
% legend('Model','Obiekt','interpreter','latex','Location','southeast');
% matlab2tikz(sprintf('results/3/Model2_s%s.tex',index))



end