Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7302D1C1453
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgEANiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgEANiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEF32173E;
        Fri,  1 May 2020 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340289;
        bh=swBQERtVzb1zkQo/C56KBA6WkyoXvmIsuN9N/mCYZ4w=;
        h=From:To:Cc:Subject:Date:From;
        b=GUVgrklW44kuvRCzmfPX/pwPyslaCJwAGbs4dQpqwdATbBqee3YZxidaPa5uC5x2v
         i9zmdJ0/jClmmGvQzKY3Xsit5e0NfXCdzJ5QOkAyii+0YPp9Xt9iJBs3p3QrsrBMqv
         zvu1eUXIfajjTHjhrdfFw4K2SkvVdMwHgRRPn31c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/83] 5.4.37-rc1 review
Date:   Fri,  1 May 2020 15:22:39 +0200
Message-Id: <20200501131524.004332640@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.37-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.37-rc1
X-KernelTest-Deadline: 2020-05-03T13:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.37 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.37-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.37-rc1

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix regmap status check

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-core: disable route checks for legacy devices

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: check for non-zero journal inum in ext4_calculate_overhead

Yuval Basson <ybason@marvell.com>
    qed: Fix use after free in qed_chain_free

Eric Dumazet <edumazet@google.com>
    net: use indirect call wrappers for skb_copy_datagram_iter()

Ayush Sawal <ayush.sawal@chelsio.com>
    Crypto: chelsio - Fixes a hang issue during driver registration

Yuval Basson <ybason@marvell.com>
    qed: Fix race condition between scheduling and destroying the slowpath workqueue

Eugene Syromiatnikov <esyr@redhat.com>
    taprio: do not use BIT() in TCA_TAPRIO_ATTR_FLAG_* definitions

Sascha Hauer <s.hauer@pengutronix.de>
    hwmon: (jc42) Fix name to have no illegal characters

John Garry <john.garry@huawei.com>
    blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when no budget

Theodore Ts'o <tytso@mit.edu>
    ext4: convert BUG_ON's to WARN_ON's in mballoc.c

Theodore Ts'o <tytso@mit.edu>
    ext4: increase wait time needed before reuse of deleted inode numbers

yangerkun <yangerkun@huawei.com>
    ext4: use matching invalidatepage in ext4_writepage

Fangrui Song <maskray@google.com>
    arm64: Delete the space separator in __emit_inst

Tamizh chelvam <tamizhr@codeaurora.org>
    mac80211: fix channel switch trigger from unknown mesh peer

Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
    net: stmmac: socfpga: Allow all RGMII modes

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: call runtime_allow() for all hda controllers

Juergen Gross <jgross@suse.com>
    xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant status

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support Clang non-section symbols in ORC dump

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: fix PR IN / READ FULL STATUS for FC

Roy Spliet <nouveau@spliet.org>
    ALSA: hda: Explicitly permit using autosuspend if runtime PM is supported

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Keep the controller initialization even if no codecs found

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Release resources at error in delayed probe

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

David Howells <dhowells@redhat.com>
    afs: Fix length of dump of bad YFSFetchStatus record

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    signal: check sig before setting info in kill_pid_usb_asyncio

Olaf Hering <olaf@aepfle.de>
    x86: hyperv: report value of misc_features

Martin Fuzzey <martin.fuzzey@flowbird.group>
    net: fec: set GPR bit on suspend by DT configuration.

Jeremy Cline <jcline@redhat.com>
    libbpf: Initialize *nl_pid so gcc 10 is happy

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Eric Biggers <ebiggers@google.com>
    xfs: clear PF_MEMALLOC before exiting xfsaild thread

Yang Shi <yang.shi@linux.alibaba.com>
    mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path

Wang YanQing <udknight@gmail.com>
    bpf, x86_32: Fix logic error in BPF_LDX zero-extension

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86_32: Fix clobbering of dst for BPF_JSET

Luke Nelson <lukenels@cs.washington.edu>
    bpf, x86_32: Fix incorrect encoding in BPF_LDX zero-extension

Vitor Massaru Iha <vitor@massaru.org>
    um: ensure `make ARCH=um mrproper` removes arch/$(SUBARCH)/include/generated/

Waiman Long <longman@redhat.com>
    blk-iocost: Fix error on iocost_ioc_vrate_adj

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PM: sleep: core: Switch back to async_schedule_dev()

Hillf Danton <hdanton@sina.com>
    netfilter: nat: fix error handling upon registering inet hook

Ian Rogers <irogers@google.com>
    perf/core: fix parent pid/tid in task exit events

Quentin Perret <qperret@google.com>
    sched/core: Fix reset-on-fork from RT with uclamp

Niklas Schnelle <schnelle@linux.ibm.com>
    net/mlx5: Fix failing fw tracer allocation on s390

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: do not set affinity for floating irqs

Toke Høiland-Jørgensen <toke@redhat.com>
    cpumap: Avoid warning when CONFIG_DEBUG_PER_CPU_MAPS is enabled

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    ARM: dts: bcm283x: Disable dsi0 node

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Move Apex Edge TPU class quirk to fix BAR assignment

Raymond Pang <RaymondPang-oc@zhaoxin.com>
    PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports

Raymond Pang <RaymondPang-oc@zhaoxin.com>
    PCI: Add Zhaoxin Vendor ID

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Unify ACS quirk desired vs provided checking

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Make ACS quirk implementations more uniform

Raymond Pang <RaymondPang-oc@zhaoxin.com>
    PCI: Add ACS quirk for Zhaoxin multi-function devices

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Avoid ASMedia XHCI USB PME# from D0 defect

Zhu Yanjun <yanjunz@mellanox.com>
    net/mlx5e: Get the latest values from counters in switchdev mode

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Don't trigger IRQ multiple times on XSK wakeup to avoid WQ overruns

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix leak of svc_rdma_recv_ctxt objects

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix trace point use-after-free race

Brian Foster <bfoster@redhat.com>
    xfs: acquire superblock freeze protection on eofblocks scans

Jason Gunthorpe <jgg@ziepe.ca>
    net/cxgb4: Check the return from t4_query_params properly

David Howells <dhowells@redhat.com>
    rxrpc: Fix DATA Tx to disable nofrag for UDP on AF_INET6 socket

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: altera: use proper variable to hold errno

Jann Horn <jannh@google.com>
    bpf: Forbid XADD on spilled pointers for unprivileged users

Vasily Averin <vvs@virtuozzo.com>
    nfsd: memory corruption in nfsd4_lock()

Arnd Bergmann <arnd@arndb.de>
    drivers: soc: xilinx: fix firmware driver Kconfig dependency

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix wrong clock after suspend & resume

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-card: fix codec-to-codec link setup

Philipp Puschmann <p.puschmann@pironex.de>
    ASoC: tas571x: disable regulators on failed probe

Stephan Gerhold <stephan@gerhold.net>
    ASoC: q6dsp6: q6afe-dai: add missing channels to MI2S DAIs

Philipp Rudo <prudo@linux.ibm.com>
    s390/ftrace: fix potential crashes when switching tracers

Syed Nayyar Waris <syednwaris@gmail.com>
    counter: 104-quad-8: Add lock guards - generic interface

Al Viro <viro@zeniv.linux.org.uk>
    propagate_one(): mnt_set_mountpoint() needs mount_lock

YueHaibing <yuehaibing@huawei.com>
    iio:ad7797: Use correct attribute_group

David Howells <dhowells@redhat.com>
    afs: Fix to actually set AFS_SERVER_FL_HAVE_EPOCH

David Howells <dhowells@redhat.com>
    afs: Make record checking use TASK_UNINTERRUPTIBLE when appropriate

Cristian Birsan <cristian.birsan@microchip.com>
    usb: gadget: udc: atmel: Fix vbus disconnect handling

Nathan Chancellor <natechancellor@gmail.com>
    usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_complete

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix DT binding schema rule again to avoid needless rebuilds

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Do link recovery for SS and SSP

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: sai: fix sai probe

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    printk: queue wake_up_klogd irq_work only if per-CPU areas are ready

Richard Weinberger <richard@nod.at>
    ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()

Clement Leger <cleger@kalray.eu>
    remoteproc: Fix wrong rvring index computation


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                     |   1 +
 arch/arm64/include/asm/sysreg.h                    |   4 +-
 arch/s390/kernel/diag.c                            |   2 +-
 arch/s390/kernel/smp.c                             |   4 +-
 arch/s390/kernel/trace.c                           |   2 +-
 arch/s390/pci/pci_irq.c                            |   5 +-
 arch/um/Makefile                                   |   1 +
 arch/x86/kernel/cpu/mshyperv.c                     |   4 +-
 arch/x86/net/bpf_jit_comp.c                        |  18 +-
 arch/x86/net/bpf_jit_comp32.c                      |  28 ++-
 block/blk-iocost.c                                 |   4 +-
 block/blk-mq.c                                     |   4 +-
 drivers/base/power/main.c                          |   2 +-
 drivers/counter/104-quad-8.c                       | 194 +++++++++++++++++----
 drivers/crypto/chelsio/chcr_core.c                 |   2 -
 drivers/hwmon/jc42.c                               |   2 +-
 drivers/i2c/busses/i2c-altera.c                    |   9 +-
 drivers/iio/adc/ad7793.c                           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   2 +-
 drivers/net/ethernet/freescale/fec.h               |   7 +
 drivers/net/ethernet/freescale/fec_main.c          | 149 +++++++++++++---
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  38 ++--
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  13 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |   2 +
 drivers/pci/quirks.c                               | 143 +++++++++++----
 drivers/remoteproc/remoteproc_core.c               |   2 +-
 drivers/soc/xilinx/Kconfig                         |   4 +-
 drivers/staging/gasket/apex_driver.c               |   7 -
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/target/target_core_user.c                  |   1 +
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_ep.c                |   2 +-
 drivers/xen/xenbus/xenbus_client.c                 |   9 +-
 fs/afs/cmservice.c                                 |   2 +-
 fs/afs/internal.h                                  |   2 +-
 fs/afs/rotate.c                                    |   6 +-
 fs/afs/server.c                                    |   7 +-
 fs/afs/volume.c                                    |   8 +-
 fs/afs/yfsclient.c                                 |   6 +-
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |   6 +-
 fs/ext4/super.c                                    |   3 +-
 fs/nfsd/nfs4state.c                                |   2 +
 fs/pnode.c                                         |   9 +-
 fs/ubifs/orphan.c                                  |   4 +-
 fs/xfs/xfs_icache.c                                |  10 ++
 fs/xfs/xfs_ioctl.c                                 |   5 +-
 fs/xfs/xfs_reflink.c                               |   1 +
 fs/xfs/xfs_trans_ail.c                             |   4 +-
 include/linux/pci_ids.h                            |   2 +
 include/linux/printk.h                             |   5 -
 include/linux/qed/qed_chain.h                      |  24 ++-
 include/linux/sunrpc/svc_rdma.h                    |   1 +
 include/sound/soc.h                                |   1 +
 include/trace/events/iocost.h                      |   6 +-
 include/trace/events/rpcrdma.h                     |  50 ++++--
 include/uapi/linux/pkt_sched.h                     |   4 +-
 init/main.c                                        |   1 -
 kernel/bpf/cpumap.c                                |   2 +-
 kernel/bpf/verifier.c                              |  28 ++-
 kernel/events/core.c                               |  13 +-
 kernel/printk/internal.h                           |   5 +
 kernel/printk/printk.c                             |  34 ++++
 kernel/printk/printk_safe.c                        |  11 +-
 kernel/sched/core.c                                |   9 +-
 kernel/signal.c                                    |   6 +-
 mm/shmem.c                                         |   4 +-
 net/core/datagram.c                                |  14 +-
 net/mac80211/mesh.c                                |  11 +-
 net/netfilter/nf_nat_proto.c                       |   4 +-
 net/rxrpc/local_object.c                           |   9 -
 net/rxrpc/output.c                                 |  44 ++---
 net/sunrpc/svc_xprt.c                              |   3 -
 net/sunrpc/svcsock.c                               |   4 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |  22 +++
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |  29 ++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   5 -
 scripts/Makefile.lib                               |   2 +-
 sound/pci/hda/hda_intel.c                          |  46 +++--
 sound/pci/hda/hda_intel.h                          |   1 +
 sound/soc/codecs/tas571x.c                         |  20 ++-
 sound/soc/codecs/wm8960.c                          |   3 +-
 sound/soc/meson/axg-card.c                         |   4 +-
 sound/soc/qcom/qdsp6/q6afe-dai.c                   |  16 ++
 sound/soc/soc-core.c                               |  28 ++-
 sound/soc/stm/stm32_sai_sub.c                      |  12 +-
 sound/soc/stm/stm32_spdifrx.c                      |   2 +
 tools/lib/bpf/netlink.c                            |   4 +-
 tools/objtool/check.c                              |  17 +-
 tools/objtool/orc_dump.c                           |  44 +++--
 .../selftests/bpf/verifier/value_illegal_alu.c     |   1 +
 101 files changed, 917 insertions(+), 434 deletions(-)


