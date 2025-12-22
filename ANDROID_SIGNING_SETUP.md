# Android Release Signing Setup

Your keystore has been generated successfully!

## Local Configuration ✅
- **Keystore file**: `android/keystore.jks` 
- **Properties file**: `android/key.properties`
- **Credentials**:
  - Store Password: `123456`
  - Key Alias: `riverpod`
  - Key Password: `123456`

## GitHub Actions Setup

To enable automatic releases via GitHub Actions, add these secrets to your repository:

### Required Secrets

Go to: **Settings → Secrets and variables → Actions → New repository secret**

1. **ANDROID_KEYSTORE_BASE64**
   ```bash
   # Run this command to get the value:
   base64 -i android/keystore.jks | pbcopy
   # Then paste into GitHub secret
   ```

2. **ANDROID_KEYSTORE_PASSWORD**
   ```
   123456
   ```

3. **ANDROID_KEY_ALIAS**
   ```
   riverpod
   ```

4. **ANDROID_KEY_PASSWORD**
   ```
   123456
   ```

5. **GOOGLE_PLAY_SERVICE_ACCOUNT_JSON**
   - Create a service account in Google Cloud Console
   - Enable Google Play Developer API
   - Download JSON key and paste content here

### Quick Setup Commands

```bash
# 1. Copy keystore base64 to clipboard (for ANDROID_KEYSTORE_BASE64 secret)
base64 -i android/keystore.jks | pbcopy

# 2. View your key.properties to confirm values
cat android/key.properties
```

### Testing Locally

```bash
# Build release APK locally
flutter build apk --release

# Build release App Bundle
flutter build appbundle --release
```

## Security Notes

⚠️ **IMPORTANT**: 
- The `keystore.jks` and `key.properties` files are already in `.gitignore`
- Never commit these files to version control
- Keep your keystore password secure
- For production, use stronger passwords

## Triggering Releases

Once secrets are configured:

```bash
# Trigger via tag
git tag android-v1.0.0
git push origin android-v1.0.0

# Or run manually from GitHub Actions tab
```
