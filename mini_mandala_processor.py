#!/usr/bin/env python3
"""
Mini Mandala Processor

Creates 100x100px miniature versions of existing mandala PNGs for use in the carousel panel.
Uses high-quality resampling to maintain visual quality at small sizes.
"""

import os
from pathlib import Path
from PIL import Image

def create_mini_mandala(input_path, output_path, target_size=100):
    """
    Create a miniature version of a mandala PNG.
    
    Args:
        input_path (Path): Path to the input PNG file
        output_path (Path): Path to save the mini PNG
        target_size (int): Target size for both width and height
        
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Open the original image
        img = Image.open(input_path)
        
        # Resize using high-quality Lanczos resampling
        mini_img = img.resize((target_size, target_size), Image.Resampling.LANCZOS)
        
        # Save as PNG
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        mini_img.save(output_path, 'PNG', optimize=True)
        
        return True
        
    except Exception as e:
        print(f"Error processing {input_path}: {str(e)}")
        return False

def process_all_mandalas():
    """
    Process all existing mandala PNGs to create mini versions.
    """
    # Define paths
    source_dir = Path("/Users/jonatas/code/ideia.me/images/mandalas")
    mini_dir = Path("/Users/jonatas/code/ideia.me/images/mandalas/mini")
    
    print("🎯 Mini Mandala Processor")
    print(f"📁 Source directory: {source_dir}")
    print(f"📁 Mini directory: {mini_dir}")
    print("=" * 60)
    
    # Ensure mini directory exists
    mini_dir.mkdir(parents=True, exist_ok=True)
    
    # Find all numbered PNG files (excluding 'b' suffixes)
    png_files = [f for f in source_dir.glob("*.png") if f.name.replace('.png', '').isdigit()]
    png_files.sort(key=lambda x: int(x.name.replace('.png', '')))
    
    if not png_files:
        print("No numbered PNG files found!")
        return
    
    print(f"Found {len(png_files)} mandala files to process\n")
    
    processed_count = 0
    skipped_count = 0
    failed_count = 0
    
    for png_file in png_files:
        mini_file = mini_dir / png_file.name
        
        # Check if mini version already exists
        if mini_file.exists():
            print(f"✓ Skipping {png_file.name} - mini version already exists")
            skipped_count += 1
            continue
        
        print(f"🎨 Processing: {png_file.name} → mini/{png_file.name}")
        
        success = create_mini_mandala(png_file, mini_file)
        
        if success:
            processed_count += 1
            print(f"   ✅ Success: mini/{png_file.name}")
        else:
            failed_count += 1
            print(f"   ❌ Failed: {png_file.name}")
    
    # Print summary
    print("\n" + "=" * 60)
    print("📊 MINI PROCESSING SUMMARY")
    print("=" * 60)
    print(f"✅ Processed: {processed_count} files")
    print(f"⏭️  Skipped: {skipped_count} files (already exist)")
    print(f"❌ Failed: {failed_count} files")
    print(f"📁 Total mini files: {len(list(mini_dir.glob('*.png')))} PNG files")
    
    if failed_count > 0:
        print(f"\n⚠️  {failed_count} files failed to process. Check the error messages above.")
    
    if processed_count > 0:
        print(f"\n🎉 Successfully processed {processed_count} mini mandala files!")
        print(f"💡 Mini mandalas are ready for the carousel panel.")

def main():
    process_all_mandalas()

if __name__ == "__main__":
    main()
