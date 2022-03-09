Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61204D336A
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiCIQKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiCIQIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:08:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C5413CA25;
        Wed,  9 Mar 2022 08:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 746B4B82222;
        Wed,  9 Mar 2022 16:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA40C340E8;
        Wed,  9 Mar 2022 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841897;
        bh=XBybpJyAFe6Gt+30ldIN9wMIK/cXPSF5eZqeyD4Ue+w=;
        h=From:To:Cc:Subject:Date:From;
        b=ZrIFhQ0gQpIET8JG6r1kxFBkQUXbSgF77WZs96hRipcK9iw++Y7YeMY6bcXNZ2ahp
         abhD39QlkmwFuu4F9vCt4VB5ptKt1V5PqGzSJrWdBiFXWtp5bnpQeXnHquSUoQJNsQ
         TQybCEaGkInpJtJRgi72X598wZBZD5/3ZG4ACawA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/43] 5.10.105-rc1 review
Date:   Wed,  9 Mar 2022 16:59:33 +0100
Message-Id: <20220309155859.239810747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.105-rc1
X-KernelTest-Deadline: 2022-03-11T15:59+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.105 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.105-rc1

Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
    ARM: fix build error when BPF_SYSCALL is disabled

James Morse <james.morse@arm.com>
    arm64: proton-pack: Include unprivileged eBPF status in Spectre v2 mitigation reporting

James Morse <james.morse@arm.com>
    arm64: Use the clearbhb instruction in mitigations

James Morse <james.morse@arm.com>
    KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated

James Morse <james.morse@arm.com>
    arm64: Mitigate spectre style branch history side channels

James Morse <james.morse@arm.com>
    KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A

James Morse <james.morse@arm.com>
    arm64: proton-pack: Report Spectre-BHB vulnerabilities as part of Spectre-v2

James Morse <james.morse@arm.com>
    arm64: Add percpu vectors for EL1

James Morse <james.morse@arm.com>
    arm64: entry: Add macro for reading symbol addresses from the trampoline

James Morse <james.morse@arm.com>
    arm64: entry: Add vectors that have the bhb mitigation sequences

James Morse <james.morse@arm.com>
    arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations

James Morse <james.morse@arm.com>
    arm64: entry: Allow the trampoline text to occupy multiple pages

James Morse <james.morse@arm.com>
    arm64: entry: Make the kpti trampoline's kpti sequence optional

James Morse <james.morse@arm.com>
    arm64: entry: Move trampoline macros out of ifdef'd section

James Morse <james.morse@arm.com>
    arm64: entry: Don't assume tramp_vectors is the start of the vectors

James Morse <james.morse@arm.com>
    arm64: entry: Allow tramp_alias to access symbols after the 4K boundary

James Morse <james.morse@arm.com>
    arm64: entry: Move the trampoline data page before the text page

James Morse <james.morse@arm.com>
    arm64: entry: Free up another register on kpti's tramp_exit path

James Morse <james.morse@arm.com>
    arm64: entry: Make the trampoline cleanup optional

James Morse <james.morse@arm.com>
    arm64: spectre: Rename spectre_v4_patch_fw_mitigation_conduit

James Morse <james.morse@arm.com>
    arm64: entry.S: Add ventry overflow sanity checks

Joey Gouly <joey.gouly@arm.com>
    arm64: cpufeature: add HWCAP for FEAT_RPRES

Joey Gouly <joey.gouly@arm.com>
    arm64: cpufeature: add HWCAP for FEAT_AFP

Joey Gouly <joey.gouly@arm.com>
    arm64: add ID_AA64ISAR2_EL1 sys register

Marc Zyngier <maz@kernel.org>
    arm64: Add HWCAP for self-synchronising virtual counter

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-A510 CPU part definition

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-X2 CPU part definition

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

Hector Martin <marcan@marcan.st>
    arm64: cputype: Add CPU implementor & types for the Apple M1 cores

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: include unprivileged BPF status in Spectre V2 reporting

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: Spectre-BHB workaround

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: use LOADADDR() to get load address of sections

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: early traps initialisation

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: report Spectre v2 status through sysfs

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Warn about eIBRS + LFENCE + Unprivileged eBPF + SMT

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Warn about Spectre v2 LFENCE mitigation

Kim Phillips <kim.phillips@amd.com>
    x86/speculation: Update link to AMD speculation whitepaper

Kim Phillips <kim.phillips@amd.com>
    x86/speculation: Use generic retpoline by default on AMD

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting

Peter Zijlstra <peterz@infradead.org>
    Documentation/hw-vuln: Update spectre doc

Peter Zijlstra <peterz@infradead.org>
    x86/speculation: Add eIBRS + Retpoline options

Peter Zijlstra (Intel) <peterz@infradead.org>
    x86/speculation: Rename RETPOLINE_AMD to RETPOLINE_LFENCE

Peter Zijlstra <peterz@infradead.org>
    x86,bugs: Unconditionally allow spectre_v2=retpoline,amd


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst   |  48 ++--
 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 Documentation/arm64/cpu-feature-registers.rst   |  29 +-
 Documentation/arm64/elf_hwcaps.rst              |  12 +
 Makefile                                        |   4 +-
 arch/arm/include/asm/assembler.h                |  10 +
 arch/arm/include/asm/spectre.h                  |  32 +++
 arch/arm/include/asm/vmlinux.lds.h              |  35 ++-
 arch/arm/kernel/Makefile                        |   2 +
 arch/arm/kernel/entry-armv.S                    |  79 +++++-
 arch/arm/kernel/entry-common.S                  |  24 ++
 arch/arm/kernel/spectre.c                       |  71 +++++
 arch/arm/kernel/traps.c                         |  65 ++++-
 arch/arm/mm/Kconfig                             |  11 +
 arch/arm/mm/proc-v7-bugs.c                      | 207 +++++++++++---
 arch/arm64/Kconfig                              |   9 +
 arch/arm64/include/asm/assembler.h              |  33 +++
 arch/arm64/include/asm/cpu.h                    |   1 +
 arch/arm64/include/asm/cpucaps.h                |   3 +-
 arch/arm64/include/asm/cpufeature.h             |  28 ++
 arch/arm64/include/asm/cputype.h                |  22 ++
 arch/arm64/include/asm/fixmap.h                 |   6 +-
 arch/arm64/include/asm/hwcap.h                  |   3 +
 arch/arm64/include/asm/insn.h                   |   1 +
 arch/arm64/include/asm/kvm_asm.h                |   8 +
 arch/arm64/include/asm/kvm_mmu.h                |   3 +-
 arch/arm64/include/asm/mmu.h                    |   6 +
 arch/arm64/include/asm/sections.h               |   5 +
 arch/arm64/include/asm/spectre.h                |   4 +
 arch/arm64/include/asm/sysreg.h                 |  18 ++
 arch/arm64/include/asm/vectors.h                |  73 +++++
 arch/arm64/include/uapi/asm/hwcap.h             |   3 +
 arch/arm64/include/uapi/asm/kvm.h               |   5 +
 arch/arm64/kernel/cpu_errata.c                  |   7 +
 arch/arm64/kernel/cpufeature.c                  |  28 +-
 arch/arm64/kernel/cpuinfo.c                     |   4 +
 arch/arm64/kernel/entry.S                       | 213 ++++++++++----
 arch/arm64/kernel/proton-pack.c                 | 359 +++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S                 |   2 +-
 arch/arm64/kvm/arm.c                            |   3 +-
 arch/arm64/kvm/hyp/hyp-entry.S                  |   4 +
 arch/arm64/kvm/hyp/smccc_wa.S                   |  75 +++++
 arch/arm64/kvm/hyp/vhe/switch.c                 |   9 +-
 arch/arm64/kvm/hypercalls.c                     |  12 +
 arch/arm64/kvm/psci.c                           |  18 +-
 arch/arm64/kvm/sys_regs.c                       |   2 +-
 arch/arm64/mm/mmu.c                             |  12 +-
 arch/x86/include/asm/cpufeatures.h              |   2 +-
 arch/x86/include/asm/nospec-branch.h            |  16 +-
 arch/x86/kernel/cpu/bugs.c                      | 205 ++++++++++----
 include/linux/arm-smccc.h                       |   5 +
 include/linux/bpf.h                             |  12 +
 kernel/sysctl.c                                 |   7 +
 tools/arch/x86/include/asm/cpufeatures.h        |   2 +-
 54 files changed, 1651 insertions(+), 214 deletions(-)


