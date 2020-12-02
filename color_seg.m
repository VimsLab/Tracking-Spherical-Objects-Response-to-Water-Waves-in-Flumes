% img = imread('C2/Recording_2018-05-31_13_22_44_C2_138_2018-05-31_13-22-49.761.tif');
fileList = dir('C2/*.tif');

% numOfFiles = length(fileList);  % the folder in which ur images exists
 video = VideoWriter('video5.avi');
 open(video);


% READ THE AVI
v = VideoReader('trackertest.avi');
% GRAB A SINGLE FRAME
% currAxes = axes;

while hasFrame(v)
    vidFrame = readFrame(v);
    img = vidFrame;
    
    grayImg = rgb2gray(img);
    mask = grayImg < 200;  
       
    r = img(:, :, 1);
    g = img(:, :, 2);
    b = img(:, :, 3);
    justGreen = g - r/2 -b/2;
    bw = justGreen > 10;
    bw = bw & mask;
    se = strel('disk', 3);
    bw2 = imopen(bw, se);
    imshowpair(bw,bw2, 'montage')
    bw = im2double(bw2);
    for k = 1:3
       writeVideo(video, bw);  
    end
   
end


% for i = 1 : length(fileList)
%     filename = strcat('/home/yliu1/waveBall/C2/',fileList(i).name);
%     filename
%     img = imread(filename);
%     imagesc(img);
%     r = img(:, :, 1);
%     g = img(:, :, 2);
%     b = img(:, :, 3);
%     justGreen = g - r/2 -b/2;
%     bw = justGreen > 10;
%     bw = im2double(bw);
%     for k = 1:5
%        writeVideo(video,bw);  
%     end
% end
% 
close(video)

% 
% imagesc(img);
% r = img(:, :, 1);
% g = img(:, :, 2);
% b = img(:, :, 3);
% justGreen = g - r/2 -b/2;
% % justGreen = g./(g + r +b);
% 
% bw = justGreen > 10;
% imagesc(bw);