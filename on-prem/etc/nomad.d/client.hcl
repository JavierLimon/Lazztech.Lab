# Increase log verbosity
log_level = "DEBUG"

# Give the agent a unique name. Defaults to hostname
name = "client1"

# Enable the client
client {
    enabled = true

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["127.0.0.1:4647"]

  host_volume "acme" {
    path     = "/acme"
    read_only = false
  }
}

# For Prometheus metrics
telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}

ports {
    http = 4646
}

plugin "docker" {
  config {
    allow_caps = ["ALL"]
  }
}