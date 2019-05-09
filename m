Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8050619289
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfEISo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfEISoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:44:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A20217D6;
        Thu,  9 May 2019 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427494;
        bh=Z0f0+ZL3QQynnqexc86HmoG4yQE4cBDUZPRGIe1voHM=;
        h=From:To:Cc:Subject:Date:From;
        b=lVsu8Zlt/mPQ8Euo2oDX7AKcrvNA7ctqCkpCFjyBTPe5wTY+SgBOYsenWDNkOAu2u
         3ttz2+0Go2jiDs8/3IdOvoKymtoz5Nlg1IREuWrjnngQDlWGxQF/tWl6vqy12hvsfG
         lndCwnRS0OqRHBr+H2RgVdC71A1jMrE3hT54qV5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/28] 4.9.175-stable review
Date:   Thu,  9 May 2019 20:41:52 +0200
Message-Id: <20190509181247.647767531@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.175-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.175-rc1
X-KernelTest-Deadline: 2019-05-11T18:12+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.175 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 11 May 2019 06:11:12 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.175-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.175-rc1

Ben Hutchings <ben@decadent.org.uk>
    timer/debug: Change /proc/timer_stats from 0644 to 0600

Ross Zwisler <zwisler@chromium.org>
    ASoC: Intel: avoid Oops if DMA setup fails

Oliver Neukum <oneukum@suse.com>
    UAS: fix alignment of scatter/gather segments

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Align minimum encryption key size for LE and BR/EDR connections

Young Xiao <YangX92@hotmail.com>
    Bluetooth: hidp: fix buffer overflow

Andrew Vasquez <andrewv@marvell.com>
    scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS routines

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Set virt_boundary_mask to avoid SG overflows

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    USB: serial: f81232: fix interrupt worker not stop

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Fix default lpm_nyet_threshold value

Prasad Sodagudi <psodagud@codeaurora.org>
    genirq: Prevent use-after-free and work list corruption

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    ARM: 8680/1: boot/compressed: fix inappropriate Thumb2 mnemonic for __nop

Linus Torvalds <torvalds@linux-foundation.org>
    mm: add 'try_get_page()' helper function

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Set exclusion range correctly

Dongli Zhang <dongli.zhang@oracle.com>
    virtio-blk: limit number of hw queues by nr_cpu_ids

Wen Yang <wen.yang99@zte.com.cn>
    drm/mediatek: fix possible object reference leak

Varun Prakash <varun@chelsio.com>
    scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix initialization of pt_regs::syscall in start_thread

Jann Horn <jannh@google.com>
    linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Dan Carpenter <dan.carpenter@oracle.com>
    drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Fix Common Pins

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Eliminate opcode tests on mr deref

Daniel Mack <daniel@zonque.org>
    ASoC: cs4270: Set auto-increment bit for register writes

John Hsu <KCHSU0@nuvoton.com>
    ASoC: nau8810: fix the issue of widget with prefixed name

Rander Wang <rander.wang@linux.intel.com>
    ASoC:soc-pcm:fix a codec fixup issue in TDM case

Johan Hovold <johan@kernel.org>
    staging: greybus: power_supply: fix prop-descriptor request size

Andrey Ryabinin <aryabinin@virtuozzo.com>
    ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: fix a race condition when smp task timeout


-------------

Diffstat:

 Makefile                               |  4 +--
 arch/arm/boot/compressed/efi-header.S  |  3 ++-
 arch/x86/events/intel/core.c           |  2 +-
 arch/xtensa/include/asm/processor.h    | 21 ++++++++-------
 drivers/block/virtio_blk.c             |  2 ++
 drivers/gpu/drm/mediatek/mtk_hdmi.c    |  2 +-
 drivers/infiniband/hw/hfi1/rc.c        |  4 +--
 drivers/iommu/amd_iommu_init.c         |  2 +-
 drivers/scsi/csiostor/csio_scsi.c      |  5 +++-
 drivers/scsi/libsas/sas_expander.c     |  9 +++----
 drivers/scsi/qla2xxx/qla_attr.c        |  4 +--
 drivers/staging/greybus/power_supply.c |  2 +-
 drivers/usb/dwc3/core.c                |  2 +-
 drivers/usb/serial/f81232.c            | 39 +++++++++++++++++++++++++++
 drivers/usb/storage/scsiglue.c         | 26 +++++++++---------
 drivers/usb/storage/uas.c              | 35 +++++++++++++++---------
 include/linux/kernel.h                 |  4 +--
 include/linux/mm.h                     |  9 +++++++
 include/net/bluetooth/hci_core.h       |  3 +++
 kernel/irq/manage.c                    |  4 ++-
 kernel/time/timer_stats.c              |  2 +-
 lib/ubsan.c                            | 49 ++++++++++++++++------------------
 net/bluetooth/hci_conn.c               |  8 ++++++
 net/bluetooth/hidp/sock.c              |  1 +
 sound/soc/codecs/cs4270.c              |  1 +
 sound/soc/codecs/nau8810.c             |  4 +--
 sound/soc/codecs/tlv320aic32x4.c       |  2 ++
 sound/soc/intel/common/sst-firmware.c  |  8 ++++--
 sound/soc/soc-pcm.c                    |  7 +++--
 29 files changed, 174 insertions(+), 90 deletions(-)


