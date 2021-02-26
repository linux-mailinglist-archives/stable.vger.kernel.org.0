Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7175332610F
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 11:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhBZKM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 05:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhBZKLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 05:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE40964EF0;
        Fri, 26 Feb 2021 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614334221;
        bh=cCvpOeiBxcsD5SgG0hnI/5Z7zIF1il7xvNNp26HhUzk=;
        h=From:To:Cc:Subject:Date:From;
        b=dHzVaGndLq4habhKyemec6/5t/kl3dOP8CAEZqVTC7wpoKau6CPiKLbvefjme984d
         A40qwa+yQnJHX3CW7+IeWgLqOPCPfGSymz0lqnf8zdmc6HRST0ql3WG6gTDt+25mhU
         kE6VHHz2YSwhorol5MEcid0nyWwHrGMDufH97ie4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.2
Date:   Fri, 26 Feb 2021 11:10:14 +0100
Message-Id: <1614334214168@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.2 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    1 
 arch/s390/pci/pci_mmio.c                 |    4 +--
 arch/x86/kvm/mmu/mmu.c                   |    2 -
 drivers/bluetooth/btusb.c                |    7 +++++
 drivers/hid/hid-core.c                   |    6 ++--
 drivers/hwmon/dell-smm-hwmon.c           |    7 +++++
 drivers/usb/core/quirks.c                |    9 ++++--
 fs/dax.c                                 |    5 ++-
 fs/ntfs/inode.c                          |    6 ++++
 include/linux/mm.h                       |    6 +++-
 kernel/bpf/verifier.c                    |   10 ++++---
 mm/memory.c                              |   41 +++++++++++++++++++++++++++----
 virt/kvm/kvm_main.c                      |   17 +++++++++---
 14 files changed, 96 insertions(+), 27 deletions(-)

Daniel Borkmann (1):
      bpf: Fix truncation handling for mod32 dst reg wrt zero

Greg Kroah-Hartman (1):
      Linux 5.11.2

Hui Wang (1):
      Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

Johan Hovold (1):
      USB: quirks: sort quirk entries

Paolo Bonzini (2):
      KVM: do not assume PTE is writable after follow_pfn
      mm: provide a saner PTE walking API for modules

Rustam Kovhaev (1):
      ntfs: check for valid standard information attribute

Sameer Pujar (1):
      arm64: tegra: Add power-domain for Tegra210 HDA

Sean Christopherson (2):
      KVM: x86: Zap the oldest MMU pages, not the newest
      KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Stefan Ursella (1):
      usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Thomas Hebb (1):
      hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist

Will McVicker (1):
      HID: make arrays usage and value to be the same

