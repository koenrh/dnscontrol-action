# DNSControl Action

![](https://github.com/koenrh/dnscontrol-action/workflows/build/badge.svg)

Deploy your DNS configuration using [GitHub Actions](https://github.com/actions)
using [DNSControl](https://github.com/StackExchange/dnscontrol/).

## Usage

These are the three relevant sub commands to use with this action.

### check

Run the action with the 'check' argument in order to check and validate the `dnsconfig.js`
file. This action does not communicate with the DNS providers, hence does not require
any secrets to be set.

```yaml
name: Check

on: pull_request

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: DNSControl check
        uses: koenrh/dnscontrol-action@v4.7.3
        with:
          args: check

          # Optionally, if your DNSConfig files are in a non-default location,
          # you could specify the paths to the config and credentials file.
          config_file: 'dns/dnsconfig.js'
```

### preview

Run the action with the 'preview' argument to check what changes need to be made.
It prints out what DNS records are expected to be created, modified or deleted.
This action requires the secrets for the specified DNS providers.

```yaml
name: Preview

on: pull_request

jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: DNSControl preview
        uses: koenrh/dnscontrol-action@v4.7.3
        id: dnscontrol_preview
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
        with:
          args: preview

          # Optionally, if your DNSConfig files are in a non-default location,
          # you could specify the paths to the config and credentials file.
          config_file: 'dns/dnscontrol.js'
          creds_file: 'dns/creds.json'
```

This is the action you probably want to run for each branch so that proposed changes
could be verified before an authorized person merges these changes into the default
branch.

#### Pull request comment

Optionally, you could configure your GitHub Action so that the output of the 'preview'
command is published as a comment to the pull request for the branch containing the
changes. This saves you several clicks through the menus to get to the output logs
for the preview job.

```
 ******************** Domain: example.com
----- Getting nameservers from: cloudflare
----- DNS Provider: cloudflare...6 corrections
#1: CREATE record: @ TXT 1 v=spf1 include:_spf.google.com -all
#2: CREATE record: @ MX 1 1  aspmx.l.google.com.
#3: CREATE record: @ MX 1 5  alt1.aspmx.l.google.com.
#4: CREATE record: @ MX 1 5  alt2.aspmx.l.google.com.
#5: CREATE record: @ MX 1 10  alt3.aspmx.l.google.com.
#6: CREATE record: @ MX 1 10  alt4.aspmx.l.google.com.
----- Registrar: none...0 corrections
Done. 6 corrections.
```

Provided that your GitHub Action job for 'preview' has an id
`dnscontrol_preview`, you could use the following snippet to enable pull request
comments using Unsplash's [comment-on-pr](https://github.com/unsplash/comment-on-pr)
GitHub Action.

```yaml
- name: Preview pull request comment
  uses: unsplash/comment-on-pr@v1.3.0
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    msg: |
      ```
      ${{ steps.dnscontrol_preview.outputs.preview_comment }}
      ```
    check_for_duplicate_msg: true
```

### push

Run the action with the 'push' argument to publish the changes to the specified
DNS providers.

Running the action with the 'push' argument will publish the changes with the
specified DNS providers. The example workflow depicted below contains a filtering
pattern so that it only runs on the default branch.

```yaml
name: Push

on:
  push:
    branches:
      - main

jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: DNSControl push
        uses: koenrh/dnscontrol-action@v4.7.3
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
        with:
          args: push

          # Optionally, if your DNSConfig files are in a non-default location,
          # you could specify the paths to the config and credentials file.
          config_file: 'dns/dnsconfig.js'
          creds_file: 'dns/creds.json'
```

## Credentials

Depending on the DNS providers that are used, this action requires credentials to
be set. These secrets can be configured through a file named `creds.json`. You
should **not** add secrets as plaintext to this file, but use GitHub
Actions [encrypted secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)
instead. These encrypted secrets are exposed at runtime as environment variables.
See the DNSControl [Service Providers](https://stackexchange.github.io/dnscontrol/provider-list)
documentation for details.

To follow the Cloudflare example, add an encrypted secret named `CLOUDFLARE_API_TOKEN`
and then define the `creds.json` file as follows.

```json
{
  "cloudflare":{
    "TYPE": "CLOUDFLAREAPI",
    "apitoken": "$CLOUDFLARE_API_TOKEN"
  }
}
```

## Dependabot

[Dependabot](https://docs.github.com/en/github/administering-a-repository/keeping-your-actions-up-to-date-with-github-dependabot)
is a GitHub service that helps developers to automate dependency maintenance and
keep dependencies updated to the latest versions. It has native support for
[GitHub Actions](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#package-ecosystem),
which means you can use it in your GitHub repository to keep the DNSConrol Acion
up-to-date.

To enable Dependabot in your GitHub repository, add a `.github/dependabot.yml`
file with the following contents:

```yaml
version: 2
updates:
  # Maintain dependencies for GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "daily"
```
