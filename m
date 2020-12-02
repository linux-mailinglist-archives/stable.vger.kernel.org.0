Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60462CB823
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgLBJJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 04:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbgLBJJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 04:09:08 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.210
Date:   Wed,  2 Dec 2020 10:09:32 +0100
Message-Id: <160690017278228@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.210 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 
 arch/arm64/include/asm/pgtable.h             |   34 +++----
 arch/x86/events/intel/cstate.c               |    6 -
 arch/x86/events/intel/rapl.c                 |   14 --
 arch/x86/events/intel/uncore.c               |    4 
 arch/x86/events/intel/uncore.h               |   12 +-
 arch/x86/kernel/cpu/bugs.c                   |    4 
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c     |   65 +++++--------
 arch/x86/xen/spinlock.c                      |   12 ++
 drivers/dma/pl330.c                          |    2 
 drivers/dma/xilinx/xilinx_dma.c              |    4 
 drivers/hid/hid-cypress.c                    |   44 ++++++++-
 drivers/hid/hid-ids.h                        |    3 
 drivers/hid/hid-input.c                      |    3 
 drivers/hid/hid-sensor-hub.c                 |    3 
 drivers/infiniband/hw/mthca/mthca_cq.c       |   10 +-
 drivers/input/serio/i8042.c                  |   12 ++
 drivers/net/can/m_can/m_can.c                |    2 
 drivers/net/can/usb/gs_usb.c                 |  131 ++++++++++++++-------------
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   17 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |    4 
 drivers/net/ethernet/ibm/ibmvnic.c           |    6 +
 drivers/nfc/s3fwrn5/i2c.c                    |    4 
 drivers/nvme/host/pci.c                      |   15 +++
 drivers/pci/bus.c                            |    6 -
 drivers/phy/tegra/xusb.c                     |    1 
 drivers/platform/x86/toshiba_acpi.c          |    3 
 drivers/scsi/libiscsi.c                      |   23 +++-
 drivers/scsi/ufs/ufshcd.c                    |    6 -
 drivers/target/iscsi/iscsi_target.c          |   17 ++-
 drivers/usb/core/config.c                    |   11 ++
 drivers/usb/core/devio.c                     |   14 +-
 drivers/usb/core/quirks.c                    |   38 +++++++
 drivers/usb/core/usb.h                       |    3 
 drivers/usb/gadget/function/f_midi.c         |   10 +-
 drivers/usb/gadget/legacy/inode.c            |    3 
 drivers/video/fbdev/hyperv_fb.c              |    7 +
 fs/btrfs/inode.c                             |   63 ++++++++----
 fs/btrfs/qgroup.c                            |    2 
 fs/btrfs/tests/inode-tests.c                 |    1 
 fs/btrfs/volumes.c                           |    7 +
 fs/efivarfs/inode.c                          |    2 
 fs/efivarfs/super.c                          |    1 
 fs/proc/self.c                               |    7 +
 include/linux/usb/quirks.h                   |    3 
 include/scsi/libiscsi.h                      |    3 
 include/uapi/linux/wireless.h                |    6 +
 mm/huge_memory.c                             |    9 -
 net/batman-adv/log.c                         |    1 
 sound/pci/hda/patch_hdmi.c                   |   85 +++++++++--------
 tools/perf/util/dwarf-aux.c                  |    8 +
 tools/perf/util/event.c                      |    7 -
 52 files changed, 482 insertions(+), 278 deletions(-)

Alan Stern (2):
      USB: core: Change %pK for __user pointers to %px
      USB: core: Fix regression in Hercules audio card

Anand K Mistry (1):
      x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Ard Biesheuvel (1):
      efivarfs: revert "fix memory leak in efivarfs_create()"

Brian Masney (1):
      x86/xen: don't unbind uninitialized lock_kicker_irq

Dexuan Cui (1):
      video: hyperv_fb: Fix the cache type when mapping the VRAM

Filipe Manana (1):
      btrfs: fix lockdep splat when reading qgroup config on mount

Frank Yang (1):
      HID: cypress: Support Varmilo Keyboards' media hotkeys

Gerald Schaefer (1):
      mm/userfaultfd: do not access vma->vm_mm after calling handle_userfault()

Greg Kroah-Hartman (1):
      Linux 4.14.210

Hans de Goede (2):
      Input: i8042 - allow insmod to succeed on devices without an i8042 controller
      HID: Add Logitech Dinovo Edge battery quirk

Hauke Mehrtens (1):
      wireless: Use linux/stddef.h instead of stddef.h

Igor Lubashev (1):
      perf event: Check ref_reloc_sym before using it

Jens Axboe (1):
      proc: don't allow async path resolution of /proc/self components

Johan Hovold (1):
      USB: core: add endpoint-blacklist quirk

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close

Kaixu Xia (1):
      platform/x86: toshiba_acpi: Fix the wrong variable assignment

Krzysztof Kozlowski (1):
      nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Lee Duncan (1):
      scsi: libiscsi: Fix NOP race condition

Lijun Pan (2):
      ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
      ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq

Marc Ferland (1):
      dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant

Marc Kleine-Budde (2):
      can: gs_usb: fix endianess problem with candleLight firmware
      can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Marc Zyngier (1):
      phy: tegra: xusb: Fix dangling pointer on probe failure

Masami Hiramatsu (1):
      perf probe: Fix to die_entrypc() returns error correctly

Michael Chan (1):
      bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Mike Christie (1):
      scsi: target: iscsi: Fix cmd abort fabric stop race

Minwoo Im (1):
      nvme: free sq/cq dbbuf pointers when dbbuf set fails

Pablo Ceballos (1):
      HID: hid-sensor-hub: Fix issue with devices with no report ID

Qu Wenruo (2):
      btrfs: tree-checker: Enhance chunk checker to validate chunk profile
      btrfs: inode: Verify inode mode to avoid NULL pointer dereference

Rajat Jain (1):
      PCI: Add device even if driver attach failed

Sami Tolvanen (1):
      perf/x86: fix sysfs type mismatches

Shay Agroskin (1):
      net: ena: set initial DMA width to avoid intel iommu issue

Stanley Chu (1):
      scsi: ufs: Fix race between shutdown and runtime resume flow

Su Yue (1):
      btrfs: adjust return values of btrfs_inode_by_name

Sugar Zhang (1):
      dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

Takashi Iwai (1):
      ALSA: hda/hdmi: Use single mutex unlock in error paths

Will Deacon (2):
      arm64: pgtable: Fix pte_accessible()
      arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()

Xiaochen Shen (2):
      x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak
      x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak

Xiongfeng Wang (1):
      IB/mthca: fix return value of error branch in mthca_init_cq()

Zhang Changzhong (2):
      bnxt_en: fix error return code in bnxt_init_one()
      bnxt_en: fix error return code in bnxt_init_board()

Zhang Qilong (2):
      usb: gadget: f_midi: Fix memleak in f_midi_alloc
      usb: gadget: Fix memleak in gadgetfs_fill_super

