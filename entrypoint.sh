#!/bin/sh

set -eu

uid="${UID:-1000}"
gid="${GID:-1000}"
username="${USERNAME:-dev}"
groupname="${GROUPNAME:-$username}"

existing_group="$(getent group "$gid" | cut -d: -f1 || true)"
if [ -n "$existing_group" ]; then
    group_name="$existing_group"
elif getent group "$groupname" >/dev/null 2>&1; then
    groupmod -g "$gid" "$groupname"
    group_name="$groupname"
else
    groupadd -g "$gid" "$groupname"
    group_name="$groupname"
fi

existing_user="$(getent passwd "$uid" | cut -d: -f1 || true)"
if [ -n "$existing_user" ]; then
    user_name="$existing_user"
    usermod -g "$gid" -s /bin/bash "$user_name"
else
    if id -u "$username" >/dev/null 2>&1; then
        usermod -u "$uid" -g "$gid" -s /bin/bash "$username"
        user_name="$username"
    else
        useradd -m -u "$uid" -g "$group_name" -s /bin/bash "$username"
        user_name="$username"
    fi
fi

home_dir="$(getent passwd "$user_name" | cut -d: -f6)"

mkdir -p "$home_dir/.ssh" "$home_dir/br-dl" /work
chmod 700 "$home_dir/.ssh"
chown -R "$uid:$gid" "$home_dir" /work

echo "$user_name ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/99-sudo-nopasswd
chmod 0440 /etc/sudoers.d/99-sudo-nopasswd
usermod -aG sudo "$user_name"

export HOME="$home_dir"

if [ "$#" -eq 0 ]; then
    set -- bash
fi

exec sudo -EH -u "$user_name" -- env \
    HOME="$home_dir" \
    LANG="${LANG:-en_US.UTF-8}" \
    LANGUAGE="${LANGUAGE:-en_US:en}" \
    LC_ALL="${LC_ALL:-en_US.UTF-8}" \
    CARGO_HOME="${CARGO_HOME:-}" \
    RUSTUP_HOME="${RUSTUP_HOME:-}" \
    N_PREFIX="${N_PREFIX:-}" \
    PATH="$PATH" \
    "$@"