Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6C376503
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhEGMYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEGMYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 08:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 801AC61400;
        Fri,  7 May 2021 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620390222;
        bh=pRtVaMVl5yjhYHK+bsW8G1rc+7MTTRAvrLDu6uHVffI=;
        h=From:To:Cc:Subject:Date:From;
        b=IREoRXExN+RgdkqUwWwhLnsoDsJG3jy9YhYEekHaFkbqEoeGsQ0WhqBf0kGa996yf
         UAKF8X7c74JyBTrzwj8u9j1klJyS0irabh5bBruxx5fvgrQtema3lAYMslbVV0ynOB
         sygeuoD+A9wdr2lk7l6I2bkcQTfnw5ILa1fytogA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.190
Date:   Fri,  7 May 2021 14:23:38 +0200
Message-Id: <162039021859112@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.190 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/mips/vdso/gettimeofday.c                     |   14 +-
 arch/x86/kernel/acpi/boot.c                       |   25 +---
 arch/x86/kernel/setup.c                           |    7 -
 drivers/acpi/tables.c                             |   42 ++++++
 drivers/net/usb/ax88179_178a.c                    |    4 
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 -
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |    7 -
 drivers/platform/x86/thinkpad_acpi.c              |   31 +++--
 drivers/staging/erofs/inode.c                     |  135 ++++++++++++++--------
 drivers/usb/core/quirks.c                         |    4 
 fs/overlayfs/super.c                              |   12 +
 include/linux/acpi.h                              |    9 +
 kernel/bpf/verifier.c                             |   12 -
 sound/usb/quirks-table.h                          |   10 +
 15 files changed, 221 insertions(+), 100 deletions(-)

Chris Chiu (1):
      USB: Add reset-resume quirk for WD19's Realtek Hub

Daniel Borkmann (1):
      bpf: Fix masking negation logic upon negative dst register

Gao Xiang (1):
      erofs: fix extended inode could cross boundary

Greg Kroah-Hartman (1):
      Linux 4.19.190

Jiri Kosina (2):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Kai-Heng Feng (1):
      USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Miklos Szeredi (1):
      ovl: allow upperdir inside lowerdir

Phillip Potter (1):
      net: usb: ax88179_178a: initialize local variables before use

Rafael J. Wysocki (2):
      ACPI: tables: x86: Reserve memory occupied by ACPI tables
      ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Romain Naour (1):
      mips: Do not include hi and lo in clobber list for R6

Takashi Iwai (1):
      ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX

