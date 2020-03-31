Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229E61999B7
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgCaPcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 11:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730464AbgCaPcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 11:32:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C2E20848;
        Tue, 31 Mar 2020 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585668727;
        bh=JpSRbR33AoPYM1rJPSTRxTXcpbqjvYPpLkaTKNcZyX8=;
        h=From:To:Cc:Subject:Date:From;
        b=BPxIznXsjKJUrqhETegLXDaasps4uamWKha1MTHfhvFInZQJ6fNdLhFjECsPNGKta
         /M0JC+3ZIMTHc53LgU8WuEUcCineaYO1Sw/xKZ7iGpSH7XBMDR+UuF92bov7VSH0nM
         A6Y8avjSS0qcJ4WP9TQvoCqEQtNGxskgmREmzPKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/156] 5.4.29-rc2 review
Date:   Tue, 31 Mar 2020 17:32:02 +0200
Message-Id: <20200331141448.508518662@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.29-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.29-rc2
X-KernelTest-Deadline: 2020-04-02T14:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.29 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Apr 2020 14:12:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.29-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.29-rc2

Pablo Neira Ayuso <pablo@netfilter.org>
    net: Fix CONFIG_NET_CLS_ACT=n and CONFIG_NFT_FWD_NETDEV={y, m} build

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: v4l2-core: fix a use-after-free bug of sd->devnode

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

Dan Carpenter <dan.carpenter@oracle.com>
    staging: kpc2000: prevent underflow in cpld_reconfigure()

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Undo incorrect __reg_bound_offset32 handling

Yubo Xie <yuboxie@microsoft.com>
    clocksource/drivers/hyper-v: Untangle stimers and timesync from clocksources

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix PHY driver check on platforms w/o module softdeps

Torsten Hilbrich <torsten.hilbrich@secunet.com>
    vti6: Fix memory leak of skb if input policy check fails

Ondrej Jirman <megous@megous.com>
    ARM: dts: sun8i-a83t-tbs-a711: Fix USB OTG mode detection

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free

Yoshiki Komachi <komachi.yoshiki@gmail.com>
    bpf/btf: Fix BTF verification of enum members in struct/union

Andrii Nakryiko <andriin@fb.com>
    bpf: Initialize storage pointers to NULL to prevent freeing garbage pointer

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x32: Fix bug with JMP32 JSET BPF_X checking upper bits

Kai-Heng Feng <kai.heng.feng@canonical.com>
    i2c: nvidia-gpu: Handle timeout correctly in gpu_i2c_check_status()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_fwd_netdev: validate family and chain type

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

Johannes Berg <johannes.berg@intel.com>
    mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX

Johannes Berg <johannes.berg@intel.com>
    ieee80211: fix HE SPR size calculation

David Howells <dhowells@redhat.com>
    afs: Fix unpinned address list during probing

David Howells <dhowells@redhat.com>
    afs: Fix some tracing details

David Howells <dhowells@redhat.com>
    afs: Fix client call Rx-phase signal handling

YueHaibing <yuehaibing@huawei.com>
    xfrm: policy: Fix doulbe free in xfrm_policy_timer

Xin Long <lucien.xin@gmail.com>
    xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

Xin Long <lucien.xin@gmail.com>
    xfrm: fix uctx len check in verify_sec_ctx_len

Maor Gottlieb <maorg@mellanox.com>
    RDMA/mlx5: Block delay drop to unprivileged users

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Fix access to wrong pointer while performing flush due to error

Mark Zhang <markz@mellanox.com>
    RDMA/mlx5: Fix the number of hwcounters of a dynamic counter

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect() in XinY cases

Raed Salem <raeds@mellanox.com>
    xfrm: handle NETDEV_UNREGISTER for xfrm device

Edward Cree <ecree@solarflare.com>
    genirq: Fix reference leaks on irq affinity notifiers

David Howells <dhowells@redhat.com>
    afs: Fix handling of an abort from a service handler

Mike Marciniszyn <mike.marciniszyn@intel.com>
    RDMA/core: Ensure security pkey modify is not lost

Andrii Nakryiko <andriin@fb.com>
    bpf: Fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP288 model

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk

Roman Gushchin <guro@fb.com>
    mm: fork: fix kernel_stack memcg stats for various stack implementations

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/sparse: fix kernel crash with pfn_section_valid check

David Hildenbrand <david@redhat.com>
    drivers/base/memory.c: indicate all memory blocks as removable

Naohiro Aota <naohiro.aota@wdc.com>
    mm/swapfile.c: move inode_lock out of claim_swapfile

Johannes Berg <johannes.berg@intel.com>
    mac80211: mark station unauthorized before key removal

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop data frames without key on encrypted links

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Fix optimal I/O size for devices that change reported values

Dirk Mueller <dmueller@suse.com>
    scripts/dtc: Remove redundant YYLOC global declaration

Masami Hiramatsu <mhiramat@kernel.org>
    tools: Let O= makes handle a relative path with -C option

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Do not depend on dwfl_module_addrsym()

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to delete multiple probe event

Borislav Petkov <bp@suse.de>
    x86/ioremap: Fix CONFIG_EFI=n build

Roger Quadros <rogerq@ti.com>
    ARM: dts: omap5: Add bus_dma_limit for L3 bus

Roger Quadros <rogerq@ti.com>
    ARM: dts: dra7: Add bus_dma_limit for L3 bus

Luis Henriques <lhenriques@suse.com>
    ceph: fix memory leak in ceph_cleanup_snapid_map()

Ilya Dryomov <idryomov@gmail.com>
    ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mad: Do not crash if the rdma device does not have a umad interface

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/nl: Do not permit empty devices names during RDMA_NLDEV_CMD_NEWLINK/SET

Linus Walleij <linus.walleij@linaro.org>
    gpiolib: Fix irq_disable() semantics

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Fix missing error check on dev_set_name()

Kaike Wan <kaike.wan@intel.com>
    IB/rdmavt: Free kernel completion queue when done

Eugene Syromiatnikov <esyr@redhat.com>
    Input: avoid BIT() macro usage in the serio.h UAPI header

Yussuf Khalil <dev@pp3345.net>
    Input: synaptics - enable RMI on HP Envy 13-ad105ng

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: fix stale timestamp on key autorepeat events

Dan Carpenter <dan.carpenter@oracle.com>
    Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

Chuhong Yuan <hslester96@gmail.com>
    i2c: hix5hd2: add missed clk_disable_unprepare in remove

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix non-ACPI function

Megha Dey <megha.dey@linux.intel.com>
    iommu/vt-d: Populate debugfs if IOMMUs are detected

Megha Dey <megha.dey@linux.intel.com>
    iommu/vt-d: Fix debugfs register reads

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix "tc qdisc del" failed issue

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

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: don't reset default_out_queue

Qian Cai <cai@lca.pw>
    iommu/vt-d: Silence RCU-list debugging warnings

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: Fix cleanup of IOMMU related objects

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: correct ROM_INDEX/DATA offset for VEGA20

Martin Leung <martin.leung@amd.com>
    drm/amd/display: update soc bb for nv14

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

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Do not recover from a non-fatal syndrome

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix ICOSQ recovery flow with Striding RQ

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Enhance ICOSQ WQE info fields

Hamdan Igbaria <hamdani@mellanox.com>
    net/mlx5: DR, Fix postsend actions write length

Taehee Yoo <ap420073@gmail.com>
    hsr: set .netnsok flag

Taehee Yoo <ap420073@gmail.com>
    hsr: add restart routine into hsr_get_node_list()

Taehee Yoo <ap420073@gmail.com>
    hsr: use rcu_read_lock() in hsr_get_node_{list/status}()

Petr Machata <petrm@mellanox.com>
    net: ip_gre: Accept IFLA_INFO_DATA-less configuration

Petr Machata <petrm@mellanox.com>
    net: ip_gre: Separate ERSPAN newlink / changelink callbacks

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Reset rings if ring reservation fails during open()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Free context memory after disabling PCI in probe error path.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.

Taehee Yoo <ap420073@gmail.com>
    vxlan: check return value of gro_cells_init()

Eric Dumazet <edumazet@google.com>
    tcp: repair: fix TCP_QUEUE_SEQ implementation

Eric Dumazet <edumazet@google.com>
    tcp: ensure skb->dev is NULL before leaving TCP stack

Florian Westphal <fw@strlen.de>
    tcp: also NULL skb->dev when copy was needed

Oliver Hartkopp <socketcan@hartkopp.net>
    slcan: not call free_netdev before rtnl_unlock in slcan_open

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: re-enable MSI on RTL8168c

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

Emil Renner Berthing <kernel@esmil.dk>
    net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: keep alloc_hash updated after hash allocation

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: hold rtnl lock in tcindex_partial_destroy_work()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: cls_route: remove the right filter from hashtable

Paul Blakey <paulb@mellanox.com>
    net/sched: act_ct: Fix leak of ct zone template on replace

Pawel Dembicki <paweldembicki@gmail.com>
    net: qmi_wwan: add support for ASKEY WWHC050

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value

Andre Przywara <andre.przywara@arm.com>
    net: phy: mdio-bcm-unimac: Fix clock handling

Grygorii Strashko <grygorii.strashko@ti.com>
    net: phy: dp83867: w/a for fld detect threshold bootstrapping issue

Willem de Bruijn <willemb@google.com>
    net/packet: tpacket_rcv: avoid a producer race condition

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: mvneta: Fix the case where the last poll did not process all rx

Guilherme G. Piccoli <gpiccoli@canonical.com>
    net: ena: Add PCI shutdown handler to allow safe kexec

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_pop

René van Dorst <opensource@vdorst.com>
    net: dsa: mt7530: Change the LINK bit to reflect the link status

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Fix duplicate frames flooded by learning

Zh-yuan Ye <ye.zh-yuan@socionext.com>
    net: cbs: Fix software cbs to consider packet sending time

Bruno Meneguele <bmeneg@redhat.com>
    net/bpfilter: fix dprintf usage for /dev/kmsg

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_mr: Fix list iteration in error path

Ido Schimmel <idosch@mellanox.com>
    mlxsw: pci: Only issue reset when system is ready

Willem de Bruijn <willemb@google.com>
    macsec: restrict to ethernet devices

Qian Cai <cai@lca.pw>
    ipv4: fix a RCU-list lock in inet_dump_fib()

Taehee Yoo <ap420073@gmail.com>
    hsr: fix general protection fault in hsr_addr_is_self()

Florian Westphal <fw@strlen.de>
    geneve: move debug check after netdev unregister

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix Txq restart check during backpressure

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix throughput drop during Tx backpressure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Rework ACPI events synchronization

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
 arch/arm/boot/dts/dra7.dtsi                        |   1 +
 arch/arm/boot/dts/omap5.dtsi                       |   1 +
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts          |   3 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |   2 +
 arch/x86/mm/ioremap.c                              |   3 +
 arch/x86/net/bpf_jit_comp32.c                      |  10 +-
 drivers/acpi/sleep.c                               |  26 +++--
 drivers/ata/ahci.c                                 |   1 +
 drivers/base/memory.c                              |  23 +---
 drivers/clocksource/hyperv_timer.c                 |   6 +-
 drivers/gpio/gpiolib-acpi.c                        | 125 ++++++++++++++++-----
 drivers/gpio/gpiolib.c                             |   9 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |  25 ++++-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  | 114 +++++++++++++++++++
 drivers/gpu/drm/exynos/exynos5433_drm_decon.c      |   5 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_dma.c            |  28 +++--
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   6 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   5 +-
 drivers/gpu/drm/exynos/exynos_drm_scaler.c         |   6 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |   7 +-
 drivers/i2c/busses/i2c-hix5hd2.c                   |   1 +
 drivers/i2c/busses/i2c-nvidia-gpu.c                |  20 ++--
 drivers/infiniband/core/device.c                   |   4 +-
 drivers/infiniband/core/nldev.c                    |   6 +-
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/core/user_mad.c                 |  33 ++++--
 drivers/infiniband/hw/mlx5/cq.c                    |  27 ++++-
 drivers/infiniband/hw/mlx5/main.c                  |   5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
 drivers/infiniband/hw/mlx5/qp.c                    |   5 +
 drivers/infiniband/sw/rdmavt/cq.c                  |   2 +-
 drivers/input/input.c                              |   1 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/raydium_i2c_ts.c         |   8 +-
 drivers/iommu/dmar.c                               |   3 +-
 drivers/iommu/intel-iommu-debugfs.c                |  51 ++++++---
 drivers/iommu/intel-iommu.c                        |   4 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   6 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   4 +-
 drivers/media/usb/gspca/ov519.c                    |  10 ++
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |  19 +++-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |   4 +
 drivers/media/usb/gspca/xirlink_cit.c              |  18 ++-
 drivers/media/usb/usbtv/usbtv-core.c               |   2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   5 +-
 drivers/media/v4l2-core/v4l2-device.c              |   1 +
 drivers/mmc/core/core.c                            |   5 +-
 drivers/mmc/core/mmc.c                             |   7 +-
 drivers/mmc/core/mmc_ops.c                         |   8 +-
 drivers/mmc/host/sdhci-omap.c                      |   3 +
 drivers/mmc/host/sdhci-tegra.c                     |   3 +
 drivers/net/Kconfig                                |   1 +
 drivers/net/can/slcan.c                            |   3 +
 drivers/net/dsa/mt7530.c                           |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  51 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  28 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |  15 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  52 ++-------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   4 +-
 drivers/net/ethernet/freescale/fman/Kconfig        |  28 +++++
 drivers/net/ethernet/freescale/fman/fman.c         |  18 +++
 drivers/net/ethernet/freescale/fman/fman.h         |   5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   3 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  31 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   1 +
 .../mellanox/mlx5/core/steering/dr_action.c        |   1 -
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  50 +++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  18 ++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   2 +-
 drivers/net/geneve.c                               |   8 +-
 drivers/net/ifb.c                                  |   6 +-
 drivers/net/macsec.c                               |   3 +
 drivers/net/phy/dp83867.c                          |  21 +++-
 drivers/net/phy/mdio-bcm-unimac.c                  |   6 +-
 drivers/net/phy/mdio-mux-bcm-iproc.c               |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan.c                                |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   1 +
 drivers/nfc/fdp/fdp.c                              |   5 +-
 drivers/of/of_mdio.c                               |   1 +
 drivers/s390/net/qeth_core_main.c                  |  14 ++-
 drivers/scsi/ipr.c                                 |   3 +-
 drivers/scsi/ipr.h                                 |   1 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/staging/kpc2000/kpc2000/core.c             |   4 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |   2 +
 drivers/staging/wlan-ng/prism2usb.c                |   1 +
 drivers/usb/class/cdc-acm.c                        |  18 +--
 drivers/usb/musb/musb_host.c                       |  17 +--
 drivers/usb/serial/io_edgeport.c                   |   2 +-
 drivers/usb/serial/option.c                        |   6 +
 fs/afs/cmservice.c                                 |  14 ++-
 fs/afs/fs_probe.c                                  |   2 +
 fs/afs/internal.h                                  |  12 +-
 fs/afs/rxrpc.c                                     |  71 ++----------
 fs/ceph/file.c                                     |  14 ++-
 fs/ceph/snap.c                                     |   1 +
 fs/libfs.c                                         |   8 +-
 fs/nfs/client.c                                    |   1 +
 fs/nfs/fscache.c                                   |   2 +
 fs/nfs/nfs4client.c                                |   1 -
 include/linux/ceph/osdmap.h                        |   4 +
 include/linux/ceph/rados.h                         |   6 +-
 include/linux/dmar.h                               |   6 +-
 include/linux/dsa/8021q.h                          |   7 --
 include/linux/ieee80211.h                          |   4 +-
 include/linux/intel-iommu.h                        |   2 +
 include/linux/memcontrol.h                         |  12 ++
 include/linux/mmc/host.h                           |   1 +
 include/linux/skbuff.h                             |  36 +++++-
 include/net/af_rxrpc.h                             |   4 +-
 include/net/sch_generic.h                          |  16 ---
 include/trace/events/afs.h                         |   2 +-
 include/uapi/linux/serio.h                         |  10 +-
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/cgroup.c                                |   7 +-
 kernel/bpf/verifier.c                              |  19 ----
 kernel/cgroup/cgroup-v1.c                          |   3 +-
 kernel/fork.c                                      |   4 +-
 kernel/irq/manage.c                                |  11 +-
 mm/memcontrol.c                                    |  38 +++++++
 mm/sparse.c                                        |   6 +
 mm/swapfile.c                                      |  39 ++++---
 net/Kconfig                                        |   3 +
 net/bpfilter/main.c                                |  14 ++-
 net/ceph/osdmap.c                                  |   9 ++
 net/core/dev.c                                     |   4 +-
 net/core/pktgen.c                                  |   2 +-
 net/core/sock_map.c                                |  12 +-
 net/dsa/tag_8021q.c                                |  43 -------
 net/dsa/tag_brcm.c                                 |   2 +
 net/dsa/tag_sja1105.c                              |  19 ++--
 net/hsr/hsr_framereg.c                             |   9 +-
 net/hsr/hsr_netlink.c                              |  70 +++++++-----
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/Kconfig                                   |   1 +
 net/ipv4/fib_frontend.c                            |   2 +
 net/ipv4/ip_gre.c                                  | 105 ++++++++++++++---
 net/ipv4/ip_vti.c                                  |  38 +++++--
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_output.c                              |  12 +-
 net/ipv6/ip6_vti.c                                 |  34 ++++--
 net/mac80211/debugfs_sta.c                         |   3 +-
 net/mac80211/key.c                                 |  20 ++--
 net/mac80211/mesh_hwmp.c                           |   3 +-
 net/mac80211/sta_info.c                            |   7 +-
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/tx.c                                  |  20 +++-
 net/netfilter/nf_flow_table_ip.c                   |   2 +
 net/netfilter/nft_fwd_netdev.c                     |  12 ++
 net/packet/af_packet.c                             |  21 ++++
 net/packet/internal.h                              |   5 +-
 net/rxrpc/af_rxrpc.c                               |  33 +-----
 net/rxrpc/ar-internal.h                            |   1 -
 net/rxrpc/input.c                                  |   1 -
 net/sched/act_ct.c                                 |   2 +-
 net/sched/act_mirred.c                             |   6 +-
 net/sched/cls_route.c                              |   4 +-
 net/sched/cls_tcindex.c                            |   3 +
 net/sched/sch_cbs.c                                |  12 +-
 net/wireless/nl80211.c                             |   2 +-
 net/xfrm/xfrm_device.c                             |   1 +
 net/xfrm/xfrm_policy.c                             |   2 +
 net/xfrm/xfrm_user.c                               |   6 +-
 scripts/dtc/dtc-lexer.l                            |   1 -
 tools/perf/Makefile                                |   2 +-
 tools/perf/util/probe-file.c                       |   3 +
 tools/perf/util/probe-finder.c                     |  11 +-
 .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |   2 +-
 .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |   2 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |   2 +
 .../cpupower/utils/idle_monitor/cpupower-monitor.h |   2 +-
 tools/scripts/Makefile.include                     |   4 +-
 193 files changed, 1464 insertions(+), 717 deletions(-)


