Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D964583BE
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhKUNPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238109AbhKUNPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 08:15:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40FCA60232;
        Sun, 21 Nov 2021 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637500321;
        bh=/yimWH9RBNUmKwUYOEfdo9xLVk99dE5wxXXWipv+CDo=;
        h=From:To:Cc:Subject:Date:From;
        b=tfSDafFAaFYc+wwOkzdl2gYd1QEsjos8TWs7o3wm8OwBkMrlosXG+i3OfX84px5cR
         /EpqyPbrM/0QtXmc0IR7jozFByAKFjqnlyw7nnx+2TJ8Q9fAbAj5BRFACL4/N0H1sv
         9iTGknrk7wm3pok9TTk+3rF0dv5qJKagIPNQrLqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.4
Date:   Sun, 21 Nov 2021 14:11:57 +0100
Message-Id: <163750031819276@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.4 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                     |    2 -
 arch/parisc/kernel/entry.S   |    2 -
 arch/x86/kvm/x86.c           |    6 ++--
 drivers/acpi/glue.c          |   25 -------------------
 drivers/acpi/internal.h      |    1 
 drivers/acpi/scan.c          |    6 ----
 drivers/block/loop.c         |   17 +------------
 drivers/bluetooth/btusb.c    |    4 +++
 drivers/gpu/drm/Kconfig      |    5 ++-
 drivers/pci/msi.c            |    3 ++
 drivers/pci/quirks.c         |    6 ++++
 drivers/thermal/thermal_of.c |    9 ++++--
 fs/btrfs/block-group.c       |    1 
 fs/btrfs/ctree.h             |   12 +++++++++
 fs/btrfs/disk-io.c           |    3 +-
 fs/btrfs/extent-tree.c       |   56 ++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/extent_io.c         |   11 ++++++++
 fs/btrfs/inode.c             |   29 +++++++++++++---------
 fs/btrfs/relocation.c        |   38 ++---------------------------
 fs/btrfs/zoned.c             |   21 ++++++++++++++++
 fs/btrfs/zoned.h             |    3 ++
 include/linux/blkdev.h       |    8 ++++++
 include/linux/pci.h          |    2 +
 include/linux/string.h       |   19 +-------------
 kernel/events/core.c         |   10 +++----
 lib/string_helpers.c         |   20 +++++++++++++++
 security/Kconfig             |    3 ++
 27 files changed, 192 insertions(+), 130 deletions(-)

David Woodhouse (1):
      KVM: Fix steal time asm constraints

Greg Kroah-Hartman (3):
      Revert "drm: fb_helper: improve CONFIG_FB dependency"
      Revert "drm: fb_helper: fix CONFIG_FB dependency"
      Linux 5.15.4

Greg Thelen (1):
      perf/core: Avoid put_page() when GUP fails

Guenter Roeck (1):
      string: uninline memcpy_and_pad

Johannes Thumshirn (6):
      btrfs: introduce btrfs_is_data_reloc_root
      btrfs: zoned: add a dedicated data relocation block group
      btrfs: zoned: only allow one process to add pages to a relocation inode
      btrfs: zoned: use regular writes for relocation
      btrfs: check for relocation inodes on zoned btrfs in should_nocow
      btrfs: zoned: allow preallocation for relocation inodes

Kees Cook (1):
      fortify: Explicitly disable Clang support

Marc Zyngier (2):
      PCI/MSI: Deal with devices lying about their MSI mask capability
      PCI: Add MSI masking quirk for Nvidia ION AHCI

Nicholas Flintham (1):
      Bluetooth: btusb: Add support for TP-Link UB500 Adapter

Rafael J. Wysocki (1):
      Revert "ACPI: scan: Release PM resources blocked by unused objects"

Subbaraman Narayanamurthy (1):
      thermal: Fix NULL pointer dereferences in of_thermal_ functions

Sven Schnelle (1):
      parisc/entry: fix trace test in syscall exit path

Xie Yongji (2):
      block: Add a helper to validate the block size
      loop: Use blk_validate_block_size() to validate block size

