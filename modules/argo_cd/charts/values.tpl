argocd-apps:
  applications:
    example-app:
      namespace: argocd
      project: default
      source:
        repoURL: https://github.com/ira-alchynska/devops.git
        path: charts/django-app
        targetRevision: final-project
        helm:
          valueFiles:
            - values.yaml
          values: |
            config:
              POSTGRES_HOST: "example-app-postgresql"
              POSTGRES_USER: "postgres"
              POSTGRES_NAME: "myapp"
              POSTGRES_PASSWORD: "postgres"
      destination:
        server: https://kubernetes.default.svc
        namespace: default
      syncPolicy:
        automated:
          prune: true
          selfHeal: true

  repositories:
    example-app:
      url: https://github.com/ira-alchynska/devops.git

  repoConfig:
    insecure: "true"
    enableLfs: "true"