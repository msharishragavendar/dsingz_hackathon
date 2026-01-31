"""
Visualization Engine
"""
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from typing import List, Dict, Any
from datetime import datetime

class Visualizer:
    def __init__(self, output_dir: str = "./charts"):
        self.output_dir = output_dir
        if not os.path.exists(output_dir): os.makedirs(output_dir)
    
    def line_chart(self, x_values, y_values, title="Trend", x_label="Time", y_label="Value", color="#4CAF50"):
        fig, ax = plt.subplots(figsize=(10, 6))
        ax.plot(x_values, y_values, marker='o', color=color, linewidth=2)
        ax.set_title(title, fontsize=14, fontweight='bold')
        ax.set_xlabel(x_label); ax.set_ylabel(y_label)
        ax.grid(True, alpha=0.3)
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        
        filename = f"line_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath)
        plt.close()
        return {"filepath": filepath, "status": "success"}

    def bar_chart(self, categories, values, title="Comparison", x_label="Category", y_label="Value", color="#2196F3"):
        fig, ax = plt.subplots(figsize=(10, 6))
        bars = ax.bar(categories, values, color=color)
        ax.set_title(title, fontsize=14, fontweight='bold')
        ax.set_xlabel(x_label); ax.set_ylabel(y_label)
        plt.xticks(rotation=45, ha='right')
        
        for bar in bars:
            height = bar.get_height()
            ax.text(bar.get_x() + bar.get_width()/2., height, f'{height:.1f}', ha='center', va='bottom')
            
        plt.tight_layout()
        filename = f"bar_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath)
        plt.close()
        return {"filepath": filepath, "status": "success"}

    def pie_chart(self, labels, values, title="Distribution"):
        fig, ax = plt.subplots(figsize=(8, 8))
        ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=90)
        ax.set_title(title, fontsize=14, fontweight='bold')
        plt.tight_layout()
        filename = f"pie_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        filepath = os.path.join(self.output_dir, filename)
        plt.savefig(filepath)
        plt.close()
        return {"filepath": filepath, "status": "success"}