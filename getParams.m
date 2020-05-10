function [p] = getParams(s,index)
global sObject;
sObject = s ; 
fval = 100;

fun = @ modelError;
cFractions = [0.1,0.5,0.9];
mFractions = [0.2,0.5,0.8];
pSizes = [100,200]; 

CF = zeros(18,1); 
MF = zeros(18,1); 
PS = zeros(18,1); 
fvalues = zeros(18,1); 
Params = zeros(18,4); 
i = 1 ;
for cf = cFractions 
    for mf = mFractions 
        for PopulationSize = pSizes
            options = optimoptions('ga','CrossoverFraction', cf,...
                    'MaxGenerations', 100, ...
                    'MaxStallGenerations', 50,...
                    'MigrationFraction', mf,...
                    'PopulationSize', PopulationSize,...
                    'EliteCount', ceil(eval("0.1*PopulationSize"))); 
                [params, fval, exitflag, output] = ga (fun,4,[],[],[],[],[0,8,0,0],[],[],2,options);
                CF(i) = cf ; MF(i) = mf ; PS(i) = PopulationSize; Params(i,1:end) = params; fvalues(i)=fval;
                Gs = tf(params(1),[params(3)*params(4),(params(4)+params(3)),1],'OutputDelay',params(2)) ;
                Gz = c2d(Gs,1);
                y = step(1:151,Gz);
                figure
                stairs(y) 
                hold on
                plot(s)
                axis([0 151 -0.5 3.5])
                title(sprintf("Aproksymacja odpowiedzi skokowej $s_{%s}$ $E=%.2f$",index,fval),'interpreter','latex');
                xlabel('Czas','interpreter','latex') ;
                ylabel("Wyjscie obiektu i modelu",'interpreter','latex');
                legend('Model','Obiekt','interpreter','latex','Location','southeast');
                matlab2tikz(sprintf('results/3/Model_cf%.2fmf%.2fpSize%d_s%sE%.2f.tex',cf,mf,PopulationSize,index,fval))
                i =  i + 1 ;
        end
    end
end


[e,i] = min(fvalues);
p = Params(i,1:end); 


end
