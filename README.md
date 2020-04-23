# Docker Vulnerability Scan with Tufin SecureCloud

This GitHub Action scans a docker image for vulnerabilities using Tufin SecureCloud.

## Usage

Build a docker image (or pull it from a registry) and then use this action to scan it for vulnerabilities.

## Setup

1.  [Signup to SecureCloud](https://www.tufin.com/request-evaluation)

2.  In the SecureCloud console, go to the Kubernetes/Settings/General view and copy two tokens:

    - The token with Scope=`agent` and Label=`kite`

    - The token with Scope=`all` and Label=`CI`

3.  Add the following secrets to your repository's secrets (under Settings):

    - `TUFIN_DOCKER_REPO_PASSWORD`: The token with Scope=`agent` and Label=`kite`

    - `TUFIN_API_KEY`: The token with Scope=`all` and Label=`CI`

4.  Call the Tufin action with the following parametes:

| Parameter           | Desription           | Mandatory?  |
| ------------------- | -------------------- | ----------- |
| securecloud_account | SecureCloud account  | yes         |
| securecloud_project | SecureCloud project  | yes         |
| image               | Docker image name    | yes         |
| tag                 | Image image tag      | no          |


## Run the workflow

For example:

```
name: Test
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@master
      - name: Build the Docker Image
        run: docker build -t image_to_scan:2 . 
      - name: Tufin SecureCloud Vulenrability Analysis
        uses: Tufin/securecloud-image-analysis-action
        with:
          securecloud_account: generic-bank
          securecloud_project: my-project
          image: image_to_scan
          tag: 2
        env:
          TUFIN_API_KEY: ${{ secrets.TUFIN_API_KEY }}
          TUFIN_DOCKER_REPO_PASSWORD: ${{ secrets.TUFIN_DOCKER_REPO_PASSWORD }}
```

## How it works

The action starts by pushing the image to https://registry.tufin.io, this approach allows SecureCloud to scan images in private repositories.

Once the image is pushed, SecureCloud scans it and returns a high-level summary of the findings.

