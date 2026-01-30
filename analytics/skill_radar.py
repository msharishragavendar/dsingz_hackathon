"""
Skill Radar Chart Generator
Generates spider/radar charts for employee skill profile visualization.
"""

import os
import numpy as np
import matplotlib.pyplot as plt
from typing import List, Dict, Any, Optional
from datetime import datetime


# Skill level to numeric score mapping
SKILL_LEVEL_SCORES = {
    'trainee': 1,
    'beginner': 2,
    'intermediate': 3,
    'expert': 4
}


def get_skill_aggregation_sql(employee_uuid: str) -> str:
    """
    Generate SQL query to aggregate employee skills by category.
    
    Args:
        employee_uuid: The UUID of the employee
        
    Returns:
        SQL query string for skill aggregation
    """
    sql = f"""
    SELECT 
        c.name AS category_name,
        AVG(
            CASE es.level
                WHEN 'trainee' THEN 1
                WHEN 'beginner' THEN 2
                WHEN 'intermediate' THEN 3
                WHEN 'expert' THEN 4
                ELSE 0
            END
        ) AS avg_skill_score,
        COUNT(DISTINCT t.uuid) AS technology_count,
        GROUP_CONCAT(DISTINCT t.technology_name SEPARATOR ', ') AS technologies
    FROM employees e
    INNER JOIN employees_skills es ON es.employee_id = e.uuid
    INNER JOIN employee_skill_technologies est ON est.employee_skill_id = es.uuid
    INNER JOIN technologies t ON t.uuid = est.technology_id
    INNER JOIN categories c ON c.uuid = t.category_id
    WHERE e.uuid = '{employee_uuid}'
    GROUP BY c.uuid, c.name
    ORDER BY c.name;
    """
    return sql


def get_skill_aggregation_sql_by_name(first_name: str) -> str:
    """
    Generate SQL query to aggregate employee skills by category using first name.
    
    Args:
        first_name: The first name of the employee
        
    Returns:
        SQL query string for skill aggregation
    """
    sql = f"""
    SELECT 
        c.name AS category_name,
        AVG(
            CASE es.level
                WHEN 'trainee' THEN 1
                WHEN 'beginner' THEN 2
                WHEN 'intermediate' THEN 3
                WHEN 'expert' THEN 4
                ELSE 0
            END
        ) AS avg_skill_score,
        COUNT(DISTINCT t.uuid) AS technology_count,
        GROUP_CONCAT(DISTINCT t.technology_name SEPARATOR ', ') AS technologies,
        e.first_name,
        e.last_name
    FROM employees e
    INNER JOIN employees_skills es ON es.employee_id = e.uuid
    INNER JOIN employee_skill_technologies est ON est.employee_skill_id = es.uuid
    INNER JOIN technologies t ON t.uuid = est.technology_id
    INNER JOIN categories c ON c.uuid = t.category_id
    WHERE LOWER(e.first_name) = LOWER('{first_name}')
    GROUP BY c.uuid, c.name, e.first_name, e.last_name
    ORDER BY c.name;
    """
    return sql


class SkillRadarChart:
    """
    Generates spider/radar charts for employee skill profiles.
    
    Why Radar Charts for Skills?
    ----------------------------
    Radar charts are ideal for skill comparison because:
    1. Multi-dimensional: Display multiple skill categories simultaneously
    2. Visual balance: Quickly identify strengths and weaknesses
    3. Comparative: Easy to overlay multiple employees for comparison
    4. Intuitive: The "filled area" gives immediate sense of overall capability
    5. Scalable: Works well with 4-10 categories (typical skill domains)
    """
    
    def __init__(self, output_dir: str = "./charts"):
        """Initialize the skill radar chart generator."""
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
        """
        Generate a spider/radar chart for employee skills.
        
        Args:
            categories: List of skill category names
            scores: List of average scores per category (1-4 scale)
            employee_name: Name of the employee for the title
            filename: Output filename (auto-generated if None)
            color: Line and fill color
            fill_alpha: Transparency of filled area (0-1)
            max_score: Maximum score value (default 4)
            
        Returns:
            Dict with status, filepath, and interpretation
        """
        if len(categories) < 3:
            return {
                "status": "error",
                "message": "Need at least 3 categories for a radar chart"
            }
        
        # Number of categories
        num_cats = len(categories)
        
        # Create angles for each category (evenly spaced around circle)
        angles = np.linspace(0, 2 * np.pi, num_cats, endpoint=False).tolist()
        
        # Close the polygon by appending first value
        scores_closed = scores + [scores[0]]
        angles_closed = angles + [angles[0]]
        
        # Create figure
        fig, ax = plt.subplots(figsize=(10, 10), subplot_kw=dict(polar=True))
        
        # Set background color
        fig.patch.set_facecolor('#1a1a2e')
        ax.set_facecolor('#1a1a2e')
        
        # Plot the radar chart
        ax.plot(angles_closed, scores_closed, 'o-', linewidth=2.5, color=color, label=employee_name)
        ax.fill(angles_closed, scores_closed, alpha=fill_alpha, color=color)
        
        # Add score points
        for angle, score in zip(angles, scores):
            ax.scatter(angle, score, s=100, color=color, zorder=5, edgecolors='white', linewidths=2)
        
        # Set category labels
        ax.set_xticks(angles)
        ax.set_xticklabels(categories, size=11, color='white', fontweight='bold')
        
        # Set radial limits and ticks
        ax.set_ylim(0, max_score + 0.5)
        ax.set_yticks([1, 2, 3, 4])
        ax.set_yticklabels(['Trainee', 'Beginner', 'Intermediate', 'Expert'], 
                           size=9, color='#888888')
        
        # Style the grid
        ax.spines['polar'].set_color('#444444')
        ax.grid(color='#444444', linestyle='-', linewidth=0.5, alpha=0.7)
        
        # Add title
        plt.title(
            f"Skill Profile: {employee_name}",
            size=16, color='white', fontweight='bold',
            pad=20
        )
        
        # Add legend
        ax.legend(loc='upper right', bbox_to_anchor=(1.15, 1.1), 
                  facecolor='#2a2a4a', edgecolor='#444444', labelcolor='white')
        
        # Generate filename
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            safe_name = employee_name.replace(" ", "_").lower()
            filename = f"skill_radar_{safe_name}_{timestamp}.png"
        
        filepath = os.path.join(self.output_dir, filename)
        plt.tight_layout()
        plt.savefig(filepath, dpi=150, bbox_inches='tight', 
                    facecolor='#1a1a2e', edgecolor='none')
        plt.close()
        
        # Generate interpretation
        interpretation = self._interpret_skills(categories, scores, employee_name)
        
        return {
            "status": "success",
            "filepath": filepath,
            "interpretation": interpretation,
            "data": {
                "categories": categories,
                "scores": scores,
                "employee": employee_name
            }
        }
    
    def generate_comparison_radar(
        self,
        categories: List[str],
        employees_data: List[Dict[str, Any]],
        filename: str = None,
        max_score: float = 4.0
    ) -> Dict[str, Any]:
        """
        Generate a comparison radar chart for multiple employees.
        
        Args:
            categories: List of skill category names
            employees_data: List of dicts with 'name', 'scores', and optional 'color'
            filename: Output filename
            max_score: Maximum score value
            
        Returns:
            Dict with status and filepath
        """
        if len(categories) < 3:
            return {
                "status": "error",
                "message": "Need at least 3 categories for a radar chart"
            }
        
        colors = ['#4A90D9', '#E94560', '#00D9C0', '#FFB830', '#8B5CF6']
        num_cats = len(categories)
        angles = np.linspace(0, 2 * np.pi, num_cats, endpoint=False).tolist()
        angles_closed = angles + [angles[0]]
        
        fig, ax = plt.subplots(figsize=(12, 10), subplot_kw=dict(polar=True))
        fig.patch.set_facecolor('#1a1a2e')
        ax.set_facecolor('#1a1a2e')
        
        for i, emp in enumerate(employees_data):
            color = emp.get('color', colors[i % len(colors)])
            scores = emp['scores']
            scores_closed = scores + [scores[0]]
            
            ax.plot(angles_closed, scores_closed, 'o-', linewidth=2, 
                   color=color, label=emp['name'])
            ax.fill(angles_closed, scores_closed, alpha=0.15, color=color)
        
        ax.set_xticks(angles)
        ax.set_xticklabels(categories, size=11, color='white', fontweight='bold')
        ax.set_ylim(0, max_score + 0.5)
        ax.set_yticks([1, 2, 3, 4])
        ax.set_yticklabels(['Trainee', 'Beginner', 'Intermediate', 'Expert'], 
                           size=9, color='#888888')
        
        ax.spines['polar'].set_color('#444444')
        ax.grid(color='#444444', linestyle='-', linewidth=0.5, alpha=0.7)
        
        plt.title("Skill Profile Comparison", size=16, color='white', 
                  fontweight='bold', pad=20)
        ax.legend(loc='upper right', bbox_to_anchor=(1.25, 1.1),
                  facecolor='#2a2a4a', edgecolor='#444444', labelcolor='white')
        
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"skill_comparison_{timestamp}.png"
        
        filepath = os.path.join(self.output_dir, filename)
        plt.tight_layout()
        plt.savefig(filepath, dpi=150, bbox_inches='tight',
                    facecolor='#1a1a2e', edgecolor='none')
        plt.close()
        
        return {
            "status": "success",
            "filepath": filepath,
            "employees_compared": [e['name'] for e in employees_data]
        }
    
    def _interpret_skills(
        self, 
        categories: List[str], 
        scores: List[float],
        employee_name: str
    ) -> str:
        """Generate analytical interpretation of the skill profile."""
        
        if not scores:
            return "No skill data available for interpretation."
        
        avg_score = sum(scores) / len(scores)
        max_idx = scores.index(max(scores))
        min_idx = scores.index(min(scores))
        
        level_names = {1: "Trainee", 2: "Beginner", 3: "Intermediate", 4: "Expert"}
        avg_level = level_names.get(round(avg_score), "Developing")
        
        # Count expert-level skills
        expert_count = sum(1 for s in scores if s >= 3.5)
        
        interpretation = f"""
**Skill Profile Analysis for {employee_name}**

📊 **Overall Assessment**: {avg_level} Level (Average Score: {avg_score:.2f}/4.0)

💪 **Strongest Area**: {categories[max_idx]} (Score: {scores[max_idx]:.2f})
📈 **Growth Opportunity**: {categories[min_idx]} (Score: {scores[min_idx]:.2f})

🎯 **Key Observations**:
- {expert_count} out of {len(categories)} skill categories at Intermediate/Expert level
- Skill balance ratio: {(max(scores) - min(scores)):.2f} (lower = more balanced)
"""
        
        if avg_score >= 3.5:
            interpretation += "\n✨ **Recommendation**: Consider for senior/lead technical roles"
        elif avg_score >= 2.5:
            interpretation += "\n✨ **Recommendation**: Ready for independent project work"
        else:
            interpretation += "\n✨ **Recommendation**: Focus on structured learning and mentorship"
        
        return interpretation.strip()


def process_skill_data(sql_results: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Process SQL results into format suitable for radar chart.
    
    Args:
        sql_results: List of dicts from SQL query
        
    Returns:
        Dict with categories, scores, and metadata
    """
    if not sql_results:
        return {"categories": [], "scores": [], "error": "No data found"}
    
    categories = []
    scores = []
    details = []
    
    for row in sql_results:
        cat_name = row.get('category_name', 'Unknown')
        avg_score = float(row.get('avg_skill_score', 0))
        tech_count = row.get('technology_count', 0)
        technologies = row.get('technologies', '')
        
        categories.append(cat_name)
        scores.append(avg_score)
        details.append({
            "category": cat_name,
            "score": avg_score,
            "technology_count": tech_count,
            "technologies": technologies
        })
    
    # Get employee name if available
    employee_name = "Employee"
    if sql_results and 'first_name' in sql_results[0]:
        first_name = sql_results[0].get('first_name', '')
        last_name = sql_results[0].get('last_name', '')
        employee_name = f"{first_name} {last_name}".strip()
    
    return {
        "categories": categories,
        "scores": scores,
        "details": details,
        "employee_name": employee_name
    }


# Example usage and test
if __name__ == "__main__":
    # Sample data (simulating SQL query result)
    sample_data = [
        {"category_name": "Backend", "avg_skill_score": 3.5, "technology_count": 4, 
         "technologies": "Python, Java, Node.js, Go"},
        {"category_name": "Frontend", "avg_skill_score": 2.8, "technology_count": 3,
         "technologies": "React, Vue, Angular"},
        {"category_name": "Database", "avg_skill_score": 3.2, "technology_count": 3,
         "technologies": "MySQL, PostgreSQL, MongoDB"},
        {"category_name": "DevOps", "avg_skill_score": 2.0, "technology_count": 2,
         "technologies": "Docker, Kubernetes"},
        {"category_name": "Cloud", "avg_skill_score": 2.5, "technology_count": 2,
         "technologies": "AWS, GCP"},
        {"category_name": "Mobile", "avg_skill_score": 1.5, "technology_count": 1,
         "technologies": "Flutter"}
    ]
    
    # Process data
    processed = process_skill_data(sample_data)
    
    # Generate chart
    radar = SkillRadarChart(output_dir="./charts")
    result = radar.generate_radar_chart(
        categories=processed["categories"],
        scores=processed["scores"],
        employee_name="John Doe"
    )
    
    print(f"Chart generated: {result['filepath']}")
    print(result['interpretation'])
