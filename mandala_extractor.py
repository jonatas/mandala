#!/usr/bin/env python3
"""
Mandala Circle Extractor

This script detects circular mandalas in images and extracts them as 500x500 PNG files.
It uses OpenCV for circle detection and PIL for image processing.
"""

import cv2
import numpy as np
from PIL import Image, ImageDraw
import os
import argparse
from pathlib import Path


def detect_largest_circle(image_path, debug=False):
    """
    Detect the largest circle in an image using multiple methods for better accuracy.
    
    Args:
        image_path (str): Path to the input image
        debug (bool): Whether to show debug information
        
    Returns:
        tuple: (x, y, radius) of the largest circle, or None if no circle found
    """
    # Read the image
    img = cv2.imread(str(image_path))
    if img is None:
        print(f"Error: Could not load image {image_path}")
        return None
    
    height, width = img.shape[:2]
    
    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Apply multiple preprocessing techniques
    # 1. Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(gray, (5, 5), 1.5)
    
    # 2. Enhance contrast
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    enhanced = clahe.apply(blurred)
    
    # 3. Apply median filter to reduce noise while preserving edges
    filtered = cv2.medianBlur(enhanced, 5)
    
    # Try multiple parameter sets for HoughCircles
    circle_params = [
        # Conservative parameters for well-defined circles
        {'dp': 1, 'minDist': min(width, height)//4, 'param1': 100, 'param2': 50, 'minRadius': min(width, height)//8, 'maxRadius': min(width, height)//2},
        # More sensitive parameters
        {'dp': 1, 'minDist': min(width, height)//6, 'param1': 80, 'param2': 40, 'minRadius': min(width, height)//10, 'maxRadius': min(width, height)//2},
        # Very sensitive parameters for faint circles
        {'dp': 1, 'minDist': min(width, height)//8, 'param1': 60, 'param2': 30, 'minRadius': min(width, height)//12, 'maxRadius': min(width, height)//2}
    ]
    
    all_circles = []
    
    for params in circle_params:
        circles = cv2.HoughCircles(
            filtered,
            cv2.HOUGH_GRADIENT,
            **params
        )
        
        if circles is not None:
            circles = np.round(circles[0, :]).astype("int")
            all_circles.extend(circles)
    
    if all_circles:
        # Filter circles - prefer those that are well-centered and large
        valid_circles = []
        
        for (x, y, r) in all_circles:
            # Check if circle is well within image bounds
            margin = r * 0.1  # 10% margin
            if (x - r + margin >= 0 and y - r + margin >= 0 and 
                x + r - margin <= width and y + r - margin <= height):
                
                # Calculate how centered the circle is (prefer centered circles)
                center_x, center_y = width // 2, height // 2
                distance_from_center = np.sqrt((x - center_x)**2 + (y - center_y)**2)
                max_distance = np.sqrt(center_x**2 + center_y**2)
                centrality_score = 1 - (distance_from_center / max_distance)
                
                # Score combines size and centrality
                score = r * (0.7 + 0.3 * centrality_score)
                valid_circles.append((x, y, r, score))
        
        if valid_circles:
            # Sort by score and pick the best one
            valid_circles.sort(key=lambda c: c[3], reverse=True)
            best_circle = valid_circles[0]
            largest_circle = (best_circle[0], best_circle[1], best_circle[2])
            
            if debug:
                # Create a copy for debugging - show all detected circles
                debug_img = img.copy()
                
                # Draw all valid circles in blue
                for (x, y, r, score) in valid_circles[:5]:  # Show top 5
                    cv2.circle(debug_img, (x, y), r, (255, 0, 0), 1)
                    cv2.putText(debug_img, f"{score:.1f}", (x-20, y-r-10), 
                              cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1)
                
                # Draw the selected circle in green
                x, y, r = largest_circle
                cv2.circle(debug_img, (x, y), r, (0, 255, 0), 3)
                cv2.circle(debug_img, (x, y), 2, (0, 0, 255), 3)
                cv2.putText(debug_img, f"SELECTED: {r}px", (x-50, y+r+20), 
                          cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
                
                # Save debug image
                debug_path = str(image_path).replace('.jpg', '_debug.jpg')
                cv2.imwrite(debug_path, debug_img)
                print(f"Debug image saved to: {debug_path}")
            
            return largest_circle
    
    return None


def extract_circular_mandala(image_path, output_path, target_size=500, debug=False):
    """
    Extract a circular mandala from an image and save as PNG.
    
    Args:
        image_path (str): Path to the input image
        output_path (str): Path to save the output PNG
        target_size (int): Target size for the output image (width and height)
        debug (bool): Whether to show debug information
        
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Detect the largest circle
        circle = detect_largest_circle(image_path, debug)
        if circle is None:
            print(f"No circle detected in {image_path}")
            return False
        
        x, y, radius = circle
        print(f"Found circle at ({x}, {y}) with radius {radius}")
        
        # Open the original image with PIL
        img = Image.open(image_path)
        
        # Create a square crop that fully contains the circle
        # Add some padding to ensure we capture the full circle
        padding = int(radius * 0.05)  # 5% padding
        crop_radius = radius + padding
        
        # Calculate crop box (square around the circle)
        left = max(0, x - crop_radius)
        top = max(0, y - crop_radius)
        right = min(img.width, x + crop_radius)
        bottom = min(img.height, y + crop_radius)
        
        # Ensure we have a square crop
        crop_width = right - left
        crop_height = bottom - top
        crop_size = max(crop_width, crop_height)
        
        # Adjust crop to be square and centered on the circle
        center_x_crop = (left + right) // 2
        center_y_crop = (top + bottom) // 2
        half_size = crop_size // 2
        
        left = max(0, center_x_crop - half_size)
        top = max(0, center_y_crop - half_size)
        right = min(img.width, center_x_crop + half_size)
        bottom = min(img.height, center_y_crop + half_size)
        
        # If we hit image boundaries, create a larger canvas
        crop_width = right - left
        crop_height = bottom - top
        
        if crop_width < crop_size or crop_height < crop_size:
            # Create a new image with padding
            padded_size = crop_size
            padded_img = Image.new('RGB', (padded_size, padded_size), (255, 255, 255))
            
            # Calculate offset to center the original crop
            offset_x = (padded_size - crop_width) // 2
            offset_y = (padded_size - crop_height) // 2
            
            cropped = img.crop((left, top, right, bottom))
            padded_img.paste(cropped, (offset_x, offset_y))
            
            # Adjust circle position for the padded image
            circle_x = x - left + offset_x
            circle_y = y - top + offset_y
            
            cropped = padded_img
        else:
            # Normal crop
            cropped = img.crop((left, top, right, bottom))
            circle_x = x - left
            circle_y = y - top
        
        # Create a circular mask
        mask_size = cropped.size
        mask = Image.new('L', mask_size, 0)
        draw = ImageDraw.Draw(mask)
        
        # Draw the circle mask - use the original radius
        draw.ellipse(
            (circle_x - radius, circle_y - radius, 
             circle_x + radius, circle_y + radius), 
            fill=255
        )
        
        # Apply the mask to create transparent background
        result = Image.new('RGBA', mask_size, (0, 0, 0, 0))
        result.paste(cropped, (0, 0))
        result.putalpha(mask)
        
        # Resize to target size
        result = result.resize((target_size, target_size), Image.Resampling.LANCZOS)
        
        # Save as PNG
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        result.save(output_path, 'PNG')
        
        print(f"Successfully extracted mandala to: {output_path}")
        return True
        
    except Exception as e:
        print(f"Error processing {image_path}: {str(e)}")
        return False


def process_single_image(input_path, output_path=None, debug=False):
    """
    Process a single image file.
    
    Args:
        input_path (str): Path to the input image
        output_path (str): Path to save the output (optional)
        debug (bool): Whether to show debug information
    """
    input_path = Path(input_path)
    
    if output_path is None:
        output_path = input_path.parent / f"{input_path.stem}_circle.png"
    else:
        output_path = Path(output_path)
    
    success = extract_circular_mandala(str(input_path), str(output_path), debug=debug)
    return success


def process_directory(input_dir, output_dir=None, debug=False):
    """
    Process all JPG images in a directory.
    
    Args:
        input_dir (str): Path to the input directory
        output_dir (str): Path to the output directory (optional)
        debug (bool): Whether to show debug information
    """
    input_dir = Path(input_dir)
    
    if output_dir is None:
        output_dir = input_dir / "extracted"
    else:
        output_dir = Path(output_dir)
    
    # Find all JPG files
    jpg_files = list(input_dir.glob("*.jpg")) + list(input_dir.glob("*.JPG"))
    
    if not jpg_files:
        print(f"No JPG files found in {input_dir}")
        return
    
    print(f"Found {len(jpg_files)} JPG files to process")
    
    success_count = 0
    for jpg_file in jpg_files:
        output_file = output_dir / f"{jpg_file.stem}.png"
        print(f"\nProcessing: {jpg_file.name}")
        
        if extract_circular_mandala(str(jpg_file), str(output_file), debug=debug):
            success_count += 1
    
    print(f"\nCompleted: {success_count}/{len(jpg_files)} images processed successfully")


def main():
    parser = argparse.ArgumentParser(description="Extract circular mandalas from images")
    parser.add_argument("input", help="Input image file or directory")
    parser.add_argument("-o", "--output", help="Output file or directory")
    parser.add_argument("-d", "--debug", action="store_true", help="Enable debug mode")
    parser.add_argument("--batch", action="store_true", help="Process directory in batch mode")
    
    args = parser.parse_args()
    
    input_path = Path(args.input)
    
    if not input_path.exists():
        print(f"Error: Input path {input_path} does not exist")
        return
    
    if args.batch or input_path.is_dir():
        process_directory(str(input_path), args.output, args.debug)
    else:
        process_single_image(str(input_path), args.output, args.debug)


if __name__ == "__main__":
    main()
