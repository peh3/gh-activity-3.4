terraform {
  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "tk\\gh-activity-3.4-bootstrap.tfstate"
    #use_lockfile = true
    region = "us-east-1"
  }
}