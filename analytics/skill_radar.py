"""
Skill Radar Chart Generator
Generates spider/radar charts for employee skill profile visualization.
"""

import os
import numpy as np
import matplotlib.pyplot as plt
from typing import List, Dict, Any
from datetime import datetime

class SkillRadarChart:
    def __init__(self, output_dir: str = "./charts"):
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)
    
    def generate_radar_chart(
        self,
        categories: List[str],
        scores: List[float],
        employee_name: str = "Employee",
        filename: str = None,
        color: str = "#4A90D9",
        fill_alpha: float = 0.25,
        max_score: float = 4.0
    ) -> Dict[str, Any]:
        if len(categories) < 3:
            return {"status": "error", "message": "Need at least 3 categories for a radar chart"}
        
        num_cats = len(categories)
        angles = np.linspace(0, 2 * np.pi, num_cats, endpoint=False).tolist()
        scores_closed = scores + [scores[0]]
        angles_closed = angles + [angles[0]]
        
        fig, ax = plt.subplots(figsize=(10, 10), subplot_kw=dict(polar=True))
        fig.patch.set_facecolor('#ffffff') # Changed to white for better UI integration
        ax.set_facecolor('#f8f9fa')
        
        ax.plot(angles_closed, scores_closed, 'o-', linewidth=2.5, color=color, label=employee_name)
        ax.fill(angles_closed, scores_closed, alpha=fill_alpha, color=color)
        
        ax.set_xticks(angles)
        ax.set_xticklabels(categories, size=11, fontweight='bold')
        ax.set_ylim(0, max_score + 0.5)
        ax.set_yticks([1, 2, 3, 4])
        ax.set_yticklabels(['Trainee', 'Beginner', 'Intermediate', 'Expert'], size=9, color='gray')
        
        plt.title(f"Skill Profile: {employee_name}", size=16, fontweight='bold', pad=20)
        
        if filename is None:
            filename = f"skill_radar_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        
        filepath = os.path.join(self.output_dir, filename)
        plt.tight_layout()
        plt.savefig(filepath, dpi=150, bbox_inches='tight')
        plt.close()
        
        return {"status": "success", "filepath": filepath}