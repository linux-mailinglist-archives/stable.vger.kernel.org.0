Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1F73FFC99
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348647AbhICJCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348635AbhICJCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD2276069E;
        Fri,  3 Sep 2021 09:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659707;
        bh=/m0SIhNBKWV0hwGdnCABBt+FfVMmfdpmxYnlVVI4t9Y=;
        h=From:To:Cc:Subject:Date:From;
        b=2Rlk9+TqcIzfpwlQuWavxqTh4TibfQ3iiN2FH9r6N/dLKfffMGwlzQax8mjmkrFtU
         Pc8pyqvP8QmQdwXiHRZYgYP+MQco6zPdkKbs3a49UrKALWGWqrY8N2Lf3xMPiL/PIZ
         3K/mJNFtHi2xanPz3Io1q4+eiRyUMtMI574xYVqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.62
Date:   Fri,  3 Sep 2021 11:01:34 +0200
Message-Id: <163065969515792@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.62 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml |    6 
 Makefile                                                     |    2 
 arch/arc/kernel/vmlinux.lds.S                                |    2 
 arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts          |    4 
 arch/parisc/include/asm/string.h                             |   15 -
 arch/parisc/kernel/parisc_ksyms.c                            |    4 
 arch/parisc/lib/Makefile                                     |    4 
 arch/parisc/lib/memset.c                                     |   72 +++++
 arch/parisc/lib/string.S                                     |  136 -----------
 arch/powerpc/perf/core-book3s.c                              |   10 
 arch/riscv/kernel/Makefile                                   |    5 
 arch/riscv/kernel/ptrace.c                                   |    4 
 arch/riscv/mm/Makefile                                       |    3 
 arch/x86/events/intel/uncore_snbep.c                         |    2 
 block/blk-iocost.c                                           |    8 
 block/blk-mq.c                                               |   30 --
 drivers/block/floppy.c                                       |   30 +-
 drivers/bluetooth/btusb.c                                    |   22 +
 drivers/clk/renesas/rcar-usb2-clock-sel.c                    |    2 
 drivers/cpufreq/cpufreq-dt-platdev.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                   |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                      |   36 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c        |   15 +
 drivers/gpu/drm/drm_ioc32.c                                  |    4 
 drivers/gpu/drm/i915/gt/intel_timeline.c                     |    8 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                      |   27 ++
 drivers/gpu/drm/nouveau/dispnv50/head.c                      |   13 -
 drivers/gpu/drm/nouveau/dispnv50/head.h                      |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c                |    2 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h                |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c              |    9 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                     |    1 
 drivers/infiniband/hw/bnxt_re/main.c                         |    1 
 drivers/infiniband/hw/efa/efa_main.c                         |    1 
 drivers/infiniband/hw/hfi1/sdma.c                            |    9 
 drivers/misc/lkdtm/core.c                                    |    2 
 drivers/mmc/host/sdhci-iproc.c                               |    3 
 drivers/mtd/nand/spi/core.c                                  |    6 
 drivers/mtd/nand/spi/macronix.c                              |    6 
 drivers/mtd/nand/spi/toshiba.c                               |    6 
 drivers/net/can/usb/esd_usb2.c                               |    4 
 drivers/net/dsa/mt7530.c                                     |    5 
 drivers/net/ethernet/apm/xgene-v2/main.c                     |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c              |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c       |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h       |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c       |   13 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c      |   32 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h     |    1 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |   32 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h                  |    3 
 drivers/net/ethernet/intel/ice/ice_devlink.c                 |    4 
 drivers/net/ethernet/intel/igc/igc_main.c                    |   36 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c                     |    3 
 drivers/net/ethernet/marvell/mvneta.c                        |    2 
 drivers/net/ethernet/mscc/ocelot_io.c                        |   16 -
 drivers/net/ethernet/qlogic/qed/qed_ll2.c                    |   20 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                   |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c              |   22 +
 drivers/net/usb/pegasus.c                                    |    4 
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c                 |   25 +-
 drivers/opp/of.c                                             |    5 
 drivers/scsi/scsi_sysfs.c                                    |    9 
 drivers/tty/vt/vt_ioctl.c                                    |   10 
 drivers/usb/dwc3/gadget.c                                    |   23 -
 drivers/usb/gadget/function/u_audio.c                        |    5 
 drivers/usb/host/xhci-pci-renesas.c                          |   35 +-
 drivers/usb/serial/ch341.c                                   |    1 
 drivers/usb/serial/option.c                                  |    2 
 drivers/usb/typec/ucsi/ucsi.c                                |  125 ++++++++--
 drivers/usb/typec/ucsi/ucsi.h                                |    2 
 drivers/usb/typec/ucsi/ucsi_acpi.c                           |    5 
 drivers/vhost/vringh.c                                       |    2 
 drivers/virtio/virtio_pci_common.c                           |    7 
 drivers/virtio/virtio_ring.c                                 |    6 
 drivers/virtio/virtio_vdpa.c                                 |    3 
 fs/btrfs/btrfs_inode.h                                       |   15 +
 fs/btrfs/file.c                                              |   11 
 fs/btrfs/inode.c                                             |    6 
 fs/btrfs/transaction.h                                       |    2 
 fs/btrfs/volumes.c                                           |    2 
 fs/ceph/caps.c                                               |   21 +
 fs/ceph/mds_client.c                                         |    7 
 fs/ceph/snap.c                                               |    3 
 fs/ceph/super.h                                              |    3 
 fs/overlayfs/export.c                                        |    2 
 fs/pipe.c                                                    |   33 +-
 include/linux/bpf-cgroup.h                                   |   57 +++-
 include/linux/bpf.h                                          |   15 -
 include/linux/netdevice.h                                    |    4 
 include/linux/once.h                                         |    4 
 include/linux/pipe_fs_i.h                                    |    2 
 include/linux/rcupdate.h                                     |    2 
 include/linux/srcu.h                                         |    3 
 include/linux/srcutiny.h                                     |    7 
 include/linux/stmmac.h                                       |    1 
 kernel/audit_tree.c                                          |    2 
 kernel/bpf/helpers.c                                         |   15 -
 kernel/bpf/local_storage.c                                   |    5 
 kernel/bpf/verifier.c                                        |    8 
 kernel/cred.c                                                |   12 
 kernel/kthread.c                                             |   33 ++
 kernel/rcu/srcutiny.c                                        |   77 +++++-
 kernel/rcu/srcutree.c                                        |  127 +++++++---
 kernel/sched/fair.c                                          |    2 
 kernel/tracepoint.c                                          |   81 +++++-
 lib/once.c                                                   |   11 
 net/bpf/test_run.c                                           |    6 
 net/core/rtnetlink.c                                         |    3 
 net/ipv4/ip_gre.c                                            |    2 
 net/ipv4/route.c                                             |   12 
 net/ipv6/route.c                                             |   20 +
 net/netfilter/nf_conntrack_core.c                            |   71 +----
 net/qrtr/qrtr.c                                              |    2 
 net/rds/ib_frmr.c                                            |    4 
 net/sched/sch_ets.c                                          |    7 
 net/socket.c                                                 |    6 
 net/tipc/socket.c                                            |    2 
 sound/soc/codecs/rt5682.c                                    |    1 
 sound/soc/soc-component.c                                    |   63 ++---
 tools/perf/arch/arm/include/perf_regs.h                      |    2 
 tools/perf/arch/arm64/include/perf_regs.h                    |    2 
 tools/perf/arch/csky/include/perf_regs.h                     |    2 
 tools/perf/arch/powerpc/include/perf_regs.h                  |    2 
 tools/perf/arch/riscv/include/perf_regs.h                    |    2 
 tools/perf/arch/s390/include/perf_regs.h                     |    2 
 tools/perf/arch/x86/include/perf_regs.h                      |    2 
 tools/perf/util/annotate.c                                   |    8 
 tools/perf/util/annotate.h                                   |    1 
 tools/perf/util/env.c                                        |    1 
 tools/perf/util/perf_regs.h                                  |    7 
 tools/perf/util/symbol-elf.c                                 |    1 
 tools/perf/util/vdso.c                                       |    2 
 tools/virtio/Makefile                                        |    3 
 tools/virtio/linux/spinlock.h                                |   56 ++++
 tools/virtio/linux/virtio.h                                  |    2 
 137 files changed, 1226 insertions(+), 658 deletions(-)

Aaron Ma (1):
      igc: fix page fault when thunderbolt is unplugged

Adam Ford (1):
      clk: renesas: rcar-usb2-clock-sel: Fix kernel NULL pointer dereference

Alexey Gladkov (1):
      ucounts: Increase ucounts reference counter before the security hook

Andrey Ignatov (1):
      rtnetlink: Return correct error on changing device netns

Athira Rajeev (1):
      powerpc/perf: Invoke per-CPU variable access with disabled interrupts

Ben Skeggs (2):
      drm/nouveau/disp: power down unused DP links during init
      drm/nouveau/kms/nv50: workaround EFI GOP window channel format differences

Benjamin Berg (2):
      usb: typec: ucsi: acpi: Always decode connector change information
      usb: typec: ucsi: Work around PPM losing change information

Bjorn Andersson (1):
      usb: typec: ucsi: Clear pending after acking connector change

Christophe JAILLET (1):
      xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Colin Ian King (1):
      perf/x86/intel/uncore: Fix integer overflow on 23 bit left shift of a u32

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks again

Daniel Borkmann (1):
      bpf: Fix ringbuf helper function compatibility

Davide Caratti (1):
      net/sched: ets: fix crash when flipping from 'strict' to 'quantum'

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

Derek Fang (1):
      ASoC: rt5682: Adjust headset volume button threshold

Dinghao Liu (1):
      RDMA/bnxt_re: Remove unpaired rtnl unlock in bnxt_re_dev_init()

Eric Dumazet (2):
      ipv6: use siphash in rt6_exception_hash()
      ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Filipe Manana (1):
      btrfs: fix race between marking inode needs to be logged and log syncing

Florian Westphal (1):
      netfilter: conntrack: collect all entries in one cycle

Frieder Schrempf (1):
      mtd: spinand: Fix incorrect parameters for on-die ECC

Gal Pressman (1):
      RDMA/efa: Free IRQ vectors on error flow

Gerd Rausch (1):
      net/rds: dma_map_sg is entitled to merge entries

Greg Kroah-Hartman (1):
      Linux 5.10.62

Guangbin Huang (1):
      net: hns3: fix get wrong pfc_en when query PFC configuration

Guenter Roeck (1):
      ARC: Fix CONFIG_STACKDEPOT

Guo Ren (2):
      riscv: Fixup wrong ftrace remove cflag
      riscv: Fixup patch_text panic in ftrace

Guojia Liao (1):
      net: hns3: fix duplicate node in VLAN list

Helge Deller (1):
      Revert "parisc: Add assembly implementations for memset, strlen, strcpy, strncpy and strcat"

Jacob Keller (1):
      ice: do not abort devlink info if board identifier can't be found

Jerome Brunet (1):
      usb: gadget: u_audio: fix race condition on endpoint stop

Jianlin Lv (1):
      perf tools: Fix arm64 build error with gcc-11

Johan Hovold (1):
      Revert "USB: serial: ch341: fix character loss at high transfer rates"

Johannes Berg (1):
      iwlwifi: pnvm: accept multiple HW-type TLVs

Kees Cook (1):
      lkdtm: Enable DOUBLE_FAULT on all architectures

Kefeng Wang (1):
      once: Fix panic when module unload

Kenneth Feng (2):
      Revert "drm/amd/pm: fix workload mismatch on vega10"
      drm/amd/pm: change the workload type for some cards

Li Jinlin (1):
      scsi: core: Fix hang of freezing queue between blocking and running device

Linus Torvalds (3):
      pipe: avoid unnecessary EPOLLET wakeups under normal loads
      pipe: do FASYNC notifications for every pipe IO, not just state changes
      vt_kdsetmode: extend console locking

Mark Brown (2):
      ASoC: component: Remove misplaced prefix handling in pin control functions
      net: mscc: Fix non-GPL export of regmap APIs

Mark Yacoub (1):
      drm: Copy drm_wait_vblank to user before returning

Martin Liška (1):
      perf annotate: Fix jump parsing for C++ code.

Mathieu Desnoyers (1):
      tracepoint: Use rcu get state and cond sync for static call updates

Matthew Brost (1):
      drm/i915: Fix syncmap memory leak

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Michael S. Tsirkin (1):
      tools/virtio: fix build

Michał Mirosław (1):
      opp: remove WARN when no valid OPPs remain

Michel Dänzer (1):
      drm/amdgpu: Cancel delayed work when GFXOFF is disabled

Miklos Szeredi (1):
      ovl: fix uninitialized pointer read in ovl_lookup_real_one()

Ming Lei (2):
      blk-iocost: fix lockdep warning on blkcg->lock
      blk-mq: don't grab rq's refcount in blk_mq_check_expired()

Namhyung Kim (1):
      perf record: Fix memory leak in vDSO found using ASAN

Naresh Kumar PBS (1):
      RDMA/bnxt_re: Add missing spin lock initialization

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (2):
      virtio: Improve vq->broken access to avoid any compiler optimization
      virtio_pci: Support surprise removal of virtio pci device

Paul E. McKenney (5):
      srcu: Provide internal interface to start a Tree SRCU grace period
      srcu: Provide polling interfaces for Tree SRCU grace periods
      srcu: Provide internal interface to start a Tiny SRCU grace period
      srcu: Make Tiny SRCU use multi-bit grace-period counter
      srcu: Provide polling interfaces for Tiny SRCU grace periods

Pauli Virtanen (1):
      Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Peter Collingbourne (1):
      net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Peter Zijlstra (1):
      kthread: Fix PF_KTHREAD vs to_kthread() race

Petko Manolov (1):
      net: usb: pegasus: fixes of set_register(s) return value evaluation;

Petr Vorel (1):
      arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88

Qu Wenruo (2):
      Revert "btrfs: compression: don't try to compress if we don't have enough pages"
      btrfs: fix NULL pointer dereference when deleting device by invalid id

Rahul Lakkireddy (1):
      cxgb4: dont touch blocked freelist bitmap after free

Riccardo Mancini (2):
      perf env: Fix memory leak of bpf_prog_info_linear member
      perf symbol-elf: Fix memory leak by freeing sdt_note.args

Richard Guy Briggs (1):
      audit: move put_tree() to avoid trim_trees refcount underflow and UAF

Rob Herring (1):
      dt-bindings: sifive-l2-cache: Fix 'select' matching

Sasha Neftin (2):
      e1000e: Fix the max snoop/no-snoop latency for 10M
      e1000e: Do not take care about recovery NVM checksum

Shai Malin (2):
      qed: qed ll2 race condition fixes
      qed: Fix null-pointer dereference in qed_rdma_create_qp()

Shreyansh Chouhan (1):
      ip_gre: add validation for csum_start

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Takashi Iwai (1):
      usb: renesas-xhci: Prefer firmware loading on unknown ROM state

Thara Gopinath (1):
      cpufreq: blocklist Qualcomm sm8150 in cpufreq-dt-platdev

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Toshiki Nishioka (1):
      igc: Use num_tx_queues when iterating over tx_ring queue

Tuo Li (1):
      IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Ulf Hansson (1):
      Revert "mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711"

Vincent Chen (1):
      riscv: Ensure the value of FP registers in the core dump file is up to date

Vincent Whitchurch (1):
      virtio_vdpa: reject invalid vq indices

Wesley Cheng (1):
      usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Wong Vee Khee (1):
      net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est

Xiaoliang Yang (1):
      net: stmmac: add mutex lock to protect est parameters

Xiaolong Huang (1):
      net: qrtr: fix another OOB Read in qrtr_endpoint_post

Xin Long (1):
      tipc: call tipc_wait_for_connect only when dlen is not 0

Xiubo Li (1):
      ceph: correctly handle releasing an embedded cap flush

Yonghong Song (2):
      bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper
      bpf: Fix potentially incorrect results with bpf_get_local_storage()

Yufeng Mo (2):
      net: hns3: clear hardware resource when loading driver
      net: hns3: add waiting time before cmdq memory is released

Zhengjun Zhang (1):
      USB: serial: option: add new VID/PID to support Fibocom FG150

