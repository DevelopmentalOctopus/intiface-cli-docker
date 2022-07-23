# intiface-cli-docker

Docker Container for [intiface-cli](https://github.com/intiface/intiface-cli-rs).

Works in kubernetes too.

Be sure your host kernel has a bluetooth kernel module AND supports your bluetooth adapter.

Remember that you can't mount symlinks (from udevadm etc.)

# TODO
 - run as non-root
 - healthcheck
   - basic one actually makes intiface-cli crash.
