#!/usr/bin/env python3
"""
Visuals App Management Script
File operations utility for the Visuals macOS app

Co-Authored-By: Oz <oz-agent@warp.dev>
"""

import os
import shutil
import json
import sys
from pathlib import Path
from datetime import datetime


class VisualsManager:
    """Manage Visuals app files and operations"""
    
    def __init__(self, app_dir=None):
        """Initialize with app directory path"""
        if app_dir is None:
            app_dir = Path(__file__).parent
        self.app_dir = Path(app_dir)
        self.app_bundle = self.app_dir / "Visuals.app"
        
    def get_app_info(self):
        """Get information about the Visuals app"""
        if not self.app_bundle.exists():
            return {"error": "Visuals.app not found"}
        
        info = {
            "app_path": str(self.app_bundle),
            "exists": self.app_bundle.exists(),
            "size_mb": self._get_dir_size(self.app_bundle) / (1024 * 1024),
            "executable": str(self.app_bundle / "Contents/MacOS/Visuals"),
            "icon": str(self.app_bundle / "Contents/Resources/AppIcon.icns"),
            "info_plist": str(self.app_bundle / "Contents/Info.plist"),
        }
        
        # Get executable size
        executable = self.app_bundle / "Contents/MacOS/Visuals"
        if executable.exists():
            info["executable_size_kb"] = executable.stat().st_size / 1024
            
        # Get icon size
        icon = self.app_bundle / "Contents/Resources/AppIcon.icns"
        if icon.exists():
            info["icon_size_mb"] = icon.stat().st_size / (1024 * 1024)
            
        return info
    
    def _get_dir_size(self, path):
        """Calculate total size of directory"""
        total = 0
        for entry in Path(path).rglob('*'):
            if entry.is_file():
                total += entry.stat().st_size
        return total
    
    def list_source_files(self):
        """List all Swift source files"""
        swift_files = sorted(self.app_dir.glob("*.swift"))
        return [
            {
                "name": f.name,
                "path": str(f),
                "size_kb": f.stat().st_size / 1024,
                "lines": self._count_lines(f)
            }
            for f in swift_files
        ]
    
    def _count_lines(self, file_path):
        """Count lines in a file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return len(f.readlines())
        except:
            return 0
    
    def backup_app(self, backup_dir=None):
        """Create a backup of the Visuals.app bundle"""
        if not self.app_bundle.exists():
            return {"error": "Visuals.app not found"}
        
        if backup_dir is None:
            backup_dir = self.app_dir / "backups"
        else:
            backup_dir = Path(backup_dir)
            
        backup_dir.mkdir(exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_name = f"Visuals_{timestamp}.app"
        backup_path = backup_dir / backup_name
        
        print(f"Creating backup: {backup_path}")
        shutil.copytree(self.app_bundle, backup_path)
        
        return {
            "success": True,
            "backup_path": str(backup_path),
            "size_mb": self._get_dir_size(backup_path) / (1024 * 1024)
        }
    
    def export_project_structure(self, output_file=None):
        """Export project structure to JSON"""
        if output_file is None:
            output_file = self.app_dir / "project_structure.json"
        else:
            output_file = Path(output_file)
        
        structure = {
            "app_info": self.get_app_info(),
            "source_files": self.list_source_files(),
            "additional_files": self._list_additional_files(),
            "generated_at": datetime.now().isoformat()
        }
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(structure, f, indent=2)
        
        print(f"Project structure exported to: {output_file}")
        return str(output_file)
    
    def _list_additional_files(self):
        """List additional project files"""
        patterns = ["*.sh", "*.md", "*.plist", "*.icns", "*.iconset"]
        files = []
        
        for pattern in patterns:
            for f in self.app_dir.glob(pattern):
                if f.is_file():
                    files.append({
                        "name": f.name,
                        "type": f.suffix,
                        "size_kb": f.stat().st_size / 1024
                    })
        
        return files
    
    def clean_build_artifacts(self):
        """Remove build artifacts"""
        artifacts = [
            "Visuals",  # Standalone executable
            ".DS_Store",
            "AppIcon.iconset",
        ]
        
        removed = []
        for artifact in artifacts:
            path = self.app_dir / artifact
            if path.exists():
                if path.is_dir():
                    shutil.rmtree(path)
                else:
                    path.unlink()
                removed.append(artifact)
        
        return {
            "removed": removed,
            "count": len(removed)
        }
    
    def create_distribution_package(self, output_dir=None):
        """Create a distribution package with app and documentation"""
        if output_dir is None:
            output_dir = self.app_dir / "dist"
        else:
            output_dir = Path(output_dir)
        
        output_dir.mkdir(exist_ok=True)
        
        # Copy app bundle
        if self.app_bundle.exists():
            shutil.copytree(
                self.app_bundle, 
                output_dir / "Visuals.app",
                dirs_exist_ok=True
            )
        
        # Copy README
        readme = self.app_dir / "README.md"
        if readme.exists():
            shutil.copy2(readme, output_dir / "README.md")
        
        print(f"Distribution package created in: {output_dir}")
        return {
            "success": True,
            "output_dir": str(output_dir),
            "contents": [f.name for f in output_dir.iterdir()]
        }
    
    def generate_stats_report(self):
        """Generate statistics report"""
        source_files = self.list_source_files()
        total_lines = sum(f['lines'] for f in source_files)
        total_size_kb = sum(f['size_kb'] for f in source_files)
        
        report = {
            "source_code": {
                "file_count": len(source_files),
                "total_lines": total_lines,
                "total_size_kb": round(total_size_kb, 2),
                "files": source_files
            },
            "app_bundle": self.get_app_info(),
            "generated_at": datetime.now().isoformat()
        }
        
        return report


def main():
    """Main CLI interface"""
    manager = VisualsManager()
    
    if len(sys.argv) < 2:
        print("Visuals App Management Script")
        print("\nUsage:")
        print("  python manage_visuals.py info          - Show app information")
        print("  python manage_visuals.py sources       - List source files")
        print("  python manage_visuals.py backup        - Create app backup")
        print("  python manage_visuals.py export        - Export project structure")
        print("  python manage_visuals.py clean         - Clean build artifacts")
        print("  python manage_visuals.py dist          - Create distribution package")
        print("  python manage_visuals.py stats         - Generate statistics report")
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    if command == "info":
        info = manager.get_app_info()
        print("\n=== Visuals App Information ===")
        for key, value in info.items():
            print(f"{key}: {value}")
    
    elif command == "sources":
        sources = manager.list_source_files()
        print("\n=== Source Files ===")
        for src in sources:
            print(f"{src['name']:30} {src['lines']:5} lines  {src['size_kb']:.1f} KB")
        print(f"\nTotal: {len(sources)} files")
    
    elif command == "backup":
        result = manager.backup_app()
        if "error" in result:
            print(f"Error: {result['error']}")
        else:
            print(f"✓ Backup created: {result['backup_path']}")
            print(f"  Size: {result['size_mb']:.2f} MB")
    
    elif command == "export":
        output_file = manager.export_project_structure()
        print(f"✓ Project structure exported to: {output_file}")
    
    elif command == "clean":
        result = manager.clean_build_artifacts()
        print(f"✓ Removed {result['count']} artifacts:")
        for item in result['removed']:
            print(f"  - {item}")
    
    elif command == "dist":
        result = manager.create_distribution_package()
        print(f"✓ Distribution package created")
        print(f"  Location: {result['output_dir']}")
        print(f"  Contents: {', '.join(result['contents'])}")
    
    elif command == "stats":
        stats = manager.generate_stats_report()
        print("\n=== Statistics Report ===")
        print(f"Source Files: {stats['source_code']['file_count']}")
        print(f"Total Lines: {stats['source_code']['total_lines']}")
        print(f"Source Size: {stats['source_code']['total_size_kb']:.2f} KB")
        print(f"\nApp Bundle: {stats['app_bundle'].get('size_mb', 'N/A'):.2f} MB")
        print(f"Executable: {stats['app_bundle'].get('executable_size_kb', 'N/A'):.2f} KB")
        print(f"Icon: {stats['app_bundle'].get('icon_size_mb', 'N/A'):.2f} MB")
    
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
