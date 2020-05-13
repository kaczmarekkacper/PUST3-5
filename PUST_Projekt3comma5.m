%%0. Definicja makr

initSerialControl COM3 % initialise com port
global k;
k = 151;
G1pp = 25+7;
G2pp = 30+7;
T1pp = 0;
T3pp = 0;

saving = 1;

%% 1. Sprawdzic mozliwosc sterowania i pomiaru w komunikacji ze stanowiskiem – w szczególnosci
% sygnałów sterujacych G1, G2, oraz pomiaru T1, T3. Okreslic wartosci temperatur
%w punkcie pracy (punkt pracy: sterowanie G1 = 25 + F, G2 = 30 + F, T1
% oraz T3 do zmierzenia, F oznacza numer zespołu).
mkdir('results/1');
[y, u] = MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy');
if saving
    matlab2tikz('results/1/CheckWorkpoint.tex');
end
T1pp = mean(y(end-10:end, 1));
T3pp = mean(y(end-10:end, 2));

%% 2. Wyznaczyc odpowiedzi skokowe dla róznych zmian sygnałów sterujacych G1 i G2
% rozpoczynajac z punktu pracy – pomiar nalezy wykonac zarówno na T1 jak i T3. Dla
% kazdego toru narysowac przebiegi otrzymane dla róznych zmian sterowania na jednym
% rysunku. Czy własciwosci statyczne obiektu mozna okreslic jako (w przyblizeniu)
% liniowe? Jesli tak – wyznaczyc wzmocnienie statyczne dla kazdego toru. Narysowac
% charakterystyki statyczne procesu T1(G1,G2), T3(G1,G2).
mkdir('results/2');
%% G1+5

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G1 o 5');
%skok
[yG1plus5, uG1plus5] = MakeJump(G1pp+5, G2pp);
subplot(2,1,1);
title('Skok G1 o 5');
if saving
    matlab2tikz('results/2/G1+5.tex');
end

%% G1-5

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G1 o -5');
%skok
[yG1minus5, uG1minus5] = MakeJump(G1pp-5, G2pp);
subplot(2,1,1);
title('Skok G1 o -5');
if saving
    matlab2tikz('results/2/G1-5.tex');
end

%% G1-10

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G1 o -10');
%skok
[yG1minus10, uG1minus10] = MakeJump(G1pp-10, G2pp);
subplot(2,1,1);
title('Skok G1 o -10');
if saving
    matlab2tikz('results/2/G1-10.tex');
end

%% G1-20

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G1 o -20');
%skok
[yG1minus20, uG1minus20] = MakeJump(G1pp-20, G2pp);
subplot(2,1,1);
title('Skok G1 o -20');
if saving
    matlab2tikz('results/2/G1-20.tex');
end

%% G2+5

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G2 o 5');
%skok
[yG2plus5, uG2plus5] = MakeJump(G1pp, G2pp+5);
subplot(2,1,1);
title('Skok G2 o 5');
if saving
    matlab2tikz('results/2/G2+5.tex');
end

%% G2-5

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G2 o -5');
%skok
[yG2minus5, uG2minus5] = MakeJump(G1pp, G2pp-5);
subplot(2,1,1);
title('Skok G2 o -5');
if saving
    matlab2tikz('results/2/G2-5.tex');
end

%% G2-10

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G2 o -10');
%skok
[yG2minus10, uG2minus10] = MakeJump(G1pp, G2pp-10);
subplot(2,1,1);
title('Skok G2 o -10');
if saving
    matlab2tikz('results/2/G2-10.tex');
end

%% G2-20

%stabilizacja
MakeJump(G1pp, G2pp);
subplot(2,1,1);
title('Stabilizowanie obiektu w punkcie pracy G2 o -20');
%skok
[yG2minus20, uG2minus20] = MakeJump(G1pp, G2pp-20);
subplot(2,1,1);
title('Skok G2 o -20');
if saving
    matlab2tikz('results/2/G2-20.tex');
end

save('answers.mat');

%% Rysowanie odpowiedzi na jednym rysunku
load('answers.mat');

% T1 do G1
figure;
subplot(2,1,1);
plot(0:150, T1pp*ones(151,1));
title("Odpowiedzi skokowe $T_{1}$ dla  $G_{1}$", 'interpreter', 'latex');
hold on;
plot(0:150, yG1plus5(:,1));
plot(0:150, yG1minus5(:,1));
plot(0:150, yG1minus10(:,1));
plot(0:150, yG1minus20(:,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_{1pp}$", "$G_{1pp}+5$", "$G_{1pp}-5$", "$G_{1pp}-10$", "$G_{1pp}-20$", 'interpreter', 'latex', 'location', 'southwest');

subplot(2,1,2);
plot(0:150, G1pp*ones(151,1));
hold on;
plot(0:150, uG1plus5(:,1));
plot(0:150, uG1minus5(:,1));
plot(0:150, uG1minus10(:,1));
plot(0:150, uG1minus20(:,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("$G_{1pp}$", "$G_{1pp}+5$", "$G_{1pp}-5$", "$G_{1pp}-10$", "$G_{1pp}-20$", 'interpreter', 'latex');

if saving
    matlab2tikz('results/2/T1doG1.tex');
end
% T3 do G1
figure;
subplot(2,1,1);
plot(0:150, T3pp*ones(151,1));
title("Odpowiedzi skokowe $T_3$ dla $G_1$", 'interpreter', 'latex');
hold on;
plot(0:150, yG1plus5(:,2));
plot(0:150, yG1minus5(:,2));
plot(0:150, yG1minus10(:,2));
plot(0:150, yG1minus20(:,2));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_{3pp}$", "$G_{1pp}+5$", "$G_{1pp}-5$", "$G_{1pp}-10$", "$G_{1pp}-20$", 'interpreter', 'latex', 'location', 'southwest');

subplot(2,1,2);
plot(0:150, G1pp*ones(151,1));
hold on;
plot(0:150, uG1plus5(:,1));
plot(0:150, uG1minus5(:,1));
plot(0:150, uG1minus10(:,1));
plot(0:150, uG1minus20(:,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("$G_{1pp}$", "$G_{1pp}+5$", "$G_{1pp}-5$", "$G_{1pp}-10$", "$G_{1pp}-20$", 'interpreter', 'latex');

if saving
    matlab2tikz('results/2/T3doG1.tex');
end

% T1 do G2
figure;
subplot(2,1,1);
plot(0:150, T1pp*ones(151,1));
title("Odpowiedzi skokowe $T_1$ dla $G_2$", 'interpreter', 'latex');
hold on;
plot(0:150, yG2minus5(:,1));
plot(0:150, yG2minus10(:,1));
plot(0:150, yG2minus20(:,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_{1pp}$", "$G_{2pp}-5$", "$G_{2pp}-10$", "$G_{2pp}-20$", 'interpreter', 'latex', 'location', 'southwest');

subplot(2,1,2);
plot(0:150, G2pp*ones(151,1));
hold on;
plot(0:150, uG2minus5(:,2));
plot(0:150, uG2minus10(:,2));
plot(0:150, uG2minus20(:,2));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("$G_{2pp}$", "$G_{2pp}-5$", "$G_{2pp}-10$", "$G_{2pp}-20$", 'interpreter', 'latex');

if saving
    matlab2tikz('results/2/T1doG2.tex');
end

% T3 do G2
figure;
subplot(2,1,1);
plot(0:150, T3pp*ones(151,1));
title("Odpowiedzi skokowe $T_3$ dla $G_2$", 'interpreter', 'latex');
hold on;
plot(0:150, yG2minus5(:,2));
plot(0:150, yG2minus10(:,2));
plot(0:150, yG2minus20(:,2));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_{3pp}$", "$G_{2pp}-5$", "$G_{2pp}-10$", "$G_{2pp}-20$", 'interpreter', 'latex', 'location', 'southwest');

subplot(2,1,2);
plot(0:150, G2pp*ones(151,1));
hold on;
plot(0:150, uG2minus5(:,2));
plot(0:150, uG2minus10(:,2));
plot(0:150, uG2minus20(:,2));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("$G_{2pp}$", "$G_{2pp}-5$", "$G_{2pp}-10$", "$G_{2pp}-20$", 'interpreter', 'latex');

if saving
    matlab2tikz('results/2/T3doG2.tex');
end

%% Charakterystyki statyczne
load('answers.mat');
G1 = 0:3:50; G1 = G1';
G2 = 0:3:50; G2 = G2';
Us = zeros(size(G1,1)*size(G2,1), 2);
Ys = zeros(size(G1,1)*size(G2,1), 2);
isValid = true(size(G1,1)*size(G2,1), 1);
MakeJump(0, 0);
i = 1;
for g1 = G1'
    for g2 = G2'
        k = 100;
        [y, u] = MakeJump(g1, g2);
        close;
        exceeded = any(y>150, 'all');
        Us(i, :) = u(end, :);
        Ys(i, :) = mean(y(end-10:end, :));
        isValid(i) = ~exceeded;
        i = i+1;
    end
    MakeJump(g1, 0);
end
G1 = Us(:,1);
G2 = Us(:,2);
T1 = Ys(:,1);
T3 = Ys(:,2);
chstat = table(G1, G2, T1, T3, isValid);

save('chstat.mat');

%% Rysowanie charakterystyki statycznej

load('chstat.mat');

[X,Y] = meshgrid(0:3:50);

Z1 = zeros(size(X));
Z3 = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(Y,1)
        if chstat.isValid( chstat.G1 == X(i,j) & chstat.G2 == Y(i,j))
            Z1(i,j) = chstat.T1( chstat.G1 == X(i,j) & chstat.G2 == Y(i,j));
            Z3(i,j) = chstat.T3( chstat.G1 == X(i,j) & chstat.G2 == Y(i,j));
        else
            Z1(i,j) = NaN;
            Z3(i,j) = NaN;
        end
    end
end

figure;
surf(X,Y,Z1);
xlabel("$G_{1}$", 'interpreter', 'latex');
ylabel("$G_{2}$", 'interpreter', 'latex');
zlabel("$T_{1}$", 'interpreter', 'latex');
title("Charakterystyka statyczna $T_{1}(G_{1},G_{2}$)", 'interpreter', 'latex');

figure;
surf(X,Y,Z3);
xlabel("$G_{1}$", 'interpreter', 'latex');
ylabel("$G_{2}$", 'interpreter', 'latex');
zlabel("$T_{3}$", 'interpreter', 'latex');
title("Charakterystyka statyczna $T_{3}(G_{1},G_{2}$)", 'interpreter', 'latex');


%% 3. Przygotowac stosowna liczbe odpowiedzi skokowych do implementacji regulatora DMC
% 2 × 2 i wykonac ich aproksymacje uzywajac w tym celu członu inercyjnego drugiego
% rzedu z opóznieniem (szczegóły w opisie znajdujacym sie na stronie przedmiotu). W
% celu doboru parametrów modelu wykorzystac optymalizacje. Uzasadnic wybór parametrów
% optymalizacji. Zamiescic rysunki porównujace odpowiedzi skokowe (tj. w
% postaci nadajacej sie do uzycia jako model DMC) oryginalne i po aproksymacji (uzyc
% tej samej skali dla wszystkich rysunków).
load('answers.mat');
mkdir('results/3');
%T1 do G1
s11 = (yG1minus20(:,1)-T1pp)/-20;

figure;
subplot(2,1,1);
plot(0:150, s11)
title("Znormalizowana odpowiedz DMC $T_1$ dla $G_1$", 'interpreter', 'latex');
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_1$ dla $G_1$", 'interpreter', 'latex', 'location', 'southeast');

subplot(2,1,2)
plot(0:150, ones(151,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("skok", 'interpreter', 'latex');

if saving
   matlab2tikz('results/3/DMCT1G1.tex'); 
end
%T3 do G1
s12 = (yG1minus20(:,2)-T3pp)/-20;

figure;
subplot(2,1,1);
plot(0:150, s12)
title("Znormalizowana odpowiedz DMC $T_3$ dla $G_1$", 'interpreter', 'latex');
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_3$ dla $G_1$", 'interpreter', 'latex', 'location', 'southeast');

subplot(2,1,2)
plot(0:150, ones(151,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("skok", 'interpreter', 'latex');

if saving
   matlab2tikz('results/3/DMCT3G1.tex'); 
end

%T1 do G2
s21 = (yG2minus20(:,1)-T1pp)/-20;


figure;
subplot(2,1,1);
plot(0:150, s21)
title("Znormalizowana odpowiedz DMC $T_1$ dla $G_2$", 'interpreter', 'latex');
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_1$ dla $G_2$", 'interpreter', 'latex', 'location', 'southeast');

subplot(2,1,2)
plot(0:150, ones(151,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("skok", 'interpreter', 'latex');

if saving
   matlab2tikz('results/3/DMCT1G2.tex'); 
end

%T3 do G2
s22 = (yG2minus20(:,2)-T3pp)/-20;

figure;
subplot(2,1,1);
plot(0:150, s22)
title("Znormalizowana odpowiedz DMC $T_3$ dla $G_2$", 'interpreter', 'latex');
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$T[\circ C]$", 'interpreter', 'latex');
legend("$T_3$ dla $G_2$", 'interpreter', 'latex', 'location', 'southeast');

subplot(2,1,2)
plot(0:150, ones(151,1));
xlabel("$t[s]$", 'interpreter', 'latex');
ylabel("$\%$", 'interpreter', 'latex');
legend("skok", 'interpreter', 'latex');

if saving
   matlab2tikz('results/3/DMCT3G2.tex'); 
end