Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A516157DE21
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiGVJVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiGVJS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:18:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2B5EE3F;
        Fri, 22 Jul 2022 02:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3092CB827C1;
        Fri, 22 Jul 2022 09:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A36BC341C6;
        Fri, 22 Jul 2022 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481181;
        bh=Oyj4WRa2+KA3dsbvsVzxnLv5CoCIqoH0hShcQHsBQ8Y=;
        h=From:To:Cc:Subject:Date:From;
        b=e3xOb4n8ZwPthFICL56jeTa/sRoD/u8qozTKCUzYgwfjr3isCpBrQZShdjtxTxibG
         pw9ZpqgqOBDWysOvXwTDpq7Wam+/Mgxfs9wQH9tXLGEggZOkZhAomYN3b1zOzUV8Qu
         kwZlho3Ps3Gxv3gHC6TNaA+KYBwbVPCT4uGXRFVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/89] 5.15.57-rc1 review
Date:   Fri, 22 Jul 2022 11:10:34 +0200
Message-Id: <20220722091133.320803732@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.57-rc1
X-KernelTest-Deadline: 2022-07-24T09:11+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.57 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.57-rc1

Peter Zijlstra <peterz@infradead.org>
    x86: Use -mindirect-branch-cs-prefix for RETPOLINE builds

Peter Zijlstra <peterz@infradead.org>
    um: Add missing apply_returns()

Kim Phillips <kim.phillips@amd.com>
    x86/bugs: Remove apostrophe typo

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers cpufeatures: Sync with the kernel sources

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools arch x86: Sync the msr-index.h copy with the kernel sources

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulate: do not adjust size of fastop and setcc subroutines

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/kvm: fix FASTOP_SIZE when return thunks are enabled

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    efi/x86: use naked RET on mixed mode call wrapper

Nathan Chancellor <nathan@kernel.org>
    x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Jiri Slaby <jirislaby@kernel.org>
    x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit

Ben Hutchings <ben@decadent.org.uk>
    x86/xen: Fix initialisation in hypercall_page after rethunk

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

Peter Zijlstra <peterz@infradead.org>
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

Peter Zijlstra <peterz@infradead.org>
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

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/realmode: build with -D__DISABLE_EXPORTS

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Remove skip_r11rcx

Peter Zijlstra <peterz@infradead.org>
    objtool: Default ignore INT3 for unreachable

Peter Zijlstra <peterz@infradead.org>
    bpf,x86: Respect X86_FEATURE_RETPOLINE*

Peter Zijlstra <peterz@infradead.org>
    bpf,x86: Simplify computing label offsets

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Add debug prints to apply_retpolines()

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Try inline spectre_v2=retpoline,amd

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Handle Jcc __x86_indirect_thunk_\reg

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Implement .retpoline_sites support

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Create a retpoline thunk array

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Move the retpoline thunk declarations to nospec-branch.h

Peter Zijlstra <peterz@infradead.org>
    x86/asm: Fixup odd GEN-for-each-reg.h usage

Peter Zijlstra <peterz@infradead.org>
    x86/asm: Fix register order

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Remove unused replacement symbols

Peter Zijlstra <peterz@infradead.org>
    objtool: Introduce CFI hash

Peter Zijlstra <peterz@infradead.org>
    objtool,x86: Replace alternatives with .retpoline_sites

Peter Zijlstra <peterz@infradead.org>
    objtool: Shrink struct instruction

Peter Zijlstra <peterz@infradead.org>
    objtool: Explicitly avoid self modifying code in .altinstr_replacement

Peter Zijlstra <peterz@infradead.org>
    objtool: Classify symbols

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

 Documentation/admin-guide/kernel-parameters.txt |  25 +
 Makefile                                        |  11 +-
 arch/um/kernel/um_arch.c                        |   8 +
 arch/x86/Kconfig                                | 103 +++-
 arch/x86/Makefile                               |   2 +-
 arch/x86/entry/Makefile                         |   2 +-
 arch/x86/entry/calling.h                        |  72 ++-
 arch/x86/entry/entry.S                          |  22 +
 arch/x86/entry/entry_32.S                       |   2 -
 arch/x86/entry/entry_64.S                       |  88 ++-
 arch/x86/entry/entry_64_compat.S                |  21 +-
 arch/x86/entry/vdso/Makefile                    |   1 +
 arch/x86/entry/vsyscall/vsyscall_emu_64.S       |   9 +-
 arch/x86/include/asm/GEN-for-each-reg.h         |  14 +-
 arch/x86/include/asm/alternative.h              |   2 +
 arch/x86/include/asm/asm-prototypes.h           |  18 -
 arch/x86/include/asm/cpufeatures.h              |  12 +-
 arch/x86/include/asm/disabled-features.h        |  21 +-
 arch/x86/include/asm/linkage.h                  |   8 +
 arch/x86/include/asm/msr-index.h                |  13 +
 arch/x86/include/asm/nospec-branch.h            | 134 ++---
 arch/x86/include/asm/static_call.h              |  17 +
 arch/x86/include/asm/traps.h                    |   2 +-
 arch/x86/include/asm/unwind_hints.h             |  14 +-
 arch/x86/kernel/alternative.c                   | 260 ++++++++-
 arch/x86/kernel/cpu/amd.c                       |  46 +-
 arch/x86/kernel/cpu/bugs.c                      | 475 +++++++++++++---
 arch/x86/kernel/cpu/common.c                    |  61 ++-
 arch/x86/kernel/cpu/cpu.h                       |   2 +
 arch/x86/kernel/cpu/hygon.c                     |   6 +
 arch/x86/kernel/cpu/scattered.c                 |   1 +
 arch/x86/kernel/ftrace.c                        |   7 +-
 arch/x86/kernel/head_32.S                       |   1 +
 arch/x86/kernel/head_64.S                       |   5 +
 arch/x86/kernel/module.c                        |  15 +-
 arch/x86/kernel/process.c                       |   2 +-
 arch/x86/kernel/relocate_kernel_32.S            |  25 +-
 arch/x86/kernel/relocate_kernel_64.S            |  23 +-
 arch/x86/kernel/static_call.c                   |  49 +-
 arch/x86/kernel/traps.c                         |  19 +-
 arch/x86/kernel/vmlinux.lds.S                   |  23 +-
 arch/x86/kvm/emulate.c                          |  33 +-
 arch/x86/kvm/svm/vmenter.S                      |  18 +
 arch/x86/kvm/vmx/nested.c                       |   2 +-
 arch/x86/kvm/vmx/run_flags.h                    |   8 +
 arch/x86/kvm/vmx/vmenter.S                      | 164 +++---
 arch/x86/kvm/vmx/vmx.c                          |  76 ++-
 arch/x86/kvm/vmx/vmx.h                          |   6 +-
 arch/x86/kvm/x86.c                              |   4 +-
 arch/x86/lib/memmove_64.S                       |   7 +-
 arch/x86/lib/retpoline.S                        | 133 +++--
 arch/x86/mm/mem_encrypt_boot.S                  |  10 +-
 arch/x86/net/bpf_jit_comp.c                     | 179 +++---
 arch/x86/net/bpf_jit_comp32.c                   |  22 +-
 arch/x86/platform/efi/efi_thunk_64.S            |   5 +-
 arch/x86/xen/setup.c                            |   6 +-
 arch/x86/xen/xen-asm.S                          |  30 +-
 arch/x86/xen/xen-head.S                         |   5 +-
 arch/x86/xen/xen-ops.h                          |   6 +-
 drivers/base/cpu.c                              |   8 +
 drivers/idle/intel_idle.c                       |  43 +-
 include/linux/cpu.h                             |   2 +
 include/linux/kvm_host.h                        |   2 +-
 include/linux/objtool.h                         |   9 +-
 scripts/Makefile.build                          |   1 +
 scripts/link-vmlinux.sh                         |   3 +
 security/Kconfig                                |  11 -
 tools/arch/x86/include/asm/cpufeatures.h        |  12 +-
 tools/arch/x86/include/asm/disabled-features.h  |  21 +-
 tools/arch/x86/include/asm/msr-index.h          |  13 +
 tools/include/linux/objtool.h                   |   9 +-
 tools/objtool/arch/x86/decode.c                 | 145 +----
 tools/objtool/builtin-check.c                   |   4 +-
 tools/objtool/check.c                           | 701 ++++++++++++++++++++----
 tools/objtool/elf.c                             |  84 ---
 tools/objtool/include/objtool/arch.h            |   3 +-
 tools/objtool/include/objtool/builtin.h         |   2 +-
 tools/objtool/include/objtool/cfi.h             |   2 +
 tools/objtool/include/objtool/check.h           |  10 +-
 tools/objtool/include/objtool/elf.h             |   9 +-
 tools/objtool/include/objtool/objtool.h         |   1 +
 tools/objtool/objtool.c                         |   1 +
 tools/objtool/orc_gen.c                         |  15 +-
 tools/objtool/special.c                         |   8 -
 84 files changed, 2520 insertions(+), 954 deletions(-)


