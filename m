Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6435724EC
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiGLTII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbiGLTH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:07:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F04FB8FE;
        Tue, 12 Jul 2022 11:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 513B8B81BAB;
        Tue, 12 Jul 2022 18:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8915CC3411C;
        Tue, 12 Jul 2022 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651892;
        bh=YsMRwxZ8Zp9d5R7Rnw9AJjFXRfo7VcwZShIY4SCnjdg=;
        h=From:To:Cc:Subject:Date:From;
        b=xDYV5ARJotS1S7ZvjbHFk08n0jzsCZGYzD6Awxu7N0snrf5N4607aCHzJK+gBbOxs
         c5SBxgkiRqrPmTEtbPlsXvdfTUUrDUCOCCAORrbD4neS1fFaRTSP9qBTIxtfQnfinQ
         9T4jgNmnKKAi7it5kdFDc1DcbYkDGUm6ngK6h6rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 00/61] 5.18.12-rc1 review
Date:   Tue, 12 Jul 2022 20:38:57 +0200
Message-Id: <20220712183236.931648980@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.12-rc1
X-KernelTest-Deadline: 2022-07-14T18:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.12 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.12-rc1

Thomas Gleixner <tglx@linutronix.de>
    x86/static_call: Serialize __static_call_fixup() properly

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Disable RRSBA behavior

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/kexec: Disable RET on kexec

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/bugs: Do not enable IBPB-on-entry when IBPB is not supported

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Add Cannon lake to RETBleed affected CPU list

Peter Zijlstra <peterz@infradead.org>
    x86/retbleed: Add fine grained Kconfig knobs

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/cpu/amd: Enumerate BTC_NO

Peter Zijlstra <peterz@infradead.org>
    x86/common: Stamp out the stepping madness

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Prevent RSB underflow before vmenter

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation: Fill RSB on vmexit for IBRS

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Fix IBRS handling after vmexit

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Convert launched argument to flags

Josh Poimboeuf <jpoimboe@kernel.org>
    KVM: VMX: Flatten __vmx_vcpu_run()

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Re-add UNWIND_HINT_{SAVE_RESTORE}

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
    x86/cpu/amd: Add Spectral Chicken

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    objtool: Add entry UNRET validation

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/bugs: Do IBPB fallback check only once

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Add retbleed=ibpb

Peter Zijlstra <peterz@infradead.org>
    x86/xen: Add UNTRAIN_RET

Peter Zijlstra <peterz@infradead.org>
    x86/xen: Rename SYS* entry points

Peter Zijlstra <peterz@infradead.org>
    objtool: Update Retpoline validation

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

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/entry: Add kernel IBRS implementation

Peter Zijlstra <peterz@infradead.org>
    x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value

Kim Phillips <kim.phillips@amd.com>
    x86/bugs: Enable STIBP for JMP2RET

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Add AMD retbleed= boot parameter

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bugs: Report AMD retbleed vulnerability

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86: Add magic AMD return-thunk

Peter Zijlstra <peterz@infradead.org>
    objtool: Treat .text.__x86.* as noinstr

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Avoid very early RET

Peter Zijlstra <peterz@infradead.org>
    x86: Use return-thunk in asm code

Kim Phillips <kim.phillips@amd.com>
    x86/sev: Avoid using __x86_return_thunk

Peter Zijlstra <peterz@infradead.org>
    x86/vsyscall_emu/64: Don't use RET in vsyscall emulation

Peter Zijlstra <peterz@infradead.org>
    x86/kvm: Fix SETcc emulation for return thunks

Peter Zijlstra <peterz@infradead.org>
    x86/bpf: Use alternative RET encoding

Peter Zijlstra <peterz@infradead.org>
    x86/ftrace: Use alternative RET encoding

Peter Zijlstra <peterz@infradead.org>
    x86,static_call: Use alternative RET encoding

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    objtool: skip non-text sections when adding return-thunk sites

Peter Zijlstra <peterz@infradead.org>
    x86,objtool: Create .return_sites

Peter Zijlstra <peterz@infradead.org>
    x86: Undo return-thunk damage

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Use -mfunction-return

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Swizzle retpoline thunk

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Cleanup some #ifdefery

Peter Zijlstra <peterz@infradead.org>
    x86/cpufeatures: Move RETPOLINE flags to word 11

Peter Zijlstra <peterz@infradead.org>
    x86/kvm/vmx: Make noinstr clean

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Remove skip_r11rcx

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/entry: Don't call error_entry() for XENPV

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/entry: Switch the stack after error_entry() returns

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    x86/traps: Use pt_regs directly in fixup_bad_iret()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |  25 ++
 Makefile                                        |   4 +-
 arch/x86/Kconfig                                | 103 +++--
 arch/x86/Makefile                               |   6 +
 arch/x86/entry/Makefile                         |   2 +-
 arch/x86/entry/calling.h                        |  72 +++-
 arch/x86/entry/entry.S                          |  22 ++
 arch/x86/entry/entry_32.S                       |   2 -
 arch/x86/entry/entry_64.S                       |  88 ++++-
 arch/x86/entry/entry_64_compat.S                |  21 +-
 arch/x86/entry/vdso/Makefile                    |   1 +
 arch/x86/entry/vsyscall/vsyscall_emu_64.S       |   9 +-
 arch/x86/include/asm/alternative.h              |   1 +
 arch/x86/include/asm/cpufeatures.h              |  12 +-
 arch/x86/include/asm/disabled-features.h        |  21 +-
 arch/x86/include/asm/linkage.h                  |   8 +
 arch/x86/include/asm/msr-index.h                |  13 +
 arch/x86/include/asm/nospec-branch.h            |  68 +++-
 arch/x86/include/asm/static_call.h              |  19 +-
 arch/x86/include/asm/traps.h                    |   2 +-
 arch/x86/include/asm/unwind_hints.h             |  14 +-
 arch/x86/kernel/alternative.c                   |  69 ++++
 arch/x86/kernel/asm-offsets.c                   |   6 +
 arch/x86/kernel/cpu/amd.c                       |  46 ++-
 arch/x86/kernel/cpu/bugs.c                      | 475 ++++++++++++++++++++----
 arch/x86/kernel/cpu/common.c                    |  61 +--
 arch/x86/kernel/cpu/cpu.h                       |   2 +
 arch/x86/kernel/cpu/hygon.c                     |   6 +
 arch/x86/kernel/cpu/scattered.c                 |   1 +
 arch/x86/kernel/ftrace.c                        |   7 +-
 arch/x86/kernel/head_64.S                       |   5 +
 arch/x86/kernel/module.c                        |   8 +-
 arch/x86/kernel/process.c                       |   2 +-
 arch/x86/kernel/relocate_kernel_32.S            |  25 +-
 arch/x86/kernel/relocate_kernel_64.S            |  23 +-
 arch/x86/kernel/static_call.c                   |  51 ++-
 arch/x86/kernel/traps.c                         |  19 +-
 arch/x86/kernel/vmlinux.lds.S                   |   9 +-
 arch/x86/kvm/emulate.c                          |  28 +-
 arch/x86/kvm/svm/vmenter.S                      |  18 +
 arch/x86/kvm/vmx/capabilities.h                 |   4 +-
 arch/x86/kvm/vmx/nested.c                       |   2 +-
 arch/x86/kvm/vmx/run_flags.h                    |   8 +
 arch/x86/kvm/vmx/vmenter.S                      | 194 ++++++----
 arch/x86/kvm/vmx/vmx.c                          |  84 +++--
 arch/x86/kvm/vmx/vmx.h                          |  10 +-
 arch/x86/kvm/vmx/vmx_ops.h                      |   2 +-
 arch/x86/kvm/x86.c                              |   4 +-
 arch/x86/lib/memmove_64.S                       |   7 +-
 arch/x86/lib/retpoline.S                        |  79 +++-
 arch/x86/mm/mem_encrypt_boot.S                  |  10 +-
 arch/x86/net/bpf_jit_comp.c                     |  26 +-
 arch/x86/xen/setup.c                            |   6 +-
 arch/x86/xen/xen-asm.S                          |  30 +-
 arch/x86/xen/xen-head.S                         |   1 +
 arch/x86/xen/xen-ops.h                          |   6 +-
 drivers/base/cpu.c                              |   8 +
 drivers/idle/intel_idle.c                       |  44 ++-
 include/linux/cpu.h                             |   2 +
 include/linux/kvm_host.h                        |   2 +-
 include/linux/objtool.h                         |   9 +-
 scripts/Makefile.build                          |   1 +
 scripts/link-vmlinux.sh                         |   3 +
 security/Kconfig                                |  11 -
 tools/arch/x86/include/asm/msr-index.h          |   9 +
 tools/include/linux/objtool.h                   |   9 +-
 tools/objtool/arch/x86/decode.c                 |   5 +
 tools/objtool/builtin-check.c                   |   4 +-
 tools/objtool/check.c                           | 331 ++++++++++++++++-
 tools/objtool/include/objtool/arch.h            |   1 +
 tools/objtool/include/objtool/builtin.h         |   2 +-
 tools/objtool/include/objtool/check.h           |  24 +-
 tools/objtool/include/objtool/elf.h             |   1 +
 tools/objtool/include/objtool/objtool.h         |   1 +
 tools/objtool/objtool.c                         |   1 +
 75 files changed, 1890 insertions(+), 425 deletions(-)


