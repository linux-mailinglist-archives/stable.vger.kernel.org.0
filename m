Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D843373EC
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhCKN3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233680AbhCKN3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:29:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 402F064E41;
        Thu, 11 Mar 2021 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615469381;
        bh=2mA1LHSYIsFOfZTSIdUGezbG2xrpsk4B0VPNAyCkdn4=;
        h=From:To:Cc:Subject:Date:From;
        b=TXXuH/9Ee71Utu3j1s31W/0J+WjEELwvswT9uMSclD937RDWGQBGrQea2NPAilOog
         dbNkr/QBxqk/0fd+4F9+P6B/I/Km/WuMQ2c8p7PBASxgsdnRRKkZ38B0OVl1zIjE0A
         y3rI58quhwJ7qjDZpZOFyEdRIQcimEDiXmv6C87I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.6
Date:   Thu, 11 Mar 2021 14:29:35 +0100
Message-Id: <16154693741097@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 5.11.6 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm64/Kconfig                                 |    5 
 arch/parisc/Kconfig                                |    7 
 arch/x86/kvm/svm/svm.c                             |    1 
 drivers/acpi/acpica/acobject.h                     |    1 
 drivers/acpi/acpica/evhandler.c                    |    7 
 drivers/acpi/acpica/evregion.c                     |   64 ++-
 drivers/acpi/acpica/evxfregn.c                     |    2 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |    2 
 drivers/hid/hid-ids.h                              |    2 
 drivers/hid/hid-ite.c                              |   12 
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    2 
 drivers/iommu/amd/iommu.c                          |   10 
 drivers/misc/eeprom/eeprom_93xx46.c                |   15 
 drivers/mmc/host/sdhci-of-dwcmshc.c                |    1 
 drivers/nvme/host/pci.c                            |    8 
 drivers/pci/controller/cadence/pci-j721e.c         |    3 
 drivers/pci/controller/cadence/pcie-cadence-host.c |   81 +++-
 drivers/pci/controller/cadence/pcie-cadence.h      |   11 
 drivers/scsi/ufs/ufs-exynos.c                      |    9 
 drivers/scsi/ufs/ufs-mediatek.c                    |    1 
 drivers/scsi/ufs/ufshcd.c                          |   42 +-
 drivers/scsi/ufs/ufshcd.h                          |   10 
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   49 --
 drivers/staging/media/sunxi/cedrus/cedrus.h        |    1 
 fs/btrfs/delayed-inode.c                           |    3 
 fs/btrfs/inode.c                                   |    2 
 fs/btrfs/qgroup.c                                  |    8 
 fs/btrfs/qgroup.h                                  |    2 
 fs/file.c                                          |   36 +-
 fs/internal.h                                      |    1 
 fs/io-wq.c                                         |   17 
 fs/io-wq.h                                         |    5 
 fs/io_uring.c                                      |  241 ++++++-------
 include/linux/eeprom_93xx46.h                      |    2 
 sound/soc/intel/boards/sof_sdw.c                   |   89 +++--
 sound/usb/mixer_quirks.c                           |  367 ++++++++++++++-------
 37 files changed, 685 insertions(+), 436 deletions(-)

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

Fabian Lesniak (1):
      ALSA: usb-audio: add mixer quirks for Pioneer DJM-900NXS2

Greg Kroah-Hartman (1):
      Linux 5.11.6

Hans de Goede (3):
      ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling
      HID: i2c-hid: Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for ITE8568 EC on Voyo Winpad A15
      HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E

Helge Deller (1):
      parisc: Enable -mlong-calls gcc option with CONFIG_COMPILE_TEST

Jens Axboe (3):
      fs: provide locked helper variant of close_fd_get_file()
      io_uring: get rid of intermediate IORING_OP_CLOSE stage
      io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL

Jernej Skrabec (1):
      media: cedrus: Remove checking for required controls

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

Pavel Begunkov (6):
      io_uring: fix inconsistent lock state
      io_uring: deduplicate core cancellations sequence
      io_uring: unpark SQPOLL thread for cancelation
      io_uring: deduplicate failing task_work_add
      io_uring/io-wq: return 2-step work swap scheme
      io_uring: don't take uring_lock during iowq cancel

Pierre-Louis Bossart (2):
      ASoC: Intel: sof_sdw: reorganize quirks by generation
      ASoC: Intel: sof_sdw: add quirk for HP Spectre x360 convertible

Stanley Chu (1):
      scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL

Zoltán Böszörményi (1):
      nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state

