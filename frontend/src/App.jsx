import { useState, useRef, useEffect } from 'react'
import ReactMarkdown from 'react-markdown'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { oneDark } from 'react-syntax-highlighter/dist/esm/styles/prism'


// ========================================
// Main App Component
// ========================================
function App() {
    const [messages, setMessages] = useState([])
    const [input, setInput] = useState('')
    const [isLoading, setIsLoading] = useState(false)

    const [showSettings, setShowSettings] = useState(false)
    const [settings, setSettings] = useState(null)
    
    // Autocomplete States
    const [employees, setEmployees] = useState([])
    const [showSuggestions, setShowSuggestions] = useState(false)
    const [filteredEmployees, setFilteredEmployees] = useState([])
    const [cursorPosition, setCursorPosition] = useState(0)

    const chatEndRef = useRef(null)
    const textareaRef = useRef(null)

    // 1. Fetch Employees on Load
    useEffect(() => {
        fetch('/api/employees')
            .then(res => res.json())
            .then(data => {
                if (data.success) setEmployees(data.employees)
            })
            .catch(err => console.error("Failed to load employees", err))
    }, [])

    // Auto-scroll to bottom
    useEffect(() => {
        chatEndRef.current?.scrollIntoView({ behavior: 'smooth' })
    }, [messages])

    // Auto-resize textarea
    useEffect(() => {
        if (textareaRef.current) {
            textareaRef.current.style.height = 'auto'
            textareaRef.current.style.height = Math.min(textareaRef.current.scrollHeight, 200) + 'px'
        }
    }, [input])

    // 2. Handle Input & Detect @
    const handleInputChange = (e) => {
        const val = e.target.value
        setInput(val)
        
        // Logic to find word being typed
        const cursor = e.target.selectionStart
        setCursorPosition(cursor)
        
        const textBeforeCursor = val.slice(0, cursor)
        const lastWordMatch = textBeforeCursor.match(/@([\w\s]*)$/)
        
        if (lastWordMatch) {
            const query = lastWordMatch[1].toLowerCase()
            const matches = employees.filter(emp => 
                emp.toLowerCase().includes(query)
            ).slice(0, 5) // Limit to 5 suggestions
            
            setFilteredEmployees(matches)
            setShowSuggestions(matches.length > 0)
        } else {
            setShowSuggestions(false)
        }
    }

    // 3. Handle Suggestion Click
    const handleMentionClick = (name) => {
        const textBeforeCursor = input.slice(0, cursorPosition)
        const textAfterCursor = input.slice(cursorPosition)
        
        // Replace the partial @mention with the full name
        const lastAtPos = textBeforeCursor.lastIndexOf('@')
        const newText = textBeforeCursor.slice(0, lastAtPos) + `@${name} ` + textAfterCursor
        
        setInput(newText)
        setShowSuggestions(false)
        textareaRef.current.focus()
    }
    // 4. Settings Logic
    const openSettings = () => {
        fetch('/api/settings')
            .then(res => res.json())
            .then(data => {
                if(data.success) setSettings(data.settings)
            })
            .catch(err => console.error("Failed to fetch settings", err))
        setShowSettings(true)
    }

    const saveSettings = () => {
        fetch('/api/settings', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(settings)
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) setShowSettings(false)
            else alert("Error saving settings")
        })
    }

    const updateSetting = (category, key, value) => {
        setSettings(prev => ({
            ...prev,
            [category]: {
                ...prev[category],
                [key]: parseInt(value)
            }
        }))
    }

    const handleSubmit = async (messageText = input) => {
        if (!messageText.trim() || isLoading) return

        const userMessage = {
            role: 'user',
            content: messageText.trim()
        }

        setMessages(prev => [...prev, userMessage])
        setInput('')
        setShowSuggestions(false) // Close popup
        setIsLoading(true)

        try {
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: messageText.trim() })
            })

            const data = await response.json()

            const assistantMessage = {
                role: 'assistant',
                content: data.response || 'No response received.',
                sql: data.sql_query,
                chart: data.chart,
                queryType: data.query_type,
                recordCount: data.record_count,
                data: data.data || [],
                error: !data.success ? data.error : null
            }

            setMessages(prev => [...prev, assistantMessage])
        } catch (error) {
            setMessages(prev => [...prev, {
                role: 'assistant',
                content: 'Sorry, there was an error connecting to the server.',
                error: error.message
            }])
        } finally {
            setIsLoading(false)
        }
    }

    const handleKeyDown = (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault()
            // If suggestions are open, select the first one (optional)
            // For now, we prioritize sending logic
            handleSubmit()
        }
    }

    const handleNewChat = () => {
        setMessages([])
        setInput('')
    }

    const handleSuggestionClick = (text) => {
        handleSubmit(text)
    }

    return (
        <div className="app">
            {/* Header */}
            <header className="header">
                <div className="header-title">
                    <span className="header-icon">🧠</span>
                    <span>NL2SQL Analytics</span>
                </div>
                <button className="new-chat-btn" onClick={handleNewChat}>
                    <span>+</span>
                    <span>New Chat</span>
                </button>
            </header>

            {/* Chat Container */}
            <div className="chat-container">
                <div className="chat-content">
                    {messages.length === 0 ? (
                        <WelcomeScreen onSuggestionClick={handleSuggestionClick} />
                    ) : (
                        <>
                            {messages.map((msg, idx) => (
                                <Message key={idx} message={msg} />
                            ))}
                            {isLoading && <TypingIndicator />}
                        </>
                    )}
                    <div ref={chatEndRef} />
                </div>
            </div>

            {/* Input Area */}
            <div className="input-area">
                {/* 4. Suggestion Popup (Now positioned correctly via CSS) */}
                {showSuggestions && (
                    <div className="suggestions-popup">
                        {filteredEmployees.map((emp, idx) => (
                            <div 
                                key={idx} 
                                className="suggestion-item"
                                onClick={() => handleMentionClick(emp)}
                            >
                                <span className="avatar">👤</span> {emp}
                            </div>
                        ))}
                    </div>
                )}

                <div className="input-container">
                    <textarea
                        ref={textareaRef}
                        className="input-textarea"
                        placeholder="Type a question..."
                        value={input}
                        onChange={handleInputChange}
                        onKeyDown={handleKeyDown}
                        rows={1}
                    />
                    <button
                        className="send-btn"
                        onClick={() => handleSubmit()}
                        disabled={!input.trim() || isLoading}
                    >
                        <SendIcon />
                    </button>
                </div>
                <p className="input-hint">Press Enter to send, Shift+Enter for new line</p>
            </div>

            {/* Settings Modal */}
            {showSettings && settings && (
                <div className="modal-overlay">
                    <div className="modal-content">
                        <div style={{display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:'15px'}}>
                            <h3 style={{margin:0}}>⚙️ Salary Config</h3>
                            <button onClick={() => setShowSettings(false)} style={{background:'none',border:'none',fontSize:'1.2rem',cursor:'pointer'}}>✕</button>
                        </div>
                        
                        <div className="setting-group">
                            <h4>Hourly Rates (₹)</h4>
                            <label>Intern: <input type="number" value={settings.rates.intern} onChange={e => updateSetting('rates','intern',e.target.value)} /></label>
                            <label>Employee: <input type="number" value={settings.rates.employee} onChange={e => updateSetting('rates','employee',e.target.value)} /></label>
                            <label>Expert: <input type="number" value={settings.rates.expert} onChange={e => updateSetting('rates','expert',e.target.value)} /></label>
                        </div>

                        <div className="setting-group">
                            <h4>Rules</h4>
                            <label>Expected Monthly Hours: <input type="number" value={settings.rules.expected_hours} onChange={e => updateSetting('rules','expected_hours',e.target.value)} /></label>
                            <label>Deficit Forgive Threshold (hrs): <input type="number" value={settings.rules.deficit_threshold} onChange={e => updateSetting('rules','deficit_threshold',e.target.value)} /></label>
                        </div>

                        <div className="modal-actions">
                            <button className="btn-secondary" onClick={() => setShowSettings(false)}>Cancel</button>
                            <button className="btn-primary" onClick={saveSettings}>Save Changes</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    )
}

// ========================================
// Restored UI Components
// ========================================

function WelcomeScreen({ onSuggestionClick }) {
    const suggestions = [
        { title: '📊 List Employees', text: 'List all employees with their details' },
        { title: '📅 Attendance', text: 'Show attendance for this month' },
        { title: '🏖️ Leave Stats', text: 'Show leave statistics by type' },
        { title: '👥 Team Compare', text: 'Compare team performance' }
    ]

    return (
        <div className="welcome-screen">
            <div className="welcome-icon">🧠</div>
            <h1 className="welcome-title">NL2SQL Analytics</h1>
            <p className="welcome-subtitle">
                Ask questions about your employee data in natural language
            </p>
            <div className="suggestions">
                {suggestions.map((s, idx) => (
                    <div
                        key={idx}
                        className="suggestion-card"
                        onClick={() => onSuggestionClick(s.text)}
                    >
                        <div className="suggestion-title">{s.title}</div>
                        <div className="suggestion-text">{s.text}</div>
                    </div>
                ))}
            </div>
        </div>
    )
}

function Message({ message }) {
    return (
        <div className={`message ${message.role}`}>
            <div className="message-avatar">
                {message.role === 'user' ? '👤' : '🤖'}
            </div>
            <div className="message-content">
                <ReactMarkdown
                    components={{
                        code({ node, inline, className, children, ...props }) {
                            const match = /language-(\w+)/.exec(className || '')
                            return !inline && match ? (
                                <SyntaxHighlighter
                                    style={oneDark}
                                    language={match[1]}
                                    PreTag="div"
                                    {...props}
                                >
                                    {String(children).replace(/\n$/, '')}
                                </SyntaxHighlighter>
                            ) : (
                                <code className={className} {...props}>
                                    {children}
                                </code>
                            )
                        }
                    }}
                >
                    {message.content}
                </ReactMarkdown>

                {/* Data Table Display */}
                {message.data && message.data.length > 0 && (
                    <DataTable data={message.data} />
                )}

                {/* SQL Query Display */}
                {message.sql && (
                    <div className="sql-query">
                        <strong>SQL:</strong> {message.sql}
                    </div>
                )}

                {/* Chart Display */}
                {message.chart && (
                    <div className="chart-container">
                        <img src={message.chart} alt="Generated Chart" />
                    </div>
                )}

                {/* Error Display */}
                {message.error && (
                    <div className="error-message">
                        ⚠️ {message.error}
                    </div>
                )}
            </div>
        </div>
    )
}

function DataTable({ data }) {
    if (!data || data.length === 0) return null

    const columns = Object.keys(data[0])
    // Prioritize important columns
    const priorityCols = ['first_name', 'last_name', 'employee_id', 'official_email', 'job_role', 'date_of_joining']
    const sortedCols = priorityCols.filter(c => columns.includes(c))
    const otherCols = columns.filter(c => !priorityCols.includes(c) && !['uuid', 'profile_image', 'pan_number', 'deleted_at', 'created_at', 'updated_at'].includes(c))
    const displayCols = [...sortedCols, ...otherCols].slice(0, 6)

    return (
        <div className="data-table-container">
            <table className="data-table">
                <thead>
                    <tr>
                        {displayCols.map(col => (
                            <th key={col}>{col.replace(/_/g, ' ')}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {data.slice(0, 10).map((row, idx) => (
                        <tr key={idx}>
                            {displayCols.map(col => (
                                <td key={col}>{String(row[col] ?? '-').slice(0, 30)}</td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
            {data.length > 10 && (
                <p className="table-more">...and {data.length - 10} more records</p>
            )}
        </div>
    )
}

function TypingIndicator() {
    return (
        <div className="message assistant">
            <div className="message-avatar">🤖</div>
            <div className="message-content">
                <div className="typing-indicator">
                    <div className="typing-dot"></div>
                    <div className="typing-dot"></div>
                    <div className="typing-dot"></div>
                </div>
            </div>
        </div>
    )
}

const GearIcon = () => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.38a2 2 0 0 0-.73-2.73l-.15-.1a2 2 0 0 1-1-1.72v-.51a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"></path>
        <circle cx="12" cy="12" r="3"></circle>
    </svg>
)


function SendIcon() {
    return (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
        </svg>
    )
}

export default App