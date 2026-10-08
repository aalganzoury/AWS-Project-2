# Private app instances: IMDSv2 required, encrypted EBS, no public IP, least-privilege role.
terraform {
  required_version = ">= 1.6"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

resource "aws_instance" "app" {
  count                       = length(var.app_subnet_ids)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.app_subnet_ids[count.index]
  vpc_security_group_ids      = [var.app_sg_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = false
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # WHY: IMDSv2 blocks SSRF credential theft
  }
  root_block_device {
    encrypted = true # WHY: EBS encryption default
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf install -y python3 || yum install -y python3
    cat >/home/ec2-user/app.py <<'PY'
    from http.server import BaseHTTPRequestHandler, HTTPServer
    class H(BaseHTTPRequestHandler):
      def do_GET(self):
        body = b'{"status":"ok","az":"lab"}'
        self.send_response(200); self.send_header('Content-Type','application/json')
        self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body)
      def log_message(self, *a): pass
    HTTPServer(('0.0.0.0', ${var.app_port}), H).serve_forever()
    PY
    nohup python3 /home/ec2-user/app.py >/var/log/app.log 2>&1 &
    echo "health" > /var/log/health-check
  EOF
  )
  tags = merge(var.tags, { Name = "app-${count.index}", Role = "app" })
}
