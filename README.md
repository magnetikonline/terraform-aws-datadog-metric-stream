# Terraform AWS -> Datadog metric stream

A boilerplate Terraform configuration for standing up required AWS infrastructure to support [CloudWatch Metric Streams for the delivery of metrics into Datadog](https://docs.datadoghq.com/integrations/guide/aws-cloudwatch-metric-streams-with-kinesis-data-firehose/).

This offers a _significantly_ faster delivery method of CloudWatch metrics using a CloudWatch metric stream for batching and pushing into Datadog every 2-3 minutes vs. the traditional approach of Datadog polling CloudWatch APIs for metrics roughly every 10 minutes.

- [Implementation](#implementation)
- [Terraform variables](#terraform-variables)
- [Related](#related)

## Implementation

Resources created and their interplay:

- A [CloudWatch metric stream](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Metric-Streams.html) takes selected CloudWatch metric AWS namespaces and feeds into a nominated Kinesis Firehose delivery stream (see below).
- [Kinesis Firehose delivery stream](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html) buffers received stream metrics and periodically pushes to a nominated HTTP endpoint - in this instance the Datadog metric intake API.
- An S3 bucket, which is required by the Kinesis delivery stream to store either all data received, or data which failed delivery to our HTTP endpoint. The configuration here uses the latter mode (delivery errors only).

## Terraform variables

See [`example.tfvars`](example.tfvars) for usage of these variables:

- `datadog_api_key`: Your Datadog account API key, which is sent along with HTTP push requests made by the Kinesis Firehose delivery stream.
- `datadog_metric_stream_namespace_list`: List of CloudWatch metric AWS namespaces for delivery onto Datadog. AWS metrics which _are not_ delivered to Datadog via Kinesis will continue to pulled by Datadog using the legacy AWS metrics polling method.
- `datadog_firehose_endpoint`: The HTTPS endpoint for delivery of metrics payloads into Datadog. Will differ based on the location of your Datadog account (US/EU).

## Related

- https://aws.amazon.com/blogs/aws/cloudwatch-metric-streams-send-aws-metrics-to-partners-and-to-your-apps-in-real-time/
- https://www.datadoghq.com/blog/amazon-cloudwatch-metric-streams-datadog/
- https://docs.datadoghq.com/integrations/guide/aws-cloudwatch-metric-streams-with-kinesis-data-firehose/
- Terraform AWS provider resources:
	- [`aws_cloudwatch_metric_stream`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream)
	- [`aws_kinesis_firehose_delivery_stream`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream)
