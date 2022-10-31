Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE7F6130DC
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJaHCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaHCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9E1BC31;
        Mon, 31 Oct 2022 00:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3657AB81151;
        Mon, 31 Oct 2022 07:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6230DC433C1;
        Mon, 31 Oct 2022 07:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199734;
        bh=izXUeTAnZYDOq36uQJFHi8H95rgZoH4hxSRBjqOB43k=;
        h=From:To:Cc:Subject:Date:From;
        b=WDTZe131H5mBA1z9XM8YMCa0dYryERRsdZOlPzbziKLdoOplI6Ig7x8muFaoe2uKX
         GjvUrMkAY/MBTyjuskGnQtsL8xxRBgeM4Hal+ORzWOmFHlEXxjFVjrsaV1Xi+c9CXS
         GS4apyipyzYYS30DEkLUKLNln89sqMYGnIlrJITU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 4.14 00/34] 4.14.297-rc1 review
Date:   Mon, 31 Oct 2022 08:02:33 +0100
Message-Id: <20221031070140.108124105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.297-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.297-rc1
X-KernelTest-Deadline: 2022-11-02T07:01+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.297 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Nov 2022 07:01:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.297-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.297-rc1

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

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add LFENCE to RSB fill sequence

Peter Zijlstra <peterz@infradead.org>
    x86/speculation: Change FILL_RETURN_BUFFER to work with objtool

Peter Zijlstra <peterz@infradead.org>
    entel_idle: Disable IBRS during long idle

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Report Intel retbleed vulnerability

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Optimize SPEC_CTRL MSR writes

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/entry: Add kernel IBRS implementation

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Add AMD retbleed= boot parameter

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Report AMD retbleed vulnerability

Peter Zijlstra <peterz@infradead.org>
    x86/cpufeatures: Move RETPOLINE flags to word 11

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Remove skip_r11rcx

Mark Gross <mgross@linux.intel.com>
    x86/cpu: Add a steppings field to struct x86_cpu_id

Thomas Gleixner <tglx@linutronix.de>
    x86/cpu: Add consistent CPU match macros

Thomas Gleixner <tglx@linutronix.de>
    x86/devicetable: Move x86 specific macro out of generic code

Ingo Molnar <mingo@kernel.org>
    x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header

Kan Liang <kan.liang@linux.intel.com>
    x86/cpufeature: Add facility to check for min microcode revisions

Suraj Jitindar Singh <surajjs@amazon.com>
    Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst   |   8 +
 Documentation/admin-guide/kernel-parameters.txt |  13 +
 Makefile                                        |   4 +-
 arch/x86/entry/calling.h                        |  68 +++-
 arch/x86/entry/entry_32.S                       |   2 -
 arch/x86/entry/entry_64.S                       |  38 ++-
 arch/x86/entry/entry_64_compat.S                |  12 +-
 arch/x86/include/asm/cpu_device_id.h            | 168 +++++++++-
 arch/x86/include/asm/cpufeatures.h              |  16 +-
 arch/x86/include/asm/intel-family.h             |   6 +
 arch/x86/include/asm/msr-index.h                |  14 +
 arch/x86/include/asm/nospec-branch.h            |  48 +--
 arch/x86/kernel/cpu/amd.c                       |  21 +-
 arch/x86/kernel/cpu/bugs.c                      | 415 ++++++++++++++++++++----
 arch/x86/kernel/cpu/common.c                    |  68 ++--
 arch/x86/kernel/cpu/match.c                     |  44 ++-
 arch/x86/kernel/cpu/scattered.c                 |   1 +
 arch/x86/kernel/process.c                       |   2 +-
 arch/x86/kvm/svm.c                              |   1 +
 arch/x86/kvm/vmx.c                              |  51 ++-
 drivers/base/cpu.c                              |   8 +
 drivers/cpufreq/acpi-cpufreq.c                  |   1 +
 drivers/cpufreq/amd_freq_sensitivity.c          |   1 +
 drivers/idle/intel_idle.c                       |  45 ++-
 include/linux/cpu.h                             |   2 +
 include/linux/mod_devicetable.h                 |   4 +-
 tools/arch/x86/include/asm/cpufeatures.h        |   1 +
 27 files changed, 899 insertions(+), 163 deletions(-)


