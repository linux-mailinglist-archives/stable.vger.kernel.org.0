Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6DF24D44E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgHULnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 07:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgHULjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 07:39:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 848CE2078D;
        Fri, 21 Aug 2020 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598009963;
        bh=t3DIq8ticFfLI2yzJqpvduFDIhvUTngDlB/4v+/LPGY=;
        h=From:To:Cc:Subject:Date:From;
        b=iZFKMm4Wsw9gfto+0e7VY3uNxAhq0GR4l+LKm+BcUAInLnI2zF8bAB3N1w08RNQnO
         IW5CzoaO+Z0asuMCV8u4cnsV3Yfxbq5ysjvb+6ZkPTgohUz1UYEy37EOZ7EorLQjsO
         mK9X/b4ba9JoYQiTLH3xpXnC0t8oiGff7rQq3nHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.17
Date:   Fri, 21 Aug 2020 13:39:34 +0200
Message-Id: <15980099746095@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.17 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/multihit.rst                       |    4 
 Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt |    2 
 Makefile                                                             |    2 
 arch/arm64/kernel/perf_event.c                                       |   13 
 arch/mips/Kconfig                                                    |    1 
 arch/mips/boot/dts/ingenic/qi_lb60.dts                               |    2 
 arch/mips/kernel/topology.c                                          |    2 
 arch/openrisc/kernel/stacktrace.c                                    |   18 +
 arch/powerpc/include/asm/percpu.h                                    |    4 
 arch/powerpc/mm/fault.c                                              |    7 
 arch/powerpc/mm/ptdump/hashpagetable.c                               |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c                      |    2 
 arch/s390/Kconfig                                                    |    1 
 arch/s390/lib/test_unwind.c                                          |    1 
 arch/sh/boards/mach-landisk/setup.c                                  |    3 
 arch/x86/events/rapl.c                                               |    2 
 arch/x86/kernel/apic/vector.c                                        |    4 
 arch/x86/kernel/cpu/bugs.c                                           |    8 
 arch/x86/kernel/tsc_msr.c                                            |    9 
 arch/xtensa/include/asm/thread_info.h                                |    4 
 arch/xtensa/kernel/asm-offsets.c                                     |    3 
 arch/xtensa/kernel/entry.S                                           |   11 
 arch/xtensa/kernel/perf_event.c                                      |    2 
 crypto/af_alg.c                                                      |   11 
 crypto/algif_aead.c                                                  |   10 
 crypto/algif_skcipher.c                                              |   11 
 drivers/base/dd.c                                                    |    4 
 drivers/clk/actions/owl-s500.c                                       |    2 
 drivers/clk/bcm/clk-bcm2835.c                                        |   25 +
 drivers/clk/qcom/clk-alpha-pll.c                                     |    2 
 drivers/clk/qcom/gcc-sdm660.c                                        |    3 
 drivers/clk/qcom/gcc-sm8150.c                                        |    8 
 drivers/clk/sirf/clk-atlas6.c                                        |    2 
 drivers/crypto/caam/caamalg.c                                        |   29 --
 drivers/crypto/caam/compat.h                                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                              |    8 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                    |   23 +
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c           |   69 ++++
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c                     |    5 
 drivers/gpu/drm/drm_dp_mst_topology.c                                |   35 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c                       |    6 
 drivers/gpu/drm/i915/gt/intel_gt.c                                   |    5 
 drivers/gpu/drm/imx/imx-ldb.c                                        |    7 
 drivers/gpu/drm/ingenic/ingenic-drm.c                                |    2 
 drivers/gpu/drm/omapdrm/dss/dispc.c                                  |    1 
 drivers/gpu/drm/omapdrm/dss/dsi.c                                    |    1 
 drivers/gpu/drm/omapdrm/dss/dss.c                                    |    1 
 drivers/gpu/drm/omapdrm/dss/venc.c                                   |    1 
 drivers/gpu/drm/panfrost/panfrost_gem.c                              |    2 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                              |    2 
 drivers/gpu/drm/tidss/tidss_kms.c                                    |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                  |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                                  |    5 
 drivers/gpu/ipu-v3/ipu-image-convert.c                               |  145 ++++++----
 drivers/i2c/busses/i2c-bcm-iproc.c                                   |   13 
 drivers/i2c/busses/i2c-rcar.c                                        |   15 -
 drivers/iio/dac/ad5592r-base.c                                       |    4 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h                              |    3 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c                       |   23 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                         |    2 
 drivers/infiniband/core/counters.c                                   |    4 
 drivers/infiniband/core/uverbs_cmd.c                                 |    4 
 drivers/infiniband/hw/cxgb4/mem.c                                    |    1 
 drivers/infiniband/hw/mlx4/mr.c                                      |    1 
 drivers/infiniband/ulp/ipoib/ipoib.h                                 |    2 
 drivers/infiniband/ulp/ipoib/ipoib_ib.c                              |   67 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c                            |    2 
 drivers/input/mouse/sentelic.c                                       |    2 
 drivers/iommu/intel-iommu.c                                          |    2 
 drivers/iommu/omap-iommu-debug.c                                     |    3 
 drivers/irqchip/irq-gic-v3-its.c                                     |   15 -
 drivers/irqchip/irq-loongson-liointc.c                               |   10 
 drivers/md/bcache/bcache.h                                           |    2 
 drivers/md/bcache/bset.c                                             |    2 
 drivers/md/bcache/btree.c                                            |    2 
 drivers/md/bcache/journal.c                                          |    4 
 drivers/md/bcache/super.c                                            |    2 
 drivers/md/bcache/writeback.c                                        |   14 
 drivers/md/bcache/writeback.h                                        |   19 +
 drivers/md/dm-rq.c                                                   |    3 
 drivers/md/dm.c                                                      |    3 
 drivers/md/md-cluster.c                                              |    1 
 drivers/md/raid5.c                                                   |    3 
 drivers/media/platform/qcom/venus/pm_helpers.c                       |    4 
 drivers/media/platform/rockchip/rga/rga-hw.c                         |   29 +-
 drivers/media/platform/rockchip/rga/rga-hw.h                         |    5 
 drivers/media/platform/vsp1/vsp1_dl.c                                |    2 
 drivers/mfd/arizona-core.c                                           |   18 +
 drivers/mfd/dln2.c                                                   |    4 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                        |   18 -
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                             |   26 +
 drivers/mtd/nand/raw/fsl_upm.c                                       |    1 
 drivers/net/ethernet/marvell/octeontx2/af/common.h                   |    2 
 drivers/net/ethernet/qualcomm/emac/emac.c                            |   17 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                  |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c                 |    3 
 drivers/net/wireless/realtek/rtw88/pci.c                             |    9 
 drivers/nvdimm/security.c                                            |   13 
 drivers/nvme/host/core.c                                             |   15 +
 drivers/nvme/host/fabrics.c                                          |    2 
 drivers/nvme/host/fabrics.h                                          |    3 
 drivers/nvme/host/fc.c                                               |    1 
 drivers/nvme/host/multipath.c                                        |   18 +
 drivers/nvme/host/nvme.h                                             |    1 
 drivers/nvme/host/rdma.c                                             |   10 
 drivers/nvme/host/tcp.c                                              |   15 -
 drivers/pci/ats.c                                                    |   15 +
 drivers/pci/bus.c                                                    |    6 
 drivers/pci/controller/dwc/pcie-qcom.c                               |   41 ++
 drivers/pci/hotplug/acpiphp_glue.c                                   |   14 
 drivers/pci/quirks.c                                                 |    5 
 drivers/pinctrl/pinctrl-ingenic.c                                    |    9 
 drivers/platform/chrome/cros_ec_ishtp.c                              |    4 
 drivers/pwm/pwm-bcm-iproc.c                                          |    9 
 drivers/remoteproc/qcom_q6v5.c                                       |    2 
 drivers/remoteproc/qcom_q6v5_mss.c                                   |   11 
 drivers/rtc/rtc-cpcap.c                                              |    2 
 drivers/rtc/rtc-pl031.c                                              |    1 
 drivers/scsi/lpfc/lpfc_nvmet.c                                       |    2 
 drivers/staging/media/rkisp1/rkisp1-isp.c                            |   25 -
 drivers/usb/serial/ftdi_sio.c                                        |   37 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                                     |    3 
 drivers/watchdog/f71808e_wdt.c                                       |   13 
 drivers/watchdog/rti_wdt.c                                           |    2 
 drivers/watchdog/watchdog_dev.c                                      |   18 -
 fs/btrfs/ctree.h                                                     |    4 
 fs/btrfs/disk-io.c                                                   |   13 
 fs/btrfs/extent-io-tree.h                                            |    2 
 fs/btrfs/extent-tree.c                                               |   23 +
 fs/btrfs/extent_io.c                                                 |   18 -
 fs/btrfs/free-space-cache.c                                          |    4 
 fs/btrfs/inode.c                                                     |   20 -
 fs/btrfs/ioctl.c                                                     |   46 ++-
 fs/btrfs/ref-verify.c                                                |    2 
 fs/btrfs/relocation.c                                                |   12 
 fs/btrfs/scrub.c                                                     |    2 
 fs/btrfs/super.c                                                     |   51 ++-
 fs/btrfs/sysfs.c                                                     |    3 
 fs/btrfs/transaction.c                                               |    5 
 fs/btrfs/tree-log.c                                                  |   43 --
 fs/btrfs/volumes.c                                                   |   48 ++-
 fs/ceph/dir.c                                                        |    4 
 fs/ceph/mds_client.c                                                 |    6 
 fs/cifs/smb2misc.c                                                   |   73 +++--
 fs/cifs/smb2pdu.c                                                    |    2 
 fs/ext2/ialloc.c                                                     |    3 
 fs/f2fs/compress.c                                                   |    2 
 fs/f2fs/data.c                                                       |    4 
 fs/gfs2/bmap.c                                                       |   69 ++--
 fs/minix/inode.c                                                     |   12 
 fs/minix/itree_v1.c                                                  |   12 
 fs/minix/itree_v2.c                                                  |   13 
 fs/minix/minix.h                                                     |    1 
 fs/nfs/file.c                                                        |   17 -
 fs/nfs/flexfilelayout/flexfilelayout.c                               |   50 ++-
 fs/nfs/nfs4file.c                                                    |    5 
 fs/nfs/nfs4proc.c                                                    |    2 
 fs/nfs/nfs4xdr.c                                                     |    6 
 fs/nfs/pnfs.c                                                        |    4 
 fs/nfs/pnfs.h                                                        |    2 
 fs/ocfs2/ocfs2.h                                                     |    4 
 fs/ocfs2/suballoc.c                                                  |    4 
 fs/ocfs2/super.c                                                     |    4 
 fs/ubifs/journal.c                                                   |   10 
 fs/ufs/super.c                                                       |    2 
 include/crypto/if_alg.h                                              |    4 
 include/linux/fs.h                                                   |   10 
 include/linux/hugetlb.h                                              |    8 
 include/linux/intel-iommu.h                                          |    4 
 include/linux/irq.h                                                  |   13 
 include/linux/pci-ats.h                                              |    4 
 include/net/sock.h                                                   |    4 
 include/uapi/linux/btrfs.h                                           |   14 
 init/main.c                                                          |   14 
 kernel/irq/manage.c                                                  |    6 
 kernel/irq/pm.c                                                      |    8 
 kernel/kprobes.c                                                     |    7 
 kernel/module.c                                                      |   22 +
 kernel/pid.c                                                         |    7 
 kernel/sched/core.c                                                  |   81 +++++
 kernel/sched/cpufreq_schedutil.c                                     |    2 
 kernel/sched/sched.h                                                 |   47 +++
 kernel/trace/ftrace.c                                                |   15 -
 kernel/trace/trace_events.c                                          |    4 
 kernel/trace/trace_hwlat.c                                           |    5 
 lib/devres.c                                                         |   11 
 lib/test_kmod.c                                                      |    2 
 lib/test_lockup.c                                                    |    4 
 mm/cma.c                                                             |   23 -
 mm/hugetlb.c                                                         |   39 +-
 mm/khugepaged.c                                                      |   70 ++--
 mm/memory_hotplug.c                                                  |    5 
 mm/page_counter.c                                                    |    6 
 mm/rmap.c                                                            |    2 
 mm/shuffle.c                                                         |   18 -
 net/compat.c                                                         |    1 
 net/core/sock.c                                                      |   21 +
 net/mac80211/sta_info.c                                              |    2 
 scripts/recordmcount.c                                               |    2 
 security/integrity/ima/ima_policy.c                                  |   15 -
 sound/pci/echoaudio/echoaudio.c                                      |    2 
 sound/soc/tegra/tegra_alc5632.c                                      |    7 
 sound/soc/tegra/tegra_asoc_utils.c                                   |  113 +++----
 sound/soc/tegra/tegra_asoc_utils.h                                   |    1 
 sound/soc/tegra/tegra_max98090.c                                     |   22 -
 sound/soc/tegra/tegra_rt5640.c                                       |   22 -
 sound/soc/tegra/tegra_rt5677.c                                       |    7 
 sound/soc/tegra/tegra_sgtl5000.c                                     |    7 
 sound/soc/tegra/tegra_wm8753.c                                       |   22 -
 sound/soc/tegra/tegra_wm8903.c                                       |   22 -
 sound/soc/tegra/tegra_wm9712.c                                       |    8 
 sound/soc/tegra/trimslice.c                                          |   18 -
 tools/build/Makefile.feature                                         |    2 
 tools/build/feature/Makefile                                         |    2 
 tools/perf/bench/mem-functions.c                                     |   21 -
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                  |   29 --
 tools/perf/util/probe-finder.c                                       |    5 
 tools/testing/selftests/bpf/Makefile                                 |    5 
 tools/testing/selftests/bpf/test_progs.c                             |   33 ++
 tools/testing/selftests/bpf/test_progs.h                             |    2 
 tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c                 |   55 +--
 tools/testing/selftests/seccomp/seccomp_bpf.c                        |    5 
 222 files changed, 1798 insertions(+), 926 deletions(-)

Adrian Hunter (2):
      perf intel-pt: Fix FUP packet state
      perf intel-pt: Fix duplicate branch after CBR

Ahmad Fatoum (3):
      watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options
      watchdog: f71808e_wdt: remove use of wrong watchdog_info option
      watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Alex Deucher (1):
      drm/amdgpu: fix ordering of psp suspend

Alexandru Ardelean (1):
      iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Anand Jain (1):
      btrfs: don't traverse into the seed devices in show_devname

Andrii Nakryiko (1):
      selftests/bpf: Prevent runqslower from racing on building bpftool

Andy Shevchenko (1):
      mfd: dln2: Run event handler loop under spinlock

Aneesh Kumar K.V (3):
      selftests/powerpc: ptrace-pkey: Rename variables to make it easier to follow code
      selftests/powerpc: ptrace-pkey: Update the test to mark an invalid pkey correctly
      selftests/powerpc: ptrace-pkey: Don't update expected UAMOR value

Ansuel Smith (2):
      PCI: qcom: Define some PARF params needed for ipq8064 SoC
      PCI: qcom: Add support for tx term offset for rev 2.1.0

Anton Blanchard (1):
      pseries: Fix 64 bit logical memory block panic

Ashok Raj (1):
      PCI/ATS: Add pci_pri_supported() to check device or associated PF

Bob Peterson (1):
      gfs2: Never call gfs2_block_zero_range with an open transaction

Boris Brezillon (1):
      mtd: rawnand: fsl_upm: Remove unused mtd var

ChangSyun Peng (1):
      md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Chao Yu (2):
      f2fs: compress: fix to avoid memory leak on cc->cpages
      f2fs: compress: fix to update isize when overwriting compressed file

Charles Keepax (1):
      mfd: arizona: Ensure 32k clock is put on driver unbind and error

Chengming Zhou (1):
      ftrace: Setup correct FTRACE_FL_REGS flags for module

Chris Wilson (1):
      drm/i915/gt: Force the GT reset on shutdown

Christian Eggers (1):
      dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Christophe Leroy (2):
      powerpc/ptdump: Fix build failure in hashpagetable.c
      recordmcount: Fix build failure on non arm64

Colin Ian King (3):
      iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
      Input: sentelic - fix error return when fsp_reg_write fails
      fs/ufs: avoid potential u32 multiplication overflow

Coly Li (2):
      bcache: allocate meta data pages as compound pages
      bcache: fix overflow in offset_to_stripe()

Cristian Ciocaltea (1):
      clk: actions: Fix h_clk for Actions S500 SoC

Dafna Hirschfeld (1):
      media: staging: rkisp1: remove macro RKISP1_DIR_SINK_SRC

Dan Carpenter (4):
      md-cluster: Fix potential error pointer dereference in resize_bitmaps()
      vdpa: Fix pointer math bug in vdpasim_get_config()
      drm/vmwgfx: Use correct vmw_legacy_display_unit pointer
      drm/vmwgfx: Fix two list_for_each loop exit tests

Daniel Díaz (1):
      tools build feature: Quote CC and CXX for their arguments

David Hildenbrand (1):
      mm/shuffle: don't move pages between zones and don't read garbage memmaps

David Sterba (3):
      btrfs: allow use of global block reserve for balance item deletion
      btrfs: add missing check for nocow and compression inode flags
      btrfs: fix messages after changing compression level by remount

Denis Efremov (1):
      drm/panfrost: Use kvfree() to free bo->sgts

Dhananjay Phadke (1):
      i2c: iproc: fix race between client unreg and isr

Dilip Kota (1):
      x86/tsr: Fix tsc frequency enumeration bug on Lightning Mountain SoC

Dinghao Liu (1):
      ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Eric Biggers (3):
      fs/minix: set s_maxbytes correctly
      fs/minix: fix block limit check for V1 filesystems
      fs/minix: remove expected error message in block_to_path()

Eric Dumazet (1):
      octeontx2-af: change (struct qmem)->entry_sz from u8 to u16

Eugeniu Rosca (1):
      media: vsp1: dl: Fix NULL pointer dereference on unbind

Ewan D. Milne (1):
      scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport

Filipe Manana (6):
      btrfs: only commit the delayed inode when doing a full fsync
      btrfs: stop incremening log_batch for the log root tree when syncing log
      btrfs: only commit delayed items at fsync if we are logging a directory
      btrfs: remove no longer needed use of log_writers for the log root tree
      btrfs: fix race between page release and a fast fsync
      btrfs: fix memory leaks after failure to lookup checksums during inode logging

Geert Uytterhoeven (1):
      sh: landisk: Add missing initialization of sh_io_port_base

Greg Kroah-Hartman (1):
      Linux 5.7.17

Guenter Roeck (1):
      genirq/PM: Always unlock IRQ descriptor in rearm_wake_irq()

Herbert Xu (3):
      crypto: algif_aead - Only wake up when ctx->more is zero
      crypto: af_alg - Fix regression on empty requests
      crypto: caam - Remove broken arc4 support

Huacai Chen (2):
      irqchip/loongson-liointc: Fix misuse of gc->mask_cache
      MIPS: CPU#0 is not hotpluggable

Hugh Dickins (3):
      khugepaged: collapse_pte_mapped_thp() flush the right range
      khugepaged: collapse_pte_mapped_thp() protect the pmd lock
      khugepaged: retract_page_tables() remember to test exit

Imre Deak (1):
      drm/dp_mst: Fix the DDC I2C device registration of an MST port

Jane Chu (2):
      libnvdimm/security: fix a typo
      libnvdimm/security: ensure sysfs poll thread woke up and fetch updated attr

Jason Gunthorpe (1):
      RDMA/ipoib: Fix ABBA deadlock with ipoib_reap_ah()

Jeff Layton (2):
      ceph: set sec_context xattr on symlink creation
      ceph: handle zero-length feature mask in session messages

Jeffrey Mitchell (1):
      nfs: Fix getxattr kernel panic and memory overflow

Jesper Dangaard Brouer (3):
      selftests/bpf: Test_progs indicate to shell on non-actions
      selftests/bpf: test_progs use another shell exit on non-actions
      selftests/bpf: test_progs avoid minus shell exit codes

Jia He (1):
      mm/memory_hotplug: fix unpaired mem_hotplug_begin/done

Johan Hovold (2):
      USB: serial: ftdi_sio: make process-packet buffer unsigned
      USB: serial: ftdi_sio: clean up receive processing

Johannes Berg (1):
      mac80211: fix misplaced while instead of if

Johannes Thumshirn (2):
      btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
      dm: don't call report zones for more than the user requested

Jonathan Marek (2):
      clk: qcom: gcc: fix sm8150 GPU and NPU clocks
      clk: qcom: clk-alpha-pll: remove unused/incorrect PLL_CAL_VAL

Jonathan McDowell (2):
      net: ethernet: stmmac: Disable hardware multicast filter
      net: stmmac: dwmac1000: provide multicast filter fallback

Josef Bacik (8):
      btrfs: open device without device_list_mutex
      btrfs: move the chunk_mutex in btrfs_read_chunk_tree
      btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases
      btrfs: sysfs: use NOFS for device creation
      btrfs: don't WARN if we abort a transaction with EROFS
      btrfs: don't show full path of bind mounts in subvol=
      btrfs: only search for left_info if there is no right_info in try_merge_free_space
      btrfs: make sure SB_I_VERSION doesn't get unset by remount

Junxiao Bi (1):
      ocfs2: change slot number type s16 to u16

Kai-Heng Feng (1):
      PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken

Kamal Dasu (1):
      mtd: rawnand: brcmnand: ECC error handling on EDU transfers

Kamal Heib (1):
      RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Kees Cook (4):
      pidfd: Add missing sock updates for pidfd_getfd()
      net/compat: Add missing sock updates for SCM_RIGHTS
      selftests/seccomp: Set NNP for TSYNC ESRCH flag test
      module: Correctly truncate sysfs sections output

Kevin Hao (1):
      tracing/hwlat: Honor the tracing_cpumask

Konrad Dybcio (1):
      clk: qcom: gcc-sdm660: Fix up gcc_mss_mnoc_bimc_axi_clk

Krzysztof Kozlowski (1):
      s390/Kconfig: add missing ZCRYPT dependency to VFIO_AP

Krzysztof Sobota (1):
      watchdog: initialize device before misc_register

Liu Yi L (1):
      iommu/vt-d: Enforce PASID devTLB field mask

Liu Ying (1):
      drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: reset hw ts after resume

Lukas Wunner (1):
      driver core: Avoid binding drivers to dead devices

Mansur Alisha Shaik (1):
      media: venus: fix multiple encoder crash

Marius Iacob (1):
      drm: Added orientation quirk for ASUS tablet model T103HAF

Mark Zhang (2):
      RDMA/counter: Only bind user QPs in auto mode
      RDMA/counter: Allow manually bind QPs with different pids to same counter

Martin KaFai Lau (1):
      bpf: selftests: Restore netns after each test

Masami Hiramatsu (3):
      bootconfig: Fix to find the initargs correctly
      perf probe: Fix wrong variable warning when the probe point is not found
      perf probe: Fix memory leakage when the probe point is not found

Max Filippov (2):
      xtensa: add missing exclusive access state management
      xtensa: fix xtensa_pmu_setup prototype

Michael Ellerman (2):
      powerpc: Allow 4224 bytes of stack expansion for the signal frame
      powerpc: Fix circular dependency between percpu.h and mmu.h

Michael S. Tsirkin (1):
      vdpa_sim: init iommu lock

Michal Koutný (1):
      mm/page_counter.c: fix protection usage propagation

Mike Kravetz (2):
      hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem
      cma: don't quit at first error when activating reserved areas

Mike Rapoport (1):
      MIPS: SGI-IP27: always enable NUMA in Kconfig

Mikulas Patocka (1):
      ext2: fix missing percpu_counter_inc

Ming Lei (1):
      dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Muchun Song (1):
      kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Nicolas Saenz Julienne (1):
      clk: bcm2835: Do not use prediv with bcm2711's PLLs

Ondrej Mosnacek (1):
      crypto: algif_aead - fix uninitialized ctx->init

Paul Aurich (1):
      cifs: Fix leak when handling lease break for cached root fid

Paul Cercueil (4):
      pinctrl: ingenic: Enhance support for IRQ_TYPE_EDGE_BOTH
      pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ
      MIPS: qi_lb60: Fix routing to audio amplifier
      drm/ingenic: Fix incorrect assumption about plane->index

Paul Kocialkowski (2):
      media: rockchip: rga: Introduce color fmt macros and refactor CSC mode logic
      media: rockchip: rga: Only set output CSC mode for RGB input

Pavel Machek (1):
      btrfs: fix return value mixup in btrfs_get_extent

Pawan Gupta (1):
      x86/bugs/multihit: Fix mitigation reporting when VMX is not in use

Peter Xu (1):
      mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Qais Yousef (2):
      sched/uclamp: Protect uclamp fast path code with static key
      sched/uclamp: Fix a deadlock when enabling uclamp static key

Qiushi Wu (1):
      platform/chrome: cros_ec_ishtp: Fix a double-unlock issue

Qu Wenruo (6):
      btrfs: free anon block device right after subvolume deletion
      btrfs: don't allocate anonymous block device for user invisible roots
      btrfs: relocation: review the call sites which can be interrupted by signal
      btrfs: avoid possible signal interruption of btrfs_drop_snapshot() on relocation tree
      btrfs: inode: fix NULL pointer dereference if inode doesn't need compression
      btrfs: trim: fix underflow in trim length to prevent access beyond device boundary

Rafael J. Wysocki (1):
      PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Rajat Jain (1):
      PCI: Add device even if driver attach failed

Rayagonda Kokatanur (1):
      pwm: bcm-iproc: handle clk_get_rate() return

Sagi Grimberg (1):
      nvme: fix deadlock in disconnect during scan_work and/or ana_work

Sandeep Raghuraman (1):
      drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume

Scott Mayhew (2):
      nfs: ensure correct writeback errors are returned on close()
      nfs: nfs_file_write() should check for writeback errors

Sebastian Reichel (1):
      rtc: cpcap: fix range

Shaokun Zhang (1):
      arm64: perf: Correct the event index in sysfs

Sibi Sankar (3):
      remoteproc: qcom: q6v5: Update running state before requesting stop
      remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load
      remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load

Sowjanya Komatineni (3):
      ASoC: tegra: Use device managed resource APIs to get the clock
      ASoC: tegra: Add audio mclk parent configuration
      ASoC: tegra: Enable audio mclk during tegra_asoc_utils_init()

Stafford Horne (1):
      openrisc: Fix oops caused when dumping stack

Steve French (1):
      smb3: warn on confusing error scenario with sec=krb5

Steve Longerbeam (2):
      gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers
      gpu: ipu-v3: image-convert: Wait for all EOFs before completing a tile

Steven Rostedt (VMware) (1):
      tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Stylon Wang (1):
      drm/amd/display: Fix dmesg warning from setting abm level

Sudeep Holla (1):
      rtc: pl031: fix set_alarm by adding back call to alarm_irq_enable

Tero Kristo (1):
      watchdog: rti-wdt: balance pm runtime enable calls

Thomas Gleixner (1):
      genirq/affinity: Make affinity setting if activated opt-in

Thomas Hebb (1):
      tools build feature: Use CC and CXX from parent

Tiezhu Yang (2):
      lib/test_lockup.c: fix return value of test_lockup_init()
      test_kmod: avoid potential double free in trigger_config_run_type()

Tom Rix (1):
      btrfs: ref-verify: fix memory leak in add_block_entry

Tomi Valkeinen (2):
      drm/omap: force runtime PM suspend on system suspend
      drm/tidss: fix modeset init for DPI panels

Trond Myklebust (1):
      NFS: Fix flexfiles read failover

Tyler Hicks (1):
      ima: Fail rule parsing when appraise_flag=blacklist is unsupportable

Vincent Whitchurch (1):
      perf bench mem: Always memset source before memcpy

Vladimir Oltean (1):
      devres: keep both device name and resource name in pretty name

Wang Hai (2):
      s390/test_unwind: fix possible memleak in test_unwind()
      net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Wolfram Sang (2):
      i2c: rcar: slave: only send STOP event when we have been addressed
      i2c: rcar: avoid race when unregistering slave

Xin Xiong (1):
      drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi

Xu Wang (1):
      clk: clk-atlas6: fix return value check in atlas6_clk_init()

Yan-Hsuan Chuang (1):
      rtw88: pci: disable aspm for platform inter-op with module parameter

Yishai Hadas (1):
      IB/uverbs: Set IOVA on IB MR in uverbs layer

Yoshihiro Shimoda (1):
      mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete

Zenghui Yu (1):
      irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR

Zhang Rui (1):
      perf/x86/rapl: Fix missing psys sysfs attributes

Zhihao Cheng (1):
      ubifs: Fix wrong orphan node deletion in ubifs_jnl_update|rename

hersen wu (1):
      drm/amd/display: dchubbub p-state warning during surface planes switch

