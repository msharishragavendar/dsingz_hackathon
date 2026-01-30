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

    def create_profile_dashboard(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a comprehensive profile dashboard image.
        
        Args:
            data: Profile data from ProfileEngine
            
        Returns:
            Dict with filepath
        """
        if not self._check_dependencies():
            return {"error": "matplotlib not installed", "status": "failed"}

        basic = data.get('basic_info', {})
        stats = data.get('attendance_stats', {})
        skills = data.get('skills', [])
        
        # Create figure with GridSpec
        fig = plt.figure(figsize=(12, 8))
        gs = fig.add_gridspec(2, 2)
        
        # 1. Text Info (Top Left)
        ax_text = fig.add_subplot(gs[0, 0])
        ax_text.axis('off')
        
        name = f"{basic.get('first_name', 'Unknown')} {basic.get('last_name', '')}"
        role = basic.get('job_role', 'N/A')
        join_date = basic.get('date_of_joining', 'N/A')
        email = basic.get('official_email', 'N/A')
        
        text_str = (
            f"👤 NAME: {name}\n"
            f"💼 ROLE: {role}\n"
            f"📅 JOINED: {join_date}\n"
            f"📧 EMAIL: {email}\n\n"
            f"📊 ATTENDANCE RATE: {stats.get('attendance_rate', 0)}%\n"
            f"✅ PRESENT: {stats.get('present', 0)} days\n"
            f"🏠 WFH: {stats.get('wfh', 0)} days"
        )
        
        ax_text.text(0.1, 0.5, text_str, fontsize=12, va='center', family='monospace')
        ax_text.set_title("Employee Profile", fontsize=14, fontweight='bold')
        
        # 2. Attendance Pie Chart (Top Right)
        ax_pie = fig.add_subplot(gs[0, 1])
        pie_labels = []
        pie_values = []
        for k in ['present', 'late', 'absent', 'leave', 'wfh']:
            val = stats.get(k, 0)
            if val > 0:
                pie_labels.append(k.upper())
                pie_values.append(val)
        
        if pie_values:
            ax_pie.pie(pie_values, labels=pie_labels, autopct='%1.1f%%', colors=plt.cm.Set3.colors)
            ax_pie.set_title("Attendance Distribution", fontsize=12)
        else:
            ax_pie.text(0.5, 0.5, "No Data", ha='center')
        
        # 3. Skills Bar Chart (Bottom Left)
        ax_bar = fig.add_subplot(gs[1, 0])
        if skills:
            # Sort skills by level (expert=3, intermediate=2, beginner=1)
            lvl_map = {'expert': 3, 'intermediate': 2, 'beginner': 1, 'trainee': 0.5}
            sorted_skills = sorted(skills, key=lambda x: lvl_map.get(x.get('level', 'beginner').lower(), 0), reverse=True)[:5]
            
            skill_names = [s['technology_name'] for s in sorted_skills]
            skill_lvls = [lvl_map.get(s['level'].lower(), 1) for s in sorted_skills]
            
            bars = ax_bar.barh(skill_names, skill_lvls, color='#00BCD4')
            ax_bar.set_yticks(range(len(skill_names)))
            ax_bar.set_yticklabels(skill_names)
            ax_bar.set_xlabel("Proficiency Level")
            ax_bar.set_title("Top Skills", fontsize=12)
            
            # Custom x-ticks
            ax_bar.set_xticks([1, 2, 3])
            ax_bar.set_xticklabels(['Beginner', 'Interim', 'Expert'])
        else:
            ax_bar.text(0.5, 0.5, "No Skills Listed", ha='center')
            ax_bar.axis('off')

        # 4. Projects List (Bottom Right)
        ax_proj = fig.add_subplot(gs[1, 1])
        ax_proj.axis('off')
        projects = data.get('projects', [])
        
        proj_str = "PROJECTS:\n\n"
        if projects:
            for p in projects[:4]:  # Show max 4
                proj_str += f"• {p.get('name')} ({p.get('project_status')})\n"
        else:
            proj_str += "(No active projects)"
            
        ax_proj.text(0.1, 0.8, proj_str, fontsize=10, va='top', wrap=True)

        plt.tight_layout()
        
        filename = f"profile_{data['uuid']}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath, dpi=100)
        plt.close()
        
        return {"filepath": filepath, "status": "success", "type": "profile_dashboard"}
