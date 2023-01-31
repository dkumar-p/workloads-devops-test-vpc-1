resource "aws_iam_role" "eventbrige-sla4--ews--infra-8009" {
  name = format("%s%s%s%s-%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idae", "sla4--ews--infra-8009", "00013")

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}


## custom policy for s3 with encripted and access Kms---------------------------
resource "aws_iam_policy" "policy-eventbrige-sla4--ews--infra-8009" {
  name        = "cloudwatch-eventbrige-access-sla4--ews--infra-8009"
  path        = "/"
  description = "access eventbrige and ec2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:SendCommand"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:eu-west-1:420879962194:instance/*"
        ],
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/*" : [
              "operations-airports--sla4--ews--infra-8009"
            ]
          }
        }
      },
      {
        "Action" : "ssm:SendCommand",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ssm:eu-west-1:*:document/AWS-RunShellScript"
        ]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eventbrige-sla4--ews--infra-8009" {
  role       = aws_iam_role.eventbrige-sla4--ews--infra-8009.name
  policy_arn = aws_iam_policy.policy-eventbrige-sla4--ews--infra-8009.arn
}
