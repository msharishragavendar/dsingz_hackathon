"""
Natural Language Response Generator
Converts raw SQL results into human-friendly summaries using LLM.
"""

import requests
from typing import Dict, Any, List
from datetime import datetime


class NLResponseGenerator:
    """Generate natural language responses from query results."""
    
    def __init__(self, api_key: str, api_url: str):
        self.api_key = api_key
        self.api_url = api_url
        self.model = "google/gemini-2.0-flash-001"
    
    def generate(self, query_info: Dict[str, Any], sql_data: List[Dict], 
                 analysis: Dict[str, Any] = None) -> str:
        """
        Generate a natural language response from query results.
        
        Args:
            query_info: Query classification and metadata
            sql_data: Raw SQL results
            analysis: Optional analytics results
            
        Returns:
            Human-friendly summary string
        """
        if not sql_data:
            return "No data found for your query."
        
        query_type = query_info.get('query_type', 'DIRECT_SQL')
        
        # Build context for LLM
        context = self._build_context(query_info, sql_data, analysis)
        
        # Generate response using LLM
        prompt = self._create_prompt(query_type, context)
        
        try:
            response = self._call_llm(prompt)
            return response
        except Exception as e:
            # Fallback to template-based response
            return self._fallback_response(query_type, sql_data, analysis)
    
    def _build_context(self, query_info: Dict, sql_data: List[Dict], 
                       analysis: Dict = None) -> Dict:
        """Build context dictionary for response generation."""
        context = {
            "query_type": query_info.get('query_type'),
            "metric": query_info.get('metric'),
            "record_count": len(sql_data),
            "sample_data": sql_data[:5],  # First 5 records
            "columns": list(sql_data[0].keys()) if sql_data else []
        }
        
        if analysis:
            context["analysis"] = analysis
            
        return context
    
    def _create_prompt(self, query_type: str, context: Dict) -> str:
        """Create prompt for LLM-based response generation."""
        return f"""
You are a friendly HR analytics assistant. Generate a concise, natural language summary.

QUERY TYPE: {query_type}
RECORDS FOUND: {context['record_count']}
DATA COLUMNS: {context['columns']}
SAMPLE DATA: {context['sample_data']}
ANALYSIS RESULTS: {context.get('analysis', 'None')}

RULES:
- Be conversational and helpful
- Highlight key insights
- Use bullet points for multiple items
- Include specific numbers/names when relevant
- Keep response under 100 words
- Don't mention technical details like SQL or JSON

Generate a natural language summary:
"""

    def _call_llm(self, prompt: str) -> str:
        """Call LLM API to generate response."""
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": prompt}],
            "temperature": 0.7,
            "max_tokens": 200
        }
        
        response = requests.post(self.api_url, headers=headers, json=payload, timeout=30)
        response.raise_for_status()
        
        result = response.json()
        return result['choices'][0]['message']['content'].strip()
    
    def _fallback_response(self, query_type: str, sql_data: List[Dict], 
                           analysis: Dict = None) -> str:
        """Generate template-based fallback response."""
        count = len(sql_data)
        
        templates = {
            "DIRECT_SQL": f"Found {count} record(s) matching your query.",
            "SQL_WITH_STATS": self._stats_template(sql_data, analysis),
            "PATTERN_DETECTION": self._pattern_template(analysis),
            "ANOMALY_DETECTION": self._anomaly_template(analysis),
            "TREND_ANALYSIS": self._trend_template(analysis),
            "COMPARISON": self._comparison_template(sql_data, analysis)
        }
        
        return templates.get(query_type, f"Found {count} record(s).")
    
    def _stats_template(self, data: List[Dict], analysis: Dict) -> str:
        """Template for statistical analysis responses."""
        if not analysis:
            return f"Analyzed {len(data)} records."
        
        stats = analysis.get('statistics', {})
        return f"📊 Analysis of {len(data)} records:\n" + \
               f"• Average: {stats.get('mean', 'N/A')}\n" + \
               f"• Range: {stats.get('min', 'N/A')} to {stats.get('max', 'N/A')}\n" + \
               f"• Consistency: {stats.get('consistency_score', 'N/A')}"
    
    def _pattern_template(self, analysis: Dict) -> str:
        """Template for pattern detection responses."""
        if not analysis:
            return "No significant patterns detected."
        
        patterns = analysis.get('patterns', [])
        if not patterns:
            return "No significant patterns detected."
        
        response = "🔍 Patterns detected:\n"
        for p in patterns[:3]:
            response += f"• {p}\n"
        return response
    
    def _anomaly_template(self, analysis: Dict) -> str:
        """Template for anomaly detection responses."""
        if not analysis:
            return "No anomalies detected."
        
        anomalies = analysis.get('anomalies', [])
        if not anomalies:
            return "✅ No anomalies detected - everything looks normal."
        
        return f"⚠️ Found {len(anomalies)} anomaly(ies) that may need attention."
    
    def _trend_template(self, analysis: Dict) -> str:
        """Template for trend analysis responses."""
        if not analysis:
            return "Insufficient data for trend analysis."
        
        trend = analysis.get('trend', {})
        direction = trend.get('direction', 'stable')
        
        icons = {"increasing": "📈", "decreasing": "📉", "stable": "➡️"}
        return f"{icons.get(direction, '📊')} Trend: {direction.title()}"
    
    def _comparison_template(self, data: List[Dict], analysis: Dict) -> str:
        """Template for comparison responses."""
        if not analysis:
            return f"Comparison data retrieved ({len(data)} records)."
        
        return "📊 Comparison complete - see the visualization for details."


# Convenience function for quick response generation
def generate_nl_response(query_info: Dict, sql_data: List[Dict], 
                         analysis: Dict = None, api_key: str = None, 
                         api_url: str = None) -> str:
    """
    Quick function to generate NL response.
    Falls back to templates if API credentials not provided.
    """
    if api_key and api_url:
        generator = NLResponseGenerator(api_key, api_url)
        return generator.generate(query_info, sql_data, analysis)
    else:
        # Template-based fallback
        generator = NLResponseGenerator("", "")
        return generator._fallback_response(
            query_info.get('query_type', 'DIRECT_SQL'),
            sql_data,
            analysis
        )
