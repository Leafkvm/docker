ARG BASE_IMAGE=lazymio/leafkvm:base
FROM ${BASE_IMAGE}

ARG PLAYWRIGHT_VERSION=latest
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV CARGO_HOME=/opt/cargo
ENV RUSTUP_HOME=/opt/rustup
ENV N_PREFIX=/opt/n
ENV PATH=/opt/cargo/bin:/opt/n/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN set -eux; \
	apt-get update; \
	apt-get install -y direnv libncurses-dev ripgrep jq; \
	printf '\n%s\n' 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc; \
	rm -rf /var/lib/apt/lists/*;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path; \
	curl -fsSL https://bit.ly/n-install | N_PREFIX="$N_PREFIX" bash -s -- -y -n; \
	rustup default stable; \
	for tool in "$CARGO_HOME"/bin/* "$N_PREFIX"/bin/*; do \
		ln -sf "$tool" "/usr/local/bin/$(basename "$tool")"; \
	done

RUN set -eux; \
    npm install -g "playwright@${PLAYWRIGHT_VERSION}"; \
    ln -sf "$N_PREFIX/bin/playwright" /usr/local/bin/playwright; \
    playwright install --with-deps chromium; \
    chmod -R a+rX "$PLAYWRIGHT_BROWSERS_PATH"; \
    rm -rf /root/.npm /var/lib/apt/lists/*;

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 0755 /usr/local/bin/entrypoint.sh

WORKDIR /work

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["bash"]