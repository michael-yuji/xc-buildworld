# xc-buildworld

This repo contains a "Jailfile" to build a container that runs `make buildworld` on a FreeBSD source tree.

To use this Jailfile, you will need [xc](https://github.com/michael-yuji/xc), you'll also need a FreeBSD base image as `freebsd:test`, the easiest way is to pull the test images from DockerHub.

For `amd64`:
```sh
# xc pull index.docker.io/freebsdxc/freebsd:test-amd64
```

For `aarch64`, a.k.a `arm64`:
```sh
# xc pull index.docker.io/freebsdxc/freebsd:test-aarch64
```

If you intend to use your own image instead of pulling from DockerHub, read [this section](#Alternative-base-image) first, and then come back.

Now you have the `freebsd:test` image, you can build the container with `xc`, you **WILL NEED INTERNET** access to build the container as it needs to pull packages. Read the `xc` documentation on how to configure your network.

```sh
# Assume I have a network called `network`, and build this image as `buildworld:test`
# xc build --network default buildworld:test
```

Now if everything completed well you are good to go, try to run the image:

```sh
# xc run --network default -e NCPU=2 -e BRANCH=releng/13.2 buildworld:test
```

## Alternative base image

If you want to use a custom FreeBSD base image instead, say a `base.txz` downloaded from [FreeBSD](https://download.freebsd.org) or the one you build yourself, you can import it directly, with a hand-crafted manifest file.

**PLEASE** note that `xc` **ONLY SUPPORT ZSTD, GZIP or UNCOMPRESSED TAR**. This is a limitation in the `OCI distribution` specification.

```
# make a .tar.zst from base.txz
xzcat base.txz | zstd -o base.tar.zst
```

You can also ask `xc` for a template and edit it yourself to save some keystrokes.

```sh
# xc template freebsd.json
```

The Json file, let's name it `freebsd.json`
```json
{
  "layers": [],
  "secure_level": 0,
  "vnet": false,
  "ports": {},
  "devfs_rules": [],
  "allow": [],
  "sysv_msg": "new",
  "sysv_shm": "new",
  "sysv_sem": "new",
  "envs": {},
  "entry_points": {
    "main": {
        "exec": "/bin/sh",
        "args": [],
        "default_args": [],
        "required_envs": [],
        "environ": {
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        }
    }
  },
  "init": [],
  "deinit": [],
  "linux": false,
  "special_mounts": [],
  "mounts": {}
}
```

Now you can run the import command.

```sh
xc import /path/to/the/base.tar.zst /path/to/that/freebsd.json freebsd:test
```
