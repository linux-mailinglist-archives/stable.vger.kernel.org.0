Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB71915B
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfEISzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbfEISzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:55:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C599204FD;
        Thu,  9 May 2019 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428120;
        bh=rKlNMGiGE87j05Hs5EDmbJNz8PnL4zYhc55QwOj/DU8=;
        h=From:To:Cc:Subject:Date:From;
        b=T6LtnTtY6P1d4t8/nKutCzwAiAMncEUviX7rSKNownwAmbj0+H/lLrsrVSFQFafjM
         Wp4fJY9yf+az+neEo0tuNkgbwdyGXqI9O7onpwz0LaH02cfZmZTFI8AQWlE6/qTz7A
         yi71A40b+Ia3CbrXQtxPsO3si0VyGeWs4xBadU4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 00/30] 5.1.1-stable review
Date:   Thu,  9 May 2019 20:42:32 +0200
Message-Id: <20190509181250.417203112@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.1-rc1
X-KernelTest-Deadline: 2019-05-11T18:12+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.1 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.1-rc1

Will Deacon <will.deacon@arm.com>
    arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Will Deacon <will.deacon@arm.com>
    locking/futex: Allow low-level atomic operations to return -EAGAIN

Dan Carpenter <dan.carpenter@oracle.com>
    i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()

Ross Zwisler <zwisler@chromium.org>
    ASoC: Intel: avoid Oops if DMA setup fails

Oliver Neukum <oneukum@suse.com>
    UAS: fix alignment of scatter/gather segments

Chen-Yu Tsai <wens@csie.org>
    Bluetooth: hci_bcm: Fix empty regulator supplies for Intel Macs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not initializing L2CAP tx_credits

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Young Xiao <YangX92@hotmail.com>
    Bluetooth: hidp: fix buffer overflow

Quinn Tran <qtran@marvell.com>
    scsi: qla2xxx: Fix device staying in blocked state

Giridhar Malavali <gmalavali@marvell.com>
    scsi: qla2xxx: Set remote port devloss timeout to 0

Andrew Vasquez <andrewv@marvell.com>
    scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines

Silvio Cesare <silvio.cesare@gmail.com>
    scsi: lpfc: change snprintf to scnprintf for possible overflow

Samuel Holland <samuel@sholland.org>
    soc: sunxi: Fix missing dependency on REGMAP_MMIO

Hans de Goede <hdegoede@redhat.com>
    ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for hibernate

Gregory CLEMENT <gregory.clement@bootlin.com>
    cpufreq: armada-37xx: fix frequency calculation for opp

Bjorn Andersson <bjorn.andersson@linaro.org>
    iio: adc: qcom-spmi-adc5: Fix of-based module autoloading

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake support

Prasad Sodagudi <psodagud@codeaurora.org>
    genirq: Prevent use-after-free and work list corruption

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Set virt_boundary_mask to avoid SG overflows

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unthrottle races

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    USB: serial: f81232: fix interrupt worker not stop

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Fix default lpm_nyet_threshold value

Marc Gonzalez <marc.w.gonzalez@free.fr>
    usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON

Christian Gromm <christian.gromm@microchip.com>
    staging: most: sound: pass correct device when creating a sound card

Suresh Udipi <sudipi@jp.adit-jv.com>
    staging: most: cdev: fix chrdev_region leak in mod_exit

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.

Johan Hovold <johan@kernel.org>
    staging: greybus: power_supply: fix prop-descriptor request size

Andrey Ryabinin <aryabinin@virtuozzo.com>
    ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()


-------------

Diffstat:

 Makefile                               |   4 +-
 arch/arm64/include/asm/futex.h         |  55 ++--
 drivers/acpi/acpi_lpss.c               |   4 +-
 drivers/bluetooth/hci_bcm.c            |  20 +-
 drivers/cpufreq/armada-37xx-cpufreq.c  |  22 +-
 drivers/hv/hv.c                        |   1 -
 drivers/hwtracing/intel_th/pci.c       |   5 +
 drivers/i3c/master.c                   |   5 +-
 drivers/iio/adc/qcom-spmi-adc5.c       |   1 +
 drivers/scsi/lpfc/lpfc_attr.c          | 196 +++++++-------
 drivers/scsi/lpfc/lpfc_ct.c            |  12 +-
 drivers/scsi/lpfc/lpfc_debugfs.c       | 474 +++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_debugfs.h       |   6 +-
 drivers/scsi/qla2xxx/qla_attr.c        |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c        |  19 +-
 drivers/scsi/qla2xxx/qla_target.c      |   4 +-
 drivers/soc/sunxi/Kconfig              |   1 +
 drivers/staging/greybus/power_supply.c |   2 +-
 drivers/staging/most/cdev/cdev.c       |   2 +-
 drivers/staging/most/sound/sound.c     |   2 +-
 drivers/staging/wilc1000/wilc_netdev.c |   2 +-
 drivers/usb/class/cdc-acm.c            |  32 ++-
 drivers/usb/dwc3/Kconfig               |   6 +-
 drivers/usb/dwc3/core.c                |   2 +-
 drivers/usb/musb/Kconfig               |   2 +-
 drivers/usb/serial/f81232.c            |  39 +++
 drivers/usb/storage/scsiglue.c         |  26 +-
 drivers/usb/storage/uas.c              |  35 ++-
 include/net/bluetooth/hci_core.h       |   3 +
 kernel/futex.c                         | 188 ++++++++-----
 kernel/irq/manage.c                    |   4 +-
 lib/ubsan.c                            |  49 ++--
 net/bluetooth/hci_conn.c               |   8 +
 net/bluetooth/hidp/sock.c              |   1 +
 net/bluetooth/l2cap_core.c             |   9 +-
 sound/soc/intel/common/sst-firmware.c  |   8 +-
 36 files changed, 716 insertions(+), 537 deletions(-)


