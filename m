Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6413C1925E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfEISq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbfEISqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:46:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0928C217F5;
        Thu,  9 May 2019 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427584;
        bh=34QExHLqEx7A/HvY9cxS8Iiun9yaNg1Eh70QXzOY9G0=;
        h=From:To:Cc:Subject:Date:From;
        b=tZ+lIgfkN6Shl1qyBmNbYfS6z2jHo+jscl9rvzl3DI/s4A+s1WT9SNNFk3xQ9yrDK
         dkdMwWg4T5maC/T0+ia16EZ+KziUsmdvE9tHsdN3C3XqaWY01GwQbHBTtG7K+7V+hI
         HBaaWC8QwQD6/OwnyZGhx9OKAtbGnqIvsZja+cm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/42] 4.14.118-stable review
Date:   Thu,  9 May 2019 20:41:49 +0200
Message-Id: <20190509181252.616018683@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.118-rc1
X-KernelTest-Deadline: 2019-05-11T18:13+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.118 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 11 May 2019 06:11:15 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.118-rc1

Will Deacon <will.deacon@arm.com>
    arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Will Deacon <will.deacon@arm.com>
    locking/futex: Allow low-level atomic operations to return -EAGAIN

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

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake support

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Set virt_boundary_mask to avoid SG overflows

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unthrottle races

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    USB: serial: f81232: fix interrupt worker not stop

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Fix default lpm_nyet_threshold value

Prasad Sodagudi <psodagud@codeaurora.org>
    genirq: Prevent use-after-free and work list corruption

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Set exclusion range correctly

Stephen Boyd <sboyd@kernel.org>
    platform/x86: pmc_atom: Drop __initconst on dmi table

Dongli Zhang <dongli.zhang@oracle.com>
    virtio-blk: limit number of hw queues by nr_cpu_ids

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: Intel: kbl: fix wrong number of channels

Wen Yang <wen.yang99@zte.com.cn>
    drm/mediatek: fix possible object reference leak

Varun Prakash <varun@chelsio.com>
    scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove

Longpeng <longpeng2@huawei.com>
    virtio_pci: fix a NULL pointer reference in vp_del_vqs

Qian Cai <cai@lca.pw>
    slab: fix a crash by reading /proc/slab_allocators

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: pdm: fix regmap_ops hang issue

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix initialization of pt_regs::syscall in start_thread

Jann Horn <jannh@google.com>
    linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

Peter Zijlstra <peterz@infradead.org>
    perf/x86/intel: Initialize TFA MSR

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Dan Carpenter <dan.carpenter@oracle.com>
    drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Fix Common Pins

Chong Qiao <qiaochong@loongson.cn>
    MIPS: KGDB: fix kgdb support for SMP platforms.

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Eliminate opcode tests on mr deref

Daniel Mack <daniel@zonque.org>
    ASoC: cs4270: Set auto-increment bit for register writes

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Add locking to wm_adsp2_bus_error

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: samsung: odroid: Fix clock configuration for 44100 sample rate

John Hsu <KCHSU0@nuvoton.com>
    ASoC: nau8810: fix the issue of widget with prefixed name

John Hsu <KCHSU0@nuvoton.com>
    ASoC: nau8824: fix the issue of the widget with prefix name

Rander Wang <rander.wang@linux.intel.com>
    ASoC:soc-pcm:fix a codec fixup issue in TDM case

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: hdmi-codec: fix S/PDIF DAI

Johan Hovold <johan@kernel.org>
    staging: greybus: power_supply: fix prop-descriptor request size

Andrey Ryabinin <aryabinin@virtuozzo.com>
    ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cleanup()

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: fix a race condition when smp task timeout


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/futex.h                     |  55 +++---
 arch/mips/kernel/kgdb.c                            |   3 +-
 arch/x86/events/intel/core.c                       |   8 +-
 arch/xtensa/include/asm/processor.h                |  21 ++-
 drivers/block/virtio_blk.c                         |   2 +
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |   2 +-
 drivers/hv/hv.c                                    |   1 -
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/infiniband/hw/hfi1/rc.c                    |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c     |   2 +
 drivers/iommu/amd_iommu_init.c                     |   2 +-
 drivers/platform/x86/pmc_atom.c                    |   2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |   5 +-
 drivers/scsi/libsas/sas_expander.c                 |   9 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   4 +-
 drivers/staging/greybus/power_supply.c             |   2 +-
 drivers/usb/class/cdc-acm.c                        |  32 +++-
 drivers/usb/dwc3/core.c                            |   2 +-
 drivers/usb/serial/f81232.c                        |  39 +++++
 drivers/usb/storage/scsiglue.c                     |  26 ++-
 drivers/usb/storage/uas.c                          |  35 ++--
 drivers/virtio/virtio_pci_common.c                 |   8 +-
 include/linux/kernel.h                             |   4 +-
 include/net/bluetooth/hci_core.h                   |   3 +
 kernel/futex.c                                     | 188 +++++++++++++--------
 kernel/irq/manage.c                                |   4 +-
 lib/ubsan.c                                        |  49 +++---
 mm/slab.c                                          |   3 +-
 net/bluetooth/hci_conn.c                           |   8 +
 net/bluetooth/hidp/sock.c                          |   1 +
 sound/soc/codecs/cs4270.c                          |   1 +
 sound/soc/codecs/hdmi-codec.c                      | 118 ++++++-------
 sound/soc/codecs/nau8810.c                         |   4 +-
 sound/soc/codecs/nau8824.c                         |  46 ++++-
 sound/soc/codecs/tlv320aic32x4.c                   |   2 +
 sound/soc/codecs/wm_adsp.c                         |  11 +-
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   2 +-
 sound/soc/intel/common/sst-firmware.c              |   8 +-
 sound/soc/rockchip/rockchip_pdm.c                  |   2 +
 sound/soc/samsung/odroid.c                         |   4 +-
 sound/soc/soc-pcm.c                                |   7 +-
 42 files changed, 471 insertions(+), 267 deletions(-)


