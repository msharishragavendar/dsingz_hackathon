"""
Visualization Engine
Generates charts and visualizations for analytics results.
"""

import os
from typing import List, Dict, Any, Optional, Tuple
from datetime import datetime

# Try to import visualization libraries
try:
    import matplotlib
    matplotlib.use('Agg')  # Non-interactive backend
    import matplotlib.pyplot as plt
    import matplotlib.dates as mdates
    HAS_MATPLOTLIB = True
except ImportError:
    HAS_MATPLOTLIB = False

try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False


class Visualizer:
    """Visualization engine for attendance and work analytics."""
    
    def __init__(self, output_dir: str = "./charts"):
        """
        Initialize visualizer.
        
        Args:
            output_dir: Directory to save chart images
        """
        self.output_dir = output_dir
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
    
    def _check_dependencies(self) -> bool:
        """Check if visualization dependencies are available."""
        if not HAS_MATPLOTLIB:
            return False
        return True
    
    def line_chart(
        self,
        x_values: List[Any],
        y_values: List[float],
        title: str = "Trend Chart",
        x_label: str = "Time",
        y_label: str = "Value",
        filename: str = None,
        color: str = "#4CAF50",
        show_trend: bool = True
    ) -> Dict[str, Any]:
        """
        Generate a line chart for trend visualization.
        
        Args:
            x_values: X-axis values (dates or labels)
            y_values: Y-axis values
            title: Chart title
            x_label: X-axis label
            y_label: Y-axis label
            filename: Output filename (auto-generated if None)
            color: Line color
            show_trend: Show trend line
            
        Returns:
            Dict with file path and status
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}
        
        if len(x_values) != len(y_values):
            return {"error": "x and y values must have same length", "status": "failed"}
        
        fig, ax = plt.subplots(figsize=(10, 6))
        
        # Plot main line
        ax.plot(x_values, y_values, marker='o', color=color, linewidth=2, markersize=4)
        
        # Add trend line if requested
        if show_trend and len(y_values) > 2:
            z = np.polyfit(range(len(y_values)), y_values, 1)
            p = np.poly1d(z)
            ax.plot(x_values, p(range(len(y_values))), "--", color="red", 
                   alpha=0.7, linewidth=1.5, label="Trend")
            ax.legend()
        
        ax.set_title(title, fontsize=14, fontweight='bold')
        ax.set_xlabel(x_label, fontsize=11)
        ax.set_ylabel(y_label, fontsize=11)
        ax.grid(True, alpha=0.3)
        
        # Rotate x labels if they're dates or long strings
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        
        # Save
        if filename is None:
            filename = f"line_chart_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "line_chart"}
    
    def bar_chart(
        self,
        categories: List[str],
        values: List[float],
        title: str = "Comparison Chart",
        x_label: str = "Category",
        y_label: str = "Value",
        filename: str = None,
        color: str = "#2196F3",
        horizontal: bool = False
    ) -> Dict[str, Any]:
        """
        Generate a bar chart for comparisons.
        
        Args:
            categories: Category labels
            values: Values for each category
            title: Chart title
            x_label: X-axis label
            y_label: Y-axis label
            filename: Output filename
            color: Bar color
            horizontal: If True, create horizontal bars
            
        Returns:
            Dict with file path and status
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}
        
        fig, ax = plt.subplots(figsize=(10, 6))
        
        if horizontal:
            bars = ax.barh(categories, values, color=color)
            ax.set_xlabel(y_label, fontsize=11)
            ax.set_ylabel(x_label, fontsize=11)
        else:
            bars = ax.bar(categories, values, color=color)
            ax.set_xlabel(x_label, fontsize=11)
            ax.set_ylabel(y_label, fontsize=11)
            plt.xticks(rotation=45, ha='right')
        
        # Add value labels on bars
        for bar, val in zip(bars, values):
            if horizontal:
                ax.text(bar.get_width() + 0.1, bar.get_y() + bar.get_height()/2,
                       f'{val:.1f}', va='center', fontsize=9)
            else:
                ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.1,
                       f'{val:.1f}', ha='center', fontsize=9)
        
        ax.set_title(title, fontsize=14, fontweight='bold')
        ax.grid(True, alpha=0.3, axis='y' if not horizontal else 'x')
        plt.tight_layout()
        
        # Save
        if filename is None:
            filename = f"bar_chart_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "bar_chart"}
    
    def heatmap(
        self,
        data: List[List[float]],
        row_labels: List[str],
        col_labels: List[str],
        title: str = "Heatmap",
        filename: str = None,
        cmap: str = "YlOrRd"
    ) -> Dict[str, Any]:
        """
        Generate a heatmap for pattern visualization.
        
        Args:
            data: 2D data array
            row_labels: Labels for rows
            col_labels: Labels for columns
            title: Chart title
            filename: Output filename
            cmap: Color map name
            
        Returns:
            Dict with file path and status
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}
        
        fig, ax = plt.subplots(figsize=(12, 8))
        
        data_array = np.array(data)
        im = ax.imshow(data_array, cmap=cmap, aspect='auto')
        
        # Add colorbar
        cbar = ax.figure.colorbar(im, ax=ax)
        
        # Set ticks and labels
        ax.set_xticks(np.arange(len(col_labels)))
        ax.set_yticks(np.arange(len(row_labels)))
        ax.set_xticklabels(col_labels)
        ax.set_yticklabels(row_labels)
        
        plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")
        
        # Add value annotations
        for i in range(len(row_labels)):
            for j in range(len(col_labels)):
                text = ax.text(j, i, f'{data_array[i, j]:.0f}',
                              ha="center", va="center", color="black", fontsize=8)
        
        ax.set_title(title, fontsize=14, fontweight='bold')
        plt.tight_layout()
        
        # Save
        if filename is None:
            filename = f"heatmap_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "heatmap"}
    
    def distribution_plot(
        self,
        values: List[float],
        title: str = "Distribution",
        x_label: str = "Value",
        filename: str = None,
        bins: int = 20,
        color: str = "#9C27B0"
    ) -> Dict[str, Any]:
        """
        Generate a histogram/distribution plot.
        
        Args:
            values: Data values
            title: Chart title
            x_label: X-axis label
            filename: Output filename
            bins: Number of histogram bins
            color: Bar color
            
        Returns:
            Dict with file path and status
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}
        
        fig, ax = plt.subplots(figsize=(10, 6))
        
        n, bins_arr, patches = ax.hist(values, bins=bins, color=color, 
                                        edgecolor='white', alpha=0.8)
        
        # Add mean and std lines
        mean_val = np.mean(values)
        std_val = np.std(values)
        
        ax.axvline(mean_val, color='red', linestyle='--', linewidth=2, label=f'Mean: {mean_val:.1f}')
        ax.axvline(mean_val + std_val, color='orange', linestyle=':', linewidth=1.5, label=f'+1 Std: {mean_val + std_val:.1f}')
        ax.axvline(mean_val - std_val, color='orange', linestyle=':', linewidth=1.5, label=f'-1 Std: {mean_val - std_val:.1f}')
        
        ax.set_title(title, fontsize=14, fontweight='bold')
        ax.set_xlabel(x_label, fontsize=11)
        ax.set_ylabel("Frequency", fontsize=11)
        ax.legend()
        ax.grid(True, alpha=0.3)
        plt.tight_layout()
        
        # Save
        if filename is None:
            filename = f"distribution_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "distribution"}
    
    def pie_chart(
        self,
        labels: List[str],
        values: List[float],
        title: str = "Distribution",
        filename: str = None,
        colors: List[str] = None
    ) -> Dict[str, Any]:
        """
        Generate a pie chart.
        
        Args:
            labels: Category labels
            values: Values for each category
            title: Chart title
            filename: Output filename
            colors: Custom colors list
            
        Returns:
            Dict with file path and status
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}
        
        fig, ax = plt.subplots(figsize=(10, 8))
        
        if colors is None:
            colors = plt.cm.Set3(np.linspace(0, 1, len(labels)))
        
        wedges, texts, autotexts = ax.pie(values, labels=labels, colors=colors,
                                           autopct='%1.1f%%', startangle=90,
                                           explode=[0.02] * len(values))
        
        ax.set_title(title, fontsize=14, fontweight='bold')
        plt.tight_layout()
        
        # Save
        if filename is None:
            filename = f"pie_chart_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "pie_chart"}
