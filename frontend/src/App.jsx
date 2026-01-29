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
    const chatEndRef = useRef(null)
    const textareaRef = useRef(null)

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

    const handleSubmit = async (messageText = input) => {
        if (!messageText.trim() || isLoading) return

        const userMessage = {
            role: 'user',
            content: messageText.trim()
        }

        setMessages(prev => [...prev, userMessage])
        setInput('')
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
                <div className="input-container">
                    <textarea
                        ref={textareaRef}
                        className="input-textarea"
                        placeholder="Ask a question about your data..."
                        value={input}
                        onChange={(e) => setInput(e.target.value)}
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
        </div>
    )
}

// ========================================
// Welcome Screen Component
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

// ========================================
// Message Component
// ========================================
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

// ========================================
// Data Table Component
// ========================================
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

// ========================================
// Typing Indicator Component
// ========================================
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

// ========================================
// Send Icon Component
// ========================================
function SendIcon() {
    return (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
        </svg>
    )
}

export default App
