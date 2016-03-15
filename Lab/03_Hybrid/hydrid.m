%% Laboratorio 3 Visión artificial
% - Imágenes Híbridas -
% Juan Sebastían Díaz Boada
% Imágenes: María Alejandra Díaz y María Camila Segura

close all
clear all
delete 'Alejandra_Segura.jpg'
delete 'Camila_Diaz.jpg'
delete 'piramide_AS.jpg'
delete 'piramide_CD.jpg'
clc
%% Se importan las imágenes
cami=imread('cami.jpg');
aleja=imread('aleja.jpg');
%% Se crea el kernel gaussiano y se filtran las imagenes
% pasa bajas
h=fspecial('gaussian',100,9);
cami_filt=imfilter(cami,h);
aleja_filt=imfilter(aleja,h);
%% Se crean las imágenes pasa altas
aleja_alto=aleja-aleja_filt;
cami_alto=cami-cami_filt;
%% Se muestran las imagenes filtradas
figure;
subplot(2,2,1)
imshow(aleja_filt)
subplot(2,2,2)
imshow(cami_filt)
subplot(2,2,3)
imshow(aleja_alto)
subplot(2,2,4)
imshow(cami_alto)
%% Alejandra Segura
% Se suma el bajo de 'Camila' con el alto de 'Alejandra'
AS=aleja_alto+cami_filt;
% Se crea la pirámide de la suma
pAS=vis_hybrid_image(AS);
figure
imshow(AS)
figure
imshow(pAS)
% Se guardan las imagenes en formato jpg
imwrite(AS,'Alejandra_Segura.jpg')
imwrite(pAS,'piramide_AS.jpg')
%% Camila Diaz
% SE suma el bajo de 'Alejandra' con el alto de 'Camila'
CD=aleja_filt+cami_alto;
% Se crea la pirámide de la suma
pCD=vis_hybrid_image(CD);
figure
imshow(CD)
figure
imshow(pCD)
% Se guardan las imagenes en formato jpg
imwrite(pCD,'piramide_CD.jpg')
imwrite(CD,'Camila_Diaz.jpg')