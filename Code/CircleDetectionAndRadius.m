 I = imread(['Linear_1.png']); 

%% Preparing the image
% Converting the image to grayscale
grayImage = im2gray(I);

% Noise Reduction using Gaussian smoothing
smoothedImage = imgaussfilt(grayImage, 1); % Adjust standard deviation as needed
%%
% the range of radii for circle detection 
radiusRange = [5, 6]; 
%% Obtimizing the accuricy of circle detection by Adjusting sensitivity and edge threshold 
sensitivity = 0.95; % Lower sensitivity for smaller circles
edgeThreshold = 0.1; % Lower edge threshold for smaller circles

% Performing circle detection using the Hough Transform with adjusted parameters on the original image
[centers, radii, metric] = imfindcircles(smoothedImage, radiusRange, ...
    'ObjectPolarity', 'bright', 'Sensitivity', sensitivity, 'EdgeThreshold', edgeThreshold);

% Create a folder to save the detected circles and figures
outputFolder = 'Linear_1';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Save each detected circle as a separate file and write radii information to a text file
outputFile = fullfile(outputFolder, 'Linear_1.txt');
outputExcelFile = fullfile(outputFolder, 'Linear_1.xlsx');

fid = fopen(outputFile, 'w');
fprintf(fid, 'ImageName\tRadius\n');

data = cell(length(radii), 2);

for i = 1:length(radii)
    % Extract information for each detected circle
    center = centers(i,:);
    radius = radii(i);
    
    % Create an image with only the current detected circle
    [x, y] = meshgrid(1:size(smoothedImage, 2), 1:size(smoothedImage, 1));
    circleMask = (x - center(1)).^2 + (y - center(2)).^2 <= radius^2;
    
    % Create an image with the current detected circle
    circleImage = false(size(smoothedImage));
    circleImage(circleMask) = true;
    
    % Save the circle image as a separate file in the folder
    circleFilename = sprintf('Cell%d.png', i);
    circleFilePath = fullfile(outputFolder, circleFilename);
    imwrite(circleImage, circleFilePath);
    
    % Write radii information to the text file
    fprintf(fid, '%s\t%f\n', circleFilename, radius);
    
    % Store data for Excel file
    data{i, 1} = circleFilename;
    data{i, 2} = radius;
end

fclose(fid);

% Write radii information to Excel file
columnNames = {'ImageName', 'Radius'};
dataTable = cell2table(data, 'VariableNames', columnNames);
writetable(dataTable, outputExcelFile);

% Perform additional processing to attempt separating closely located circles
separationImage = smoothedImage; % Modify this step based on your specific needs
separationImage = imclose(separationImage, strel('disk', 3)); % Adjust structuring element size

% Perform circle detection on the separated image
[centersSeparated, radiiSeparated, metricSeparated] = imfindcircles(separationImage, radiusRange, ...
    'ObjectPolarity', 'bright', 'Sensitivity', sensitivity, 'EdgeThreshold', edgeThreshold);

% Display the original image with detected circles
figure;
imshow(I);
viscircles(centers, radii,'EdgeColor','b'); % Display detected circles as blue circles
title('Detected Circles (Original)');

% Save the figure as an image in the same folder
figureFilePath = fullfile(outputFolder, 'Detected_Circles_Original.png');
saveas(gcf, figureFilePath);


