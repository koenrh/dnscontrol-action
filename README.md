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
      - uses: actions/checkout@master

      - name: DNSControl check
        uses: koenrh/dnscontrol-action@v2.11
        with:
          args: check
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
      - uses: actions/checkout@master

      - name: DNSControl preview
        uses: koenrh/dnscontrol-action@v2.11
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
        with:
          args: preview
```

This is the action you probably want to run for each branch so that proposed changes
could be verified before an authorized person merges these changes into `master`.

### push

Run the action with the 'push' arugment to publish the changes to the specified
DNS providers.

Running the action with the 'push' argument will publish the changes with the
specified DNS providers. The example workflow depicted below contains a filtering
pattern so that it only runs on the `master` branch.

```yaml
name: Push

on:
  push:
    branches:
      - master

jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master

      - name: DNSControl push
        uses: koenrh/dnscontrol-action@v2.11
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
        with:
          args: push
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
    "apitoken": "$CLOUDFLARE_API_TOKEN"
  }
}
```
