import { openDB } from 'idb';
import type { DBSchema, IDBPDatabase } from 'idb';

interface WebWakaDB extends DBSchema {
  'api-cache': {
    key: string;
    value: {
      data: any;
      timestamp: number;
    };
  };
}

const DB_NAME = 'webwaka-db';
const DB_VERSION = 1;
const STORE_NAME = 'api-cache';

let dbPromise: Promise<IDBPDatabase<WebWakaDB>> | null = null;

export async function getDB(): Promise<IDBPDatabase<WebWakaDB>> {
  if (!dbPromise) {
    dbPromise = openDB<WebWakaDB>(DB_NAME, DB_VERSION, {
      upgrade(db) {
        if (!db.objectStoreNames.contains(STORE_NAME)) {
          db.createObjectStore(STORE_NAME);
        }
      },
    });
  }
  return dbPromise;
}

export async function getCachedData(key: string): Promise<any | null> {
  try {
    const db = await getDB();
    const cached = await db.get(STORE_NAME, key);
    
    if (!cached) {
      return null;
    }

    // Check if cache is older than 5 minutes
    const now = Date.now();
    const age = now - cached.timestamp;
    const MAX_AGE = 5 * 60 * 1000; // 5 minutes

    if (age > MAX_AGE) {
      // Cache expired
      await db.delete(STORE_NAME, key);
      return null;
    }

    return cached.data;
  } catch (error) {
    console.error('Error getting cached data:', error);
    return null;
  }
}

export async function setCachedData(key: string, data: any): Promise<void> {
  try {
    const db = await getDB();
    await db.put(STORE_NAME, {
      data,
      timestamp: Date.now(),
    }, key);
  } catch (error) {
    console.error('Error setting cached data:', error);
  }
}

export async function clearCache(): Promise<void> {
  try {
    const db = await getDB();
    await db.clear(STORE_NAME);
  } catch (error) {
    console.error('Error clearing cache:', error);
  }
}
