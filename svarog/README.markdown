# 0.1 svarog 12/04/2013 #

Currently this simply installs the packages set on Enterprise Linux based systems.

Tested on:

 * Centos 6.4

# СentOS Support #

You need to have the repository enabled in order to install the svarog.

 * RPM's list is rpmlist.txt
 * for download RPM's use yumdownloader from yum-utils package

# What svarog does? #

svarog build RPM packages from any type of source code and publishes them to the predefined folder. The output format is YUM repository. If shared via HTTP the folder becomes ready-4-use as YUM repository by any YUM-enabled systems, especially RHEL/CentOS/Fedora.

svarog make the implementation of Continuous Delivery process very smooth and convenient. It resolves the problem of making the source code "travel" from SCM to environment.
