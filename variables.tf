variable "datadog_api_key" {
  type      = string
  sensitive = true
}

variable "datadog_firehose_endpoint" {
  type = string

  validation {
    condition = contains([
      "https://awsmetrics-intake.datadoghq.com/v1/input",
      "https://awsmetrics-intake.datadoghq.eu/v1/input",
    ], var.datadog_firehose_endpoint)

    error_message = "Invalid Datadog Kinesis Firehose endpoint."
  }
}

variable "datadog_metric_stream_namespace_list" {
  type    = list(string)
  default = []
}
