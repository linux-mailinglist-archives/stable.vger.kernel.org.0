Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF514D4B1A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbiCJOeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiCJOb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AB5C4E06;
        Thu, 10 Mar 2022 06:27:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5C161D22;
        Thu, 10 Mar 2022 14:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8C4C340E8;
        Thu, 10 Mar 2022 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922460;
        bh=zMW4Lex3NIwRpcAAAaCfwEW3/J0cPpUtzbhCt+891Os=;
        h=From:To:Cc:Subject:Date:From;
        b=biXSAqd1qb7UPMXykBlw/OGDV2GU8/mHgyyiXRlC9Xu/RJb92ozM9Cs/IUbSrS9tR
         h/ZFm4gpSu7tQm+N6Jze1mGf1bEYG5xJY0DrkkQhF9/HHYYm5vuUOx1taEKyJV/gOx
         Iw/e2scXP6z0VoFEGUajWjnmMx8jZ3lH1V1f3sVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/33] 5.4.184-rc2 review
Date:   Thu, 10 Mar 2022 15:19:01 +0100
Message-Id: <20220310140808.741682643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.184-rc2
X-KernelTest-Deadline: 2022-03-12T14:08+00:00
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

This is the start of the stable review cycle for the 5.4.184 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.184-rc2

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"

Juergen Gross <jgross@suse.com>
    xen/netfront: react properly to failing gnttab_end_foreign_access_ref()

Juergen Gross <jgross@suse.com>
    xen/gnttab: fix gnttab_end_foreign_access() without page specified

Juergen Gross <jgross@suse.com>
    xen/pvcalls: use alloc/free_pages_exact()

Juergen Gross <jgross@suse.com>
    xen/9p: use alloc/free_pages_exact()

Juergen Gross <jgross@suse.com>
    xen: remove gnttab_query_foreign_access()

Juergen Gross <jgross@suse.com>
    xen/gntalloc: don't use gnttab_query_foreign_access()

Juergen Gross <jgross@suse.com>
    xen/scsifront: don't use gnttab_query_foreign_access() for mapped status

Juergen Gross <jgross@suse.com>
    xen/netfront: don't use gnttab_query_foreign_access() for mapped status

Juergen Gross <jgross@suse.com>
    xen/blkfront: don't use gnttab_query_foreign_access() for mapped status

Juergen Gross <jgross@suse.com>
    xen/grant-table: add gnttab_try_end_foreign_access()

Juergen Gross <jgross@suse.com>
    xen/xenbus: don't let xenbus_grant_ring() remove grants in error case

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix build warning in proc-v7-bugs.c

Nathan Chancellor <nathan@kernel.org>
    ARM: Do not use NOCROSSREFS directive with ld.lld

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix co-processor register typo

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
 arch/arm/kernel/vmlinux.lds.h                   |  43 ++++-
 arch/arm/mm/Kconfig                             |  11 ++
 arch/arm/mm/proc-v7-bugs.c                      | 200 +++++++++++++++++++---
 arch/x86/include/asm/cpufeatures.h              |   2 +-
 arch/x86/include/asm/nospec-branch.h            |  16 +-
 arch/x86/kernel/cpu/bugs.c                      | 216 +++++++++++++++++-------
 drivers/acpi/ec.c                               |  10 --
 drivers/acpi/sleep.c                            |  14 +-
 drivers/block/xen-blkfront.c                    |  63 ++++---
 drivers/firmware/psci/psci.c                    |  15 ++
 drivers/net/xen-netfront.c                      |  54 +++---
 drivers/scsi/xen-scsifront.c                    |   3 +-
 drivers/xen/gntalloc.c                          |  25 +--
 drivers/xen/grant-table.c                       |  71 ++++----
 drivers/xen/pvcalls-front.c                     |   8 +-
 drivers/xen/xenbus/xenbus_client.c              |  24 ++-
 include/linux/arm-smccc.h                       |  74 ++++++++
 include/linux/bpf.h                             |  12 ++
 include/xen/grant_table.h                       |  19 ++-
 kernel/sysctl.c                                 |   8 +
 net/9p/trans_xen.c                              |  14 +-
 tools/arch/x86/include/asm/cpufeatures.h        |   2 +-
 32 files changed, 970 insertions(+), 277 deletions(-)


