pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    BUCKET_NAME = 'my-lambda-code-bucket-123456'
    S3_KEY = 'lambda.zip'
    ROLE_ARN = 'arn:aws:iam::<your-account-id>:role/lambda-exec-role'
  }

  stages {
    stage('Package Lambda') {
      steps {
        sh 'zip lambda.zip lambda_function.py'
      }
    }

    stage('Upload to S3') {
      steps {
        sh 'aws s3 cp lambda.zip s3://${BUCKET_NAME}/${S3_KEY}'
      }
    }

    stage('Deploy Lambda with Terraform') {
      steps {
        git url: 'https://git.company.com/infra-repo.git'
        dir('infra-repo/lambda') {
          sh '''
            terraform init
            terraform apply -auto-approve \
              -var="lambda_s3_key=${S3_KEY}" \
              -var="lambda_role_arn=${ROLE_ARN}"
          '''
        }
      }
    }
  }
}
