RUN mkdir /tmp/keys
@{
debian_before_stretch = ('squeeze', 'wheezy', 'jessie')
ubuntu_before_bionic = (
    'precise', 'quantal', 'raring', 'saucy',
    'trusty', 'utopic', 'vivid', 'wily',
    'xenial', 'yakkety', 'zesty', 'artful')
}@
@[if os_name == 'debian' and os_code_name not in debian_before_stretch or os_name == 'ubuntu' and os_code_name not in ubuntu_before_bionic]@
@# In Debian Stretch apt doesn't depend on gnupg anymore
@# https://anonscm.debian.org/cgit/apt/apt.git/commit/?id=87d468fe355c87325c943c40043a0bb236b2407f
RUN for i in 1 2 3; do apt-get update && apt-get install -q -y gnupg ca-certificates && apt-get clean && break || if [ $i -lt 3 ]; then sleep 5; else false; fi; done
@[end if]@
@[for i, key in enumerate(distribution_repository_keys)]@
RUN echo "@('\\n'.join(key.splitlines()))" > /tmp/keys/@(i).key@[if key] && apt-key add /tmp/keys/@(i).key@[end if]
@[end for]@
@[for i, url in enumerate(distribution_repository_urls)]@
RUN echo deb @[if not distribution_repository_keys[i]][trusted=yes] @[end if]@ @url @os_code_name main | tee -a /etc/apt/sources.list.d/buildfarm.list
@[if add_source and url == target_repository]@
RUN echo deb-src @[if not distribution_repository_keys[i]][trusted=yes] @[end if]@ @url @os_code_name main | tee -a /etc/apt/sources.list.d/buildfarm.list
@[end if]@
@[end for]@
@# On Ubuntu Trusty a newer version of dpkg is required to install Debian packages created by stdeb on newer distros
@[if os_name == 'ubuntu' and os_code_name == 'trusty']@
RUN for i in 1 2 3; do apt-get update && apt-get install -q -y dpkg && apt-get clean && break || if [ $i -lt 3 ]; then sleep 5; else false; fi; done
@[end if]@
