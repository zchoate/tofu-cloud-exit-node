resource "digitalocean_droplet" "exit_node" {
  name   = "do-cloud-exit-node"
  image  = "ubuntu-24-04-x64"
  region = "nyc3"
  size   = "s-1vcpu-1gb"

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    # tailscale_auth_key = var.tailscale_auth_key
    tailscale_auth_key = tailscale_tailnet_key.exit_node.key
    ssh_public_key     = var.ssh_public_key
    vm_username        = var.vm_username
  })
}

resource "digitalocean_firewall" "default_outbound" {
  name        = "default-outbound"
  droplet_ids = [digitalocean_droplet.exit_node.id]

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "tailscale_inbound" {
  name        = "tailscale-inbound"
  droplet_ids = [digitalocean_droplet.exit_node.id]

  inbound_rule {
    protocol         = "udp"
    port_range       = "41641"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "http_inbound" {
  name        = "http-inbound"
  droplet_ids = [digitalocean_droplet.exit_node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}