# Security Policy

## Supported versions

Security fixes are made against the default branch. Older tags are provided for reference and may not receive fixes.

## Reporting a vulnerability

Please do not disclose credentials, private keys, public server addresses, or a working exploit in a public issue. Open a private GitHub security advisory for this repository when available. If that option is unavailable, contact the repository owner through the email address listed on the GitHub profile and include:

- A short description of the issue and its impact.
- The affected file, command, or release.
- Safe reproduction steps with secrets and identifying data removed.
- A suggested mitigation, if known.

Please allow reasonable time for investigation and a coordinated fix before public disclosure.

## Security assumptions

This project configures a network service. Users are responsible for restricting TCP port 3389 at their cloud-provider and host firewalls, applying operating-system updates, and using strong non-root accounts. The installer intentionally does not open the firewall automatically.
