Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AC532610B
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 11:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhBZKMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 05:12:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhBZKKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 05:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527E664EF3;
        Fri, 26 Feb 2021 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614334211;
        bh=J8488/xWlzmQzNniMsL80fBVsFtQWrYNRztSdfJwqAk=;
        h=From:To:Cc:Subject:Date:From;
        b=WhCwCAwnN+mIiDnlP0uo/JttnWB4Zl9f3pi1WL6S+ek62KLlsQETmefsOijLSxAa9
         dwObUzDq/Lx0RwWUqjwidIr4CPFemwOnJ4QWm91YUtA1qtyKuDhoH73K/xcLGuetCI
         6HInXnvXkZi5cJ3pRUFFpuCmNEQ/tyOVvQmQNOwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.101
Date:   Fri, 26 Feb 2021 11:10:06 +0100
Message-Id: <1614334206157249@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.101 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |    1 
 drivers/hid/hid-core.c                             |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h |    1 
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/usb/core/quirks.c                          |    9 ++-
 fs/cifs/connect.c                                  |    1 
 fs/dax.c                                           |   10 +--
 fs/ntfs/inode.c                                    |    6 ++
 include/linux/mm.h                                 |    8 +-
 kernel/bpf/verifier.c                              |   10 ++-
 mm/memory.c                                        |   57 +++++++++++----------
 scripts/Makefile                                   |    9 ++-
 scripts/recordmcount.pl                            |    6 +-
 virt/kvm/kvm_main.c                                |   17 ++++--
 15 files changed, 92 insertions(+), 52 deletions(-)

Christoph Hellwig (2):
      mm: unexport follow_pte_pmd
      mm: simplify follow_pte{,pmd}

Christoph Schemmel (1):
      NET: usb: qmi_wwan: Adding support for Cinterion MV31

Daniel Borkmann (1):
      bpf: Fix truncation handling for mod32 dst reg wrt zero

Greg Kroah-Hartman (1):
      Linux 5.4.101

Johan Hovold (1):
      USB: quirks: sort quirk entries

Paolo Bonzini (2):
      KVM: do not assume PTE is writable after follow_pfn
      mm: provide a saner PTE walking API for modules

Raju Rangoju (1):
      cxgb4: Add new T6 PCI device id 0x6092

Rolf Eike Beer (2):
      scripts: use pkg-config to locate libcrypto
      scripts: set proper OpenSSL include dir also for sign-file

Rong Chen (1):
      scripts/recordmcount.pl: support big endian for ARCH sh

Rustam Kovhaev (1):
      ntfs: check for valid standard information attribute

Sameer Pujar (1):
      arm64: tegra: Add power-domain for Tegra210 HDA

Sean Christopherson (1):
      KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Will McVicker (1):
      HID: make arrays usage and value to be the same

