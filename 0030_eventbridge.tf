resource "aws_cloudwatch_event_rule" "eventbrige-update-file-sla1--eap--8015--infra" {
  name        = "Rule_eventbrige_update-file-sla1--eap--8015--infra"
  description = "Event for update-file operations--sla1--eap--8015--infra to s3"
  role_arn    = aws_iam_role.eventbrige-sla1--eap--8015--infra.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-integration-operations"]
    },
    "object": {
      "key": ["Etc/operations--sla1--eap--8015--infra/hosts"]
    }
  }
}
EOF
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "eventbrige-update-file-sla1--eap--8015--infra" {
  target_id = "Target_update-file_sla1--eap--8015--infra"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-update-file-sla1--eap--8015--infra.name
  role_arn  = aws_iam_role.eventbrige-sla1--eap--8015--infra.arn
  input     = "{\"commands\":[\"bash /wl_config/update-file.sh iberia-configs-files-apps-integration-operations Etc/operations--sla1--eap--8015--infra/hosts /etc/hosts\"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["operations--sla1--eap--8015--infra"]
  }

}
