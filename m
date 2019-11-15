Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8742DFD64E
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKOGVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbfKOGVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:53 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35C220728;
        Fri, 15 Nov 2019 06:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798912;
        bh=4+nCz3LEl6kdoeHSXQYEjgSPf3SPhDIfUUjquwpozLY=;
        h=From:To:Cc:Subject:Date:From;
        b=AgwsMk63LYEgC47H2n50bnkdPqhS4A3JciDrg0tCdqYHLxJycAjFm4J2UHQ7Ddml7
         EwA5JPRz6Cf1hueqmlFljWZluGdVaVw901gav9qEG+Dceim3Ll9de0S+Uw+t975Zl7
         qjbAUU/gT4lzajVegNY7EJZhsLxWc1nofitauQVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/20] 4.4.202-stable review
Date:   Fri, 15 Nov 2019 14:20:29 +0800
Message-Id: <20191115062006.854443935@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.202-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.202-rc1
X-KernelTest-Deadline: 2019-11-17T06:20+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.202 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2019 06:18:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.202-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.202-rc1

Vineela Tummalapalli <vineela.tummalapalli@intel.com>
    x86/bugs: Add ITLB_MULTIHIT bug infrastructure

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Michal Hocko <mhocko@suse.com>
    x86/tsx: Add config options to set tsx=on|off|auto

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add documentation for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add "auto" option to the tsx= cmdline parameter

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    kvm/x86: Export MDS_NO=0 to guests when TSX is enabled

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add sysfs reporting for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/taa: Add mitigation for TSX Async Abort

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Add a helper function x86_read_arch_cap_msr()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/msr: Add the IA32_TSX_CTRL MSR

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: use Intel speculation bugs and features as derived in generic x86 code

Jim Mattson <jmattson@google.com>
    kvm: x86: IA32_ARCH_CAPABILITIES is always supported

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts

Ben Hutchings <ben@decadent.org.uk>
    KVM: Introduce kvm_get_arch_capabilities()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/boot: Request no dynamic linker for boot wrapper

Nicholas Piggin <npiggin@gmail.com>
    powerpc: Fix compiling a BE kernel with a powerpc64le toolchain

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/Makefile: Use cflags-y/aflags-y for setting endian options

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: BCM63XX: fix switch core reset on BCM6368

Junaid Shahid <junaids@google.com>
    kvm: mmu: Don't read PDPTEs when paging is not enabled


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/tsx_async_abort.rst          | 268 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |  62 +++++
 Documentation/x86/tsx_async_abort.rst              | 117 +++++++++
 Makefile                                           |   4 +-
 arch/mips/bcm63xx/reset.c                          |   2 +-
 arch/powerpc/Makefile                              |  31 ++-
 arch/powerpc/boot/wrapper                          |  24 +-
 arch/x86/Kconfig                                   |  45 ++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |   2 +
 arch/x86/include/asm/msr-index.h                   |  16 ++
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/processor.h                   |   7 +
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 143 ++++++++++-
 arch/x86/kernel/cpu/common.c                       |  93 ++++---
 arch/x86/kernel/cpu/cpu.h                          |  18 ++
 arch/x86/kernel/cpu/intel.c                        |   5 +
 arch/x86/kernel/cpu/tsx.c                          | 140 +++++++++++
 arch/x86/kvm/cpuid.c                               |  12 +
 arch/x86/kvm/vmx.c                                 |  15 --
 arch/x86/kvm/x86.c                                 |  53 +++-
 drivers/base/cpu.c                                 |  17 ++
 include/linux/cpu.h                                |   5 +
 25 files changed, 1019 insertions(+), 70 deletions(-)


