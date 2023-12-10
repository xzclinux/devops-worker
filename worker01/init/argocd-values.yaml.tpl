configs:
  secret:
    argocdServerAdminPassword: $2a$10$.NeEDuo4qmMNzuwHBLMvDuIpvqT52TdzW.1Zg9/dDssaiSRN.xa3u  #password123
  cm:
    timeout.reconciliation: 20s
  params:
    server.insecure: true

server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/tls-acme: "true"
      cert-manager.io/issuer: "argocd-issuer"
    ingressClassName: nginx
    hosts:
      - "argocd.${domain}"
    tls:
    - secretName: argocd-secret-tls
      hosts:
        - "argocd.${domain}"
