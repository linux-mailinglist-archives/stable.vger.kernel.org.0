Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589183373DB
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhCKN2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhCKN2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:28:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B004F64D74;
        Thu, 11 Mar 2021 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615469296;
        bh=mBM11l4hVDTUj2ue2jnf0QZc52Rxrwh5FrEGyS++Hyk=;
        h=From:To:Cc:Subject:Date:From;
        b=THQRFocTOAPyKqhBPYC8Utj80BUZsy4/1FeERDDGmlLNbG+Sbm37IE45F+DfaCKmE
         BM5lRfFN0FCc/jvIK/GkkTrzItc3wLES/5AnKjYmBgbo3eQpguqPX/vtXZvpYWRvCj
         si91uq/yAWkYiQGQyjqKIdAk0WVudXHl0giNf/SE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.180
Date:   Thu, 11 Mar 2021 14:28:11 +0100
Message-Id: <1615469290153168@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 4.19.180 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/um/drivers/ubd_kern.c                  |    2 
 block/genhd.c                               |   19 ++-
 drivers/base/power/runtime.c                |   62 +++++----
 drivers/block/aoe/aoe.h                     |    1 
 drivers/block/aoe/aoeblk.c                  |   21 +--
 drivers/block/aoe/aoedev.c                  |    1 
 drivers/block/floppy.c                      |    2 
 drivers/block/mtip32xx/mtip32xx.c           |    2 
 drivers/block/ps3disk.c                     |    2 
 drivers/block/ps3vram.c                     |    2 
 drivers/block/rsxx/core.c                   |    8 -
 drivers/block/rsxx/dev.c                    |    2 
 drivers/block/skd_main.c                    |    2 
 drivers/block/sunvdc.c                      |    2 
 drivers/block/virtio_blk.c                  |   68 ++++++----
 drivers/block/xen-blkfront.c                |    2 
 drivers/block/zram/zram_drv.c               |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |    2 
 drivers/hid/hid-ids.h                       |    1 
 drivers/hid/hid-mf.c                        |    2 
 drivers/hid/hid-quirks.c                    |    2 
 drivers/ide/ide-cd.c                        |    2 
 drivers/ide/ide-gd.c                        |    2 
 drivers/infiniband/sw/rxe/Kconfig           |    1 
 drivers/iommu/amd_iommu.c                   |   10 -
 drivers/md/dm-bufio.c                       |    4 
 drivers/md/dm-table.c                       |  174 +++++++++++-----------------
 drivers/md/dm-verity-fec.c                  |   23 +--
 drivers/media/pci/cx23885/cx23885-core.c    |    4 
 drivers/memstick/core/ms_block.c            |    2 
 drivers/memstick/core/mspro_block.c         |    2 
 drivers/misc/eeprom/eeprom_93xx46.c         |   15 ++
 drivers/mmc/core/block.c                    |    2 
 drivers/mmc/host/sdhci-of-dwcmshc.c         |    1 
 drivers/mtd/mtd_blkdevs.c                   |    2 
 drivers/net/ethernet/realtek/r8169.c        |    2 
 drivers/net/wireless/marvell/mwifiex/pcie.c |   18 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h |    2 
 drivers/nvdimm/blk.c                        |    2 
 drivers/nvdimm/btt.c                        |    2 
 drivers/nvdimm/pmem.c                       |    2 
 drivers/nvme/host/core.c                    |   21 +--
 drivers/nvme/host/lightnvm.c                |  105 +++++++---------
 drivers/nvme/host/multipath.c               |   15 --
 drivers/nvme/host/nvme.h                    |   10 -
 drivers/pci/quirks.c                        |    3 
 drivers/platform/x86/acer-wmi.c             |  169 ++++++++++++++++++++++-----
 drivers/s390/block/dasd_genhd.c             |    2 
 drivers/s390/block/dcssblk.c                |    2 
 drivers/s390/block/scm_blk.c                |    2 
 drivers/scsi/sd.c                           |    2 
 drivers/scsi/sr.c                           |    2 
 fs/btrfs/delayed-inode.c                    |    2 
 fs/btrfs/file.c                             |    5 
 fs/btrfs/ioctl.c                            |   19 ++-
 fs/btrfs/raid56.c                           |   58 ++++-----
 include/linux/eeprom_93xx46.h               |    2 
 include/linux/genhd.h                       |    5 
 net/dsa/Kconfig                             |    1 
 net/dsa/dsa.c                               |    2 
 net/dsa/dsa_priv.h                          |    3 
 net/dsa/slave.c                             |   10 +
 sound/pci/ctxfi/cthw20k2.c                  |    2 
 sound/soc/intel/boards/bytcr_rt5640.c       |   12 +
 tools/usb/usbip/libsrc/usbip_host_common.c  |    2 
 67 files changed, 555 insertions(+), 388 deletions(-)

Alexander Lobakin (1):
      net: dsa: add GRO support via gro_cells

Andrey Ryabinin (1):
      iommu/amd: Fix sleeping in atomic in increase_address_space()

AngeloGioacchino Del Regno (1):
      drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Antonio Borneo (1):
      usbip: tools: fix build error for multiple definition

Aswath Govindraju (1):
      misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Chris Chiu (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140

Colin Ian King (1):
      ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Dan Carpenter (2):
      btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
      rsxx: Return -EFAULT if copy_to_user() fails

Daniel Lee Kruse (1):
      media: cx23885: add more quirks for reset DMA on some AMD IOMMU

David Sterba (1):
      btrfs: raid56: simplify tracking of Q stripe presence

Ethan Warth (1):
      HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter

Greg Kroah-Hartman (1):
      Linux 4.19.180

Hannes Reinecke (5):
      block: genhd: add 'groups' argument to device_add_disk
      nvme: register ns_id attributes as default sysfs groups
      aoe: register default groups with device_add_disk()
      zram: register default groups with device_add_disk()
      virtio-blk: modernize sysfs attribute creation

Hans de Goede (6):
      platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
      platform/x86: acer-wmi: Cleanup accelerometer device handling
      platform/x86: acer-wmi: Add new force_caps module parameter
      platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag
      platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices
      platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016

Heiner Kallweit (1):
      r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Ira Weiny (1):
      btrfs: fix raid6 qstripe kmap

Jeffle Xu (4):
      Revert "zram: close udev startup race condition as default groups"
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks
      dm table: fix zoned iterate_devices based device capability checks

Jisheng Zhang (1):
      mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Julian Braha (1):
      RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Kevin Wang (1):
      drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Mikulas Patocka (1):
      dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Milan Broz (1):
      dm verity: fix FEC for RS roots unaligned to block size

Nikolay Borisov (2):
      btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata
      btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Rafael J. Wysocki (1):
      PM: runtime: Update device status before letting suppliers suspend

Tsuchiya Yuto (1):
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

