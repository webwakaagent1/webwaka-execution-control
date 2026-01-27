# AWS Bootstrap Fix Instructions for Founder

**Date:** January 27, 2026  
**Issue:** Non-existent AWS policy `AWSAmplifyFullAccess` in line 70 of `aws-bootstrap.yml`  
**Identified by:** Implementation Agent  
**Fix prepared by:** Coordinator/Verifier Agent

---

## The Problem

The AWS bootstrap workflow file contains a reference to a policy called `AWSAmplifyFullAccess` which does not exist in AWS IAM. This causes the workflow to fail when it tries to attach this policy to the deployment user.

**Location:** `.github/workflows/aws-bootstrap.yml`, line 70

**Current line 70:**
```yaml
aws iam attach-user-policy --user-name webwaka-deployment-user --policy-arn arn:aws:iam::aws:policy/AWSAmplifyFullAccess
```

---

## The Solution

**Simply delete line 70** from the file. The other policies are sufficient for the deployment user.

---

## How to Fix (2 Minutes)

### Option 1: Via GitHub Web Interface (Recommended)

1. **Go to the file:**
   - https://github.com/webwakaagent1/webwaka-execution-control/blob/main/.github/workflows/aws-bootstrap.yml

2. **Click the pencil icon** (Edit this file) in the top-right corner

3. **Find line 70:**
   - Scroll down to around line 70
   - Look for the line containing `AWSAmplifyFullAccess`

4. **Delete the entire line 70:**
   - Select the entire line
   - Press Delete or Backspace

5. **Commit the change:**
   - Scroll to the bottom
   - Enter commit message: `fix: remove non-existent AWSAmplifyFullAccess policy`
   - Click "Commit changes"

### Option 2: Ask the Implementation Agent

Forward these instructions to the Implementation Agent and ask them to make the fix once you've completed it.

---

## After the Fix

Once you've deleted line 70 and committed the change:

1. **Notify the Implementation Agent** that the fix is complete
2. **The Implementation Agent can retry** the AWS bootstrap workflow
3. **The workflow should now succeed**

---

## Why This Happened

The `AWSAmplifyFullAccess` policy was likely included in error. AWS Amplify is a separate service, and its policy is not needed for the WebWaka deployment user. The other policies (ECS, S3, CloudFront, etc.) are sufficient.

---

**Prepared by:** Manus AI Agent (Coordinator/Verifier)  
**Date:** 2026-01-27 12:57 UTC
