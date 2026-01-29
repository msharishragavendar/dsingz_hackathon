"""
Anomaly Detection Engine
Provides Z-score, IQR, and spike detection for attendance data.
"""

import numpy as np
from typing import List, Dict, Any, Optional
from datetime import datetime


class AnomalyDetector:
    """Anomaly detection for attendance and work patterns."""
    
    @staticmethod
    def zscore_outliers(
        values: List[float],
        threshold: float = 2.0,
        labels: List[str] = None
    ) -> Dict[str, Any]:
        """
        Detect outliers using Z-score method.
        
        Args:
            values: Data values
            threshold: Z-score threshold (default 2.0 = ~95% confidence)
            labels: Optional labels for data points (e.g., dates)
            
        Returns:
            Outliers with their positions and z-scores
        """
        if len(values) < 3:
            return {"outliers": [], "interpretation": "Insufficient data"}
        
        arr = np.array(values, dtype=float)
        mean_val = np.mean(arr)
        std_val = np.std(arr, ddof=1)
        
        if std_val == 0:
            return {"outliers": [], "interpretation": "No variation in data"}
        
        z_scores = (arr - mean_val) / std_val
        outlier_indices = np.where(np.abs(z_scores) > threshold)[0]
        
        outliers = []
        for idx in outlier_indices:
            outliers.append({
                "position": int(idx),
                "label": labels[idx] if labels and idx < len(labels) else f"Point {idx}",
                "value": round(values[idx], 2),
                "z_score": round(z_scores[idx], 2),
                "type": "high" if z_scores[idx] > 0 else "low"
            })
        
        return {
            "outliers": outliers,
            "total_outliers": len(outliers),
            "mean": round(mean_val, 2),
            "std_dev": round(std_val, 2),
            "interpretation": f"Found {len(outliers)} unusual value(s)" if outliers else "No anomalies detected"
        }
    
    @staticmethod
    def iqr_outliers(
        values: List[float],
        multiplier: float = 1.5,
        labels: List[str] = None
    ) -> Dict[str, Any]:
        """
        Detect outliers using Interquartile Range (IQR) method.
        More robust to extreme values than Z-score.
        
        Args:
            values: Data values
            multiplier: IQR multiplier (1.5 = mild outliers, 3.0 = extreme)
            labels: Optional labels for data points
            
        Returns:
            Outliers with their positions
        """
        if len(values) < 4:
            return {"outliers": [], "interpretation": "Insufficient data"}
        
        arr = np.array(values, dtype=float)
        q1 = np.percentile(arr, 25)
        q3 = np.percentile(arr, 75)
        iqr = q3 - q1
        
        lower_bound = q1 - multiplier * iqr
        upper_bound = q3 + multiplier * iqr
        
        outlier_indices = np.where((arr < lower_bound) | (arr > upper_bound))[0]
        
        outliers = []
        for idx in outlier_indices:
            outliers.append({
                "position": int(idx),
                "label": labels[idx] if labels and idx < len(labels) else f"Point {idx}",
                "value": round(values[idx], 2),
                "type": "high" if values[idx] > upper_bound else "low"
            })
        
        return {
            "outliers": outliers,
            "total_outliers": len(outliers),
            "q1": round(q1, 2),
            "q3": round(q3, 2),
            "iqr": round(iqr, 2),
            "lower_bound": round(lower_bound, 2),
            "upper_bound": round(upper_bound, 2),
            "interpretation": f"Found {len(outliers)} outlier(s)" if outliers else "No outliers detected"
        }
    
    @staticmethod
    def spike_detection(
        values: List[float],
        threshold: float = 2.0,
        labels: List[str] = None
    ) -> Dict[str, Any]:
        """
        Detect sudden spikes or drops in sequential data.
        Looks at day-over-day changes.
        
        Args:
            values: Sequential data values
            threshold: Z-score threshold for change magnitude
            labels: Optional labels for data points
            
        Returns:
            Detected spikes with their positions and magnitudes
        """
        if len(values) < 3:
            return {"spikes": [], "interpretation": "Insufficient data"}
        
        arr = np.array(values, dtype=float)
        
        # Calculate day-over-day changes
        changes = np.diff(arr)
        mean_change = np.mean(changes)
        std_change = np.std(changes, ddof=1)
        
        if std_change == 0:
            return {"spikes": [], "interpretation": "No variation in changes"}
        
        z_scores = (changes - mean_change) / std_change
        spike_indices = np.where(np.abs(z_scores) > threshold)[0]
        
        spikes = []
        for idx in spike_indices:
            spikes.append({
                "position": int(idx + 1),  # +1 because diff reduces length by 1
                "label": labels[idx + 1] if labels and idx + 1 < len(labels) else f"Point {idx + 1}",
                "change": round(changes[idx], 2),
                "type": "spike_up" if changes[idx] > 0 else "spike_down",
                "z_score": round(z_scores[idx], 2)
            })
        
        return {
            "spikes": spikes,
            "total_spikes": len(spikes),
            "avg_change": round(mean_change, 2),
            "interpretation": f"Found {len(spikes)} sudden change(s)" if spikes else "No sudden changes detected"
        }
    
    @staticmethod
    def detect_anomalies(
        values: List[float],
        labels: List[str] = None,
        method: str = "combined"
    ) -> Dict[str, Any]:
        """
        Combined anomaly detection using multiple methods.
        
        Args:
            values: Data values
            labels: Optional labels
            method: "zscore", "iqr", "spike", or "combined"
            
        Returns:
            Comprehensive anomaly report
        """
        results = {
            "method": method,
            "data_points": len(values)
        }
        
        if method in ["zscore", "combined"]:
            results["zscore_analysis"] = AnomalyDetector.zscore_outliers(values, labels=labels)
        
        if method in ["iqr", "combined"]:
            results["iqr_analysis"] = AnomalyDetector.iqr_outliers(values, labels=labels)
        
        if method in ["spike", "combined"]:
            results["spike_analysis"] = AnomalyDetector.spike_detection(values, labels=labels)
        
        # Summary for combined
        if method == "combined":
            total_issues = (
                results.get("zscore_analysis", {}).get("total_outliers", 0) +
                results.get("spike_analysis", {}).get("total_spikes", 0)
            )
            
            if total_issues == 0:
                results["summary"] = "No anomalies detected - your pattern is consistent"
            elif total_issues <= 2:
                results["summary"] = f"Minor anomalies detected ({total_issues} unusual points)"
            else:
                results["summary"] = f"Multiple anomalies detected ({total_issues} unusual points) - worth reviewing"
        
        return results
