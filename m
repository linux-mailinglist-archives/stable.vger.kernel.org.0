Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA63346BD
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhCJS34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhCJS31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:29:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3245264EFD;
        Wed, 10 Mar 2021 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615400967;
        bh=gFvTeR4qQmXHoWxhEP4MMSaTdq/EEq4Yn7TDl28ZApo=;
        h=From:To:Cc:Subject:Date:From;
        b=2vulh9vqHhhpOVjE8DwJy+Em+mlnVxpaZpUE6wyVwBa2//lpUeNVgn1TtZ2UA+xtm
         DqTi7i6QJt8gkLZoNavpkpLjUJdIiyixfqVc40pvD+GuYkKhgHdXoVhpPzEdd521PI
         +vgLplbm+/28vMk91P1cV5jLeHRUAYJrfk5Hx1Zk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/47] 5.10.23-rc2 review
Date:   Wed, 10 Mar 2021 19:29:23 +0100
Message-Id: <20210310182834.696191666@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.23-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.23-rc2
X-KernelTest-Deadline: 2021-03-12T18:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.10.23 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.23-rc2

Pascal Terjan <pterjan@google.com>
    nvme-pci: add quirks for Lexar 256GB SSD

Julian Einwag <jeinwag-nvme@marcapo.com>
    nvme-pci: mark Seagate Nytro XM1440 as QUIRK_NO_NS_DESC_LIST.

Babu Moger <babu.moger@amd.com>
    KVM: SVM: Clear the CR4 register on reset

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Fix a duplicate dev quirk number

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk for HP Spectre x360 convertible

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: reorganize quirks by generation

Nadeem Athani <nadeem@cadence.com>
    PCI: cadence: Retrain Link to work around Gen2 training defect

Fabian Lesniak <fabian@lesniak-it.de>
    ALSA: usb-audio: add mixer quirks for Pioneer DJM-900NXS2

Olivia Mackintosh <livvy@base.nu>
    ALSA: usb-audio: Add DJM750 to Pioneer mixer quirk

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: ufs-exynos: Use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: Introduce a quirk to allow only page-aligned sg entries

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: Add a quirk to permit overriding UniPro defaults

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A32

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Roger Quadros <rogerq@ti.com>
    usb: cdns3: fix NULL pointer dereference on no platform data

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: add quirk for enable runtime pm by default

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: host: add xhci_plat_priv quirk XHCI_SKIP_PHY_INIT

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: host: add .suspend_quirk for xhci-plat.c

Chris Chiu <chiu@endlessos.org>
    ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140

Jasper St. Pierre <jstpierre@mecheye.net>
    ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807

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

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Implement GPMC debug quirk to drop platform data

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk for new TigerLake-SDCA device

Tsuchiya Yuto <kitakar@gmail.com>
    mwifiex: pcie: skip cancel_work_sync() on reset failure path

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: btqca: Add valid le states quirk

Andrey Ryabinin <arbn@yandex-team.com>
    iommu/amd: Fix sleeping in atomic in increase_address_space()

Nikolay Borisov <nborisov@suse.com>
    btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Nikolay Borisov <nborisov@suse.com>
    btrfs: export and rename qgroup_reserve_meta

Nathan Chancellor <nathan@kernel.org>
    arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld 13.0.0+

Helge Deller <deller@gmx.de>
    parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST

Zoltán Böszörményi <zboszor@gmail.com>
    nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: broadwell: fix mutual exclusion with catpt driver

Hans de Goede <hdegoede@redhat.com>
    ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   5 +-
 arch/parisc/Kconfig                                |   7 +-
 arch/x86/kvm/svm/svm.c                             |   1 +
 arch/x86/kvm/x86.h                                 |   2 +
 drivers/acpi/acpica/acobject.h                     |   1 +
 drivers/acpi/acpica/evhandler.c                    |   7 +
 drivers/acpi/acpica/evregion.c                     |  64 +++-
 drivers/acpi/acpica/evxfregn.c                     |   2 +
 drivers/acpi/video_detect.c                        |   7 +
 drivers/bluetooth/hci_qca.c                        |  19 +-
 drivers/bus/ti-sysc.c                              |  10 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   2 -
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-mf.c                               |   2 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   2 +
 drivers/iommu/amd/iommu.c                          |  10 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   4 +
 drivers/misc/eeprom/eeprom_93xx46.c                |  15 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  18 +-
 drivers/net/wireless/marvell/mwifiex/pcie.h        |   2 +
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/pci/controller/cadence/pci-j721e.c         |   3 +
 drivers/pci/controller/cadence/pcie-cadence-host.c |  81 ++++-
 drivers/pci/controller/cadence/pcie-cadence.h      |  11 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/platform/x86/acer-wmi.c                    | 169 ++++++++--
 drivers/scsi/ufs/ufs-exynos.c                      |   9 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |   1 +
 drivers/scsi/ufs/ufshcd.c                          |  42 +--
 drivers/scsi/ufs/ufshcd.h                          |  10 +
 drivers/usb/cdns3/core.c                           |   3 +-
 drivers/usb/cdns3/core.h                           |   4 +
 drivers/usb/cdns3/host-export.h                    |   6 +
 drivers/usb/cdns3/host.c                           |  60 +++-
 fs/btrfs/delayed-inode.c                           |   3 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |   8 +-
 fs/btrfs/qgroup.h                                  |   2 +
 include/linux/eeprom_93xx46.h                      |   2 +
 include/linux/platform_data/ti-sysc.h              |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  12 +
 sound/soc/intel/boards/sof_sdw.c                   |  78 +++--
 sound/soc/sof/intel/Kconfig                        |   2 +-
 sound/usb/mixer_quirks.c                           | 367 ++++++++++++++-------
 47 files changed, 820 insertions(+), 257 deletions(-)


