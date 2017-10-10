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
<a href="https://github.com/lede-project/source.git">https://github.com/lede-project/source.git</a> <br>
first follow this link to explain to do <br>
see <a href="https://lede-project.org/docs/guide-developer/use-buildsystem">https://lede-project.org/docs/guide-developer/use-buildsystem</a>
</ul>
