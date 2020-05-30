clear all
close all
 
 [FILENAME, PATHNAME] = uigetfile('*.*');
i_rgb=imread(strcat(PATHNAME,FILENAME));
% addpath(genpath('barcode images'));
% i_rgb=imread('lait3.JPG');
%converision en nuance de gris
i_gray = rgb2gray(i_rgb);
% Filtrage morphologique top hat black (mise en �vidence du contraste)
se = strel('square',100);
i_black = imbothat(i_gray,se);
%augmentation du contraste
i_adjust = imadjust(i_black);
%conversion en noir et blanc
i_bw = imbinarize(i_adjust);

figure('Name','Pr�-traitement','NumberTitle','off')
subplot(4,2,1)
    image(i_rgb)
    title('Image originale')
subplot(4,2,2)
    imshow(i_gray)
    title('Nuances de gris')
subplot(4,2,3)
    imshow(i_black)
    title('Filtre top hat black')
subplot(4,2,4)
    imshow(i_adjust)
    title('Augmentation du contraste')
subplot(4,2,5)
    imhist(i_black)
    title('Histogramme sans contraste')
subplot(4,2,6)
    imhist(i_adjust)
    title('Histogramme avec contraste')
subplot(4,2,7)
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
%creation d'une image noir et blanc avec les r�gions voisines uniquement
i_regions_voisines = ismember(i_regions_orientation_identique_num,idx);

%%Filtrage sur les tailles
%A ce stade, il peut reste quelques barres issues de lettres d'un texte
%On propose de les �liminer en les comparant � la taille m�diane des
%r�gions restantes

stats1_2 = regionprops(i_regions_voisines,'MajorAxisLength','Centroid');
Med=[];
d=zeros(length(stats1_2));

for k=1:length(stats1_2)
    Med=[Med (stats1_2(k).MajorAxisLength)];
end
Med=median(Med); 
%La moyenne n'aurait ici pas d'int�ret, les petites barres la tirant vers le bas, il serait difficile de les filtrer
%Si le travail a �t� bien fait jusqu'ici, les r�gions restantes sont
%majoritairement celles du code-barres: la m�diane correspond � la taille
%d'une barre. (Elle pourrait aussi correspondre � une barre coup�e en deux,
%d'o� les marges �largies dans la boucle suivante.

for k=1:length(stats1_2)
    if (((stats1_2(k).MajorAxisLength)<3*Med)&&((stats1_2(k).MajorAxisLength)>Med/5))
        d(k)=k;       
    end
end

e=d~=0;
idx_regions_petites = d(e);

%creation d'une image noir et blanc avec les r�gions petites uniquement
i_regions_petites = ismember(i_regions_voisines,idx_regions_petites);
%num�rotation des r�gions du code-barres
i_regions_petites = bwlabel(i_regions_petites);


%% Calcul de la zone ou se trouve le code barre
box = findBoundingBox(i_regions_petites);

%% Affichage des diff�rentes �tapes de l'extraction du code barre

figure('Name','Extraction des codes barrres','NumberTitle','off')
subplot(2,2,1)
    imshow(i_regions);
    title('Image noir et blanc')
subplot(2,2,2)
    imshow(i_regions_allongees)
    title('Filtrage des r�gions allong�es')
%     hold on
% for k=1:length(stats2)
%     txt=texlabel(num2str(k));
%     text(stats2(k).Centroid(1),stats2(k).Centroid(2),txt,'Color','r')
% end
subplot(2,2,3)
    imshow(i_regions_orientation_identique)
    title('Filtrage gr�ce � l''orientation')
% for k=1:length(stats3)
%     txt=texlabel(num2str(k));
%     text(stats3(k).Centroid(1),stats3(k).Centroid(2),txt,'Color','r')
% end
subplot(2,2,4)
    imshow(i_regions_petites)
    title('Filtrage des r�gions voisines puis petites')
%     hold on
%     for k=1:length(stats1_2)
%     txt=texlabel(num2str(k));
%     text(stats1_2(k).Centroid(1),stats1_2(k).Centroid(2),txt,'Color','r')
%     end
    rectangle('Position',box,'EdgeColor','r')

%%Redressement des photos prises de biais
%barcode_rotate=redresse(imcrop(i_regions_voisines,box),stats3);


%% D�codage
validBarcode = 0;
l=1;

while l<4  
%Cette boucle permet d'essayer de d�chiffrer trois images diff�rentes:
%L'�tape de redressement peut cr�er des probl�mes lors de la projection:
%Si la premi�re barre est coup�e en deux, on ne consid�rera qu'une moiti�
%et la projection rendra le code illisible. 
%On essaie donc d'abord avec une image trait�e mais non redress�e.
%Puis avec une image regions_allongees redress�e et enfin avec une image
%regions_petites redress�e.  

if l==1
    %% S�lection de la zone ou se trouve le code barre
barcode_crop=imcrop(i_regions_voisines,box);
%%Rotation du code barre
angle_moy = stats3(1).Orientation+90;
        for i=2:length(stats3)
             angle_i = stats3(i).Orientation+90;
             if abs(angle_moy-angle_i)>90
                 angle_moy = mod((angle_moy+angle_i+180)/2,180);
             else
        angle_moy = (angle_moy+angle_i)/2;
             end
        end
angle_moy = 180-angle_moy;

barcode_rotate = imrotate(barcode_crop,angle_moy+180);
%les barres sont verticales mais elles peuvent �tre � l'envers
end

if l==2
    %%Redressement des photos prises de biais
    barcode_rotate=RedresseEtAffiche(imcrop(i_regions_petites,box),stats3,'Redressement sur image filtree au maximum');
end

if l==3
    %%Redressement des photos prises de biais
    barcode_rotate=RedresseEtAffiche(imcrop(i_regions_allongees,box),stats3,'Redressement sur image filtree avec les regions allongees seulement');
end


for i=1:size(barcode_rotate,1)
    disp('work in progress')
    %extraction d'une ligne
    ligne=extractLigne(i,barcode_rotate);

    %calcul le nombre de barres verticales
    numberOfBars=countBars(ligne);
    
    %tableau contenant la largeur des barres
    widthOfBars=findWidths2(ligne,numberOfBars);

    %donne l'indice de la premiere barre valide (k)
    %et de la derni�re barre valide (g)
    [k,g]=findValidBars(widthOfBars);
        
    if (numberOfBars-g-k)==57

        %calcul la largeur des barres �l�mentaires
        standardWidth1=(widthOfBars(k)+widthOfBars(k+1)+widthOfBars(k+2))/3;
        standardWidth2=(widthOfBars(k+27)+widthOfBars(k+28)+widthOfBars(k+29)+widthOfBars(k+30)+widthOfBars(k+31))/5;
        standardWidth3=(widthOfBars(k+56)+widthOfBars(k+57)+widthOfBars(k+58))/3;
    
        %applatissement du code barre et normalisation
        x1=[k+1, k+29, k+57];
        y1=[standardWidth1, standardWidth2, standardWidth3];
        p=polyfit(x1,y1,2);
    
        x=k:k+58;
    
        standardWidthOfBars(x)=round(widthOfBars(x)./polyval(p,x));
    
        %decodage du code barre
        [validBarcode,result]=decode(standardWidthOfBars,k);
    
        %verification de la validit� du code barre(chiffre de controle)
        if validBarcode
            disp(result)
            l=6;
            break;
        else
            [validBarcode,result]=decode(fliplr(standardWidthOfBars),1);
            if validBarcode
                disp(result)
                l=6;
                break;
            end
        end
    end
end
l=l+1;
end
