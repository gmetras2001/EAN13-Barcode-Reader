clear all 
close all
[im,map]=imread('nutella.PNG');
size(im);
size(map);
subplot(2,2,1);
image(im);
ndg=0.3*im(:,:,1)+0.59*im(:,:,2)+0.11*im(:,:,3);
subplot(2,2,2);
image(ndg);
mapndg=([0:255]/255)'*[1 1 1];
colormap(mapndg);

%convolution(application d'un filtre)
NL=size(ndg,1);
NC=size(ndg,2);
ndg=double(ndg);
masque=[-3 -2 -1;0 0 0;1 2 1]';
imconv=zeros(NL,NC);
W=0.5;
offset=128;
for L=2:NL-1,
    for C=2:NC-1,
        imconv(L,C)=offset+sum(sum(masque.*ndg(L-1:L+1,C-1:C+1)))/W;
    end
end
subplot(2,2,3);
image(imconv)
colormap(mapndg)
%seuillage
barcode_bw_global = imbinarize(imconv,'global');
subplot(2,2,4), imshow(barcode_bw_global);
barcode_bw_global_adaptive = imbinarize(imconv,'adaptive');
figure(2), imshow(barcode_bw_global_adaptive);



