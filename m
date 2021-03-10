Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76A1333E12
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhCJNZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhCJNYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F2F64FF6;
        Wed, 10 Mar 2021 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382692;
        bh=WaPW0M6gRHuliwZuvyqKIR6xBWXURhfgOQq3zWlDSMM=;
        h=From:To:Cc:Subject:Date:From;
        b=a3+Lxr+F9SadvLS2o9T5xec4vYK+6hrJdS6y3ER1EY7TPcWn9Iyml9gg6Ev/yGIHs
         goapcxP44T83W5RV4hq6i1lVAB8hXAzPxDIBTlwKKwyQI9smzYw3HvOsUti2zckamB
         O9A/PYcIzoDjgbfUgaQgw3qznrvtc13tHtHEw8O8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/39] 4.19.180-rc1 review
Date:   Wed, 10 Mar 2021 14:24:08 +0100
Message-Id: <20210310132319.708237392@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.180-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.180-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.19.180 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.180-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.180-rc1

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Chris Chiu <chiu@endlessos.org>
    ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140

Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>
    media: cx23885: add more quirks for reset DMA on some AMD IOMMU

Ethan Warth <redyoshi49q@gmail.com>
    HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add new force_caps module parameter

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Cleanup accelerometer device handling

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines

Tsuchiya Yuto <kitakar@gmail.com>
    mwifiex: pcie: skip cancel_work_sync() on reset failure path

Andrey Ryabinin <arbn@yandex-team.com>
    iommu/amd: Fix sleeping in atomic in increase_address_space()

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix zoned iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix DAX iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix iterate_devices based device capability checks

Alexander Lobakin <bloodyreaper@yandex.ru>
    net: dsa: add GRO support via gro_cells

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix resuming from suspend on RTL8105e if machine runs on battery

Milan Broz <gmazyland@gmail.com>
    dm verity: fix FEC for RS roots unaligned to block size

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

Julian Braha <julianbraha@gmail.com>
    RDMA/rxe: Fix missing kconfig dependency on CRYPTO

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Hannes Reinecke <hare@suse.de>
    virtio-blk: modernize sysfs attribute creation

Hannes Reinecke <hare@suse.de>
    zram: register default groups with device_add_disk()

Hannes Reinecke <hare@suse.de>
    aoe: register default groups with device_add_disk()

Hannes Reinecke <hare@suse.de>
    nvme: register ns_id attributes as default sysfs groups

Hannes Reinecke <hare@suse.de>
    block: genhd: add 'groups' argument to device_add_disk

Jeffle Xu <jefflexu@linux.alibaba.com>
    Revert "zram: close udev startup race condition as default groups"

Antonio Borneo <borneo.antonio@gmail.com>
    usbip: tools: fix build error for multiple definition

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update device status before letting suppliers suspend

Nikolay Borisov <nborisov@suse.com>
    btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors

Nikolay Borisov <nborisov@suse.com>
    btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata

Dan Carpenter <dancarpenter@oracle.com>
    btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl

Ira Weiny <ira.weiny@intel.com>
    btrfs: fix raid6 qstripe kmap

David Sterba <dsterba@suse.com>
    btrfs: raid56: simplify tracking of Q stripe presence


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/um/drivers/ubd_kern.c                  |   2 +-
 block/genhd.c                               |  19 ++-
 drivers/base/power/runtime.c                |  62 ++++++----
 drivers/block/aoe/aoe.h                     |   1 -
 drivers/block/aoe/aoeblk.c                  |  21 ++--
 drivers/block/aoe/aoedev.c                  |   1 -
 drivers/block/floppy.c                      |   2 +-
 drivers/block/mtip32xx/mtip32xx.c           |   2 +-
 drivers/block/ps3disk.c                     |   2 +-
 drivers/block/ps3vram.c                     |   2 +-
 drivers/block/rsxx/core.c                   |   8 +-
 drivers/block/rsxx/dev.c                    |   2 +-
 drivers/block/skd_main.c                    |   2 +-
 drivers/block/sunvdc.c                      |   2 +-
 drivers/block/virtio_blk.c                  |  68 ++++++-----
 drivers/block/xen-blkfront.c                |   2 +-
 drivers/block/zram/zram_drv.c               |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |   4 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |   2 -
 drivers/hid/hid-ids.h                       |   1 +
 drivers/hid/hid-mf.c                        |   2 +
 drivers/hid/hid-quirks.c                    |   2 +
 drivers/ide/ide-cd.c                        |   2 +-
 drivers/ide/ide-gd.c                        |   2 +-
 drivers/infiniband/sw/rxe/Kconfig           |   1 +
 drivers/iommu/amd_iommu.c                   |  10 +-
 drivers/md/dm-bufio.c                       |   4 +
 drivers/md/dm-table.c                       | 174 ++++++++++++----------------
 drivers/md/dm-verity-fec.c                  |  23 ++--
 drivers/media/pci/cx23885/cx23885-core.c    |   4 +
 drivers/memstick/core/ms_block.c            |   2 +-
 drivers/memstick/core/mspro_block.c         |   2 +-
 drivers/misc/eeprom/eeprom_93xx46.c         |  15 +++
 drivers/mmc/core/block.c                    |   2 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c         |   1 +
 drivers/mtd/mtd_blkdevs.c                   |   2 +-
 drivers/net/ethernet/realtek/r8169.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/pcie.c |  18 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.h |   2 +
 drivers/nvdimm/blk.c                        |   2 +-
 drivers/nvdimm/btt.c                        |   2 +-
 drivers/nvdimm/pmem.c                       |   2 +-
 drivers/nvme/host/core.c                    |  21 ++--
 drivers/nvme/host/lightnvm.c                | 105 +++++++----------
 drivers/nvme/host/multipath.c               |  15 +--
 drivers/nvme/host/nvme.h                    |  10 +-
 drivers/pci/quirks.c                        |   3 +
 drivers/platform/x86/acer-wmi.c             | 169 ++++++++++++++++++++++-----
 drivers/s390/block/dasd_genhd.c             |   2 +-
 drivers/s390/block/dcssblk.c                |   2 +-
 drivers/s390/block/scm_blk.c                |   2 +-
 drivers/scsi/sd.c                           |   2 +-
 drivers/scsi/sr.c                           |   2 +-
 fs/btrfs/delayed-inode.c                    |   2 +-
 fs/btrfs/file.c                             |   5 +-
 fs/btrfs/ioctl.c                            |  19 ++-
 fs/btrfs/raid56.c                           |  58 ++++------
 include/linux/eeprom_93xx46.h               |   2 +
 include/linux/genhd.h                       |   5 +-
 net/dsa/Kconfig                             |   1 +
 net/dsa/dsa.c                               |   2 +-
 net/dsa/dsa_priv.h                          |   3 +
 net/dsa/slave.c                             |  10 +-
 sound/pci/ctxfi/cthw20k2.c                  |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c       |  12 ++
 tools/usb/usbip/libsrc/usbip_host_common.c  |   2 +-
 67 files changed, 556 insertions(+), 389 deletions(-)


