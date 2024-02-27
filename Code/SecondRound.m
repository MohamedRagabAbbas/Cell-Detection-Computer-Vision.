% Define the list of input images
inputImages = {'Linear_1.png', 'Linear_2.png', 'Branched_1.png', 'Branched_2.png', 'Network_1.png', 'Mixture.png'};

% Define patch size and overlap
patchSize = 100; % Change this value to set the patch size (e.g., 100x100)
overlap = 10; % Change this value to set the overlap amount

% Create a folder to save the cropped images
outputFolder = 'images';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Initialize counter for total number of images
totalCounter = 0;

% Process each input image
for imgIdx = 1:length(inputImages)
    % Read the current input image
    currentImage = imread(inputImages{imgIdx});
    
    % Get the size of the current image
    [rows, cols, ~] = size(currentImage);
    
    % Slide a window over the image to capture patches with overlap
    counter = 1;
    for i = 1:overlap:rows-patchSize+1
        for j = 1:overlap:cols-patchSize+1
            % Define the coordinates for cropping
            rowStart = i;
            rowEnd = i + patchSize - 1;
            colStart = j;
            colEnd = j + patchSize - 1;
            
            % Crop the image
            croppedImage = currentImage(rowStart:rowEnd, colStart:colEnd, :);
            
            % Save the cropped image
            imageName = sprintf('%s_patch_%d.png', inputImages{imgIdx}(1:end-4), counter);
            imwrite(croppedImage, fullfile(outputFolder, imageName), 'png'); % Specify the image format explicitly
            
            counter = counter + 1;
            totalCounter = totalCounter + 1;
            
            % Check if the desired number of images is generated
            if totalCounter >= 12000
                disp('Image splitting complete.');
                return;
            end
        end
    end
end

disp('Image splitting complete.');
