import { useEffect, useState } from 'react'
import './App.css'

interface ApiResponse {
  message: string
  version: string
  timestamp: string
  environment: string
}

function App() {
  const [apiData, setApiData] = useState<ApiResponse | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('https://qtoh7sgol1.execute-api.us-east-1.amazonaws.com/prod')
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        const data = await response.json()
        setApiData(data)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch data')
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <h1>WebWaka Platform</h1>
        <p>Frontend Placeholder Application</p>
        
        <div className="api-response">
          <h2>Backend API Response:</h2>
          {loading && <p>Loading...</p>}
          {error && <p className="error">Error: {error}</p>}
          {apiData && (
            <div className="response-data">
              <p><strong>Message:</strong> {apiData.message}</p>
              <p><strong>Version:</strong> {apiData.version}</p>
              <p><strong>Environment:</strong> {apiData.environment}</p>
              <p><strong>Timestamp:</strong> {new Date(apiData.timestamp).toLocaleString()}</p>
            </div>
          )}
        </div>
      </header>
    </div>
  )
}

export default App
