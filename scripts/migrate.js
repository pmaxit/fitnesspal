const admin = require('firebase-admin');
const path = require('path');

const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin with the generated service account key
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Assuming you know the userId, or we create a default one for the demo
// In the Flutter app, FirestoreService used 'demo-user-1' or authenticated user.
// Let's use 'demo-user-1' as the default demo user if we don't have auth.
const USER_ID = 'demo-user-1'; // Replace with actual user ID if different

async function clearCollection(collectionPath) {
  const collectionRef = db.collection(collectionPath);
  const snapshot = await collectionRef.get();
  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });
  await batch.commit();
}

async function migrate() {
  console.log('Starting migration script...');
  
  const collections = ['meals', 'activities', 'dailyMetrics', 'habits', 'profile'];
  
  console.log('Clearing old data...');
  for (const coll of collections) {
    await clearCollection(`users/${USER_ID}/${coll}`);
  }

  console.log('Old data cleared. Seeding new profile for Puneet...');

  const profile = {
    id: USER_ID,
    name: 'Puneet',
    initials: 'P',
    bio: 'Ready to start',
    goals: [],
    weightLb: 150,
    bodyFatPct: 15,
    muscleLb: 120,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection(`users/${USER_ID}/profile`).doc('data').set(profile);
  
  // Create an empty daily metric for today so the app doesn't crash if it expects one
  const today = new Date();
  const dateId = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
  
  const defaultMetric = {
    id: dateId,
    date: admin.firestore.Timestamp.fromDate(today),
    calories: 0,
    sleepHours: 0,
    steps: 0,
    waterCups: 0,
    wellnessScore: 0,
    aiInsight: 'Welcome to FitnessPal, Puneet. Log your first activity to see insights.',
    sleepScore: 0,
    trainScore: 0,
    foodScore: 0,
    hydrationScore: 0,
    recoveryPct: 0,
    energyScore: 0,
    calorieTarget: 2100,
    waterTarget: 8,
  };

  await db.collection(`users/${USER_ID}/dailyMetrics`).doc(dateId).set(defaultMetric);

  console.log('Migration complete!');
}

migrate().catch(console.error);
