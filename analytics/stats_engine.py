"""
Statistical Analysis Engine
Provides variance, consistency, correlation, and comparative analysis.
"""

import numpy as np
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta


class StatsEngine:
    """Statistical analysis for attendance and work metrics."""
    
    @staticmethod
    def calculate_variance(values: List[float]) -> Dict[str, float]:
        """
        Calculate variance and standard deviation.
        
        Args:
            values: List of numeric values (e.g., work hours per day)
            
        Returns:
            Dict with mean, variance, std_dev, and coefficient of variation
        """
        if not values or len(values) < 2:
            return {"mean": 0, "variance": 0, "std_dev": 0, "cv": 0}
        
        arr = np.array(values, dtype=float)
        mean = np.mean(arr)
        variance = np.var(arr, ddof=1)  # Sample variance
        std_dev = np.std(arr, ddof=1)
        cv = (std_dev / mean * 100) if mean != 0 else 0  # Coefficient of variation
        
        return {
            "mean": round(mean, 2),
            "variance": round(variance, 2),
            "std_dev": round(std_dev, 2),
            "cv": round(cv, 2)  # Percentage
        }
    
    @staticmethod
    def calculate_consistency_score(values: List[float], target: float = None) -> Dict[str, Any]:
        """
        Calculate a 0-100 consistency score.
        Lower variance = higher consistency.
        
        Args:
            values: List of numeric values
            target: Optional target value (e.g., 8 hours for work hours)
            
        Returns:
            Dict with consistency_score (0-100) and interpretation
        """
        if not values or len(values) < 2:
            return {"consistency_score": 0, "interpretation": "Insufficient data"}
        
        stats = StatsEngine.calculate_variance(values)
        cv = stats["cv"]
        
        # Convert CV to consistency score (lower CV = higher consistency)
        # CV < 5% = excellent, CV > 30% = poor
        if cv <= 5:
            score = 95 + (5 - cv)
        elif cv <= 10:
            score = 85 + (10 - cv)
        elif cv <= 15:
            score = 70 + (15 - cv)
        elif cv <= 20:
            score = 55 + (20 - cv)
        elif cv <= 30:
            score = 35 + (30 - cv) * 0.5
        else:
            score = max(0, 35 - (cv - 30))
        
        score = min(100, max(0, score))
        
        if score >= 85:
            interpretation = "Excellent consistency"
        elif score >= 70:
            interpretation = "Good consistency"
        elif score >= 55:
            interpretation = "Moderate consistency"
        elif score >= 35:
            interpretation = "Below average consistency"
        else:
            interpretation = "High fluctuation - needs attention"
        
        return {
            "consistency_score": round(score, 1),
            "interpretation": interpretation,
            "cv_percentage": stats["cv"],
            "std_dev": stats["std_dev"],
            "mean": stats["mean"]
        }
    
    @staticmethod
    def comparative_analysis(
        individual_values: List[float],
        team_values: List[float]
    ) -> Dict[str, Any]:
        """
        Compare individual metrics against team average.
        
        Args:
            individual_values: Individual's data points
            team_values: Team's aggregated data points
            
        Returns:
            Comparison results with percentile and interpretation
        """
        if not individual_values or not team_values:
            return {"error": "Insufficient data for comparison"}
        
        ind_mean = np.mean(individual_values)
        team_mean = np.mean(team_values)
        team_std = np.std(team_values, ddof=1) if len(team_values) > 1 else 1
        
        # Z-score relative to team
        z_score = (ind_mean - team_mean) / team_std if team_std > 0 else 0
        
        # Percentile (approximate from z-score)
        from scipy import stats as scipy_stats
        percentile = scipy_stats.norm.cdf(z_score) * 100
        
        # Difference
        diff = ind_mean - team_mean
        diff_percent = (diff / team_mean * 100) if team_mean != 0 else 0
        
        if diff_percent > 10:
            interpretation = "Above team average"
        elif diff_percent < -10:
            interpretation = "Below team average"
        else:
            interpretation = "Aligned with team average"
        
        return {
            "individual_mean": round(ind_mean, 2),
            "team_mean": round(team_mean, 2),
            "difference": round(diff, 2),
            "difference_percent": round(diff_percent, 1),
            "percentile": round(percentile, 1),
            "interpretation": interpretation
        }
    
    @staticmethod
    def correlation_analysis(
        series1: List[float],
        series2: List[float],
        label1: str = "Series 1",
        label2: str = "Series 2"
    ) -> Dict[str, Any]:
        """
        Calculate correlation between two series.
        Useful for: leaves vs holidays, attendance vs project changes
        
        Args:
            series1: First data series
            series2: Second data series
            label1: Label for first series
            label2: Label for second series
            
        Returns:
            Correlation coefficient and interpretation
        """
        if len(series1) != len(series2) or len(series1) < 3:
            return {"error": "Insufficient or mismatched data"}
        
        correlation = np.corrcoef(series1, series2)[0, 1]
        
        if np.isnan(correlation):
            return {"error": "Cannot calculate correlation (constant values)"}
        
        abs_corr = abs(correlation)
        if abs_corr >= 0.7:
            strength = "Strong"
        elif abs_corr >= 0.4:
            strength = "Moderate"
        elif abs_corr >= 0.2:
            strength = "Weak"
        else:
            strength = "No significant"
        
        direction = "positive" if correlation > 0 else "negative"
        
        return {
            "correlation": round(correlation, 3),
            "strength": strength,
            "direction": direction,
            "interpretation": f"{strength} {direction} correlation between {label1} and {label2}"
        }
