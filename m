Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F521100029
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 09:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfKRIOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 03:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfKRIOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 03:14:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47A320727;
        Mon, 18 Nov 2019 08:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574064870;
        bh=Jh4YxIaGWYPBVmBKqluRFDnHUVV75y/f1RYzID680L4=;
        h=Date:From:To:Cc:Subject:From;
        b=AjrJB2wEEfFd6/h3dSZAirbwAEi0l5O826B43VBSJfj247sIFBUoE5d4JCNFqMQxY
         8t2k8m64zOAMVhDcGSKcolf95pBwqjCNboD5hoWwpTR20Yjm1prB9I2xGYRBMJGcJy
         kJ/sRmUyjn3NbSUBGF3FfpmK7YSbomSUqdXXn5P4=
Date:   Mon, 18 Nov 2019 09:14:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.202
Message-ID: <20191118081427.GA133992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.202 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |    2 
 Documentation/hw-vuln/tsx_async_abort.rst          |  268 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |   62 ++++
 Documentation/x86/tsx_async_abort.rst              |  117 +++++++++
 Makefile                                           |    2 
 arch/mips/bcm63xx/reset.c                          |    2 
 arch/powerpc/Makefile                              |   31 +-
 arch/powerpc/boot/wrapper                          |   24 +
 arch/x86/Kconfig                                   |   45 +++
 arch/x86/include/asm/cpufeatures.h                 |    2 
 arch/x86/include/asm/kvm_host.h                    |    2 
 arch/x86/include/asm/msr-index.h                   |   16 +
 arch/x86/include/asm/nospec-branch.h               |    4 
 arch/x86/include/asm/processor.h                   |    7 
 arch/x86/kernel/cpu/Makefile                       |    2 
 arch/x86/kernel/cpu/bugs.c                         |  143 ++++++++++-
 arch/x86/kernel/cpu/common.c                       |   93 ++++---
 arch/x86/kernel/cpu/cpu.h                          |   18 +
 arch/x86/kernel/cpu/intel.c                        |    5 
 arch/x86/kernel/cpu/tsx.c                          |  140 ++++++++++
 arch/x86/kvm/cpuid.c                               |   12 
 arch/x86/kvm/vmx.c                                 |   15 -
 arch/x86/kvm/x86.c                                 |   53 +++-
 drivers/base/cpu.c                                 |   17 +
 include/linux/cpu.h                                |    5 
 25 files changed, 1018 insertions(+), 69 deletions(-)

Ben Hutchings (1):
      KVM: Introduce kvm_get_arch_capabilities()

Greg Kroah-Hartman (1):
      Linux 4.4.202

Jim Mattson (1):
      kvm: x86: IA32_ARCH_CAPABILITIES is always supported

Jonas Gorski (1):
      MIPS: BCM63XX: fix switch core reset on BCM6368

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Junaid Shahid (1):
      kvm: mmu: Don't read PDPTEs when paging is not enabled

Michael Ellerman (1):
      powerpc/Makefile: Use cflags-y/aflags-y for setting endian options

Michal Hocko (1):
      x86/tsx: Add config options to set tsx=on|off|auto

Nicholas Piggin (2):
      powerpc: Fix compiling a BE kernel with a powerpc64le toolchain
      powerpc/boot: Request no dynamic linker for boot wrapper

Paolo Bonzini (1):
      KVM: x86: use Intel speculation bugs and features as derived in generic x86 code

Pawan Gupta (8):
      x86/msr: Add the IA32_TSX_CTRL MSR
      x86/cpu: Add a helper function x86_read_arch_cap_msr()
      x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default
      x86/speculation/taa: Add mitigation for TSX Async Abort
      x86/speculation/taa: Add sysfs reporting for TSX Async Abort
      kvm/x86: Export MDS_NO=0 to guests when TSX is enabled
      x86/tsx: Add "auto" option to the tsx= cmdline parameter
      x86/speculation/taa: Add documentation for TSX Async Abort

Sean Christopherson (1):
      KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure

