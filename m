Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27AD4583C2
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 14:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhKUNQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 08:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238164AbhKUNQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 08:16:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CD6960E75;
        Sun, 21 Nov 2021 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637500390;
        bh=8EIpy8rgxgTr4aTNQOPq/jLMjZK2xmJ6XSLTJfbgmmI=;
        h=From:To:Cc:Subject:Date:From;
        b=D6HmQq1n4IhvHq+N5TJscYbIFMWkkG1rUdnpZHsE7TA3P3mv2nchW8Tg2xw/XF7aX
         4lm70pXShhkJg9Vh0jxBhuuyUs58NakmkZqJULnc0Sa+GfJ33aHWHdKYt5+uwbKGdF
         151WfMh3g3dObTSELhNBNgqJXNz799+mcsVeG0ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.21
Date:   Sun, 21 Nov 2021 14:13:03 +0100
Message-Id: <1637500331152110@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--------------------
Note, this is the LAST 5.14.y kernel release.  It is now end-of-life.
Please move to the 5.15.y kernel branch at this point in time.
--------------------

I'm announcing the release of the 5.14.21 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                     |    2 +-
 arch/parisc/kernel/entry.S   |    2 +-
 arch/x86/kvm/x86.c           |    6 +++---
 drivers/acpi/glue.c          |   25 -------------------------
 drivers/acpi/internal.h      |    1 -
 drivers/acpi/scan.c          |    6 ------
 drivers/block/loop.c         |   17 ++---------------
 drivers/bluetooth/btusb.c    |    4 ++++
 drivers/gpu/drm/Kconfig      |    5 +++--
 drivers/pci/msi.c            |   27 +++++++++++++++------------
 drivers/pci/quirks.c         |    6 ++++++
 drivers/thermal/thermal_of.c |    9 ++++++---
 include/linux/blkdev.h       |    8 ++++++++
 include/linux/pci.h          |    2 ++
 init/main.c                  |    1 +
 kernel/events/core.c         |   10 +++++-----
 security/Kconfig             |    3 +++
 17 files changed, 60 insertions(+), 74 deletions(-)

David Woodhouse (1):
      KVM: Fix steal time asm constraints

Greg Kroah-Hartman (3):
      Revert "drm: fb_helper: improve CONFIG_FB dependency"
      Revert "drm: fb_helper: fix CONFIG_FB dependency"
      Linux 5.14.21

Greg Thelen (1):
      perf/core: Avoid put_page() when GUP fails

Kees Cook (1):
      fortify: Explicitly disable Clang support

Marc Zyngier (2):
      PCI/MSI: Deal with devices lying about their MSI mask capability
      PCI: Add MSI masking quirk for Nvidia ION AHCI

Masami Hiramatsu (1):
      bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Nicholas Flintham (1):
      Bluetooth: btusb: Add support for TP-Link UB500 Adapter

Rafael J. Wysocki (1):
      Revert "ACPI: scan: Release PM resources blocked by unused objects"

Subbaraman Narayanamurthy (1):
      thermal: Fix NULL pointer dereferences in of_thermal_ functions

Sven Schnelle (1):
      parisc/entry: fix trace test in syscall exit path

Thomas Gleixner (1):
      PCI/MSI: Destroy sysfs before freeing entries

Xie Yongji (2):
      block: Add a helper to validate the block size
      loop: Use blk_validate_block_size() to validate block size

