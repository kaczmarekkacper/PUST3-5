classdef DMCRegMIMO < handle
    properties
        LAMBDA % macierz lambda
        S % macierz odpowiedzi skokowych
        M % macierz dynamiczna
        Mp % macierz zmian odp skokowej
        K % Wektor wzmocnieñ
        D % horyzont dynamiki
        N % horyzont predykcji
        Nu % horyzont sterowania
        u_prev % poprzednie sterowanie
        yzad % wartoœæ zadana
        deltaup % wektor delta Up
        Umin % minimalna wartoœæ sterowania
        Umax % maksymalna wartoœæ sterowniaa
    end
    
    methods
        function obj = DMCRegMIMO(s, D, N, Nu, lambda, Umin, Umax)
            % przypisanie do zmiennych obiektu
            obj.N = N;  
            obj.D = D;  
            obj.Nu = Nu;
            obj.S = zeros(size(s,1)*2, 2);
            for i = 1:size(s,1)
                obj.S(2 * i - 1, 1) = s(i,1);
                obj.S(2 * i - 1, 2) = s(i,2);
                obj.S(2 * i, 1) = s(i,3);
                obj.S(2 * i, 2) = s(i,4);
            end
            obj.LAMBDA = eye(Nu * 2) * lambda; 
            obj.Umin = Umin; 
            obj.Umax = Umax; 

            % Wyznaczanie macierzy M 
            obj.M= zeros(2 * N, 2 * Nu);
            for i=1:2:Nu*2
                obj.M(i:N*2,i:i+1)=obj.S(1:2*N-i+1, :);
            end

            % Wyznaczanie macierzy Mp 
            obj.Mp= zeros(N * 2, (D-1)*2);
            for i=1:N
               for j=1:(D-1)
                  if 2*(i+j)<=2*D
                     obj.Mp(2*i-1:2*i,2*j-1:2*j)=obj.S((i+j)*2-1:(i+j)*2, :)-obj.S(j*2-1:j*2, :);
                  else
                     obj.Mp(2*i-1:2*i,2*j-1:2*j)=obj.S(2*D-1:2*D, :)-obj.S(j*2-1:j*2, :);
                  end   
               end
            end

            % Wektor wzmocnieñ - wyznaczany raz (offline)
            obj.K=(obj.M'*obj.M+obj.LAMBDA)\obj.M';
        end
        
        function [] = reset(obj,u_p)
            obj.u_prev = u_p;
            obj.deltaup=zeros(1,(obj.D-1) * 2)';
        end
        
        function [] = setValue(obj, yzad)
            obj.yzad = ones(obj.N * 2, 1);
            for i = 1:2: obj.N *2
                obj.yzad(i) = yzad(1);
                obj.yzad(i+1) = yzad(2);
            end
        end
        
        function u = countValue(obj,y)
            
            % aktualizacja wektora aktualnej wartoœci wyjœcia
            yk=ones(obj.N * 2,1);
            for i = 1:2: obj.N *2
                yk(i) = yk(i) * y(1);
                yk(i+1) = yk(i+1) *y(2);
            end
            % wyliczenie nowego wektora odpowiedzi swobodnej
            y0=yk+obj.Mp*obj.deltaup;
            
            % wyliczenie wektora zmian sterowania
            deltauk=obj.K(1:2,:)*(obj.yzad-y0);
            
            % prawo regulacji
            u=obj.u_prev+deltauk(1:2);
            
            %ograniczenie wartoœci
            lowerArr = u < obj.Umin;
            u(lowerArr) = obj.Umin(lowerArr);
            upperArr = u > obj.Umax;
            u(upperArr) = obj.Umax(upperArr);
            
            %Przepisanie poprzedniej wartoœci
            obj.u_prev = u;
            
            % aktualizacja poprzednich zmian sterowania
            obj.deltaup=[deltauk(1:2); obj.deltaup(1:end-2)];
        end
    end
end

