% Lab 5 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 79096
%Raquel Ara�jo nr. 80843

%% Question 1

%Ver folha


%% Variables

clear all;
close all;

% Longitudinal relaxation
T1=700*10^-3;

% Transverse relaxation
T2=70*10^-3;

% Time echo
TE=20*10^-3;

% Time repetition
TR=200*10^-3;

% Pulses
angle90 = 90*(pi/180);
angle180=180*(pi/180);


% Time Step da excita��o 1 ms = 1*10^-3 s
step = 1*10^-3;

% Equilibrium magnetization vector
M0=[0;0;1];

% Inicial magnetization after excitation
Minicial=[0;1;0];

%% ------------------------------ON RESONANCE - SPIN ECHO PULSE SEQUENCE ----------------------------------------------
%% Question 2  

%DUVIDA: se os spins estao on resonance, porque e que haveriamos de fazer
%um refocusing?

%Dura��o da relaxa��o= TR=200 ms - Ap�s este tempo � feita a aquisi��o
%Na spin echo pulse sequence, TE/2 ap�s o 90� RF pulse de excita��o � aplicado um
%180� RF pulse para spin refocusing. A aquisi��o � realizada em TE (quando ocorre o echo).

% Matriz onde estar�o guardados os valores de Mx, My e Mz ao longo de
% processo de relaxa��o
Mxyz_rel = zeros(3, TR/step);
% M_xy = zeros(1, TR/step);

%Sabemos que as condi��es iniciais de Mxyz_rel s�o M0_rel
Mxyz_rel(:,1) = Minicial;

%A cada T2/2 � feito um pulso de 180�, pelo que temos de o incluir na
%forma como evolui a magnetiza��o
pulse180=[1 0 0;0 cos(angle180) sin(angle180); 0 -sin(angle180) cos(angle180)];

%Vetor de instantes de tempo onde h� pulso de 180�
v_aux=(10*10^-3):TE:TR;

%Vetor tempos
time=0:step:TR-step;

%Preencher a matriz com as equa��es de relaxa��o 

for j =2:TR/step
   if time(j)==TE/2
      Mxyz_rel(:,j)=pulse180*Mxyz_rel(:,j-1);
   else
    Mxyz_rel(:,j) = [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)] * Mxyz_rel(:,j-1) + [0; 0; (1-exp(-step/T1))] ;
   end
end

figure('Name', 'Q2 - On resonance relaxation after excitation by a 90� flip angle', 'NumberTitle','off');
subplot(2,1,1)
for j=1:10:size(Mxyz_rel,2)
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
ylabel('Yrot'); ylim([-1.2,1.2]);
zlabel('Zrot'); zlim([0,1.2]);
end

subplot(2,1,2)
tempo_rel = (step:step:TR);
Mx_rel = Mxyz_rel (1,:);
My_rel = Mxyz_rel (2,:);
Mz_rel = Mxyz_rel (3,:);
plot (tempo_rel,Mx_rel,tempo_rel,My_rel,tempo_rel,Mz_rel)
legend('Mx','My','Mz');
xlabel('Time[s]');
ylabel('Magnitude');ylim([-1,1]);

%Na spin echo pulse sequence, ap�s excita��o com o pulso de 90�
%(Mxy=Minicial=[0 1 0]), inicia-se a relaxa��o: Diminui��o da magnitude My
%e aumento da magnitude Mz,sendo a segunda mais lenta.
%No entanto, no tempo TE/2 � aplicado o pulso RF de 180� em torno
%de x (spin refocusing), de forma a que, ap�s um novo TE/2 se possa adquirir o echo. 
%Assim, este pulso, por ser aplicado segundo x vai provocar uma rota��o de
%180� de My e Mz em torno deste eixo, prosseguindo depois a relaxa��o. 
%Uma vez que My decresce mais r�pido do que Mz cresce, este efeito � muito
%mais not�rio de My.

%% Question 3 - Complex transverse magnetization

% Mxy=Mx+iMy
 
for j=1:size(Mxyz_rel,2)
complexMatrix(1,j)=Mxyz_rel(1,j)+Mxyz_rel(2,j)*i;
end

amplitudeMatrix=abs(complexMatrix);
phaseMatrix=angle(complexMatrix)*180*(1/pi);

figure('Name', 'Q3 - On resonance complex transverse relaxation', 'NumberTitle','off');
subplot(2,1,1)
plot(tempo_rel,amplitudeMatrix);
title('Amplitude')

subplot(2,1,2)
plot(tempo_rel,phaseMatrix);
title('Phase(deg)')

% O mx � sempre zero por isso a magnetiza��o transversal complexa � sempre um n�mero imagin�rio com m�dulo
% igual a My. Inicialmente a amplitude � 90� e ap�s o pulos � de -90�.

%% -------------------------------OFF RESONANCE SPINS - SPIN ECHO PULSE SEQUENCE ----------------
% OFF RESONANCE - precession is not matched by the rotating frame, hence
% some precession remains in the rotating frame with frequency deltaw
% Off resonance: w(spin)?wL

%% Question 4

% Off resonance spins with delta w between -50 and +50 Hz in steps of 1 Hz
freqOR=-50:1:50; %Tamanho 101

%Matriz Mxyz_OR guarda o que a matriz Mxyz_rel j� tinha mas acrescenta
%uma terceira dimens�o, para guardar para os v�rios valores de frequencia.
%Mxyz_OR(axbxc) onde a corresponde aos valores tomados por Mx, My e Mz
%(a=3), b corresponde aos tempos (b=201) e c corresponde �s frequencias ()

for l=1:length(freqOR)
    phi=2*pi*freqOR(l)*step;
    Rz_resonance=[cos(phi) sin(phi) 0; -sin(phi) cos(phi) 0; 0 0 1];
    
    Mxyz_OR(:,1,l)=Minicial;    
    
    for j =2:TR/step
        if time(j)==TE/2
            Mxyz_OR(:,j,l)=pulse180*Mxyz_OR(:,j-1,l);
        else
            Mxyz_OR_prev= [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)] * Mxyz_OR(:,j-1,l) + [0; 0; (1-exp(-step/T1))] ;
            Mxyz_OR(:,j,l)=Rz_resonance*Mxyz_OR_prev; %Tenho de introduzir aqui a ressonancia em z
        end
    end
end

% For each time instant I want the mean of the spins
    Mxyz_mean(1,:)=sum(Mxyz_OR(1,:,:),3)/length(freqOR);
    Mxyz_mean(2,:)=sum(Mxyz_OR(2,:,:),3)/length(freqOR);
    Mxyz_mean(3,:)=sum(Mxyz_OR(3,:,:),3)/length(freqOR); 
% 
figure('Name', 'Q4 - Off resonance relaxation after excitation by a 90� flip angle', 'NumberTitle','off');
tempo_rel = (step:step:TR);
subplot(2,1,1);
plot (tempo_rel,Mxyz_mean(1,:)+ Mxyz_mean(2,:))
%abs( Mxyz_mean(1,:)+ Mxyz_mean(2,:)*1i
%tempo_rel,Mxyz_mean(1,:),tempo_rel,Mxyz_mean(2,:),tempo_rel,Mxyz_mean(3,:),
legend('Mxy');
xlabel('Time[s]');
ylabel('Magnitude');ylim([-1,1]);

subplot(2,1,2);
plot (tempo_rel,Mxyz_mean(1,:),tempo_rel,Mxyz_mean(2,:),tempo_rel,Mxyz_mean(3,:))
legend('Mx','My', 'Mz');
xlabel('Time[s]');
ylabel('Magnitude');ylim([-1,1]);



% Mxy=Mx+iMy
 
for j=1:size(Mxyz_rel,2)
complexMatrixOR(1,j)=Mxyz_mean(1,j)+Mxyz_mean(2,j)*i;
end

amplitudeMatrixOR=abs(complexMatrixOR);
phaseMatrixOR=angle(complexMatrixOR)*180*(1/pi);

%M_xy =amplitudeMatrixOR(1,:) + amplitudeMatrixOR(2,:);
% M_xy=mean(M_trans([1,2],:,:),3);
% M_xy=M_xy(1,:)+1i*M_xy(2,:); % Conversion to complex transverse magnetization
% Ampl_xy=abs(M_xy); 


figure('Name', 'Q4 - Off resonance complex transverse relaxation', 'NumberTitle','off');
subplot(2,1,1)
plot(tempo_rel,amplitudeMatrixOR)
title('Amplitude')

subplot(2,1,2)
plot(tempo_rel,phaseMatrixOR);
title('Phase(deg)')

%COMENT�RIO:


%% Question 5 - Repeat 4. for a multiple spin-echo with 3 echoes.

% Off resonance spins with delta w between -50 and +50 Hz in steps of 1 Hz
freqOR=-50:1:50; %Tamanho 101

%Matriz Mxyz_OR guarda o que a matriz Mxyz_rel j� tinha mas acrescenta
%uma terceira dimens�o, para guardar para os v�rios valores de frequencia.
%Mxyz_OR(axbxc) onde a corresponde aos valores tomados por Mx, My e Mz
%(a=3), b corresponde aos tempos (b=201) e c corresponde �s frequencias ()

for l=1:length(freqOR)
    phi=2*pi*freqOR(l)*step;
    Rz_resonance=[cos(phi) sin(phi) 0; -sin(phi) cos(phi) 0; 0 0 1];
    
    Mxyz_OR(:,1,l)=Minicial;    
    %3 ecos (varia de TE/2 em TE/2)
    for j =2:TR/step
        if time(j)==TE/2 | time(j)==(TE*3)/2 | time(j)==(TE*5)/2
            Mxyz_OR(:,j,l)=pulse180*Mxyz_OR(:,j-1,l);
        else
            Mxyz_OR_prev= [exp(-step/T2) 0 0; 0 exp(-step/T2) 0; 0 0 exp(-step/T1)] * Mxyz_OR(:,j-1,l) + [0; 0; (1-exp(-step/T1))] ;
            Mxyz_OR(:,j,l)=Rz_resonance*Mxyz_OR_prev; %Tenho de introduzir aqui a ressonancia em z
        end
    end
end

% For each time instant I want the mean of the spins
    Mxyz_mean(1,:)=sum(Mxyz_OR(1,:,:),3)/length(freqOR);
    Mxyz_mean(2,:)=sum(Mxyz_OR(2,:,:),3)/length(freqOR);
    Mxyz_mean(3,:)=sum(Mxyz_OR(3,:,:),3)/length(freqOR); 
% 
figure('Name', 'Q5 - Multiple spin echo (3 echos)', 'NumberTitle','off');
tempo_rel = (step:step:TR);
plot (tempo_rel,Mxyz_mean(1,:),tempo_rel,Mxyz_mean(2,:),tempo_rel,Mxyz_mean(3,:))
legend('Mx','My','Mz');
xlabel('Time[s]');
ylabel('Magnitude');ylim([-1,1]);

% Mxy=Mx+iMy
 
for j=1:size(Mxyz_rel,2)
complexMatrixOR(1,j)=Mxyz_mean(1,j)+Mxyz_mean(2,j)*i;
end

amplitudeMatrixOR=abs(complexMatrixOR);
phaseMatrixOR=angle(complexMatrixOR)*180*(1/pi);

figure('Name', 'Q5 - Off resonance complex transverse relaxation (3 echos)', 'NumberTitle','off');
subplot(2,1,1)
plot(tempo_rel,amplitudeMatrixOR);
title('Amplitude')

subplot(2,1,2)
plot(tempo_rel,phaseMatrixOR);
title('Phase(deg)')

%COMENT�RIO:
%FALTA ANALISAR GRAFICO


%% Question 6 - Determine the T2 of the sample using the data obtained in 5. 

%Fazer desenhozinho dos picos
%a partir do T2estrela fazemos samples do T2 no eco. 
%Varias maneiras de o fazer:
%findpic que deteta picos; fazer derivada? find max?

%Como temos os tempos exatos com os picos ocorrem, basta extrairmos os
%valores por ai

%buscar os valores a alinea anterior

M0_amp=1; %amplitude do M0
T2_teste=ones(1,3);
j=1;
for i=[1,2,3]
    
    T2_teste(j)=-(TE*i/log(amplitudeMatrixOR((TE*i)/step)/M0_amp));
    j=1+j;
    %reversed equation for relaxation of Transverse magnetization (T2)
end


% T2_teste_2=zeros(1,3);
% 
% peaks,pos=findpeaks(amplitudeMatrixOR);
% 
% j=1;
% for i=[1,3,5]
%     
%     T2_teste_2(j)=-(TE*i/2/log(amplitudeMatrixOR(peaks(j)/M0_amp)));
%     j=1+j;
%     %reversed equation for relaxation of Transverse magnetization (T2)
% end

disp(T2_teste)
disp(sum(T2_teste(1)+T2_teste(2)+T2_teste(3))/3);
%fazer uma mediazinha se calhar

%ARRAY_DAS_MAGNETIZACOES_MXY = Mxy

%T2 descreve a relaxacao da magnetizacao no plano xy
%a excitacao serve para por a magnetizacao no plano transversal para depois
%relaxar com T2
%varios pulsos de 180� fazem com que amostremos a curva de relaxacao de Mxy

%comparar com valor original do T2 = 70ms
