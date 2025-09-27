#!/usr/bin/env python3
"""
Mandala Batch Processor

Processes all mandala folders, skipping images that already have corresponding PNG files.
Outputs directly to the ideia.me/images/mandalas/ folder with proper naming.
"""

import os
import sys
from pathlib import Path
from mandala_extractor import extract_circular_mandala

def get_output_filename(input_filename, folder_number):
    """
    Generate output filename based on input filename and folder number.
    
    Args:
        input_filename (str): Original JPG filename (e.g., "1.jpg", "capa.jpg")
        folder_number (int): Folder number (1-9)
        
    Returns:
        str: Output PNG filename (e.g., "01.png", "capa1.png")
    """
    name_without_ext = Path(input_filename).stem
    
    # Handle numbered files
    if name_without_ext.isdigit():
        # Convert to zero-padded format based on folder
        number = int(name_without_ext)
        if folder_number == 1:
            return f"{number:02d}.png"  # 01.png, 02.png, etc.
        else:
            # For other folders, use folder prefix
            return f"{folder_number}{number:02d}.png"  # 201.png, 302.png, etc.
    else:
        # Handle special files like "capa.jpg"
        return f"{name_without_ext}{folder_number}.png"

def should_skip_file(input_path, output_path):
    """
    Check if we should skip processing this file.
    
    Args:
        input_path (Path): Input JPG file path
        output_path (Path): Expected output PNG file path
        
    Returns:
        bool: True if should skip, False if should process
    """
    if output_path.exists():
        print(f"✓ Skipping {input_path.name} - {output_path.name} already exists")
        return True
    return False

def process_mandala_folder(folder_path, folder_number, output_dir):
    """
    Process all JPG files in a mandala folder.
    
    Args:
        folder_path (Path): Path to the mandala folder
        folder_number (int): Folder number for output naming
        output_dir (Path): Output directory for PNG files
        
    Returns:
        tuple: (processed_count, skipped_count, failed_count)
    """
    print(f"\n🔄 Processing folder {folder_number}: {folder_path}")
    
    # Find all JPG files
    jpg_files = list(folder_path.glob("*.jpg")) + list(folder_path.glob("*.JPG"))
    jpg_files = [f for f in jpg_files if not f.name.endswith('_debug.jpg')]  # Skip debug files
    
    if not jpg_files:
        print(f"   No JPG files found in {folder_path}")
        return 0, 0, 0
    
    processed_count = 0
    skipped_count = 0
    failed_count = 0
    
    for jpg_file in sorted(jpg_files):
        output_filename = get_output_filename(jpg_file.name, folder_number)
        output_path = output_dir / output_filename
        
        # Check if we should skip this file
        if should_skip_file(jpg_file, output_path):
            skipped_count += 1
            continue
        
        print(f"   🎨 Processing: {jpg_file.name} → {output_filename}")
        
        # Process the mandala
        success = extract_circular_mandala(str(jpg_file), str(output_path), debug=False)
        
        if success:
            processed_count += 1
            print(f"   ✅ Success: {output_filename}")
        else:
            failed_count += 1
            print(f"   ❌ Failed: {jpg_file.name}")
    
    return processed_count, skipped_count, failed_count

def main():
    # Define paths
    mandala_base_dir = Path("/Users/jonatas/code/mandala/www/img/mandalas")
    output_dir = Path("/Users/jonatas/code/ideia.me/images/mandalas")
    
    # Ensure output directory exists
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print("🎯 Mandala Batch Processor")
    print(f"📁 Input directory: {mandala_base_dir}")
    print(f"📁 Output directory: {output_dir}")
    print("=" * 60)
    
    total_processed = 0
    total_skipped = 0
    total_failed = 0
    
    # Process each numbered folder (1-9)
    for folder_number in range(1, 10):
        folder_path = mandala_base_dir / str(folder_number)
        
        if not folder_path.exists():
            print(f"⚠️  Folder {folder_number} not found: {folder_path}")
            continue
        
        processed, skipped, failed = process_mandala_folder(folder_path, folder_number, output_dir)
        total_processed += processed
        total_skipped += skipped
        total_failed += failed
    
    # Print summary
    print("\n" + "=" * 60)
    print("📊 PROCESSING SUMMARY")
    print("=" * 60)
    print(f"✅ Processed: {total_processed} files")
    print(f"⏭️  Skipped: {total_skipped} files (already exist)")
    print(f"❌ Failed: {total_failed} files")
    print(f"📁 Total files in output: {len(list(output_dir.glob('*.png')))} PNG files")
    
    if total_failed > 0:
        print(f"\n⚠️  {total_failed} files failed to process. Check the error messages above.")
    
    if total_processed > 0:
        print(f"\n🎉 Successfully processed {total_processed} new mandala files!")
        print(f"💡 You can now update the playground mandala list.")

if __name__ == "__main__":
    main()
