Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD32A7EAE
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgKEMfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 07:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbgKEMfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 07:35:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D972078E;
        Thu,  5 Nov 2020 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604579736;
        bh=1Ch+GXcN7s3qK+twHipRfe6OGwU0xQiJnTxNzLc9/+I=;
        h=From:To:Cc:Subject:Date:From;
        b=F3YZYWcbquwYE7zsM5VgLXzjPNglA27jYysmsVW1UD4GMyS5ed6Av4498vLDN+/ZZ
         gHqFRB1x1Efxtq8Wg5Ac0U5qGHu73jST7l54adYCm1jX4k+K69JklZ9yMLtpmFxQb1
         xccghD+ufujfTsHGgDAMd6T0BYL6I9/2sksJuyQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.75
Date:   Thu,  5 Nov 2020 13:36:23 +0100
Message-Id: <16045797832150@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.75 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt             |    8 
 Documentation/media/uapi/v4l/colorspaces-defs.rst           |    9 
 Documentation/media/uapi/v4l/colorspaces-details.rst        |    5 
 Makefile                                                    |    2 
 arch/Kconfig                                                |    7 
 arch/arc/boot/dts/axc001.dtsi                               |    2 
 arch/arc/boot/dts/axc003.dtsi                               |    2 
 arch/arc/boot/dts/axc003_idu.dtsi                           |    2 
 arch/arc/boot/dts/vdk_axc003.dtsi                           |    2 
 arch/arc/boot/dts/vdk_axc003_idu.dtsi                       |    2 
 arch/arc/kernel/perf_event.c                                |   27 
 arch/arm/Kconfig                                            |    2 
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts               |    1 
 arch/arm/boot/dts/omap4.dtsi                                |    2 
 arch/arm/boot/dts/omap443x.dtsi                             |   10 
 arch/arm/boot/dts/s5pv210.dtsi                              |  163 +---
 arch/arm/kernel/hw_breakpoint.c                             |  100 ++
 arch/arm/plat-samsung/Kconfig                               |    1 
 arch/arm64/Kconfig.platforms                                |    1 
 arch/arm64/boot/dts/renesas/ulcb.dtsi                       |    1 
 arch/arm64/include/asm/kvm_host.h                           |    1 
 arch/arm64/include/asm/numa.h                               |    3 
 arch/arm64/kernel/topology.c                                |   32 
 arch/arm64/kvm/sys_regs.c                                   |    6 
 arch/arm64/mm/numa.c                                        |    6 
 arch/ia64/kernel/Makefile                                   |    2 
 arch/ia64/kernel/kprobes.c                                  |   77 --
 arch/mips/dec/setup.c                                       |    9 
 arch/powerpc/Kconfig                                        |   14 
 arch/powerpc/include/asm/drmem.h                            |    4 
 arch/powerpc/include/asm/mmu_context.h                      |    2 
 arch/powerpc/kernel/head_32.S                               |    2 
 arch/powerpc/kernel/rtas.c                                  |  153 ++++
 arch/powerpc/kernel/sysfs.c                                 |   42 -
 arch/powerpc/kernel/traps.c                                 |    2 
 arch/powerpc/kvm/book3s_hv.c                                |    6 
 arch/powerpc/platforms/powermac/sleep.S                     |    9 
 arch/powerpc/platforms/powernv/opal-elog.c                  |   33 
 arch/powerpc/platforms/powernv/smp.c                        |    2 
 arch/powerpc/platforms/pseries/hotplug-memory.c             |   43 -
 arch/riscv/include/uapi/asm/auxvec.h                        |    3 
 arch/s390/boot/head.S                                       |   21 
 arch/s390/kernel/time.c                                     |  118 ++-
 arch/sparc/kernel/smp_64.c                                  |   65 -
 arch/um/kernel/sigio.c                                      |    6 
 arch/x86/events/amd/ibs.c                                   |   38 -
 arch/x86/events/intel/core.c                                |    2 
 arch/x86/include/asm/msr-index.h                            |    1 
 arch/x86/kernel/unwind_orc.c                                |    9 
 drivers/acpi/acpi_dbg.c                                     |    3 
 drivers/acpi/acpi_extlog.c                                  |    6 
 drivers/acpi/button.c                                       |   13 
 drivers/acpi/ec.c                                           |   10 
 drivers/acpi/hmat/hmat.c                                    |    3 
 drivers/acpi/numa.c                                         |    2 
 drivers/acpi/video_detect.c                                 |    9 
 drivers/ata/sata_nv.c                                       |    2 
 drivers/base/core.c                                         |    4 
 drivers/base/power/runtime.c                                |    5 
 drivers/block/nbd.c                                         |    2 
 drivers/block/xen-blkback/blkback.c                         |   22 
 drivers/block/xen-blkback/xenbus.c                          |    5 
 drivers/bus/fsl-mc/mc-io.c                                  |    7 
 drivers/clk/ti/clockdomain.c                                |    2 
 drivers/cpufreq/acpi-cpufreq.c                              |    3 
 drivers/cpufreq/sti-cpufreq.c                               |    6 
 drivers/dma/dma-jz4780.c                                    |    7 
 drivers/extcon/extcon-ptn5150.c                             |    8 
 drivers/firmware/arm_scmi/base.c                            |    2 
 drivers/firmware/arm_scmi/clock.c                           |    2 
 drivers/firmware/arm_scmi/common.h                          |    2 
 drivers/firmware/arm_scmi/driver.c                          |    8 
 drivers/firmware/arm_scmi/perf.c                            |    2 
 drivers/firmware/arm_scmi/reset.c                           |    4 
 drivers/firmware/arm_scmi/sensors.c                         |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                  |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                     |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                      |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c   |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    7 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c               |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c |    4 
 drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c             |    4 
 drivers/gpu/drm/amd/display/dc/os_types.h                   |    2 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c            |    2 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c    |   12 
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c               |    9 
 drivers/gpu/drm/i915/i915_drv.h                             |    6 
 drivers/gpu/drm/ttm/ttm_bo.c                                |    2 
 drivers/hid/wacom_wac.c                                     |    4 
 drivers/hwtracing/coresight/coresight-priv.h                |    3 
 drivers/hwtracing/coresight/coresight.c                     |   62 -
 drivers/i2c/busses/i2c-imx.c                                |   24 
 drivers/iio/adc/rcar-gyroadc.c                              |   21 
 drivers/iio/adc/ti-adc0832.c                                |   11 
 drivers/iio/adc/ti-adc12138.c                               |   13 
 drivers/iio/gyro/itg3200_buffer.c                           |   15 
 drivers/iio/light/si1145.c                                  |   19 
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                     |    1 
 drivers/input/serio/hil_mlc.c                               |   21 
 drivers/input/serio/hp_sdc_mlc.c                            |    8 
 drivers/leds/leds-bcm6328.c                                 |    2 
 drivers/leds/leds-bcm6358.c                                 |    2 
 drivers/md/md-bitmap.c                                      |    2 
 drivers/md/raid5.c                                          |    4 
 drivers/media/i2c/imx274.c                                  |    8 
 drivers/media/pci/tw5864/tw5864-video.c                     |    6 
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c             |    7 
 drivers/media/usb/uvc/uvc_ctrl.c                            |   27 
 drivers/memory/emif.c                                       |   33 
 drivers/message/fusion/mptscsih.c                           |   13 
 drivers/mmc/host/sdhci-acpi.c                               |   37 +
 drivers/mmc/host/sdhci-of-esdhc.c                           |   11 
 drivers/mmc/host/sdhci-pci-core.c                           |  154 ++++
 drivers/mmc/host/sdhci.c                                    |    6 
 drivers/mmc/host/via-sdmmc.c                                |    3 
 drivers/mtd/ubi/wl.c                                        |   13 
 drivers/net/can/flexcan.c                                   |   30 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    6 
 drivers/net/ethernet/mellanox/mlxsw/core.c                  |    3 
 drivers/net/wan/hdlc_fr.c                                   |   98 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                    |    8 
 drivers/net/wireless/ath/ath10k/sdio.c                      |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c     |   10 
 drivers/net/xen-netback/common.h                            |   15 
 drivers/net/xen-netback/interface.c                         |   61 +
 drivers/net/xen-netback/netback.c                           |   11 
 drivers/net/xen-netback/rx.c                                |   13 
 drivers/nvme/host/rdma.c                                    |    1 
 drivers/pci/pci-acpi.c                                      |   10 
 drivers/power/supply/bq27xxx_battery.c                      |    6 
 drivers/power/supply/test_power.c                           |    6 
 drivers/rpmsg/qcom_glink_native.c                           |    6 
 drivers/rtc/rtc-rx8010.c                                    |   24 
 drivers/scsi/qla2xxx/qla_target.c                           |   13 
 drivers/spi/spi-sprd.c                                      |    2 
 drivers/staging/comedi/drivers/cb_pcidas.c                  |    1 
 drivers/staging/fieldbus/anybuss/arcx-anybus.c              |    2 
 drivers/staging/octeon/ethernet-mdio.c                      |    6 
 drivers/staging/octeon/ethernet-rx.c                        |   34 
 drivers/staging/octeon/ethernet.c                           |    9 
 drivers/tty/vt/keyboard.c                                   |   39 -
 drivers/tty/vt/vt_ioctl.c                                   |   32 
 drivers/uio/uio.c                                           |    4 
 drivers/usb/class/cdc-acm.c                                 |   12 
 drivers/usb/class/cdc-acm.h                                 |    3 
 drivers/usb/dwc3/core.c                                     |   15 
 drivers/usb/dwc3/core.h                                     |    1 
 drivers/usb/dwc3/dwc3-pci.c                                 |    3 
 drivers/usb/dwc3/ep0.c                                      |   27 
 drivers/usb/dwc3/gadget.c                                   |   60 +
 drivers/usb/dwc3/gadget.h                                   |    1 
 drivers/usb/host/fsl-mph-dr-of.c                            |    9 
 drivers/usb/host/xhci-pci.c                                 |   17 
 drivers/usb/host/xhci.c                                     |    7 
 drivers/usb/host/xhci.h                                     |    1 
 drivers/usb/misc/adutux.c                                   |    1 
 drivers/usb/typec/tcpm/tcpm.c                               |    8 
 drivers/vhost/vringh.c                                      |    9 
 drivers/video/fbdev/pvr2fb.c                                |    2 
 drivers/w1/masters/mxc_w1.c                                 |   14 
 drivers/watchdog/rdc321x_wdt.c                              |    5 
 drivers/xen/events/events_2l.c                              |    9 
 drivers/xen/events/events_base.c                            |  422 +++++++++++-
 drivers/xen/events/events_fifo.c                            |   83 +-
 drivers/xen/events/events_internal.h                        |   20 
 drivers/xen/evtchn.c                                        |    7 
 drivers/xen/pvcalls-back.c                                  |   76 +-
 drivers/xen/xen-pciback/pci_stub.c                          |   14 
 drivers/xen/xen-pciback/pciback.h                           |   12 
 drivers/xen/xen-pciback/pciback_ops.c                       |   48 +
 drivers/xen/xen-pciback/xenbus.c                            |    2 
 drivers/xen/xen-scsiback.c                                  |   23 
 fs/9p/vfs_file.c                                            |    4 
 fs/btrfs/ctree.c                                            |    6 
 fs/btrfs/ctree.h                                            |    2 
 fs/btrfs/delayed-inode.c                                    |    3 
 fs/btrfs/dev-replace.c                                      |    7 
 fs/btrfs/reada.c                                            |   47 +
 fs/btrfs/send.c                                             |  201 ++++-
 fs/btrfs/tree-checker.c                                     |   35 
 fs/btrfs/tree-log.c                                         |    8 
 fs/btrfs/volumes.c                                          |   17 
 fs/btrfs/volumes.h                                          |    1 
 fs/buffer.c                                                 |   16 
 fs/cachefiles/rdwr.c                                        |    3 
 fs/ceph/addr.c                                              |    2 
 fs/cifs/inode.c                                             |   13 
 fs/exec.c                                                   |   17 
 fs/ext4/inode.c                                             |   11 
 fs/ext4/resize.c                                            |    4 
 fs/ext4/super.c                                             |    6 
 fs/f2fs/checkpoint.c                                        |   10 
 fs/f2fs/dir.c                                               |    8 
 fs/f2fs/f2fs.h                                              |    2 
 fs/f2fs/node.c                                              |    2 
 fs/f2fs/segment.c                                           |   12 
 fs/gfs2/incore.h                                            |    1 
 fs/gfs2/ops_fstype.c                                        |   40 -
 fs/gfs2/super.c                                             |    1 
 fs/gfs2/sys.c                                               |    5 
 fs/nfs/namespace.c                                          |   12 
 fs/nfs/nfs4_fs.h                                            |    8 
 fs/nfs/nfs4file.c                                           |    3 
 fs/nfs/nfs4proc.c                                           |   90 +-
 fs/nfs/nfs4trace.h                                          |    1 
 fs/nfsd/nfsproc.c                                           |   16 
 fs/ubifs/debug.c                                            |    1 
 fs/ubifs/journal.c                                          |    6 
 fs/ubifs/orphan.c                                           |    2 
 fs/ubifs/super.c                                            |   44 -
 fs/ubifs/tnc.c                                              |    3 
 fs/ubifs/xattr.c                                            |    2 
 fs/udf/super.c                                              |   21 
 fs/xfs/libxfs/xfs_bmap.c                                    |   19 
 fs/xfs/xfs_rtalloc.c                                        |   10 
 include/linux/hil_mlc.h                                     |    2 
 include/linux/usb/pd.h                                      |    1 
 include/uapi/linux/btrfs_tree.h                             |   14 
 include/uapi/linux/nfs4.h                                   |    3 
 include/uapi/linux/videodev2.h                              |   17 
 include/xen/events.h                                        |   29 
 init/Kconfig                                                |    3 
 kernel/bpf/verifier.c                                       |    4 
 kernel/debug/debug_core.c                                   |   22 
 kernel/futex.c                                              |    4 
 kernel/seccomp.c                                            |   38 -
 kernel/trace/ring_buffer.c                                  |    8 
 lib/scatterlist.c                                           |    2 
 net/9p/trans_fd.c                                           |    2 
 net/ceph/messenger.c                                        |    5 
 net/sunrpc/xprt.c                                           |    6 
 samples/bpf/xdpsock_user.c                                  |    1 
 tools/perf/util/print_binary.c                              |    2 
 tools/testing/selftests/bpf/progs/test_sysctl_prog.c        |    4 
 tools/testing/selftests/x86/fsgsbase.c                      |   68 +
 236 files changed, 2912 insertions(+), 1212 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Add LTR support for some Intel BYT based controllers

Alain Volmat (1):
      cpufreq: sti-cpufreq: add stih418 support

Alex Hung (1):
      ACPI: video: use ACPI backlight for HP 635 Notebook

Alexander Sverdlin (2):
      staging: octeon: repair "fixed-link" support
      staging: octeon: Drop on uncorrectable alignment or FCS error

Alok Prasad (1):
      RDMA/qedr: Fix memory leak in iWARP CM

Amit Cohen (1):
      mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Anand Jain (2):
      btrfs: fix replace of seed device
      btrfs: improve device scanning messages

Anant Thazhemadam (2):
      net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
      gfs2: add validation checks for size of superblock

Andrew Donnellan (1):
      powerpc/rtas: Restrict RTAS requests from userspace

Andrey Grodzovsky (1):
      drm/amd/display: Avoid MST manager resource leak.

Andy Lutomirski (2):
      selftests/x86/fsgsbase: Reap a forgotten child
      selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS

Andy Shevchenko (2):
      device property: Keep secondary firmware node secondary by type
      device property: Don't clear secondary pointer for shared primary firmware node

Aneesh Kumar K.V (2):
      powerpc/drmem: Make lmb_size 64 bit
      powerpc/memhotplug: Make lmb size 64bit

Antonio Borneo (1):
      drm/bridge/synopsys: dsi: add support for non-continuous HS clock

Ashish Sangwan (1):
      NFS: fix nfs_path in case of a rename retry

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart

Bartosz Golaszewski (1):
      rtc: rx8010: don't modify the global rtc ops

Ben Hutchings (1):
      ACPI / extlog: Check for RDMSR failure

Benjamin Coddington (1):
      NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE

Chao Leng (1):
      nvme-rdma: fix crash when connect rejected

Chao Yu (2):
      f2fs: fix uninit-value in f2fs_lookup
      f2fs: fix to check segment boundary during SIT page readahead

Chris Lew (1):
      rpmsg: glink: Use complete_all for open states

Chris Wilson (1):
      drm/i915: Force VT'd workarounds when running as a guest OS

Christian König (1):
      drm/amdgpu: increase the reserved VM size to 2MB

Christophe Leroy (1):
      powerpc/powermac: Fix low_sleep_handler with KUAP and KUEP

Chuck Lever (2):
      SUNRPC: Mitigate cond_resched() in xprt_transmit()
      NFSD: Add missing NFSv2 .pc_func methods

Dan Carpenter (1):
      memory: emif: Remove bogus debugfs error handling

Daniel W. S. Almeida (1):
      media: uvcvideo: Fix dereference of out-of-bound list iterator

Daniel Xu (1):
      btrfs: tree-checker: validate number of chunk stripes and parity

Darrick J. Wong (2):
      xfs: fix realtime bitmap/summary file truncation when growing rt volume
      xfs: don't free rt blocks when we're doing a REMAP bunmapi call

Dave Airlie (1):
      drm/ttm: fix eviction valuable range check.

Dave Wysochanski (1):
      NFS4: Fix oops when copy_file_range is attempted with NFS4.0 source

Denis Efremov (1):
      btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()

Diana Craciun (1):
      bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Dinghao Liu (1):
      ext4: fix error handling code in add_new_gdb

Douglas Anderson (2):
      ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses
      kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

Douglas Gilbert (1):
      sgl_alloc_order: fix memory leak

Eric Biggers (1):
      ext4: fix leaking sysfs kobject after failed mount

Etienne Carriere (1):
      firmware: arm_scmi: Fix ARCH_COLD_RESET

Evan Quan (2):
      drm/amdgpu: correct the gpu reset handling for job != NULL case
      drm/amd/pm: increase mclk switch threshold to 200 us

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest

Fangzhi Zuo (1):
      drm/amd/display: HDMI remote sink need mode validation for Linux

Filipe Manana (5):
      btrfs: reschedule if necessary when logging directory items
      btrfs: send, orphanize first all conflicting inodes when processing references
      btrfs: send, recompute reference path after orphanization of a directory
      btrfs: fix use-after-free on readahead extent after failure to create it
      btrfs: fix readahead hang and use-after-free after removing a device

Frank Wunderlich (1):
      arm: dts: mt7623: add missing pause for switchport

Greg Kroah-Hartman (1):
      Linux 5.4.75

Hans Verkuil (2):
      media: videodev2.h: RGB BT2020 and HSV are always full range
      media: imx274: fix frame interval handling

Hans de Goede (1):
      media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect

Helge Deller (2):
      scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()
      hil/parisc: Disable HIL driver when it gets stuck

Ian Abbott (1):
      staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Ilya Dryomov (1):
      libceph: clear con->out_msg on Policy::stateful_server faults

Jaegeuk Kim (1):
      f2fs: handle errors of f2fs_get_meta_page_nofail

Jamie Iles (2):
      gfs2: use-after-free in sysfs deregistration
      ACPI: debug: don't allow debugging when ACPI is disabled

Jan Kara (3):
      ext4: Detect already used quota file early
      fs: Don't invalidate page buffers in block_write_full_page()
      udf: Fix memory leak when mounting

Jann Horn (1):
      seccomp: Make duplicate listener detection non-racy

Jason Gerecke (1):
      HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery

Jay Cornwall (1):
      drm/amdkfd: Use same SQ prefetch setting as amdgpu

Jerome Brunet (1):
      usb: cdc-acm: fix cooldown mechanism

Jing Xiangfeng (1):
      staging: fieldbus: anybuss: jump to correct label in an error path

Jiri Olsa (1):
      perf python scripting: Fix printable strings in python3 scripts

Jiri Slaby (3):
      x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels
      vt: keyboard, simplify vt_kdgkbsent
      vt: keyboard, extend func_buf_lock to readers

Jisheng Zhang (2):
      mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true
      arm64: berlin: Select DW_APB_TIMER_OF

Joakim Zhang (1):
      can: flexcan: disable clocks during stop mode

Joel Stanley (1):
      powerpc: Warn about use of smt_snooze_delay

Johannes Berg (1):
      um: change sigio_spinlock to a mutex

John Ogness (1):
      printk: reduce LOG_BUF_SHIFT range for H8300

Jonathan Cameron (6):
      ACPI: Add out of bounds and numa_off protections to pxm_to_node()
      ACPI: HMAT: Fix handling of changes from ACPI 6.2 to ACPI 6.3
      iio:light:si1145: Fix timestamp alignment and prevent data leak.
      iio:adc:ti-adc0832 Fix alignment issue with timestamp
      iio:adc:ti-adc12138 Fix alignment issue with timestamp
      iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Josef Bacik (1):
      btrfs: cleanup cow block on error

Juergen Gross (13):
      xen/events: avoid removing an event channel while handling it
      xen/events: add a proper barrier to 2-level uevent unmasking
      xen/events: fix race in evtchn_fifo_unmask()
      xen/events: add a new "late EOI" evtchn framework
      xen/blkback: use lateeoi irq binding
      xen/netback: use lateeoi irq binding
      xen/scsiback: use lateeoi irq binding
      xen/pvcallsback: use lateeoi irq binding
      xen/pciback: use lateeoi irq binding
      xen/events: switch user event channels to lateeoi model
      xen/events: use a common cpu hotplug hook for event channels
      xen/events: defer eoi in case of excessive number of events
      xen/events: block rogue events for some time

Kan Liang (1):
      perf/x86/intel: Fix Ice Lake event constraint table

Kim Phillips (2):
      perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()
      perf/x86/amd/ibs: Fix raw sample data accumulation

Krzysztof Kozlowski (11):
      power: supply: bq27xxx: report "not charging" on all types
      ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings
      ARM: dts: s5pv210: move fixed clocks under root node
      ARM: dts: s5pv210: move PMU node out of clock controller
      ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node
      spi: sprd: Release DMA channel also on probe deferral
      extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips
      ia64: fix build error with !COREDUMP
      i2c: imx: Fix external abort on interrupt in exit paths
      ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
      ARM: s3c24xx: fix missing system reset

Lang Dai (1):
      uio: free uio id after uio file node is freed

Li Jun (3):
      usb: dwc3: core: add phy cleanup for probe error handling
      usb: dwc3: core: don't trigger runtime pm when remove driver
      usb: typec: tcpm: reset hard_reset_count for any disconnect

Linu Cherian (1):
      coresight: Make sysfs functional on topologies with per core sink

Linus Torvalds (1):
      tty: make FONTX ioctl use the tty pointer they were actually passed

Lukas Wunner (1):
      PCI/ACPI: Whitelist hotplug ports for D3 if power managed by ACPI

Luo Meng (1):
      ext4: fix invalid inode checksum

Maciej W. Rozycki (1):
      MIPS: DEC: Restore bootmem reservation for firmware working memory area

Madhav Chauhan (1):
      drm/amdgpu: don't map BO in reserved region

Madhuparna Bhowmik (2):
      mmc: via-sdmmc: Fix data race bug
      drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Magnus Karlsson (1):
      samples/bpf: Fix possible deadlock in xdpsock

Mahesh Salgaonkar (1):
      powerpc/powernv/elog: Fix race while processing OPAL error log event.

Marc Zyngier (1):
      KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Marek Behún (1):
      leds: bcm6328, bcm6358: use devres LED registering function

Martin Fuzzey (1):
      w1: mxc_w1: Fix timeout resolution problem leading to bus error

Masami Hiramatsu (1):
      ia64: kprobes: Use generic kretprobe trampoline handler

Mateusz Nosek (1):
      futex: Fix incorrect should_fail_futex() handling

Matthew Wilcox (Oracle) (3):
      ceph: promote to unsigned long long before shifting
      9P: Cast to loff_t before multiplying
      cachefiles: Handle readpage error correctly

Michael Chan (1):
      bnxt_en: Log unknown link speed appropriately.

Michael Neuling (1):
      powerpc: Fix undetected data corruption with P9N DD2.1 VSX CI load emulation

Michael Walle (1):
      mmc: sdhci-of-esdhc: set timeout to max before tuning

Nadezda Lutovinova (1):
      drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly

Nicholas Piggin (3):
      mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race
      powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
      sparc64: remove mm_cpumask clearing to fix kthread_use_mm race

Olga Kornievskaia (1):
      NFSv4.2: support EXCHGID4_FLAG_SUPP_FENCE_OPS 4.2 EXCHANGE_ID flag

Oliver Neukum (1):
      USB: adutux: fix debugging

Oliver O'Halloran (1):
      powerpc/powernv/smp: Fix spurious DBG() warning

Paul Cercueil (1):
      dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Peter Chen (1):
      usb: xhci: omit duplicate actions when suspending a runtime suspended host.

Qiujun Huang (1):
      ring-buffer: Return 0 on success from ring_buffer_resize()

Qu Wenruo (2):
      btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode
      btrfs: tree-checker: fix false alert caused by legacy btrfs root item

Quinn Tran (1):
      scsi: qla2xxx: Fix crash on session cleanup with unload

Rafael J. Wysocki (2):
      ACPI: EC: PM: Flush EC work unconditionally after wakeup
      ACPI: EC: PM: Drop ec_no_wakeup check from acpi_ec_dispatch_gpe()

Ran Wang (1):
      usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Raul E Rangel (1):
      mmc: sdhci-acpi: AMDI0040: Set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Raymond Tan (1):
      usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality

Richard Weinberger (1):
      ubifs: journal: Make sure to not dirty twice for auth nodes

Ronnie Sahlberg (1):
      cifs: handle -EINTR in cifs_setattr

Sandeep Singh (1):
      usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC

Sascha Hauer (1):
      ata: sata_nv: Fix retrieving of active qcs

Sathishkumar Muruganandam (1):
      ath10k: fix VHT NSS calculation when STBC is enabled

Song Liu (1):
      md/raid5: fix oops during stripe resizing

Stefano Garzarella (1):
      vringh: fix __vringh_iov() when riov and wiov are different

Sudeep Holla (1):
      firmware: arm_scmi: Add missing Rx size re-initialisation

Sven Schnelle (1):
      s390/stp: add locking to sysfs functions

Takashi Iwai (2):
      drm/amd/display: Don't invoke kgdb_breakpoint() unconditionally
      drm/amd/display: Fix kernel panic by dal_gpio_open() error

Tero Kristo (1):
      clk: ti: clockdomain: fix static checker warning

Thinh Nguyen (4):
      usb: dwc3: ep0: Fix ZLP for OUT ep0 requests
      usb: dwc3: gadget: Check MPS of the request length
      usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
      usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command

Tobias Jordan (1):
      iio: adc: gyroadc: fix leak of device node iterator

Tom Rix (2):
      video: fbdev: pvr2fb: initialize variables
      media: tw5864: check status of tw5864_frameinterval_get

Tony Lindgren (1):
      ARM: dts: omap4: Fix sgx clock rate for 4430

Valentin Schneider (1):
      arm64: topology: Stop using MPIDR for topology information

Vasily Gorbik (1):
      s390/startup: avoid save_area_sync overflow

Vineet Gupta (1):
      ARC: perf: redo the pct irq missing in device-tree handling

Wei Huang (1):
      acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

Wen Gong (1):
      ath10k: start recovery process when payload length exceeds max htc length for sdio

Wesley Chalmers (1):
      drm/amd/display: Increase timeout for DP Disable

Wright Feng (1):
      brcmfmac: Fix warning message after dongle setup failed

Xia Jiang (1):
      media: platform: Improve queue set up flow for bug fixing

Xiang Chen (1):
      PM: runtime: Remove link state checks in rpm_get/put_supplier()

Xie He (1):
      drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Xiongfeng Wang (1):
      power: supply: test_power: add missing newlines when printing parameters by sysfs

Xiubo Li (1):
      nbd: make the config put is called before the notifying the waiter

Yonghong Song (2):
      bpf: Permit map_ptr arithmetic with opcode add and offset 0
      selftests/bpf: Define string const as global for test_sysctl_prog.c

Yoshihiro Shimoda (1):
      arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes

Zhang Qilong (1):
      f2fs: add trace exit in exception path

Zhao Heming (1):
      md/bitmap: md_bitmap_get_counter returns wrong blocks

Zhen Lei (1):
      ARC: [dts] fix the errors detected by dtbs_check

Zhengyuan Liu (1):
      arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Zhihao Cheng (6):
      ubifs: dent: Fix some potential memory leaks while iterating entries
      ubifs: xattr: Fix some potential memory leaks while iterating entries
      ubifs: Fix a memleak after dumping authentication mount options
      ubifs: Don't parse authentication mount options in remount process
      ubifs: mount_ubifs: Release authentication resource in error handling path
      ubi: check kthread_should_stop() after the setting of task state

Zong Li (1):
      riscv: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO

dmitry.torokhov@gmail.com (1):
      ACPI: button: fix handling lid state changes when input device closed

