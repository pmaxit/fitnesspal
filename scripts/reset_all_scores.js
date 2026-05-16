const admin = require('firebase-admin');
const path = require('path');

// Using temporary access token for reset
admin.initializeApp({
  credential: {
    getAccessToken: () => Promise.resolve({
      expires_in: 3600,
      access_token: process.env.FIREBASE_ACCESS_TOKEN || 'YOUR_ACCESS_TOKEN'
    })
  },
  projectId: 'fitness-pal-demo'
});

const db = admin.firestore();

async function resetScores() {
  console.log('Resetting scores for all users...');

  // Get all users
  const usersSnapshot = await db.collection('users').get();
  
  if (usersSnapshot.empty) {
    console.log('No users found.');
    return;
  }

  for (const userDoc of usersSnapshot.docs) {
    const userId = userDoc.id;
    console.log(`Processing user: ${userId}`);

    // Get all dailyMetrics for the user
    const metricsSnapshot = await db.collection(`users/${userId}/dailyMetrics`).get();
    
    if (metricsSnapshot.empty) {
      console.log(`  No daily metrics found for user ${userId}.`);
      continue;
    }

    const batch = db.batch();
    let updatedCount = 0;

    for (const metricDoc of metricsSnapshot.docs) {
      batch.update(metricDoc.ref, {
        wellnessScore: 0,
        sleepScore: 0,
        trainScore: 0,
        foodScore: 0,
        hydrationScore: 0,
        recoveryPct: 0,
        energyScore: 0,
      });
      updatedCount++;
    }

    if (updatedCount > 0) {
      await batch.commit();
      console.log(`  Reset ${updatedCount} daily metrics for user ${userId}.`);
    }
  }

  console.log('All scores reset successfully!');
}

resetScores()
  .then(() => process.exit(0))
  .catch(error => {
    console.error('Error resetting scores:', error);
    process.exit(1);
  });
