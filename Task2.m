%Team 12 - Jakub Gałąska, Karol Michalik

clc
clear all
close all
%%--------------------INPUT-----------------------
load('Task_2_Training_Dataset.mat')
data = Task_2_Training_Data;
%%------------------------------------------------
saveToFile = struct2cell(data)';
Array = vertcat(data.BoundingBox);
Photo = struct2cell(data);
Photo = Photo(1,:);
for i = 1:1:size(Photo,2)-120
img = imread(char(Photo(i)));

I = rgb2hsv(img);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.080;
channel1Max = 0.180;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.300;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.100;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = img;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;


[BW_out] = bwareaopen(BW,100);
se_X = strel('line',8,0);
se_y = strel('line',8,90);
BW_out_dilate = imdilate(BW_out,se_X);
BW_out_dilate = imdilate(BW_out_dilate,se_y);
BW_out = BW_out_dilate;
stat = regionprops(BW_out);
biggest_area = 0;

for x = 1: numel(stat)
    center_x = round(stat(x).Centroid(1));
    center_y = round(stat(x).Centroid(2));

    vert_line = BW_out(:,center_x);
    vert_line_1 = vert_line(center_y:end);
    przekatna_vert_1 =find(vert_line_1 == 0, 1);
    vert_line_2 = flip(vert_line(1:center_y));
    przekatna_vert_2 = find(vert_line_2 == 0, 1);
    vert_rozmiar = przekatna_vert_1+przekatna_vert_2-3;

    horz_line = BW_out(center_y,:);
    horz_line_1 = horz_line(center_x:end);
    przekatna_horz_1 =find(horz_line_1 == 0, 1);
    horz_line_2 = flip(horz_line(1:center_x));
    przekatna_horz_2 = find(horz_line_2 == 0, 1);
    horz_rozmiar = przekatna_horz_1+przekatna_horz_2-3;

    if ~isempty(horz_rozmiar) && ~isempty(vert_rozmiar)
    if ((vert_rozmiar>=0) && (horz_rozmiar>=0))
    blad = abs(horz_rozmiar - vert_rozmiar)/vert_rozmiar*100;
    if blad <= 10
    %plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
    if stat(x).Area >= biggest_area
    biggest_area = stat(x).Area; 
    x_cord = stat(x).Centroid(1) - round(horz_rozmiar*1.4/2);
    y_cord = stat(x).Centroid(2) - round(vert_rozmiar*1.4/2);
    width = horz_rozmiar*1.4;
    height = vert_rozmiar*1.4;   
    end
    end
    end
    end
end
BoundingBox = [x_cord,y_cord,width,height];
saveToFile(i,2) = (num2cell(BoundingBox,2));
end
%%
saveToFile = struct('Image',saveToFile(:,1),'BoundingBox',saveToFile(:,2));
save("Task_2_Team_12.mat","saveToFile");
a=1
