# Mandala Circle Extractor

A Python script that automatically detects and extracts circular mandalas from images, cropping them to perfect circles and scaling to 500x500 PNG format.

## Features

- Automatic circle detection using OpenCV's HoughCircles algorithm
- Extracts the largest circle found in each image
- Creates transparent circular crops
- Scales output to 500x500 pixels
- Supports both single image and batch processing
- Debug mode to visualize detected circles

## Installation

1. Install the required dependencies:
```bash
pip3 install -r requirements.txt
```

## Usage

### Single Image Processing

Extract a mandala from a single image:
```bash
python3 mandala_extractor.py input_image.jpg -o output_mandala.png
```

With debug mode (shows detected circle):
```bash
python3 mandala_extractor.py input_image.jpg -o output_mandala.png -d
```

### Batch Processing

Process all JPG images in a directory:
```bash
python3 mandala_extractor.py input_directory/ -o output_directory/ --batch
```

### Examples

1. **Extract from a single mandala:**
```bash
python3 mandala_extractor.py www/img/mandalas/1/1.jpg -o extracted/01.png
```

2. **Process all mandalas in folder 1:**
```bash
python3 mandala_extractor.py www/img/mandalas/1/ -o extracted_folder1/ --batch
```

3. **Test with debug mode:**
```bash
python3 test_extraction.py
```

## How It Works

1. **Circle Detection**: Uses OpenCV's HoughCircles to detect circular patterns in the image
2. **Largest Circle Selection**: Automatically selects the largest detected circle (assumes this is the main mandala)
3. **Cropping**: Crops a square area around the detected circle
4. **Masking**: Creates a circular mask to make the background transparent
5. **Scaling**: Resizes the result to exactly 500x500 pixels
6. **Output**: Saves as PNG with transparency

## Algorithm Parameters

The script uses these parameters for circle detection:
- **dp**: 1 (inverse ratio of accumulator resolution)
- **minDist**: 30 (minimum distance between circle centers)
- **param1**: 50 (upper threshold for edge detection)
- **param2**: 30 (accumulator threshold for center detection)
- **minRadius**: 50 (minimum circle radius in pixels)
- **maxRadius**: 0 (no maximum limit)

These can be adjusted in the `detect_largest_circle()` function if needed for different image types.

## Output Format

- **Format**: PNG with transparency
- **Size**: 500x500 pixels
- **Background**: Transparent (alpha channel)
- **Quality**: High-quality Lanczos resampling

## Troubleshooting

### No circle detected
- Try adjusting the HoughCircles parameters in the code
- Ensure the mandala has clear circular edges
- Check that the image has sufficient contrast

### Circle detection not accurate
- Enable debug mode with `-d` flag to see detected circles
- The algorithm selects the largest circle found
- Manual parameter tuning may be needed for specific image sets

## Files

- `mandala_extractor.py` - Main extraction script
- `test_extraction.py` - Simple test script
- `requirements.txt` - Python dependencies
- `README_mandala_extractor.md` - This documentation


Want to see more about this project? https://ideia.me/mandala-playground
