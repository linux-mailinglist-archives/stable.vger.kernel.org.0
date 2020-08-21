Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FB624D44F
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgHULn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 07:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbgHULjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 07:39:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A91012177B;
        Fri, 21 Aug 2020 11:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598009946;
        bh=0C2/73/gCRORKzItH10mObAShM9kl3czMVMl64XKJTo=;
        h=From:To:Cc:Subject:Date:From;
        b=LOxn5hLwX18iPm+1zTFrR66PV2S8znwHqiSclFbf4NkZXiibragU9w70w04aZQTF1
         EzsohimE9L8vPV3EYe8gbT+YmpFsaP7itYs8crHQ/U7FSQfCifSSzyveX6IMKIeiHD
         9lo46g0NmPrIpHcFNCy0B6ydp/vUcufsSEEpwy0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.141
Date:   Fri, 21 Aug 2020 13:39:14 +0200
Message-Id: <15980099541141@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.141 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt |    2 
 Makefile                                                             |    2 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts              |    6 
 arch/mips/kernel/topology.c                                          |    2 
 arch/openrisc/kernel/stacktrace.c                                    |   18 ++
 arch/powerpc/include/asm/percpu.h                                    |    4 
 arch/powerpc/mm/fault.c                                              |    7 
 arch/powerpc/platforms/pseries/hotplug-memory.c                      |    2 
 arch/sh/boards/mach-landisk/setup.c                                  |    3 
 arch/x86/kernel/apic/vector.c                                        |    4 
 arch/xtensa/kernel/perf_event.c                                      |    2 
 drivers/base/dd.c                                                    |    4 
 drivers/clk/sirf/clk-atlas6.c                                        |    2 
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c                     |    5 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                       |    6 
 drivers/gpu/drm/imx/imx-ldb.c                                        |    7 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                  |    8 -
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                                  |    5 
 drivers/gpu/ipu-v3/ipu-image-convert.c                               |   58 ++-----
 drivers/i2c/busses/i2c-rcar.c                                        |   15 +-
 drivers/iio/dac/ad5592r-base.c                                       |    4 
 drivers/infiniband/ulp/ipoib/ipoib.h                                 |    2 
 drivers/infiniband/ulp/ipoib/ipoib_ib.c                              |   67 +++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c                            |    2 
 drivers/input/mouse/sentelic.c                                       |    2 
 drivers/iommu/omap-iommu-debug.c                                     |    3 
 drivers/irqchip/irq-gic-v3-its.c                                     |    5 
 drivers/md/bcache/bcache.h                                           |    2 
 drivers/md/bcache/bset.c                                             |    2 
 drivers/md/bcache/btree.c                                            |    2 
 drivers/md/bcache/journal.c                                          |    4 
 drivers/md/bcache/super.c                                            |    2 
 drivers/md/bcache/writeback.c                                        |   14 +
 drivers/md/bcache/writeback.h                                        |   19 ++
 drivers/md/dm-rq.c                                                   |    3 
 drivers/md/raid5.c                                                   |    3 
 drivers/media/platform/rockchip/rga/rga-hw.c                         |   29 ++-
 drivers/media/platform/rockchip/rga/rga-hw.h                         |    5 
 drivers/media/platform/vsp1/vsp1_dl.c                                |    2 
 drivers/mfd/arizona-core.c                                           |   18 ++
 drivers/mfd/dln2.c                                                   |    4 
 drivers/mmc/host/renesas_sdhi_internal_dmac.c                        |   18 +-
 drivers/net/ethernet/qualcomm/emac/emac.c                            |   17 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                  |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c                 |    3 
 drivers/pci/bus.c                                                    |    6 
 drivers/pci/controller/dwc/pcie-qcom.c                               |   41 +++++
 drivers/pci/hotplug/acpiphp_glue.c                                   |   14 +
 drivers/pci/probe.c                                                  |   52 +++++++
 drivers/pci/quirks.c                                                 |    5 
 drivers/pci/setup-bus.c                                              |   45 ------
 drivers/pwm/pwm-bcm-iproc.c                                          |    9 -
 drivers/remoteproc/qcom_q6v5.c                                       |    2 
 drivers/scsi/lpfc/lpfc_nvmet.c                                       |    2 
 drivers/usb/serial/ftdi_sio.c                                        |   37 ++---
 drivers/watchdog/f71808e_wdt.c                                       |   13 +
 drivers/watchdog/watchdog_dev.c                                      |   18 +-
 fs/btrfs/disk-io.c                                                   |   13 +
 fs/btrfs/free-space-cache.c                                          |    4 
 fs/btrfs/inode.c                                                     |    4 
 fs/btrfs/ref-verify.c                                                |    2 
 fs/btrfs/super.c                                                     |   35 ++--
 fs/btrfs/tree-log.c                                                  |    8 -
 fs/btrfs/volumes.c                                                   |   21 ++
 fs/cifs/smb2misc.c                                                   |   73 +++++++---
 fs/cifs/smb2pdu.c                                                    |    2 
 fs/ext2/ialloc.c                                                     |    3 
 fs/minix/inode.c                                                     |   12 -
 fs/minix/itree_v1.c                                                  |   12 -
 fs/minix/itree_v2.c                                                  |   13 -
 fs/minix/minix.h                                                     |    1 
 fs/nfs/nfs4proc.c                                                    |    2 
 fs/nfs/nfs4xdr.c                                                     |    6 
 fs/ocfs2/ocfs2.h                                                     |    4 
 fs/ocfs2/suballoc.c                                                  |    4 
 fs/ocfs2/super.c                                                     |    4 
 fs/ufs/super.c                                                       |    2 
 include/linux/intel-iommu.h                                          |    4 
 include/linux/irq.h                                                  |   13 +
 include/linux/pci.h                                                  |    3 
 include/net/sock.h                                                   |    4 
 kernel/irq/manage.c                                                  |    6 
 kernel/kprobes.c                                                     |    7 
 kernel/module.c                                                      |   22 ++-
 kernel/trace/ftrace.c                                                |   15 +-
 kernel/trace/trace_events.c                                          |    4 
 kernel/trace/trace_hwlat.c                                           |    5 
 lib/test_kmod.c                                                      |    2 
 mm/khugepaged.c                                                      |   22 +--
 mm/page_counter.c                                                    |    6 
 net/compat.c                                                         |    1 
 net/core/sock.c                                                      |   21 ++
 net/mac80211/sta_info.c                                              |    2 
 sound/pci/echoaudio/echoaudio.c                                      |    2 
 tools/build/Makefile.feature                                         |    2 
 tools/build/feature/Makefile                                         |    2 
 tools/perf/bench/mem-functions.c                                     |   21 +-
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c                  |   21 --
 tools/testing/selftests/powerpc/ptrace/ptrace-pkey.c                 |   55 +++----
 99 files changed, 698 insertions(+), 406 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix FUP packet state

Ahmad Fatoum (3):
      watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options
      watchdog: f71808e_wdt: remove use of wrong watchdog_info option
      watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Alexandru Ardelean (1):
      iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Anand Jain (1):
      btrfs: don't traverse into the seed devices in show_devname

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

Bjorn Helgaas (1):
      PCI: Probe bridge window attributes once at enumeration-time

ChangSyun Peng (1):
      md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Charles Keepax (1):
      mfd: arizona: Ensure 32k clock is put on driver unbind and error

Chengming Zhou (1):
      ftrace: Setup correct FTRACE_FL_REGS flags for module

Christian Eggers (1):
      dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Colin Ian King (3):
      iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
      Input: sentelic - fix error return when fsp_reg_write fails
      fs/ufs: avoid potential u32 multiplication overflow

Coly Li (2):
      bcache: allocate meta data pages as compound pages
      bcache: fix overflow in offset_to_stripe()

Dan Carpenter (2):
      drm/vmwgfx: Use correct vmw_legacy_display_unit pointer
      drm/vmwgfx: Fix two list_for_each loop exit tests

Daniel Díaz (1):
      tools build feature: Quote CC and CXX for their arguments

David Sterba (1):
      btrfs: fix messages after changing compression level by remount

Dinghao Liu (1):
      ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Eric Biggers (3):
      fs/minix: set s_maxbytes correctly
      fs/minix: fix block limit check for V1 filesystems
      fs/minix: remove expected error message in block_to_path()

Eugeniu Rosca (1):
      media: vsp1: dl: Fix NULL pointer dereference on unbind

Ewan D. Milne (1):
      scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport

Filipe Manana (1):
      btrfs: fix memory leaks after failure to lookup checksums during inode logging

Geert Uytterhoeven (1):
      sh: landisk: Add missing initialization of sh_io_port_base

Greg Kroah-Hartman (1):
      Linux 4.19.141

Huacai Chen (1):
      MIPS: CPU#0 is not hotpluggable

Hugh Dickins (1):
      khugepaged: retract_page_tables() remember to test exit

Jason Gunthorpe (1):
      RDMA/ipoib: Fix ABBA deadlock with ipoib_reap_ah()

Jeffrey Mitchell (1):
      nfs: Fix getxattr kernel panic and memory overflow

Johan Hovold (2):
      USB: serial: ftdi_sio: make process-packet buffer unsigned
      USB: serial: ftdi_sio: clean up receive processing

Johannes Berg (1):
      mac80211: fix misplaced while instead of if

Jonathan McDowell (2):
      net: ethernet: stmmac: Disable hardware multicast filter
      net: stmmac: dwmac1000: provide multicast filter fallback

Josef Bacik (2):
      btrfs: open device without device_list_mutex
      btrfs: only search for left_info if there is no right_info in try_merge_free_space

Junxiao Bi (1):
      ocfs2: change slot number type s16 to u16

Kai-Heng Feng (1):
      PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken

Kamal Heib (1):
      RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Kees Cook (2):
      net/compat: Add missing sock updates for SCM_RIGHTS
      module: Correctly truncate sysfs sections output

Kevin Hao (1):
      tracing/hwlat: Honor the tracing_cpumask

Krzysztof Sobota (1):
      watchdog: initialize device before misc_register

Liu Yi L (1):
      iommu/vt-d: Enforce PASID devTLB field mask

Liu Ying (1):
      drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Lukas Wunner (1):
      driver core: Avoid binding drivers to dead devices

Marius Iacob (1):
      drm: Added orientation quirk for ASUS tablet model T103HAF

Max Filippov (1):
      xtensa: fix xtensa_pmu_setup prototype

Michael Ellerman (2):
      powerpc: Allow 4224 bytes of stack expansion for the signal frame
      powerpc: Fix circular dependency between percpu.h and mmu.h

Michal Koutný (1):
      mm/page_counter.c: fix protection usage propagation

Mikulas Patocka (1):
      ext2: fix missing percpu_counter_inc

Ming Lei (1):
      dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Muchun Song (1):
      kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Paul Aurich (1):
      cifs: Fix leak when handling lease break for cached root fid

Paul Kocialkowski (2):
      media: rockchip: rga: Introduce color fmt macros and refactor CSC mode logic
      media: rockchip: rga: Only set output CSC mode for RGB input

Pavel Machek (1):
      btrfs: fix return value mixup in btrfs_get_extent

Qu Wenruo (2):
      btrfs: free anon block device right after subvolume deletion
      btrfs: don't allocate anonymous block device for user invisible roots

Rafael J. Wysocki (1):
      PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Rajat Jain (1):
      PCI: Add device even if driver attach failed

Rayagonda Kokatanur (1):
      pwm: bcm-iproc: handle clk_get_rate() return

Sandeep Raghuraman (1):
      drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume

Sibi Sankar (1):
      remoteproc: qcom: q6v5: Update running state before requesting stop

Stafford Horne (1):
      openrisc: Fix oops caused when dumping stack

Steve French (1):
      smb3: warn on confusing error scenario with sec=krb5

Steve Longerbeam (1):
      gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Steven Rostedt (VMware) (1):
      tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Thomas Gleixner (1):
      genirq/affinity: Make affinity setting if activated opt-in

Thomas Hebb (1):
      tools build feature: Use CC and CXX from parent

Tiezhu Yang (1):
      test_kmod: avoid potential double free in trigger_config_run_type()

Tom Rix (1):
      btrfs: ref-verify: fix memory leak in add_block_entry

Tomasz Maciej Nowak (1):
      arm64: dts: marvell: espressobin: add ethernet alias

Vincent Whitchurch (1):
      perf bench mem: Always memset source before memcpy

Wang Hai (1):
      net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Wolfram Sang (2):
      i2c: rcar: slave: only send STOP event when we have been addressed
      i2c: rcar: avoid race when unregistering slave

Xu Wang (1):
      clk: clk-atlas6: fix return value check in atlas6_clk_init()

Yoshihiro Shimoda (1):
      mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete

