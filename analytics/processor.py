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


class AnalyticsProcessor:
    """
    Unified analytics processor that routes queries to appropriate modules
    based on query type from the LLM classifier.
    """
    
    def __init__(self, chart_output_dir: str = "./charts"):
        """
        Initialize the analytics processor.
        
        Args:
            chart_output_dir: Directory to save visualization outputs
        """
        self.stats = StatsEngine()
        self.time_series = TimeSeriesAnalyzer()
        self.anomaly = AnomalyDetector()
        self.pattern = PatternAnalyzer()
        self.visualizer = Visualizer(output_dir=chart_output_dir)
    
    def process(
        self,
        query_result: Dict[str, Any],
        sql_data: List[Dict[str, Any]]
    ) -> Dict[str, Any]:
        """
        Main processing entry point.
        
        Args:
            query_result: Parsed JSON from LLM with query_type, analysis_required, etc.
            sql_data: Results from SQL execution
            
        Returns:
            Comprehensive analytics result
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
        
        # If no data, return early
        if not sql_data:
            result["natural_language_response"] = "No data found for your query."
            return result
        
        # Route to appropriate processor
        if query_type == "DIRECT_SQL":
            result["analysis"] = self._process_direct_sql(sql_data)
            
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
            result["visualization"] = self._generate_visualization(
                sql_data, visualization, metric, result["analysis"]
            )
        
        # Generate natural language response
        result["natural_language_response"] = self._generate_nl_response(result)
        
        return result
    
    def _extract_numeric_values(self, data: List[Dict], key: str) -> List[float]:
        """Extract numeric values from data list by key."""
        values = []
        for row in data:
            val = row.get(key)
            if val is not None:
                try:
                    values.append(float(val))
                except (ValueError, TypeError):
                    pass
        return values
    
    def _extract_dates(self, data: List[Dict], key: str = "date") -> List[str]:
        """Extract date strings from data."""
        dates = []
        for row in data:
            val = row.get(key)
            if val:
                dates.append(str(val))
        return dates
    
    def _process_direct_sql(self, data: List[Dict]) -> Dict[str, Any]:
        """Process direct SQL results - just format and return."""
        return {
            "type": "direct_result",
            "row_count": len(data),
            "data": data
        }
    
    def _process_with_stats(
        self,
        data: List[Dict],
        analysis_required: List[str],
        metric: str
    ) -> Dict[str, Any]:
        """Process SQL results with statistical analysis."""
        result = {"type": "statistical_analysis"}
        
        # Try to find the numeric column for stats
        numeric_keys = ["work_hours", "hours", "count", "days", "present_days", 
                        "late_days", "absent_days", "present_count", "total_days"]
        
        values = []
        used_key = None
        for key in numeric_keys:
            values = self._extract_numeric_values(data, key)
            if values:
                used_key = key
                break
        
        # Fallback: use first numeric column found
        if not values and data:
            for key, val in data[0].items():
                try:
                    float(val)
                    values = self._extract_numeric_values(data, key)
                    used_key = key
                    break
                except (ValueError, TypeError):
                    pass
        
        if values:
            if "variance" in analysis_required or "consistency" in analysis_required:
                result["consistency"] = self.stats.calculate_consistency_score(values)
            
            result["variance_stats"] = self.stats.calculate_variance(values)
            result["analyzed_metric"] = used_key
            result["data_points"] = len(values)
        
        return result
    
    def _process_pattern_detection(
        self,
        data: List[Dict],
        analysis_required: List[str],
        metric: str
    ) -> Dict[str, Any]:
        """Process pattern detection queries."""
        result = {"type": "pattern_analysis"}
        
        if "seasonal_pattern" in analysis_required or metric == "leaves":
            # Extract monthly leave counts
            month_counts = {}
            for row in data:
                month = row.get("month")
                count = row.get("leave_count", row.get("count", 1))
                if month is not None:
                    try:
                        month_counts[int(month)] = int(count)
                    except (ValueError, TypeError):
                        pass
            
            if month_counts:
                result["seasonal"] = self.pattern.seasonal_leave_pattern(month_counts)
        
        # WFH pattern
        if "wfh" in str(analysis_required).lower():
            wfh_counts = self._extract_numeric_values(data, "wfh_count")
            if wfh_counts:
                result["wfh_trend"] = self.pattern.wfh_frequency_trend(wfh_counts)
        
        return result
    
    def _process_anomaly_detection(
        self,
        data: List[Dict],
        metric: str
    ) -> Dict[str, Any]:
        """Process anomaly detection queries."""
        result = {"type": "anomaly_detection"}
        
        # Extract numeric values and labels
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
            result["anomalies"] = self.anomaly.detect_anomalies(
                values, labels=labels if labels else None
            )
            result["analyzed_metric"] = used_key
        
        return result
    
    def _process_trend_analysis(
        self,
        data: List[Dict],
        metric: str
    ) -> Dict[str, Any]:
        """Process trend analysis queries."""
        result = {"type": "trend_analysis"}
        
        # Extract values for trend
        numeric_keys = ["present_count", "attendance_rate", "work_hours", 
                        "late_count", "count", "present_days", "total_days"]
        
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
            
            # If we have dates, use them as labels
            dates = self._extract_dates(data, "month") or self._extract_dates(data, "date")
            if dates:
                result["time_labels"] = dates
        
        return result
    
    def _process_comparison(
        self,
        data: List[Dict],
        metric: str
    ) -> Dict[str, Any]:
        """Process comparison queries."""
        result = {"type": "comparison"}
        
        # Group data by person/entity
        comparisons = []
        for row in data:
            name = row.get("first_name", "") + " " + row.get("last_name", "")
            name = name.strip() or row.get("employee_id", "Unknown")
            
            comp_data = {"name": name}
            for key in ["present_days", "late_days", "absent_days", "work_hours", 
                        "total_days", "attendance_rate", "count"]:
                if key in row:
                    try:
                        comp_data[key] = float(row[key])
                    except (ValueError, TypeError):
                        comp_data[key] = row[key]
            
            comparisons.append(comp_data)
        
        result["comparisons"] = comparisons
        result["entities_compared"] = len(comparisons)
        
        return result
    
    def _generate_visualization(
        self,
        data: List[Dict],
        viz_type: str,
        metric: str,
        analysis: Dict
    ) -> Dict[str, Any]:
        """Generate appropriate visualization."""
        
        try:
            if viz_type == "line_chart":
                # Extract x and y values
                dates = self._extract_dates(data, "month") or \
                        self._extract_dates(data, "date") or \
                        [f"Point {i+1}" for i in range(len(data))]
                
                y_key = None
                for key in ["present_count", "count", "work_hours", "present_days", "attendance_rate"]:
                    if key in (data[0] if data else {}):
                        y_key = key
                        break
                
                if y_key:
                    values = self._extract_numeric_values(data, y_key)
                    return self.visualizer.line_chart(
                        dates[:len(values)], values,
                        title=f"{metric.replace('_', ' ').title()} Trend",
                        x_label="Time Period",
                        y_label=y_key.replace('_', ' ').title()
                    )
            
            elif viz_type == "bar_chart":
                # Extract categories and values
                if analysis.get("type") == "comparison":
                    comps = analysis.get("comparisons", [])
                    categories = [c["name"] for c in comps]
                    values = [c.get("present_days", 0) for c in comps]
                else:
                    # Use first string column as category, first numeric as value
                    categories = []
                    values = []
                    for row in data:
                        cat = row.get("name") or row.get("month") or row.get("status", "")
                        val = row.get("count", row.get("days", 0))
                        if cat:
                            categories.append(str(cat))
                            try:
                                values.append(float(val))
                            except:
                                values.append(0)
                
                if categories and values:
                    return self.visualizer.bar_chart(
                        categories, values,
                        title=f"{metric.replace('_', ' ').title()} Comparison"
                    )
            
            elif viz_type == "heatmap":
                # For heatmaps, we need 2D data (e.g., month x day)
                # This is a simplified version
                return {"status": "skipped", "reason": "Heatmap requires structured 2D data"}
            
            elif viz_type == "pie_chart":
                categories = []
                values = []
                for row in data:
                    cat = row.get("status") or row.get("type") or row.get("name", "")
                    val = row.get("count", row.get("days", 1))
                    if cat:
                        categories.append(str(cat))
                        try:
                            values.append(float(val))
                        except:
                            values.append(1)
                
                if categories and values:
                    return self.visualizer.pie_chart(
                        categories, values,
                        title=f"{metric.replace('_', ' ').title()} Distribution"
                    )
        
        except Exception as e:
            return {"status": "error", "message": str(e)}
        
        return {"status": "skipped", "reason": "Could not generate visualization"}
    
    def _generate_nl_response(self, result: Dict) -> str:
        """Generate a natural language response from the analysis."""
        analysis = result.get("analysis", {})
        analysis_type = analysis.get("type", "")
        
        # Start with data summary
        sql_data = result.get("sql_data", [])
        response_parts = [f"Found {len(sql_data)} record(s)."]
        
        if analysis_type == "statistical_analysis":
            consistency = analysis.get("consistency", {})
            if consistency:
                score = consistency.get("consistency_score", 0)
                interp = consistency.get("interpretation", "")
                response_parts.append(f"Consistency score: {score}/100 - {interp}")
            
            stats = analysis.get("variance_stats", {})
            if stats:
                response_parts.append(
                    f"Average: {stats.get('mean', 'N/A')}, "
                    f"Std Dev: {stats.get('std_dev', 'N/A')}"
                )
        
        elif analysis_type == "pattern_analysis":
            seasonal = analysis.get("seasonal", {})
            if seasonal:
                response_parts.append(seasonal.get("interpretation", ""))
            
            wfh = analysis.get("wfh_trend", {})
            if wfh:
                response_parts.append(wfh.get("interpretation", ""))
        
        elif analysis_type == "anomaly_detection":
            anomalies = analysis.get("anomalies", {})
            summary = anomalies.get("summary", "")
            if summary:
                response_parts.append(summary)
        
        elif analysis_type == "trend_analysis":
            trend = analysis.get("trend", {})
            if trend:
                response_parts.append(trend.get("interpretation", ""))
            
            changes = analysis.get("change_points", {})
            if changes:
                response_parts.append(changes.get("interpretation", ""))
        
        elif analysis_type == "comparison":
            comps = analysis.get("comparisons", [])
            if comps:
                response_parts.append(f"Compared {len(comps)} entities.")
        
        # Add visualization info
        viz = result.get("visualization", {})
        if viz and viz.get("status") == "success":
            response_parts.append(f"📊 Chart saved: {viz.get('filepath', '')}")
        
        return " ".join(response_parts)
