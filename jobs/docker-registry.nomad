job "docker-registry" {
  datacenters = ["dc1"]
  type = "service"

  group "registry" {
    count = 1
    ephemeral_disk {
      sticky = true
      migrate = true
      size = 300
    }
    task "docker-registry" {
      driver = "docker"
      config {
        image = "registry:2"
        port_map {
          http = 5000
        }
      }
      resources {
        cpu    = 250 # 250 MHz
        memory = 256 # 256MB

        network {
          mbits = 10
          port "http" { static = 5000 }
        }
      }
      service {
        name = "docker-registry"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.docker-registry.rule=HostRegexp(`registry.lazz.tech`)"
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }

    task "docker-registry-frontend" {
      driver = "docker"
      env {
        ENV_DOCKER_REGISTRY_HOST="0.0.0.0"
        ENV_DOCKER_REGISTRY_PORT="5000"
        // ENV_DOCKER_REGISTRY_USE_SSL="1"
      }
      config {
        image = "konradkleine/docker-registry-frontend:v2"
        port_map {
          http = 80
        }
      }
      resources {
        cpu    = 250 # 250 MHz
        memory = 256 # 256MB

        network {
          mbits = 10
          port "http" {}
        }
      }
      service {
        name = "docker-registry-frontend"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.docker-registry-frontend.rule=HostRegexp(`docker.lazz.tech`)"
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
