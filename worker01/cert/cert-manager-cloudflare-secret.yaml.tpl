apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
type: Opaque
stringData:
  api-token: "${api_key}"
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: "${name}-issuer"
spec:
  acme:
    email: wangwei@gmail.com
    privateKeySecretRef:
      name: acme-key
    # TODO CHANGE TO PRODUCTION
    server: https://acme-v02.api.letsencrypt.org/directory
    # server: https://acme-staging-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cloudflare-api-token-secret
            key: api-token