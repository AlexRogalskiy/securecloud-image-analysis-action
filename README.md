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
| image               | Image name           | yes         |
| tag                 | Image tag            | no          |


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

The action starts by pushing the image to https://registry.tufin.io. This allows SecureCloud to scan images in private repositories.  
Once the image is pushed, SecureCloud scans it and returns a high-level summary of the findings

## Output

The scan action returns a high-level summary of the findings including the number of vulnerabilities for each severity (critical, high etc.), a rank and a score.
The rank range is between 1 (many vulnerabilities) to 100 (no vulnerabilities).
The score is one of:

| Score | Rank  | Vulnerabilities                    |
| ------|-------|------------------------------------|
| A+    | 100   | No vulnerabilities                 |
| A     | 90-99 | A few with low severities          |
| B     | 80-89 | ...                                |
| C     | 70-79 | ...                                |
| D     | 60-60 | ...                                |
| F     | <60   | Many or a few with high-severities |

For example, this scan found multiple vulnerabilities including four high-severity ones, the score is therefor 'F':

```
{
  "Id": "5658fd79-af24-4713-b373-560050311140",
  "Timestamp": 1587625041488578600,
  "Image": "ubuntu:trusty-20161101",
  "State": "Finished",
  "Rank": 1,
  "Score": "F",
  "Vulnerabilities": [
    {
      "Severity": "High",
      "Items": 4
    },
    {
      "Severity": "Medium",
      "Items": 81
    },
    {
      "Severity": "Low",
      "Items": 94
    },
    {
      "Severity": "Negligible",
      "Items": 34
    }
  ]
}
```

This scan found no vulnerabilities, the score is therefor 'A+':

```
{
  "Id": "c63ae188-603c-4d80-8e7f-5f14c63c8512",
  "Timestamp": 1587625026671285200,
  "Image": "image_to_scan:latest",
  "State": "Finished",
  "Rank": 100,
  "Score": "A+",
  "Vulnerabilities": []
}
```