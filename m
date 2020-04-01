Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2319B02F
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733304AbgDAQYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733201AbgDAQYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:24:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC6220857;
        Wed,  1 Apr 2020 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758292;
        bh=7SxuKIfH55uX0c1mTHeJzI7WLiEtbefxc5ksxf5c8mQ=;
        h=From:To:Cc:Subject:Date:From;
        b=biYi9fChswVCqmthk6t3+V6t5WrTYTSEqr3hLe5ErH/hC+0P1r4dxkJoBkyjQv4a/
         CwmAZtxWhO/BQcIjzXZELVbB15nY536EwdLdiGnzTMsi9ewtJYn4AgGjrUS49PGCbr
         EJSo2pBC7CQI+FIl2UVfzfFeZxKB10JZYYiQo+3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/116] 4.19.114-rc1 review
Date:   Wed,  1 Apr 2020 18:16:16 +0200
Message-Id: <20200401161542.669484650@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.114-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.114-rc1
X-KernelTest-Deadline: 2020-04-03T16:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.114 release.
There are 116 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.114-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.114-rc1

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Madalin Bucur <madalin.bucur@oss.nxp.com>
    arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id

Arthur Demchenkov <spinal.by@gmail.com>
    ARM: dts: N900: fix onenand timings

Marco Felsch <m.felsch@pengutronix.de>
    ARM: dts: imx6: phycore-som: fix arm and soc minimum voltage

Nick Hudson <skrll@netbsd.org>
    ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Sungbo Eo <mans0n@gorani.run>
    ARM: dts: oxnas: Fix clear-mask property

disconnect3d <dominik.b.czarnota@gmail.com>
    perf map: Fix off by one in strncpy() size argument

Ilie Halip <ilie.halip@gmail.com>
    arm64: alternative: fix build with clang integrated assembler

Marek Vasut <marex@denx.de>
    net: ks8851-ml: Fix IO operations, again

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP288 model

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset some bpf info structures declared on the stack

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bpf: Explicitly memset the bpf_attr structure

Georg Müller <georgmueller@gmx.net>
    platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix use-after-free in vt_in_use()

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console

Eric Biggers <ebiggers@google.com>
    vt: vt_ioctl: remove unnecessary console allocation checks

Jiri Slaby <jslaby@suse.cz>
    vt: switch vt_dont_switch to bool

Jiri Slaby <jslaby@suse.cz>
    vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines

Jiri Slaby <jslaby@suse.cz>
    vt: selection, introduce vc_is_sel

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix authentication with iwlwifi/mvm

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Johan Hovold <johan@kernel.org>
    media: xirlink_cit: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: stv06xx: add missing descriptor sanity checks

Johan Hovold <johan@kernel.org>
    media: dib0700: fix rc endpoint lookup

Johan Hovold <johan@kernel.org>
    media: ov519: add missing endpoint sanity checks

Eric Biggers <ebiggers@google.com>
    libfs: fix infoleak in simple_attr_read()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ahci: Add Intel Comet Lake H RAID PCI ID

Qiujun Huang <hqjagain@gmail.com>
    staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Qiujun Huang <hqjagain@gmail.com>
    staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Johan Hovold <johan@kernel.org>
    media: usbtv: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix endpoint sanity check

Mans Rullgard <mans@mansr.com>
    usb: musb: fix crash with highmen PIO and usbmon

Qiujun Huang <hqjagain@gmail.com>
    USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback

Matthias Reichl <hias@horus.com>
    USB: cdc-acm: restore capability check order

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add Wistron Neweb D19Q1

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add BroadMobi BM806U

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add support for ASKEY WWHC050

Johannes Berg <johannes.berg@intel.com>
    mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX

Rajkumar Manoharan <rmanohar@codeaurora.org>
    mac80211: add option for setting control flags

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "r8169: check that Realtek PHY driver module is loaded"

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    vti6: Fix memory leak of skb if input policy check fails

Yoshiki Komachi <komachi.yoshiki@gmail.com>
    bpf/btf: Fix BTF verification of enum members in struct/union

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_fwd_netdev: validate family and chain type

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

David Howells <dhowells@redhat.com>
    afs: Fix some tracing details

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix doulbe free in xfrm_policy_timer

Xin Long <lucien.xin@gmail.com>
    xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

Xin Long <lucien.xin@gmail.com>
    xfrm: fix uctx len check in verify_sec_ctx_len

Maor Gottlieb <maorg@mellanox.com>
    RDMA/mlx5: Block delay drop to unprivileged users

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect() in XinY cases

Raed Salem <raeds@mellanox.com>
    xfrm: handle NETDEV_UNREGISTER for xfrm device

Edward Cree <ecree@solarflare.com>
    genirq: Fix reference leaks on irq affinity notifiers

Mike Marciniszyn <mike.marciniszyn@intel.com>
    RDMA/core: Ensure security pkey modify is not lost

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP288 model

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark station unauthorized before key removal

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Fix optimal I/O size for devices that change reported values

Dirk Mueller <dmueller@suse.com>
    scripts/dtc: Remove redundant YYLOC global declaration

Masami Hiramatsu <mhiramat@kernel.org>
    tools: Let O= makes handle a relative path with -C option

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not depend on dwfl_module_addrsym()

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Add bus_dma_limit for L3 bus

Roger Quadros <rogerq@ti.com>
    ARM: dts: dra7: Add bus_dma_limit for L3 bus

Ilya Dryomov <idryomov@gmail.com>
    ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL

Eugene Syromiatnikov <esyr@redhat.com>
    Input: avoid BIT() macro usage in the serio.h UAPI header

Yussuf Khalil <dev@pp3345.net>
    Input: synaptics - enable RMI on HP Envy 13-ad105ng

Dan Carpenter <dan.carpenter@oracle.com>
    Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

Chuhong Yuan <hslester96@gmail.com>
    i2c: hix5hd2: add missed clk_disable_unprepare in remove

Jiri Kosina <jkosina@suse.cz>
    ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()

Dominik Czarnota <dominik.b.czarnota@gmail.com>
    sxgbe: Fix off by one in samsung driver strncpy size arg

Nathan Chancellor <natechancellor@gmail.com>
    dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Wen Xiong <wenxiong@linux.vnet.ibm.com>
    scsi: ipr: Fix softlockup when rescanning devices in petitboot

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: handle error when backing RX buffer

Madalin Bucur <madalin.bucur@nxp.com>
    fsl/fman: detect FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    arm64: dts: ls1043a: FMan erratum A050385

Madalin Bucur <madalin.bucur@nxp.com>
    dt-bindings: net: FMan erratum A050385

Tycho Andersen <tycho@tycho.ws>
    cgroup1: don't call release_agent when it is ""

Dajun Jin <adajunjin@gmail.com>
    drivers/of/of_mdio.c:fix of_mdiobus_register()

Mike Gilbert <floppym@gentoo.org>
    cpupower: avoid multiple definition with gcc -fno-common

Scott Mayhew <smayhew@redhat.com>
    nfs: add minor version to nfs_server_key for fscache

Vasily Averin <vvs@virtuozzo.com>
    cgroup-v1: cgroup_pidlist_next should update position index

Taehee Yoo <ap420073@gmail.com>
    hsr: set .netnsok flag

Taehee Yoo <ap420073@gmail.com>
    hsr: add restart routine into hsr_get_node_list()

Taehee Yoo <ap420073@gmail.com>
    hsr: use rcu_read_lock() in hsr_get_node_{list/status}()

Taehee Yoo <ap420073@gmail.com>
    vxlan: check return value of gro_cells_init()

Eric Dumazet <edumazet@google.com>
    tcp: repair: fix TCP_QUEUE_SEQ implementation

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: re-enable MSI on RTL8168c

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value

René van Dorst <opensource@vdorst.com>
    net: dsa: mt7530: Change the LINK bit to reflect the link status

Petr Machata <petrm@mellanox.com>
    net: ip_gre: Accept IFLA_INFO_DATA-less configuration

Petr Machata <petrm@mellanox.com>
    net: ip_gre: Separate ERSPAN newlink / changelink callbacks

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Reset rings if ring reservation fails during open()

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Oliver Hartkopp <socketcan@hartkopp.net>
    slcan: not call free_netdev before rtnl_unlock in slcan_open

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

Emil Renner Berthing <kernel@esmil.dk>
    net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: keep alloc_hash updated after hash allocation

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: cls_route: remove the right filter from hashtable

Pawel Dembicki <paweldembicki@gmail.com>
    net: qmi_wwan: add support for ASKEY WWHC050

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: avoid a producer race condition

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: mvneta: Fix the case where the last poll did not process all rx

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Fix duplicate frames flooded by learning

Zh-yuan Ye <ye.zh-yuan@socionext.com>
    net: cbs: Fix software cbs to consider packet sending time

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_mr: Fix list iteration in error path

Willem de Bruijn <willemb@google.com>
    macsec: restrict to ethernet devices

Taehee Yoo <ap420073@gmail.com>
    hsr: fix general protection fault in hsr_addr_is_self()

Florian Westphal <fw@strlen.de>
    geneve: move debug check after netdev unregister

Lyude Paul <lyude@redhat.com>
    Revert "drm/dp_mst: Skip validating ports during destruction, just ref"

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Allow host controllers to require R1B for CMD6


-------------

Diffstat:

 Documentation/devicetree/bindings/net/fsl-fman.txt |   7 ++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |   1 +
 arch/arm/boot/dts/dra7.dtsi                        |   1 +
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi  |   4 +-
 arch/arm/boot/dts/omap3-n900.dts                   |  44 ++++---
 arch/arm/boot/dts/omap5.dtsi                       |   1 +
 arch/arm/boot/dts/ox810se.dtsi                     |   4 +-
 arch/arm/boot/dts/ox820.dtsi                       |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |   2 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts  |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts  |   4 +-
 arch/arm64/include/asm/alternative.h               |   2 +-
 arch/x86/kernel/ftrace.c                           |   2 +
 drivers/ata/ahci.c                                 |   1 +
 drivers/gpio/gpiolib-acpi.c                        | 140 +++++++++++++++++----
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 +--
 drivers/i2c/busses/i2c-hix5hd2.c                   |   1 +
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/raydium_i2c_ts.c         |   8 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   6 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   4 +-
 drivers/media/usb/gspca/ov519.c                    |  10 ++
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |  19 ++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |   4 +
 drivers/media/usb/gspca/xirlink_cit.c              |  18 ++-
 drivers/media/usb/usbtv/usbtv-core.c               |   2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   5 +-
 drivers/mmc/core/core.c                            |   5 +-
 drivers/mmc/core/mmc.c                             |   7 +-
 drivers/mmc/core/mmc_ops.c                         |   8 +-
 drivers/mmc/host/sdhci-omap.c                      |   3 +
 drivers/mmc/host/sdhci-tegra.c                     |   3 +
 drivers/net/can/slcan.c                            |   3 +
 drivers/net/dsa/mt7530.c                           |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |  15 ++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   4 +-
 drivers/net/ethernet/freescale/fman/Kconfig        |  28 +++++
 drivers/net/ethernet/freescale/fman/fman.c         |  18 +++
 drivers/net/ethernet/freescale/fman/fman.h         |   5 +
 drivers/net/ethernet/marvell/mvneta.c              |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   8 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |  56 ++++++++-
 drivers/net/ethernet/realtek/r8169.c               |  11 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   2 +-
 drivers/net/geneve.c                               |   8 +-
 drivers/net/macsec.c                               |   3 +
 drivers/net/phy/mdio-mux-bcm-iproc.c               |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan.c                                |  11 +-
 drivers/nfc/fdp/fdp.c                              |   5 +-
 drivers/of/of_mdio.c                               |   1 +
 drivers/platform/x86/pmc_atom.c                    |   8 ++
 drivers/s390/net/qeth_core_main.c                  |  13 +-
 drivers/scsi/ipr.c                                 |   3 +-
 drivers/scsi/ipr.h                                 |   1 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |   2 +
 drivers/staging/wlan-ng/prism2usb.c                |   1 +
 drivers/tty/vt/selection.c                         |   5 +
 drivers/tty/vt/vt.c                                |  30 ++++-
 drivers/tty/vt/vt_ioctl.c                          |  80 ++++++------
 drivers/usb/class/cdc-acm.c                        |  18 +--
 drivers/usb/musb/musb_host.c                       |  17 +--
 drivers/usb/serial/io_edgeport.c                   |   2 +-
 drivers/usb/serial/option.c                        |   6 +
 fs/afs/rxrpc.c                                     |   4 +-
 fs/ceph/file.c                                     |  14 ++-
 fs/libfs.c                                         |   8 +-
 fs/nfs/client.c                                    |   1 +
 fs/nfs/fscache.c                                   |   2 +
 fs/nfs/nfs4client.c                                |   1 -
 include/linux/ceph/osdmap.h                        |   4 +
 include/linux/ceph/rados.h                         |   6 +-
 include/linux/mmc/host.h                           |   1 +
 include/linux/selection.h                          |   4 +-
 include/linux/vt_kern.h                            |   2 +-
 include/trace/events/afs.h                         |   2 +-
 include/uapi/linux/serio.h                         |  10 +-
 kernel/bpf/btf.c                                   |   5 +-
 kernel/bpf/syscall.c                               |   9 +-
 kernel/cgroup/cgroup-v1.c                          |   3 +-
 kernel/irq/manage.c                                |  11 +-
 net/ceph/osdmap.c                                  |   9 ++
 net/dsa/tag_brcm.c                                 |   2 +
 net/hsr/hsr_framereg.c                             |  10 +-
 net/hsr/hsr_netlink.c                              |  74 ++++++-----
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/Kconfig                                   |   1 +
 net/ipv4/ip_gre.c                                  | 105 +++++++++++++---
 net/ipv4/ip_vti.c                                  |  38 ++++--
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv6/ip6_vti.c                                 |  34 +++--
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/mesh_hwmp.c                           |   3 +-
 net/mac80211/sta_info.c                            |   7 +-
 net/mac80211/tdls.c                                |   2 +-
 net/mac80211/tx.c                                  |  44 +++++--
 net/netfilter/nf_flow_table_ip.c                   |   2 +
 net/netfilter/nft_fwd_netdev.c                     |   9 ++
 net/packet/af_packet.c                             |  21 ++++
 net/packet/internal.h                              |   5 +-
 net/sched/cls_route.c                              |   4 +-
 net/sched/cls_tcindex.c                            |   1 +
 net/sched/sch_cbs.c                                |  12 +-
 net/wireless/nl80211.c                             |   2 +-
 net/xfrm/xfrm_device.c                             |   1 +
 net/xfrm/xfrm_policy.c                             |   2 +
 net/xfrm/xfrm_user.c                               |   6 +-
 scripts/dtc/dtc-lexer.l                            |   1 -
 tools/perf/Makefile                                |   2 +-
 tools/perf/util/map.c                              |   2 +-
 tools/perf/util/probe-finder.c                     |  11 +-
 .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |   2 +-
 .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |   2 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |   2 +
 .../cpupower/utils/idle_monitor/cpupower-monitor.h |   2 +-
 tools/scripts/Makefile.include                     |   4 +-
 123 files changed, 929 insertions(+), 342 deletions(-)


