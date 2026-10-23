# claude-sandbox

Run Claude Code in a sandbox microVM

## Before first use: set your git identity

The image sets it's own git identity via config file. Add one to [image/etc/gitconfig](image/etc/gitconfig), then rebuild:

```ini
[user]
	useConfigOnly = true
	name =
	email =
```

## Build image

```bash
docker build --tag claude-code-msb:latest .
```

## Add image to msb

```bash
docker save claude-code-msb:latest | msb load
```

## Update image

```bash
msb image rm claude-code-msb:latest && docker save claude-code-msb:latest | msb load
```

# VS Code usage

msb ssh authorize --file ~/.ssh/id_rsa.pub && msb ssh serve claude-sandbox

msb run --cpus 4 --memory 8G --net public --detach --mount-named "claude-home:/home/node:kind=dir,quota=4G" claude-code-msb:latest --name claude-sandbox

ssh claude-sandbox

## Update SSH config ~/.ssh/config

```
Host claude-sandbox
  HostName 127.0.0.1
  Port 2222
  User root
  IdentityFile ~/.ssh/id_rsa.pub
  IdentitiesOnly yes
```

docker run --rm claude-code-msb:latest -- bash