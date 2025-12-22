# CI/CD Secrets Setup

Set these in your GitHub repository settings → Secrets and variables → Actions.

## Android (Google Play)
- ANDROID_KEYSTORE_BASE64: Base64 of your `keystore.jks`.
- ANDROID_KEYSTORE_PASSWORD: Keystore password.
- ANDROID_KEY_ALIAS: Key alias.
- ANDROID_KEY_PASSWORD: Key password.
- GOOGLE_PLAY_SERVICE_ACCOUNT_JSON: Contents of your Google service account JSON with Play Developer API access.
- Optional Repo Variable: `ANDROID_PACKAGE_NAME` (or edit `PACKAGE_NAME` in workflow).

## iOS (App Store / TestFlight)
- APP_STORE_CONNECT_KEY_ID: App Store Connect API Key ID.
- APP_STORE_CONNECT_ISSUER_ID: App Store Connect Issuer ID.
- APP_STORE_CONNECT_API_KEY_BASE64: Base64 of your `.p8` API key file.
- MATCH_GIT_URL: Private repo URL containing encrypted certificates/profiles (fastlane match).
- MATCH_GIT_BRANCH: Branch name (e.g. `main`).
- MATCH_PASSWORD: Passphrase used by `match` to decrypt certs/profiles.
- APPLE_TEAM_ID: Developer Portal Team ID (optional, used by Appfile).
- APP_STORE_CONNECT_TEAM_ID: App Store Connect Team ID (optional, used by Appfile).
- APPLE_ID: Apple ID email (optional, used by Appfile).

## How to generate values
- Keystore: `keytool -genkey -v -keystore keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000`
  - Base64: `base64 -i keystore.jks | pbcopy`
- Service account JSON: Create in Google Cloud → IAM → Service Accounts, grant Play Developer API, download JSON and paste into the secret.
- App Store Connect API key: Users and Access → Keys → Create. Download `.p8` then base64: `base64 -i AuthKey_XXXX.p8 | pbcopy`.
- fastlane match: `fastlane match appstore` to bootstrap and push to a private repo, then use its URL and passphrase in secrets.

## Triggers
- Android: push a tag like `android-v1.0.0` or run manually.
- iOS: push a tag like `ios-v1.0.0` or run manually.
