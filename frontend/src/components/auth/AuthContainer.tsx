import React, { useState } from 'react';
import { CognitoUser } from 'amazon-cognito-identity-js';
import { Login } from './Login';
import { Register } from './Register';
import './auth.css';

interface AuthContainerProps {
  onAuthSuccess: (user: CognitoUser) => void;
}

export const AuthContainer: React.FC<AuthContainerProps> = ({ onAuthSuccess }) => {
  const [view, setView] = useState<'login' | 'register'>('login');

  const handleLoginSuccess = (user: CognitoUser) => {
    onAuthSuccess(user);
  };

  const handleRegisterSuccess = () => {
    // After successful registration and verification, switch to login
    setView('login');
  };

  return (
    <div className="auth-wrapper">
      {view === 'login' ? (
        <Login
          onLoginSuccess={handleLoginSuccess}
          onSwitchToRegister={() => setView('register')}
        />
      ) : (
        <Register
          onRegisterSuccess={handleRegisterSuccess}
          onSwitchToLogin={() => setView('login')}
        />
      )}
    </div>
  );
};
