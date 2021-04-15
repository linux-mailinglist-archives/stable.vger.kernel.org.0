Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA236360D23
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhDOO5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhDOOzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D084613C5;
        Thu, 15 Apr 2021 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498427;
        bh=t8Fyygk4351n9VS62Ko0Y8sdoTfGCH2bUvy+BoLpdZ0=;
        h=From:To:Cc:Subject:Date:From;
        b=XHtIQDrfhrPTYJ1VGo6cokFeBSyzNr4VrVNQ9a73m+MzW7aOD1VVQJypOux4kXRrp
         dvf/QU1wpxl4VigLqCEo5sKFeUKlvIo4/3FUrMwsVcS8h62IJjp17fvlH4nonxva8N
         UaM0odY6yATT080GyoQsbNYk4MnNDzb3Pyrb45Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/68] 4.14.231-rc1 review
Date:   Thu, 15 Apr 2021 16:46:41 +0200
Message-Id: <20210415144414.464797272@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.231-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.231-rc1
X-KernelTest-Deadline: 2021-04-17T14:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.231 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.231-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.231-rc1

Juergen Gross <jgross@suse.com>
    xen/events: fix setting irq affinity

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: fix compat match/target pad out-of-bound write

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Only advertise EEE for supported modes

Yufen Yu <yuyufen@huawei.com>
    block: only update parent bi_status when bio fail

Bob Peterson <rpeterso@redhat.com>
    gfs2: report "already frozen/thawed" errors

Arnd Bergmann <arnd@arndb.de>
    drm/imx: imx-ldb: fix out of bounds array access warning

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Disable guest access to trace filter controls

Suzuki K Poulose <suzuki.poulose@arm.com>
    KVM: arm64: Hide system instruction access to Trace registers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec params for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for set llsec params

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 add llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: nl-mac: fix check on panid

Pavel Skripkin <paskripkin@gmail.com>
    net: mac802154: Fix general protection fault

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in peak_usb_create_dev

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in atusb_probe

Phillip Potter <phil@philpotter.co.uk>
    net: tun: set tun->dev->addr_len during TUNSETLINK processing

Du Cheng <ducheng2@gmail.com>
    cfg80211: remove WARN_ON() in cfg80211_sme_connect

Shuah Khan <skhan@linuxfoundation.org>
    usbip: fix vudc usbip_sockfd_store races leading to gpf

Samuel Mendoza-Jonas <sam@mendozajonas.com>
    net/ncsi: Avoid GFP_KERNEL in response handler

Samuel Mendoza-Jonas <sam@mendozajonas.com>
    net/ncsi: Refactor MAC, VLAN filters

Samuel Mendoza-Jonas <sam@mendozajonas.com>
    net/ncsi: Add generic netlink family

Samuel Mendoza-Jonas <sam@mendozajonas.com>
    net/ncsi: Don't return error on normal response

Samuel Mendoza-Jonas <sam@mendozajonas.com>
    net/ncsi: Improve general state logging

Wei Yongjun <weiyongjun1@huawei.com>
    net/ncsi: Make local function ncsi_get_filter() static

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    clk: socfpga: fix iomem pointer cast on 64-bit

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: check for ipv6 address properly while destroying listener

Raed Salem <raeds@nvidia.com>
    net/mlx5: Fix placement of log_max_flow_counter

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpcmd: fix inline assembly register clobbering

Zqiang <qiang.zhang@windriver.com>
    workqueue: Move the position of debug_work_activate() in __queue_work()

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in unregister

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in register

Arnd Bergmann <arnd@arndb.de>
    soc/fsl: qbman: fix conflicting alignment attributes

Bastian Germann <bage@linutronix.de>
    ASoC: sunxi: sun4i-codec: fill ASoC card owner

Milton Miller <miltonm@us.ibm.com>
    net/ncsi: Avoid channel_monitor hrtimer deadlock

Stefan Riedmueller <s.riedmueller@phytec.de>
    ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:tipc: Fix a double free in tipc_sk_mcast_rcv

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Handle error code at MAC address change

Eric Dumazet <edumazet@google.com>
    sch_red: fix off-by-one checks in red_check_params()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    amd-xgbe: Update DMA coherency values

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips

Geert Uytterhoeven <geert+renesas@glider.be>
    regulator: bd9571mwv: Fix AVS and DVFS voltage range

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: turn recovery error on init to debug

Shuah Khan <skhan@linuxfoundation.org>
    usbip: synchronize event handler with sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: stub-dev synchronize sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: add sysfs_lock to synchronize sysfs code paths

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    net: sched: sch_teql: fix null-pointer dereference

Eric Dumazet <edumazet@google.com>
    net: ensure mac header is set in virtio_net_hdr_to_skb()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Marek Behún <kabel@kernel.org>
    ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Gao Xiang <hsiangkao@redhat.com>
    parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Helge Deller <deller@gmx.de>
    parisc: parisc-agp requires SBA IOMMU driver

Jack Qiu <jack.qiu@huawei.com>
    fs: direct-io: fix missing sdio->boundary

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: fix deadlock between setattr and dio_end_io_write

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix user_stack_pointer() for ptrace()

Muhammad Usama Anjum <musamaanjum@gmail.com>
    net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Luca Fancellu <luca.fancellu@arm.com>
    xen/evtchn: Change irq_info lock to raw_spinlock_t

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix memory leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_bind()

Hans de Goede <hdegoede@redhat.com>
    ASoC: intel: atom: Stop advertising non working S24LE support

Jonas Holmberg <jonashg@axis.com>
    ALSA: aloop: Fix initialization of controls


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts |   1 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi  |   2 +
 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/kernel/cpufeature.c                |   1 -
 arch/arm64/kvm/debug.c                        |   2 +
 arch/ia64/include/asm/ptrace.h                |   8 +-
 arch/parisc/include/asm/cmpxchg.h             |   2 +-
 arch/s390/kernel/cpcmd.c                      |   6 +-
 block/bio.c                                   |   2 +-
 drivers/char/agp/Kconfig                      |   2 +-
 drivers/clk/clk.c                             |  47 ++-
 drivers/clk/socfpga/clk-gate.c                |   2 +-
 drivers/gpu/drm/imx/imx-ldb.c                 |  10 +
 drivers/i2c/i2c-core-base.c                   |   7 +-
 drivers/infiniband/hw/cxgb4/cm.c              |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h          |   6 +-
 drivers/net/ethernet/freescale/gianfar.c      |   6 +-
 drivers/net/ieee802154/atusb.c                |   1 +
 drivers/net/phy/bcm-phy-lib.c                 |  11 +-
 drivers/net/tun.c                             |  48 +++
 drivers/regulator/bd9571mwv-regulator.c       |   4 +-
 drivers/soc/fsl/qbman/qman.c                  |   2 +-
 drivers/usb/usbip/stub_dev.c                  |  11 +-
 drivers/usb/usbip/usbip_common.h              |   3 +
 drivers/usb/usbip/usbip_event.c               |   2 +
 drivers/usb/usbip/vhci_hcd.c                  |   1 +
 drivers/usb/usbip/vhci_sysfs.c                |  30 +-
 drivers/usb/usbip/vudc_sysfs.c                |  42 ++-
 drivers/xen/events/events_base.c              |  14 +-
 drivers/xen/events/events_internal.h          |   2 +-
 fs/cifs/connect.c                             |   1 -
 fs/direct-io.c                                |   5 +-
 fs/gfs2/super.c                               |  10 +-
 fs/ocfs2/aops.c                               |  11 +-
 fs/ocfs2/file.c                               |   8 +-
 include/linux/mlx5/mlx5_ifc.h                 |   6 +-
 include/linux/virtio_net.h                    |   2 +
 include/net/red.h                             |   4 +-
 include/uapi/linux/ncsi.h                     | 115 +++++++
 kernel/workqueue.c                            |   2 +-
 net/batman-adv/translation-table.c            |   2 +
 net/ieee802154/nl-mac.c                       |   7 +-
 net/ieee802154/nl802154.c                     |  23 +-
 net/ipv4/netfilter/arp_tables.c               |   2 +
 net/ipv4/netfilter/ip_tables.c                |   2 +
 net/ipv6/netfilter/ip6_tables.c               |   2 +
 net/ipv6/route.c                              |   8 +-
 net/mac802154/llsec.c                         |   2 +-
 net/ncsi/Makefile                             |   2 +-
 net/ncsi/internal.h                           |  35 ++-
 net/ncsi/ncsi-aen.c                           |  15 +-
 net/ncsi/ncsi-manage.c                        | 342 +++++++++------------
 net/ncsi/ncsi-netlink.c                       | 415 ++++++++++++++++++++++++++
 net/ncsi/ncsi-netlink.h                       |  20 ++
 net/ncsi/ncsi-rsp.c                           | 215 ++++++-------
 net/netfilter/x_tables.c                      |  10 +-
 net/nfc/llcp_sock.c                           |  10 +
 net/sched/sch_teql.c                          |   3 +
 net/tipc/socket.c                             |   2 +-
 net/wireless/sme.c                            |   2 +-
 sound/drivers/aloop.c                         |  11 +-
 sound/soc/codecs/wm8960.c                     |   8 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c  |   6 +-
 sound/soc/sunxi/sun4i-codec.c                 |   5 +
 tools/perf/util/map.c                         |   7 +-
 67 files changed, 1132 insertions(+), 477 deletions(-)


