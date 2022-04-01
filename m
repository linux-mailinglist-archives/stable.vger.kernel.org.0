Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CA64EE854
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbiDAGip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245462AbiDAGig (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:38:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77A218DAB9;
        Thu, 31 Mar 2022 23:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F99DB823D9;
        Fri,  1 Apr 2022 06:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43F9C2BBE4;
        Fri,  1 Apr 2022 06:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795004;
        bh=xBXlQCMtFbWUMpyKpU6xZl2vpjdaAwZgL0XinuyoEy4=;
        h=From:To:Cc:Subject:Date:From;
        b=fsLaZ2YmsTHPnn56D7sX0K6mTtxfyjaJ5nsKsjUZ3hTVr5AqxQ5m1JuXySTWhuH9m
         UVSb8cV5CYyJdBb93xu9VPVayG+YJPcTAw/paCWFcX5Gd9xRpXXuFPI7LHn82HTr4/
         yYEPSESyPE07Gv4AiOg4ZIY4JN3ppKbNXtcY5/14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/27] 4.14.275-rc1 review
Date:   Fri,  1 Apr 2022 08:36:10 +0200
Message-Id: <20220401063624.232282121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.275-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.275-rc1
X-KernelTest-Deadline: 2022-04-03T06:36+00:00
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

This is the start of the stable review cycle for the 4.14.275 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 03 Apr 2022 06:36:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.275-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.275-rc1

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
    arm64: entry.S: Add ventry overflow sanity checks

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


-------------

Diffstat:

 Documentation/arm64/silicon-errata.txt |   1 +
 Makefile                               |   4 +-
 arch/arm/include/asm/kvm_host.h        |   6 +
 arch/arm64/Kconfig                     |  24 ++
 arch/arm64/include/asm/assembler.h     |  34 +++
 arch/arm64/include/asm/cpu.h           |   1 +
 arch/arm64/include/asm/cpucaps.h       |   4 +-
 arch/arm64/include/asm/cpufeature.h    |  39 ++++
 arch/arm64/include/asm/cputype.h       |  20 ++
 arch/arm64/include/asm/fixmap.h        |   6 +-
 arch/arm64/include/asm/kvm_host.h      |   5 +
 arch/arm64/include/asm/kvm_mmu.h       |   2 +-
 arch/arm64/include/asm/mmu.h           |   8 +-
 arch/arm64/include/asm/sections.h      |   6 +
 arch/arm64/include/asm/sysreg.h        |   5 +
 arch/arm64/include/asm/vectors.h       |  74 ++++++
 arch/arm64/kernel/bpi.S                |  55 +++++
 arch/arm64/kernel/cpu_errata.c         | 395 ++++++++++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c         |  21 ++
 arch/arm64/kernel/cpuinfo.c            |   1 +
 arch/arm64/kernel/entry.S              | 196 ++++++++++++----
 arch/arm64/kernel/vmlinux.lds.S        |   2 +-
 arch/arm64/kvm/hyp/hyp-entry.S         |   4 +
 arch/arm64/kvm/hyp/switch.c            |   9 +-
 arch/arm64/mm/mmu.c                    |  11 +-
 drivers/clocksource/arm_arch_timer.c   |  15 ++
 include/linux/arm-smccc.h              |   7 +
 virt/kvm/arm/psci.c                    |  12 +
 28 files changed, 909 insertions(+), 58 deletions(-)


