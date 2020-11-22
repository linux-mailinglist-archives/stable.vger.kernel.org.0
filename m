Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6192BC4A8
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 10:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgKVJUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 04:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbgKVJUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 04:20:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEA7320795;
        Sun, 22 Nov 2020 09:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606036842;
        bh=U2C9O0eehhXnH/nST8zzwserCbCgx6ZCLK8wVNJLBIE=;
        h=From:To:Cc:Subject:Date:From;
        b=xJXE/8jxuBLnH8Ben8yAP0m4PjJPHjsj5oa58FtFg9BXPuKoLKc1UYTFxBBl4q9VN
         rBlcXidWtCmDvsxRTxfLrxjcKmgyC1UCASvALwwekcHojZt2rBEKmfmDCtrX/03Cha
         AHCgB0IN/h09I9KZ6/CBuBCBQ4+B2hRLMH0ECfOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.245
Date:   Sun, 22 Nov 2020 10:21:16 +0100
Message-Id: <160603687616466@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.245 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt            |    7 +
 Makefile                                       |    2 
 arch/powerpc/include/asm/book3s/64/kup-radix.h |   22 +++
 arch/powerpc/include/asm/exception-64s.h       |   13 ++
 arch/powerpc/include/asm/feature-fixups.h      |   19 +++
 arch/powerpc/include/asm/futex.h               |    4 
 arch/powerpc/include/asm/kup.h                 |   40 ++++++
 arch/powerpc/include/asm/security_features.h   |    7 +
 arch/powerpc/include/asm/setup.h               |    4 
 arch/powerpc/include/asm/uaccess.h             |  143 +++++++++++++++++++------
 arch/powerpc/kernel/exceptions-64s.S           |  130 ++++++++++++----------
 arch/powerpc/kernel/head_8xx.S                 |    8 -
 arch/powerpc/kernel/setup_64.c                 |  120 ++++++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S              |   14 ++
 arch/powerpc/lib/checksum_wrappers.c           |    4 
 arch/powerpc/lib/feature-fixups.c              |  104 ++++++++++++++++++
 arch/powerpc/lib/string.S                      |    4 
 arch/powerpc/lib/string_64.S                   |    6 -
 arch/powerpc/platforms/powernv/setup.c         |   15 ++
 arch/powerpc/platforms/pseries/setup.c         |    8 +
 arch/x86/kvm/emulate.c                         |    8 +
 drivers/acpi/evged.c                           |    2 
 drivers/i2c/busses/i2c-imx.c                   |   56 ++++++---
 drivers/i2c/muxes/i2c-mux-pca954x.c            |    6 -
 drivers/input/keyboard/sunkbd.c                |   41 +++++--
 net/mac80211/sta_info.c                        |   18 +++
 26 files changed, 672 insertions(+), 133 deletions(-)

Andrew Donnellan (1):
      powerpc: Fix __clear_user() with KUAP enabled

Christophe Leroy (3):
      powerpc: Add a framework for user access tracking
      powerpc: Implement user_access_begin and friends
      powerpc/8xx: Always fault when _PAGE_ACCESSED is not set

Daniel Axtens (2):
      powerpc/64s: Define MASKABLE_RELON_EXCEPTION_PSERIES_OOL
      powerpc/64s: move some exception handlers out of line

David Edmondson (1):
      KVM: x86: clflushopt should be treated as a no-op by emulation

Dmitry Torokhov (1):
      Input: sunkbd - avoid use-after-free in teardown paths

Greg Kroah-Hartman (1):
      Linux 4.9.245

Johannes Berg (1):
      mac80211: always wind down STA state

Krzysztof Kozlowski (1):
      i2c: imx: Fix external abort on interrupt in exit paths

Lucas Stach (1):
      i2c: imx: use clk notifier for rate changes

Mike Looijmans (1):
      i2c: mux: pca954x: Add missing pca9546 definition to chip_desc

Nicholas Piggin (3):
      powerpc/64s: flush L1D on kernel entry
      powerpc/uaccess: Evaluate macro arguments once, before user access is allowed
      powerpc/64s: flush L1D after user accesses

Nick Desaulniers (1):
      ACPI: GED: fix -Wformat

