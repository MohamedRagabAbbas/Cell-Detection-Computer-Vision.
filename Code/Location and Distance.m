 
I = imread(['Linear_1.tif']); 

% Convert the image to grayscale using im2gray
grayImage = im2gray(I);

% Preprocessing step: Apply Gaussian smoothing for noise reduction
smoothedImage = imgaussfilt(grayImage, 1); % Adjust standard deviation as needed

% Define the range of radii for circle detection (adjust as needed)
radiusRange = [5, 8]; % Set the minimum and maximum radius for smaller circles

% Adjust sensitivity and edge threshold for smaller circles
sensitivity = 0.98; % Lower sensitivity for smaller circles
edgeThreshold = 0.1; % Lower edge threshold for smaller circles

% Perform circle detection using the Hough Transform with adjusted parameters on the original image
[centers, radii, metric] = imfindcircles(smoothedImage, radiusRange, ...
    'ObjectPolarity', 'bright', 'Sensitivity', sensitivity, 'EdgeThreshold', edgeThreshold);

% Create a folder to save the detected circles and figures
outputFolder = 'Linear_1';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end




% radii information
outputFile = fullfile(outputFolder, 'Linear_1.txt');
outputExcelFile = fullfile(outputFolder, 'Linear_1.xlsx');

fid = fopen(outputFile, 'w');
fprintf(fid, 'ImageName\tRadius\n');

data = cell(length(radii), 2);

for i = 1:length(radii)
    %information for each detected circle
    center = centers(i,:);
    radius = radii(i);
    
    [x, y] = meshgrid(1:size(smoothedImage, 2), 1:size(smoothedImage, 1));
    circleMask = (x - center(1)).^2 + (y - center(2)).^2 <= radius^2;
    
    circleImage = false(size(smoothedImage));
    circleImage(circleMask) = true;
    
    %Saving the circle image as a separate file in the folder
    circleFilename = sprintf('Cell%d.png', i);
    circleFilePath = fullfile(outputFolder, circleFilename);
    imwrite(circleImage, circleFilePath);
    
    %Saving radii information to a text file
    fprintf(fid, '%s\t%f\n', circleFilename, radius);
    
    data{i, 1} = circleFilename;
    data{i, 2} = radius;
end

fclose(fid);

% Saving  radii information to Excel file
columnNames = {'ImageName', 'Radius'};
dataTable = cell2table(data, 'VariableNames', columnNames);
writetable(dataTable, outputExcelFile);

% Perform additional processing to attempt separating closely located circles
separationImage = smoothedImage; % Modify this step based on your specific needs
separationImage = imclose(separationImage, strel('disk', 3)); % Adjust structuring element size

% Perform circle detection on the separated image
[centersSeparated, radiiSeparated, metricSeparated] = imfindcircles(separationImage, radiusRange, ...
    'ObjectPolarity', 'bright', 'Sensitivity', sensitivity, 'EdgeThreshold', edgeThreshold);




%to save the x, y coordinates of the detected circle centers

figure;
imshow(I);
viscircles(centers, radii,'EdgeColor','b'); 
title('Detected Circles (Original)');

figureFilePath = fullfile(outputFolder, 'Detected_Circles_Original.png');
saveas(gcf, figureFilePath);

%storing the x, y coordinates of circle centers
centersTable = table(centers(:, 1), centers(:, 2), 'VariableNames', {'X', 'Y'});

centersFile = fullfile(outputFolder, 'Circle_Centers.txt');
writetable(centersTable, centersFile, 'Delimiter', '\t');

centersExcelFile = fullfile(outputFolder, 'Circle_Centers.xlsx');
writetable(centersTable, centersExcelFile);

% original image with detected circles and their locations
figure;
imshow(I);
viscircles(centers, radii,'EdgeColor','b'); 

% the center of each detected circle is a red cross
hold on;
plot(centers(:, 1), centers(:, 2), 'rx', 'MarkerSize', 10); 

title('Detected Circles with Centers');

figureFilePathWithCenters = fullfile(outputFolder, 'Detected_Circles_With_Centers.png');
saveas(gcf, figureFilePathWithCenters);

% Distance between a random cell and all other cells
% Choose a random cell
randomIndex = randi(length(radii));
randomCellCenter = centers(randomIndex, :);

% distances between the random cell and other cells
distances = sqrt((centers(:, 1) - randomCellCenter(1)).^2 + (centers(:, 2) - randomCellCenter(2)).^2);

distancesTable = table(centers(:, 1), centers(:, 2), distances, 'VariableNames', {'X', 'Y', 'Distance'});
distancesExcelFile = fullfile(outputFolder, 'Distances_From_Random_Cell.xlsx');
writetable(distancesTable, distancesExcelFile);

disp('Distances from the random cell to other cells:');
disp(distances);

% color map visualization
figure;
scatter(centers(:, 1), centers(:, 2), 50, distances, 'filled');
colormap(jet);
colorbar;
hold on;
plot(randomCellCenter(1), randomCellCenter(2), 'rx', 'MarkerSize', 10); % Red cross for random cell
title('Distances from Random Cell to Other Cells');
xlabel('X Coordinate');
ylabel('Y Coordinate');

figureFilePathDistances = fullfile(outputFolder, 'Distances_From_Random_Cell.png');
saveas(gcf, figureFilePathDistances);
