# fdi-openwrt-lede
<ul>
<li>make sure install this package on linux OS</li>
<pre>
sudo apt-get update
sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk zlib1g-dev automake cmake gettext shc
</pre>
<li>create new user as root group</li>
<pre>
adduser openwrt
passwd openwrt
#input your secret password>
#enter
visudo # user ass sudoer
openwrt ALL=(ALL:ALL) ALL
# esc + :wq + enter <<-- to save configuration
su openwrt
# enter your secret password
# now successfull add user for compile openwrt package fdi
</pre>
<li>openwrt LEDE compile</li>
<a href="https://github.com/lede-project/source.git">https://github.com/lede-project/source.git</a>
<p>first follow this link :</p>
<p>see <a href="https://lede-project.org/docs/guide-developer/use-buildsystem">https://lede-project.org/docs/guide-developer/use-buildsystem</a></p>
<li>now aready to compile fdi-lede package</li>
<pre>
# login as openwrt users
cd ~/source/package/
git clone https://github.com/friyadhibiermann/fdi-openwrt-lede.git
cd ~/source/
make defconfig
sed -i 's/# CONFIG_PACKAGE_fdi is not set/CONFIG_PACKAGE_fdi=y/g' .config
make defconfig
</pre>
</ul>
#NOTE:
<strong>change value CFLAGS on ~/source/package/fdi-openwrt-lede/src/Makefile to your cpu type CFLAGS</stong>
