Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A993A2A5B
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 13:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFJLhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 07:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFJLhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F03261412;
        Thu, 10 Jun 2021 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623324922;
        bh=NftKmhKQyJMqe9VFtzaomRGYJTuzG87sC+dGlXJ9boA=;
        h=From:To:Cc:Subject:Date:From;
        b=LerNOYCmwT3C0hznk9mu611ng+CXEJUu0JCys8vtPbKv65UW/VmSWhJNQamts1Dvp
         3djnmszDHvQX/XXcKJbLZE0NuX5oZZMgK4hMx8LM4n66NSm84Fm4iPdiqdVtUY/1iT
         7c2hcRJRIJemnoN3ZZr4FRSf4b2g5Mi+qAa+H1Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.194
Date:   Thu, 10 Jun 2021 13:35:12 +0200
Message-Id: <162332491244163@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.194 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm64/kvm/sys_regs.c                         |   42 ++--
 arch/x86/include/asm/apic.h                       |    1 
 arch/x86/kernel/apic/apic.c                       |    1 
 arch/x86/kernel/apic/vector.c                     |   20 +
 arch/x86/kvm/svm.c                                |    8 
 drivers/acpi/bus.c                                |   42 +---
 drivers/firmware/efi/cper.c                       |    4 
 drivers/firmware/efi/memattr.c                    |    5 
 drivers/hid/hid-multitouch.c                      |   10 
 drivers/hid/i2c-hid/i2c-hid-core.c                |    4 
 drivers/hid/usbhid/hid-pidff.c                    |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    1 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    3 
 drivers/net/usb/cdc_ncm.c                         |   12 +
 drivers/usb/dwc2/core_intr.c                      |    4 
 drivers/vfio/pci/Kconfig                          |    1 
 drivers/vfio/pci/vfio_pci_config.c                |    2 
 drivers/vfio/platform/vfio_platform_common.c      |    2 
 drivers/xen/xen-pciback/vpci.c                    |   14 -
 fs/btrfs/extent-tree.c                            |   12 -
 fs/btrfs/file-item.c                              |   10 
 fs/btrfs/inode.c                                  |   12 +
 fs/btrfs/tree-log.c                               |   13 -
 fs/ext4/extents.c                                 |   43 ++--
 fs/ocfs2/file.c                                   |   55 ++++-
 include/linux/perf_event.h                        |    5 
 include/linux/usb/usbnet.h                        |    2 
 include/net/caif/caif_dev.h                       |    2 
 include/net/caif/cfcnfg.h                         |    2 
 include/net/caif/cfserl.h                         |    1 
 include/uapi/linux/bpf.h                          |   14 +
 init/main.c                                       |    2 
 kernel/bpf/syscall.c                              |    7 
 kernel/bpf/verifier.c                             |    3 
 kernel/events/core.c                              |   62 +++---
 kernel/sched/fair.c                               |    7 
 mm/hugetlb.c                                      |   14 +
 net/bluetooth/hci_core.c                          |    7 
 net/bluetooth/hci_sock.c                          |    4 
 net/caif/caif_dev.c                               |   13 -
 net/caif/caif_usb.c                               |   14 +
 net/caif/cfcnfg.c                                 |   16 +
 net/caif/cfserl.c                                 |    5 
 net/ieee802154/nl-mac.c                           |    4 
 net/ieee802154/nl-phy.c                           |    4 
 net/netfilter/ipvs/ip_vs_ctl.c                    |    2 
 net/netfilter/nfnetlink_cthelper.c                |    8 
 net/nfc/llcp_sock.c                               |    2 
 net/tipc/bearer.c                                 |   94 ++++++---
 net/wireless/core.h                               |    2 
 net/wireless/nl80211.c                            |    7 
 net/wireless/util.c                               |   39 +++
 samples/vfio-mdev/mdpy-fb.c                       |   13 -
 sound/core/timer.c                                |    3 
 sound/pci/hda/patch_realtek.c                     |    1 
 sound/usb/mixer_quirks.c                          |    2 
 tools/include/uapi/linux/bpf.h                    |   14 +
 tools/lib/bpf/bpf.c                               |    8 
 tools/lib/bpf/bpf.h                               |    2 
 tools/testing/selftests/bpf/test_align.c          |    4 
 tools/testing/selftests/bpf/test_verifier.c       |  224 +++++++++++++++-------
 62 files changed, 663 insertions(+), 274 deletions(-)

Ahelenia Ziemiańska (1):
      HID: multitouch: require Finger field to mark Win8 reports as MT

Anand Jain (1):
      btrfs: fix unmountable seed device after fstrim

Anant Thazhemadam (1):
      nl80211: validate key indexes for cfg80211_registered_device

Arnd Bergmann (1):
      HID: i2c-hid: fix format string mismatch

Björn Töpel (2):
      selftests/bpf: add "any alignment" annotation for some tests
      selftests/bpf: Avoid running unprivileged tests with alignment requirements

Carlos M (1):
      ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx

Cheng Jian (1):
      sched/fair: Optimize select_idle_cpu

Daniel Borkmann (2):
      bpf: fix test suite to enable all unpriv program types
      bpf: test make sure to run unpriv test cases in test_verifier

David S. Miller (4):
      bpf: Add BPF_F_ANY_ALIGNMENT.
      bpf: Adjust F_NEEDS_EFFICIENT_UNALIGNED_ACCESS handling in test_verifier.c
      bpf: Make more use of 'any' alignment in test_verifier.c
      bpf: Apply F_NEEDS_EFFICIENT_UNALIGNED_ACCESS to more ACCEPT test cases.

Erik Schmauss (1):
      ACPI: probe ECDT before loading AML tables regardless of module-level code flag

Grant Grundler (1):
      net: usb: cdc_ncm: don't spew notifications

Greg Kroah-Hartman (1):
      Linux 4.19.194

Heiner Kallweit (1):
      efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Hoang Le (2):
      tipc: add extack messages for bearer/media failure
      tipc: fix unique bearer names sanity check

Ian Rogers (1):
      perf/cgroups: Don't rotate events for cgroups unnecessarily

Jan Beulich (1):
      xen-pciback: redo VF placement in the virtual topology

Joe Stringer (1):
      selftests/bpf: Generalize dummy program types

Josef Bacik (4):
      btrfs: mark ordered extent and inode with error if we fail to finish
      btrfs: fix error handling in btrfs_del_csums
      btrfs: return errors from btrfs_del_csums in cleanup_ref_head
      btrfs: fixup error handling in fixup_inode_link_counts

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Junxiao Bi (1):
      ocfs2: fix data corruption by fallocate

Krzysztof Kozlowski (1):
      nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Magnus Karlsson (1):
      ixgbevf: add correct exception tracing for XDP

Marc Zyngier (1):
      KVM: arm64: Fix debug register indexing

Mark Rutland (1):
      pid: take a reference when initializing `cad_pid`

Max Gurtovoy (1):
      vfio/platform: fix module_put call in error flow

Michael Chan (1):
      bnxt_en: Remove the setting of dev_port.

Mina Almasry (1):
      mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Pavel Skripkin (4):
      net: caif: added cfserl_release function
      net: caif: add proper error handling
      net: caif: fix memory leak in caif_device_notify
      net: caif: fix memory leak in cfusbl_device_notify

Phil Elwell (1):
      usb: dwc2: Fix build in periphal-only mode

Pierre-Louis Bossart (1):
      ALSA: usb: update old-style static const declaration

Rafael J. Wysocki (1):
      ACPI: EC: Look for ECDT EC after calling acpi_load_tables()

Randy Dunlap (1):
      vfio/pci: zap_vma_ptes() needs MMU

Rasmus Villemoes (1):
      efi: cper: fix snprintf() use in cper_dimm_err_location()

Sean Christopherson (1):
      KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Song Liu (1):
      perf/core: Fix corner case in perf_rotate_context()

Takashi Iwai (1):
      ALSA: timer: Fix master timer notification

Thomas Gleixner (1):
      x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing

Wei Yongjun (2):
      samples: vfio-mdev: fix error handing in mdpy_fb_probe()
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Ye Bin (1):
      ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Zhen Lei (3):
      vfio/pci: Fix error return code in vfio_ecap_init()
      HID: pidff: fix error return code in hid_pidff_init()
      ieee802154: fix error return code in ieee802154_add_iface()

