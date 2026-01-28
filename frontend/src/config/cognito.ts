import { CognitoUserPool } from 'amazon-cognito-identity-js';

// These values should be replaced with actual Cognito User Pool details from Session 4
// For now, using placeholder values that need to be configured
const poolData = {
  UserPoolId: process.env.VITE_COGNITO_USER_POOL_ID || 'us-east-1_XXXXXXXXX',
  ClientId: process.env.VITE_COGNITO_CLIENT_ID || 'XXXXXXXXXXXXXXXXXXXXXXXXXX',
};

export const userPool = new CognitoUserPool(poolData);

export const getCurrentUser = () => {
  return userPool.getCurrentUser();
};

export const signOut = () => {
  const currentUser = getCurrentUser();
  if (currentUser) {
    currentUser.signOut();
  }
};

export const getSession = (): Promise<any> => {
  return new Promise((resolve, reject) => {
    const currentUser = getCurrentUser();
    
    if (!currentUser) {
      reject(new Error('No user logged in'));
      return;
    }

    currentUser.getSession((err: Error | null, session: any) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(session);
    });
  });
};

export const getIdToken = async (): Promise<string> => {
  const session = await getSession();
  return session.getIdToken().getJwtToken();
};

export const getAccessToken = async (): Promise<string> => {
  const session = await getSession();
  return session.getAccessToken().getJwtToken();
};
