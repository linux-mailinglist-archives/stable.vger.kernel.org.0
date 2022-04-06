Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A264F6ABB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiDFUD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiDFUDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:03:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9A181B12;
        Wed,  6 Apr 2022 11:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B63B8252B;
        Wed,  6 Apr 2022 18:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66849C385A3;
        Wed,  6 Apr 2022 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269618;
        bh=Q0RYEjzeisjhD20Or2HKQ6z6h4FOwlY7X2OSh5h/0K8=;
        h=From:To:Cc:Subject:Date:From;
        b=LFa5Yzg/qVPSO1xuaHeYbFtrBX3JgC3p5/0LIh//H+jhCgr1s7wkxOk7zdIPpy8c4
         LyhGVoo5Z/Vk3lRYeKh+wyTrfNDDA6TmPqDxgsoO65aijQx5DZR+gHvST0g4z/EZR4
         qIk67RsWZ75HrWiZBh3L6Xq/avUV4sJ2vRDC7fzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/43] 4.9.310-rc1 review
Date:   Wed,  6 Apr 2022 20:26:09 +0200
Message-Id: <20220406182436.675069715@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.310-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.310-rc1
X-KernelTest-Deadline: 2022-04-08T18:24+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.310 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.310-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.310-rc1

James Morse <james.morse@arm.com>
    arm64: Use the clearbhb instruction in mitigations

James Morse <james.morse@arm.com>
    arm64: add ID_AA64ISAR2_EL1 sys register

James Morse <james.morse@arm.com>
    KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated

James Morse <james.morse@arm.com>
    arm64: Mitigate spectre style branch history side channels

James Morse <james.morse@arm.com>
    KVM: arm64: Add templates for BHB mitigation sequences

James Morse <james.morse@arm.com>
    arm64: Add percpu vectors for EL1

James Morse <james.morse@arm.com>
    arm64: entry: Add macro for reading symbol addresses from the trampoline

James Morse <james.morse@arm.com>
    arm64: entry: Add vectors that have the bhb mitigation sequences

James Morse <james.morse@arm.com>
    arm64: Move arm64_update_smccc_conduit() out of SSBD ifdef

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
    arm64: entry.S: Add ventry overflow sanity checks

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add helper to decode register from instruction

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-X2 CPU part definition

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add Neoverse-N2, Cortex-A710 CPU part definition

Rob Herring <robh@kernel.org>
    arm64: Add part number for Arm Cortex-A77

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Add part number for Neoverse N1

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Make ARM64_ERRATUM_1188873 depend on COMPAT

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Add silicon-errata.txt entry for ARM erratum 1188873

Arnd Bergmann <arnd@arndb.de>
    arm64: arch_timer: avoid unused function warning

Marc Zyngier <marc.zyngier@arm.com>
    arm64: arch_timer: Add workaround for ARM erratum 1188873

Marc Zyngier <marc.zyngier@arm.com>
    arm64: arch_timer: Add erratum handler for CPU-specific capability

Marc Zyngier <marc.zyngier@arm.com>
    arm64: arch_timer: Add infrastructure for multiple erratum detection methods

Ding Tianhong <dingtianhong@huawei.com>
    clocksource/drivers/arm_arch_timer: Introduce generic errata handling infrastructure

Ding Tianhong <dingtianhong@huawei.com>
    clocksource/drivers/arm_arch_timer: Remove fsl-a008585 parameter

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Add support for checks based on a list of MIDRs

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add helpers for checking CPU MIDR against a range

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Clean up midr range helpers

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Add flags to handle the conflicts on late CPU

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Prepare for fine grained capabilities

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Move errata processing code

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Move errata work around check on boot CPU

Dave Martin <dave.martin@arm.com>
    arm64: capabilities: Update prototype for enable call back

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35

James Morse <james.morse@arm.com>
    arm64: Remove useless UAO IPI and describe how this gets enabled

Robert Richter <rrichter@cavium.com>
    arm64: errata: Provide macro for major and minor cpu revisions


-------------

Diffstat:

 Documentation/arm64/silicon-errata.txt |   1 +
 Documentation/kernel-parameters.txt    |   9 -
 Makefile                               |   4 +-
 arch/arm/include/asm/kvm_host.h        |   5 +
 arch/arm/kvm/psci.c                    |   4 +
 arch/arm64/Kconfig                     |  24 ++
 arch/arm64/include/asm/arch_timer.h    |  44 ++-
 arch/arm64/include/asm/assembler.h     |  34 ++
 arch/arm64/include/asm/cpu.h           |   1 +
 arch/arm64/include/asm/cpucaps.h       |   4 +-
 arch/arm64/include/asm/cpufeature.h    | 232 ++++++++++++-
 arch/arm64/include/asm/cputype.h       |  63 ++++
 arch/arm64/include/asm/fixmap.h        |   6 +-
 arch/arm64/include/asm/insn.h          |   2 +
 arch/arm64/include/asm/kvm_host.h      |   4 +
 arch/arm64/include/asm/kvm_mmu.h       |   2 +-
 arch/arm64/include/asm/mmu.h           |   8 +-
 arch/arm64/include/asm/processor.h     |   6 +-
 arch/arm64/include/asm/sections.h      |   6 +
 arch/arm64/include/asm/sysreg.h        |   5 +
 arch/arm64/include/asm/vectors.h       |  74 +++++
 arch/arm64/kernel/bpi.S                |  55 +++
 arch/arm64/kernel/cpu_errata.c         | 591 ++++++++++++++++++++++++++-------
 arch/arm64/kernel/cpufeature.c         | 167 +++++++---
 arch/arm64/kernel/cpuinfo.c            |   1 +
 arch/arm64/kernel/entry.S              | 197 ++++++++---
 arch/arm64/kernel/fpsimd.c             |   1 +
 arch/arm64/kernel/insn.c               |  29 ++
 arch/arm64/kernel/smp.c                |   6 -
 arch/arm64/kernel/traps.c              |   4 +-
 arch/arm64/kernel/vmlinux.lds.S        |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S         |   4 +
 arch/arm64/kvm/hyp/switch.c            |   9 +-
 arch/arm64/mm/fault.c                  |  17 +-
 arch/arm64/mm/mmu.c                    |  11 +-
 drivers/clocksource/Kconfig            |   4 +
 drivers/clocksource/arm_arch_timer.c   | 192 ++++++++---
 include/linux/arm-smccc.h              |   7 +
 38 files changed, 1504 insertions(+), 331 deletions(-)


