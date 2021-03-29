Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE434C73D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhC2INY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhC2IMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D966761477;
        Mon, 29 Mar 2021 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005552;
        bh=1/luxF030GAOqhtRRI31IIu/MXD1duuraY2cja9gpZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=gy10GJhJHsT2MBnKtlhjvNwElxgFopT9TYiV2+kG9lgXnVDGVgTr21uR8nUVevHoq
         j1+yUjob104pz+KAF5SCf35oQ8pnFKbH8s6pv98sFPXyI5/k7UfvA9pe/nwEe+HDpQ
         8G7ryayWK9S9hY3Vi7vE01CtfHyBs5CrBdApgGp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/111] 5.4.109-rc1 review
Date:   Mon, 29 Mar 2021 09:57:08 +0200
Message-Id: <20210329075615.186199980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.109-rc1
X-KernelTest-Deadline: 2021-03-31T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.109 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.109-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.109-rc1

Marc Kleine-Budde <mkl@pengutronix.de>
    can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Jan Kara <jack@suse.cz>
    ext4: add reclaim checks to xattr code

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: fix double free in ibss_leave

Eric Dumazet <edumazet@google.com>
    net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: VLAN filtering is global to all users

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

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "qla2xxx: Make sure that aborted commands are freed"

David Jeffery <djeffery@redhat.com>
    block: recalculate segment count for multi-segment discards correctly

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix auxtrace queue conflict

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

Lukasz Luba <lukasz.luba@arm.com>
    PM: EM: postpone creating the debugfs dir till fs_initcall

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix error path for ethtool set-priv-flag

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Defer suspending suppliers

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: kdump: update ppos when reading elfcorehdr

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: fix shutdown hook in case GPU components failed to bind

Jean-Philippe Brucker <jean-philippe@linaro.org>
    libbpf: Fix BTF dump of pointer-to-array-of-struct

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value

Corentin Labbe <clabbe@baylibre.com>
    net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes

Hayes Wang <hayeswang@realtek.com>
    r8152: limit the RX buffer size of RTL8153A for USB 2.0

Johan Hovold <johan@kernel.org>
    net: cdc-phonet: fix data-interface release on probe failure

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: fix infinite loop in unmapping NPC counter

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix irq free in rvu teardown

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Use SOCK_CLOEXEC when opening the netlink socket

Louis Peens <louis.peens@corigine.com>
    nfp: flower: fix pre_tun mask id allocation

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix rate mask reset

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors

Torin Cooper-Bennun <torin@maxiluxsystems.com>
    can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning

Tong Zhang <ztong0001@gmail.com>
    can: c_can: move runtime PM enable/disable to c_can_platform

Tong Zhang <ztong0001@gmail.com>
    can: c_can_pci: c_can_pci_remove(): fix use-after-free

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Always disable bus load reporting

Angelo Dureghello <angelo@kernel-space.org>
    can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: add forgotten supported devices

Alexander Ovechkin <ovov@yandex-team.ru>
    tcp: relookup sock for RST+ACK packets handled by obsolete req sock

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix dump of the expect mask attribute

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed

Dylan Hung <dylan_hung@aspeedtech.com>
    ftgmac100: Restart MAC HW once

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template

Dinghao Liu <dinghao.liu@zju.edu.cn>
    e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: add rtnl_lock() to e1000_reset_task

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Fix Supported Pause Frame Link Setting

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Fix Pause Frame Advertising

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port

Eric Dumazet <edumazet@google.com>
    net: sched: validate stab values

Eric Dumazet <edumazet@google.com>
    macvlan: macvlan_count_rx() needs to be aware of preemption

Wei Wang <weiwan@google.com>
    ipv6: fix suspecious RCU usage warning

Maor Dickman <maord@nvidia.com>
    net/mlx5e: Don't match on Geneve options in case option masks are all zero

Georgi Valkov <gvalkov@abv.bg>
    libbpf: Fix INSTALL flag order

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    veth: Store queue_mapping independently of XDP prog presence

Grygorii Strashko <grygorii.strashko@ti.com>
    bus: omap_l3_noc: mark l3 irqs as IRQF_NO_THREAD

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix out of bounds array access when no devices

JeongHyeon Lee <jhs2.lee@samsung.com>
    dm verity: fix DM_VERITY_OPTS_MAX value

Mimi Zohar <zohar@linux.ibm.com>
    integrity: double check iint_cache was initialized

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91-sama5d27_som1: fix phy address to 7

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1043a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1012a: mark crypto engine dma coherent

Horia Geantă <horia.geanta@nxp.com>
    arm64: dts: ls1046a: mark crypto engine dma coherent

Chris Chiu <chris.chiu@canonical.com>
    ACPI: video: Add missing callback back for Sony VPCEH3U1E

Nick Desaulniers <ndesaulniers@google.com>
    gcov: fix clang-11+ support

Andrey Konovalov <andreyknvl@google.com>
    kasan: fix per-page tags for non-page_alloc pages

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

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    nvme-pci: add the DISABLE_WRITE_ZEROES quirk for a Samsung PM1725a

Hannes Reinecke <hare@suse.de>
    nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted

Hannes Reinecke <hare@suse.de>
    nvme: add NVME_REQ_CANCELLED flag in nvme_cancel_request()

Christian König <christian.koenig@amd.com>
    drm/radeon: fix AGP dependency

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fb BO should be ttm_bo_type_device

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Revert dram_clock_change_latency for DCN2.1

satya priya <skakit@codeaurora.org>
    regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck

Peter Zijlstra <peterz@infradead.org>
    u64_stats,lockdep: Fix u64_stats_init() vs lockdep

Tomer Tayar <ttayar@habana.ai>
    habanalabs: Call put_pid() when releasing control device

Rob Gardner <rob.gardner@oracle.com>
    sparc64: Fix opcode filtering in handling of no fault loads

Paul Cercueil <paul@crapouillou.net>
    irqchip/ingenic: Add support for the JZ4760

Paulo Alcantara <pc@cjr.nz>
    cifs: change noisy error message to FYI

Tong Zhang <ztong0001@gmail.com>
    atm: idt77252: fix null-ptr-dereference

Tong Zhang <ztong0001@gmail.com>
    atm: uPD98402: fix incorrect allocation

Paul Cercueil <paul@crapouillou.net>
    net: davicom: Use platform_get_irq_optional()

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

Sudeep Holla <sudeep.holla@arm.com>
    cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev

Aurelien Aptel <aaptel@suse.com>
    cifs: ask for more credit on async read/write code paths

Michael Braun <michael-dev@fami-braun.de>
    gianfar: fix jumbo packets+napi+rx overrun crash

Denis Efremov <efremov@linux.com>
    sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: intel: iavf: fix error return code of iavf_init_get_resources()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: tehuti: fix error return code in bdx_probe()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ixgbe: Fix memleak in ixgbe_configure_clsu32

Mark Pearson <markpearson@lenovo.com>
    ALSA: hda: ignore invalid NHLT table

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

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: hugetlb_fault_mutex_hash() cleanup


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
 block/blk-merge.c                                  |  8 ++
 block/genhd.c                                      |  4 +-
 drivers/acpi/internal.h                            |  6 +-
 drivers/acpi/scan.c                                | 88 +++++++++++++---------
 drivers/acpi/video_detect.c                        |  1 +
 drivers/atm/eni.c                                  |  3 +-
 drivers/atm/idt77105.c                             |  4 +-
 drivers/atm/lanai.c                                |  5 +-
 drivers/atm/uPD98402.c                             |  2 +-
 drivers/base/power/runtime.c                       | 45 +++++++++--
 drivers/bus/omap_l3_noc.c                          |  4 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |  2 +
 drivers/gpio/gpiolib-acpi.c                        |  2 +-
 drivers/gpu/drm/Kconfig                            |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |  2 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  4 +
 drivers/infiniband/hw/cxgb4/cm.c                   |  4 +-
 drivers/irqchip/irq-ingenic-tcu.c                  |  1 +
 drivers/irqchip/irq-ingenic.c                      |  1 +
 drivers/md/dm-ioctl.c                              |  2 +-
 drivers/md/dm-verity-target.c                      |  2 +-
 drivers/misc/habanalabs/device.c                   |  2 +
 drivers/net/can/c_can/c_can.c                      | 24 +-----
 drivers/net/can/c_can/c_can_pci.c                  |  3 +-
 drivers/net/can/c_can/c_can_platform.c             |  6 +-
 drivers/net/can/dev.c                              |  1 +
 drivers/net/can/flexcan.c                          |  8 +-
 drivers/net/can/kvaser_pciefd.c                    |  4 +
 drivers/net/can/m_can/m_can.c                      |  5 +-
 drivers/net/dsa/b53/b53_common.c                   | 14 ++--
 drivers/net/dsa/bcm_sf2.c                          |  6 +-
 drivers/net/ethernet/davicom/dm9000.c              |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  7 ++
 drivers/net/ethernet/freescale/gianfar.c           | 15 ++++
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  4 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |  2 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  3 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  4 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  6 +-
 .../net/ethernet/netronome/nfp/flower/metadata.c   | 24 ++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |  3 +
 drivers/net/ethernet/socionext/netsec.c            |  9 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  2 +
 drivers/net/ethernet/sun/niu.c                     |  2 -
 drivers/net/ethernet/tehuti/tehuti.c               |  1 +
 drivers/net/usb/cdc-phonet.c                       |  2 +
 drivers/net/usb/r8152.c                            | 40 +++-------
 drivers/net/veth.c                                 |  3 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |  8 +-
 drivers/nvme/host/core.c                           |  1 +
 drivers/nvme/host/fc.c                             |  2 +-
 drivers/nvme/host/pci.c                            |  1 +
 drivers/platform/x86/intel-vbtn.c                  | 12 ++-
 drivers/regulator/qcom-rpmh-regulator.c            |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  8 +-
 drivers/scsi/qedi/qedi_main.c                      |  1 +
 drivers/scsi/qla2xxx/qla_target.c                  | 13 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  4 -
 fs/cifs/smb2pdu.c                                  |  6 +-
 fs/cifs/transport.c                                |  2 +-
 fs/ext4/xattr.c                                    |  4 +
 fs/hugetlbfs/inode.c                               |  4 +-
 fs/nfs/Kconfig                                     |  2 +-
 fs/nfs/nfs3xdr.c                                   |  3 +-
 fs/nfs/nfs4proc.c                                  |  3 +
 fs/squashfs/export.c                               |  8 +-
 fs/squashfs/id.c                                   |  6 +-
 fs/squashfs/squashfs_fs.h                          |  1 +
 fs/squashfs/xattr_id.c                             |  6 +-
 include/acpi/acpi_bus.h                            |  1 +
 include/linux/bpf.h                                |  9 ++-
 include/linux/hugetlb.h                            |  2 +-
 include/linux/if_macvlan.h                         |  3 +-
 include/linux/mm.h                                 | 15 +++-
 include/linux/mutex.h                              |  2 +-
 include/linux/netfilter/x_tables.h                 |  7 +-
 include/linux/u64_stats_sync.h                     |  7 +-
 include/net/inet_connection_sock.h                 |  2 +-
 include/net/nexthop.h                              | 24 ++++++
 include/net/red.h                                  | 10 ++-
 include/net/rtnetlink.h                            |  2 +
 kernel/gcov/clang.c                                | 69 +++++++++++++++++
 kernel/power/energy_model.c                        |  2 +-
 mm/hugetlb.c                                       | 10 +--
 mm/userfaultfd.c                                   |  2 +-
 net/core/dev.c                                     |  2 +-
 net/ipv4/inet_connection_sock.c                    |  7 +-
 net/ipv4/netfilter/arp_tables.c                    | 16 ++--
 net/ipv4/netfilter/ip_tables.c                     | 16 ++--
 net/ipv4/tcp_minisocks.c                           |  7 +-
 net/ipv6/ip6_fib.c                                 |  2 +-
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
 security/integrity/iint.c                          |  8 ++
 sound/hda/intel-nhlt.c                             |  5 ++
 tools/lib/bpf/Makefile                             |  2 +-
 tools/lib/bpf/btf_dump.c                           |  2 +-
 tools/lib/bpf/netlink.c                            |  2 +-
 tools/perf/util/auxtrace.c                         |  4 -
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  6 +-
 .../selftests/net/forwarding/vxlan_bridge_1d.sh    |  2 +-
 127 files changed, 621 insertions(+), 304 deletions(-)


