Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46F557ED71
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiGWJ5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiGWJ5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E4B3C164;
        Sat, 23 Jul 2022 02:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E42DB82C1B;
        Sat, 23 Jul 2022 09:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC9C341C0;
        Sat, 23 Jul 2022 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570212;
        bh=ZwQQNYUjSB/xKmaB3+OFuC0u7cCzi+rxNe3jfNarZ8M=;
        h=From:To:Cc:Subject:Date:From;
        b=AMK9/gPhIT460vpQdzxyQAvEfak0YRXmZ2d4fedMNU1ur0C5Vtu3sq2n28fTZABtm
         QpBuYNUvK8h1g/KBzAZXC8NsDpoqtLl9TPEQRToPFmMPQEeElvszgsibNIOGBKT6HP
         ufgFhYxhbWjVazANhkQkkLGkU7PdaorafAogJAog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/148] 5.10.133-rc1 review
Date:   Sat, 23 Jul 2022 11:53:32 +0200
Message-Id: <20220723095224.302504400@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.133-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.133-rc1
X-KernelTest-Deadline: 2022-07-25T09:53+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.133 release.
There are 148 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.133-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.133-rc1

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers: Remove broken definition of __LITTLE_ENDIAN

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy' - again

Vasily Gorbik <gor@linux.ibm.com>
    objtool: Fix elf_create_undef_symbol() endianness

Linus Torvalds <torvalds@linux-foundation.org>
    kvm: fix objtool relocation warning

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

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/ftrace: Add UNWIND_HINT_FUNC annotation for ftrace_stub

Ben Hutchings <ben@decadent.org.uk>
    x86/xen: Fix initialisation in hypercall_page after rethunk

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted

Borislav Petkov <bp@suse.de>
    tools/insn: Restore the relative include paths for cross building

Thomas Gleixner <tglx@linutronix.de>
    x86/static_call: Serialize __static_call_fixup() properly

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Disable RRSBA behavior

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    x86/kexec: Disable RET on kexec

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    x86/bugs: Do not enable IBPB-on-entry when IBPB is not supported

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

Peter Zijlstra <peterz@infradead.org>
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

Ben Hutchings <ben@decadent.org.uk>
    Makefile: Set retpoline cflags based on CONFIG_CC_IS_{CLANG,GCC}

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

Mikulas Patocka <mpatocka@redhat.com>
    objtool: Fix objtool regression on x32 systems

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Remove skip_r11rcx

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix symbol creation

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix type of reloc::addend

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix code relocs vs weak symbols

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix SLS validation for kcov tail-call replacement

Peter Zijlstra <peterz@infradead.org>
    crypto: x86/poly1305 - Fixup SLS

Peter Zijlstra <peterz@infradead.org>
    objtool: Default ignore INT3 for unreachable

Borislav Petkov <bp@suse.de>
    kvm/emulate: Fix SETcc emulation function offsets with SLS

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy'

Peter Zijlstra <peterz@infradead.org>
    x86: Add straight-line-speculation mitigation

Peter Zijlstra <peterz@infradead.org>
    objtool: Add straight-line-speculation validation

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Relax text_poke_bp() constraint

Peter Zijlstra <peterz@infradead.org>
    x86: Prepare inline-asm for straight-line-speculation

Peter Zijlstra <peterz@infradead.org>
    x86: Prepare asm files for straight-line-speculation

Peter Zijlstra <peterz@infradead.org>
    x86/lib/atomic64_386_32: Rename things

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
    objtool,x86: Replace alternatives with .retpoline_sites

Peter Zijlstra <peterz@infradead.org>
    objtool: Explicitly avoid self modifying code in .altinstr_replacement

Peter Zijlstra <peterz@infradead.org>
    objtool: Classify symbols

Peter Zijlstra <peterz@infradead.org>
    objtool: Handle __sanitize_cov*() tail calls

Peter Zijlstra <peterz@infradead.org>
    objtool: Introduce CFI hash

Joe Lawrence <joe.lawrence@redhat.com>
    objtool: Make .altinstructions section entry size consistent

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Remove reloc symbol type checks in get_alt_entry()

Linus Torvalds <torvalds@linux-foundation.org>
    objtool: print out the symbol type when complaining about it

Peter Zijlstra <peterz@infradead.org>
    objtool: Teach get_alt_entry() about more relocation types

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't make .altinstructions writable

Peter Zijlstra <peterz@infradead.org>
    objtool/x86: Ignore __x86_indirect_alt_* symbols

Peter Zijlstra <peterz@infradead.org>
    objtool: Only rewrite unconditional retpoline thunk calls

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix .symtab_shndx handling for elf_create_undef_symbol()

Borislav Petkov <bp@suse.de>
    x86/alternative: Optimize single-byte NOPs at an arbitrary position

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support asm jump tables

Peter Zijlstra <peterz@infradead.org>
    objtool/x86: Rewrite retpoline thunk calls

Peter Zijlstra <peterz@infradead.org>
    objtool: Skip magical retpoline .altinstr_replacement

Peter Zijlstra <peterz@infradead.org>
    objtool: Cache instruction relocs

Peter Zijlstra <peterz@infradead.org>
    objtool: Keep track of retpoline call sites

Peter Zijlstra <peterz@infradead.org>
    objtool: Add elf_create_undef_symbol()

Peter Zijlstra <peterz@infradead.org>
    objtool: Extract elf_symbol_add()

Peter Zijlstra <peterz@infradead.org>
    objtool: Extract elf_strtab_concat()

Peter Zijlstra <peterz@infradead.org>
    objtool: Create reloc sections implicitly

Peter Zijlstra <peterz@infradead.org>
    objtool: Add elf_create_reloc() helper

Peter Zijlstra <peterz@infradead.org>
    objtool: Rework the elf_rebuild_reloc_section() logic

Peter Zijlstra <peterz@infradead.org>
    objtool: Handle per arch retpoline naming

Peter Zijlstra <peterz@infradead.org>
    objtool: Correctly handle retpoline thunk calls

Peter Zijlstra <peterz@infradead.org>
    x86/retpoline: Simplify retpolines

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Optimize optimize_nops()

Ben Hutchings <ben@decadent.org.uk>
    x86: Add insn_decode_kernel()

Borislav Petkov <bp@suse.de>
    x86/alternative: Use insn_decode()

Borislav Petkov <bp@suse.de>
    x86/insn-eval: Handle return values from the decoder

Borislav Petkov <bp@suse.de>
    x86/insn: Add an insn_decode() API

Borislav Petkov <bp@suse.de>
    x86/insn: Add a __ignore_sync_check__ marker

Borislav Petkov <bp@suse.de>
    x86/insn: Rename insn_decode() to insn_decode_from_regs()

Juergen Gross <jgross@suse.com>
    x86/alternative: Use ALTERNATIVE_TERNARY() in _static_cpu_has()

Juergen Gross <jgross@suse.com>
    x86/alternative: Support ALTERNATIVE_TERNARY

Juergen Gross <jgross@suse.com>
    x86/alternative: Support not-feature

Juergen Gross <jgross@suse.com>
    x86/alternative: Merge include files

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/xen: Support objtool vmlinux.o validation in xen-head.S

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/xen: Support objtool validation in xen-asm.S

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Combine UNWIND_HINT_RET_OFFSET and UNWIND_HINT_FUNC

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Assume only ELF functions do sibling calls

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support retpoline jump detection for vmlinux.o

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support stack layout changes in alternatives

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Add 'alt_group' struct

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Refactor ORC section generation

Uros Bizjak <ubizjak@gmail.com>
    KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw

Uros Bizjak <ubizjak@gmail.com>
    KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   25 +
 Makefile                                           |   25 +-
 arch/um/kernel/um_arch.c                           |    8 +
 arch/x86/Kconfig                                   |   91 +-
 arch/x86/Makefile                                  |    8 +-
 arch/x86/boot/compressed/efi_thunk_64.S            |    2 +-
 arch/x86/boot/compressed/head_64.S                 |    4 +-
 arch/x86/boot/compressed/mem_encrypt.S             |    4 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |   48 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |    2 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   52 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |   40 +-
 arch/x86/crypto/blake2s-core.S                     |    4 +-
 arch/x86/crypto/blowfish-x86_64-asm_64.S           |   12 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |   18 +-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       |   18 +-
 arch/x86/crypto/camellia-x86_64-asm_64.S           |   12 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |   12 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |   16 +-
 arch/x86/crypto/chacha-avx2-x86_64.S               |    6 +-
 arch/x86/crypto/chacha-avx512vl-x86_64.S           |    6 +-
 arch/x86/crypto/chacha-ssse3-x86_64.S              |    8 +-
 arch/x86/crypto/crc32-pclmul_asm.S                 |    2 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |    2 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S             |    2 +-
 arch/x86/crypto/des3_ede-asm_64.S                  |    4 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    6 +-
 arch/x86/crypto/nh-avx2-x86_64.S                   |    2 +-
 arch/x86/crypto/nh-sse2-x86_64.S                   |    2 +-
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl      |   38 +-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |   16 +-
 arch/x86/crypto/serpent-avx2-asm_64.S              |   16 +-
 arch/x86/crypto/serpent-sse2-i586-asm_32.S         |    6 +-
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S       |    6 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S             |    2 +-
 arch/x86/crypto/sha1_ni_asm.S                      |    2 +-
 arch/x86/crypto/sha1_ssse3_asm.S                   |    2 +-
 arch/x86/crypto/sha256-avx-asm.S                   |    2 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |    2 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |    2 +-
 arch/x86/crypto/sha256_ni_asm.S                    |    2 +-
 arch/x86/crypto/sha512-avx-asm.S                   |    2 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |    2 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |    2 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |   16 +-
 arch/x86/crypto/twofish-i586-asm_32.S              |    4 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |    6 +-
 arch/x86/crypto/twofish-x86_64-asm_64.S            |    4 +-
 arch/x86/entry/Makefile                            |    2 +-
 arch/x86/entry/calling.h                           |   72 +-
 arch/x86/entry/entry.S                             |   22 +
 arch/x86/entry/entry_32.S                          |    6 +-
 arch/x86/entry/entry_64.S                          |   62 +-
 arch/x86/entry/entry_64_compat.S                   |   21 +-
 arch/x86/entry/thunk_32.S                          |    2 +-
 arch/x86/entry/thunk_64.S                          |    2 +-
 arch/x86/entry/vdso/Makefile                       |    1 +
 arch/x86/entry/vdso/vdso32/system_call.S           |    4 +-
 arch/x86/entry/vsyscall/vsyscall_emu_64.S          |    3 +
 arch/x86/include/asm/GEN-for-each-reg.h            |   14 +-
 arch/x86/include/asm/alternative-asm.h             |  114 --
 arch/x86/include/asm/alternative.h                 |  137 ++-
 arch/x86/include/asm/asm-prototypes.h              |   17 -
 arch/x86/include/asm/cpufeature.h                  |   41 +-
 arch/x86/include/asm/cpufeatures.h                 |   14 +-
 arch/x86/include/asm/disabled-features.h           |   21 +-
 arch/x86/include/asm/inat.h                        |    2 +-
 arch/x86/include/asm/insn-eval.h                   |    4 +-
 arch/x86/include/asm/insn.h                        |   28 +-
 arch/x86/include/asm/linkage.h                     |   22 +
 arch/x86/include/asm/msr-index.h                   |   13 +
 arch/x86/include/asm/nospec-branch.h               |  141 +--
 arch/x86/include/asm/paravirt.h                    |    2 +-
 arch/x86/include/asm/qspinlock_paravirt.h          |    4 +-
 arch/x86/include/asm/smap.h                        |    5 +-
 arch/x86/include/asm/static_call.h                 |   19 +-
 arch/x86/include/asm/unwind_hints.h                |   23 +-
 arch/x86/kernel/acpi/wakeup_32.S                   |    6 +-
 arch/x86/kernel/alternative.c                      |  406 ++++++-
 arch/x86/kernel/cpu/amd.c                          |   46 +-
 arch/x86/kernel/cpu/bugs.c                         |  475 ++++++--
 arch/x86/kernel/cpu/common.c                       |   61 +-
 arch/x86/kernel/cpu/cpu.h                          |    2 +
 arch/x86/kernel/cpu/hygon.c                        |    6 +
 arch/x86/kernel/cpu/scattered.c                    |    1 +
 arch/x86/kernel/ftrace.c                           |    7 +-
 arch/x86/kernel/ftrace_32.S                        |    6 +-
 arch/x86/kernel/ftrace_64.S                        |   13 +-
 arch/x86/kernel/head_32.S                          |    3 +-
 arch/x86/kernel/head_64.S                          |    5 +
 arch/x86/kernel/irqflags.S                         |    4 +-
 arch/x86/kernel/kprobes/core.c                     |    2 +-
 arch/x86/kernel/kvm.c                              |    2 +-
 arch/x86/kernel/module.c                           |   15 +-
 arch/x86/kernel/paravirt.c                         |    2 +-
 arch/x86/kernel/process.c                          |    2 +-
 arch/x86/kernel/relocate_kernel_32.S               |   15 +-
 arch/x86/kernel/relocate_kernel_64.S               |   13 +-
 arch/x86/kernel/sev-es.c                           |    2 +-
 arch/x86/kernel/sev_verify_cbit.S                  |    2 +-
 arch/x86/kernel/static_call.c                      |   52 +-
 arch/x86/kernel/umip.c                             |    2 +-
 arch/x86/kernel/verify_cpu.S                       |    4 +-
 arch/x86/kernel/vmlinux.lds.S                      |   23 +-
 arch/x86/kvm/emulate.c                             |   39 +-
 arch/x86/kvm/svm/vmenter.S                         |   11 +-
 arch/x86/kvm/vmx/nested.c                          |   32 +-
 arch/x86/kvm/vmx/run_flags.h                       |    8 +
 arch/x86/kvm/vmx/vmenter.S                         |  170 +--
 arch/x86/kvm/vmx/vmx.c                             |   78 +-
 arch/x86/kvm/vmx/vmx.h                             |    5 +
 arch/x86/kvm/x86.c                                 |    4 +-
 arch/x86/lib/atomic64_386_32.S                     |   88 +-
 arch/x86/lib/atomic64_cx8_32.S                     |   18 +-
 arch/x86/lib/checksum_32.S                         |    8 +-
 arch/x86/lib/clear_page_64.S                       |    6 +-
 arch/x86/lib/cmpxchg16b_emu.S                      |    4 +-
 arch/x86/lib/cmpxchg8b_emu.S                       |    4 +-
 arch/x86/lib/copy_mc_64.S                          |    6 +-
 arch/x86/lib/copy_page_64.S                        |    6 +-
 arch/x86/lib/copy_user_64.S                        |   14 +-
 arch/x86/lib/csum-copy_64.S                        |    2 +-
 arch/x86/lib/error-inject.c                        |    3 +-
 arch/x86/lib/getuser.S                             |   22 +-
 arch/x86/lib/hweight.S                             |    6 +-
 arch/x86/lib/inat.c                                |    2 +-
 arch/x86/lib/insn-eval.c                           |   40 +-
 arch/x86/lib/insn.c                                |  222 +++-
 arch/x86/lib/iomap_copy_64.S                       |    2 +-
 arch/x86/lib/memcpy_64.S                           |   14 +-
 arch/x86/lib/memmove_64.S                          |   11 +-
 arch/x86/lib/memset_64.S                           |    8 +-
 arch/x86/lib/msr-reg.S                             |    4 +-
 arch/x86/lib/putuser.S                             |    6 +-
 arch/x86/lib/retpoline.S                           |  118 +-
 arch/x86/math-emu/div_Xsig.S                       |    2 +-
 arch/x86/math-emu/div_small.S                      |    2 +-
 arch/x86/math-emu/mul_Xsig.S                       |    6 +-
 arch/x86/math-emu/polynom_Xsig.S                   |    2 +-
 arch/x86/math-emu/reg_norm.S                       |    6 +-
 arch/x86/math-emu/reg_round.S                      |    2 +-
 arch/x86/math-emu/reg_u_add.S                      |    2 +-
 arch/x86/math-emu/reg_u_div.S                      |    2 +-
 arch/x86/math-emu/reg_u_mul.S                      |    2 +-
 arch/x86/math-emu/reg_u_sub.S                      |    2 +-
 arch/x86/math-emu/round_Xsig.S                     |    4 +-
 arch/x86/math-emu/shr_Xsig.S                       |    8 +-
 arch/x86/math-emu/wm_shrx.S                        |   16 +-
 arch/x86/mm/mem_encrypt_boot.S                     |    6 +
 arch/x86/net/bpf_jit_comp.c                        |  185 ++--
 arch/x86/net/bpf_jit_comp32.c                      |   22 +-
 arch/x86/platform/efi/efi_stub_32.S                |    2 +-
 arch/x86/platform/efi/efi_stub_64.S                |    2 +-
 arch/x86/platform/efi/efi_thunk_64.S               |    5 +-
 arch/x86/platform/olpc/xo1-wakeup.S                |    6 +-
 arch/x86/power/hibernate_asm_32.S                  |    4 +-
 arch/x86/power/hibernate_asm_64.S                  |    4 +-
 arch/x86/um/checksum_32.S                          |    4 +-
 arch/x86/um/setjmp_32.S                            |    2 +-
 arch/x86/um/setjmp_64.S                            |    2 +-
 arch/x86/xen/Makefile                              |    1 -
 arch/x86/xen/setup.c                               |    6 +-
 arch/x86/xen/xen-asm.S                             |   43 +-
 arch/x86/xen/xen-head.S                            |    6 +-
 arch/x86/xen/xen-ops.h                             |    6 +-
 drivers/base/cpu.c                                 |    8 +
 drivers/idle/intel_idle.c                          |   43 +-
 include/linux/cpu.h                                |    2 +
 include/linux/kvm_host.h                           |    2 +-
 include/linux/objtool.h                            |   14 +-
 samples/ftrace/ftrace-direct-modify.c              |    4 +-
 samples/ftrace/ftrace-direct-too.c                 |    2 +-
 samples/ftrace/ftrace-direct.c                     |    2 +-
 scripts/Makefile.build                             |    6 +
 scripts/link-vmlinux.sh                            |    6 +
 security/Kconfig                                   |   11 -
 tools/arch/x86/include/asm/cpufeatures.h           |   12 +-
 tools/arch/x86/include/asm/disabled-features.h     |   21 +-
 tools/arch/x86/include/asm/inat.h                  |    2 +-
 tools/arch/x86/include/asm/insn.h                  |   28 +-
 tools/arch/x86/include/asm/msr-index.h             |   13 +
 tools/arch/x86/lib/inat.c                          |    2 +-
 tools/arch/x86/lib/insn.c                          |  222 +++-
 tools/arch/x86/lib/memcpy_64.S                     |   14 +-
 tools/arch/x86/lib/memset_64.S                     |    8 +-
 .../asm/{alternative-asm.h => alternative.h}       |    0
 tools/include/linux/kconfig.h                      |   67 ++
 tools/include/linux/objtool.h                      |   14 +-
 tools/objtool/Documentation/stack-validation.txt   |   16 +-
 tools/objtool/Makefile                             |    4 -
 tools/objtool/arch.h                               |   13 +-
 tools/objtool/arch/x86/decode.c                    |   58 +-
 tools/objtool/arch/x86/include/arch_special.h      |    2 +-
 tools/objtool/builtin-check.c                      |    6 +-
 tools/objtool/builtin-orc.c                        |    6 +-
 tools/objtool/builtin.h                            |    3 +-
 tools/objtool/cfi.h                                |    2 +
 tools/objtool/check.c                              | 1140 +++++++++++++++-----
 tools/objtool/check.h                              |   35 +-
 tools/objtool/elf.c                                |  435 ++++++--
 tools/objtool/elf.h                                |   22 +-
 tools/objtool/objtool.c                            |    2 +
 tools/objtool/objtool.h                            |    5 +-
 tools/objtool/orc_gen.c                            |  324 +++---
 tools/objtool/special.c                            |   22 +-
 tools/objtool/sync-check.sh                        |   17 +-
 tools/objtool/weak.c                               |    7 +-
 tools/perf/check-headers.sh                        |   15 +-
 208 files changed, 4602 insertions(+), 1926 deletions(-)


