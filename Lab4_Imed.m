% Lab 4 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 79096
%Raquel Ara�jo nr. 80843

%% Question 1

% No equil�brio, � aplicado um campo magn�tico forte, B0 representado por um vetor com
% orienta��o segundo z, cuja a magnitude n�o altera ao longo do tempo (est�tico).
%|B0| varia entre 1-10 T.

%Este campo vai levar � polariza��o dos spins, que atingem dois estados de
%energia espec�ficos, E-=-1/2*gama*h*B0 e E+=1/2*gama*h*B0, ou seja
%deltaE=gama*h*B0.
%Como o campo magn�tico B0 � segundo z, os momentos magn�ticos v�o girar em
%torno de z, no plano transversal. O vetor magnetiza��o M0 consiste no
%somat�rio de todos os momentos magn�ticos e uma vez que h� mais spins 
%com orienta��o paralela (para +z) do que antiparalela (para -z), o vetor
%M0 vai estar orientado segundo z.

%O campo magn�tico B0 est� SEMPRE presente, por isso os spins (miu) est�o
%sempre a rodar em torno de B0. Como este � o "estado natural" dos spins
%polarizados temos de usar um novo referencial que esteja a rodar com a
%mesma frequencia de miu, para que possamos considerar miu est�tico neste
%referencial. Como consequencia, o M0 tamb�m vai ser est�tico neste
%referencial e orientado seugndo B0.

M0=[0; 0; 1]; %Vetor unit�rio est�tico de magnetiza��o

%% Question 2: EXCITA��O (Mxy>0) COM B1 SEGUNDO +X E FLIP ANGLE: 90�

% 'The basic unit for angles in MATLAB� is the radian.'
theta = 90*(pi/180);

%Dura��o da excita��o 15ms = 15*10^-3 s
T = 15*10^-3;

%Time Step da excita��o 0.1 ms = 0.1*10^-3 s
step = 0.1*10^-3;

% Matriz onde est�o guardados os valores de Mx, My e Mz ao longo de todos
% os incrementos de �ngulo
Mxyz = zeros(3, T/step);

% Incremento de �ngulos: x = tempo total / time step e y = 90/x . 
x = T/step;

%Preencher a matriz Mxyz. N�mero de itera��es � o nr de colunas da matriz
%que t�m de ser preenchidas (todos os steps de 0 at� 15ms)
for t = 0:T/step
    Mxyz(:,t+1)= [1 0 0; 0 cos(t*theta/x) sin(t*theta/x); 0 -sin(t*theta/x) cos(t*theta/x)]*M0;
end

Myz_norm=zeros(1,T/step);
for t = 0:T/step
    Myz_norm(1,t+1)=norm([Mxyz(1,t+1) Mxyz(2,t+1) Mxyz(3,t+1)]);
end

figure('Name', 'Q2 - Excitation by a 90� flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:10:size(Mxyz,2)
point =[Mxyz(1,j) Mxyz(2,j) Mxyz(3,j)];
point1=[1,0,0];
point2=[0,0,1];
origin = [0 0 0];
plot3([origin(1) point(1)],[origin(2) point(2)],[origin(3) point(3)],'LineWidth',5,'Marker','^','DisplayName','M','Color','b');
plot3([origin(1) point1(1)],[origin(2) point1(2)],[origin(3) point1(3)],'LineWidth',5,'Marker','^','DisplayName','B1','Color','r');
plot3([origin(1) point2(1)],[origin(2) point2(2)],[origin(3) point2(3)],'LineWidth',5,'Marker','^','DisplayName','M0','Color','cyan');
legend({'M0','M','B1'});
set(gca,'YDir','reverse','XDir','reverse');
grid on
hold on
xlabel('Xrot'); xlim([0,1.5]);
ylabel('Yrot'); ylim([0,1.5]);
zlabel('Zrot'); zlim([0,1.5]);
end

subplot(2,1,2)
tempo = (0:step:T);
Mx = Mxyz (1,:);
My = Mxyz (2,:);
Mz = Mxyz (3,:);
plot (tempo,Mx,tempo,My,tempo,Mz,tempo,Myz_norm)
legend('Mx','My','Mz','MyzNORM')
xlabel('Time [s]')
ylabel('Magnitude')
ylim([0,1.5]);

%COMENT�RIO:
%Quando come�a a ser aplicado o campo vari�vel B1 segundo x', ocorre uma rota��o do
%vetor de magnetiza��o (inicialmente M0 segundo z) em torno de x' at� atingir o
%valor de 90�. Ao longo desta rota��o, o vetor aumenta inicialmente de
%magnitude mas esta volta a diminuir, sendo que no fim da rota��o a magnitude � igual a M0
%e o vetor tem a dire��o +y: My = M0 e Mz = 0.

%% Question 3: RELAXA��O AP�S B1 SEGUNDO +X E FLIP ANGLE: 90�

%Dura��o da observa��o da relaxa��o 1000ms = 1s
Trel = 1;

%O vetor de magnetiza��o est� agora todo sobre o eixo y porque sofreu uma
%rota��o de 90�. Assim My = M0.
M0_rel = [0; 1; 0];

% Matriz onde estar�o guardados os valores de Mx, My e Mz ao longo de
% processo de relaxa��o
Mxyz_rel = zeros(3, Trel/step);

%Sabemos que as condi��es iniciais de Mxyz_rel s�o M0_rel
Mxyz_rel(:,1) = M0_rel;

%Preencher a matriz com as equa��es de relaxa��o 
T1 = 700*10^-3;
T2 = 70*10^-3;

for t = 1:Trel/step
   Mxyz_rel(:,t+1) = [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)] * Mxyz_rel(:,t) + [0; 0; (1-exp(-step/T1))] ;
end

figure('Name', 'Q3 - Relaxation after excitation by a 90� flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:500:size(Mxyz_rel,2)
point =[0 Mxyz_rel(2,j) 0];
point1=[0 0 Mxyz_rel(3,j)];
point2=[0,0,1];
origin = [0 0 0];
plot3([origin(1) point(1)],[origin(2) point(2)],[origin(3) point(3)],'LineWidth',5,'Marker','^','DisplayName','My','Color','b');
plot3([origin(1) point1(1)],[origin(2) point1(2)],[origin(3) point1(3)],'LineWidth',5,'Marker','^','DisplayName','Mx','Color','r');
plot3([origin(1) point2(1)],[origin(2) point2(2)],[origin(3) point2(3)],'LineWidth',5,'Marker','^','DisplayName','M0','Color','cyan');
legend({'M0','My','Mz'});
set(gca,'YDir','reverse','XDir','reverse');
grid on
hold on
xlabel('Xrot'); xlim([0,0.2]);
ylabel('Yrot'); ylim([0,1.2]);
zlabel('Zrot'); zlim([0,1.2]);
end

subplot(2,1,2)
tempo_rel = (0:step:Trel);
Mx_rel = Mxyz_rel (1,:);
My_rel = Mxyz_rel (2,:);
Mz_rel = Mxyz_rel (3,:);
plot (tempo_rel,Mx_rel,tempo_rel,My_rel,tempo_rel,Mz_rel)
legend('Mx','My','Mz')
xlabel('Time [s]');
ylabel('Magnitude')

%COMENT�RIO:
%Quando o campo magn�tico B1 segundo +x deixa de ser aplicado, d�-se a
%relaxa��o (regresso ao equil�brio), na qual My diminui � taxa de 1/T2
%at� atingir o valor zero e Mz aumenta � taxa de 1/T1 at� atingir M0.
%Uma vez que T1>T2 � normal que My diminua mais r�pido do que Mz aumenta.
%Verifica-se ainda que 1 segundo n�o d� tempo suficiente para Mz atingir o
%valor de M0.

%% Question 4_A: EXCITA��O COM B1 +X FLIP ANGLE: 30�

theta_4 = 30*(pi/180);

Mxyz_4 = zeros(3, T/step);
Myz_4_norm=zeros(1,T/step);
for t = 0:T/step
    Mxyz_4(:,t+1)= [1 0 0; 0 cos(t*theta_4/x) sin(t*theta_4/x); 0 -sin(t*theta_4/x) cos(t*theta_4/x)]*M0;
end

for t = 0:T/step
    Myz_4_norm(1,t+1)=norm([Mxyz_4(1,t+1) Mxyz_4(2,t+1) Mxyz_4(3,t+1)]);
end

figure('Name', 'Q4_A - Excitation by a 30� flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:10:size(Mxyz_4,2)
point =[Mxyz_4(1,j) Mxyz_4(2,j) Mxyz_4(3,j)];
point1=[1,0,0];
point2=[0,0,1];
origin = [0 0 0];
plot3([origin(1) point(1)],[origin(2) point(2)],[origin(3) point(3)],'LineWidth',5,'Marker','^','DisplayName','M','Color','b');
plot3([origin(1) point1(1)],[origin(2) point1(2)],[origin(3) point1(3)],'LineWidth',5,'Marker','^','DisplayName','B1','Color','r');
plot3([origin(1) point2(1)],[origin(2) point2(2)],[origin(3) point2(3)],'LineWidth',5,'Marker','^','DisplayName','M0','Color','cyan');
legend({'M0','M','B1'});
set(gca,'YDir','reverse','XDir','reverse');
grid on
hold on
xlabel('Xrot'); xlim([0,1.5]);
ylabel('Yrot'); ylim([0,1.5]);
zlabel('Zrot'); zlim([0,1.5]);
end

subplot(2,1,2)
tempo = (0:step:T);
Mx_4 = Mxyz_4 (1,:);
My_4 = Mxyz_4 (2,:);
Mz_4 = Mxyz_4 (3,:);
plot (tempo,Mx_4,tempo,My_4,tempo,Mz_4,tempo,Myz_4_norm)
legend('Mx','My','Mz','MyzNORM')
xlabel('Time [s]')
ylabel('Magnitude')
ylim([0, 1.5])


%COMENT�RIO:


%% Question 4_B: RELAXA��O AP�S B1 +X FLIP ANGLE: 30�

%Dura��o da observa��o da relaxa��o 1000ms = 1s
Trel = 1;

% O vetor de magnetiza��o, no in�cio da relaxa��o, corresponde ao vetor de
% magnetiza��o no fim da exita��o.
M0_rel_4 = Mxyz_4(:,T/step);

% Matriz onde estar�o guardados os valores de Mx, My e Mz ao longo de
% processo de relaxa��o
Mxyz_rel_4 = zeros(3, Trel/step);

%Sabemos que as condi��es iniciais de Mxyz_rel s�o M0_rel
Mxyz_rel_4(:,1) = M0_rel_4;

%Preencher a matriz com as equa��es de relaxa��o 
T1 = 700*10^-3;
T2 = 70*10^-3;

for t = 1:Trel/step
   Mxyz_rel_4(:,t+1) = [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)]*Mxyz_rel_4(:,t)+[0; 0; (1-exp(-step/T1))] ;
end

figure('Name', 'Q4_B - Relaxation after excitation by a 30� flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:500:size(Mxyz_rel_4,2)
point =[0 Mxyz_rel_4(2,j) 0];
point1=[0 0 Mxyz_rel_4(3,j)];
point2=[0,0,1];
%point3=[Mxyz_4(1,size(Mxyz_4,2)),Mxyz_4(2,size(Mxyz_4,2)),Mxyz_4(3,size(Mxyz_4,2))];  %N�O SEI SE VALE A PENA TER ISTO AQUI!
origin = [0 0 0];
plot3([origin(1) point(1)],[origin(2) point(2)],[origin(3) point(3)],'LineWidth',5,'Marker','^','DisplayName','My','Color','b');
plot3([origin(1) point1(1)],[origin(2) point1(2)],[origin(3) point1(3)],'LineWidth',5,'Marker','^','DisplayName','Mx','Color','r');
plot3([origin(1) point2(1)],[origin(2) point2(2)],[origin(3) point2(3)],'LineWidth',5,'Marker','^','DisplayName','M0','Color','cyan');
legend({'M0','My','Mz'});
set(gca,'YDir','reverse','XDir','reverse');
grid on
hold on
xlabel('Xrot'); xlim([0,0.2]);
ylabel('Yrot'); ylim([0,1.2]);
zlabel('Zrot'); zlim([0,1.2]);
end

subplot(2,1,2)
tempo_rel = (0:step:Trel);
Mx_rel_4 = Mxyz_rel_4 (1,:);
My_rel_4 = Mxyz_rel_4 (2,:);
Mz_rel_4 = Mxyz_rel_4 (3,:);
plot (tempo_rel,Mx_rel_4,tempo_rel,My_rel_4,tempo_rel,Mz_rel_4)
legend('Mx','My','Mz')
xlabel('Time [s]')
ylabel('Magnitude')

%COMENT�RIO:
%Assim como no caso anterior os vetore My e Mz come�am a relaxar a partir
%dos respectivos valores no fim dos 15ms de excita��o. No entanto, My<1 e
%Mz?0. Assim, Mz atinge o valor de 0 � mesma taxa mas ainda mais rapido por 
%ser mais pequeno e Mz vai crescer � mesma taxa mas atingir um valor mais
%pr�ximo de M0 do que no caso inicial, por estar mais pr�ximo deste valor
%no intante em que a relaxa��o come�a.


%% Question 5: RELAXATION DURING EXCITATION PERIOD 

% Repeat for a 90� flip angle, but this time considering relaxation during the
% excitation period. 
% ent�o usamos T = 1000 ms ???
% como sobrepor os dois acontecimentos? multiplicar matrizes?? O que eu
% penso: a cada time step (0.1ms) o vetor M0 "desce" segundo a fun��o de
% sen/cos e "sobe" segundo a fun��o exponencial. Como t�m comportamentos
% diferentes (subida!=descida)vamos notar varia��es. Por isso SOMEI as
% contribui��es.

% Dura��o da observa��o: 1s (que � o tempo maior) ent�o vou usar a vari�vel
% Trel
% Time step habitural: vou usar a vari�vel step
% T1 e T2 definidos anteriormente
% Angulo: 90� - vari�vel theta
% Vetor magnetiza��o inicial � M0 = Mz (do equil�brio)

T=15*(10^(-3));
% step=0.1*(10^(-3));

ang_it = theta / (T/step);

%nao sei se � suposto ter o exp(-step/T2) ou nao. alguem que me ajude a
%perceber!
relax_matrix = [exp(-step/T2) 0 0; 0 exp(-(step/T2)) 0; 0 0 (exp(-(step/T1)))];
relax_sum = [0;0;(1-exp(-(step/T1)))];

rotat_m = [1 0 0;
    0 cos(ang_it) sin(ang_it);
    0 -sin(ang_it) cos(ang_it)];

M0 = [0; 0; 1];

Mxyz_5 = zeros(3, T/step);
Mxyz_5(:,1) = M0;

y = T/step;
for i = 2:y+1
    
    M_new = rotat_m * Mxyz_5(:,i-1);
    Mxyz_5(:,i) = relax_matrix * M_new + relax_sum;
    
end

tempo_rel = (0:T/step);

figure();
Mx_5 = Mxyz_5 (1,:);
My_5 = Mxyz_5 (2,:);
Mz_5 = Mxyz_5 (3,:);

plot (tempo_rel,Mx_5,tempo_rel,My_5,tempo_rel,Mz_5)
title('5. Excitation + Relaxation of B1 along +x by 90� flip angle')
legend('Mx','My','Mz')
xlabel('Time [s]')
ylabel('Magnitude')

figure('Name', 'Q2 - Excitation by a 90� flip angle', 'NumberTitle','off');
Mxyz=Mxyz_5;
for j=1:10:size(Mxyz,2)
point =[Mxyz(1,j) Mxyz(2,j) Mxyz(3,j)];
point1=[1,0,0];
point2=[0,0,1];
origin = [0 0 0];
plot3([origin(1) point(1)],[origin(2) point(2)],[origin(3) point(3)],'LineWidth',5,'Marker','^','DisplayName','M','Color','b');
plot3([origin(1) point1(1)],[origin(2) point1(2)],[origin(3) point1(3)],'LineWidth',5,'Marker','^','DisplayName','B1','Color','r');
plot3([origin(1) point2(1)],[origin(2) point2(2)],[origin(3) point2(3)],'LineWidth',5,'Marker','^','DisplayName','M0','Color','cyan');
legend({'M0','M','B1'});
set(gca,'YDir','reverse','XDir','reverse');
grid on
hold on
xlabel('Xrot'); xlim([0,1.5]);
ylabel('Yrot'); ylim([0,1.5]);
zlabel('Zrot'); zlim([0,1.5]);
end

%COMENTARIO:
%fenomeno de excitacao e relaxacao ao mesmo tempo. Comparando com a situacao 
%original da excitacao com o valor de 90�, conseguimos ver que esta,
%embora seja a mesma o fenomeno predominante, demora
%muito mais tempo e nao chega a ser completa (o MZ nao chega a zero nem os 90� sao atingidos).
% Isto porque a excitacao � um fenomeno muito mais rapido que a relaxacao.

