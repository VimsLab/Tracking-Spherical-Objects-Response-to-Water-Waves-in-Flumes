function [ video , A , B , C , timestamp] = perform_tracking_tiffs_v3( input_tiff_dir , output_video)
%function [ video , A , B , C , timestamp] = perform_tracking_tiffs( input_tiff_dir , output_video , y1 , y2 )

fileList = dir([input_tiff_dir '\*.tif']);
video = VideoWriter(output_video);
%set(video, 'Visible', 'off');
open(video);
%  videoSource = vision.VideoFileReader('trackertest.avi',...
%     'ImageColorSpace','Intensity','VideoOutputDataType','uint8');
%  detector = vision.ForegroundDetector(...
%      'NumTrainingFrames', 10, ...
%      'InitialVariance', 50 * 50);


 
 blob = vision.BlobAnalysis(...
       'CentroidOutputPort', true, 'AreaOutputPort', true, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 200);
                                                            %200 is pretty
                                                            %good
   videoPlayer = vision.VideoPlayer('Position',[80,75,1425,700]);
      C = {};
      i = 1;
      timestamp=[];
      
      kalmanFilter = []; isTrackInitialized = false;
tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track


      
for i=1:length(fileList)
    
     imInf = imfinfo([input_tiff_dir '\' fileList(i).name]);
     timestamp = [timestamp; datetime(imInf.Filename(end-26:end-4),'InputFormat','yyyy-MM-dd_HH-mm-ss.SSS')];
     
     frame = imread([input_tiff_dir '\' fileList(i).name]);
     
     
%      frame  = videoSource();
     %fgMask = detectorMade_cropped(frame,y1,y2);
     
     
     fgMask = detectorMade(frame);

     [area,centroids,bboxes]   = step(blob,fgMask);
     
     predictNewLocationsOfTracks();
     
     [assignments, unassignedTracks, unassignedDetections] = ...
      detectionToTrackAssignment();
     
% %      %shapeInserter = vision.ShapeInserter('BorderColor','White','Shape','Circles');
% %      isObjectDetected = size(centroid, 1) > 0;
% %      if ~isTrackInitialized
% %         if isObjectDetected % First detection.
% %             kalmanFilter = configureKalmanFilter('ConstantAcceleration', ...
% %             centroid(1,:), [1 1 1]*1e5, [25, 10, 10], 25);
% %             isTrackInitialized = true;
% %         end
% %         
% %      label = ''; circle = zeros(0,3); % initialize annotation properties
% %      else  % A track was initialized and therefore Kalman filter exists
% %         if isObjectDetected % Object was detected
% %           % Reduce the measurement noise by calling predict, then correct
% %           predict(kalmanFilter);
% %           trackedLocation = correct(kalmanFilter, centroid(1,:));
% %           label = 'Corrected';
% %         else % Object is missing
% %           trackedLocation = predict(kalmanFilter);  % Predict object location
% %           label = 'Predicted';
% %         end
% %         circle = [trackedLocation, 5];
% %         C{i} = trackedLocation;
% %      end
% %      colorImage = insertObjectAnnotation(frame, 'circle', ...
% %         circle, label, 'Color', 'red'); % mark the tracked object
% %      step(videoPlayer, colorImage);    % play video
% %     %end % while 
        
     
  %  shapeInserter = vision.ShapeInserter('BorderColor','White');
     
     


     %out    = step(shapeInserter,frame,int32([centroid ones(length(centroid(:,1)),1)*10])); %trying to insert circles 
    %out    = step(shapeInserter,frame,colorImage);
    updateAssignedTracks();
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks();
    
    
    displayTrackingResults();
    
    
     writeVideo(video, colorImage);
   %  C{i} = centroid;


   %  step(videoPlayer,out); 
     i = i+1;
end
close(video)
release(videoPlayer);
% release(videoSource);

% Determine centroid for plotting trajectory:
[~,num] = size(C);
A = nan*ones(num,2);
B = nan*ones(num,2);

for k = 1 : num

    tmp = C{1,k};
    [tmp2,~] = size(C{1,k});
    if isempty(tmp)
        tmp = [nan nan; nan nan]; %in the case no centroids are detected
    elseif length(C{1,k})>2 | tmp2<2
        tmp = [nan nan; nan nan]; %in case more than 2 centroids are detected
    else
        A(k,:) = tmp(1,:); %grab the 1st centroid detected
        [row, ~] = size(tmp);
        if row > 1
            B(k,:) = tmp(2,:); %grab the 2nd centroid detected
        end
    
%         if row <= 1
%             B = [B; nan nan];
%         end
    end
end

% figure
% plot(A)
% figure
% plot(B)

end