Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF003373E4
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhCKN3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:29:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233620AbhCKN3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:29:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920F264E69;
        Thu, 11 Mar 2021 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615469342;
        bh=HYVTyoPMxQAEXNwxHTCKslpS6UwI4Us1vzT942kCcsc=;
        h=From:To:Cc:Subject:Date:From;
        b=hXzgv61XzUeTMpG39OiGKVOJWNCvTGHkvodEamS87Le/NRytqLt1rK42HTeqwQxmV
         m8N1rVyvAAK9JU2hphy6fWE9DU2gYnAUsAVswCQ4rs6rP6PV/nBtIgNKZxiyUaClYx
         0IU9BfLM/XEMX6D7ITqtaTNQ6goGOSRThhOd3404=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.105
Date:   Thu, 11 Mar 2021 14:28:56 +0100
Message-Id: <1615469336136157@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 5.4.105 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 drivers/acpi/acpica/acobject.h              |    1 
 drivers/acpi/acpica/evhandler.c             |    7 +
 drivers/acpi/acpica/evregion.c              |   64 +++++++---
 drivers/acpi/acpica/evxfregn.c              |    2 
 drivers/acpi/video_detect.c                 |    7 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |    2 
 drivers/hid/hid-ids.h                       |    3 
 drivers/hid/hid-mf.c                        |    2 
 drivers/hid/hid-quirks.c                    |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c          |    2 
 drivers/iommu/amd_iommu.c                   |   10 -
 drivers/md/dm-table.c                       |  174 +++++++++++-----------------
 drivers/md/dm.c                             |    2 
 drivers/md/dm.h                             |    2 
 drivers/media/pci/cx23885/cx23885-core.c    |    4 
 drivers/misc/eeprom/eeprom_93xx46.c         |   15 ++
 drivers/mmc/host/sdhci-of-dwcmshc.c         |    1 
 drivers/net/wireless/marvell/mwifiex/pcie.c |   18 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h |    2 
 drivers/nvme/host/pci.c                     |    6 
 drivers/pci/quirks.c                        |    3 
 drivers/platform/x86/acer-wmi.c             |  169 ++++++++++++++++++++++-----
 include/linux/eeprom_93xx46.h               |    2 
 net/dsa/Kconfig                             |    1 
 net/dsa/dsa.c                               |    2 
 net/dsa/dsa_priv.h                          |    3 
 net/dsa/slave.c                             |   10 +
 sound/soc/intel/boards/bytcr_rt5640.c       |   12 +
 29 files changed, 370 insertions(+), 160 deletions(-)

Alexander Lobakin (1):
      net: dsa: add GRO support via gro_cells

Andrey Ryabinin (1):
      iommu/amd: Fix sleeping in atomic in increase_address_space()

AngeloGioacchino Del Regno (1):
      drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Aswath Govindraju (1):
      misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Chris Chiu (1):
      ASoC: Intel: bytcr_rt5640: Add quirk for ARCHOS Cesium 140

Daniel Lee Kruse (1):
      media: cx23885: add more quirks for reset DMA on some AMD IOMMU

Ethan Warth (1):
      HID: mf: add support for 0079:1846 Mayflash/Dragonrise USB Gamecube Adapter

Greg Kroah-Hartman (1):
      Linux 5.4.105

Hans de Goede (8):
      ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling
      platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
      platform/x86: acer-wmi: Cleanup accelerometer device handling
      platform/x86: acer-wmi: Add new force_caps module parameter
      platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag
      platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices
      platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016
      HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15

Jasper St. Pierre (1):
      ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807

Jeffle Xu (3):
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks
      dm table: fix zoned iterate_devices based device capability checks

Jisheng Zhang (1):
      mmc: sdhci-of-dwcmshc: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Julian Einwag (1):
      nvme-pci: mark Seagate Nytro XM1440 as QUIRK_NO_NS_DESC_LIST.

Pascal Terjan (1):
      nvme-pci: add quirks for Lexar 256GB SSD

Tsuchiya Yuto (1):
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

