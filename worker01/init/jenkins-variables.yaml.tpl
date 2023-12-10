controller:
  installPlugins:
    - git:5.2.0
  additionalPlugins: 
  - prometheus:2.2.3
  - kubernetes-credentials-provider:1.211.vc236a_f5a_2f3c
  - job-dsl:1.84
  - github:1.37.1
  - github-branch-source:1725.vd391eef681a_e
  - gitlab-plugin:1.7.16
  - gitlab-branch-source:660.vd45c0f4c0042
  - gitlab-kubernetes-credentials:132.v23fd732822dc
  - pipeline-stage-view:2.33
  - sonar:2.15
  - pipeline-utility-steps:2.16.0
  ingress:
    enabled: true
    annotations:
      kubernetes.io/tls-acme: "true"
      cert-manager.io/issuer: "jenkins-issuer"
    ingressClassName: nginx
    hostName: jenkins.${domain}
    tls:
    - secretName: jenkins-scret-tls
      hosts:
        - jenkins.${domain}