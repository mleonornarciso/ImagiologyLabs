% Lab 1 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 
%Raquel Araújo nr. 80843

%% Question 1

clear all; close all;

%"Generate the modified Shepp-Logan phantom with a 256x256 dimension 
%(using phantom)". 

% P = phantom(def, n) - generates an image of a head phantom that can be 
%used to test the numerical accuracy of radon and iradon or other two-dimensional 
%reconstruction algorithms. P is a grayscale intensity image that consists
%of one large ellipse (representing the brain) containing several smaller 
%ellipses (representing features in the brain).

% def specifies the type of head phantom to generate

Shepp_Logan = phantom('Modified Shepp-Logan',256);

figure;
imshow(Shepp_Logan);
title('Phantom Shepp-Logan');

%% Question 2

% "Simulate the sinogram obtained by collecting projections covering a 
% maximum of 180° in steps of 0.25° (using radon)."

angle = 0:180; %ou sera 0:180 ? 
sinograma = radon(Shepp_Logan, angle);

figure;
colormap gray;
imagesc(sinograma);
title('Sinograma Shepp-Logan');

%COMENTAR IMAGEM OBTIDA


%% Question 3

% "Simulate the associated reconstructed image using filtered backprojection 
%(using iradon)."

reconst = iradon(sinograma, angle);

%POR OS GRAFICOS BONITOS

figure;
subplot(1,2,1);
colormap gray;
imagesc(Shepp_Logan);
title('Shepp-Logan Original');

subplot(1,2,2);
colormap gray;
imagesc(reconst);
title('Shepp-Logan Reconstruido');

%COMENTAR COMPARAÇÃO: 

%Faixas na imagem - Numero finito de projecoes ?
%Possivel noise
%Streak artifacts (mas baixinhos)

%% Question 4

%"Repeat the simulations in 2. and 3. by: i) covering 360° (instead of 180°) 
%in steps of 0.25°; and ii) covering 180° in steps of 5° (instead of 0.25°). 
%Interpret the results. "


%% i) 360 º in steps of 0.25º



%% ii) 180 º in steps of 5º 





% COMENTAR RESULTADOS