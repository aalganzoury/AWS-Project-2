# Firewall Manager Concepts (concept + policy JSON examples)

> Firewall Manager requires AWS Organizations + AWS Config + delegated admin. Do NOT enable in a single-account lab without accepting cost/org changes.

## What it manages
Central WAF (CLOUDFRONT + REGIONAL), Security Groups (audit/remediate overly open), Network Firewall, Shield Advanced, DNS Firewall policies across accounts/OUs.

## Prerequisites
1. Organization with all features; 2. AWS Config recorder on; 3. Delegated Firewall Manager admin account; 4. IAM policy for admin.

## Policy examples (JSON — adapt ARNs to placeholders)

```json
{
  "PolicyName": "fms-waf-alb-baseline",
  "ResourceType": "AWS::ElasticLoadBalancingV2::LoadBalancer",
  "SecurityServicePolicyData": {
    "Type": "WAFV2",
    "ManagedServiceData": "{\"type\":\"WAFV2\",\"preProcessRuleGroups\":[{\"ruleGroupId\":\"AWSManagedRulesCommonRuleSet\"}],\"defaultAction\":{\"type\":\"BLOCK\"}}"
  },
  "RemediationEnabled": true
}
```

```json
{
  "PolicyName": "fms-sg-no-open-ssh",
  "ResourceType": "AWS::EC2::SecurityGroup",
  "SecurityServicePolicyData": {
    "Type": "SECURITY_GROUPS_COMMON",
    "ManagedServiceData": "{\"type\":\"SECURITY_GROUPS_COMMON\",\"revertManualSecurityGroupChanges\":true}"
  }
}
```
