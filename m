Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C94734C6BB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhC2IJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhC2IIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2924461481;
        Mon, 29 Mar 2021 08:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005329;
        bh=59NoZhmpaNT+nMhh9SBMML2vtZx7jJ7+eJ5zubcDwrU=;
        h=From:To:Cc:Subject:Date:From;
        b=O7nDDuNmWuKw//1Ert4pKD6gCCjGdXbvoewmhnK+dmtl/XXVT1BkQyYagQfs6zHM/
         lz6pxUCXwory/eJ0qTF2xXUlgRI/WecuLFmU2y7MMhjQh7Q51NjFUj7SXI57rEaYPU
         iQJZhEIRI+BIrYqNhjLxEIPpiheA8ML4yBmW+g3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/72] 4.19.184-rc1 review
Date:   Mon, 29 Mar 2021 09:57:36 +0200
Message-Id: <20210329075610.300795746@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.184-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.184-rc1
X-KernelTest-Deadline: 2021-03-31T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.184 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.184-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.184-rc1

Marc Kleine-Budde <mkl@pengutronix.de>
    can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Jan Kara <jack@suse.cz>
    ext4: add reclaim checks to xattr code

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: fix double free in ibss_leave

Eric Dumazet <edumazet@google.com>
    net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Eric Dumazet <edumazet@google.com>
    net: sched: validate stab values

Martin Willi <martin@strongswan.org>
    can: dev: Move device back to init netns on owning netns delete

Isaku Yamahata <isaku.yamahata@intel.com>
    x86/mem_encrypt: Correct physical address calculation in __set_clr_pte_enc()

Thomas Gleixner <tglx@linutronix.de>
    locking/mutex: Fix non debug version of mutex_lock_io_nested()

Jia-Ju Bai <baijiaju1990@gmail.com>
    scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()

Jia-Ju Bai <baijiaju1990@gmail.com>
    scsi: qedi: Fix error return code of qedi_alloc_global_queues()

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix auxtrace queue conflict

JeongHyeon Lee <jhs2.lee@samsung.com>
    dm verity: add root hash pkcs#7 signature verification

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: scan: Use unique number for instance_no

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Rearrange memory allocation in acpi_device_add()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    Revert "netfilter: x_tables: Update remaining dereference to RCU"

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    netfilter: x_tables: Use correct memory barriers.

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    Revert "netfilter: x_tables: Switch synchronization to RCU"

Sasha Levin <sashal@kernel.org>
    bpf: Don't do bpf_cgroup_storage_set() for kuprobe/tp programs

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix error path for ethtool set-priv-flag

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: kdump: update ppos when reading elfcorehdr

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: fix shutdown hook in case GPU components failed to bind

Corentin Labbe <clabbe@baylibre.com>
    net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Johan Hovold <johan@kernel.org>
    net: cdc-phonet: fix data-interface release on probe failure

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix rate mask reset

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning

Tong Zhang <ztong0001@gmail.com>
    can: c_can: move runtime PM enable/disable to c_can_platform

Tong Zhang <ztong0001@gmail.com>
    can: c_can_pci: c_can_pci_remove(): fix use-after-free

Angelo Dureghello <angelo@kernel-space.org>
    can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: add forgotten supported devices

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix dump of the expect mask attribute

Dylan Hung <dylan_hung@aspeedtech.com>
    ftgmac100: Restart MAC HW once

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Dinghao Liu <dinghao.liu@zju.edu.cn>
    e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: add rtnl_lock() to e1000_reset_task

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port

Eric Dumazet <edumazet@google.com>
    macvlan: macvlan_count_rx() needs to be aware of preemption

Georgi Valkov <gvalkov@abv.bg>
    libbpf: Fix INSTALL flag order

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    veth: Store queue_mapping independently of XDP prog presence

Grygorii Strashko <grygorii.strashko@ti.com>
    bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix out of bounds array access when no devices

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91-sama5d27_som1: fix phy address to 7

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1043a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1012a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1046a: mark crypto engine dma coherent

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix xattr id and id lookup sanity checks

Sean Nyekjaer <sean@geanix.com>
    squashfs: fix inode lookup sanity checks

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Stop reporting SW_DOCK events

Mian Yousaf Kaukab <ykaukab@suse.de>
    netsec: restore phy power state after controller reset

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix ptrace(PTRACE_SYSCALL_INFO_EXIT) sign

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix ia64_syscall_get_set_arguments() for break-based syscalls

Daniel Wagner <dwagner@suse.de>
    block: Suppress uevent for hidden device when removed

J. Bruce Fields <bfields@redhat.com>
    nfs: we don't support removing system.nfs4_acl

Christian König <christian.koenig@amd.com>
    drm/radeon: fix AGP dependency

Peter Zijlstra <peterz@infradead.org>
    u64_stats,lockdep: Fix u64_stats_init() vs lockdep

Rob Gardner <rob.gardner@oracle.com>
    sparc64: Fix opcode filtering in handling of no fault loads

Tong Zhang <ztong0001@gmail.com>
    atm: idt77252: fix null-ptr-dereference

Tong Zhang <ztong0001@gmail.com>
    atm: uPD98402: fix incorrect allocation

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: wan: fix error return code of uhdlc_init()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()

Frank Sorenson <sorenson@redhat.com>
    NFS: Correct size calculation for create reply length

Timo Rothenpieler <timo@rothenpieler.org>
    nfs: fix PNFS_FLEXFILE_LAYOUT Kconfig default

Yang Li <yang.lee@linux.alibaba.com>
    gpiolib: acpi: Add missing IRQF_ONESHOT

Michael Braun <michael-dev@fami-braun.de>
    gianfar: fix jumbo packets+napi+rx overrun crash

Denis Efremov <efremov@linux.com>
    sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: tehuti: fix error return code in bdx_probe()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ixgbe: Fix memleak in ixgbe_configure_clsu32

Hayes Wang <hayeswang@realtek.com>
    Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"

Tong Zhang <ztong0001@gmail.com>
    atm: lanai: dont run lanai_dev_close if not open

Tong Zhang <ztong0001@gmail.com>
    atm: eni: dont release is never initialized

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/4xx: Fix build errors from mfdcr()

Heiko Thiery <heiko.thiery@gmail.com>
    net: fec: ptp: avoid register access when ipg clock is disabled


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi          |  4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi     |  1 +
 arch/arm64/boot/dts/freescale/fsl-ls1043a.dtsi     |  1 +
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |  1 +
 arch/arm64/kernel/crash_dump.c                     |  2 +
 arch/ia64/include/asm/syscall.h                    |  2 +-
 arch/ia64/kernel/ptrace.c                          | 24 ++++--
 arch/powerpc/include/asm/dcr-native.h              |  8 +-
 arch/sparc/kernel/traps_64.c                       | 13 ++--
 arch/x86/mm/mem_encrypt.c                          |  2 +-
 block/genhd.c                                      |  4 +-
 drivers/acpi/internal.h                            |  6 +-
 drivers/acpi/scan.c                                | 88 +++++++++++++---------
 drivers/atm/eni.c                                  |  3 +-
 drivers/atm/idt77105.c                             |  4 +-
 drivers/atm/lanai.c                                |  5 +-
 drivers/atm/uPD98402.c                             |  2 +-
 drivers/bus/omap_l3_noc.c                          |  4 +-
 drivers/gpio/gpiolib-acpi.c                        |  2 +-
 drivers/gpu/drm/Kconfig                            |  1 +
 drivers/gpu/drm/msm/msm_drv.c                      |  4 +
 drivers/infiniband/hw/cxgb4/cm.c                   |  4 +-
 drivers/md/dm-ioctl.c                              |  2 +-
 drivers/md/dm-verity-target.c                      |  2 +-
 drivers/net/can/c_can/c_can.c                      | 24 +-----
 drivers/net/can/c_can/c_can_pci.c                  |  3 +-
 drivers/net/can/c_can/c_can_platform.c             |  6 +-
 drivers/net/can/dev.c                              |  1 +
 drivers/net/can/flexcan.c                          |  8 +-
 drivers/net/can/m_can/m_can.c                      |  3 -
 drivers/net/dsa/bcm_sf2.c                          |  6 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  7 ++
 drivers/net/ethernet/freescale/gianfar.c           | 15 ++++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  4 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |  2 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  6 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |  3 +
 drivers/net/ethernet/socionext/netsec.c            |  9 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  2 +
 drivers/net/ethernet/sun/niu.c                     |  2 -
 drivers/net/ethernet/tehuti/tehuti.c               |  1 +
 drivers/net/usb/cdc-phonet.c                       |  2 +
 drivers/net/usb/r8152.c                            | 35 ++-------
 drivers/net/veth.c                                 |  3 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |  8 +-
 drivers/platform/x86/intel-vbtn.c                  | 12 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  8 +-
 drivers/scsi/qedi/qedi_main.c                      |  1 +
 fs/ext4/xattr.c                                    |  4 +
 fs/nfs/Kconfig                                     |  2 +-
 fs/nfs/nfs3xdr.c                                   |  3 +-
 fs/nfs/nfs4proc.c                                  |  3 +
 fs/squashfs/export.c                               |  8 +-
 fs/squashfs/id.c                                   |  6 +-
 fs/squashfs/squashfs_fs.h                          |  1 +
 fs/squashfs/xattr_id.c                             |  6 +-
 include/acpi/acpi_bus.h                            |  1 +
 include/linux/bpf.h                                |  9 ++-
 include/linux/if_macvlan.h                         |  3 +-
 include/linux/mutex.h                              |  2 +-
 include/linux/netfilter/x_tables.h                 |  7 +-
 include/linux/u64_stats_sync.h                     |  7 +-
 include/net/red.h                                  | 10 ++-
 include/net/rtnetlink.h                            |  2 +
 net/core/dev.c                                     |  2 +-
 net/ipv4/netfilter/arp_tables.c                    | 16 ++--
 net/ipv4/netfilter/ip_tables.c                     | 16 ++--
 net/ipv6/netfilter/ip6_tables.c                    | 16 ++--
 net/mac80211/cfg.c                                 |  4 +-
 net/mac80211/ibss.c                                |  2 +
 net/netfilter/nf_conntrack_netlink.c               |  1 +
 net/netfilter/x_tables.c                           | 49 ++++++++----
 net/qrtr/qrtr.c                                    |  5 ++
 net/sched/sch_choke.c                              |  7 +-
 net/sched/sch_gred.c                               |  2 +-
 net/sched/sch_red.c                                |  7 +-
 net/sched/sch_sfq.c                                |  2 +-
 tools/lib/bpf/Makefile                             |  2 +-
 tools/perf/util/auxtrace.c                         |  4 -
 83 files changed, 357 insertions(+), 229 deletions(-)


