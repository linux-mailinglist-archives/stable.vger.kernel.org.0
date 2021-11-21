Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFED458378
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 13:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbhKUMuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 07:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235036AbhKUMuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 07:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 239DB60E54;
        Sun, 21 Nov 2021 12:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637498865;
        bh=bQwfMsoglto+9LtXcZRfDvcKrFI0K8pTukrI7BVldhg=;
        h=From:To:Cc:Subject:Date:From;
        b=iL/i9UVQUhD5gKKisM079Ezu0Di2AvQGRtzDDKCu4lIn02PGVcrt/w/vhtBZJoHdh
         BqO3620ESRmw24YyJFxrpjpuwX6KSMrIVQMNpHemcjyiiIlnfnCNt1dpv6TrCf+z7i
         VGoaIjSdAfcQFhHp+EGVVVF7aJkgG9IxoRJ3GLzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.161
Date:   Sun, 21 Nov 2021 13:47:37 +0100
Message-Id: <163749885759102@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.161 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 arch/mips/include/asm/cmpxchg.h |    3 +++
 arch/parisc/kernel/entry.S      |    2 +-
 drivers/pci/msi.c               |   27 +++++++++++++++------------
 drivers/pci/quirks.c            |    6 ++++++
 drivers/scsi/ufs/ufshcd.c       |   17 ++++++++++++-----
 drivers/soc/tegra/pmc.c         |    2 +-
 fs/erofs/zdata.c                |   15 +++++++--------
 fs/erofs/zpvec.h                |   14 +++++++++-----
 fs/ext4/super.c                 |    9 ++++-----
 include/linux/pci.h             |    2 ++
 security/Kconfig                |    3 +++
 12 files changed, 64 insertions(+), 38 deletions(-)

Adrian Hunter (1):
      scsi: ufs: Fix interrupt error message for shared interrupts

Dmitry Osipenko (1):
      soc/tegra: pmc: Fix imbalanced clock disabling in error code path

Gao Xiang (1):
      erofs: fix unsafe pagevec reuse of hooked pclusters

Greg Kroah-Hartman (1):
      Linux 5.4.161

Jaegeuk Kim (1):
      scsi: ufs: Fix tm request when non-fatal error happens

Kees Cook (1):
      fortify: Explicitly disable Clang support

Maciej W. Rozycki (1):
      MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_LEVEL

Marc Zyngier (2):
      PCI/MSI: Deal with devices lying about their MSI mask capability
      PCI: Add MSI masking quirk for Nvidia ION AHCI

Shaoying Xu (1):
      ext4: fix lazy initialization next schedule time computation in more granular unit

Sven Schnelle (1):
      parisc/entry: fix trace test in syscall exit path

Thomas Gleixner (1):
      PCI/MSI: Destroy sysfs before freeing entries

Yue Hu (1):
      erofs: remove the occupied parameter from z_erofs_pagevec_enqueue()

