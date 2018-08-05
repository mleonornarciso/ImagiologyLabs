% Lab 7 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 79096
%Raquel Araújo nr. 80843

%%
clear all;
close all;

cd 'C:\Users\mleon\Desktop\4º Ano 2º Semestre\Imagiologia Médica\Lab 7'

%% Question 1
% Display the magnitude and phase of the 2D k-space data

data_loaded = load('rawdata.mat'); 
%data_loaded é uma estrutura, temos de aceder a matriz interior - o raw
%data

%Variaveis
data = data_loaded.rawdata;
size_data = size(data);
size_lin = size_data(1);
size_col = size_data(2);
magnitude = abs(data);
phase = angle(data);

%Visualizacao da fase e magnitude
figure('Name', 'Q1 - Magnitude and Phase', 'NumberTitle','off');
subplot(2,1,1)
imshow(magnitude);
imcontrast();

subplot(2,1,2)
imshow(phase,[]);

%ao ajustar o contraste da primeira imagem, conseguimos ver com clareza que
%as frequencias baixas estao localizadas no centro e, a medida que
%caminhamos para a fronteira da imagem, mais as frequencias aumentam.

%% Question 2
%Reconstruct the image by Fourier transform 

%k space: espaco das frequencias espaciais

recons_data = fftshift(ifft2(data));

figure('Name', 'Q2 - Reconstrucao por Transformada de Fourier', 'NumberTitle','off');
imshow(recons_data,[]);


%% Question 3

%Display the magnitude and phase of the reconstructed image.

%calcular a magnitude e fase da reconstrucao
mag_recons = abs(recons_data);
phase_recons = angle(recons_data);

%visualizacao da reconstrucao
figure('Name', 'Q3 - Fase e Magnitude da Reconstrucao', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_recons,[])

subplot (2,1,2)
imshow(phase_recons,[])

%comparar com original?

%% Question 4 
% Assign one of the image dimensions to the readout direction and the other
%to the phaseencoding direction

%gradient y para o phase encoding / frequency encoding
%gradient x para o readout 

%fiz assim porque foi como a professora disse na aula
%se alguem tiver uma melhor explicacao, fico muito agradecida!

%% Question 5
% Repeat 1-3, by truncating the k-space data (i.e., reducing kmax and leaving ?k
%unchanged), by one half, one fourth and one eighth, along the phase-encoding direction.

%along the phase enconding direction = y direction
%queremos apenas apanhar a parte central do k space


%% 1/2

k_truncado_1_2 = data((size_lin/2-size_lin*0.5+1):(size_lin/2+size_lin*0.5),:);
mag_1_2 = abs(k_truncado_1_2);
phase_1_2 = angle(k_truncado_1_2);
recons_1_2 = fftshift(ifft2(k_truncado_1_2));
mag_recons_1_2 = abs(recons_1_2);
phase_recons_1_2 = angle(recons_1_2);

%Visualizacao da Repeticao da 1
figure('Name', 'Q5 - Repeticao da 1: Magnitude and Phase (Reducao de 1/2)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_1_2,[]);
imcontrast();

subplot(2,1,2)
imshow(phase_1_2,[]);

%Visualizacao da repeticao da 2
figure('Name', 'Q5 - Repeticao da 2: Reconstrucao(Reducao de 1/2)', 'NumberTitle','off');
imshow(recons_1_2,[]);

%Visualizacao da Repeticao da 3
figure('Name', 'Q5 - Repeticao da 3: Fase e Magnitude da Reconstrucao (Reducao de 1/2)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_recons_1_2,[])

subplot (2,1,2)
imshow(phase_recons_1_2,[])

%% 1/4

k_truncado_1_4 = data((size_lin/2-size_lin*0.25+1):(size_lin/2+size_lin*0.25),:);
mag_1_4 = abs(k_truncado_1_4);
phase_1_4 = angle(k_truncado_1_4);
recons_1_4 = fftshift(ifft2(k_truncado_1_4));
mag_recons_1_4 = abs(recons_1_4);
phase_recons_1_4 = angle(recons_1_4);

%Visualizacao da Repeticao da 1
figure('Name', 'Q5 - Repeticao da 1: Magnitude and Phase (Reducao de 1/4)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_1_4,[]);
imcontrast();

subplot(2,1,2)
imshow(phase_1_4,[]);

%Visualizacao da repeticao da 2
figure('Name', 'Q5 - Repeticao da 2: Reconstrucao(Reducao de 1/4)', 'NumberTitle','off');
imshow(recons_1_4,[]);

%Visualizacao da Repeticao da 3
figure('Name', 'Q5 - Repeticao da 3: Fase e Magnitude da Reconstrucao (Reducao de 1/4)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_recons_1_4,[])

subplot (2,1,2)
imshow(phase_recons_1_4,[])

%% 1/8

k_truncado_1_8 = data((size_lin/2-size_lin*0.125+1):(size_lin/2+size_lin*0.125),:);
mag_1_8 = abs(k_truncado_1_8);
phase_1_8 = angle(k_truncado_1_8);
recons_1_8 = fftshift(ifft2(k_truncado_1_8));
mag_recons_1_8 = abs(recons_1_8);
phase_recons_1_8 = angle(recons_1_8);

%Visualizacao da Repeticao da 1
figure('Name', 'Q5 - Repeticao da 1: Magnitude and Phase (Reducao de 1/8)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_1_8,[]);
imcontrast();

subplot(2,1,2)
imshow(phase_1_8,[]);

%Visualizacao da repeticao da 2
figure('Name', 'Q5 - Repeticao da 2: Reconstrucao(Reducao de 1/8)', 'NumberTitle','off');
imshow(recons_1_8,[]);

%Visualizacao da Repeticao da 3
figure('Name', 'Q5 - Repeticao da 3: Fase e Magnitude da Reconstrucao (Reducao de 1/8)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_recons_1_8,[])

subplot (2,1,2)
imshow(phase_recons_1_8,[])

%Falta: fazer plots de comparacao destes resultados com os anteriores
%% Explicacao

%A frequencia espacial e tanto melhor quanto mais frequencias altas tenho.
%visto que as frequencias mais baixas estao no centro, a medida que vamos
%caminhando para um kmax, vamos apanhando frequencias mais altas e
%melhorando a nossa resolucao. Quando mais longe estiver este kmax, mais
%frequencias altas vamos apanhar e melhor resolucao espacial teremos.
%maior kmax, melhor resolucao espacial. Isto porque um maior kmax implica
%maior tempo de aquisicao ou fazer mais passos.

%tambem temos frequencias negativas, mas o que interessa e o valor absoluto
%das frequencias 

%% Question 6
% Repeat 1-3, by under-sampling the k-space data (i.e., leaving kmax unchanged 
% and increasing ?k) by half along the phase-encoding direction

%simulacao do undersampling fazendo o passo de 2 em 2 
k_undersampling  = data( 1:2:end ,:);
mag_undersampling = abs(k_undersampling);
phase_undersampling = angle(k_undersampling);
recons_undersampling = fftshift(ifft2(k_undersampling));
mag_recons_undersampling = abs(recons_undersampling);
phase_recons_undersampling = angle(recons_undersampling);

%Visualizacao da Repeticao da 1
figure('Name', 'Q6 - Repeticao da 1: Magnitude and Phase (undersampling)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_undersampling,[]);
imcontrast();

subplot(2,1,2)
imshow(phase_undersampling,[]);

%Visualizacao da repeticao da 2
figure('Name', 'Q6 - Repeticao da 2: Reconstrucao(undersampling)', 'NumberTitle','off');
imshow(recons_undersampling,[]);

%Visualizacao da Repeticao da 3
figure('Name', 'Q6 - Repeticao da 3: Fase e Magnitude da Reconstrucao (undersampling)', 'NumberTitle','off');
subplot(2,1,1)
imshow(mag_recons_undersampling,[])

subplot (2,1,2)
imshow(phase_recons_undersampling,[])

%se o ?k numa dada direcao for aumentado, o FOV diminui (por causa da formula).
%Isto pode ser problematico porque podemos nao ver uma determinada zona (e.g. torax)

%frequencia de nyquist nao for respeitada - vou ter aliasing
%wrap around

%% Question 7

%% Question 8
