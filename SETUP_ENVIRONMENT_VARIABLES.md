# Setting Up Environment Variables with xcconfig Files

## 🚨 IMPORTANT: Follow these steps to complete the setup

The ConfigurationManager is currently using temporary fallbacks. Follow these steps to properly configure the xcconfig files:

## Step 1: Add xcconfig files to Xcode project
1. Open your project in Xcode
2. In the Project Navigator, right-click on the project root "recruiter-ios"
3. Select "Add Files to 'recruiter-ios'"
4. Navigate to `recruiter-ios/Config/` folder
5. Select all 4 xcconfig files (Debug.xcconfig, Release.xcconfig, Staging.xcconfig, Production.xcconfig)
6. Click "Add"
7. Make sure "recruiter-ios" target is selected

## Step 2: Configure Build Settings to use xcconfig files
1. Select your project in the navigator (top level "recruiter-ios")
2. Go to the "Info" tab (not "Build Settings")
3. Under "Configurations", you'll see Debug and Release
4. For **Debug**: Click the dropdown and select "Debug" (this will be `Debug.xcconfig`)
5. For **Release**: Click the dropdown and select "Release" (this will be `Release.xcconfig`)

## Step 3: Add ConfigurationManager to Xcode
1. In the Project Navigator, right-click on the project root "recruiter-ios"
2. Select "Add Files to 'recruiter-ios'"
3. Navigate to `recruiter-ios/Common/Config/ConfigurationManager.swift`
4. Select the file and click "Add"
5. Make sure "recruiter-ios" target is selected

## Step 4: Clean and rebuild
1. In Xcode, go to Product → Clean Build Folder
2. Then Product → Build

## Step 5: Verify it's working
Once configured, you should see the environment variables working and the warning messages should disappear.

## How to verify xcconfig is working:
1. Build your project
2. Check the console - you should NOT see the warning messages:
   - "⚠️ WARNING: Using hardcoded API URL. Please configure xcconfig files!"
   - "⚠️ WARNING: Using hardcoded API key. Please configure xcconfig files!"
3. If you still see warnings, the xcconfig files aren't properly configured

## What the xcconfig files contain:
- **Debug.xcconfig**: Staging API URL and key
- **Release.xcconfig**: Staging API URL and key  
- **Staging.xcconfig**: Staging API URL and key
- **Production.xcconfig**: Production API URL and placeholder key

## Files that use ConfigurationManager:
- RecruiterService.swift
- FeedService.swift  
- UserService.swift
- ReviewViewModel.swift

## Security Note:
Once you set up Production.xcconfig, replace `YOUR_PRODUCTION_API_KEY_HERE` with your actual production API key.

## Need help?
If you're still seeing the fatal error or warnings after following these steps, the xcconfig files aren't properly linked to your build configurations in Xcode.