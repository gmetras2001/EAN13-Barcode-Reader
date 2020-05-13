clear all
close all
clc
%% Pr�-traitement %%

%recup�ration de l'image
[FILENAME, PATHNAME] = uigetfile('*.*');
i_rgb=imread(strcat(PATHNAME,FILENAME));
%addpath(genpath('barcode images'));
%i_rgb=imread('lait3.JPG');
%converision en nuance de gris
i_gray = rgb2gray(i_rgb);
% Filtrage morphologique top hat black (mise en �vidence du contraste)
se = strel('square',25);
i_black = imbothat(i_gray,se);
%augmentation du contraste
i_adjust = imadjust(i_black);
%conversion en noir et blanc
i_bw = imbinarize(i_adjust);

figure('Name','Pr�-traitement')
subplot(3,2,1)
    image(i_rgb)
    title('Image originale')
subplot(3,2,2)
    imshow(i_gray)
    title('Nuances de gris')
subplot(3,2,3)
    imshow(i_black)
    title('Filtre top hat black')
subplot(3,2,4)
    imshow(i_adjust)
    title('Augmentation du contraste')
subplot(3,2,5)
    imshow(i_bw)
    title('Noir et blanc')

%% Extraction du code barre %%
%% Filtrage des r�gions allong�es (rapport longeur/largeur des axes principaux > 10)

%num�rotation des r�gions connexes
[i_regions,n_regions] = bwlabel(i_bw,4);
%calcul des param�tres g�om�triques des r�gions
stats1 = regionprops(i_regions,'MinorAxisLength','MajorAxisLength');

d=zeros(length(stats1));
%pour chaque r�gion d'indice k
for k=1:length(stats1)
    if (stats1(k).MajorAxisLength/stats1(k).MinorAxisLength) > 5
        d(k)=k;
    end
end
e=d~=0;
idx_regions_allongees = d(e);

%creation d'une image noir et blanc avec les r�gions allong�es uniquement
i_regions_allongees = ismember(i_regions,idx_regions_allongees);
%num�rotation des r�gions allong�es
i_regions_allongees_num = bwlabel(i_regions_allongees);
stats2=regionprops(i_regions_allongees_num,'Centroid','Orientation');

%% Filtrage des r�gions de meme orientation
orientation_identique=zeros(length(stats2));
a=zeros(1,length(stats2));
for i=1:length(stats2)
    for j=1:length(stats2)
        if isSameOrientation(stats2(i).Orientation,stats2(j).Orientation)
            orientation_identique(i,j) = 1;
        end
    end
    a(i)=sum(orientation_identique(i,:));
end
ligne=1;
for i=2:length(a)
    if a(i)>a(ligne)
        ligne=i;
    end
end
b=zeros(length(orientation_identique));
for i=1:length(orientation_identique)
    if orientation_identique(ligne,i)
        b(i)=i;
    end
end
c=b~=0;
idx_orientation_identique = b(c);
%creation d'une image noir et blanc avec les r�gions allong�es de meme orientation
%uniquement
i_regions_orientation_identique = ismember(i_regions_allongees_num,idx_orientation_identique);
%num�rotation des r�gions de meme orientation
i_regions_orientation_identique_num = bwlabel(i_regions_orientation_identique);
stats3=regionprops(i_regions_orientation_identique_num,'Centroid','Orientation');



%% Filtrage des r�gions poss�dant des r�gions voisines proches

Distance=zeros(1,length(stats3));
Taille=size(i_rgb);
DimensionIm=Taille(1,1);

for i=1:length(stats3)
    disp(i)
    Position_i=stats3(i).Centroid;
    voisins=DimensionIm*ones(1,5); %On cherche les 5 voisins les plus proches
    
    for j=1:length(stats3)
        dist=DimensionIm;
        if i~=j
            Position_j=stats3(j).Centroid;
            dist=sqrt((Position_i (1,1)-Position_j (1,1))^2 + (Position_i (1,2)-Position_j (1,2))^2);

            if(dist<voisins(1,5))
                voisins(1,5)=dist;
                voisins=sort(voisins);               
            end
            
        end
            
    end
    
Distance(1,i)=sum(voisins);
    
end

Minimum=min(Distance);
idx=[];

for i=1:length(Distance)
    if Distance(i)<2.25*Minimum   %Le 2.25 est d�termin� exp�rimentalement. Pour une valeur inf�rieure on commence � supprimer les barres ext�rieures du code
    idx=[idx i];
    end
end

i_regions_voisines = ismember(i_regions_orientation_identique_num,idx);
%num�rotation des r�gions de meme orientation
i_regions_voisines_num = bwlabel(i_regions_voisines);
stats4=regionprops(i_regions_voisines_num,'Centroid','Orientation');


%Affichage des diff�rentes �tapes du pr�-traitement

figure('Name','Extraction des codes barrres')
subplot(2,2,1)
    imshow(i_regions);
    title('Image noir et blanc')
subplot(2,2,2)
    imshow(i_regions_allongees)
    title('Filtrage des r�gions allong�es')
    hold on
for k=1:length(stats2)
    txt=texlabel(num2str(k));
    text(stats2(k).Centroid(1),stats2(k).Centroid(2),txt,'Color','r')
end
subplot(2,2,3)
    imshow(i_regions_orientation_identique)
    title('Filtrage grace � l''orientation')
for k=1:length(stats3)
    txt=texlabel(num2str(k));
    text(stats3(k).Centroid(1),stats3(k).Centroid(2),txt,'Color','r')
end


subplot(2,2,4)
    imshow(i_regions_voisines)
    title('Filtrage grace � l''orientation')
for k=1:length(stats4)
    txt=texlabel(num2str(k));
    text(stats4(k).Centroid(1),stats4(k).Centroid(2),txt,'Color','r')
end
