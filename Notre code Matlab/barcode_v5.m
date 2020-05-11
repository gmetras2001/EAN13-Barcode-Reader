clear all
close all
clc
%% Pr�-traitement %%

%recup�ration de l'image
[FILENAME, PATHNAME] = uigetfile('*.png');
i_rgb=imread(strcat(PATHNAME,FILENAME));
%converision en nuance de gris
i_gray = rgb2gray(i_rgb);
% ?ltrage morphologique top hat black (mise en �vidence du contraste
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

%num�rotation des r�gions connexes
[i_regions,n_regions] = bwlabel(i_bw,4);
%calcul des param�tres g�om�triques des r�gions
stats1 = regionprops(i_regions,'MinorAxisLength','MajorAxisLength');

%% Filtrage des r�gions allong�es (rapport longeur/largeur des axes principaux > 10)
idx_regions_allongees=[]; %indice des r�gions allong�es
%pour chaque r�gion d'indice k
for k=1:length(stats1)
    if (stats1(k).MajorAxisLength/stats1(k).MinorAxisLength) > 10
        idx_regions_allongees = [idx_regions_allongees k];
    end
end
%creation d'une image noir et blanc avec les r�gions allong�es uniquement
i_regions_allongees = ismember(i_regions,idx_regions_allongees);
%num�rotation des r�gions allong�es
i_regions_allongees_num = bwlabel(i_regions_allongees);
stats2=regionprops(i_regions_allongees_num,'Centroid','Orientation');

%% Associer des r�gions allong�es pour constituer des zones scuceptibles d'�tre des codes barres
%orientation des barres (recherche de barres parrall�les)
%     idx_regions_orientation_identique = [];
%     orientation_moy = 90+stats2(1).Orientation; 
%     for k=1:length(stats2)
%         current_orientation=90+stats2(k).Orientation;
%         if abs(current_orientation-orientation_moy)<5
%             idx_regions_orientation_identique = [idx_regions_orientation_identique k];
%             orientation_moy=(orientation_moy+current_orientation)/2;
%         elseif abs(current_orientation-orientation_moy)>175
%             idx_regions_orientation_identique = [idx_regions_orientation_identique k];
%             orientation_moy=(orientation_moy+current_orientation+180)/2;
%         end
%     end
    
% for i=1:length(stats2)
%     for j=1:length(stats2)
%         if isSameOrientation(stats2(j).Orientation,stats2(i).Orientation)
%             
%         end
%     end
% end

figure('Name','Extraction des codes barrres')
subplot(2,2,1)
    imshow(i_regions_allongees)
    hold on
for k=1:length(stats2)
    txt=texlabel(num2str(k));
    text(stats2(k).Centroid(1),stats2(k).Centroid(2),txt,'Color','r')
end

%distance des barycentres/distance moyenne entre les barres d�ja li�es ~=1

%% filtrage des zones
%possede plus de deux r�gions

%l'espacement moyen entre les r�gions est inf�rieur � 8 fois la largeur
%moyenne (minorAxisLength)

%envisag� la fusion de deux zones si les orientations de leurs r�gions est
%tr�s proches(identiques)

%Essayons de d�teriminer quelles sont les barres dont les voisins sont
%proches: les barres du code


Distance=zeros(1,length(stats2));
Taille=size(i_rgb);
DimensionIm=Taille(1,1);

for i=1:length(stats2)
    Position_i=stats2(i).Centroid;
    voisins=DimensionIm*ones(1,5); %On cherche les 5 voisins les plus proches
    
    for j=1:length(stats2)
        dist=DimensionIm;
        if i~=j
            Position_j=stats2.Centroid;
            dist=sqrt((Position_i (1,1)-Position_j (1,1))^2 + (Position_i (1,2)-Position_j (1,2))^2);
            
            if(dist<voisins(1,5))
                voisins(1,5)=dist;
                sort(voisins);
            end
            
        end
            
    end
    
Distance(1,i)=sum(voisins);
    
end

ValARetirer=length(stats2)-30;

while ValARetirer>0
val=max(Distance);
idx=find(Distance==val)
Distance(idx)=0;
ValARetirer=ValARetirer-length(idx);
end