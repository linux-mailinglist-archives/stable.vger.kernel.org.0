Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2455F5367
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJELdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJELdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:33:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC9753A2;
        Wed,  5 Oct 2022 04:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA87FB81DB2;
        Wed,  5 Oct 2022 11:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02881C433D6;
        Wed,  5 Oct 2022 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969598;
        bh=uHguYNWOMm0l8gmJwWn7/GNTZSdHAHNhEmZJAT3lPKE=;
        h=From:To:Cc:Subject:Date:From;
        b=G5mOwiIrKvuUVRDcj3+9/cxtOYji1zcEBAwlg9BAVmMLG7fIjbbty7AQAHYLhmDIn
         TnsxJH4IxAQihsZefcYvkD0bq0XUrz7qymASJxdVpCQfQAyvb0QkgAZc2RvS1lXWDn
         qL3l2f7FzEJ9g6PZwbsUDRyPWPC85yyPhxtx7BsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.4 00/51] 5.4.217-rc1 review
Date:   Wed,  5 Oct 2022 13:31:48 +0200
Message-Id: <20221005113210.255710920@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.217-rc1
X-KernelTest-Deadline: 2022-10-07T11:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.217 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.217-rc1

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator information in CoC docs

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/amdgpu: use dirty framebuffer helper"

YueHaibing <yuehaibing@huawei.com>
    xfs: remove unused variable 'done'

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix uninitialized variable in xfs_attr3_leaf_inactive

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: streamline xfs_attr3_leaf_inactive

Christoph Hellwig <hch@lst.de>
    xfs: move incore structures out of xfs_da_format.h

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix memory corruption during remote attr value buffer invalidation

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: refactor remote attr value buffer invalidation

Christoph Hellwig <hch@lst.de>
    xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix s_maxbytes computation on 32-bit kernels

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: truncate should remove all blocks, not just to the end of the page cache

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: introduce XFS_MAX_FILEOFF

Christoph Hellwig <hch@lst.de>
    xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/speculation: Add RSB VM Exit protections

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Nathan Chancellor <nathan@kernel.org>
    x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Disable RRSBA behavior

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add Cannon lake to RETBleed affected CPU list

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/cpu/amd: Enumerate BTC_NO

Peter Zijlstra <peterz@infradead.org>
    x86/common: Stamp out the stepping madness

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Fill RSB on vmexit for IBRS

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Fix IBRS handling after vmexit

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    KVM: VMX: Convert launched argument to flags

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Flatten __vmx_vcpu_run()

Uros Bizjak <ubizjak@gmail.com>
    KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw

Uros Bizjak <ubizjak@gmail.com>
    KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Remove x86_spec_ctrl_mask

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Fix SPEC_CTRL write on SMT state change

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Fix firmware entry SPEC_CTRL handling

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n

Peter Zijlstra <peterz@infradead.org>
    x86/speculation: Change FILL_RETURN_BUFFER to work with objtool

Peter Zijlstra <peterz@infradead.org>
    intel_idle: Disable IBRS during long idle

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Report Intel retbleed vulnerability

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Optimize SPEC_CTRL MSR writes

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Add kernel IBRS implementation

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Remove skip_r11rcx

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Add AMD retbleed= boot parameter

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Report AMD retbleed vulnerability

Peter Zijlstra <peterz@infradead.org>
    x86/cpufeatures: Move RETPOLINE flags to word 11

Peter Zijlstra <peterz@infradead.org>
    x86/kvm/vmx: Make noinstr clean

Mark Gross <mgross@linux.intel.com>
    x86/cpu: Add a steppings field to struct x86_cpu_id

Thomas Gleixner <tglx@linutronix.de>
    x86/cpu: Add consistent CPU match macros

Thomas Gleixner <tglx@linutronix.de>
    x86/devicetable: Move x86 specific macro out of generic code

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Revert "x86/speculation: Add RSB VM Exit protections"


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  13 +
 .../process/code-of-conduct-interpretation.rst     |   2 +-
 Makefile                                           |   4 +-
 arch/x86/entry/calling.h                           |  68 +++-
 arch/x86/entry/entry_32.S                          |   2 -
 arch/x86/entry/entry_64.S                          |  34 +-
 arch/x86/entry/entry_64_compat.S                   |  11 +-
 arch/x86/include/asm/cpu_device_id.h               | 132 +++++++-
 arch/x86/include/asm/cpufeatures.h                 |  13 +-
 arch/x86/include/asm/intel-family.h                |   6 +
 arch/x86/include/asm/msr-index.h                   |  10 +
 arch/x86/include/asm/nospec-branch.h               |  54 +--
 arch/x86/kernel/cpu/amd.c                          |  21 +-
 arch/x86/kernel/cpu/bugs.c                         | 365 ++++++++++++++++-----
 arch/x86/kernel/cpu/common.c                       |  61 ++--
 arch/x86/kernel/cpu/match.c                        |  13 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kvm/svm.c                                 |   1 +
 arch/x86/kvm/vmx/nested.c                          |  32 +-
 arch/x86/kvm/vmx/run_flags.h                       |   8 +
 arch/x86/kvm/vmx/vmenter.S                         | 161 +++++----
 arch/x86/kvm/vmx/vmx.c                             |  72 ++--
 arch/x86/kvm/vmx/vmx.h                             |   5 +
 arch/x86/kvm/x86.c                                 |   4 +-
 drivers/base/cpu.c                                 |   8 +
 drivers/cpufreq/acpi-cpufreq.c                     |   1 +
 drivers/cpufreq/amd_freq_sensitivity.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 -
 drivers/idle/intel_idle.c                          |  43 ++-
 fs/xfs/libxfs/xfs_attr.c                           |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h                      |  26 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |  85 +++--
 fs/xfs/libxfs/xfs_attr_remote.h                    |   2 +
 fs/xfs/libxfs/xfs_da_btree.h                       |  17 +-
 fs/xfs/libxfs/xfs_da_format.c                      |   1 +
 fs/xfs/libxfs/xfs_da_format.h                      |  59 ----
 fs/xfs/libxfs/xfs_dir2.h                           |   2 +
 fs/xfs/libxfs/xfs_dir2_priv.h                      |  19 ++
 fs/xfs/libxfs/xfs_format.h                         |   7 +
 fs/xfs/xfs_attr_inactive.c                         | 146 +++------
 fs/xfs/xfs_file.c                                  |   7 +-
 fs/xfs/xfs_inode.c                                 |  25 +-
 fs/xfs/xfs_reflink.c                               |   3 +-
 fs/xfs/xfs_super.c                                 |  48 ++-
 include/linux/cpu.h                                |   2 +
 include/linux/kvm_host.h                           |   2 +-
 include/linux/mod_devicetable.h                    |   4 +-
 scripts/Makefile.extrawarn                         |   1 +
 tools/arch/x86/include/asm/cpufeatures.h           |   2 +-
 51 files changed, 1056 insertions(+), 558 deletions(-)


