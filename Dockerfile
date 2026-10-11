FROM node:26-trixie-slim@sha256:dc959319aa89ba9ab709c3e2d2ef8827e254284df2221856c58d78d32c45a913

# Packages installation
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        bash-completion \
        ca-certificates \
        curl \
        dnsutils \
        git \
        iptables \
        ipset \
        iproute2 \
        openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf bash /bin/sh

# Claude Code CLI
ARG CLAUDE_CODE_VERSION=2.1.296

RUN npm install --global --no-audit  --no-fund "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
    && claude --version && npm cache clean --force

RUN mkdir -p /workspace /home/node /home/claude-plugin-cache \
    && chown -R node:node \
        /workspace \
        /home/node \
        /home/claude-plugin-cache

# Runtime
ENV HOME=/home/node
ENV SHELL=/bin/bash
ENV PATH=/usr/local/bin:/usr/bin:/bin

USER node
WORKDIR /workspace

# Claude Code plugins
# marketplaces: repo URLs, e.g. https://github.com/owner/repo.git
# plugins: <plugin>@<marketplace>
RUN marketplaces=(); \
    plugins=(); \
    export CLAUDE_CODE_PLUGIN_CACHE_DIR=/home/claude-plugin-cache; \
    for marketplace in "${marketplaces[@]}"; do \
        claude plugin marketplace add "${marketplace}"; \
    done; \
    for plugin in "${plugins[@]}"; do \
        claude plugin install "${plugin}"; \
    done

ENV CLAUDE_CODE_PLUGIN_SEED_DIR=/home/claude-plugin-cache

CMD ["claude"]
