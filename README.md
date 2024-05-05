# Instructions for Running MATLAB Files and YOLOv5 Training/Detection

This repository contains MATLAB scripts for circle detection, distance calculation, image splitting, and a Python script for YOLOv5 model training and cell detection.

## Requirements

- MATLAB installed on your system.
- Python environment with required packages for YOLOv5.

## MATLAB Scripts

### File Description

- **CircleDetectionAndRadius.m**: Detects circles in an image, saves the detected circles as separate files, and computes their radii and coordinates.
- **Location and Distance.m**: Detects circles in an image, saves the detected circles as separate files, calculates their radii and coordinates, and computes distances between circles.
- **SecondRound.m**: Splits input images into smaller patches with specified patch size and overlap.

### Instructions

1. **CircleDetectionAndRadius.m**:
    - Open MATLAB.
    - Ensure the image file (`Linear_1.png` or `Linear_1.tif`) is in the same directory as the script.
    - Modify parameters such as `radiusRange`, `sensitivity`, and `edgeThreshold` if needed.
    - Run the script. Detected circles will be saved in the `Linear_1` folder.

2. **Location and Distance.m**:
    - Follow the same steps as above but with a different image file (`Linear_1.tif`).
    - Detected circles and their centers will be saved in the `Linear_1` folder.
    - Distances from a randomly chosen circle to other circles will be calculated and saved.

3. **SecondRound.m**:
    - This script requires a set of input images (`Linear_1.png`, `Linear_2.png`, etc.) in the same directory.
    - Modify `patchSize` and `overlap` variables as needed.
    - Run the script. Cropped patches will be saved in the `images` folder.

## YOLOv5 Training and Detection

### File Description

- **YOLODLModel.py**: Python script for training YOLOv5 on custom data for 100 epochs and detecting cells.

### Instructions for YOLOv5

1. **YOLODLModel.py**:
    - Ensure Python is installed on your system along with required YOLOv5 dependencies.
    - Place the `YOLODLModel.py` file in a desired directory.
    - Modify parameters like `--img`, `--batch`, `--epochs`, etc., as per your requirements in the script.
    - Execute the script in a terminal or command prompt:
        ```bash
        python YOLODLModel.py
        ```
    - The script will start training the YOLOv5 model on custom data we provided. It will generate output files and folders based on specified parameters.

2. **Evaluation and Cell Detection**:
    - After training, for model evaluation and cell detection, use the provided code snippet in a Python environment or Jupyter Notebook:
        ```python
        from utils.plots import plot_results
        from IPython.display import Image
      
        # Plot results.txt as results.png
        plot_results('/content/yolov5/runs/train/yolov5s_results2/results.png', width=1000)
      
        # View results.png
        Image(filename='/content/yolov5/runs/train/yolov5s_results2/results.png', width=1000)
        ```

