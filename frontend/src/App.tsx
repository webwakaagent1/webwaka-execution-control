import { useEffect, useState } from 'react'
import './App.css'

interface ApiResponse {
  message: string
  version: string
  timestamp: string
  environment: string
}

interface UploadResponse {
  success: boolean
  uploadUrl: string
  key: string
  expiresIn: number
  timestamp: string
}

function App() {
  const [apiData, setApiData] = useState<ApiResponse | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [uploading, setUploading] = useState(false)
  const [uploadSuccess, setUploadSuccess] = useState<string | null>(null)
  const [uploadError, setUploadError] = useState<string | null>(null)

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

  const handleFileSelect = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files[0]) {
      setSelectedFile(event.target.files[0])
      setUploadSuccess(null)
      setUploadError(null)
    }
  }

  const handleUpload = async () => {
    if (!selectedFile) {
      setUploadError('Please select a file first')
      return
    }

    setUploading(true)
    setUploadError(null)
    setUploadSuccess(null)

    try {
      // Step 1: Get presigned URL from backend
      const response = await fetch('https://qtoh7sgol1.execute-api.us-east-1.amazonaws.com/prod/generate-upload-url', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          filename: selectedFile.name,
          contentType: selectedFile.type
        })
      })

      if (!response.ok) {
        throw new Error(`Failed to get upload URL: ${response.status}`)
      }

      const data: UploadResponse = await response.json()

      // Step 2: Upload file directly to S3 using presigned URL
      const uploadResponse = await fetch(data.uploadUrl, {
        method: 'PUT',
        headers: {
          'Content-Type': selectedFile.type
        },
        body: selectedFile
      })

      if (!uploadResponse.ok) {
        throw new Error(`Failed to upload file: ${uploadResponse.status}`)
      }

      setUploadSuccess(`File uploaded successfully! Key: ${data.key}`)
      setSelectedFile(null)
      // Reset file input
      const fileInput = document.getElementById('file-input') as HTMLInputElement
      if (fileInput) fileInput.value = ''
    } catch (err) {
      setUploadError(err instanceof Error ? err.message : 'Upload failed')
    } finally {
      setUploading(false)
    }
  }

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

        <div className="file-upload">
          <h2>File Upload:</h2>
          <div className="upload-controls">
            <input
              id="file-input"
              type="file"
              onChange={handleFileSelect}
              disabled={uploading}
            />
            <button
              onClick={handleUpload}
              disabled={!selectedFile || uploading}
              className="upload-button"
            >
              {uploading ? 'Uploading...' : 'Upload File'}
            </button>
          </div>
          {selectedFile && (
            <p className="file-info">
              Selected: {selectedFile.name} ({(selectedFile.size / 1024).toFixed(2)} KB)
            </p>
          )}
          {uploadSuccess && <p className="success">{uploadSuccess}</p>}
          {uploadError && <p className="error">Error: {uploadError}</p>}
        </div>
      </header>
    </div>
  )
}

export default App
