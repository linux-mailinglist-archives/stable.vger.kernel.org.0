Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37DF4D32F6
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiCIQHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiCIQFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:05:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76ED13EF8F;
        Wed,  9 Mar 2022 08:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C41B5B82222;
        Wed,  9 Mar 2022 16:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DEEC340E8;
        Wed,  9 Mar 2022 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841773;
        bh=3fQUgmqWeDD+UpGTO6YQJwkMhWwp1kKe/wrEc0SOUAw=;
        h=From:To:Cc:Subject:Date:From;
        b=S8/R7RG/KX04QcYHCoMJQWR53JC9lYh0WI9lE1cLRUOcZnu1EPxS3hOY3hQf1QF6K
         JBg09laSCpz74PugYt7fGztwp1MxjvvdZRT/IyyJM73qCnv16P1iWoLFcOE2c++9IR
         h0Zw+axd//4K0rLb1bbK7wYwk14R5D/LJ/YuOSTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/18] 4.14.271-rc1 review
Date:   Wed,  9 Mar 2022 16:59:30 +0100
Message-Id: <20220309155856.090281301@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.271-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.271-rc1
X-KernelTest-Deadline: 2022-03-11T15:58+00:00
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

This is the start of the stable review cycle for the 4.14.271 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.271-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.271-rc1

Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
    ARM: fix build error when BPF_SYSCALL is disabled

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

Mark Rutland <mark.rutland@arm.com>
    arm/arm64: smccc/psci: add arm_smccc_1_1_get_conduit()

Steven Price <steven.price@arm.com>
    arm/arm64: Provide a wrapper for SMCCC 1.1 calls

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

Borislav Petkov <bp@suse.de>
    x86/speculation: Merge one test in spectre_v2_user_select_mitigation()


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst   |  48 ++++--
 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 Makefile                                        |   4 +-
 arch/arm/include/asm/assembler.h                |  10 ++
 arch/arm/include/asm/spectre.h                  |  32 ++++
 arch/arm/kernel/Makefile                        |   2 +
 arch/arm/kernel/entry-armv.S                    |  79 ++++++++-
 arch/arm/kernel/entry-common.S                  |  24 +++
 arch/arm/kernel/spectre.c                       |  71 ++++++++
 arch/arm/kernel/traps.c                         |  65 ++++++-
 arch/arm/kernel/vmlinux-xip.lds.S               |  37 ++--
 arch/arm/kernel/vmlinux.lds.S                   |  37 ++--
 arch/arm/mm/Kconfig                             |  11 ++
 arch/arm/mm/proc-v7-bugs.c                      | 198 +++++++++++++++++++---
 arch/x86/include/asm/cpufeatures.h              |   2 +-
 arch/x86/include/asm/nospec-branch.h            |  16 +-
 arch/x86/kernel/cpu/bugs.c                      | 214 +++++++++++++++++-------
 drivers/firmware/psci.c                         |  15 ++
 include/linux/arm-smccc.h                       |  74 ++++++++
 include/linux/bpf.h                             |  11 ++
 kernel/sysctl.c                                 |   8 +
 tools/arch/x86/include/asm/cpufeatures.h        |   2 +-
 22 files changed, 822 insertions(+), 146 deletions(-)


