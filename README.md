# Docker Vulnerability Scan with Tufin SecureChange GitHub Action

This GitHub Action scans a docker image for vulnerabilities using Tufin SecureCloud.

## Usage

Build a docker image (or pull it from some registry) and then use this action to scan it for vulnerabilities.

## Setup

1.  Signup to SecureCloud 

2.  In the SecureCloud console, go to the Kubernetes/Settings/General view and copy two tokens:

    - The token with Scope=`agent` and Label=`kite`

    - The token with Scope=`all` and Label=`CI`

3.  Add the following secrets to your repository's secrets (under Settings):

    - `TUFIN_DOCKER_REPO_PASSWORD`: The token with Scope=`agent` and Label=`kite`

    - `TUFIN_API_KEY`: The token with Scope=`all` and Label=`CI`

4.  Call the Tufin action with the following parametes:

## Run the workflow

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
        run: docker build -t image_to_scan:latest . 
      - name: Tufin SecureCloud Vulenrability Analysis
        uses: Tufin/securecloud-image-analysis-action
        with:
          securecloud_account: <your SecureCloud account name>
          securecloud_project: <your SecureCloud project name>
          image: <the image you want to scan, e.g. 'image_to_scan' - must be present locally>
          tag: <the image tag , e.g. 'latest'>
        env:
          TUFIN_API_KEY: ${{ secrets.TUFIN_API_KEY }}
          TUFIN_DOCKER_REPO_PASSWORD: ${{ secrets.TUFIN_DOCKER_REPO_PASSWORD }}
```
