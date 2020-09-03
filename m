Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6625C38A
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgICOxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 10:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbgICOMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 10:12:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E02B20E65;
        Thu,  3 Sep 2020 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599141754;
        bh=3W4LmiLdjUpUX7ZuVTTgTSG2Qxld+wJCMLcxAsOwaW8=;
        h=From:To:Cc:Subject:Date:From;
        b=Ts4/TlcGEfsiHO9sjZUGEZhqp7GopJff/gY9MOnAtE+22Bk8AKUGx/qIbLk5PqTmz
         JEO5ttcb62/CGbl71nXtqkgcOrVkxa0GUUDWd+O3UH1Vr4TcWMRdtTOwXuOgwpYmeH
         hdQrTms/Tnta9vWYQimhGZbirIHcnIckG5gHbSB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.196
Date:   Thu,  3 Sep 2020 16:02:50 +0200
Message-Id: <15991417701990@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.196 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi                          |    2 
 arch/arm64/kvm/hyp/switch.c                                         |    2 
 arch/mips/vdso/genvdso.c                                            |   10 +
 arch/powerpc/kernel/cpu_setup_power.S                               |    2 
 arch/powerpc/perf/core-book3s.c                                     |    4 
 arch/powerpc/platforms/cell/Kconfig                                 |    1 
 arch/powerpc/sysdev/xive/native.c                                   |    2 
 drivers/base/core.c                                                 |   12 -
 drivers/base/power/main.c                                           |   16 +
 drivers/block/null_blk.c                                            |    2 
 drivers/char/tpm/tpm-chip.c                                         |    9 -
 drivers/char/tpm/tpm.h                                              |    6 
 drivers/char/tpm/tpm2-space.c                                       |   26 +--
 drivers/char/tpm/tpmrm-dev.c                                        |    2 
 drivers/edac/ie31200_edac.c                                         |   50 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                      |   16 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                             |    7 
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c                           |   20 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c                         |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                             |    4 
 drivers/gpu/drm/radeon/radeon_connectors.c                          |   20 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                                  |   22 +-
 drivers/hid/usbhid/hiddev.c                                         |    4 
 drivers/i2c/busses/i2c-rcar.c                                       |    1 
 drivers/iommu/iova.c                                                |    4 
 drivers/md/dm-table.c                                               |   10 -
 drivers/media/cec/cec-api.c                                         |    8 
 drivers/media/pci/ttpci/av7110.c                                    |    5 
 drivers/media/platform/davinci/vpif_capture.c                       |    2 
 drivers/media/rc/gpio-ir-tx.c                                       |    7 
 drivers/mfd/intel-lpss-pci.c                                        |    3 
 drivers/net/ethernet/freescale/gianfar.c                            |    4 
 drivers/net/ipvlan/ipvlan_main.c                                    |   27 ++-
 drivers/net/wireless/ath/ath10k/hw.h                                |    2 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    5 
 drivers/nvme/host/fc.c                                              |    4 
 drivers/pci/slot.c                                                  |    6 
 drivers/s390/cio/css.c                                              |    5 
 drivers/scsi/fcoe/fcoe_ctlr.c                                       |    2 
 drivers/scsi/lpfc/lpfc_vport.c                                      |   26 ---
 drivers/scsi/scsi_transport_iscsi.c                                 |    2 
 drivers/scsi/ufs/ufshcd.c                                           |   14 +
 drivers/spi/spi-stm32.c                                             |    3 
 drivers/target/target_core_user.c                                   |    9 -
 drivers/tty/serial/8250/8250_exar.c                                 |   24 ++
 drivers/tty/serial/8250/8250_port.c                                 |    9 -
 drivers/tty/serial/amba-pl011.c                                     |   16 +
 drivers/tty/serial/samsung.c                                        |    8 
 drivers/tty/vt/vt.c                                                 |    5 
 drivers/tty/vt/vt_ioctl.c                                           |   12 +
 drivers/usb/class/cdc-acm.c                                         |   22 +-
 drivers/usb/core/quirks.c                                           |    2 
 drivers/usb/gadget/function/f_ncm.c                                 |   81 ++++++++-
 drivers/usb/gadget/function/f_tcm.c                                 |    7 
 drivers/usb/gadget/u_f.h                                            |   38 +++-
 drivers/usb/host/ohci-exynos.c                                      |    5 
 drivers/usb/host/xhci-hub.c                                         |   19 +-
 drivers/usb/misc/lvstest.c                                          |    2 
 drivers/usb/misc/sisusbvga/sisusb.c                                 |    2 
 drivers/usb/misc/yurex.c                                            |    2 
 drivers/usb/storage/unusual_devs.h                                  |    2 
 drivers/usb/storage/unusual_uas.h                                   |   14 +
 drivers/video/fbdev/core/fbcon.c                                    |   25 ++-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c                        |    7 
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c                          |    7 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c                          |    7 
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c                        |    5 
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c                        |    5 
 drivers/video/fbdev/omap2/omapfb/dss/venc.c                         |    7 
 drivers/xen/events/events_base.c                                    |   16 -
 fs/btrfs/disk-io.c                                                  |    1 
 fs/btrfs/free-space-cache.c                                         |    2 
 fs/btrfs/tree-log.c                                                 |   10 -
 fs/buffer.c                                                         |    9 +
 fs/ceph/mds_client.c                                                |   14 +
 fs/ext4/super.c                                                     |   75 +++++----
 fs/f2fs/super.c                                                     |    5 
 fs/fs-writeback.c                                                   |   83 +++++-----
 fs/jbd2/transaction.c                                               |   26 +++
 include/linux/efi.h                                                 |    4 
 include/linux/fs.h                                                  |    8 
 include/linux/overflow.h                                            |   73 ++++++++
 include/trace/events/writeback.h                                    |   13 -
 kernel/locking/lockdep_proc.c                                       |    2 
 kernel/trace/blktrace.c                                             |   12 +
 net/core/skbuff.c                                                   |    4 
 net/ipv6/ip6_tunnel.c                                               |   10 +
 net/tipc/netlink_compat.c                                           |   12 +
 sound/pci/cs46xx/cs46xx_lib.c                                       |    2 
 sound/pci/cs46xx/dsp_spos_scb_lib.c                                 |    2 
 sound/pci/hda/hda_codec.c                                           |    2 
 sound/pci/hda/hda_generic.c                                         |    2 
 sound/pci/hda/patch_sigmatel.c                                      |    2 
 sound/pci/ice1712/prodigy192.c                                      |    2 
 sound/pci/oxygen/xonar_dg.c                                         |    2 
 sound/soc/tegra/tegra30_ahub.c                                      |    4 
 sound/soc/tegra/tegra30_i2s.c                                       |    4 
 sound/usb/quirks-table.h                                            |    4 
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
 112 files changed, 825 insertions(+), 341 deletions(-)

Aditya Pakki (4):
      drm/radeon: fix multiple reference count leak
      omapfb: fix multiple reference count leaks due to pm_runtime_get_sync
      drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open
      drm/nouveau: Fix reference count leak in nouveau_connector_detect

Adrian Hunter (1):
      scsi: ufs: Improve interrupt handling for shared interrupts

Alan Stern (2):
      USB: yurex: Fix bad gfp argument
      usb: storage: Add unusual_uas entry for Sony PSZ drives

Alex Deucher (1):
      drm/amdgpu: Fix buffer overflow in INFO ioctl

Alexey Kardashevskiy (1):
      powerpc/xive: Ignore kmemleak false positives

Amelie Delaunay (1):
      spi: stm32: fix stm32_spi_prepare_mbr in case of odd clk_rate

Andrey Konovalov (1):
      efi: provide empty efi_enter_virtual_mode implementation

Andy Shevchenko (2):
      mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs
      USB: gadget: u_f: Unbreak offset calculation in VLAs

Arnd Bergmann (1):
      powerpc/spufs: add CONFIG_COREDUMP dependency

Athira Rajeev (1):
      powerpc/perf: Fix soft lockups due to missed interrupt accounting

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash on ARM during cmd completion

Brooke Basile (2):
      USB: gadget: u_f: add overflow checks to VLA macros
      USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()

Changming Liu (1):
      USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Chris Wilson (1):
      locking/lockdep: Fix overflow in presentation of average lock-time

Christophe JAILLET (1):
      usb: gadget: f_tcm: Fix some resource leaks in some error paths

Cong Wang (1):
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Cyril Roelandt (1):
      USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

David Brazdil (1):
      KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Dick Kennedy (1):
      scsi: lpfc: Fix shost refcount mismatch when deleting vport

Evgeny Novikov (2):
      media: davinci: vpif_capture: fix potential double free
      USB: lvtest: return proper error code in probe

Filipe Manana (1):
      btrfs: fix space cache memory leak after transaction abort

George Kennedy (2):
      fbcon: prevent user font height or width change from causing potential out-of-bounds access
      vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()

Greg Kroah-Hartman (1):
      Linux 4.14.196

Hans Verkuil (1):
      cec-api: prevent leaking memory through hole in structure

Hans de Goede (1):
      HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands

Hector Martin (1):
      ALSA: usb-audio: Update documentation comment for MS2109 quirk

Heikki Krogerus (1):
      device property: Fix the secondary firmware node handling in set_primary_fwnode()

Hou Pu (1):
      null_blk: fix passing of REQ_FUA flag in null_handle_rq

Jan Kara (4):
      ext4: don't BUG on inconsistent journal feature
      writeback: Protect inode->i_io_list with inode->i_lock
      writeback: Avoid skipping inode writeback
      writeback: Fix sync livelock due to b_dirty_time processing

Jarkko Sakkinen (1):
      tpm: Unify the mismatching TPM space buffer sizes

Jason Baron (1):
      EDAC/ie31200: Fallback if host bridge device is already initialized

Javed Hasan (1):
      scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Jia-Ju Bai (1):
      media: pci: ttpci: av7110: fix possible buffer overflow caused by bad DMA value in debiirq()

Jing Xiangfeng (1):
      scsi: iscsi: Do not put host in iscsi_set_flashnode_param()

Josef Bacik (1):
      btrfs: check the right error variable in btrfs_del_dir_entries_in_log

Kai-Heng Feng (2):
      xhci: Do warm-reset when both CAS and XDEV_RESUME are set
      USB: quirks: Add no-lpm quirk for another Raydium touchscreen

Kees Cook (1):
      overflow.h: Add allocation size calculation helpers

Li Guifu (1):
      f2fs: fix use-after-free issue

Luis Chamberlain (1):
      blktrace: ensure our debugfs dir exists

Lukas Czerner (1):
      jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Lukas Wunner (2):
      serial: pl011: Fix oops on -EPROBE_DEFER
      serial: pl011: Don't leak amba_ports entry on driver register error

Mahesh Bandewar (1):
      ipvlan: fix device features

Mark Tomlinson (1):
      gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Miaohe Lin (1):
      net: Fix potential wrong skb->protocol in skb_vlan_untag()

Michael Ellerman (1):
      powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()

Navid Emamdoost (4):
      drm/amdgpu: fix ref count leak in amdgpu_driver_open_kms
      drm/amd/display: fix ref count leak in amdgpu_drm_ioctl
      drm/amdgpu: fix ref count leak in amdgpu_display_crtc_set_config
      drm/amdgpu/display: fix ref count leak when pm_runtime_get_sync fails

Peilin Ye (1):
      HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Peng Fan (1):
      mips/vdso: Fix resource leaks in genvdso.c

Qiushi Wu (3):
      ASoC: tegra: Fix reference count leaks.
      drm/amdkfd: Fix reference count leaks.
      PCI: Fix pci_create_slot() reference count leak

Rafael J. Wysocki (1):
      PM: sleep: core: Fix the handling of pending runtime resume requests

Randy Dunlap (1):
      ALSA: pci: delete repeated words in comments

Reto Schneider (1):
      rtlwifi: rtl8192cu: Prevent leaking urb

Robin Murphy (1):
      iommu/iova: Don't BUG on invalid PFNs

Sean Young (1):
      media: gpio-ir-tx: improve precision of transmitted signal due to scheduling

Sergey Senozhatsky (1):
      serial: 8250: change lock order in serial8250_do_startup()

Stanley Chu (2):
      scsi: ufs: Fix possible infinite loop in ufshcd_hold
      scsi: ufs: Clean up completed request without interrupt notification

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep

Sumera Priyadarsini (1):
      net: gianfar: Add of_node_put() before goto statement

Tamseel Shams (1):
      serial: samsung: Removes the IRQ not found warning

Tang Bin (1):
      usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

Tetsuo Handa (1):
      vt: defer kfree() of vc_screenbuf in vc_do_resize()

Thinh Nguyen (1):
      usb: uas: Add quirk for PNY Pro Elite

Thomas Gleixner (1):
      XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.

Tianjia Zhang (1):
      nvme-fc: Fix wrong return value in __nvme_fc_init_request()

Tom Rix (1):
      USB: cdc-acm: rework notification_buffer resizing

Valmer Huhn (1):
      serial: 8250_exar: Fix number of ports for Commtech PCIe cards

Vineeth Vijayan (1):
      s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Wolfram Sang (1):
      i2c: rcar: in slave mode, clear NACK earlier

Xianting Tian (1):
      fs: prevent BUG_ON in submit_bh_wbc()

Xiubo Li (1):
      ceph: fix potential mdsc use-after-free crash

Zhi Chen (1):
      Revert "ath10k: fix DMA related firmware crashes on multiple devices"

zhangyi (F) (1):
      jbd2: abort journal if free a async write error metadata buffer

