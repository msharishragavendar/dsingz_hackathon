"""
Pattern Analysis Module
Provides behavioral pattern detection and classification.
"""

import numpy as np
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
from collections import Counter


class PatternAnalyzer:
    """Pattern recognition for attendance and leave behavior."""
    
    @staticmethod
    def weekend_leave_pattern(
        leave_dates: List[datetime],
        include_friday: bool = True,
        include_monday: bool = True
    ) -> Dict[str, Any]:
        """
        Analyze if leaves frequently fall near weekends.
        
        Args:
            leave_dates: List of leave dates
            include_friday: Consider Fridays as near-weekend
            include_monday: Consider Mondays as near-weekend
            
        Returns:
            Pattern analysis with percentages
        """
        if not leave_dates:
            return {"pattern": "no_data", "interpretation": "No leave data available"}
        
        near_weekend_count = 0
        day_distribution = Counter()
        
        for date in leave_dates:
            weekday = date.weekday()  # 0=Monday, 4=Friday, 5=Saturday, 6=Sunday
            day_distribution[weekday] += 1
            
            # Check if near weekend
            if (include_friday and weekday == 4) or \
               (include_monday and weekday == 0) or \
               weekday in [5, 6]:
                near_weekend_count += 1
        
        total_leaves = len(leave_dates)
        near_weekend_pct = (near_weekend_count / total_leaves) * 100
        
        # Expected percentage if random (Mon, Fri = ~40% of workdays if including both)
        expected_pct = 40 if (include_friday and include_monday) else 20
        
        if near_weekend_pct > expected_pct + 15:
            pattern = "strong_weekend_tendency"
            interpretation = f"Your leaves frequently fall near weekends ({near_weekend_pct:.0f}% vs expected {expected_pct}%)"
        elif near_weekend_pct > expected_pct + 5:
            pattern = "slight_weekend_tendency"
            interpretation = f"Slight tendency to take leaves near weekends ({near_weekend_pct:.0f}%)"
        else:
            pattern = "no_pattern"
            interpretation = "No significant weekend leave pattern detected"
        
        day_names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        return {
            "pattern": pattern,
            "near_weekend_percentage": round(near_weekend_pct, 1),
            "total_leaves": total_leaves,
            "near_weekend_count": near_weekend_count,
            "day_distribution": {day_names[k]: v for k, v in sorted(day_distribution.items())},
            "interpretation": interpretation
        }
    
    @staticmethod
    def seasonal_leave_pattern(
        leave_counts_by_month: Dict[int, int],
        month_names: List[str] = None
    ) -> Dict[str, Any]:
        """
        Identify which months have higher leave counts.
        
        Args:
            leave_counts_by_month: Dict mapping month number (1-12) to leave count
            month_names: Optional custom month names
            
        Returns:
            Seasonal pattern analysis
        """
        if not leave_counts_by_month:
            return {"pattern": "no_data", "interpretation": "No leave data available"}
        
        default_months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        months = month_names or default_months
        
        values = list(leave_counts_by_month.values())
        mean_leaves = np.mean(values)
        std_leaves = np.std(values)
        
        # Find high and low months
        high_months = []
        low_months = []
        
        for month_num, count in leave_counts_by_month.items():
            month_name = months[month_num - 1] if 1 <= month_num <= 12 else f"Month {month_num}"
            if count > mean_leaves + 0.5 * std_leaves:
                high_months.append((month_name, count))
            elif count < mean_leaves - 0.5 * std_leaves:
                low_months.append((month_name, count))
        
        # Sort by count
        high_months.sort(key=lambda x: x[1], reverse=True)
        low_months.sort(key=lambda x: x[1])
        
        cv = (std_leaves / mean_leaves * 100) if mean_leaves > 0 else 0
        
        if cv > 50:
            pattern_strength = "strong"
        elif cv > 25:
            pattern_strength = "moderate"
        else:
            pattern_strength = "weak"
        
        interpretation = f"{pattern_strength.capitalize()} seasonal pattern. "
        if high_months:
            interpretation += f"Peak leave months: {', '.join([m[0] for m in high_months[:3]])}. "
        if low_months:
            interpretation += f"Low leave months: {', '.join([m[0] for m in low_months[:3]])}."
        
        return {
            "pattern_strength": pattern_strength,
            "high_leave_months": [{"month": m[0], "count": m[1]} for m in high_months],
            "low_leave_months": [{"month": m[0], "count": m[1]} for m in low_months],
            "average_leaves_per_month": round(mean_leaves, 1),
            "cv_percentage": round(cv, 1),
            "interpretation": interpretation
        }
    
    @staticmethod
    def planned_vs_unplanned(
        leave_records: List[Dict[str, Any]]
    ) -> Dict[str, Any]:
        """
        Classify leave behavior as planned vs unplanned based on leave types.
        
        Args:
            leave_records: List of leave records with 'type' field
            
        Returns:
            Classification of leave behavior
        """
        if not leave_records:
            return {"pattern": "no_data", "interpretation": "No leave data available"}
        
        planned_types = ["planned", "vacation", "annual"]
        unplanned_types = ["sick", "emergency", "casual"]
        
        planned_count = 0
        unplanned_count = 0
        other_count = 0
        
        for record in leave_records:
            leave_type = record.get("type", "").lower()
            if any(p in leave_type for p in planned_types):
                planned_count += 1
            elif any(u in leave_type for u in unplanned_types):
                unplanned_count += 1
            else:
                other_count += 1
        
        total = len(leave_records)
        planned_pct = (planned_count / total) * 100
        unplanned_pct = (unplanned_count / total) * 100
        
        if planned_pct > 60:
            behavior = "mostly_planned"
            interpretation = f"Most of your leaves are planned ({planned_pct:.0f}%) - good planning habits"
        elif unplanned_pct > 60:
            behavior = "mostly_unplanned"
            interpretation = f"Most of your leaves are unplanned ({unplanned_pct:.0f}%) - consider planning ahead"
        else:
            behavior = "mixed"
            interpretation = f"Mixed leave pattern - {planned_pct:.0f}% planned, {unplanned_pct:.0f}% unplanned"
        
        return {
            "behavior": behavior,
            "planned_count": planned_count,
            "unplanned_count": unplanned_count,
            "other_count": other_count,
            "planned_percentage": round(planned_pct, 1),
            "unplanned_percentage": round(unplanned_pct, 1),
            "interpretation": interpretation
        }
    
    @staticmethod
    def arrival_pattern(
        check_in_times: List[datetime],
        expected_time: datetime = None
    ) -> Dict[str, Any]:
        """
        Classify arrival behavior as early, on-time, or late.
        
        Args:
            check_in_times: List of check-in datetime objects
            expected_time: Expected arrival time (default 9:00 AM)
            
        Returns:
            Arrival pattern classification
        """
        if not check_in_times:
            return {"pattern": "no_data", "interpretation": "No check-in data available"}
        
        if expected_time is None:
            expected_time = datetime.now().replace(hour=9, minute=0, second=0, microsecond=0)
        
        expected_minutes = expected_time.hour * 60 + expected_time.minute
        
        early_count = 0
        ontime_count = 0
        late_count = 0
        late_minutes_total = 0
        
        for check_in in check_in_times:
            check_in_minutes = check_in.hour * 60 + check_in.minute
            diff = check_in_minutes - expected_minutes
            
            if diff < -10:  # More than 10 mins early
                early_count += 1
            elif diff <= 10:  # Within 10 mins
                ontime_count += 1
            else:  # Late
                late_count += 1
                late_minutes_total += diff
        
        total = len(check_in_times)
        early_pct = (early_count / total) * 100
        ontime_pct = (ontime_count / total) * 100
        late_pct = (late_count / total) * 100
        avg_late_mins = late_minutes_total / late_count if late_count > 0 else 0
        
        if early_pct > 50:
            pattern = "early_bird"
            interpretation = f"You usually arrive early ({early_pct:.0f}% of the time)"
        elif late_pct > 30:
            pattern = "tends_late"
            interpretation = f"You tend to arrive late ({late_pct:.0f}% of the time, avg {avg_late_mins:.0f} mins late)"
        else:
            pattern = "punctual"
            interpretation = f"You're generally punctual ({ontime_pct:.0f}% on-time or early)"
        
        return {
            "pattern": pattern,
            "early_count": early_count,
            "ontime_count": ontime_count,
            "late_count": late_count,
            "early_percentage": round(early_pct, 1),
            "ontime_percentage": round(ontime_pct, 1),
            "late_percentage": round(late_pct, 1),
            "avg_late_minutes": round(avg_late_mins, 1),
            "interpretation": interpretation
        }
    
    @staticmethod
    def wfh_frequency_trend(
        wfh_counts: List[int],
        period_labels: List[str] = None
    ) -> Dict[str, Any]:
        """
        Analyze if work-from-home frequency is increasing.
        
        Args:
            wfh_counts: WFH count per period (e.g., per month)
            period_labels: Labels for periods
            
        Returns:
            WFH trend analysis
        """
        if len(wfh_counts) < 2:
            return {"trend": "insufficient_data", "interpretation": "Need more data for trend analysis"}
        
        # Simple trend using first vs last half comparison
        mid = len(wfh_counts) // 2
        first_half_avg = np.mean(wfh_counts[:mid])
        second_half_avg = np.mean(wfh_counts[mid:])
        
        change = second_half_avg - first_half_avg
        change_pct = (change / first_half_avg * 100) if first_half_avg > 0 else 0
        
        if change_pct > 20:
            trend = "increasing"
            interpretation = f"WFH frequency is increasing (+{change_pct:.0f}%)"
        elif change_pct < -20:
            trend = "decreasing"
            interpretation = f"WFH frequency is decreasing ({change_pct:.0f}%)"
        else:
            trend = "stable"
            interpretation = "WFH frequency is relatively stable"
        
        return {
            "trend": trend,
            "first_period_avg": round(first_half_avg, 1),
            "recent_period_avg": round(second_half_avg, 1),
            "change_percentage": round(change_pct, 1),
            "total_wfh_days": sum(wfh_counts),
            "interpretation": interpretation
        }
