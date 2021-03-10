Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01925333D94
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhCJNYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhCJNXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C2F764FD7;
        Wed, 10 Mar 2021 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382635;
        bh=Qd0zAZQIgUzh1wPboQZLMsmXhHYwYkri5orPBCgDRhY=;
        h=From:To:Cc:Subject:Date:From;
        b=BG4GVRxwr/OtoBruMnNyV8RYioGQs2FdUgl3Av6SlEMBpQUosmmSCqmfLixQHD8fN
         MPmJQRAKN6FIrnfm5dvX+CoF9Xx9c5p1TUvKV6ueTsdxkiu7c6bNhoFzo6C+d1FM4l
         EwW0NOdOQIAZMTPDD31r+6zcT/zdl9PIfdHvAwQ4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/36] 5.11.6-rc1 review
Date:   Wed, 10 Mar 2021 14:23:13 +0100
Message-Id: <20210310132320.510840709@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.6-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 5.11.6 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.6-rc1

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

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E

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

Jernej Skrabec <jernej.skrabec@siol.net>
    media: cedrus: Remove checking for required controls

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't take uring_lock during iowq cancel

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/io-wq: return 2-step work swap scheme

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL

Jens Axboe <axboe@kernel.dk>
    io_uring: get rid of intermediate IORING_OP_CLOSE stage

Jens Axboe <axboe@kernel.dk>
    fs: provide locked helper variant of close_fd_get_file()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: deduplicate failing task_work_add

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: unpark SQPOLL thread for cancelation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: deduplicate core cancellations sequence

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix inconsistent lock state

Hans de Goede <hdegoede@redhat.com>
    ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   5 +-
 arch/parisc/Kconfig                                |   7 +-
 arch/x86/kvm/svm/svm.c                             |   1 +
 drivers/acpi/acpica/acobject.h                     |   1 +
 drivers/acpi/acpica/evhandler.c                    |   7 +
 drivers/acpi/acpica/evregion.c                     |  64 +++-
 drivers/acpi/acpica/evxfregn.c                     |   2 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   2 -
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-ite.c                              |  12 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   2 +
 drivers/iommu/amd/iommu.c                          |  10 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |  15 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   1 +
 drivers/nvme/host/pci.c                            |   8 +-
 drivers/pci/controller/cadence/pci-j721e.c         |   3 +
 drivers/pci/controller/cadence/pcie-cadence-host.c |  81 ++++-
 drivers/pci/controller/cadence/pcie-cadence.h      |  11 +-
 drivers/scsi/ufs/ufs-exynos.c                      |   9 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |   1 +
 drivers/scsi/ufs/ufshcd.c                          |  42 +--
 drivers/scsi/ufs/ufshcd.h                          |  10 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        |  49 ---
 drivers/staging/media/sunxi/cedrus/cedrus.h        |   1 -
 fs/btrfs/delayed-inode.c                           |   3 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/qgroup.c                                  |   8 +-
 fs/btrfs/qgroup.h                                  |   2 +
 fs/file.c                                          |  36 +-
 fs/internal.h                                      |   1 +
 fs/io-wq.c                                         |  17 +-
 fs/io-wq.h                                         |   5 +-
 fs/io_uring.c                                      | 241 +++++++-------
 include/linux/eeprom_93xx46.h                      |   2 +
 sound/soc/intel/boards/sof_sdw.c                   |  89 +++--
 sound/usb/mixer_quirks.c                           | 367 ++++++++++++++-------
 37 files changed, 686 insertions(+), 437 deletions(-)


