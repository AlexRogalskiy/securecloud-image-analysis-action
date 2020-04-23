# Docker Vulnerability Scan with Tufin SecureCloud

This GitHub Action scans a docker image for vulnerabilities using Tufin SecureCloud.

## Usage

Build a docker image (or pull it from a registry) and then use this action to scan it for vulnerabilities.

## Setup

1.  [Signup to SecureCloud](https://www.tufin.com/request-evaluation)

2.  In the SecureCloud console, go to the Kubernetes/Settings/General view and copy two tokens:

    - The token with `Scope=agent` and `Label=kite`

    - The token with `Scope=all` and `Label=CI`

3.  Add the following secrets to your repository's secrets (under Settings):

    - `TUFIN_DOCKER_REPO_PASSWORD`: The token with Scope=`agent` and Label=`kite`

    - `TUFIN_API_KEY`: The token with `Scope=all` and `Label=CI`

4.  Call the Tufin action with the following parametes:

| Parameter           | Type    | Default    | Desription                                                   |
|:------------------- |:------- |:-----------|:-------------------------------------------------------------|
| securecloud_account | string  |            | SecureCloud account                                          |
| securecloud_project | string  |            | SecureCloud project                                          |
| image               | string  |            | Image name                                                   |
| tag                 | string  | latest     | Image tag                                                    |
| cve_details         | boolean | false      | Whether to inlcude CVE details in output or only the summary |
 

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
          TUFIN_DOCKER_REPO_PASSWORD: ${{ secrets.TUFIN_DOCKER_REPO_PASSWORD }}
          TUFIN_API_KEY: ${{ secrets.TUFIN_API_KEY }}
```

## How it works

The action starts by pushing the image to https://registry.tufin.io. This allows SecureCloud to scan images in private repositories.  
Once the image is pushed, SecureCloud scans it and returns a high-level summary of the findings

## Output

The scan action returns a high-level summary of the findings including the number of vulnerabilities for each severity (critical, high etc.), a rank and a score.
The rank range is between 1 (many vulnerabilities) to 100 (no vulnerabilities).
The score is one of:

| Score | Rank  | Vulnerabilities                    |
|:------|:------|:-----------------------------------|
| A+    | 100   | None                               |
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

## CVE details

You can add the CVE details to the output by setting cve_details to true.  
For example:

```
{
  "Id": "73c95d99-c7e9-40f6-a967-c3469570a62b",
  "Timestamp": 1587642121726704958,
  "Image": "ubuntu:trusty-20161101",
  "State": "Finished",
  "Rank": 1,
  "Score": "F",
  "Vulnerabilities": [
    {
      "Vulnerability": {
        "Name": "CVE-2016-1252",
        "NamespaceName": "ubuntu:14.04",
        "Description": "The apt package in Debian jessie before 1.0.9.8.4, in Debian unstable before 1.4~beta2, in Ubuntu 14.04 LTS before 1.0.1ubuntu2.17, in Ubuntu 16.04 LTS before 1.2.15ubuntu0.2, and in Ubuntu 16.10 before 1.3.2ubuntu0.1 allows man-in-the-middle attackers to bypass a repository-signing protection mechanism by leveraging improper error handling when validating InRelease file signatures.",
        "Link": "http://people.ubuntu.com/~ubuntu-security/cve/CVE-2016-1252",
        "Severity": "High",
        "Metadata": {
          "NVD": {
            "CVSSv2": {
              "PublishedDateTime": "2017-12-05T16:29Z",
              "Score": 4.3,
              "Vectors": "AV:N/AC:M/Au:N/C:N/I:P/A:N"
            },
            "CVSSv3": {
              "ExploitabilityScore": 2.2,
              "ImpactScore": 3.6,
              "Score": 5.9,
              "Vectors": "CVSS:3.0/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:H/A:N"
            }
          }
        },
        "FixedBy": "1.0.1ubuntu2.17"
      },
      "Feature": {
        "Name": "apt",
        "NamespaceName": "ubuntu:14.04",
        "Version": "1.0.1ubuntu2.15",
        "Vulnerabilities": [
          {
            "Name": "CVE-2016-1252",
            "NamespaceName": "ubuntu:14.04",
            "Description": "The apt package in Debian jessie before 1.0.9.8.4, in Debian unstable before 1.4~beta2, in Ubuntu 14.04 LTS before 1.0.1ubuntu2.17, in Ubuntu 16.04 LTS before 1.2.15ubuntu0.2, and in Ubuntu 16.10 before 1.3.2ubuntu0.1 allows man-in-the-middle attackers to bypass a repository-signing protection mechanism by leveraging improper error handling when validating InRelease file signatures.",
            "Link": "http://people.ubuntu.com/~ubuntu-security/cve/CVE-2016-1252",
            "Severity": "High",
            "Metadata": {
              "NVD": {
                "CVSSv2": {
                  "PublishedDateTime": "2017-12-05T16:29Z",
                  "Score": 4.3,
                  "Vectors": "AV:N/AC:M/Au:N/C:N/I:P/A:N"
                },
                "CVSSv3": {
                  "ExploitabilityScore": 2.2,
                  "ImpactScore": 3.6,
                  "Score": 5.9,
                  "Vectors": "CVSS:3.0/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:H/A:N"
                }
              }
            },
            "FixedBy": "1.0.1ubuntu2.17"
          },
          {
            "Name": "CVE-2019-3462",
            "NamespaceName": "ubuntu:14.04",
            "Description": "Incorrect sanitation of the 302 redirect field in HTTP transport method of apt versions 1.4.8 and earlier can lead to content injection by a MITM attacker, potentially leading to remote code execution on the target machine.",
            "Link": "http://people.ubuntu.com/~ubuntu-security/cve/CVE-2019-3462",
            "Severity": "High",
            "Metadata": {
              "NVD": {
                "CVSSv2": {
                  "PublishedDateTime": "2019-01-28T21:29Z",
                  "Score": 9.3,
                  "Vectors": "AV:N/AC:M/Au:N/C:C/I:C/A:C"
                },
                "CVSSv3": {
                  "ExploitabilityScore": 0,
                  "ImpactScore": 0,
                  "Score": 0,
                  "Vectors": ""
                }
              }
            },
            "FixedBy": "1.0.1ubuntu2.19"
          }
        ],
        "AddedBy": "46cd7d7b1e79d99fc257f5dab45029d3693428eb61e36dcd53c38a6766e1408e"
      },
      "Priority": "High"
}]}
```