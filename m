Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51D325C3F3
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgICPBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 11:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgICOFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 10:05:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9561214D8;
        Thu,  3 Sep 2020 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599141775;
        bh=Utye96z3cplfOH7uetE0vHZCKP2EsRixbKg6q4uzMX0=;
        h=From:To:Cc:Subject:Date:From;
        b=mEuWC4HnuoWkxjtSWJoy/A4HD80M4GniEAaXSYljJsPED6App8IcfaBqrd2RFnT1W
         zy88eZ+UWJvL+XuSBZIcWd3WVJglXGlf/GEc6UGhuU2JsItO6sFxd+3E3OCODx1Ehl
         2gdEZjxrIz7END/iZVrhYlVDRqL5GKxbe+62ESeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.62
Date:   Thu,  3 Sep 2020 16:03:06 +0200
Message-Id: <1599141786190175@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.62 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |   13 
 arch/arm/boot/deflate_xip_data.sh                                   |    2 
 arch/arm/boot/dts/ls1021a.dtsi                                      |    2 
 arch/arm64/Makefile                                                 |    3 
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi                          |    2 
 arch/arm64/include/asm/smp.h                                        |    7 
 arch/arm64/kernel/cpu_errata.c                                      |    2 
 arch/arm64/kernel/process.c                                         |   34 +
 arch/arm64/kernel/setup.c                                           |    8 
 arch/arm64/kernel/smp.c                                             |    6 
 arch/arm64/kvm/hyp/switch.c                                         |    2 
 arch/ia64/Makefile                                                  |    2 
 arch/m68k/Makefile                                                  |    8 
 arch/mips/vdso/genvdso.c                                            |   10 
 arch/parisc/Makefile                                                |    2 
 arch/powerpc/kernel/cpu_setup_power.S                               |    2 
 arch/powerpc/perf/core-book3s.c                                     |   23 
 arch/powerpc/platforms/cell/Kconfig                                 |    1 
 arch/powerpc/sysdev/xive/native.c                                   |    2 
 arch/s390/include/asm/numa.h                                        |    1 
 arch/s390/include/asm/topology.h                                    |    2 
 arch/s390/numa/numa.c                                               |    6 
 arch/x86/kernel/smpboot.c                                           |   26 
 block/bfq-cgroup.c                                                  |    2 
 block/bfq-iosched.h                                                 |    1 
 block/bfq-wf2q.c                                                    |   12 
 block/bio.c                                                         |   10 
 block/blk-cgroup.c                                                  |    8 
 block/blk-merge.c                                                   |   13 
 block/blk-mq-sched.c                                                |    9 
 block/blk-mq.c                                                      |   12 
 crypto/af_alg.c                                                     |   13 
 drivers/base/core.c                                                 |   12 
 drivers/base/power/main.c                                           |   16 
 drivers/block/loop.c                                                |   33 -
 drivers/block/null_blk_main.c                                       |    2 
 drivers/block/virtio_blk.c                                          |   31 -
 drivers/cpufreq/intel_pstate.c                                      |   18 
 drivers/devfreq/rk3399_dmc.c                                        |   51 +
 drivers/edac/i7core_edac.c                                          |    4 
 drivers/edac/ie31200_edac.c                                         |   50 +
 drivers/edac/pnd2_edac.c                                            |    2 
 drivers/edac/sb_edac.c                                              |   25 
 drivers/edac/skx_common.c                                           |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                      |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                             |    7 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                              |    6 
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c                           |   20 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   58 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c         |   16 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.h         |   14 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c                   |    9 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c                |   22 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c                |   21 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_hwmgr.c                  |   44 -
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c                |   21 
 drivers/gpu/drm/i915/i915_cmd_parser.c                              |   14 
 drivers/gpu/drm/ingenic/ingenic-drm.c                               |    6 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                             |    2 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                             |    4 
 drivers/gpu/drm/nouveau/nouveau_connector.c                         |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                             |    4 
 drivers/gpu/drm/radeon/radeon_connectors.c                          |   20 
 drivers/gpu/drm/xen/xen_drm_front.c                                 |    2 
 drivers/gpu/drm/xen/xen_drm_front_gem.c                             |    8 
 drivers/gpu/drm/xen/xen_drm_front_kms.c                             |    2 
 drivers/hid/hid-ids.h                                               |    1 
 drivers/hid/hid-quirks.c                                            |    1 
 drivers/hid/i2c-hid/i2c-hid-core.c                                  |   22 
 drivers/hid/usbhid/hiddev.c                                         |    4 
 drivers/hwmon/nct7904.c                                             |    4 
 drivers/i2c/busses/i2c-rcar.c                                       |    1 
 drivers/i2c/i2c-core-base.c                                         |    2 
 drivers/iommu/iova.c                                                |    4 
 drivers/irqchip/irq-stm32-exti.c                                    |   14 
 drivers/media/cec/cec-api.c                                         |    8 
 drivers/media/pci/ttpci/av7110.c                                    |    5 
 drivers/media/platform/davinci/vpif_capture.c                       |    2 
 drivers/media/rc/gpio-ir-tx.c                                       |    7 
 drivers/mfd/intel-lpss-pci.c                                        |   19 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                        |    5 
 drivers/net/ethernet/freescale/gianfar.c                            |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c                       |    2 
 drivers/net/ipvlan/ipvlan_main.c                                    |   27 
 drivers/net/macvlan.c                                               |   21 
 drivers/net/wireless/ath/ath10k/hw.h                                |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c         |    8 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    5 
 drivers/nvme/host/fc.c                                              |    4 
 drivers/nvme/host/multipath.c                                       |   15 
 drivers/pci/controller/dwc/pcie-qcom.c                              |   58 +
 drivers/pci/slot.c                                                  |    6 
 drivers/s390/cio/css.c                                              |    5 
 drivers/scsi/fcoe/fcoe_ctlr.c                                       |    2 
 drivers/scsi/lpfc/lpfc_vport.c                                      |   26 
 drivers/scsi/qla2xxx/qla_gs.c                                       |   18 
 drivers/scsi/qla2xxx/qla_mbx.c                                      |    8 
 drivers/scsi/qla2xxx/qla_nvme.c                                     |    5 
 drivers/scsi/qla2xxx/qla_os.c                                       |    5 
 drivers/scsi/qla2xxx/qla_target.c                                   |    2 
 drivers/scsi/scsi_transport_iscsi.c                                 |    2 
 drivers/scsi/ufs/ufshcd.c                                           |   14 
 drivers/spi/spi-stm32.c                                             |   73 +-
 drivers/target/target_core_internal.h                               |    1 
 drivers/target/target_core_transport.c                              |    7 
 drivers/target/target_core_user.c                                   |    9 
 drivers/target/target_core_xcopy.c                                  |   11 
 drivers/tty/serial/8250/8250_exar.c                                 |   24 
 drivers/tty/serial/8250/8250_port.c                                 |    9 
 drivers/tty/serial/amba-pl011.c                                     |   16 
 drivers/tty/serial/samsung.c                                        |    8 
 drivers/tty/serial/stm32-usart.c                                    |    2 
 drivers/tty/vt/vt.c                                                 |    5 
 drivers/tty/vt/vt_ioctl.c                                           |   12 
 drivers/usb/cdns3/gadget.c                                          |    4 
 drivers/usb/class/cdc-acm.c                                         |   22 
 drivers/usb/core/quirks.c                                           |    7 
 drivers/usb/dwc3/gadget.c                                           |  104 ++-
 drivers/usb/gadget/function/f_ncm.c                                 |   81 ++
 drivers/usb/gadget/function/f_tcm.c                                 |    7 
 drivers/usb/gadget/u_f.h                                            |   38 -
 drivers/usb/host/ohci-exynos.c                                      |    5 
 drivers/usb/host/xhci-debugfs.c                                     |    8 
 drivers/usb/host/xhci-hub.c                                         |   19 
 drivers/usb/host/xhci.c                                             |    3 
 drivers/usb/misc/lvstest.c                                          |    2 
 drivers/usb/misc/sisusbvga/sisusb.c                                 |    2 
 drivers/usb/misc/yurex.c                                            |    2 
 drivers/usb/storage/unusual_devs.h                                  |    2 
 drivers/usb/storage/unusual_uas.h                                   |   14 
 drivers/video/fbdev/core/fbcon.c                                    |   25 
 drivers/video/fbdev/core/fbmem.c                                    |    8 
 drivers/video/fbdev/core/fbsysfs.c                                  |    4 
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c                        |    7 
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c                          |    7 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c                          |    7 
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c                        |    5 
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c                        |    5 
 drivers/video/fbdev/omap2/omapfb/dss/venc.c                         |    7 
 drivers/video/fbdev/ps3fb.c                                         |    5 
 drivers/xen/events/events_base.c                                    |   16 
 fs/binfmt_flat.c                                                    |   20 
 fs/btrfs/ctree.h                                                    |    4 
 fs/btrfs/disk-io.c                                                  |    1 
 fs/btrfs/extent-tree.c                                              |   17 
 fs/btrfs/file.c                                                     |   10 
 fs/btrfs/free-space-cache.c                                         |    2 
 fs/btrfs/inode.c                                                    |   18 
 fs/btrfs/qgroup.c                                                   |   14 
 fs/btrfs/qgroup.h                                                   |    2 
 fs/btrfs/super.c                                                    |    1 
 fs/btrfs/tree-log.c                                                 |  305 +++++-----
 fs/buffer.c                                                         |    9 
 fs/ceph/file.c                                                      |    5 
 fs/ceph/mds_client.c                                                |   14 
 fs/ext4/block_validity.c                                            |    8 
 fs/ext4/super.c                                                     |  175 +++--
 fs/f2fs/f2fs.h                                                      |    4 
 fs/f2fs/inline.c                                                    |   19 
 fs/f2fs/node.c                                                      |    6 
 fs/f2fs/recovery.c                                                  |   10 
 fs/f2fs/super.c                                                     |    5 
 fs/fs-writeback.c                                                   |   83 +-
 fs/hugetlbfs/inode.c                                                |    6 
 fs/io_uring.c                                                       |    9 
 fs/jbd2/transaction.c                                               |   26 
 fs/xfs/libxfs/xfs_trans_inode.c                                     |    2 
 fs/xfs/xfs_icache.c                                                 |    3 
 fs/xfs/xfs_inode.c                                                  |   25 
 include/linux/efi.h                                                 |    4 
 include/linux/fb.h                                                  |    2 
 include/linux/fs.h                                                  |    8 
 include/linux/netfilter_ipv6.h                                      |   18 
 include/trace/events/writeback.h                                    |   13 
 kernel/Makefile                                                     |    2 
 kernel/gen_kheaders.sh                                              |   66 +-
 kernel/irq/matrix.c                                                 |    7 
 kernel/locking/lockdep_proc.c                                       |    2 
 kernel/sched/core.c                                                 |   81 ++
 kernel/sched/cpufreq_schedutil.c                                    |    2 
 kernel/sched/sched.h                                                |   47 +
 kernel/trace/blktrace.c                                             |   12 
 mm/cma.c                                                            |   29 
 mm/mmu_context.c                                                    |    7 
 mm/shuffle.c                                                        |   18 
 mm/vmalloc.c                                                        |    2 
 net/bridge/netfilter/nf_conntrack_bridge.c                          |    8 
 net/can/j1939/transport.c                                           |   15 
 net/core/skbuff.c                                                   |    4 
 net/ipv4/nexthop.c                                                  |    5 
 net/ipv6/ip6_tunnel.c                                               |   10 
 net/ipv6/netfilter.c                                                |    3 
 net/qrtr/qrtr.c                                                     |   20 
 net/sched/act_ct.c                                                  |    2 
 net/sctp/stream.c                                                   |    6 
 net/smc/smc_diag.c                                                  |   16 
 net/tipc/netlink_compat.c                                           |   12 
 scripts/Makefile.lib                                                |   12 
 scripts/Makefile.package                                            |    8 
 scripts/package/buildtar                                            |    6 
 scripts/xz_wrap.sh                                                  |    2 
 sound/pci/cs46xx/cs46xx_lib.c                                       |    2 
 sound/pci/cs46xx/dsp_spos_scb_lib.c                                 |    2 
 sound/pci/hda/hda_codec.c                                           |    2 
 sound/pci/hda/hda_generic.c                                         |    2 
 sound/pci/hda/hda_intel.c                                           |    2 
 sound/pci/hda/patch_hdmi.c                                          |   17 
 sound/pci/hda/patch_realtek.c                                       |   12 
 sound/pci/hda/patch_sigmatel.c                                      |    2 
 sound/pci/ice1712/prodigy192.c                                      |    2 
 sound/pci/oxygen/xonar_dg.c                                         |    2 
 sound/soc/codecs/wm8958-dsp2.c                                      |    4 
 sound/soc/img/img-i2s-in.c                                          |    4 
 sound/soc/img/img-parallel-out.c                                    |    4 
 sound/soc/tegra/tegra30_ahub.c                                      |    4 
 sound/soc/tegra/tegra30_i2s.c                                       |    4 
 sound/usb/quirks-table.h                                            |   34 +
 tools/testing/selftests/net/icmp_redirect.sh                        |    2 
 tools/testing/selftests/powerpc/pmu/ebb/back_to_back_ebbs_test.c    |    2 
 tools/testing/selftests/powerpc/pmu/ebb/cycles_test.c               |    2 
 tools/testing/selftests/powerpc/pmu/ebb/cycles_with_freeze_test.c   |    2 
 tools/testing/selftests/powerpc/pmu/ebb/cycles_with_mmcr2_test.c    |    2 
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c                       |    2 
 tools/testing/selftests/powerpc/pmu/ebb/ebb_on_willing_child_test.c |    2 
 tools/testing/selftests/powerpc/pmu/ebb/lost_exception_test.c       |    1 
 tools/testing/selftests/powerpc/pmu/ebb/multi_counter_test.c        |    7 
 tools/testing/selftests/powerpc/pmu/ebb/multi_ebb_procs_test.c      |    2 
 tools/testing/selftests/powerpc/pmu/ebb/pmae_handling_test.c        |    2 
 tools/testing/selftests/powerpc/pmu/ebb/pmc56_overflow_test.c       |    2 
 231 files changed, 2124 insertions(+), 1013 deletions(-)

Abhishek Sahu (1):
      PCI: qcom: Change duplicate PCI reset to phy reset

Aditya Pakki (5):
      drm/radeon: fix multiple reference count leak
      omapfb: fix multiple reference count leaks due to pm_runtime_get_sync
      drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open
      drm/nouveau: fix reference count leak in nv50_disp_atomic_commit
      drm/nouveau: Fix reference count leak in nouveau_connector_detect

Adrian Hunter (1):
      scsi: ufs: Improve interrupt handling for shared interrupts

Alaa Hleihel (1):
      net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow

Alain Volmat (1):
      spi: stm32: always perform registers configuration prior to transfer

Alan Stern (3):
      USB: yurex: Fix bad gfp argument
      USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D
      usb: storage: Add unusual_uas entry for Sony PSZ drives

Alex Deucher (1):
      drm/amdgpu: Fix buffer overflow in INFO ioctl

Alexander Tsoy (1):
      ALSA: usb-audio: Add capture support for Saffire 6 (USB 1.1)

Alexey Kardashevskiy (2):
      powerpc/xive: Ignore kmemleak false positives
      powerpc/perf: Fix crashes with generic_compat_pmu & BHRB

Alvin Šipraga (1):
      macvlan: validate setting of multiple remote source MAC addresses

Amelie Delaunay (2):
      spi: stm32: fix fifo threshold level in case of short transfer
      spi: stm32: fix stm32_spi_prepare_mbr in case of odd clk_rate

Andrey Konovalov (1):
      efi: provide empty efi_enter_virtual_mode implementation

Andy Shevchenko (4):
      mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs
      mfd: intel-lpss: Add Intel Tiger Lake PCH-H PCI IDs
      i2c: core: Don't fail PRP0001 enumeration when no ID table exist
      USB: gadget: u_f: Unbreak offset calculation in VLAs

Ansuel Smith (2):
      PCI: qcom: Add missing ipq806x clocks in PCIe driver
      PCI: qcom: Add missing reset for ipq806x

Anthony Koo (1):
      drm/amd/display: Switch to immediate mode for updating infopackets

Antonio Borneo (1):
      spi: stm32h7: fix race condition at end of transfer

Arnd Bergmann (1):
      powerpc/spufs: add CONFIG_COREDUMP dependency

Ashok Raj (1):
      x86/hotplug: Silence APIC only after all interrupts are migrated

Athira Rajeev (1):
      powerpc/perf: Fix soft lockups due to missed interrupt accounting

Aurabindo Pillai (1):
      drm/amd/display: Add additional config guards for DCN

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash on ARM during cmd completion

Boris Burkov (1):
      btrfs: detect nocow for swap after snapshot delete

Brooke Basile (2):
      USB: gadget: u_f: add overflow checks to VLA macros
      USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()

Changming Liu (1):
      USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Chao Yu (1):
      f2fs: fix error path in do_recover_data()

Chris Wilson (1):
      locking/lockdep: Fix overflow in presentation of average lock-time

Christophe JAILLET (1):
      usb: gadget: f_tcm: Fix some resource leaks in some error paths

Cong Wang (1):
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Cyril Roelandt (1):
      USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

Dave Chinner (1):
      xfs: Don't allow logging of XFS_ISTALE inodes

David Ahern (1):
      selftests: disable rp_filter for icmp_redirect.sh

David Brazdil (1):
      KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe

David Hildenbrand (1):
      mm/shuffle: don't move pages between zones and don't read garbage memmaps

David Laight (1):
      net: sctp: Fix negotiation of the number of data streams.

Denis Efremov (2):
      kbuild: add variables for compression tools
      kbuild: fix broken builds because of GZIP,BZIP2,LZOP variables

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Dick Kennedy (1):
      scsi: lpfc: Fix shost refcount mismatch when deleting vport

Ding Hui (1):
      xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

Ding Xiang (1):
      drm/xen: fix passing zero to 'PTR_ERR' warning

Dmitry Monakhov (1):
      bfq: fix blkio cgroup leakage v4

Evan Quan (6):
      drm/amd/powerplay: correct Vega20 cached smu feature state
      drm/amd/powerplay: correct UVD/VCE PG state on custom pptable uploading
      drm/amd/pm: correct Vega10 swctf limit setting
      drm/amd/pm: correct Vega12 swctf limit setting
      drm/amd/pm: correct Vega20 swctf limit setting
      drm/amd/pm: correct the thermal alert temperature limit settings

Evgeny Novikov (2):
      media: davinci: vpif_capture: fix potential double free
      USB: lvtest: return proper error code in probe

Filipe Manana (4):
      btrfs: factor out inode items copy loop from btrfs_log_inode()
      btrfs: only commit the delayed inode when doing a full fsync
      btrfs: only commit delayed items at fsync if we are logging a directory
      btrfs: fix space cache memory leak after transaction abort

Florian Westphal (1):
      netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency

Frank van der Linden (1):
      arm64: vdso32: make vdso32 install conditional

George Kennedy (2):
      fbcon: prevent user font height or width change from causing potential out-of-bounds access
      vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()

Greg Kroah-Hartman (1):
      Linux 5.4.62

Hans Verkuil (1):
      cec-api: prevent leaking memory through hole in structure

Hans de Goede (1):
      HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands

Hector Martin (1):
      ALSA: usb-audio: Update documentation comment for MS2109 quirk

Heikki Krogerus (1):
      device property: Fix the secondary firmware node handling in set_primary_fwnode()

Herbert Xu (1):
      crypto: af_alg - Work around empty control messages without MSG_MORE

Holger Assmann (1):
      serial: stm32: avoid kernel warning on absence of optional IRQ

Hou Pu (1):
      null_blk: fix passing of REQ_FUA flag in null_handle_rq

Ikjoon Jang (1):
      HID: quirks: add NOGET quirk for Logitech GROUP

Jan Kara (6):
      ext4: don't BUG on inconsistent journal feature
      ext4: handle error of ext4_setup_system_zone() on remount
      ext4: correctly restore system zone info when remount fails
      writeback: Protect inode->i_io_list with inode->i_lock
      writeback: Avoid skipping inode writeback
      writeback: Fix sync livelock due to b_dirty_time processing

Jason Baron (2):
      EDAC/ie31200: Fallback if host bridge device is already initialized
      hwmon: (nct7904) Correct divide by 0

Javed Hasan (1):
      scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Jia-Ju Bai (1):
      media: pci: ttpci: av7110: fix possible buffer overflow caused by bad DMA value in debiirq()

Jiansong Chen (1):
      drm/amdgpu/gfx10: refine mgcg setting

Jing Xiangfeng (1):
      scsi: iscsi: Do not put host in iscsi_set_flashnode_param()

Josef Bacik (1):
      btrfs: check the right error variable in btrfs_del_dir_entries_in_log

Kai-Heng Feng (5):
      ALSA: hda/hdmi: Add quirk to force connectivity
      ALSA: hda/realtek: Fix pin default on Intel NUC 8 Rugged
      ALSA: hda/hdmi: Use force connectivity quirk on another HP desktop
      xhci: Do warm-reset when both CAS and XDEV_RESUME are set
      USB: quirks: Add no-lpm quirk for another Raydium touchscreen

Kaige Li (1):
      ALSA: hda: Add support for Loongson 7A1000 controller

Kefeng Wang (1):
      arm64: Fix __cpu_logical_map undefined issue

Keith Busch (1):
      block: fix get_max_io_size()

Li Guifu (1):
      f2fs: fix use-after-free issue

Li Jun (1):
      usb: host: xhci: fix ep context print mismatch in debugfs

Luis Chamberlain (1):
      blktrace: ensure our debugfs dir exists

Lukas Czerner (3):
      jbd2: make sure jh have b_transaction set in refile/unfile_buffer
      ext4: handle read only external journal device
      ext4: handle option set by mount flags correctly

Lukas Wunner (2):
      serial: pl011: Fix oops on -EPROBE_DEFER
      serial: pl011: Don't leak amba_ports entry on driver register error

Mahesh Bandewar (1):
      ipvlan: fix device features

Marc Zyngier (3):
      PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
      arm64: Move handling of erratum 1418040 into C code
      arm64: Allow booting of late CPUs affected by erratum 1418040

Marcos Paulo de Souza (1):
      btrfs: reset compression level for lzo on remount

Mark Tomlinson (1):
      gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Martin Wilck (1):
      nvme: multipath: round-robin: fix single non-optimized path case

Masahiro Yamada (5):
      kheaders: remove unneeded 'cat' command piped to 'head' / 'tail'
      kheaders: optimize md5sum calculation for in-tree builds
      kheaders: optimize header copy for in-tree builds
      kheaders: remove the last bashism to allow sh to run it
      kheaders: explain why include/config/autoconf.h is excluded from md5sum

Matthew Wilcox (Oracle) (1):
      block: Fix page_is_mergeable() for compound pages

Mauro Carvalho Chehab (2):
      EDAC: sb_edac: get rid of unused vars
      EDAC: skx_common: get rid of unused type var

Max Filippov (1):
      binfmt_flat: revert "binfmt_flat: don't offset the data start"

Miaohe Lin (1):
      net: Fix potential wrong skb->protocol in skb_vlan_untag()

Michael Ellerman (1):
      powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()

Mika Kuoppala (1):
      drm/i915: Fix cmd parser desc matching with masks

Mike Christie (2):
      scsi: target: Fix xcopy sess release leak
      scsi: fcoe: Fix I/O path allocation

Mike Kravetz (2):
      hugetlbfs: prevent filesystem stacking of hugetlbfs
      cma: don't quit at first error when activating reserved areas

Mike Pozulp (1):
      ALSA: hda/realtek: Add model alc298-samsung-headphone

Mikita Lipski (1):
      drm/amd/display: Trigger modesets on MST DSC connectors

Ming Lei (5):
      block: respect queue limit of max discard segment
      block: virtio_blk: fix handling single range discard request
      blk-mq: insert request not through ->queue_rq into sw/scheduler queue
      block: loop: set discard granularity and alignment for block device backed loop
      blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART

Navid Emamdoost (4):
      drm/amdgpu: fix ref count leak in amdgpu_driver_open_kms
      drm/amd/display: fix ref count leak in amdgpu_drm_ioctl
      drm/amdgpu: fix ref count leak in amdgpu_display_crtc_set_config
      drm/amdgpu/display: fix ref count leak when pm_runtime_get_sync fails

Necip Fazil Yildiran (1):
      net: qrtr: fix usage of idr in port assignment to socket

Nicholas Kazlauskas (1):
      drm/amd/powerplay: Fix hardmins not being sent to SMU for RV

Nicolas Saenz Julienne (1):
      brcmfmac: Set timeout value when configuring power save

Nikolay Aleksandrov (1):
      net: nexthop: don't allow empty NHA_GROUP

Nikolay Borisov (1):
      btrfs: make btrfs_qgroup_check_reserved_leak take btrfs_inode

Oleksandr Andrushchenko (1):
      drm/xen-front: Fix misused IS_ERR_OR_NULL checks

Oleksij Rempel (1):
      can: j1939: transport: j1939_xtp_rx_dat_one(): compare own packets to detect corruptions

Paul Cercueil (2):
      gpu/drm: ingenic: Use the plane's src_[x,y] to configure DMA length
      drm/ingenic: Fix incorrect assumption about plane->index

Peilin Ye (2):
      net/smc: Prevent kernel-infoleak in __smc_diag_dump()
      HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Peng Fan (1):
      mips/vdso: Fix resource leaks in genvdso.c

Peter Zijlstra (1):
      mm: fix kthread_use_mm() vs TLB invalidate

Qais Yousef (2):
      sched/uclamp: Protect uclamp fast path code with static key
      sched/uclamp: Fix a deadlock when enabling uclamp static key

Qiushi Wu (5):
      ASoC: img: Fix a reference count leak in img_i2s_in_set_fmt
      ASoC: img-parallel-out: Fix a reference count leak
      ASoC: tegra: Fix reference count leaks.
      drm/amdkfd: Fix reference count leaks.
      PCI: Fix pci_create_slot() reference count leak

Qu Wenruo (1):
      btrfs: file: reserve qgroup space after the hole punch range is locked

Quinn Tran (2):
      scsi: qla2xxx: Fix login timeout
      scsi: qla2xxx: Fix null pointer access during disconnect from subsystem

Rafael J. Wysocki (2):
      cpufreq: intel_pstate: Fix EPP setting via sysfs in active mode
      PM: sleep: core: Fix the handling of pending runtime resume requests

Randy Dunlap (1):
      ALSA: pci: delete repeated words in comments

Reto Schneider (1):
      rtlwifi: rtl8192cu: Prevent leaking urb

Rob Clark (1):
      drm/msm/adreno: fix updating ring fence

Robin Murphy (1):
      iommu/iova: Don't BUG on invalid PFNs

Sasha Levin (3):
      usb: cdns3: gadget: always zeroed TRB buffer when enable endpoint
      s390/numa: set node distance to LOCAL_DISTANCE
      mm/vunmap: add cond_resched() in vunmap_pmd_range

Saurav Kashyap (2):
      scsi: qla2xxx: Check if FW supports MQ before enabling
      Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"

Sean Young (1):
      media: gpio-ir-tx: improve precision of transmitted signal due to scheduling

Sergey Senozhatsky (1):
      serial: 8250: change lock order in serial8250_do_startup()

Shay Agroskin (1):
      net: ena: Make missed_tx stat incremental

Stanley Chu (2):
      scsi: ufs: Fix possible infinite loop in ufshcd_hold
      scsi: ufs: Clean up completed request without interrupt notification

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep

Stylon Wang (1):
      drm/amd/display: Fix dmesg warning from setting abm level

Sumera Priyadarsini (1):
      net: gianfar: Add of_node_put() before goto statement

Sylwester Nawrocki (1):
      ASoC: wm8994: Avoid attempts to read unreadable registers

Tamseel Shams (1):
      serial: samsung: Removes the IRQ not found warning

Tang Bin (1):
      usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

Tetsuo Handa (2):
      vt: defer kfree() of vc_screenbuf in vc_do_resize()
      fbmem: pull fbcon_update_vcs() out of fb_set_var()

Thinh Nguyen (4):
      usb: uas: Add quirk for PNY Pro Elite
      usb: dwc3: gadget: Don't setup more than requested
      usb: dwc3: gadget: Fix handling ZLP
      usb: dwc3: gadget: Handle ZLP for sg requests

Thomas Gleixner (2):
      XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.
      genirq/matrix: Deal with the sillyness of for_each_cpu() on UP

Tianjia Zhang (1):
      nvme-fc: Fix wrong return value in __nvme_fc_init_request()

Tobias Schramm (1):
      spi: stm32: clear only asserted irq flags on interrupt

Tom Rix (1):
      USB: cdc-acm: rework notification_buffer resizing

Tony Luck (1):
      EDAC/{i7core,sb,pnd2,skx}: Fix error event severity

Valmer Huhn (1):
      serial: 8250_exar: Fix number of ports for Commtech PCIe cards

Vineeth Vijayan (1):
      s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Wolfram Sang (1):
      i2c: rcar: in slave mode, clear NACK earlier

Xianting Tian (1):
      fs: prevent BUG_ON in submit_bh_wbc()

Xin Yin (1):
      io_uring: Fix NULL pointer dereference in io_sq_wq_submit_work()

Xiubo Li (2):
      ceph: fix potential mdsc use-after-free crash
      ceph: do not access the kiocb after aio requests

Yangbo Lu (1):
      ARM: dts: ls1021a: output PPS signal on FIPER2

Yangtao Li (2):
      PM / devfreq: rk3399_dmc: Add missing of_node_put()
      PM / devfreq: rk3399_dmc: Disable devfreq-event device when fails

Yufen Yu (1):
      blkcg: fix memleak for iolatency

Yunfeng Ye (1):
      mm/cma.c: switch to bitmap_zalloc() for cma bitmap allocation

Zhi Chen (1):
      Revert "ath10k: fix DMA related firmware crashes on multiple devices"

qiuguorui1 (1):
      irqchip/stm32-exti: Avoid losing interrupts due to clearing pending bits by mistake

zhangyi (F) (1):
      jbd2: abort journal if free a async write error metadata buffer

