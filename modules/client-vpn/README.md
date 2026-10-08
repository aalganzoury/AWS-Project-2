# client-vpn module (OPTIONAL, default OFF)
Mutual TLS (ACM cert ARNs as vars). Generate with easy-rsa (do NOT commit keys):
```bash
easyrsa init-pki; easyrsa build-ca nopass; easyrsa build-server-full server nopass; easyrsa build-client-full client1 nopass
aws acm import-certificate --certificate fileb://pki/issued/server.crt --private-key fileb://pki/private/server.key --certificate-chain fileb://pki/ca.crt
```
Cost: endpoint-hour + association-hour — enable minutes only.
