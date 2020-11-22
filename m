Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7982B2BC50C
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 11:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgKVKdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 05:33:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgKVKdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 05:33:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE6A20936;
        Sun, 22 Nov 2020 10:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606041187;
        bh=ImegKHOBHtChPGijGDTXU4HcB+cuOZCTXL5tJ1Cgn54=;
        h=From:To:Cc:Subject:Date:From;
        b=sY36hMu08glUniZ39DEwCPAQJzehxVjEdFQI92mrCr+0tnKTiLcTBembw6nsde0Pu
         bFYjP3jrLt/1OYv7fJIYeE0kJefb1RjkpF7evQdMm9ICV2pJOkzkKUYySq9tqj9gVX
         78/H/UbqGtRmGtgv2TkNRQ9knaYSzS/w3BWZY8ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.79
Date:   Sun, 22 Nov 2020 11:33:42 +0100
Message-Id: <160604122214202@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.79 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt        |    7 
 Makefile                                               |    2 
 arch/mips/pci/pci-xtalk-bridge.c                       |    2 
 arch/powerpc/include/asm/book3s/64/kup-radix.h         |   29 +--
 arch/powerpc/include/asm/exception-64s.h               |   12 +
 arch/powerpc/include/asm/feature-fixups.h              |   19 +
 arch/powerpc/include/asm/kup.h                         |   27 ++
 arch/powerpc/include/asm/security_features.h           |    7 
 arch/powerpc/include/asm/setup.h                       |    4 
 arch/powerpc/kernel/exceptions-64s.S                   |   88 ++++-----
 arch/powerpc/kernel/head_8xx.S                         |   14 -
 arch/powerpc/kernel/setup_64.c                         |  122 ++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S                      |   14 +
 arch/powerpc/lib/feature-fixups.c                      |  104 ++++++++++
 arch/powerpc/platforms/powernv/setup.c                 |   17 +
 arch/powerpc/platforms/pseries/setup.c                 |    8 
 arch/x86/kvm/emulate.c                                 |    8 
 drivers/acpi/evged.c                                   |    2 
 drivers/input/keyboard/sunkbd.c                        |   41 +++-
 drivers/net/ethernet/lantiq_xrx200.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |  109 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c           |  157 +++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h       |    2 
 include/linux/mlx5/driver.h                            |    6 
 net/can/proc.c                                         |    6 
 net/mac80211/sta_info.c                                |   18 +
 tools/testing/selftests/powerpc/security/.gitignore    |    1 
 tools/testing/selftests/powerpc/security/Makefile      |    2 
 tools/testing/selftests/powerpc/security/entry_flush.c |  163 +++++++++++++++++
 tools/testing/selftests/powerpc/security/rfi_flush.c   |   35 +++
 30 files changed, 856 insertions(+), 172 deletions(-)

Christophe Leroy (1):
      powerpc/8xx: Always fault when _PAGE_ACCESSED is not set

Daniel Axtens (1):
      selftests/powerpc: entry flush test

David Edmondson (1):
      KVM: x86: clflushopt should be treated as a no-op by emulation

Dmitry Torokhov (1):
      Input: sunkbd - avoid use-after-free in teardown paths

Eran Ben Elisha (3):
      net/mlx5: poll cmd EQ in case of command timeout
      net/mlx5: Fix a race when moving command interface to events mode
      net/mlx5: Add retry mechanism to the command entry index allocation

Greg Kroah-Hartman (1):
      Linux 5.4.79

Hauke Mehrtens (1):
      net: lantiq: Add locking for TX DMA channel

Johannes Berg (1):
      mac80211: always wind down STA state

Michael Ellerman (1):
      powerpc: Only include kup-radix.h for 64-bit Book3S

Nicholas Piggin (2):
      powerpc/64s: flush L1D on kernel entry
      powerpc/64s: flush L1D after user accesses

Nick Desaulniers (1):
      ACPI: GED: fix -Wformat

Parav Pandit (1):
      net/mlx5: Use async EQ setup cleanup helpers for multiple EQs

Russell Currey (1):
      selftests/powerpc: rfi_flush: disable entry flush if present

Sudip Mukherjee (1):
      MIPS: PCI: Fix MIPS build

Zhang Changzhong (1):
      can: proc: can_remove_proc(): silence remove_proc_entry warning

