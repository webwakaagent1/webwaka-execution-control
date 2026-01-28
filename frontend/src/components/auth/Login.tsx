import React, { useState } from 'react';
import { CognitoUser, AuthenticationDetails } from 'amazon-cognito-identity-js';
import { userPool } from '../../config/cognito';

interface LoginProps {
  onLoginSuccess: (user: CognitoUser) => void;
  onSwitchToRegister: () => void;
}

export const Login: React.FC<LoginProps> = ({ onLoginSuccess, onSwitchToRegister }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const authenticationDetails = new AuthenticationDetails({
      Username: email,
      Password: password,
    });

    const cognitoUser = new CognitoUser({
      Username: email,
      Pool: userPool,
    });

    cognitoUser.authenticateUser(authenticationDetails, {
      onSuccess: (result) => {
        console.log('Login successful:', result);
        setLoading(false);
        onLoginSuccess(cognitoUser);
      },
      onFailure: (err) => {
        console.error('Login failed:', err);
        setError(err.message || 'Login failed. Please try again.');
        setLoading(false);
      },
      newPasswordRequired: (userAttributes) => {
        console.log('New password required:', userAttributes);
        setError('New password required. Please contact support.');
        setLoading(false);
      },
    });
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h2>Sign In to WebWaka</h2>
        <form onSubmit={handleSubmit} className="auth-form">
          {error && <div className="error-message">{error}</div>}
          
          <div className="form-group">
            <label htmlFor="email">Email</label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Enter your email"
              required
              disabled={loading}
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Password</label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter your password"
              required
              disabled={loading}
            />
          </div>

          <button type="submit" className="btn-primary" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>

        <div className="auth-footer">
          <p>
            Don't have an account?{' '}
            <button onClick={onSwitchToRegister} className="link-button">
              Sign Up
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};
