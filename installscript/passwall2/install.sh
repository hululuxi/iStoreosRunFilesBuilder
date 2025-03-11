pw2_ver=`ls |grep luci-app|awk -F'[_]' '{print $2}'`
pw2zh_ver=`ls |grep luci-i18n|awk -F'[_-]' '{print $6}'`
opkg update
if [ $? -ne 0 ]; then
    echo "更新软件源列表错误，请检查路由器自身网络连接以及是否有失效的软件源。"
    exit 1
fi
opkg install depends/*.ipk
opkg install haproxy shadowsocks-libev-config shadowsocks-libev-ss-local shadowsocks-libev-ss-redir shadowsocks-libev-ss-server
if opkg list-installed | grep -q 'luci-app-passwall2.*'$pw2_ver''; then
  echo "发现相同版本，正在执行强制重新安装passwall2 "$pw2_ver""
  opkg install luci-app-passwall2_"$pw2_ver"_all.ipk --force-reinstall
  opkg install luci-i18n-passwall2-zh-cn_"$pw2zh_ver"_all.ipk
else
  echo "正在安装passwall2 "$pw2_ver""
  opkg install luci-app-passwall2_"$pw2_ver"_all.ipk luci-i18n-passwall2-zh-cn_"$pw2zh_ver"_all.ipk
fi
