#!/usr/bin/env bash
# Restore lab after IR drill: remove quarantine tags, re-attach original SG, terminate sim snapshots (confirm).
set -euo pipefail
echo "Manual review first: incident log + manifest. Then:"
echo "  aws ec2 modify-instance-attribute --instance-id i-XXX --groups sg-original"
echo "  aws ec2 delete-tags --resources i-XXX --tags IncidentId Quarantine CompromiseSim"
echo "  terraform destroy in the week env used for the drill"
