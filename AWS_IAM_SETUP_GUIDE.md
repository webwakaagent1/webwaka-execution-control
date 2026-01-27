# AWS IAM Setup Guide

**Status:** 📋 SETUP INSTRUCTIONS  
**Authority:** Founder  
**Created:** 2026-01-27  
**Purpose:** Step-by-step guide to create IAM users for WebWaka platform

---

## 1. Purpose

This guide provides step-by-step instructions for setting up IAM users and roles required for the WebWaka platform. This must be completed before Phase 1 implementation can begin.

**Security Note:** IAM setup should be performed by the Founder or an authorized administrator with full AWS access.

---

## 2. Prerequisites

Before starting, ensure you have:
- ✅ AWS account access (webwaka.agent.1@gmail.com)
- ✅ Root account credentials
- ✅ Access to AWS Console
- ✅ MFA device ready (recommended)

---

## 3. Step 1: Enable MFA on Root Account (CRITICAL)

**Why:** Root account has unlimited access. MFA prevents unauthorized access even if password is compromised.

### Instructions:

1. Log in to AWS Console as root user:
   - Email: webwaka.agent.1@gmail.com
   - Password: [Your root password]

2. Click on your account name (top right) → "Security credentials"

3. In the "Multi-factor authentication (MFA)" section, click "Assign MFA device"

4. Choose MFA device type:
   - **Recommended:** Virtual MFA device (Google Authenticator, Authy)
   - Alternative: Hardware MFA device

5. Follow the on-screen instructions to:
   - Scan QR code with authenticator app
   - Enter two consecutive MFA codes
   - Click "Assign MFA"

6. **IMPORTANT:** Save backup codes in a secure location

**Verification:** Try logging out and back in. You should be prompted for MFA code.

---

## 4. Step 2: Create IAM Admin User (Founder)

**Why:** Never use root account for day-to-day operations. Create an admin user instead.

### Instructions:

1. In AWS Console, navigate to **IAM** service (search "IAM" in top search bar)

2. Click **Users** in left sidebar → **Add users**

3. Configure user:
   - **User name:** `webwaka-founder-admin`
   - **Access type:** ✅ AWS Management Console access
   - **Console password:** Custom password (use strong password generator)
   - **Require password reset:** ❌ Uncheck (you'll set a strong password)

4. Click **Next: Permissions**

5. Set permissions:
   - Select **Attach existing policies directly**
   - Search for and select: **AdministratorAccess**
   - Click **Next: Tags**

6. Add tags (optional but recommended):
   - Key: `Role`, Value: `Founder`
   - Key: `Environment`, Value: `All`
   - Key: `Project`, Value: `WebWaka`

7. Click **Next: Review** → **Create user**

8. **IMPORTANT:** Save the console login link and credentials:
   ```
   Console URL: https://[ACCOUNT-ID].signin.aws.amazon.com/console
   Username: webwaka-founder-admin
   Password: [Your chosen password]
   ```

9. Log out of root account and log in as `webwaka-founder-admin`

10. Enable MFA for this user:
    - Click account name → Security credentials
    - Assign MFA device (same process as root account)

**Verification:** Log in as `webwaka-founder-admin` and verify you can access all services.

---

## 5. Step 3: Create IAM Deployment User (CI/CD)

**Why:** GitHub Actions needs programmatic access to deploy code. This user has limited permissions for security.

### Instructions:

1. In IAM console, click **Users** → **Add users**

2. Configure user:
   - **User name:** `webwaka-deployment-user`
   - **Access type:** ✅ Programmatic access ONLY
   - **AWS Management Console access:** ❌ Uncheck

3. Click **Next: Permissions**

4. Set permissions:
   - Select **Attach existing policies directly**
   - Search for and attach the following policies:
     - ✅ `AmazonECS_FullAccess`
     - ✅ `AWSAmplifyFullAccess`
     - ✅ `AmazonS3FullAccess`
     - ✅ `CloudFrontFullAccess`
     - ✅ `SecretsManagerReadWrite`
     - ✅ `CloudWatchLogsFullAccess`
     - ✅ `AmazonEventBridgeFullAccess`
     - ✅ `AmazonSQSFullAccess`

5. Add tags:
   - Key: `Role`, Value: `Deployment`
   - Key: `Environment`, Value: `Development`
   - Key: `Project`, Value: `WebWaka`

6. Click **Next: Review** → **Create user**

7. **CRITICAL:** Save the access credentials:
   ```
   Access Key ID: AKIA...
   Secret Access Key: [Long secret key]
   ```

8. **IMPORTANT:** 
   - Copy these credentials immediately (you won't see the secret key again)
   - Store them in a secure password manager
   - These will be added to GitHub Secrets in Phase 1

**Verification:** Access keys are displayed and saved securely.

---

## 6. Step 4: Create Custom IAM Policy (Additional Permissions)

**Why:** Deployment user needs additional permissions not covered by managed policies.

### Instructions:

1. In IAM console, click **Policies** → **Create policy**

2. Click **JSON** tab and paste the following policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "WebWakaDeploymentPolicy",
      "Effect": "Allow",
      "Action": [
        "cognito-idp:*",
        "rds:*",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:CreateSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "elasticloadbalancing:*",
        "route53:*",
        "acm:*",
        "bedrock:InvokeModel",
        "bedrock:ListFoundationModels",
        "ses:*",
        "sns:*"
      ],
      "Resource": "*"
    }
  ]
}
```

3. Click **Next: Tags**

4. Add tags:
   - Key: `Project`, Value: `WebWaka`
   - Key: `Purpose`, Value: `Deployment`

5. Click **Next: Review**

6. Name the policy:
   - **Name:** `WebWakaDeploymentPolicy`
   - **Description:** Additional permissions for WebWaka deployment user

7. Click **Create policy**

8. Attach policy to deployment user:
   - Go to **Users** → **webwaka-deployment-user**
   - Click **Add permissions** → **Attach existing policies directly**
   - Search for `WebWakaDeploymentPolicy`
   - Select it and click **Add permissions**

**Verification:** Policy is created and attached to `webwaka-deployment-user`.

---

## 7. Step 5: Configure AWS Budget Alerts

**Why:** Prevent unexpected AWS bills by setting up alerts at key thresholds.

### Instructions:

1. Navigate to **AWS Budgets** service (search "Budgets" in top search bar)

2. Click **Create budget**

3. Choose budget type:
   - Select **Cost budget**
   - Click **Next**

4. Set budget details:
   - **Name:** `WebWaka-Development-Budget`
   - **Period:** Monthly
   - **Budget effective dates:** Recurring budget
   - **Start month:** Current month
   - **Budgeted amount:** `$200`

5. Click **Next**

6. Configure alerts:
   - **Alert #1 - 50% threshold:**
     - Threshold: 50% of budgeted amount
     - Email recipients: webwaka.agent.1@gmail.com
   
   - Click **Add alert threshold**
   
   - **Alert #2 - 75% threshold:**
     - Threshold: 75% of budgeted amount
     - Email recipients: webwaka.agent.1@gmail.com
   
   - Click **Add alert threshold**
   
   - **Alert #3 - 90% threshold:**
     - Threshold: 90% of budgeted amount
     - Email recipients: webwaka.agent.1@gmail.com
   
   - Click **Add alert threshold**
   
   - **Alert #4 - 100% threshold:**
     - Threshold: 100% of budgeted amount
     - Email recipients: webwaka.agent.1@gmail.com

7. Click **Next** → **Create budget**

**Verification:** Budget is created and you receive a confirmation email.

---

## 8. Step 6: Enable CloudTrail (Audit Logging)

**Why:** Track all API calls for security auditing and compliance.

### Instructions:

1. Navigate to **CloudTrail** service

2. Click **Create trail**

3. Configure trail:
   - **Trail name:** `webwaka-audit-trail`
   - **Storage location:** Create new S3 bucket
   - **S3 bucket name:** `webwaka-audit-trail-logs-[ACCOUNT-ID]`
   - **Log file SSE-KMS encryption:** ✅ Enabled (recommended)

4. Choose log events:
   - **Management events:** ✅ Enabled
   - **Data events:** ❌ Disabled (can enable later if needed)
   - **Insights events:** ❌ Disabled (can enable later if needed)

5. Click **Next** → **Create trail**

**Verification:** CloudTrail is enabled and logging to S3 bucket.

---

## 9. Step 7: Delete Root Access Keys (Security Best Practice)

**Why:** Root access keys should never exist. If compromised, attacker has unlimited access.

### Instructions:

1. Log in as root user

2. Click account name → **Security credentials**

3. Scroll to **Access keys** section

4. If any access keys exist:
   - Click **Delete** for each key
   - Confirm deletion

5. **Verification:** "No access keys" message is displayed

**Important:** Never create root access keys. Use IAM users instead.

---

## 10. Step 8: Configure AWS Region

**Why:** Ensure all services are created in the correct region (us-east-1 for lowest latency to Nigeria).

### Instructions:

1. In AWS Console, check the region selector (top right, next to account name)

2. Click the region dropdown

3. Select **Africa (Cape Town) us-east-1**

4. **Verify:** All subsequent service creation will be in this region

**Note:** Some services are global (IAM, CloudFront, Route 53) and don't have a region selector.

---

## 11. Step 9: Verify Service Availability in us-east-1

**Why:** Not all AWS services are available in all regions. Verify required services are available.

### Instructions:

1. Check service availability:
   - ✅ **Amazon Cognito:** Available in us-east-1
   - ✅ **Amazon Aurora:** Available in us-east-1
   - ✅ **AWS Fargate:** Available in us-east-1
   - ✅ **AWS Amplify:** Global service (uses closest region)
   - ✅ **Amazon SES:** Available in us-east-1
   - ✅ **Amazon SNS:** Available in us-east-1
   - ✅ **Amazon S3:** Available in us-east-1
   - ✅ **Amazon CloudFront:** Global service
   - ✅ **Amazon EventBridge:** Available in us-east-1
   - ✅ **Amazon SQS:** Available in us-east-1
   - ⚠️ **Amazon Bedrock:** NOT available in us-east-1
     - **Solution:** Use us-east-1 for Bedrock API calls (cross-region access is supported)
     - **Impact:** Slightly higher latency for AI features (~200ms additional)

2. **Decision:** Proceed with us-east-1 for all services except Bedrock

**Verification:** All required services are available or have acceptable workarounds.

---

## 12. Step 10: Document IAM Credentials

**Why:** Credentials must be securely stored and accessible for Phase 1 implementation.

### Instructions:

1. Create a secure document with the following information:

```
=== WebWaka AWS Credentials ===

Root Account:
- Email: webwaka.agent.1@gmail.com
- Password: [Stored securely by Founder]
- MFA: Enabled ✅

Admin User (Founder):
- Username: webwaka-founder-admin
- Console URL: https://[ACCOUNT-ID].signin.aws.amazon.com/console
- Password: [Stored securely by Founder]
- MFA: Enabled ✅

Deployment User (CI/CD):
- Username: webwaka-deployment-user
- Access Key ID: AKIA...
- Secret Access Key: [Stored in GitHub Secrets]
- MFA: Not applicable (programmatic access only)

AWS Account Details:
- Account ID: [12-digit number]
- Region: us-east-1 (US East - N. Virginia)
- Budget: $200/month
- Budget alerts: Enabled at 50%, 75%, 90%, 100%

CloudTrail:
- Enabled: ✅
- S3 Bucket: webwaka-audit-trail-logs-[ACCOUNT-ID]
```

2. Store this document in a secure password manager (e.g., 1Password, LastPass, Bitwarden)

3. **NEVER commit credentials to Git or share via insecure channels**

---

## 13. Step 11: Add Deployment Credentials to GitHub Secrets

**Why:** GitHub Actions needs AWS credentials to deploy code.

### Instructions:

1. Navigate to GitHub repository: https://github.com/webwakaagent1/webwaka-execution-control

2. Click **Settings** → **Secrets and variables** → **Actions**

3. Click **New repository secret**

4. Add the following secrets:

   **Secret #1:**
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: [Access Key ID from deployment user]
   - Click **Add secret**

   **Secret #2:**
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: [Secret Access Key from deployment user]
   - Click **Add secret**

   **Secret #3:**
   - Name: `AWS_REGION`
   - Value: `us-east-1`
   - Click **Add secret**

   **Secret #4:**
   - Name: `AWS_ACCOUNT_ID`
   - Value: [Your 12-digit AWS account ID]
   - Click **Add secret**

5. **Verification:** All 4 secrets are listed in the repository secrets

---

## 14. Completion Checklist

**Before proceeding to Phase 1, verify all steps are complete:**

- [ ] Root account MFA enabled
- [ ] Root access keys deleted (or verified none exist)
- [ ] IAM admin user created (`webwaka-founder-admin`)
- [ ] Admin user MFA enabled
- [ ] IAM deployment user created (`webwaka-deployment-user`)
- [ ] Deployment user access keys generated and saved
- [ ] Custom deployment policy created and attached
- [ ] AWS budget configured ($200/month with 4 alert thresholds)
- [ ] CloudTrail enabled for audit logging
- [ ] AWS region set to us-east-1
- [ ] Service availability verified
- [ ] IAM credentials documented securely
- [ ] Deployment credentials added to GitHub Secrets

**Once all items are checked, Phase 1 implementation can begin.**

---

## 15. Troubleshooting

### Issue: Can't enable MFA on root account

**Solution:**
- Ensure you're logged in as root user (not IAM user)
- Try a different MFA app (Google Authenticator, Authy, Microsoft Authenticator)
- Check that your device's time is synchronized

### Issue: Policy attachment fails

**Solution:**
- Verify you have AdministratorAccess permissions
- Check that the policy name is spelled correctly
- Try refreshing the IAM console

### Issue: Budget alerts not received

**Solution:**
- Check spam/junk folder
- Verify email address is correct in budget settings
- Confirm email subscription (check for confirmation email from AWS)

### Issue: CloudTrail creation fails

**Solution:**
- Verify S3 bucket name is globally unique
- Check that you have permissions to create S3 buckets
- Try a different bucket name

---

## 16. Security Best Practices

**Ongoing security maintenance:**

1. **Rotate access keys every 90 days:**
   - Create new access keys for deployment user
   - Update GitHub Secrets with new keys
   - Delete old access keys

2. **Review IAM permissions quarterly:**
   - Remove unused permissions
   - Follow principle of least privilege

3. **Monitor CloudTrail logs:**
   - Set up CloudWatch alarms for suspicious activity
   - Review logs monthly

4. **Enable AWS Config:**
   - Track configuration changes
   - Ensure compliance with security policies

5. **Use AWS Organizations (future):**
   - When creating production account
   - Centralize billing and security policies

---

## 17. Next Steps

**After completing this setup:**

1. Verify all checklist items are complete
2. Document AWS Account ID in `AWS_BOOTSTRAP_CONFIG.md`
3. Proceed to Phase 1 implementation using `PHASE_1_EXECUTION_PROMPT.md`
4. Begin provisioning AWS services per Phase 1 deliverables

**Phase 1 will create:**
- Cognito user pool
- Aurora PostgreSQL database
- Fargate ECS cluster
- Amplify frontend hosting
- SES email configuration
- SNS notification topics
- S3 buckets + CloudFront distribution
- EventBridge event bus
- SQS queues
- Bedrock AI integration

---

## 18. Support

**If you encounter issues during IAM setup:**

1. Check AWS documentation: https://docs.aws.amazon.com/iam/
2. Contact AWS Support (if you have a support plan)
3. Document the issue in a GitHub issue with label `aws-setup`

---

**End of AWS IAM Setup Guide**
