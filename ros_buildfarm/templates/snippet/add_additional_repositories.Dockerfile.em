@[if os_name == 'ubuntu']@
@{
from itertools import product
}@
@[  if arch in ['amd64', 'i386']]@
@{
archive_commands = []
old_releases_commands = []
for distribution, archive_type in product((os_code_name, os_code_name + '-updates', os_code_name + '-security'), ('deb', 'deb-src')):
    archive_entry = '%s http://archive.ubuntu.com/ubuntu/ %s multiverse' % (archive_type, distribution)
    archive_pattern = '%s http://archive\.ubuntu\.com/ubuntu/? %s ([-a-z]+ )*multiverse( [-a-z])*' % (archive_type, distribution)
    old_releases_entry = '%s http://old-releases.ubuntu.com/ubuntu/ %s multiverse' % (archive_type, distribution)
    old_releases_pattern = '%s http://old-releases\.ubuntu\.com/ubuntu/? %s ([-a-z]+ )*multiverse( [-a-z]+)*' % (archive_type, distribution)
    archive_commands.append('(grep -q -E -x -e "%s" /etc/apt/sources.list || echo "%s" >> /etc/apt/sources.list)' % (archive_pattern, archive_entry))
    old_releases_commands.append('(grep -q -E -x -e "%s" /etc/apt/sources.list || echo "%s" >> /etc/apt/sources.list)' % (old_releases_pattern, old_releases_entry))
}@
RUN grep -q -F -e "deb http://old-releases.ubuntu.com" /etc/apt/sources.list && (@(' && '.join(old_releases_commands))) || (@(' && '.join(archive_commands)))
RUN RUN echo "Package: *
Pin: origin repo.ros2.org
Pin-Priority: 400" > /etc/apt/preferences.d/ros2-building
RUN echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQINBFzvJpYBEADY8l1YvO7iYW5gUESyzsTGnMvVUmlV3XarBaJz9bGRmgPXh7jc
VFrQhE0L/HV7LOfoLI9H2GWYyHBqN5ERBlcA8XxG3ZvX7t9nAZPQT2Xxe3GT3tro
u5oCR+SyHN9xPnUwDuqUSvJ2eqMYb9B/Hph3OmtjG30jSNq9kOF5bBTk1hOTGPH4
K/AY0jzT6OpHfXU6ytlFsI47ZKsnTUhipGsKucQ1CXlyirndZ3V3k70YaooZ55rG
aIoAWlx2H0J7sAHmqS29N9jV9mo135d+d+TdLBXI0PXtiHzE9IPaX+ctdSUrPnp+
TwR99lxglpIG6hLuvOMAaxiqFBB/Jf3XJ8OBakfS6nHrWH2WqQxRbiITl0irkQoz
pwNEF2Bv0+Jvs1UFEdVGz5a8xexQHst/RmKrtHLct3iOCvBNqoAQRbvWvBhPjO/p
V5cYeUljZ5wpHyFkaEViClaVWqa6PIsyLqmyjsruPCWlURLsQoQxABcL8bwxX7UT
hM6CtH6tGlYZ85RIzRifIm2oudzV5l+8oRgFr9yVcwyOFT6JCioqkwldW52P1pk/
/SnuexC6LYqqDuHUs5NnokzzpfS6QaWfTY5P5tz4KHJfsjDIktly3mKVfY0fSPVV
okdGpcUzvz2hq1fqjxB6MlB/1vtk0bImfcsoxBmF7H+4E9ZN1sX/tSb0KQARAQAB
tCZPcGVuIFJvYm90aWNzIDxpbmZvQG9zcmZvdW5kYXRpb24ub3JnPokCVAQTAQgA
PgIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBMHPbjHmut6IaLFytPQu1vur
F8ZUBQJgsdhRBQkLTMW7AAoJEPQu1vurF8ZUTMwP/3f7EkOPIFjUdRmpNJ2db4iB
RQu5b2SJRG+KIdbvQBzKUBMV6/RUhEDPjhXZI3zDevzBewvAMKkqs2Q1cWo9WV7Z
PyTkvSyey/Tjn+PozcdvzkvrEjDMftIk8E1WzLGq7vnPLZ1q/b6Vq4H373Z+EDWa
DaDwW72CbCBLWAVtqff80CwlI2x8fYHKr3VBUnwcXNHR4+nRABfAWnaU4k+oTshC
Qucsd8vitNfsSXrKuKyz91IRHRPnJjx8UvGU4tRGfrHkw1505EZvgP02vXeRyWBR
fKiL1vGy4tCSRDdZO3ms2J2m08VPv65HsHaWYMnO+rNJmMZj9d9JdL/9GRf5F6U0
quoIFL39BhUEvBynuqlrqistnyOhw8W/IQy/ymNzBMcMz6rcMjMwhkgm/LNXoSD1
1OrJu4ktQwRhwvGVarnB8ihwjsTxZFylaLmFSfaA+OAlOqCLS1OkIVMzjW+Ul6A6
qjiCEUOsnlf4CGlhzNMZOx3low6ixzEqKOcfECpeIj80a2fBDmWkcAAjlHu6VBhA
TUDG9e2xKLzV2Z/DLYsb3+n9QW7KO0yZKfiuUo6AYboAioQKn5jh3iRvjGh2Ujpo
22G+oae3PcCc7G+z12j6xIY709FQuA49dA2YpzMda0/OX4LP56STEveDRrO+CnV6
WE+F5FaIKwb72PL4rLi4
=i0tj
-----END PGP PUBLIC KEY BLOCK-----" | apt-key add -
@[  elif arch in ['armhf', 'armv8']]@
@{
commands = []
for distribution, archive_type in product((os_code_name, os_code_name + '-updates', os_code_name + '-security'), ('deb', 'deb-src')):
    entry = '%s http://ports.ubuntu.com/ %s multiverse' % (archive_type, distribution)
    pattern = '%s http://ports\.ubuntu\.com/? %s ([-a-z]+ )*multiverse( [-a-z])*' % (archive_type, distribution)
    commands.append('(grep -q -E -x -e "%s" /etc/apt/sources.list || echo "%s" >> /etc/apt/sources.list)' % (pattern, entry))
}@
RUN @(' && '.join(commands))
@[  end if]@
@[else if os_name == 'debian']@
# Add contrib and non-free to debian images
# Using httpredir here to match mirror used in osrf image
# (https://github.com/osrf/multiarch-docker-image-generation/blob/d251b9a/build-image.sh#L46)
@{
commands = []
for component in ('contrib', 'non-free'):
    entry = 'deb http://httpredir.debian.org/debian %s %s' % (os_code_name, component)
    pattern = 'deb http://httpredir\.debian\.org/debian/? %s ([-a-z] )*%s( [-a-z])*' % (os_code_name, component)
    commands.append('(grep -q -E -x -e "%s" /etc/apt/sources.list || echo "%s" >> /etc/apt/sources.list)' % (pattern, entry))
}@
RUN @(' && '.join(commands))
# Make sure to install apt-transport-https since some CloudFront mirrors are currently being redirected to https
RUN for i in 1 2 3; do apt-get update && apt-get install -q -y apt-transport-https && apt-get clean && break || if [ $i -lt 3 ]; then sleep 5; else false; fi; done
# Hit cloudfront mirror because of corrupted packages on fastly mirrors (https://github.com/ros-infrastructure/ros_buildfarm/issues/455)
# You can remove this line to target the default mirror or replace this to use the mirror of your preference
RUN sed -i 's/httpredir\.debian\.org/cloudfront.debian.net/' /etc/apt/sources.list
@[end if]@
