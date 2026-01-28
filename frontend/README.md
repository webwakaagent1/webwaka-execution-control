# WebWaka Frontend - Authentication UI

This directory contains the authentication UI components for the WebWaka platform, integrating with AWS Cognito for user management.

## Components

### AuthContainer
Main container component that manages the authentication flow and switches between login and registration views.

### Login
User login form with email and password fields. Integrates with AWS Cognito for authentication.

### Register
User registration form with email verification. Creates new users in the Cognito User Pool.

## Configuration

Before using these components, you need to configure the Cognito User Pool details:

1. Open `src/config/cognito.ts`
2. Replace the placeholder values with your actual Cognito User Pool ID and Client ID from Session 4

```typescript
const poolData = {
  UserPoolId: 'us-east-1_XXXXXXXXX', // Replace with actual User Pool ID
  ClientId: 'XXXXXXXXXXXXXXXXXXXXXXXXXX', // Replace with actual Client ID
};
```

Alternatively, set environment variables:
- `VITE_COGNITO_USER_POOL_ID`
- `VITE_COGNITO_CLIENT_ID`

## Installation

Install the required dependencies:

```bash
npm install amazon-cognito-identity-js
```

## Usage

```typescript
import { AuthContainer } from './components/auth/AuthContainer';

function App() {
  const handleAuthSuccess = (user) => {
    console.log('User logged in:', user);
    // Handle successful authentication
  };

  return <AuthContainer onAuthSuccess={handleAuthSuccess} />;
}
```

## Features

- ✅ User registration with email verification
- ✅ User login with email and password
- ✅ Password validation (minimum 8 characters)
- ✅ Error handling and user feedback
- ✅ Loading states during API calls
- ✅ Responsive design for mobile and desktop
- ✅ JWT token management
- ✅ Session persistence

## Testing

To test the authentication flow:

1. **Registration:**
   - Fill in the registration form
   - Check your email for the verification code
   - Enter the code to verify your account

2. **Login:**
   - Use your registered email and password
   - Upon successful login, you'll receive JWT tokens

## API Integration

The authentication components provide JWT tokens that can be used to authenticate API requests:

```typescript
import { getIdToken, getAccessToken } from './config/cognito';

// Get ID token for API authentication
const idToken = await getIdToken();

// Make authenticated API request
const response = await fetch('https://api.webwaka.site/endpoint', {
  headers: {
    'Authorization': `Bearer ${idToken}`
  }
});
```

## Deployment

These components are designed to work with the existing Vite/React frontend. To deploy:

1. Ensure the Cognito configuration is correct
2. Build the frontend: `npm run build`
3. Deploy to S3 as configured in Session 6

## Next Steps

- Implement password reset functionality
- Add social login (Google, Facebook)
- Implement multi-factor authentication (MFA)
- Add user profile management
- Implement session timeout handling
