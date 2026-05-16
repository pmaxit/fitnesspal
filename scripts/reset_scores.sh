#!/bin/bash
TOKEN=$(gcloud auth print-access-token)
PROJECT="fitnesspal-149a7"

echo "Fetching users..."
USERS=$(curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"structuredQuery": {"from": [{"collectionId": "profile", "allDescendants": true}]}}' \
  "https://firestore.googleapis.com/v1/projects/$PROJECT/databases/(default)/documents:runQuery" \
  | grep '"name":' | sed 's/.*\/users\/\([^/]*\)\/profile\/data.*/\1/' | grep -v '{' | sort | uniq)

if [ -z "$USERS" ]; then
  echo "No users found."
  exit 0
fi

for USER in $USERS; do
  echo "Processing user $USER"

  echo "  Resetting profile for $USER"
  curl -s -X PATCH -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "fields": {
        "weightLb": {"doubleValue": 0},
        "goalWeightLb": {"doubleValue": 0},
        "bodyFatPct": {"doubleValue": 0},
        "muscleLb": {"doubleValue": 0}
      }
    }' \
    "https://firestore.googleapis.com/v1/projects/$PROJECT/databases/(default)/documents/users/$USER/profile/data?updateMask.fieldPaths=weightLb&updateMask.fieldPaths=goalWeightLb&updateMask.fieldPaths=bodyFatPct&updateMask.fieldPaths=muscleLb" > /dev/null

  METRICS=$(curl -s -H "Authorization: Bearer $TOKEN" \
    "https://firestore.googleapis.com/v1/projects/$PROJECT/databases/(default)/documents/users/$USER/dailyMetrics" \
    | grep '"name":' | sed 's/.*\/dailyMetrics\/\([^"]*\)".*/\1/' | sort | uniq)

  if [ -z "$METRICS" ]; then
    echo "  No daily metrics found."
    continue
  fi

  for METRIC in $METRICS; do
    echo "  Resetting metric $METRIC"
    curl -s -X PATCH -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "fields": {
          "wellnessScore": {"doubleValue": 0},
          "sleepScore": {"integerValue": 0},
          "trainScore": {"integerValue": 0},
          "foodScore": {"integerValue": 0},
          "hydrationScore": {"integerValue": 0},
          "recoveryPct": {"integerValue": 0},
          "energyScore": {"doubleValue": 0}
        }
      }' \
      "https://firestore.googleapis.com/v1/projects/$PROJECT/databases/(default)/documents/users/$USER/dailyMetrics/$METRIC?updateMask.fieldPaths=wellnessScore&updateMask.fieldPaths=sleepScore&updateMask.fieldPaths=trainScore&updateMask.fieldPaths=foodScore&updateMask.fieldPaths=hydrationScore&updateMask.fieldPaths=recoveryPct&updateMask.fieldPaths=energyScore" > /dev/null
  done
done

echo "Done!"
