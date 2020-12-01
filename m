Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB322C9CD4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgLAJBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387673AbgLAJBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:01:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74051206D8;
        Tue,  1 Dec 2020 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813252;
        bh=6etCnKf9NN1R2GT89FfD2GC6ln5MsKWGYw/YD3PFhi0=;
        h=From:To:Cc:Subject:Date:From;
        b=Myp9yprDunK2IpEvUGmRf+0YYQZw9iwKYvIN5+dU7jnRh4PYVsbsK6rCabVKq29p9
         C9O1TJVDLHkShiOP5dA1BrfUzyvIuz6iIoNXyfq+Gy5+4bznefH5WGho+m3JkeXwDy
         663weNkYncxhYVt0IWxFqvmT4UwqsigYDvns/RbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/57] 4.19.161-rc1 review
Date:   Tue,  1 Dec 2020 09:53:05 +0100
Message-Id: <20201201084647.751612010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.161-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.161-rc1
X-KernelTest-Deadline: 2020-12-03T08:46+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.161 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.161-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.161-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix regression in Hercules audio card

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak

Anand K Mistry <amistry@google.com>
    x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: Fix memleak in gadgetfs_fill_super

penghao <penghao@uniontech.com>
    USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z TIO built-in usb-audio card

Zhang Qilong <zhangqilong3@huawei.com>
    usb: gadget: f_midi: Fix memleak in f_midi_alloc

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Change %pK for __user pointers to %px

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix to die_entrypc() returns error correctly

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Kaixu Xia <kaixuxia@tencent.com>
    platform/x86: toshiba_acpi: Fix the wrong variable assignment

Benjamin Berg <bberg@redhat.com>
    platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix endianess problem with candleLight firmware

Ard Biesheuvel <ardb@kernel.org>
    efivarfs: revert "fix memory leak in efivarfs_create()"

Rui Miguel Silva <rui.silva@linaro.org>
    optee: add writeback to valid memory type

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues

Shay Agroskin <shayagr@amazon.com>
    net: ena: set initial DMA width to avoid intel iommu issue

Krzysztof Kozlowski <krzk@kernel.org>
    nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    IB/mthca: fix return value of error branch in mthca_init_cq()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix tear down of async TX buffers

Raju Rangoju <rajur@chelsio.com>
    cxgb4: fix the panic caused by non smac rewrite

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Dexuan Cui <decui@microsoft.com>
    video: hyperv_fb: Fix the cache type when mapping the VRAM

Zhang Changzhong <zhangchangzhong@huawei.com>
    bnxt_en: fix error return code in bnxt_init_board()

Zhang Changzhong <zhangchangzhong@huawei.com>
    bnxt_en: fix error return code in bnxt_init_one()

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix race between shutdown and runtime resume flow

Marc Kleine-Budde <mkl@pengutronix.de>
    ARM: dts: dra76x: m_can: fix order of clocks

Taehee Yoo <ap420073@gmail.com>
    batman-adv: set .owner to THIS_MODULE

Marc Zyngier <maz@kernel.org>
    phy: tegra: xusb: Fix dangling pointer on probe failure

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    xtensa: uaccess: Add missing __user to strncpy_from_user() prototype

Sami Tolvanen <samitolvanen@google.com>
    perf/x86: fix sysfs type mismatches

Mike Christie <michael.christie@oracle.com>
    scsi: target: iscsi: Fix cmd abort fabric stop race

Lee Duncan <lduncan@suse.com>
    scsi: libiscsi: Fix NOP race condition

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Minwoo Im <minwoo.im.dev@gmail.com>
    nvme: free sq/cq dbbuf pointers when dbbuf set fails

Jens Axboe <axboe@kernel.dk>
    proc: don't allow async path resolution of /proc/self components

Hans de Goede <hdegoede@redhat.com>
    HID: Add Logitech Dinovo Edge battery quirk

Brian Masney <bmasney@redhat.com>
    x86/xen: don't unbind uninitialized lock_kicker_irq

Marc Ferland <ferlandm@amotus.ca>
    dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant

Chris Ye <lzye@google.com>
    HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices

Pablo Ceballos <pceballos@google.com>
    HID: hid-sensor-hub: Fix issue with devices with no report ID

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - allow insmod to succeed on devices without an i8042 controller

Jiri Kosina <jkosina@suse.cz>
    HID: add support for Sega Saturn

Frank Yang <puilp0502@gmail.com>
    HID: cypress: Support Varmilo Keyboards' media hotkeys

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

Lyude Paul <lyude@redhat.com>
    drm/atomic_helper: Stop modesets on unregistered connectors harder

Will Deacon <will@kernel.org>
    arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()

Will Deacon <will@kernel.org>
    arm64: pgtable: Fix pte_accessible()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix split-irqchip vs interrupt injection window request

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

Hauke Mehrtens <hauke@hauke-m.de>
    wireless: Use linux/stddef.h instead of stddef.h

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lockdep splat when reading qgroup config on mount

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't access possibly stale fs_info data for printing duplicate device

Cong Wang <cong.wang@bytedance.com>
    netfilter: clear skb->next in NF_HOOK_LIST()

Igor Lubashev <ilubashe@akamai.com>
    perf event: Check ref_reloc_sym before using it


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/dra76x.dtsi                     |   4 +-
 arch/arm64/include/asm/pgtable.h                  |  34 +++---
 arch/x86/events/intel/cstate.c                    |   6 +-
 arch/x86/events/intel/rapl.c                      |  14 +--
 arch/x86/events/intel/uncore.c                    |   4 +-
 arch/x86/events/intel/uncore.h                    |  12 +-
 arch/x86/include/asm/kvm_host.h                   |   1 +
 arch/x86/kernel/cpu/bugs.c                        |   4 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          |  65 +++++------
 arch/x86/kvm/irq.c                                |  85 ++++++--------
 arch/x86/kvm/lapic.c                              |   2 +-
 arch/x86/kvm/x86.c                                |  18 +--
 arch/x86/xen/spinlock.c                           |  12 +-
 arch/xtensa/include/asm/uaccess.h                 |   2 +-
 drivers/dma/pl330.c                               |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                   |   4 +-
 drivers/gpu/drm/drm_atomic.c                      |  21 ----
 drivers/gpu/drm/drm_atomic_helper.c               |  21 +++-
 drivers/gpu/drm/drm_connector.c                   |  11 +-
 drivers/gpu/drm/i915/intel_dp_mst.c               |   8 +-
 drivers/hid/hid-cypress.c                         |  44 +++++++-
 drivers/hid/hid-ids.h                             |   8 ++
 drivers/hid/hid-input.c                           |   3 +
 drivers/hid/hid-quirks.c                          |   5 +
 drivers/hid/hid-sensor-hub.c                      |   3 +-
 drivers/infiniband/hw/mthca/mthca_cq.c            |  10 +-
 drivers/input/serio/i8042.c                       |  12 +-
 drivers/net/can/m_can/m_can.c                     |   2 +-
 drivers/net/can/usb/gs_usb.c                      | 131 ++++++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.c      |  17 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                |   6 +
 drivers/nfc/s3fwrn5/i2c.c                         |   4 +-
 drivers/nvme/host/pci.c                           |  15 +++
 drivers/phy/tegra/xusb.c                          |   1 +
 drivers/platform/x86/thinkpad_acpi.c              |   1 +
 drivers/platform/x86/toshiba_acpi.c               |   3 +-
 drivers/s390/net/qeth_core_main.c                 |   6 -
 drivers/scsi/libiscsi.c                           |  23 ++--
 drivers/scsi/ufs/ufshcd.c                         |   6 +-
 drivers/target/iscsi/iscsi_target.c               |  17 ++-
 drivers/tee/optee/call.c                          |   3 +-
 drivers/usb/core/devio.c                          |  14 +--
 drivers/usb/core/quirks.c                         |  10 ++
 drivers/usb/gadget/function/f_midi.c              |  10 +-
 drivers/usb/gadget/legacy/inode.c                 |   3 +
 drivers/video/fbdev/hyperv_fb.c                   |   7 +-
 fs/btrfs/qgroup.c                                 |   2 +-
 fs/btrfs/volumes.c                                |   8 +-
 fs/efivarfs/inode.c                               |   2 +
 fs/efivarfs/super.c                               |   1 -
 fs/proc/self.c                                    |   7 ++
 include/drm/drm_connector.h                       |  71 +++++++++++-
 include/linux/netfilter.h                         |   2 +-
 include/scsi/libiscsi.h                           |   3 +
 include/uapi/linux/wireless.h                     |   6 +-
 net/batman-adv/log.c                              |   1 +
 sound/pci/hda/patch_hdmi.c                        |  20 ++--
 tools/perf/util/dwarf-aux.c                       |   8 ++
 tools/perf/util/event.c                           |   7 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  |  22 +++-
 63 files changed, 541 insertions(+), 324 deletions(-)


