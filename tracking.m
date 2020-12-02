videoSource = VideoReader('trackertest.avi');
video = VideoWriter('videoTracking.avi');
open(video);
%  videoSource = vision.VideoFileReader('trackertest.avi',...
%     'ImageColorSpace','Intensity','VideoOutputDataType','uint8');
%  detector = vision.ForegroundDetector(...
%      'NumTrainingFrames', 10, ...
%      'InitialVariance', 50 * 50);


 
 blob = vision.BlobAnalysis(...
       'CentroidOutputPort', true, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 20);
      
      shapeInserter = vision.ShapeInserter('BorderColor','White');
      
      videoPlayer = vision.VideoPlayer();
      C = {};
      i = 1;
while hasFrame(videoSource)
     frame = readFrame(videoSource);
%      frame  = videoSource();
     fgMask = detectorMade(frame);
     [centroid,bbox]   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     writeVideo(video, out); 
     C{i} = centroid;
     videoPlayer(out); 
     i = i+1;
end

[~,num] = size(C);
A = [];
B = [];
for k = 1 : num
    tmp = C{1,k};
    A = [A;tmp(1,:)];
    [row, column] = size(tmp);
    if row > 1
    B = [B;tmp(2,:)];
    end
end

figure
plot(A)
figure
plot(B)
close(video)
release(videoPlayer);
% release(videoSource);