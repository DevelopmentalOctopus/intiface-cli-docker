# intiface-cli-docker

Docker container for [intiface-engine](https://github.com/intiface/intiface-engine).

Built and pushed [here](https://hub.docker.com/r/containerizedoctopus/intiface-cli).

Works in kubernetes too.

Be sure your host kernel has a bluetooth kernel module AND supports your bluetooth adapter.

Remember that you can't mount symlinks (from udevadm etc.)

# TODO
 - run as non-root
 - healthcheck
   - basic one actually makes intiface-cli crash.
 - rename to reflect intiface-cli's replacement by intiface-engine.
