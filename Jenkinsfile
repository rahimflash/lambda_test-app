pipeline {
  agent any

  environment {
    AWS_REGION = 'eu-west-1'
    BUCKET_NAME = 'sandbox-test-lambda-code-bucket'
    S3_KEY = 'lambda.zip'
    ROLE_ARN = 'arn:aws:iam::985539772768:role/lambda-exec-role'
  }

  stages {
    stage('Package Lambda') {
      steps {
        sh 'zip lambda.zip lambda_function.py'
      }
    }

    stage('Authenticate with AWS and Deploy') {
      steps {
        withAWS(credentials: 'aws_creds', region: "${AWS_REGION}") {
          
          sh 'aws sts get-caller-identity'  // Just to test access

          // Upload to S3
          sh "aws s3 cp lambda.zip s3://${BUCKET_NAME}/${S3_KEY}"

          // Clone the Terraform repo
          git url: 'https://github.com/rahimflash/lambda_test-app.git'

          // Terraform Init & Apply
          dir('lambda_test-app/lambda') {
            sh """
              terraform init
              terraform apply -auto-approve \
                -var="lambda_s3_key=${S3_KEY}" \
                -var="lambda_role_arn=${ROLE_ARN}"
            """
          }
        }
      }
    }
  }
}
