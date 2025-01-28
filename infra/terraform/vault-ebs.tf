provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_ebs_volume" "vault_storage" {
  availability_zone = "ap-northeast-2a"
  size              = 10

  tags = {
    Name = "Vault Storage"
  }
}

output "ebs_volume_id" {
  value = aws_ebs_volume.vault_storage.id
}
