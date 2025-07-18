# Setting Up Environment Variables with xcconfig Files

## What was created:
1. **ConfigurationManager.swift** - A manager class that reads values from the auto-generated Info.plist
2. **Debug.xcconfig** - Debug configuration file
3. **Release.xcconfig** - Release configuration file
4. **Staging.xcconfig** - Staging configuration file
5. **Production.xcconfig** - Production configuration file

## Manual Xcode Setup Required:

### Step 1: Add xcconfig files to your project
1. Open your project in Xcode
2. Right-click on the project root in the navigator
3. Select "Add Files to 'recruiter-ios'"
4. Navigate to the Config folder and select all .xcconfig files
5. Make sure they are added to the recruiter-ios target

### Step 2: Configure Build Settings to use xcconfig files
1. Select your project in the navigator (top level)
2. Go to the "Info" tab
3. Under "Configurations", for each configuration:
   - Set Debug to use `Debug.xcconfig`
   - Set Release to use `Release.xcconfig`
   - (Optional) Create new configurations for Staging and Production

### Step 3: Add ConfigurationManager.swift to your project
1. Right-click on the project root in the navigator
2. Select "Add Files to 'recruiter-ios'"
3. Navigate to Common/Config/ and select ConfigurationManager.swift
4. Make sure it's added to the recruiter-ios target

### Step 4: Verify the setup
1. Build your project
2. The xcconfig files will automatically add the API_BASE_URL and API_SECRET_KEY to the auto-generated Info.plist
3. ConfigurationManager will read these values at runtime

## How it works:
- The xcconfig files define `INFOPLIST_KEY_API_BASE_URL` and `INFOPLIST_KEY_API_SECRET_KEY`
- These get automatically added to the Info.plist that Xcode generates
- ConfigurationManager reads these values using `Bundle.main.object(forInfoPlist:)`
- If the values aren't found, it falls back to the default staging values

## Files Updated:
- RecruiterService.swift
- FeedService.swift  
- UserService.swift
- ReviewViewModel.swift

All now use `ConfigurationManager.apiBaseURL` and `ConfigurationManager.apiSecretKey` instead of hardcoded values.

## Security Note:
The production xcconfig file contains a placeholder API key. You should:
1. Replace `YOUR_PRODUCTION_API_KEY_HERE` with your actual production API key
2. Never commit production API keys to version control
3. Consider using a separate, private repository for production configurations

## No Info.plist conflicts:
This solution works with Xcode's auto-generated Info.plist system, so you won't get the "Multiple commands produce Info.plist" error.