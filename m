Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614F42BC515
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 11:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgKVKdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 05:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgKVKdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 05:33:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4098A2137B;
        Sun, 22 Nov 2020 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606041199;
        bh=6Bq2/gKEHHznocmuaqMpDMhpHclaofqWKEzeR09D6us=;
        h=From:To:Cc:Subject:Date:From;
        b=Ll0WV0IgdawvjM2BDqzJWzRFclGHCnKBPqz0s5Ml46Se65rONFKv3tFUVa+ieuO5J
         +GbQCFTyCJwhHo1U9WnIgcGYEKP4P9OSBhnSiafAgnkfUroKzjuDrVtozpDTwKRY7x
         BQslZHzDELnBI/ND9wiY9IFISjeZN13QvFX9alQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.10
Date:   Sun, 22 Nov 2020 11:33:47 +0100
Message-Id: <1606041227172154@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.10 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt        |    7 
 Makefile                                               |    2 
 arch/powerpc/include/asm/book3s/64/kup-radix.h         |   66 +++--
 arch/powerpc/include/asm/exception-64s.h               |   12 -
 arch/powerpc/include/asm/feature-fixups.h              |   19 +
 arch/powerpc/include/asm/kup.h                         |   26 +-
 arch/powerpc/include/asm/security_features.h           |    7 
 arch/powerpc/include/asm/setup.h                       |    4 
 arch/powerpc/kernel/exceptions-64s.S                   |   80 +++---
 arch/powerpc/kernel/setup_64.c                         |  122 ++++++++++
 arch/powerpc/kernel/smp.c                              |    2 
 arch/powerpc/kernel/syscall_64.c                       |    2 
 arch/powerpc/kernel/vmlinux.lds.S                      |   14 +
 arch/powerpc/lib/feature-fixups.c                      |  104 ++++++++
 arch/powerpc/platforms/powernv/setup.c                 |   17 +
 arch/powerpc/platforms/pseries/setup.c                 |    8 
 arch/x86/events/intel/uncore_snb.c                     |    2 
 arch/x86/kvm/emulate.c                                 |    8 
 drivers/acpi/evged.c                                   |    2 
 drivers/input/keyboard/sunkbd.c                        |   41 ++-
 drivers/leds/leds-lm3697.c                             |    8 
 net/can/proc.c                                         |    6 
 net/mac80211/sta_info.c                                |   18 +
 tools/testing/selftests/kselftest_harness.h            |    2 
 tools/testing/selftests/powerpc/security/.gitignore    |    1 
 tools/testing/selftests/powerpc/security/Makefile      |    2 
 tools/testing/selftests/powerpc/security/entry_flush.c |  198 +++++++++++++++++
 tools/testing/selftests/powerpc/security/rfi_flush.c   |   35 ++-
 28 files changed, 718 insertions(+), 97 deletions(-)

Arnd Bergmann (1):
      perf/x86/intel/uncore: Fix Add BW copypasta

Daniel Axtens (1):
      selftests/powerpc: entry flush test

David Edmondson (1):
      KVM: x86: clflushopt should be treated as a no-op by emulation

Dmitry Torokhov (1):
      Input: sunkbd - avoid use-after-free in teardown paths

Gabriel David (1):
      leds: lm3697: Fix out-of-bound access

Greg Kroah-Hartman (1):
      Linux 5.9.10

Johannes Berg (1):
      mac80211: always wind down STA state

Michael Ellerman (1):
      powerpc: Only include kup-radix.h for 64-bit Book3S

Nicholas Piggin (2):
      powerpc/64s: flush L1D on kernel entry
      powerpc/64s: flush L1D after user accesses

Nick Desaulniers (1):
      ACPI: GED: fix -Wformat

Qian Cai (1):
      powerpc/smp: Call rcu_cpu_starting() earlier

Russell Currey (1):
      selftests/powerpc: rfi_flush: disable entry flush if present

Tommi Rantala (1):
      selftests/harness: prettify SKIP message whitespace again

Zhang Changzhong (1):
      can: proc: can_remove_proc(): silence remove_proc_entry warning

