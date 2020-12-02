function [mask] = detectorMade(frame)
    img = frame;
    
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
    mask = bw2;

end