Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E19137D91
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgAKJ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgAKJ7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:06 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4E620882;
        Sat, 11 Jan 2020 09:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736744;
        bh=GvEdmiApBFulmVRoqMekfB02Jj0Z8pKX73kTgV3WTt0=;
        h=From:To:Cc:Subject:Date:From;
        b=Du2lx8J1rtxx2gb48g5qew++R1kqwfhAx0kRnbreQ/Y+VXgsvR0Z+cw1F/LWMIVL/
         pSzmVStFAxc55B/r2R9wy6qS7XHXBZ+wRvMpBhTYKvqNPM+2bQk7UMBmVJ18DF4OaG
         nxltJpoMCqxv6hhqm3byEQP3tHPWF681/DGflCQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/91] 4.9.209-stable review
Date:   Sat, 11 Jan 2020 10:48:53 +0100
Message-Id: <20200111094844.748507863@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.209-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.209-rc1
X-KernelTest-Deadline: 2020-01-13T09:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.209 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.209-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.209-rc1

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit ME910G1 0x110a composition

Johan Hovold <johan@kernel.org>
    USB: core: fix check for duplicate endpoints

Eric Dumazet <edumazet@google.com>
    vlan: fix memory leak in vlan_dev_set_egress_priority

Petr Machata <petrm@mellanox.com>
    net: sch_prio: When ungrafting, replace with FIFO

Eric Dumazet <edumazet@google.com>
    vlan: vlan_changelink() should propagate errors

Hangbin Liu <liuhangbin@gmail.com>
    vxlan: fix tos value before xmit

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Xin Long <lucien.xin@gmail.com>
    sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: fix possible skb leak

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: dwmac-sunxi: Allow all RGMII modes

Eric Dumazet <edumazet@google.com>
    macvlan: do not assume mac_header is set in macvlan_broadcast()

Chan Shu Tak, Alex <alexchan@task.com.hk>
    llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)

Helge Deller <deller@gmx.de>
    parisc: Fix compiler warnings in debug_core.c

Yang Yingliang <yangyingliang@huawei.com>
    block: fix memleak when __blk_rq_map_user_iov() is failed

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: RX buffer size must be 16 byte aligned

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel: Fix PT PMI handling

Thomas Hebb <tommyhebb@gmail.com>
    kconfig: don't crash on NULL expressions in expr_eq()

Andreas Kemnade <andreas@kemnade.info>
    regulator: rn5t618: fix module aliases

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8962: fix lambda value

Aditya Pakki <pakki001@umn.edu>
    rfkill: Fix incorrect check to avoid NULL pointer dereference

Cristian Birsan <cristian.birsan@microchip.com>
    net: usb: lan78xx: Fix error message format specifier

Manish Chopra <manishc@marvell.com>
    bnx2x: Fix logic to get total no. of PFs per engine

Manish Chopra <manishc@marvell.com>
    bnx2x: Do not handle requests from VFs after parity

Mike Rapoport <rppt@linux.ibm.com>
    powerpc: Ensure that swiotlb buffer is allocated from low memory

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: Replace symbol compare of trace_event

Tomi Valkeinen <tomi.valkeinen@ti.com>
    ARM: dts: am437x-gp/epos-evm: fix panel compatible

Chuhong Yuan <hslester96@gmail.com>
    spi: spi-cavium-thunderx: Add missing pci_release_regions()

Phil Sutter <phil@nwl.cc>
    netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Sudeep Holla <sudeep.holla@arm.com>
    ARM: vexpress: Set-up shared OPP table instead of individual for each CPU

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Fix memory leak in __gop_query32/64()

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_SUCCESS if a usable GOP was found

Arvind Sankar <nivedita@alum.mit.edu>
    efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: netns exit must wait for callbacks

Marco Elver <elver@google.com>
    locking/spinlock/debug: Fix various data races

Aleksandr Yashkin <a.yashkin@inango-systems.com>
    pstore/ram: Write new dumps to start of recycled zones

Dmitry Vyukov <dvyukov@google.com>
    locking/x86: Remove the unused atomic_inc_short() methd

SeongJae Park <sjpark@amazon.de>
    xen/blkback: Avoid unmapping unmapped grant pages

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp: fix physical to logical CPU map for SMT

Eric Dumazet <edumazet@google.com>
    net: add annotations on hh->hh_len lockless accesses

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Discard undersized packets

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Modify byte order for an error message

David Howells <dhowells@redhat.com>
    rxrpc: Fix possible NULL pointer access in ICMP handling

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etb10: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etf: Do not call smp_processor_id from preemptible

Daniel Axtens <dja@axtens.net>
    powerpc/pseries/hvconsole: Fix stack overread via udbg

Imre Deak <imre.deak@intel.com>
    drm/mst: Fix MST sideband up-reply failure handling

Al Viro <viro@zeniv.linux.org.uk>
    fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Leo Yan <leo.yan@linaro.org>
    tty: serial: msm_serial: Fix lockup for sysrq and oops

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: usb: fix memory leak in af9005_identify_state

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove AB8505 USB regulator

Colin Ian King <colin.king@canonical.com>
    media: flexcop-usb: ensure -EIO is returned on error condition

Navid Emamdoost <navid.emamdoost@gmail.com>
    Bluetooth: Fix memory leak in hci_connect_le_scan

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: delete a stray unlock

Oliver Neukum <oneukum@suse.com>
    Bluetooth: btusb: fix PM leak in error case of setup

Omar Sandoval <osandov@fb.com>
    xfs: don't check for AG deadlock for realtime files in bunmapi

Scott Mayhew <smayhew@redhat.com>
    nfsd4: fix up replay_matches_cache()

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Check NULL governor in available_governors_show

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Revert support for execute-only user mappings

Wen Yang <wenyang@linux.alibaba.com>
    ftrace: Avoid potential division by zero in function profiler

Colin Ian King <colin.king@canonical.com>
    ALSA: cs4236: fix error return comparison of an unsigned integer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have the histogram compare functions convert to u64 first

Russell King <rmk+kernel@armlinux.org.uk>
    gpiolib: fix up emulated open drain outputs

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Fix AHCI resources management

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Allow optional reset controller to be used

Florian Fainelli <f.fainelli@gmail.com>
    ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle Persistent Reservations

Lukas Wunner <lukas@wunner.de>
    dmaengine: Fix access to uninitialized dma_slave_caps

Amir Goldstein <amir73il@gmail.com>
    locks: print unsigned ino in /proc/locks

Shakeel Butt <shakeelb@google.com>
    memcg: account security cred as well to kmemcg

Chanho Min <chanho.min@lge.com>
    mm/zsmalloc.c: fix the migrated zspage statistics.

Paul Burton <paulburton@kernel.org>
    MIPS: Avoid VDSO ABI breakage due to global register variable

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code

Sasha Levin <sashal@kernel.org>
    Revert "perf report: Add warning when libunwind not compiled in"

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: limit to INT_MAX in create_blob ioctl

Christian Brauner <christian.brauner@ubuntu.com>
    taskstats: fix data-race

Brian Foster <bfoster@redhat.com>
    xfs: fix mount failure crash on invalid iclog memory access

Andy Whitcroft <apw@canonical.com>
    PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Juergen Gross <jgross@suse.com>
    xen/balloon: fix ballooned page accounting without hotplug enabled

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: prevent premature module unload

Parav Pandit <parav@mellanox.com>
    IB/mlx4: Follow mirror sequence of device add during device removal

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Avoid SBD overflow condition in irq handler

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    md: raid1: check rdev before reference in raid1_sync_request func

EJ Hsu <ejh@nvidia.com>
    usb: gadget: fix wrong endpoint desc

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: stop discovering if oob mode is disconnected

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: iscsi: qla4xxx: fix double free in probe

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Don't call qlt_async_event twice

Bo Wu <wubo40@huawei.com>
    scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Chuhong Yuan <hslester96@gmail.com>
    RDMA/cma: add missed unregister_pernet_subsys in init failure

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Don't fail devfreq_dev_release if not in list


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/am437x-gp-evm.dts               |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts              |   2 +-
 arch/arm/mach-vexpress/spc.c                      |  12 ++-
 arch/arm64/include/asm/pgtable-prot.h             |   5 +-
 arch/arm64/include/asm/pgtable.h                  |  10 +-
 arch/arm64/mm/fault.c                             |   2 +-
 arch/mips/include/asm/thread_info.h               |  20 +++-
 arch/parisc/include/asm/cmpxchg.h                 |  10 +-
 arch/powerpc/mm/mem.c                             |   8 ++
 arch/powerpc/platforms/pseries/hvconsole.c        |   2 +-
 arch/s390/kernel/perf_cpum_sf.c                   |  22 +++--
 arch/s390/kernel/smp.c                            |  80 +++++++++++-----
 arch/tile/lib/atomic_asm_32.S                     |   3 +-
 arch/x86/events/core.c                            |   9 +-
 arch/x86/include/asm/atomic.h                     |  13 ---
 block/blk-map.c                                   |   2 +-
 block/compat_ioctl.c                              |   9 ++
 drivers/ata/ahci_brcm.c                           | 112 ++++++++++++++++------
 drivers/ata/libahci_platform.c                    |   6 +-
 drivers/block/xen-blkback/blkback.c               |   2 +
 drivers/block/xen-blkback/xenbus.c                |  10 ++
 drivers/bluetooth/btusb.c                         |   3 +-
 drivers/devfreq/devfreq.c                         |   8 +-
 drivers/firewire/net.c                            |   6 +-
 drivers/firmware/efi/libstub/gop.c                |  80 ++++------------
 drivers/gpio/gpiolib.c                            |   8 ++
 drivers/gpu/drm/drm_dp_mst_topology.c             |   6 +-
 drivers/gpu/drm/drm_property.c                    |   2 +-
 drivers/hwtracing/coresight/coresight-etb10.c     |   4 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c   |   4 +-
 drivers/infiniband/core/cma.c                     |   1 +
 drivers/infiniband/hw/mlx4/main.c                 |   9 +-
 drivers/md/raid1.c                                |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c              |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                |   5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  12 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |  12 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/macvlan.c                             |   2 +-
 drivers/net/usb/lan78xx.c                         |  11 +--
 drivers/net/vxlan.c                               |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c     |  23 ++++-
 drivers/regulator/ab8500.c                        |  17 ----
 drivers/regulator/rn5t618-regulator.c             |   1 +
 drivers/scsi/libsas/sas_discover.c                |  11 ++-
 drivers/scsi/lpfc/lpfc_bsg.c                      |  15 +--
 drivers/scsi/qla2xxx/qla_isr.c                    |   4 -
 drivers/scsi/qla4xxx/ql4_os.c                     |   1 -
 drivers/spi/spi-cavium-thunderx.c                 |   2 +
 drivers/tty/hvc/hvc_vio.c                         |  16 +++-
 drivers/tty/serial/msm_serial.c                   |  13 ++-
 drivers/usb/core/config.c                         |  70 +++++++++++---
 drivers/usb/gadget/function/f_ecm.c               |   6 +-
 drivers/usb/gadget/function/f_rndis.c             |   1 +
 drivers/usb/serial/option.c                       |   2 +
 drivers/xen/balloon.c                             |   3 +-
 fs/compat_ioctl.c                                 |   3 +-
 fs/locks.c                                        |   2 +-
 fs/nfsd/nfs4state.c                               |  15 ++-
 fs/pstore/ram.c                                   |  11 +++
 fs/xfs/libxfs/xfs_bmap.c                          |   2 +-
 fs/xfs/xfs_log.c                                  |   2 +
 include/linux/ahci_platform.h                     |   2 +
 include/linux/dmaengine.h                         |   5 +-
 include/linux/if_ether.h                          |   8 ++
 include/linux/regulator/ab8500.h                  |   1 -
 include/net/neighbour.h                           |   2 +-
 include/uapi/linux/netfilter/xt_sctp.h            |   6 +-
 kernel/cred.c                                     |   6 +-
 kernel/locking/spinlock_debug.c                   |  32 +++----
 kernel/power/snapshot.c                           |   9 +-
 kernel/taskstats.c                                |  30 +++---
 kernel/trace/ftrace.c                             |   6 +-
 kernel/trace/tracing_map.c                        |   4 +-
 mm/mmap.c                                         |   6 --
 mm/zsmalloc.c                                     |   5 +
 net/8021q/vlan.h                                  |   1 +
 net/8021q/vlan_dev.c                              |   3 +-
 net/8021q/vlan_netlink.c                          |  19 ++--
 net/bluetooth/hci_conn.c                          |   4 +-
 net/bluetooth/l2cap_core.c                        |   4 +-
 net/core/neighbour.c                              |   4 +-
 net/ethernet/eth.c                                |   7 +-
 net/ipv4/tcp_input.c                              |   5 +-
 net/llc/llc_station.c                             |   4 +-
 net/netfilter/nf_conntrack_netlink.c              |   3 +
 net/rfkill/core.c                                 |   7 +-
 net/rxrpc/peer_event.c                            |   3 +
 net/sched/sch_fq.c                                |   2 +-
 net/sched/sch_prio.c                              |  10 +-
 net/sctp/sm_sideeffect.c                          |  28 ++++--
 samples/bpf/trace_event_user.c                    |   4 +-
 scripts/kconfig/expr.c                            |   7 ++
 sound/isa/cs423x/cs4236.c                         |   3 +-
 sound/pci/ice1712/ice1724.c                       |   9 +-
 sound/soc/codecs/wm8962.c                         |   4 +-
 tools/perf/builtin-report.c                       |   7 --
 101 files changed, 658 insertions(+), 355 deletions(-)


