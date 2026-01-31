"""
Analytics Processor
Unified entry point that routes queries to appropriate analytics modules.
"""

from typing import Dict, Any, List, Optional
from datetime import datetime
import json

from .stats_engine import StatsEngine
from .time_series import TimeSeriesAnalyzer
from .anomaly_detector import AnomalyDetector
from .pattern_analyzer import PatternAnalyzer
from .visualizer import Visualizer
from .skill_radar import SkillRadarChart

class AnalyticsProcessor:
    """
    Unified analytics processor that routes queries to appropriate modules.
    """
    
    def __init__(self, chart_output_dir: str = "./charts"):
        self.stats = StatsEngine()
        self.time_series = TimeSeriesAnalyzer()
        self.anomaly = AnomalyDetector()
        self.pattern = PatternAnalyzer()
        self.visualizer = Visualizer(output_dir=chart_output_dir)
        self.radar = SkillRadarChart(output_dir=chart_output_dir)
    # ---------------------------------------------------------
    # FIX: Added 'hash_map' argument here
    # ---------------------------------------------------------
    def process(
        self,
        query_result: Dict[str, Any],
        sql_data: List[Dict[str, Any]],
        hash_map: Dict[str, str] = None 
    ) -> Dict[str, Any]:
        """
        Main processing entry point.
        """
        query_type = query_result.get("query_type", "DIRECT_SQL")
        analysis_required = query_result.get("analysis_required", [])
        metric = query_result.get("metric", "attendance")
        visualization = query_result.get("visualization")
        
        result = {
            "query_type": query_type,
            "sql_data": sql_data,
            "analysis": {},
            "visualization": None,
            "natural_language_response": ""
        }
        
        if not sql_data:
            result["natural_language_response"] = "No data found for your query."
            return result
        
        # Route to appropriate processor
        if query_type == "DIRECT_SQL":
            result["analysis"] = self._process_direct_sql(sql_data)
        elif query_type == "SKILL_ANALYSIS":
            # Assume SQL returns: category_name, avg_score
            cats = [row.get('category_name') for row in sql_data]
            scores = [float(row.get('avg_skill_score', 0)) for row in sql_data]
            emp_name = "Employee"
            if sql_data:
                # Try to find name in result
                fname = sql_data[0].get('first_name')
                lname = sql_data[0].get('last_name')
                if fname: 
                    # Deanonymize name for the chart title
                    full_name = f"{fname} {lname}".strip()
                    emp_name = self._deanonymize_label(full_name, hash_map)

            result["visualization"] = self.radar.generate_radar_chart(cats, scores, emp_name)
            result["natural_language_response"] = f"Generated skill profile for {emp_name}."
            return result
        elif query_type == "SQL_WITH_STATS":
            result["analysis"] = self._process_with_stats(sql_data, analysis_required, metric)
        elif query_type == "PATTERN_DETECTION":
            result["analysis"] = self._process_pattern_detection(sql_data, analysis_required, metric)
        elif query_type == "ANOMALY_DETECTION":
            result["analysis"] = self._process_anomaly_detection(sql_data, metric)
        elif query_type == "TREND_ANALYSIS":
            result["analysis"] = self._process_trend_analysis(sql_data, metric)
        elif query_type == "COMPARISON":
            result["analysis"] = self._process_comparison(sql_data, metric)
        
        # Generate visualization if requested
        if visualization:
                    result["visualization"] = self._generate_visualization(sql_data, visualization, metric, {}, hash_map)
                    
                # Basic response generation
        result["natural_language_response"] = f"Found {len(sql_data)} records."
        if result["visualization"]:
            result["natural_language_response"] += " 📊 Chart generated."
            
        return result

    def _deanonymize_label(self, label: str, hash_map: Dict[str, str]) -> str:
        """Restores original name from hash in labels."""
        if not label or not hash_map:
            return label
        text = str(label)
        for token, original in sorted(hash_map.items(), key=lambda x: len(x[0]), reverse=True):
            if token in text:
                text = text.replace(token, original)
        return text

    # ... (Rest of the helper methods - simplified for brevity, keep your existing logic below) ...
    
    def _extract_numeric_values(self, data: List[Dict], key: str) -> List[float]:
        values = []
        for row in data:
            val = row.get(key)
            if val is not None:
                try: values.append(float(val))
                except: pass
        return values
    
    def _extract_dates(self, data: List[Dict], key: str = "date") -> List[str]:
        dates = []
        for row in data:
            val = row.get(key)
            if val: dates.append(str(val))
        return dates

    def _process_direct_sql(self, data: List[Dict]) -> Dict[str, Any]:
        return {"type": "direct_result", "row_count": len(data), "data": data}

    def _process_with_stats(self, data: List[Dict], analysis_required: List[str], metric: str) -> Dict[str, Any]:
        result = {"type": "statistical_analysis"}
        numeric_keys = ["work_hours", "hours", "count", "days", "present_days", "late_days", "absent_days", "present_count", "total_days"]
        values = []
        used_key = None
        for key in numeric_keys:
            values = self._extract_numeric_values(data, key)
            if values:
                used_key = key
                break
        if not values and data:
            for key, val in data[0].items():
                try:
                    float(val)
                    values = self._extract_numeric_values(data, key)
                    used_key = key
                    break
                except: pass
        if values:
            if "variance" in analysis_required or "consistency" in analysis_required:
                result["consistency"] = self.stats.calculate_consistency_score(values)
            result["variance_stats"] = self.stats.calculate_variance(values)
            result["analyzed_metric"] = used_key
        return result

    def _process_pattern_detection(self, data: List[Dict], analysis_required: List[str], metric: str) -> Dict[str, Any]:
        result = {"type": "pattern_analysis"}
        if "seasonal_pattern" in analysis_required or metric == "leaves":
            month_counts = {}
            for row in data:
                month = row.get("month")
                count = row.get("leave_count", row.get("count", 1))
                if month is not None:
                    try: month_counts[int(month)] = int(count)
                    except: pass
            if month_counts:
                result["seasonal"] = self.pattern.seasonal_leave_pattern(month_counts)
        return result

    def _process_anomaly_detection(self, data: List[Dict], metric: str) -> Dict[str, Any]:
        result = {"type": "anomaly_detection"}
        numeric_keys = ["work_hours", "hours", "count", "late_count", "present_count"]
        values = []
        labels = []
        used_key = None
        for key in numeric_keys:
            values = self._extract_numeric_values(data, key)
            if values:
                used_key = key
                labels = self._extract_dates(data)
                break
        if values:
            result["anomalies"] = self.anomaly.detect_anomalies(values, labels=labels if labels else None)
            result["analyzed_metric"] = used_key
        return result

    def _process_trend_analysis(self, data: List[Dict], metric: str) -> Dict[str, Any]:
        result = {"type": "trend_analysis"}
        numeric_keys = ["present_count", "attendance_rate", "work_hours", "late_count", "count", "present_days", "total_days"]
        values = []
        used_key = None
        for key in numeric_keys:
            values = self._extract_numeric_values(data, key)
            if values:
                used_key = key
                break
        if values:
            result["trend"] = self.time_series.detect_trend(values)
            result["change_points"] = self.time_series.change_point_detection(values)
            result["analyzed_metric"] = used_key
            dates = self._extract_dates(data, "month") or self._extract_dates(data, "date")
            if dates: result["time_labels"] = dates
        return result

    def _process_comparison(self, data: List[Dict], metric: str) -> Dict[str, Any]:
        result = {"type": "comparison"}
        comparisons = []
        for row in data:
            name = row.get("first_name", "") + " " + row.get("last_name", "")
            name = name.strip() or row.get("employee_id", "Unknown")
            comp_data = {"name": name}
            for key in ["present_days", "late_days", "absent_days", "work_hours", "total_days", "attendance_rate", "count"]:
                if key in row:
                    try: comp_data[key] = float(row[key])
                    except: comp_data[key] = row[key]
            comparisons.append(comp_data)
        result["comparisons"] = comparisons
        return result

    # ---------------------------------------------------------
    # FIX: Added hash_map argument here too
    # ---------------------------------------------------------
    def _generate_visualization(self, data, viz_type, metric, analysis, hash_map):
        # Extract Categories and Values with Deanonymization
        try:
            if viz_type == "line_chart":
                dates = [str(r.get('date', '')) for r in data]
                values = [float(r.get('count', r.get('work_hours', 0))) for r in data]
                return self.visualizer.line_chart(dates, values, title=f"{metric} Trend")
            
            elif viz_type == "bar_chart":
                cats = []
                vals = []
                for r in data:
                    # Find category key (name, month, status)
                    k = r.get('first_name') or r.get('name') or r.get('status')
                    if r.get('first_name'): k = f"{r.get('first_name')} {r.get('last_name')}"
                    
                    cats.append(self._deanonymize_label(str(k), hash_map))
                    vals.append(float(r.get('count', r.get('days', 0))))
                return self.visualizer.bar_chart(cats, vals, title=f"{metric} Comparison")
                
            elif viz_type == "pie_chart":
                cats = [self._deanonymize_label(r.get('status', r.get('type', '')), hash_map) for r in data]
                vals = [float(r.get('count', 0)) for r in data]
                return self.visualizer.pie_chart(cats, vals, title=f"{metric} Distribution")
                
        except Exception as e:
            return {"status": "error", "message": str(e)}
        return {"status": "skipped"}
    
    
    def _generate_nl_response(self, result: Dict) -> str:
        sql_data = result.get("sql_data", [])
        return f"Found {len(sql_data)} records."