Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634493373EB
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhCKN3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233634AbhCKN3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:29:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF76864ED5;
        Thu, 11 Mar 2021 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615469364;
        bh=n9pC0u9RrZG0yHU/0MnI6I9XDMsLPHeg3pNOMno4znY=;
        h=From:To:Cc:Subject:Date:From;
        b=BG1HWWdOIxz6R+wKIUngkqFV4w924TcoDji/CMuOFDgVz5FcH2s1YnP3pUl9c/Tv0
         P6QouqUPkN9MRCCbxeYr3Ti6B5G+2AuqO/HAtiRU8J/klbVXJ8hWqmjVUjCNsm1DWp
         W+7a106fFKmzcHGliNHQccSaOyoXqTiGR7cL7Jzw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.23
Date:   Thu, 11 Mar 2021 14:29:18 +0100
Message-Id: <1615469357134@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 5.10.23 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm64/Kconfig                                 |    5 
 arch/parisc/Kconfig                                |    7 
 arch/x86/kvm/svm/svm.c                             |    1 
 arch/x86/kvm/x86.h                                 |    2 
 drivers/acpi/acpica/acobject.h                     |    1 
 drivers/acpi/acpica/evhandler.c                    |    7 
 drivers/acpi/acpica/evregion.c                     |   64 ++-
 drivers/acpi/acpica/evxfregn.c                     |    2 
 drivers/acpi/video_detect.c                        |    7 
 drivers/bluetooth/hci_qca.c                        |   19 -
 drivers/bus/ti-sysc.c                              |   10 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |    2 
 drivers/hid/hid-ids.h                              |    3 
 drivers/hid/hid-mf.c                               |    2 
 drivers/hid/hid-quirks.c                           |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    2 
 drivers/iommu/amd/iommu.c                          |   10 
 drivers/media/pci/cx23885/cx23885-core.c           |    4 
 drivers/misc/eeprom/eeprom_93xx46.c                |   15 
 drivers/mmc/host/sdhci-of-dwcmshc.c                |    1 
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   18 -
 drivers/net/wireless/marvell/mwifiex/pcie.h        |    2 
 drivers/nvme/host/pci.c                            |    8 
 drivers/pci/controller/cadence/pci-j721e.c         |    3 
 drivers/pci/controller/cadence/pcie-cadence-host.c |   81 +++-
 drivers/pci/controller/cadence/pcie-cadence.h      |   11 
 drivers/pci/quirks.c                               |    3 
 drivers/platform/x86/acer-wmi.c                    |  169 ++++++++-
 drivers/scsi/ufs/ufs-exynos.c                      |    9 
 drivers/scsi/ufs/ufs-mediatek.c                    |    1 
 drivers/scsi/ufs/ufshcd.c                          |   42 +-
 drivers/scsi/ufs/ufshcd.h                          |   10 
 drivers/usb/cdns3/core.c                           |    3 
 drivers/usb/cdns3/core.h                           |    4 
 drivers/usb/cdns3/host-export.h                    |    6 
 drivers/usb/cdns3/host.c                           |   60 +++
 fs/btrfs/delayed-inode.c                           |    3 
 fs/btrfs/inode.c                                   |    2 
 fs/btrfs/qgroup.c                                  |    8 
 fs/btrfs/qgroup.h                                  |    2 
 include/linux/eeprom_93xx46.h                      |    2 
 include/linux/platform_data/ti-sysc.h              |    1 
 sound/soc/intel/boards/bytcr_rt5640.c              |   12 
 sound/soc/intel/boards/sof_sdw.c                   |   78 +++-
 sound/soc/sof/intel/Kconfig                        |    2 
 sound/usb/mixer_quirks.c                           |  367 ++++++++++++++-------
 47 files changed, 819 insertions(+), 256 deletions(-)

Abhishek Pandit-Subedi (1):
      Bluetooth: btqca: Add valid le states quirk

Andrey Ryabinin (1):
      iommu/amd: Fix sleeping in atomic in increase_address_space()

AngeloGioacchino Del Regno (1):
      drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Aswath Govindraju (1):
      misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Avri Altman (1):
      scsi: ufs: Fix a duplicate dev quirk number

Babu Moger (1):
      KVM: SVM: Clear the CR4 register on reset

Bjorn Helgaas (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Chris Chiu (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140

Daniel Lee Kruse (1):
      media: cx23885: add more quirks for reset DMA on some AMD IOMMU

Ethan Warth (1):
      HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter

Fabian Lesniak (1):
      ALSA: usb-audio: add mixer quirks for Pioneer DJM-900NXS2

Greg Kroah-Hartman (1):
      Linux 5.10.23

Hans de Goede (8):
      ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling
      platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
      platform/x86: acer-wmi: Cleanup accelerometer device handling
      platform/x86: acer-wmi: Add new force_caps module parameter
      platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag
      platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices
      platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016
      HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15

Helge Deller (1):
      parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST

Jasper St. Pierre (1):
      ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807

Jisheng Zhang (1):
      mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Julian Einwag (1):
      nvme-pci: mark Seagate Nytro XM1440 as QUIRK_NO_NS_DESC_LIST.

Kiwoong Kim (4):
      scsi: ufs: Add a quirk to permit overriding UniPro defaults
      scsi: ufs: Introduce a quirk to allow only page-aligned sg entries
      scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts
      scsi: ufs: ufs-exynos: Use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE

Nadeem Athani (1):
      PCI: cadence: Retrain Link to work around Gen2 training defect

Nathan Chancellor (1):
      arm64: Make CPU_BIG_ENDIAN depend on ld.bfd or ld.lld 13.0.0+

Nikolay Borisov (2):
      btrfs: export and rename qgroup_reserve_meta
      btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Olivia Mackintosh (1):
      ALSA: usb-audio: Add DJM750 to Pioneer mixer quirk

Pascal Terjan (1):
      nvme-pci: add quirks for Lexar 256GB SSD

Peter Chen (3):
      usb: cdns3: host: add .suspend_quirk for xhci-plat.c
      usb: cdns3: host: add xhci_plat_priv quirk XHCI_SKIP_PHY_INIT
      usb: cdns3: add quirk for enable runtime pm by default

Pierre-Louis Bossart (5):
      ASoC: SOF: Intel: broadwell: fix mutual exclusion with catpt driver
      ASoC: Intel: sof_sdw: add quirk for new TigerLake-SDCA device
      ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A32
      ASoC: Intel: sof_sdw: reorganize quirks by generation
      ASoC: Intel: sof_sdw: add quirk for HP Spectre x360 convertible

Roger Quadros (1):
      usb: cdns3: fix NULL pointer dereference on no platform data

Stanley Chu (1):
      scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

Tony Lindgren (1):
      bus: ti-sysc: Implement GPMC debug quirk to drop platform data

Tsuchiya Yuto (1):
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

Vitaly Kuznetsov (1):
      KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check

Zoltán Böszörményi (1):
      nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state

