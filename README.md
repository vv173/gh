
# GitHub CLI Docker Image

This repository maintains a Docker image for the GitHub CLI [gh](https://github.com/cli/cli), enabling users to interact with GitHub from within a Docker container. This Docker image facilitates seamless integration of GitHub workflows into Dockerized environments, making it easier for developers, DevOps teams, and automation workflows to leverage GitHub functionalities without needing to install the CLI on their systems directly.

## Quick Start

To pull the Docker image and start using the GitHub CLI, run:

```bash
docker pull v17v3/gh:latest
docker run -it v17v3/gh:latest
```

## Usage

### Basic Usage

You can use the GitHub CLI in a Docker container by running:

```bash
docker run -it v17v3/gh:latest <command>
```

For example, to list your repos:

```bash
docker run -it v17v3/gh:latest repo list
```

It can be useful to have a bash function to avoid typing the whole docker command:

```bash
gh() {
  docker run --rm -i -v "${PWD}":/workdir v17v3/gh:latest "$@"
}
```

### Authentication

To authenticate with GitHub using your Dockerized `gh` CLI:

1. Generate a personal access token (PAT) from GitHub with the appropriate scopes.
2. Run the container and pass your PAT:

```bash
docker run -it -e GH_TOKEN="<your-personal-access-token>" v17v3/gh:latest
```

## Building the Docker Image

To build this Docker image from source:

1. Clone this repository:

```bash
git clone https://github.com/vv173/gh.git
cd gh/
```

2. Build the image with:

```bash
docker buildx build --build-arg GH_CLI_VERSION=x.y.z --push -t gh:latest .
```

## Verifying Image Signatures

To ensure the integrity and authenticity of the Docker image, you can verify its signature using cosign. Here's how to do it:
```bash
cosign verify --key cosign.pub v17v3/gh:latest
```

## Contributing

Contributions to improve the Docker image or fix issues are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes with clear, descriptive messages.
4. Push your branch and submit a pull request against the main branch.

## License

This Docker image and its contents are released under the MIT License. See [LICENSE](LICENSE) for more details.
