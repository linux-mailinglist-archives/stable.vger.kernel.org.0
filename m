Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A8725C3BA
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgICO5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 10:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbgICOK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 10:10:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDA8208CA;
        Thu,  3 Sep 2020 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599141735;
        bh=R8U59+ZTxDrjtZexI9A/2GznRQiz979wQ3yR1ESwHfc=;
        h=From:To:Cc:Subject:Date:From;
        b=MvNLHUEaTe36IJIYCbaueRekrgaTuXciGN/DbvbDZggy9v7qHtSRVx+yF3KAJY6yv
         eW9L3VdvJ+VtbaBOOAT73xUuSQWp0mgKWVXdl7Q9ba38xeYTK0A2YrMaGU+QnmD8XJ
         CU7LCTB0U3Kchf7PPwHjRcKWA0WUXdwID84G16yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.235
Date:   Thu,  3 Sep 2020 16:02:37 +0200
Message-Id: <1599141757110214@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.235 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/mips/vdso/genvdso.c                                            |   10 +
 arch/powerpc/platforms/cell/Kconfig                                 |    1 
 arch/powerpc/platforms/pseries/ras.c                                |    1 
 drivers/base/core.c                                                 |   12 -
 drivers/base/power/main.c                                           |   16 +
 drivers/edac/ie31200_edac.c                                         |   50 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                      |   16 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                             |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c                           |   20 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c                         |    4 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c                             |    4 
 drivers/gpu/drm/radeon/radeon_connectors.c                          |   20 +-
 drivers/hid/usbhid/hiddev.c                                         |    4 
 drivers/i2c/busses/i2c-rcar.c                                       |    1 
 drivers/media/pci/ttpci/av7110.c                                    |    5 
 drivers/media/platform/davinci/vpif_capture.c                       |    2 
 drivers/net/bonding/bond_main.c                                     |   24 ++
 drivers/net/ethernet/freescale/gianfar.c                            |    4 
 drivers/net/ipvlan/ipvlan_main.c                                    |   25 ++-
 drivers/net/wireless/ath/ath10k/hw.h                                |    2 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    5 
 drivers/pci/slot.c                                                  |    6 
 drivers/s390/cio/css.c                                              |    5 
 drivers/scsi/fcoe/fcoe_ctlr.c                                       |    2 
 drivers/scsi/lpfc/lpfc_vport.c                                      |   26 ---
 drivers/scsi/scsi_transport_iscsi.c                                 |    2 
 drivers/scsi/ufs/ufshcd.c                                           |    5 
 drivers/target/target_core_user.c                                   |    9 -
 drivers/tty/serial/8250/8250_port.c                                 |    9 -
 drivers/tty/serial/amba-pl011.c                                     |    5 
 drivers/tty/serial/samsung.c                                        |    8 
 drivers/tty/vt/vt.c                                                 |    5 
 drivers/tty/vt/vt_ioctl.c                                           |   12 +
 drivers/usb/core/quirks.c                                           |    2 
 drivers/usb/host/ohci-exynos.c                                      |    5 
 drivers/usb/host/xhci-hub.c                                         |   19 +-
 drivers/usb/misc/lvstest.c                                          |    2 
 drivers/usb/misc/sisusbvga/sisusb.c                                 |    2 
 drivers/usb/misc/yurex.c                                            |    2 
 drivers/usb/storage/unusual_devs.h                                  |    2 
 drivers/usb/storage/unusual_uas.h                                   |   14 +
 drivers/video/console/fbcon.c                                       |   25 ++-
 drivers/xen/events/events_base.c                                    |   16 -
 fs/btrfs/tree-log.c                                                 |   10 -
 fs/ceph/mds_client.c                                                |   14 +
 fs/fs-writeback.c                                                   |   83 +++++-----
 fs/jbd2/transaction.c                                               |   26 +++
 include/linux/fs.h                                                  |    8 
 include/trace/events/writeback.h                                    |   13 -
 kernel/locking/lockdep_proc.c                                       |    2 
 net/core/skbuff.c                                                   |    4 
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
 76 files changed, 444 insertions(+), 202 deletions(-)

Aditya Pakki (3):
      drm/radeon: fix multiple reference count leak
      drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open
      drm/nouveau: Fix reference count leak in nouveau_connector_detect

Alan Stern (2):
      USB: yurex: Fix bad gfp argument
      usb: storage: Add unusual_uas entry for Sony PSZ drives

Arnd Bergmann (1):
      powerpc/spufs: add CONFIG_COREDUMP dependency

Bodo Stroesser (1):
      scsi: target: tcmu: Fix crash on ARM during cmd completion

Changming Liu (1):
      USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Chris Wilson (1):
      locking/lockdep: Fix overflow in presentation of average lock-time

Cong Wang (2):
      tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
      bonding: fix a potential double-unregister

Cyril Roelandt (1):
      USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

Desnes A. Nunes do Rosario (1):
      selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Dick Kennedy (1):
      scsi: lpfc: Fix shost refcount mismatch when deleting vport

Evgeny Novikov (2):
      media: davinci: vpif_capture: fix potential double free
      USB: lvtest: return proper error code in probe

George Kennedy (2):
      fbcon: prevent user font height or width change from causing potential out-of-bounds access
      vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()

Greg Kroah-Hartman (1):
      Linux 4.4.235

Hector Martin (1):
      ALSA: usb-audio: Update documentation comment for MS2109 quirk

Heikki Krogerus (1):
      device property: Fix the secondary firmware node handling in set_primary_fwnode()

Jan Kara (3):
      writeback: Protect inode->i_io_list with inode->i_lock
      writeback: Avoid skipping inode writeback
      writeback: Fix sync livelock due to b_dirty_time processing

Jarod Wilson (1):
      bonding: show saner speed for broadcast mode

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

Lukas Czerner (1):
      jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Lukas Wunner (1):
      serial: pl011: Don't leak amba_ports entry on driver register error

Mahesh Bandewar (1):
      ipvlan: fix device features

Miaohe Lin (1):
      net: Fix potential wrong skb->protocol in skb_vlan_untag()

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

Sergey Senozhatsky (1):
      serial: 8250: change lock order in serial8250_do_startup()

Stanley Chu (1):
      scsi: ufs: Fix possible infinite loop in ufshcd_hold

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

Vasant Hegde (1):
      powerpc/pseries: Do not initiate shutdown when system is running on UPS

Vineeth Vijayan (1):
      s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Wolfram Sang (1):
      i2c: rcar: in slave mode, clear NACK earlier

Xiubo Li (1):
      ceph: fix potential mdsc use-after-free crash

Zhi Chen (1):
      Revert "ath10k: fix DMA related firmware crashes on multiple devices"

zhangyi (F) (1):
      jbd2: abort journal if free a async write error metadata buffer

