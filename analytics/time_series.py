"""
Time Series Analysis Module
Provides trend detection, moving averages, and change point detection.
"""

import numpy as np
from typing import List, Dict, Any, Tuple, Optional
from datetime import datetime
from scipy import stats as scipy_stats


class TimeSeriesAnalyzer:
    """Time series analysis for attendance and work patterns."""
    
    @staticmethod
    def moving_average(values: List[float], window: int = 7) -> List[float]:
        """
        Calculate moving average for smoothing.
        
        Args:
            values: Time series data
            window: Window size (default 7 for weekly)
            
        Returns:
            Smoothed values
        """
        if len(values) < window:
            return values
        
        arr = np.array(values, dtype=float)
        cumsum = np.cumsum(np.insert(arr, 0, 0))
        return list((cumsum[window:] - cumsum[:-window]) / window)
    
    @staticmethod
    def detect_trend(
        values: List[float],
        dates: List[datetime] = None
    ) -> Dict[str, Any]:
        """
        Detect upward/downward trend using linear regression.
        
        Args:
            values: Time series data
            dates: Optional dates (uses index if not provided)
            
        Returns:
            Trend direction, slope, and confidence
        """
        if len(values) < 3:
            return {"trend": "insufficient_data", "confidence": 0}
        
        x = np.arange(len(values))
        y = np.array(values, dtype=float)
        
        # Linear regression
        slope, intercept, r_value, p_value, std_err = scipy_stats.linregress(x, y)
        
        # Calculate percentage change
        if intercept != 0:
            total_change = slope * len(values)
            pct_change = (total_change / abs(intercept)) * 100
        else:
            pct_change = slope * len(values) * 100
        
        # Determine trend direction
        if p_value > 0.1:
            trend = "stable"
            confidence = (1 - p_value) * 100
        elif slope > 0:
            trend = "increasing"
            confidence = (1 - p_value) * 100
        else:
            trend = "decreasing"
            confidence = (1 - p_value) * 100
        
        # Interpretation
        if trend == "stable":
            interpretation = "No significant trend detected - your pattern is stable"
        elif trend == "increasing":
            interpretation = f"Upward trend detected (+{abs(pct_change):.1f}% change)"
        else:
            interpretation = f"Downward trend detected ({pct_change:.1f}% change)"
        
        return {
            "trend": trend,
            "slope": round(slope, 4),
            "r_squared": round(r_value ** 2, 3),
            "p_value": round(p_value, 4),
            "confidence": round(confidence, 1),
            "pct_change": round(pct_change, 1),
            "interpretation": interpretation
        }
    
    @staticmethod
    def seasonal_pattern(
        values: List[float],
        period_labels: List[str] = None
    ) -> Dict[str, Any]:
        """
        Detect seasonal/periodic patterns (e.g., monthly patterns).
        
        Args:
            values: Values grouped by period (e.g., leave counts per month)
            period_labels: Labels for periods (e.g., month names)
            
        Returns:
            Peak periods and pattern strength
        """
        if len(values) < 3:
            return {"pattern": "insufficient_data"}
        
        arr = np.array(values, dtype=float)
        mean_val = np.mean(arr)
        std_val = np.std(arr)
        
        # Find peaks (above mean + 0.5 std)
        threshold = mean_val + 0.5 * std_val
        peak_indices = np.where(arr > threshold)[0]
        
        # Find low periods
        low_threshold = mean_val - 0.5 * std_val
        low_indices = np.where(arr < low_threshold)[0]
        
        # Pattern strength based on coefficient of variation
        cv = (std_val / mean_val * 100) if mean_val > 0 else 0
        
        if cv > 30:
            pattern_strength = "strong"
        elif cv > 15:
            pattern_strength = "moderate"
        else:
            pattern_strength = "weak"
        
        # Build period info
        if period_labels and len(period_labels) == len(values):
            peak_periods = [period_labels[i] for i in peak_indices]
            low_periods = [period_labels[i] for i in low_indices]
        else:
            peak_periods = [f"Period {i+1}" for i in peak_indices]
            low_periods = [f"Period {i+1}" for i in low_indices]
        
        return {
            "pattern_strength": pattern_strength,
            "cv_percentage": round(cv, 1),
            "mean": round(mean_val, 2),
            "peak_periods": peak_periods,
            "low_periods": low_periods,
            "interpretation": f"{pattern_strength.capitalize()} seasonal pattern detected. "
                             f"Peak periods: {', '.join(peak_periods) if peak_periods else 'None'}"
        }
    
    @staticmethod
    def change_point_detection(
        values: List[float],
        threshold: float = 2.0
    ) -> Dict[str, Any]:
        """
        Detect significant change points in the time series.
        Uses simple difference-based detection.
        
        Args:
            values: Time series data
            threshold: Z-score threshold for change detection
            
        Returns:
            Change points and their magnitudes
        """
        if len(values) < 5:
            return {"change_points": [], "interpretation": "Insufficient data"}
        
        arr = np.array(values, dtype=float)
        
        # Calculate differences
        diffs = np.diff(arr)
        mean_diff = np.mean(diffs)
        std_diff = np.std(diffs)
        
        if std_diff == 0:
            return {"change_points": [], "interpretation": "No variation detected"}
        
        # Find significant changes
        z_scores = (diffs - mean_diff) / std_diff
        change_indices = np.where(np.abs(z_scores) > threshold)[0]
        
        change_points = []
        for idx in change_indices:
            change_points.append({
                "position": int(idx + 1),
                "change_magnitude": round(diffs[idx], 2),
                "direction": "increase" if diffs[idx] > 0 else "decrease"
            })
        
        if change_points:
            interpretation = f"Found {len(change_points)} significant change point(s)"
        else:
            interpretation = "No significant change points detected - pattern is stable"
        
        return {
            "change_points": change_points,
            "total_changes": len(change_points),
            "interpretation": interpretation
        }
