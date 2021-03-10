Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC2F333DF6
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhCJNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232922AbhCJNYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC2E364FDC;
        Wed, 10 Mar 2021 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382681;
        bh=eBWBMF+B5+VI2E2kRjyAusIlk066wgmcZx/MvnrZDno=;
        h=From:To:Cc:Subject:Date:From;
        b=Ttwas9o+3dLNqqlV2Z05bPX9ruT6fmSyjk/kcJIQc9MFQTR0W22k5bFPj99X6781K
         hkqOzkHKo7OnFG11iI2BlGH/2iOSqQJVV9bneI5IfAbhsfIG/hLhZ3Bx+BhKP9Hxn9
         w5yDOnyQhZ7zUnhS3dXseVhglb5kP/qqwuay0pKk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/24] 5.4.105-rc1 review
Date:   Wed, 10 Mar 2021 14:24:12 +0100
Message-Id: <20210310132320.550932445@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.105-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.105-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.4.105 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.105-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.105-rc1

Pascal Terjan <pterjan@google.com>
    nvme-pci: add quirks for Lexar 256GB SSD

Julian Einwag <jeinwag-nvme@marcapo.com>
    nvme-pci: mark Seagate Nytro XM1440 as QUIRK_NO_NS_DESC_LIST.

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15

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

Tsuchiya Yuto <kitakar@gmail.com>
    mwifiex: pcie: skip cancel_work_sync() on reset failure path

Andrey Ryabinin <arbn@yandex-team.com>
    iommu/amd: Fix sleeping in atomic in increase_address_space()

Hans de Goede <hdegoede@redhat.com>
    ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix zoned iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix DAX iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix iterate_devices based device capability checks

Alexander Lobakin <bloodyreaper@yandex.ru>
    net: dsa: add GRO support via gro_cells


-------------

Diffstat:

 Makefile                                    |   4 +-
 drivers/acpi/acpica/acobject.h              |   1 +
 drivers/acpi/acpica/evhandler.c             |   7 ++
 drivers/acpi/acpica/evregion.c              |  64 +++++++---
 drivers/acpi/acpica/evxfregn.c              |   2 +
 drivers/acpi/video_detect.c                 |   7 ++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |   2 -
 drivers/hid/hid-ids.h                       |   3 +
 drivers/hid/hid-mf.c                        |   2 +
 drivers/hid/hid-quirks.c                    |   2 +
 drivers/hid/i2c-hid/i2c-hid-core.c          |   2 +
 drivers/iommu/amd_iommu.c                   |  10 +-
 drivers/md/dm-table.c                       | 174 ++++++++++++----------------
 drivers/md/dm.c                             |   2 +-
 drivers/md/dm.h                             |   2 +-
 drivers/media/pci/cx23885/cx23885-core.c    |   4 +
 drivers/misc/eeprom/eeprom_93xx46.c         |  15 +++
 drivers/mmc/host/sdhci-of-dwcmshc.c         |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c |  18 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.h |   2 +
 drivers/nvme/host/pci.c                     |   6 +-
 drivers/pci/quirks.c                        |   3 +
 drivers/platform/x86/acer-wmi.c             | 169 ++++++++++++++++++++++-----
 include/linux/eeprom_93xx46.h               |   2 +
 net/dsa/Kconfig                             |   1 +
 net/dsa/dsa.c                               |   2 +-
 net/dsa/dsa_priv.h                          |   3 +
 net/dsa/slave.c                             |  10 +-
 sound/soc/intel/boards/bytcr_rt5640.c       |  12 ++
 29 files changed, 371 insertions(+), 161 deletions(-)


