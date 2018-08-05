% Lab 3 IMed

%Realizado por:
%Leonor Narciso nr. 81102
%Laura Sumares nr. 79096
%Raquel Araújo nr. 80843

%% Question 1

%Consider the FDG-PET imaging of the 2D phantom stored in fdg.mat, containing 
%a number of hot spots of different sizes, with FOV = 25.6 x 25.6 cm2, using 
%the following imaging parameters: focal distance D = 40 cm; number of 
%detectors in ring 720; and maximum number of coincidences per pair of detectors 2500.

%close all;
%clear all;

%load('fdg.mat');

figure('Name', 'Original', 'NumberTitle','off');
imshow(fdg,[]);
size_phantom = size(fdg);


%% Question 2

%2. Indicate what the following parameters of the projection imaging should be in this case:

%% a. Sensor geometry (planar vs. fanbeam, equilinear vs. equiangular)

%Fanbeam equiangular geometry

%'FanSensorGeometry' -- Positioning of sensors, specified as the value 'arc' 
%or 'line'. In the 'arc' geometry, sensors are spaced equally along a circular arc, 
%  as shown below. This is the default value.

%% b. Sensor spacing (º)

% 360º/720 = 0.5º entre os centros dos detetores

%'FanSensorSpacing' -- Positive real scalar specifying the spacing of the fan-beam 
%sensors. Interpretation of the value depends on the setting of 'FanSensorGeometry'. 
%If 'FanSensorGeometry' is set to 'arc' (the default), the value defines the angular 
%spacing in degrees. Default value is 1. If 'FanSensorGeometry' is 'line', the value 
%specifies the linear spacing. Default value is 1.

%% c. Effective “rotation” coverage (º)

% 360º  
%é que assim, aquilo não roda, mas tecnicamente cobre os 360º 

%% d. Effective “rotation” increment (º)

% 0.5º 

%'FanRotationIncrement' -- Positive real scalar specifying the increment of 
%the rotation angle of the fan-beam projections. Measured in degrees. Default value is 1.

%% e. Focal distance (in pixels)

% D = 40cm 
% FOV = 25.6 x 25.6 cm2
% 25,6 cm = 128 pixeis
% 1 pixel = 0.2cm 
% D = 200 pixeis

%% Question 3

%Simulate the sinogram and reconstructed PET image of the phantom by filtered 
%backprojection(using fanbeam and ifanbeam), first without and then with noise.
%Make sure to explicitly provide the parameters in 2. when running both fanbeam and
%ifanbeam, and to use the option OutputSize in ifanbeam to constrain the
%reconstructed image to have the same size as the phantom.


%% NO NOISE

[sinogram,Fpos,Fangles] = fanbeam(fdg, 200,'FanSensorGeometry', 'arc', 'FanSensorSpacing',0.5,'FanRotationIncrement',0.5);

figure('Name', 'Q3 - Sinogram and Reconstruction No Noise', 'NumberTitle','off');
subplot(1,2,1)
imshow(sinogram,[],'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
axis normal
title('Sinogram Without Noise');
xlabel('Rotation Angles (degrees)');
ylabel('Sensor Positions (degrees)');
colormap gray, colorbar;
  
recons = ifanbeam(sinogram,200,'FanSensorSpacing',0.5,'Outputsize',128,'FanRotationIncrement',0.5);

subplot(1,2,2)
imshow(recons,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction Without Noise');


%% WITH NOISE

nbMax=2500;

sinogram_nbMax=sinogram/(max(max(sinogram)))*nbMax;
sinogram_noise=imnoise(sinogram_nbMax*(10^-12),'poisson');

figure('Name', 'Q3 - Sinogram and Reconstruction with Noise', 'NumberTitle','off');
subplot(1,2,1)
imshow(sinogram_noise,[],'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
axis normal
title('Sinogram with Noise');
xlabel('Rotation Angles (degrees)');
ylabel('Sensor Positions (degrees)');
colormap gray, colorbar;

recons_noise = ifanbeam(sinogram_noise,200,'FanSensorSpacing',0.5,'Outputsize',128,'FanRotationIncrement',0.5);
subplot(1,2,2)
imshow(recons_noise,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction With Noise');


%% Question 4

%Define appropriate ROIs for the big, the medium and one of the small hotspots 
%(using roipoly).

% HOTSPOT Grande

% figure('Name', 'Q4 - Choose ROI_BIG', 'NumberTitle','off');
% imshow(fdg,[]);
% roi_BIG =roipoly; 

%% HOTSPOT Médio

% figure('Name', 'Q4 - Choose ROI_MEDIUM', 'NumberTitle','off');
% imshow(fdg,[]);
% roi_MEDIUM = roipoly;

%% HOTSPOT Pequeno

% figure('Name', 'Q4 - Choose ROI_SMALL', 'NumberTitle','off');
% imshow(fdg,[]);
% roi_SMALL = roipoly;

%% Question 5 

% Illustrate and quantify the partial volume effects (PVE’s) suffered by each hot spot by
% comparing their average intensities in the phantom (ground truth) and in the
% reconstructed image. Make sure to normalize both the phantom and the reconstructed
% image (to 1) so that the intensities are comparable between images.

% PHANTOM ORIGINAL

%Normalize the original phantom
fdg_norm=fdg./max(max(fdg));

roi_BIG_ori=fdg_norm(roi_BIG);
roi_MEDIUM_ori=fdg_norm(roi_MEDIUM);
roi_SMALL_ori=fdg_norm(roi_SMALL);

%Average intensities
mean_BIG_ori=mean(roi_BIG_ori)
mean_MEDIUM_ori=mean(roi_MEDIUM_ori)
mean_SMALL_ori=mean(roi_SMALL_ori)

% PHANTOM RECONSTRUCTED

%Normalize the reconstructed phantom
recons_norm=recons./max(max(recons));

roi_BIG_recons=recons_norm(roi_BIG);
roi_MEDIUM_recons=recons_norm(roi_MEDIUM);
roi_SMALL_recons=recons_norm(roi_SMALL);

%Average intensities
mean_BIG_recons=mean(roi_BIG_recons)
mean_MEDIUM_recons=mean(roi_MEDIUM_recons)
mean_SMALL_recons=mean(roi_SMALL_recons)

%RESULTS:
% mean_BIG_ori =1             % mean_BIG_recons = 0.8799
% mean_MEDIUM_ori =1          % mean_MEDIUM_recons = 0.7628
% mean_SMALL_ori =1           % mean_SMALL_recons = 0.6030

%COMENTÁRIO:
% Como seria de esperar, a média das intensidades do phantom inicial em
% todas as ROI é 1. No reconstruido isto já não se verifica porque nos
% pixeis à periferia da ROI/HOTSPOT, o valor deixa de ser 1 e passa a <1
% pois esse pixel inclui regiões tanto brancas como pretas e faz a média
% ponderada desses valores (blurred edges), o que leva a uma diminuição da
% média total das intensidades, em relação à original -> Quanto menor a
% intesidade média, maior o PVE.
%Além disso, a roi_BIG apresenta maior média, ou seja, menor PVE uma vez
%que é a que apresenta maior rácio entre pixeis pixeis de valor 1
%(completamente preenchidos de branco tal como na original)e pixeis de
%valor <1 (resultantes da reconstrução, que leva ao blurring das edges). Na
%roi_SMALL, é exatamente o contrário.

%% Question 6

% Repeat 3. by doubling the number of detectors in the ring, and then repeat 
% 5 in this case to show the impact on the PVEs.

%Nr of detectors=1440 
%'FanSensorSpacing'=0.25
%'FanRotationIncrement'=0.25

%% NO NOISE

figure('Name', 'Q6 - Reconstruction w/ double nr of detectors', 'NumberTitle','off');

subplot(1,2,1)
imshow(recons,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction Without Noise');

subplot(1,2,2)
[sinogram_doubleDet,Fpos,Fangles] = fanbeam(fdg, 200,'FanSensorGeometry', 'arc', 'FanSensorSpacing',0.25,'FanRotationIncrement',0.25);
recons_doubleDet = ifanbeam(sinogram_doubleDet,200,'FanSensorSpacing',0.25,'Outputsize',128,'FanRotationIncrement',0.25); %Foi necessário diminuir para metade o output size uma vez que temos o dobro das aquisições
imshow(recons_doubleDet,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction Without Noise w/ double nr of detectors');

% PVE

%Normalize the reconstructed phantom
recons_dd_norm=recons_doubleDet./max(max(recons_doubleDet));

roi_BIG_recons_dd=recons_dd_norm(roi_BIG);
roi_MEDIUM_recons_dd=recons_dd_norm(roi_MEDIUM);
roi_SMALL_recons_dd=recons_dd_norm(roi_SMALL);

%Average intensities
mean_BIG_recons_dd=mean(roi_BIG_recons_dd)
mean_MEDIUM_recons_dd=mean(roi_MEDIUM_recons_dd)
mean_SMALL_recons_dd=mean(roi_SMALL_recons_dd)

%% WITH NOISE

figure('Name', 'Q6 - Reconstruction w/ double nr of detectors and noise', 'NumberTitle','off');

subplot(1,2,1)
imshow(recons_noise,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction With Noise');

subplot(1,2,2)
[sinogram_doubleDet_noise,Fpos,Fangles] = fanbeam(fdg, 200,'FanSensorGeometry', 'arc', 'FanSensorSpacing',0.25,'FanRotationIncrement',0.25);
recons_doubleDet_noise = ifanbeam(sinogram_doubleDet_noise,200,'FanSensorSpacing',0.25,'Outputsize',128,'FanRotationIncrement',0.25);  %Foi necessário diminuir para metade o output size uma vez que temos o dobro das aquisições
imshow(recons_doubleDet_noise,[]); %,'XData',Fangles,'YData',Fpos,'InitialMagnification','fit');
title('Reconstruction With Noise w/ double nr of detectors');

% PVE

%Normalize the reconstructed phantom
recons_noisedd_norm=recons_doubleDet_noise./max(max(recons_doubleDet_noise));

roi_BIG_recons_noisedd=recons_noisedd_norm(roi_BIG);
roi_MEDIUM_recons_noisedd=recons_noisedd_norm(roi_MEDIUM);
roi_SMALL_recons_noisedd=recons_noisedd_norm(roi_SMALL);

%Average intensities
mean_BIG_recons_noisedd=mean(roi_BIG_recons_noisedd)
mean_MEDIUM_recons_noisedd=mean(roi_MEDIUM_recons_noisedd)
mean_SMALL_recons_noisedd=mean(roi_SMALL_recons_noisedd)


%COMENTÁRIO SOBRE QUALIDADE:
%Aumentando o número de detectores, seria de esperar que, com um aumento de
%informação, a reconstrução se aproximasse mais da imagem original. No
%entanto, isso não se verificou porque aumentando o numero de detectores
%aumenta-se o numero de coincidencias, não só verdadeiras como também
%falsas aleatórias e resultantes da dispersão. Assim, estas coincidências
%falsas contribuem para uma diminuição do NECR, ou seja, diminui o SNR.




