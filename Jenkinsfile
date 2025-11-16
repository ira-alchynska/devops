pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
    - name: git
      image: alpine/git:latest
      command:
        - cat
      tty: true
    - name: yq
      image: mikefarah/yq:latest
      command:
        - cat
      tty: true
"""
    }
  }

  environment {
    ECR_REPOSITORY_URL = "${env.ECR_REPOSITORY_URL}"
    GITHUB_REPO_URL    = "${env.GITHUB_REPO_URL}"
    IMAGE_TAG          = "v1.0.${BUILD_NUMBER}"
    COMMIT_EMAIL       = "jenkins@localhost"
    COMMIT_NAME        = "jenkins"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
            # Extract ECR registry and image name from full repository URL
            ECR_FULL_URL="${ECR_REPOSITORY_URL}"
            ECR_REGISTRY=$(echo $ECR_FULL_URL | cut -d'/' -f1)
            IMAGE_NAME=$(echo $ECR_FULL_URL | cut -d'/' -f2)
            
            echo "Building and pushing to: $ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
            
            # Build context should be the app directory where Dockerfile and requirements.txt are located
            /kaniko/executor \\
              --context `pwd`/app \\
              --dockerfile Dockerfile \\
              --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \\
              --cache=true \\
              --insecure \\
              --skip-tls-verify
          '''
        }
      }
    }

    stage('Update Chart Tag in Git') {
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_PAT')]) {
            sh '''
              # Extract repo name from URL (handle both https://github.com/user/repo.git and https://github.com/user/repo formats)
              REPO_URL="${GITHUB_REPO_URL}"
              
              # Remove .git suffix if present and extract repo name
              if [[ "$REPO_URL" == *.git ]]; then
                REPO_NAME=$(basename "$REPO_URL" .git)
              else
                REPO_NAME=$(basename "$REPO_URL")
              fi
              
              # Extract username from URL (format: https://github.com/username/repo)
              REPO_USER=$(echo "$REPO_URL" | sed -E 's|https://github.com/([^/]+)/.*|\1|')
              
              # Clone repository
              git clone https://${GITHUB_USER}:${GITHUB_PAT}@github.com/${REPO_USER}/${REPO_NAME}.git repo-temp || \
              git clone https://${GITHUB_USER}:${GITHUB_PAT}@${REPO_URL#https://} repo-temp
              
              cd repo-temp
              
              # Checkout or create branch
              git checkout lesson-8-9 2>/dev/null || git checkout -b lesson-8-9
              
              # Update values.yaml
              cd charts/django-app
              sed -i "s|tag: .*|tag: $IMAGE_TAG|" values.yaml
              
              # Configure git
              git config user.email "$COMMIT_EMAIL"
              git config user.name "$COMMIT_NAME"
              
              # Commit and push
              git add values.yaml
              if git diff --staged --quiet; then
                echo "No changes to commit"
              else
                git commit -m "Update image tag to $IMAGE_TAG [skip ci]"
                git push origin lesson-8-9
              fi
            '''
          }
        }
      }
    }
  }
}
