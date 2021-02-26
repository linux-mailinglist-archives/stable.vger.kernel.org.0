Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617F5326112
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 11:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBZKNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 05:13:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhBZKLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 05:11:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF6364EFA;
        Fri, 26 Feb 2021 10:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614334238;
        bh=hxzhcJQnTAt8RobDsenZaTWavwYOBBcUVpaHj9cV6P4=;
        h=From:To:Cc:Subject:Date:From;
        b=ovH5rTq8vC8F+6dA2cHAlPs3ol6VcJfIQ7NA1eLBAC+qsjNH19JHdOoc8Y2HcSLUE
         OjpuYHEpAPdbiwABs05HdbCsJIha2sFp8yn14yJ+13fovvvT3f6T7AdmWAinX9QBwz
         FxcLXikTQ/X0pKV3xseZCUJ0OlUW+doUp0bS0IM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.19
Date:   Fri, 26 Feb 2021 11:10:23 +0100
Message-Id: <1614334223253124@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.19 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    4 -
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |    1 
 arch/x86/kvm/mmu/mmu.c                             |    2 
 drivers/bluetooth/btusb.c                          |    7 ++
 drivers/gpu/drm/xlnx/zynqmp_disp.c                 |   15 ++---
 drivers/hid/hid-core.c                             |    6 +-
 drivers/hwmon/dell-smm-hwmon.c                     |    7 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h |    1 
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/nvme/host/rdma.c                           |    2 
 drivers/usb/core/quirks.c                          |    9 ++-
 fs/ceph/mdsmap.c                                   |    4 -
 fs/cifs/connect.c                                  |    1 
 fs/dax.c                                           |   10 +--
 fs/ntfs/inode.c                                    |    6 ++
 include/linux/mm.h                                 |    8 +-
 include/rdma/ib_verbs.h                            |   13 ++++
 kernel/bpf/verifier.c                              |   10 ++-
 mm/memory.c                                        |   57 +++++++++++----------
 net/rds/ib.h                                       |    7 --
 scripts/gen_autoksyms.sh                           |    3 +
 scripts/recordmcount.pl                            |    6 +-
 virt/kvm/kvm_main.c                                |   17 ++++--
 23 files changed, 127 insertions(+), 70 deletions(-)

Christoph Hellwig (4):
      RDMA: Lift ibdev_to_node from rds to common code
      nvme-rdma: Use ibdev_to_node instead of dereferencing ->dma_device
      mm: unexport follow_pte_pmd
      mm: simplify follow_pte{,pmd}

Christoph Schemmel (1):
      NET: usb: qmi_wwan: Adding support for Cinterion MV31

Daniel Borkmann (1):
      bpf: Fix truncation handling for mod32 dst reg wrt zero

Greg Kroah-Hartman (1):
      Linux 5.10.19

Hui Wang (1):
      Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

Johan Hovold (1):
      USB: quirks: sort quirk entries

Luis Henriques (1):
      ceph: downgrade warning from mdsmap decode to debug

Masahiro Yamada (1):
      kbuild: fix CONFIG_TRIM_UNUSED_KSYMS build for ppc64

Paolo Bonzini (2):
      KVM: do not assume PTE is writable after follow_pfn
      mm: provide a saner PTE walking API for modules

Quanyang Wang (1):
      drm/xlnx: fix kmemleak by sending vblank_event in atomic_disable

Raju Rangoju (1):
      cxgb4: Add new T6 PCI device id 0x6092

Rong Chen (1):
      scripts/recordmcount.pl: support big endian for ARCH sh

Rustam Kovhaev (1):
      ntfs: check for valid standard information attribute

Sameer Pujar (1):
      arm64: tegra: Add power-domain for Tegra210 HDA

Sean Christopherson (2):
      KVM: x86: Zap the oldest MMU pages, not the newest
      KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Thomas Hebb (1):
      hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist

Will McVicker (1):
      HID: make arrays usage and value to be the same

