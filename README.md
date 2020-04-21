# Docker Image Scan with Tufin SecureChange GitHub Action

This GitHub Action scans a docker image for vulnerabilities using Tufin SecureCloud.

## Usage

Build a docker image (or pull it from some registry) and then use this action to scan it for vulnerabilities.

## Setup

1.  Signup to SecureCloud 

2.  In the SecureCloud console, go to the Kubernetes/Settings/General view and copy two tokens:
    1. The token with Scope=agent and Label=kite
    2. The token with Scope=all and Label=CI

3.  Add the following secrets to your repository's secrets (under Settings):

    - `TUFIN_DOCKER_REPO_PASSWORD`: The token with Scope=agent and Label=kite

    - `TUFIN_API_KEY`: <The token with Scope=all and Label=CI>

4.  Call the Tufin action with the following parametes:

## Run the workflow

