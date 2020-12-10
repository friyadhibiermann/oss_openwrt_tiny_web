# OSS SCRIPT V2
<ul>
<li>make sure install this package on linux OS</li>
<pre>
sudo apt-get update
sudo apt-get install git-core build-essential libssl-dev libncurses5-dev unzip gawk zlib1g-dev automake cmake gettext
</pre>
<li>compile SHC</li>
follow this link https://github.com/neurobin/shc
<li>create new user as root group</li>
<pre>
adduser openwrt
passwd openwrt
<strong>#input your secret password</strong>
<strong>#enter</strong>
visudo # user ass sudoer
openwrt ALL=(ALL:ALL) ALL
<strong># esc + :wq + enter <<-- to save configuration</strong>
su openwrt
<strong># enter your secret password</strong>
<strong># now successfull add user for compile openwrt package fdi</strong>
</pre>
<li>openwrt LEDE compile</li>
<a href="https://github.com/lede-project/source.git">https://github.com/lede-project/source.git</a>
<p>first follow this link :</p>
<p>see <a href="https://lede-project.org/docs/guide-developer/use-buildsystem">https://lede-project.org/docs/guide-developer/use-buildsystem</a></p>
<li>now aready to compile oss_openwrt_tiny_web</li>
<pre>
<strong># login as openwrt users</strong>
cd ~/source/package/
git clone https://github.com/friyadhibiermann/oss_openwrt_tiny_web.git
cd ~/source/
make defconfig
sed -i 's/# CONFIG_PACKAGE_fdi is not set/CONFIG_PACKAGE_fdi=y/g' .config
make defconfig
cd ~/source/ && make package/oss_openwrt_tiny_web/compile V=s
find -L bin -name "*oss*"
<strong>#DONE</strong>
</pre>
</ul>
<h3>NOTE:</h3><br>
<strong>change value CFLAGS on ~/source/package/oss_openwrt_tiny_web/src/Makefile to your cpu type CFLAGS</stong>
