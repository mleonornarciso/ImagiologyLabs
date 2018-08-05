% Lab 4 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 79096
%Raquel Araújo nr. 80843

%% Question 1

% No equilíbrio, é aplicado um campo magnético forte, B0 representado por um vetor com
% orientação segundo z, cuja a magnitude não altera ao longo do tempo (estático).
%|B0| varia entre 1-10 T.

%Este campo vai levar à polarização dos spins, que atingem dois estados de
%energia específicos, E-=-1/2*gama*h*B0 e E+=1/2*gama*h*B0, ou seja
%deltaE=gama*h*B0.
%Como o campo magnético B0 é segundo z, os momentos magnéticos vão girar em
%torno de z, no plano transversal. O vetor magnetização M0 consiste no
%somatório de todos os momentos magnéticos e uma vez que há mais spins 
%com orientação paralela (para +z) do que antiparalela (para -z), o vetor
%M0 vai estar orientado segundo z.

%O campo magnético B0 está SEMPRE presente, por isso os spins (miu) estão
%sempre a rodar em torno de B0. Como este é o "estado natural" dos spins
%polarizados temos de usar um novo referencial que esteja a rodar com a
%mesma frequencia de miu, para que possamos considerar miu estático neste
%referencial. Como consequencia, o M0 também vai ser estático neste
%referencial e orientado seugndo B0.

M0=[0; 0; 1]; %Vetor unitário estático de magnetização

%% Question 2: EXCITAÇÃO (Mxy>0) COM B1 SEGUNDO +X E FLIP ANGLE: 90º

% 'The basic unit for angles in MATLAB® is the radian.'
theta = 90*(pi/180);

%Duração da excitação 15ms = 15*10^-3 s
T = 15*10^-3;

%Time Step da excitação 0.1 ms = 0.1*10^-3 s
step = 0.1*10^-3;

% Matriz onde estão guardados os valores de Mx, My e Mz ao longo de todos
% os incrementos de ângulo
Mxyz = zeros(3, T/step);

% Incremento de ângulos: x = tempo total / time step e y = 90/x . 
x = T/step;

%Preencher a matriz Mxyz. Número de iterações é o nr de colunas da matriz
%que têm de ser preenchidas (todos os steps de 0 até 15ms)
for t = 0:T/step
    Mxyz(:,t+1)= [1 0 0; 0 cos(t*theta/x) sin(t*theta/x); 0 -sin(t*theta/x) cos(t*theta/x)]*M0;
end

Myz_norm=zeros(1,T/step);
for t = 0:T/step
    Myz_norm(1,t+1)=norm([Mxyz(1,t+1) Mxyz(2,t+1) Mxyz(3,t+1)]);
end

figure('Name', 'Q2 - Excitation by a 90º flip angle', 'NumberTitle','off');
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

%COMENTÁRIO:
%Quando começa a ser aplicado o campo variável B1 segundo x', ocorre uma rotação do
%vetor de magnetização (inicialmente M0 segundo z) em torno de x' até atingir o
%valor de 90º. Ao longo desta rotação, o vetor aumenta inicialmente de
%magnitude mas esta volta a diminuir, sendo que no fim da rotação a magnitude é igual a M0
%e o vetor tem a direção +y: My = M0 e Mz = 0.

%% Question 3: RELAXAÇÃO APÓS B1 SEGUNDO +X E FLIP ANGLE: 90º

%Duração da observação da relaxação 1000ms = 1s
Trel = 1;

%O vetor de magnetização está agora todo sobre o eixo y porque sofreu uma
%rotação de 90º. Assim My = M0.
M0_rel = [0; 1; 0];

% Matriz onde estarão guardados os valores de Mx, My e Mz ao longo de
% processo de relaxação
Mxyz_rel = zeros(3, Trel/step);

%Sabemos que as condições iniciais de Mxyz_rel são M0_rel
Mxyz_rel(:,1) = M0_rel;

%Preencher a matriz com as equações de relaxação 
T1 = 700*10^-3;
T2 = 70*10^-3;

for t = 1:Trel/step
   Mxyz_rel(:,t+1) = [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)] * Mxyz_rel(:,t) + [0; 0; (1-exp(-step/T1))] ;
end

figure('Name', 'Q3 - Relaxation after excitation by a 90º flip angle', 'NumberTitle','off');
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

%COMENTÁRIO:
%Quando o campo magnético B1 segundo +x deixa de ser aplicado, dá-se a
%relaxação (regresso ao equilíbrio), na qual My diminui à taxa de 1/T2
%até atingir o valor zero e Mz aumenta à taxa de 1/T1 até atingir M0.
%Uma vez que T1>T2 é normal que My diminua mais rápido do que Mz aumenta.
%Verifica-se ainda que 1 segundo não dá tempo suficiente para Mz atingir o
%valor de M0.

%% Question 4_A: EXCITAÇÃO COM B1 +X FLIP ANGLE: 30º

theta_4 = 30*(pi/180);

Mxyz_4 = zeros(3, T/step);
Myz_4_norm=zeros(1,T/step);
for t = 0:T/step
    Mxyz_4(:,t+1)= [1 0 0; 0 cos(t*theta_4/x) sin(t*theta_4/x); 0 -sin(t*theta_4/x) cos(t*theta_4/x)]*M0;
end

for t = 0:T/step
    Myz_4_norm(1,t+1)=norm([Mxyz_4(1,t+1) Mxyz_4(2,t+1) Mxyz_4(3,t+1)]);
end

figure('Name', 'Q4_A - Excitation by a 30º flip angle', 'NumberTitle','off');
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


%COMENTÁRIO:


%% Question 4_B: RELAXAÇÃO APÓS B1 +X FLIP ANGLE: 30º

%Duração da observação da relaxação 1000ms = 1s
Trel = 1;

% O vetor de magnetização, no início da relaxação, corresponde ao vetor de
% magnetização no fim da exitação.
M0_rel_4 = Mxyz_4(:,T/step);

% Matriz onde estarão guardados os valores de Mx, My e Mz ao longo de
% processo de relaxação
Mxyz_rel_4 = zeros(3, Trel/step);

%Sabemos que as condições iniciais de Mxyz_rel são M0_rel
Mxyz_rel_4(:,1) = M0_rel_4;

%Preencher a matriz com as equações de relaxação 
T1 = 700*10^-3;
T2 = 70*10^-3;

for t = 1:Trel/step
   Mxyz_rel_4(:,t+1) = [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)]*Mxyz_rel_4(:,t)+[0; 0; (1-exp(-step/T1))] ;
end

figure('Name', 'Q4_B - Relaxation after excitation by a 30º flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:500:size(Mxyz_rel_4,2)
point =[0 Mxyz_rel_4(2,j) 0];
point1=[0 0 Mxyz_rel_4(3,j)];
point2=[0,0,1];
%point3=[Mxyz_4(1,size(Mxyz_4,2)),Mxyz_4(2,size(Mxyz_4,2)),Mxyz_4(3,size(Mxyz_4,2))];  %NÃO SEI SE VALE A PENA TER ISTO AQUI!
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

%COMENTÁRIO:
%Assim como no caso anterior os vetore My e Mz começam a relaxar a partir
%dos respectivos valores no fim dos 15ms de excitação. No entanto, My<1 e
%Mz?0. Assim, Mz atinge o valor de 0 à mesma taxa mas ainda mais rapido por 
%ser mais pequeno e Mz vai crescer à mesma taxa mas atingir um valor mais
%próximo de M0 do que no caso inicial, por estar mais próximo deste valor
%no intante em que a relaxação começa.


%% Question 5: RELAXATION DURING EXCITATION PERIOD 

% Repeat for a 90° flip angle, but this time considering relaxation during the
% excitation period. 
% então usamos T = 1000 ms ???
% como sobrepor os dois acontecimentos? multiplicar matrizes?? O que eu
% penso: a cada time step (0.1ms) o vetor M0 "desce" segundo a função de
% sen/cos e "sobe" segundo a função exponencial. Como têm comportamentos
% diferentes (subida!=descida)vamos notar variações. Por isso SOMEI as
% contribuições.

% Duração da observação: 1s (que é o tempo maior) então vou usar a variável
% Trel
% Time step habitural: vou usar a variável step
% T1 e T2 definidos anteriormente
% Angulo: 90º - variável theta
% Vetor magnetização inicial é M0 = Mz (do equilíbrio)

T=15*(10^(-3));
% step=0.1*(10^(-3));

ang_it = theta / (T/step);

%nao sei se é suposto ter o exp(-step/T2) ou nao. alguem que me ajude a
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
title('5. Excitation + Relaxation of B1 along +x by 90º flip angle')
legend('Mx','My','Mz')
xlabel('Time [s]')
ylabel('Magnitude')

figure('Name', 'Q2 - Excitation by a 90º flip angle', 'NumberTitle','off');
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
%original da excitacao com o valor de 90º, conseguimos ver que esta,
%embora seja a mesma o fenomeno predominante, demora
%muito mais tempo e nao chega a ser completa (o MZ nao chega a zero nem os 90º sao atingidos).
% Isto porque a excitacao é um fenomeno muito mais rapido que a relaxacao.

