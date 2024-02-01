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

variable "datadog_buffering_interval_seconds" {
  type    = number
  default = 60

  validation {
    condition     = var.datadog_buffering_interval_seconds >= 0 && var.datadog_buffering_interval_seconds <= 900
    error_message = "Allowed buffering interval between 0-900 seconds."
  }
}
