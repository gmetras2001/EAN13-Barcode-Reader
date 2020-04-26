clear; clc;

%% Select the image
Barcode = imread('288391.jpg'); % 288391.jpg

%% Display the original image
figure(1);
imshow(Barcode);
title('Original Picture');

%% Convert the image into grayscale. 
% The purpose is to reduce the noise in the picture
% and give higher contrast so that information in the
% picture can be read easily.
Barcode = rgb2gray(Barcode);


%% Apply thresholding method to generate a binarized sequence
% We need to decode barcode information to a binarized sequence
% to be able to read the information inside barcode. 

% To find the right level of black or white intensity in the thresholded 
% image. The level range is [0,1], so graytresh find an intermediate value 
% of the image where the blacks and whites can be differentiated at best
% in the image
Level = graythresh(Barcode);

%Thresholding
ThresholdBarcode=im2bw(Barcode,Level);

% Display the thresholded picture
figure(3) ;
imshow(ThresholdBarcode);
title('Thresholded Picture');

%% Finding the size M-N matrix in the barcode
% We will find out the number of rows and columns of the barcode's 
% thresholded image
BarcodeSize = size(ThresholdBarcode);

% Find the # of rows and columns
RowNum = BarcodeSize(1); %y
ColumnNum = BarcodeSize(2); %x 

%% Refine the barcode.
% In each column, if the # of black pixels are more than # of white
% pixels, the entire column will be all black pixel, or vice versa.  
for i = 1:ColumnNum
    
    BlackCount = sum(ThresholdBarcode(:,i) == 0); % define black pixel 
    WhiteCount = sum(ThresholdBarcode(:,i) == 1); % define white pixel
    
    if BlackCount > WhiteCount % make black pixel column
        ThresholdBarcode(:,i) = 0; 
    else
        ThresholdBarcode(:,i) = 1; % make white pixel column
    end
end

% Print the refined barcode 
imshow(ThresholdBarcode);

%% Seperating the binary barcode into small arrays. 
% This for loop will check for pixel color in each column in the first row.
% When it finds a pixel color change, it will store the the pixels in the
% same color into one array. It will keep seperating them until all black
% and white lines are seperated from each other. 
k = 1; % a constant to to save where the column count was left from last
% count. 
z = 1; % a constant to increase the array number (A1, A2, A3, ...) 

for i = 1:ColumnNum - 1
    if ThresholdBarcode(:,i) ~= ThresholdBarcode(:,i+1) % When pixel color
        % changes, save the pixels in the same color to one array.
    eval(sprintf('A%d = [ThresholdBarcode(1,k+1:i)]',z )); % define the array
    k = i; % increment k 
    z = z + 1; % increment z 
    end
end

MatrixLength2 = 0; % The length of each array will be saved in this matrix
% to later find out average length. This will help us differentiating the 
% thick and thin lines. 

for i = 2: z-1
    MatrixLength = length(eval(sprintf('A%d',i))); % find the length of 
    % each array
    
    MatrixLength2 = [ MatrixLength2 MatrixLength]; % save the lengths into
    % MatrixLength2. 
end

AverageLength = mean(MatrixLength2); % Find the average length of arrays. 

NewMatrix2 = []; % This matrix will save all the defined characters of 
% each small A(i) arrays. 

%% Defining the b, B, w and W characters for A(i) arrays 
for i = 2:z-1
    if sum((eval(sprintf('A%d',i)))) == 0 && length(eval(sprintf('A%d',i))) <= AverageLength
        NewMatrix = 'b'; 
    elseif sum((eval(sprintf('A%d',i)))) == 0 && length(eval(sprintf('A%d',i))) > AverageLength
        NewMatrix = 'B';
    elseif sum((eval(sprintf('A%d',i)))) ~= 0 && length(eval(sprintf('A%d',i))) <= AverageLength
        NewMatrix = 'w';
    elseif sum((eval(sprintf('A%d',i)))) ~= 0 && length(eval(sprintf('A%d',i))) > AverageLength
        NewMatrix = 'W';
    end
    NewMatrix2 = [NewMatrix2 NewMatrix]; % Saving the output characters into one matrix
end

%% Translation of characters and finding the output. 
% This section will take 9 characters from NewMatrix2 and will check it
% in the if statement below to find out what character they match in the
% human language. Note that 9 characters together define one real
% character. 

l = 1; % to increment i after each run. 
Output = []; % Output matrix 
length(NewMatrix2(1:9)) 
length('bWbwBwBwb')
deltr = ['W','b','W','b','w','B','w','B','w','b'];
for i = 9: 10: z - 2
    s='erreur';
    if NewMatrix2(l:i) == 'bWbwBwBwb'
        s = 'deltr ';
    elseif NewMatrix2(l:i) == 'bwbWBwBwb'
        s = 'zero ';
    elseif NewMatrix2(l:i) == 'BwbWbwbwB'
        s = '1 ';
    elseif NewMatrix2(l:i) == 'bwBWbwbwB'
        s = '2 ';
    elseif NewMatrix2(l:i) == 'BwBWbwbwb'
        s = '3 ';
    elseif NewMatrix2(l:i) == 'bwbWBwbwB'
        s = '4 ';
    elseif NewMatrix2(l:i) == 'BwbWBwbwb'
        s = '5 ';
    elseif NewMatrix2(l:i) == 'bwBWBwbwb'
        s = '6 '; 
    elseif NewMatrix2(l:i) == 'bwbWbwBwB'
        s = '7 ';
    elseif NewMatrix2(l:i) == 'BwbWbwBwb'
        s = '8 ';
    elseif NewMatrix2(l:i) == 'bwBWbwBwb'
        s = '9 ';
    elseif NewMatrix2(l:i) == 'BwbwbWbwB'
        s = 'A ';
    elseif NewMatrix2(l:i) == 'bwBwbWbwB'
        s = 'B ';
    elseif NewMatrix2(l:i) == 'BwBwbWbwb'
        s = 'C ';
    elseif NewMatrix2(l:i) == 'bwbwBWbwB'
        s = 'D ';
    elseif NewMatrix2(l:i) == 'BwbwBWbwb'
        s = 'E ';
    elseif NewMatrix2(l:i) == 'bwBwBWbwb'
        s = 'F ';
    elseif NewMatrix2(l:i) == 'bwbwbWBwB'
        s = 'G ';
    elseif NewMatrix2(l:i) == 'BwbwbWBwb'
        s = 'H ';
    elseif NewMatrix2(l:i) == 'bwBwbWBwb'
        s = 'I ';
    elseif NewMatrix2(l:i) == 'bwbwBWBwb'
        s = 'J ';
    elseif NewMatrix2(l:i) == 'BwbwbwbWB'
        s = 'K ';
    elseif NewMatrix2(l:i) == 'bwBwbwbWB'
        s = 'L ';
    elseif NewMatrix2(l:i) == 'BwBwbwbWb'
        s = 'M ';
    elseif NewMatrix2(l:i) == 'bwbwBwbWB'
        s = 'N ';
    elseif NewMatrix2(l:i) == 'BwbwBwbWb'
        s = 'O ';
    elseif NewMatrix2(l:i) == 'bwBwBwbWb'
        s = 'P ';
    elseif NewMatrix2(l:i) == 'bwbwbwBWB'
        s = 'Q ';
    elseif NewMatrix2(l:i) == 'BwbwbwBWb'
        s = 'R ';
    elseif NewMatrix2(l:i) == 'bwBwbwBWb'
        s = 'S ';
    elseif NewMatrix2(l:i) == 'bwbwBwBWb'
        s = 'T ';
    elseif NewMatrix2(l:i) == 'BWbwbwbwB'
        s = 'U ';
    elseif NewMatrix2(l:i) == 'bWBwbwbwB'
        s = 'V ';
    elseif NewMatrix2(l:i) == 'BWBwbwbwb'
        s = 'W ';
    elseif NewMatrix2(l:i) == 'bWbwBwbwB'
        s = 'X ';
    elseif NewMatrix2(l:i) == 'BWbwBwbwb'
        s = 'Y ';
    elseif NewMatrix2(l:i) == 'bWBwBwbwb'
        s = 'Z ';
    elseif NewMatrix2(l:i) == 'bWbwbwBwB'
        s = 'Hyp ';
    elseif NewMatrix2(l:i) == 'BWbwbwBwb'
        s = 'Per ';
    elseif NewMatrix2(l:i) == 'bWBwbwBwb'
        s = 'Space ';
    elseif NewMatrix2(l:i) == 'bWbWbWbwb'
        s = 'Dollar ';
    elseif NewMatrix2(l:i) == 'bWbWbwbWb'
        s = 'Slash ';
    elseif NewMatrix2(l:i) == 'bWbwbWbWb'
        s = 'Plus ';
    elseif NewMatrix2(l:i) == 'bwbWbWbWb'
        s = 'Mod ';
    elseif NewMatrix2(l:i) == 'bWbwBwBwb'
        s = 'Ast '
    end
    l = i+2; % +2 is added to skip the small white line spacers between 
    % each character in the barcode picture. 
    Output = [Output s]; % add each output character right next to each other. 
end

Output % print out the output in command window. 
            