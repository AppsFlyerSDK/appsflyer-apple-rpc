# AppsFlyerRPC Release Workflows

This guide explains the automated release process for AppsFlyerRPC using GitHub Actions.

## 📋 Table of Contents

- [Overview](#overview)
- [Workflows](#workflows)
- [Release Process](#release-process)
- [Step-by-Step Guide](#step-by-step-guide)
- [Use Cases](#use-cases)
- [Troubleshooting](#troubleshooting)

---

## Overview

AppsFlyerRPC uses **two automated workflows** to streamline the release process:

1. **`prepare-release.yml`** - Automates version updates and creates a release PR
2. **`publish-release.yml`** - Publishes the release to GitHub and CocoaPods

```
┌─────────────────────────────────────────────────────────────┐
│  Developer                                                   │
│  ↓ Creates & pushes releases/* branch                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  Workflow 1: prepare-release.yml                            │
│  • Updates version files (Carthage, Podspec, SPM, README)   │
│  • Creates git tag                                           │
│  • Commits changes                                           │
│  • Opens PR to main                                          │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  Developer Reviews & Merges PR                              │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  Workflow 2: publish-release.yml                            │
│  • Creates ZIP artifacts                                     │
│  • Creates GitHub Release                                    │
│  • Uploads XCFrameworks                                      │
│  • Publishes to CocoaPods (optional)                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Workflows

### 1. Prepare Release (`prepare-release.yml`)

**Trigger**: Push to any `releases/**` branch

**What it does**:
- ✅ Extracts version number from branch name
- ✅ Validates XCFrameworks are present
- ✅ Updates all version files:
  - `Carthage/AppsFlyerRPC-static.json`
  - `Carthage/AppsFlyerRPC-dynamic.json`
  - `AppsFlyerRPC.podspec`
  - `Package.swift` (with new checksum)
  - `README.md`
- ✅ Creates git tag
- ✅ Commits changes
- ✅ Opens PR to `main`

**Branch Naming Convention**:
```
releases/[major].x.x/[major].[minor].x/[major].[minor].[patch][_suffix]
```

**Examples**:
- `releases/1.x.x/1.0.x/1.0.0` → Version: **1.0.0**
- `releases/1.x.x/1.0.x/1.0.0_rc1` → Version: **1.0.0**
- `releases/1.x.x/1.1.x/1.1.5` → Version: **1.1.5**

### 2. Publish Release (`publish-release.yml`)

**Trigger**: PR from `releases/**` merged to `main`

**What it does**:
- ✅ Verifies tag exists
- ✅ Creates ZIP artifacts:
  - `AppsFlyerRPC-static.xcframework.zip`
  - `AppsFlyerRPC-dynamic.xcframework.zip`
- ✅ Creates GitHub Release with installation instructions
- ✅ Uploads both XCFramework ZIPs
- ✅ Publishes to CocoaPods (if `COCOAPODS_TRUNK_TOKEN` is set)

---

## Release Process

### Prerequisites

Before starting a release, ensure:

1. **XCFrameworks are built**:
   ```bash
   cd /path/to/appsflyer.sdk.ios/AppsFlyerRPC
   make build_for_release
   ```

2. **XCFrameworks are copied** to the repository:
   ```bash
   # Static (root)
   cp -R /path/to/built/Static/AppsFlyerRPC.xcframework ./
   
   # Dynamic (Dynamic folder)
   cp -R /path/to/built/Dynamic/AppsFlyerRPC.xcframework ./Dynamic/
   ```

3. **Both branches exist**: `main` and `development`

---

## Step-by-Step Guide

### Example: Releasing Version 1.0.0

#### Step 1: Create Release Branch

```bash
cd /Users/Amit.Levy/XCodeProjects/appsflyer-apple-rpc

# Checkout from main
git checkout main
git pull origin main

# Create release branch following the naming convention
git checkout -b releases/1.x.x/1.0.x/1.0.0
```

#### Step 2: Ensure XCFrameworks are Present

```bash
# Verify both XCFrameworks exist
ls -la AppsFlyerRPC.xcframework/
ls -la Dynamic/AppsFlyerRPC.xcframework/
```

Both should show complete framework structures with:
- `Info.plist`
- `ios-arm64/` (device)
- `ios-arm64_x86_64-simulator/` (simulator)

#### Step 3: Push Release Branch

```bash
git push origin releases/1.x.x/1.0.x/1.0.0
```

**🤖 Automated Step**: `prepare-release.yml` workflow starts automatically

The workflow will:
1. Extract version `1.0.0` from branch name
2. Update all version files
3. Create tag `1.0.0`
4. Commit changes
5. Open PR to `main`

**Check workflow progress**:
- Go to: https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/actions
- Look for "Prepare Release" workflow

#### Step 4: Review & Merge PR

1. Review the PR created by the workflow
2. Check that version numbers are correct in:
   - `Carthage/AppsFlyerRPC-static.json`
   - `Carthage/AppsFlyerRPC-dynamic.json`
   - `AppsFlyerRPC.podspec`
   - `Package.swift`
   - `README.md`
3. Merge the PR to `main`

**🤖 Automated Step**: `publish-release.yml` workflow starts automatically

The workflow will:
1. Create ZIP files for both XCFrameworks
2. Create GitHub Release `1.0.0`
3. Upload both ZIP files
4. Publish to CocoaPods (if token available)

#### Step 5: Verify Release

Check that the release is live:
- **GitHub**: https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/releases/tag/1.0.0
- **CocoaPods**: https://cocoapods.org/pods/AppsFlyerRPC (may take a few minutes)

---

## Use Cases

### Use Case 1: Regular Release (1.0.0)

**Scenario**: Release version 1.0.0 to production

```bash
# 1. Create branch
git checkout -b releases/1.x.x/1.0.x/1.0.0

# 2. Ensure XCFrameworks are present
ls AppsFlyerRPC.xcframework/ Dynamic/AppsFlyerRPC.xcframework/

# 3. Push
git push origin releases/1.x.x/1.0.x/1.0.0

# 4. Wait for workflow, review PR, merge
# 5. Release is published automatically!
```

### Use Case 2: Release Candidate (1.1.0_rc1)

**Scenario**: Release a release candidate for testing

```bash
# 1. Create branch with _rc1 suffix
git checkout -b releases/1.x.x/1.1.x/1.1.0_rc1

# 2. Push
git push origin releases/1.x.x/1.1.x/1.1.0_rc1

# Workflow extracts version 1.1.0 (ignores _rc1)
# Tag will be 1.1.0
```

### Use Case 3: Patch Release (1.0.1)

**Scenario**: Quick patch release

```bash
# 1. Create patch branch
git checkout -b releases/1.x.x/1.0.x/1.0.1

# 2. Ensure updated XCFrameworks are present
# 3. Push
git push origin releases/1.x.x/1.0.x/1.0.1

# 4. Merge PR when ready
```

### Use Case 4: Update XCFramework After Branch Creation

**Scenario**: You pushed the branch but need to update the XCFramework

```bash
# 1. Update XCFrameworks locally
cp -R /new/path/AppsFlyerRPC.xcframework ./
cp -R /new/path/Dynamic/AppsFlyerRPC.xcframework ./Dynamic/

# 2. Commit and push to the same branch
git add AppsFlyerRPC.xcframework Dynamic/AppsFlyerRPC.xcframework
git commit -m "Update XCFrameworks"
git push origin releases/1.x.x/1.0.x/1.0.0

# Workflow will run again with updated frameworks
```

---

## Troubleshooting

### Issue: Workflow doesn't start

**Symptoms**: Pushed release branch but workflow didn't trigger

**Solutions**:
1. Check branch name matches pattern `releases/**`
   ```bash
   git branch --show-current
   # Should output: releases/1.x.x/1.0.x/1.0.0
   ```

2. Check Actions are enabled:
   - Go to: Settings > Actions > General
   - Ensure "Allow all actions" is selected

### Issue: XCFramework validation fails

**Symptoms**: Workflow fails with "Missing XCFrameworks"

**Solution**:
```bash
# Verify both XCFrameworks exist
ls -la AppsFlyerRPC.xcframework/
ls -la Dynamic/AppsFlyerRPC.xcframework/

# If missing, copy them and push again
cp -R /path/to/Static/AppsFlyerRPC.xcframework ./
cp -R /path/to/Dynamic/AppsFlyerRPC.xcframework ./Dynamic/
git add .
git commit -m "Add XCFrameworks"
git push
```

### Issue: Invalid version format

**Symptoms**: Workflow fails with "Invalid version format"

**Error**:
```
ERROR: Invalid version format: 1.0
Expected format: X.Y.Z (e.g., 1.0.0)
```

**Solution**:
Branch name must result in `X.Y.Z` format (three numbers).

❌ Bad:
- `releases/1.0` (missing patch version)
- `releases/v1.0.0` (has 'v' prefix)

✅ Good:
- `releases/1.x.x/1.0.x/1.0.0`
- `releases/1.x.x/1.0.x/1.0.0_rc1`

### Issue: Tag already exists

**Symptoms**: Workflow fails with "tag already exists"

**Solution**:
```bash
# Delete the tag locally and remotely
git tag -d 1.0.0
git push origin :refs/tags/1.0.0

# Re-run the workflow
# Or manually trigger from Actions tab
```

### Issue: CocoaPods publish fails

**Symptoms**: Release succeeds but CocoaPods step fails

**Solutions**:

1. **Missing token**: Set `COCOAPODS_TRUNK_TOKEN` secret
   - Go to: Settings > Secrets and variables > Actions
   - Add secret: `COCOAPODS_TRUNK_TOKEN`

2. **Manual publish**:
   ```bash
   # If automated publish fails, publish manually
   pod trunk push AppsFlyerRPC.podspec --allow-warnings
   ```

### Issue: Checksum mismatch in Package.swift

**Symptoms**: SPM users report checksum errors

**Solution**:
The workflow automatically calculates the checksum. If there's an issue:

```bash
# Manually update checksum
cd /path/to/repo
./scripts/update_spm.sh 1.0.0
git add Package.swift
git commit -m "Update SPM checksum"
git push
```

### Issue: PR not created

**Symptoms**: Workflow succeeds but no PR appears

**Solutions**:

1. Check if PR already exists:
   - Go to: Pull Requests tab
   - Look for open PR from your release branch

2. Check GitHub CLI authentication:
   - Ensure `GITHUB_TOKEN` has correct permissions
   - Required: `contents: write`, `pull-requests: write`

3. Manually create PR:
   ```bash
   gh pr create --base main \
     --head releases/1.x.x/1.0.x/1.0.0 \
     --title "chore: release 1.0.0" \
     --body "Release version 1.0.0"
   ```

---

## Manual Release (If Workflows Fail)

If workflows are not working, you can release manually:

### 1. Update Version Files

```bash
./scripts/update_carthage.sh 1.0.0
./scripts/update_podspec.sh 1.0.0
./scripts/update_spm.sh 1.0.0
./scripts/update_readme.sh 1.0.0
```

### 2. Create Tag

```bash
git tag 1.0.0 -m "Release 1.0.0"
git push origin 1.0.0
```

### 3. Create Release Artifacts

```bash
./scripts/zip_artifacts.sh
```

### 4. Create GitHub Release

```bash
gh release create 1.0.0 \
  --title "1.0.0" \
  --notes "Release 1.0.0" \
  AppsFlyerRPC-static.xcframework.zip \
  AppsFlyerRPC-dynamic.xcframework.zip
```

### 5. Publish to CocoaPods

```bash
pod trunk push AppsFlyerRPC.podspec --allow-warnings
```

---

## Additional Workflows

### Issue Management Workflows

The repository also includes automated issue management:

1. **`close_inactive_issues.yml`**
   - Runs daily at 10:00 UTC
   - Auto-closes stale issues

2. **`responseToSupportIssue.yml`**
   - Triggers when issue is labeled as 'support'
   - Auto-responds with support contact info

3. **`responseToSupportIssueOnOpen.yml`**
   - Triggers when new issue is opened
   - Welcomes user and provides support guidance

---

## Tips & Best Practices

### ✅ Do's

- Always test XCFrameworks locally before releasing
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Review PR carefully before merging
- Keep `main` and `development` branches in sync
- Document changes in release notes

### ❌ Don'ts

- Don't skip XCFramework validation
- Don't manually edit version files (use scripts)
- Don't force-push to release branches
- Don't delete release branches immediately (keep for reference)
- Don't skip workflow reviews

---

## Questions?

For questions or issues:

- **Internal**: Contact the Mobile SDK team
- **External**: support@appsflyer.com
- **Issues**: https://github.com/AppsFlyerSDK/appsflyer-apple-rpc/issues

---

**Last Updated**: December 2025  
**Workflows Version**: 1.0

