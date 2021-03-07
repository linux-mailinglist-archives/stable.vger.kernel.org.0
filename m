Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791FD33008F
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCGLy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230477AbhCGLy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:54:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ACFA650FD;
        Sun,  7 Mar 2021 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615118096;
        bh=m/0uXn+RN9WSe7kKpyOp7Sa/weAJjTlxoFiSaNa43+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=a+9SXeTAql3Rv5WOTllC3skAwm/Rj39cBgyw9DKkVs9RS5BAgYF02oYaWemgEzjEv
         R61xSr0GSMwxeYjM8lhQyqYNYfFEBmgXj/QVTl+S/9YyflsxX5v/1twN3hAYVpG+8U
         a4X/MV3k3PsPxlkC5nWZDZ7V3XSSNNn+WrMDnor8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.103
Date:   Sun,  7 Mar 2021 12:54:49 +0100
Message-Id: <16151180906989@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.103 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/btusb.txt                |    2 
 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    5 
 Documentation/filesystems/sysfs.txt                            |    8 
 Makefile                                                       |    2 
 arch/arm/xen/p2m.c                                             |   35 ++
 arch/arm64/kernel/module.lds                                   |    6 
 arch/mips/include/asm/string.h                                 |  121 --------
 arch/mips/vdso/Makefile                                        |    5 
 arch/parisc/kernel/irq.c                                       |    4 
 arch/x86/events/intel/core.c                                   |    3 
 arch/x86/kernel/module.c                                       |    1 
 arch/x86/kernel/reboot.c                                       |    9 
 arch/x86/tools/relocs.c                                        |   12 
 arch/x86/xen/p2m.c                                             |   44 ++
 crypto/tcrypt.c                                                |   20 -
 drivers/block/nbd.c                                            |   32 +-
 drivers/block/zram/zram_drv.c                                  |    2 
 drivers/bluetooth/hci_h5.c                                     |    5 
 drivers/gpu/drm/amd/amdgpu/cz_ih.c                             |   37 +-
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c                        |   36 +-
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c                          |   37 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                  |    5 
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c                |    1 
 drivers/gpu/drm/virtio/virtgpu_vq.c                            |    5 
 drivers/input/mouse/elantech.c                                 |   99 ++++++
 drivers/input/mouse/elantech.h                                 |    4 
 drivers/media/rc/mceusb.c                                      |    9 
 drivers/media/usb/uvc/uvc_driver.c                             |    7 
 drivers/media/v4l2-core/v4l2-ctrls.c                           |    3 
 drivers/media/v4l2-core/v4l2-ioctl.c                           |   19 -
 drivers/net/ethernet/atheros/ag71xx.c                          |    4 
 drivers/net/tap.c                                              |    7 
 drivers/net/tun.c                                              |    4 
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/wireless/ath/ath10k/mac.c                          |   15 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c         |   32 ++
 drivers/net/wireless/rsi/rsi_91x_hal.c                         |    3 
 drivers/net/wireless/rsi/rsi_91x_sdio.c                        |    6 
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c                    |   52 ---
 drivers/net/wireless/rsi/rsi_sdio.h                            |    8 
 drivers/net/wireless/ti/wl12xx/main.c                          |    3 
 drivers/net/wireless/ti/wlcore/main.c                          |   15 -
 drivers/net/wireless/ti/wlcore/wlcore.h                        |    3 
 drivers/net/xen-netback/netback.c                              |   12 
 drivers/nvme/host/core.c                                       |   20 +
 drivers/nvme/host/nvme.h                                       |    2 
 drivers/nvme/host/pci.c                                        |  105 ++++---
 drivers/nvme/host/rdma.c                                       |   18 +
 drivers/nvme/host/tcp.c                                        |   18 +
 drivers/pci/pci.c                                              |    9 
 drivers/scsi/libiscsi.c                                        |  148 +++++-----
 drivers/scsi/scsi_transport_iscsi.c                            |   38 ++
 drivers/staging/fwserial/fwserial.c                            |    2 
 drivers/staging/most/sound/sound.c                             |    2 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c      |    6 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c      |    2 
 drivers/staging/vc04_services/bcm2835-audio/bcm2835.c          |    6 
 drivers/tty/vt/consolemap.c                                    |    2 
 drivers/video/fbdev/udlfb.c                                    |    1 
 fs/btrfs/transaction.c                                         |   11 
 fs/erofs/super.c                                               |    4 
 fs/f2fs/namei.c                                                |    8 
 fs/f2fs/segment.h                                              |    4 
 fs/jfs/jfs_filsys.h                                            |    1 
 fs/jfs/jfs_mount.c                                             |   10 
 fs/sysfs/file.c                                                |   55 +++
 fs/xfs/xfs_iops.c                                              |    2 
 include/linux/netdevice.h                                      |    3 
 include/linux/swap.h                                           |    1 
 include/linux/sysfs.h                                          |   16 +
 include/linux/zsmalloc.h                                       |    2 
 kernel/sched/core.c                                            |    8 
 kernel/sched/sched.h                                           |    1 
 mm/hugetlb.c                                                   |   22 -
 mm/page_io.c                                                   |    5 
 mm/swapfile.c                                                  |   13 
 mm/zsmalloc.c                                                  |   17 -
 net/bluetooth/amp.c                                            |    3 
 net/bridge/br_sysfs_if.c                                       |    9 
 net/core/dev.c                                                 |   42 ++
 net/core/dev_ioctl.c                                           |   20 -
 net/core/pktgen.c                                              |    2 
 net/core/rtnetlink.c                                           |    2 
 net/core/skbuff.c                                              |   14 
 net/iucv/af_iucv.c                                             |    1 
 security/smack/smackfs.c                                       |   21 +
 sound/pci/hda/patch_realtek.c                                  |   13 
 sound/soc/intel/boards/bytcr_rt5640.c                          |   37 ++
 sound/soc/intel/boards/bytcr_rt5651.c                          |   13 
 sound/soc/intel/common/soc-intel-quirks.h                      |   25 +
 90 files changed, 992 insertions(+), 515 deletions(-)

Alexander Egorenkov (1):
      net/af_iucv: remove WARN_ONCE on malformed RX packets

Ard Biesheuvel (1):
      crypto: tcrypt - avoid signed overflow in byte count

Chao Leng (3):
      nvme-core: add cancel tagset helpers
      nvme-rdma: add clean action for failed reconnection
      nvme-tcp: add clean action for failed reconnection

Chao Yu (1):
      f2fs: fix to set/clear I_LINKABLE under i_lock

Chris Leech (2):
      scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE
      scsi: iscsi: Verify lengths on passthrough PDUs

Christian Gromm (1):
      staging: most: sound: add sanity check for function argument

Christoph Hellwig (2):
      nvme-pci: refactor nvme_unmap_data
      nvme-pci: fix error unwind in nvme_map_data

Claire Chang (1):
      Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Cong Wang (1):
      net: fix dev_ifsioc_locked() race condition

DENG Qingfang (1):
      net: ag71xx: remove unnecessary MTU reservation

Defang Bo (1):
      drm/amdgpu: Add check to prevent IH overflow

Di Zhu (1):
      pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Dinghao Liu (1):
      staging: fwserial: Fix error handling in fwserial_create

Eckhart Mohr (1):
      ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

Fangrui Song (1):
      x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Gao Xiang (1):
      erofs: fix shift-out-of-bounds of blkszbits

Geert Uytterhoeven (1):
      dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Gopal Tiwari (1):
      Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Greg Kroah-Hartman (1):
      Linux 5.4.103

Hans Verkuil (1):
      media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate

Hans de Goede (7):
      brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet
      brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet
      ASoC: Intel: Add DMI quirk table to soc_intel_is_byt_cr()
      ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Voyo Winpad A15 tablet
      ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet

Heiner Kallweit (1):
      x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Jaegeuk Kim (1):
      f2fs: handle unallocated section and zone on pinned/atgc

Jan Beulich (2):
      Xen/gnttab: handle p2m update errors on a per-slot basis
      xen-netback: respect gnttab_map_refs()'s return value

Jens Axboe (1):
      swap: fix swapfile read/write offset

Jim Mattson (1):
      perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]

Jiri Slaby (1):
      vt/consolemap: do font sum unsigned

Joe Perches (1):
      sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output

John David Anglin (1):
      parisc: Bump 64-bit IRQ stack size to 64 KB

Josef Bacik (2):
      nbd: handle device refs for DESTROY_ON_DISCONNECT properly
      btrfs: fix error handling in commit_fs_roots

Juerg Haefliger (1):
      staging: bcm2835-audio: Replace unsafe strcpy() with strscpy()

Juri Lelli (1):
      sched/features: Fix hrtick reprogramming

Lech Perczak (1):
      net: usb: qmi_wwan: support ZTE P685M modem

Lee Duncan (1):
      scsi: iscsi: Restrict sessions and handles to admin capabilities

Li Xinhai (1):
      mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Marco Elver (1):
      net: fix up truesize of cloned skb in skb_prepare_for_shift()

Marek Vasut (2):
      rsi: Fix TX EAPOL packet handling against iwlwifi AP
      rsi: Move card interrupt handling to RX thread

Miaoqing Pan (1):
      ath10k: fix wmi mgmt tx queue full due to race condition

Nathan Chancellor (1):
      MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Nicholas Kazlauskas (1):
      drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Nirmoy Das (1):
      PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Paul Burton (1):
      MIPS: Drop 32-bit asm string functions

Randy Dunlap (1):
      JFS: more checks for invalid superblock

Ricardo Ribalda (1):
      media: uvcvideo: Allow entities with no pads

Rokudo Yan (1):
      zsmalloc: account the number of compacted pages correctly

Russell King (1):
      dt-bindings: ethernet-controller: fix fixed-link specification

Sabyrzhan Tasbolatov (1):
      smackfs: restrict bytes count in smackfs write functions

Sakari Ailus (1):
      media: v4l: ioctl: Fix memory leak in video_usercopy

Sean Young (1):
      media: mceusb: sanity check for prescaler value

Sergey Senozhatsky (1):
      drm/virtio: use kvmalloc for large allocations

Shaoying Xu (1):
      arm64 module: set plt* section addresses to 0x0

Takashi Iwai (1):
      ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Tian Tao (1):
      drm/hisilicon: Fix use-after-free

Tony Lindgren (1):
      wlcore: Fix command execute failure 19 for wl12xx

Vladimir Oltean (1):
      net: bridge: use switchdev for port flags set through sysfs too

Werner Sembach (1):
      ALSA: hda/realtek: Add quirk for Intel NUC 10

Yumei Huang (1):
      xfs: Fix assert failure in xfs_setattr_size()

Zqiang (1):
      udlfb: Fix memory leak in dlfb_usb_probe

jingle.wu (1):
      Input: elantech - fix protocol errors for some trackpoints in SMBus mode

