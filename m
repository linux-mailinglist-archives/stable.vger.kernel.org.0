Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE5F57FC6D
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiGYJbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 05:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiGYJbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 05:31:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D316597;
        Mon, 25 Jul 2022 02:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784FE61284;
        Mon, 25 Jul 2022 09:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18540C341C6;
        Mon, 25 Jul 2022 09:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658741472;
        bh=0fgNWOlGqMTrbFTRi/jfq/KnmNj0kCwePI3BlMPOBH4=;
        h=From:To:Cc:Subject:Date:From;
        b=F1i4Ac/CXBlJNTadrq5vjU57o4DsMmpqVAmRwv160h2MlYmvNaREZB8KCFELEymup
         yz4OVUAuXHOksWowEDfNvLQE9Jx49dfV/8y8pB6BGffGu0ElBB33bnKH0YjkdzHYGr
         1KuZERRqrZvRoCWuFZBmOhptnMjYDnkt8dCTYQcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.133
Date:   Mon, 25 Jul 2022 11:31:07 +0200
Message-Id: <1658741467159176@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.133 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt  |   25 
 Makefile                                         |   23 
 arch/um/kernel/um_arch.c                         |    8 
 arch/x86/Kconfig                                 |   91 +
 arch/x86/Makefile                                |    8 
 arch/x86/boot/compressed/efi_thunk_64.S          |    2 
 arch/x86/boot/compressed/head_64.S               |    4 
 arch/x86/boot/compressed/mem_encrypt.S           |    4 
 arch/x86/crypto/aegis128-aesni-asm.S             |   48 
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S          |    2 
 arch/x86/crypto/aesni-intel_asm.S                |   52 -
 arch/x86/crypto/aesni-intel_avx-x86_64.S         |   40 
 arch/x86/crypto/blake2s-core.S                   |    4 
 arch/x86/crypto/blowfish-x86_64-asm_64.S         |   12 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S      |   18 
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S     |   18 
 arch/x86/crypto/camellia-x86_64-asm_64.S         |   12 
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S        |   12 
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S        |   16 
 arch/x86/crypto/chacha-avx2-x86_64.S             |    6 
 arch/x86/crypto/chacha-avx512vl-x86_64.S         |    6 
 arch/x86/crypto/chacha-ssse3-x86_64.S            |    8 
 arch/x86/crypto/crc32-pclmul_asm.S               |    2 
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S        |    2 
 arch/x86/crypto/crct10dif-pcl-asm_64.S           |    2 
 arch/x86/crypto/des3_ede-asm_64.S                |    4 
 arch/x86/crypto/ghash-clmulni-intel_asm.S        |    6 
 arch/x86/crypto/nh-avx2-x86_64.S                 |    2 
 arch/x86/crypto/nh-sse2-x86_64.S                 |    2 
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl    |   38 
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S      |   16 
 arch/x86/crypto/serpent-avx2-asm_64.S            |   16 
 arch/x86/crypto/serpent-sse2-i586-asm_32.S       |    6 
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S     |    6 
 arch/x86/crypto/sha1_avx2_x86_64_asm.S           |    2 
 arch/x86/crypto/sha1_ni_asm.S                    |    2 
 arch/x86/crypto/sha1_ssse3_asm.S                 |    2 
 arch/x86/crypto/sha256-avx-asm.S                 |    2 
 arch/x86/crypto/sha256-avx2-asm.S                |    2 
 arch/x86/crypto/sha256-ssse3-asm.S               |    2 
 arch/x86/crypto/sha256_ni_asm.S                  |    2 
 arch/x86/crypto/sha512-avx-asm.S                 |    2 
 arch/x86/crypto/sha512-avx2-asm.S                |    2 
 arch/x86/crypto/sha512-ssse3-asm.S               |    2 
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S      |   16 
 arch/x86/crypto/twofish-i586-asm_32.S            |    4 
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S     |    6 
 arch/x86/crypto/twofish-x86_64-asm_64.S          |    4 
 arch/x86/entry/Makefile                          |    2 
 arch/x86/entry/calling.h                         |   72 +
 arch/x86/entry/entry.S                           |   22 
 arch/x86/entry/entry_32.S                        |    6 
 arch/x86/entry/entry_64.S                        |   62 +
 arch/x86/entry/entry_64_compat.S                 |   21 
 arch/x86/entry/thunk_32.S                        |    2 
 arch/x86/entry/thunk_64.S                        |    2 
 arch/x86/entry/vdso/Makefile                     |    1 
 arch/x86/entry/vdso/vdso32/system_call.S         |    4 
 arch/x86/entry/vsyscall/vsyscall_emu_64.S        |    3 
 arch/x86/include/asm/GEN-for-each-reg.h          |   14 
 arch/x86/include/asm/alternative-asm.h           |  114 --
 arch/x86/include/asm/alternative.h               |  137 ++
 arch/x86/include/asm/asm-prototypes.h            |   17 
 arch/x86/include/asm/cpufeature.h                |   41 
 arch/x86/include/asm/cpufeatures.h               |   14 
 arch/x86/include/asm/disabled-features.h         |   21 
 arch/x86/include/asm/inat.h                      |    2 
 arch/x86/include/asm/insn-eval.h                 |    4 
 arch/x86/include/asm/insn.h                      |   28 
 arch/x86/include/asm/linkage.h                   |   22 
 arch/x86/include/asm/msr-index.h                 |   13 
 arch/x86/include/asm/nospec-branch.h             |  141 +-
 arch/x86/include/asm/paravirt.h                  |    2 
 arch/x86/include/asm/qspinlock_paravirt.h        |    4 
 arch/x86/include/asm/smap.h                      |    5 
 arch/x86/include/asm/static_call.h               |   19 
 arch/x86/include/asm/unwind_hints.h              |   23 
 arch/x86/kernel/acpi/wakeup_32.S                 |    6 
 arch/x86/kernel/alternative.c                    |  406 +++++++-
 arch/x86/kernel/cpu/amd.c                        |   46 
 arch/x86/kernel/cpu/bugs.c                       |  475 ++++++++-
 arch/x86/kernel/cpu/common.c                     |   61 -
 arch/x86/kernel/cpu/cpu.h                        |    2 
 arch/x86/kernel/cpu/hygon.c                      |    6 
 arch/x86/kernel/cpu/scattered.c                  |    1 
 arch/x86/kernel/ftrace.c                         |    7 
 arch/x86/kernel/ftrace_32.S                      |    6 
 arch/x86/kernel/ftrace_64.S                      |   13 
 arch/x86/kernel/head_32.S                        |    3 
 arch/x86/kernel/head_64.S                        |    5 
 arch/x86/kernel/irqflags.S                       |    4 
 arch/x86/kernel/kprobes/core.c                   |    2 
 arch/x86/kernel/kvm.c                            |    2 
 arch/x86/kernel/module.c                         |   15 
 arch/x86/kernel/paravirt.c                       |    2 
 arch/x86/kernel/process.c                        |    2 
 arch/x86/kernel/relocate_kernel_32.S             |   15 
 arch/x86/kernel/relocate_kernel_64.S             |   13 
 arch/x86/kernel/sev-es.c                         |    2 
 arch/x86/kernel/sev_verify_cbit.S                |    2 
 arch/x86/kernel/static_call.c                    |   52 -
 arch/x86/kernel/umip.c                           |    2 
 arch/x86/kernel/verify_cpu.S                     |    4 
 arch/x86/kernel/vmlinux.lds.S                    |   23 
 arch/x86/kvm/emulate.c                           |   39 
 arch/x86/kvm/svm/vmenter.S                       |   11 
 arch/x86/kvm/vmx/nested.c                        |   32 
 arch/x86/kvm/vmx/run_flags.h                     |    8 
 arch/x86/kvm/vmx/vmenter.S                       |  170 +--
 arch/x86/kvm/vmx/vmx.c                           |   78 +
 arch/x86/kvm/vmx/vmx.h                           |    5 
 arch/x86/kvm/x86.c                               |    4 
 arch/x86/lib/atomic64_386_32.S                   |   88 -
 arch/x86/lib/atomic64_cx8_32.S                   |   18 
 arch/x86/lib/checksum_32.S                       |    8 
 arch/x86/lib/clear_page_64.S                     |    6 
 arch/x86/lib/cmpxchg16b_emu.S                    |    4 
 arch/x86/lib/cmpxchg8b_emu.S                     |    4 
 arch/x86/lib/copy_mc_64.S                        |    6 
 arch/x86/lib/copy_page_64.S                      |    6 
 arch/x86/lib/copy_user_64.S                      |   14 
 arch/x86/lib/csum-copy_64.S                      |    2 
 arch/x86/lib/error-inject.c                      |    3 
 arch/x86/lib/getuser.S                           |   22 
 arch/x86/lib/hweight.S                           |    6 
 arch/x86/lib/inat.c                              |    2 
 arch/x86/lib/insn-eval.c                         |   40 
 arch/x86/lib/insn.c                              |  222 +++-
 arch/x86/lib/iomap_copy_64.S                     |    2 
 arch/x86/lib/memcpy_64.S                         |   14 
 arch/x86/lib/memmove_64.S                        |   11 
 arch/x86/lib/memset_64.S                         |    8 
 arch/x86/lib/msr-reg.S                           |    4 
 arch/x86/lib/putuser.S                           |    6 
 arch/x86/lib/retpoline.S                         |  118 +-
 arch/x86/math-emu/div_Xsig.S                     |    2 
 arch/x86/math-emu/div_small.S                    |    2 
 arch/x86/math-emu/mul_Xsig.S                     |    6 
 arch/x86/math-emu/polynom_Xsig.S                 |    2 
 arch/x86/math-emu/reg_norm.S                     |    6 
 arch/x86/math-emu/reg_round.S                    |    2 
 arch/x86/math-emu/reg_u_add.S                    |    2 
 arch/x86/math-emu/reg_u_div.S                    |    2 
 arch/x86/math-emu/reg_u_mul.S                    |    2 
 arch/x86/math-emu/reg_u_sub.S                    |    2 
 arch/x86/math-emu/round_Xsig.S                   |    4 
 arch/x86/math-emu/shr_Xsig.S                     |    8 
 arch/x86/math-emu/wm_shrx.S                      |   16 
 arch/x86/mm/mem_encrypt_boot.S                   |    6 
 arch/x86/net/bpf_jit_comp.c                      |  185 +--
 arch/x86/net/bpf_jit_comp32.c                    |   22 
 arch/x86/platform/efi/efi_stub_32.S              |    2 
 arch/x86/platform/efi/efi_stub_64.S              |    2 
 arch/x86/platform/efi/efi_thunk_64.S             |    5 
 arch/x86/platform/olpc/xo1-wakeup.S              |    6 
 arch/x86/power/hibernate_asm_32.S                |    4 
 arch/x86/power/hibernate_asm_64.S                |    4 
 arch/x86/um/checksum_32.S                        |    4 
 arch/x86/um/setjmp_32.S                          |    2 
 arch/x86/um/setjmp_64.S                          |    2 
 arch/x86/xen/Makefile                            |    1 
 arch/x86/xen/setup.c                             |    6 
 arch/x86/xen/xen-asm.S                           |   43 
 arch/x86/xen/xen-head.S                          |    6 
 arch/x86/xen/xen-ops.h                           |    6 
 drivers/base/cpu.c                               |    8 
 drivers/idle/intel_idle.c                        |   43 
 include/linux/cpu.h                              |    2 
 include/linux/kvm_host.h                         |    2 
 include/linux/objtool.h                          |   14 
 samples/ftrace/ftrace-direct-modify.c            |    4 
 samples/ftrace/ftrace-direct-too.c               |    2 
 samples/ftrace/ftrace-direct.c                   |    2 
 scripts/Makefile.build                           |    6 
 scripts/link-vmlinux.sh                          |    6 
 security/Kconfig                                 |   11 
 tools/arch/x86/include/asm/cpufeatures.h         |   12 
 tools/arch/x86/include/asm/disabled-features.h   |   21 
 tools/arch/x86/include/asm/inat.h                |    2 
 tools/arch/x86/include/asm/insn.h                |   28 
 tools/arch/x86/include/asm/msr-index.h           |   13 
 tools/arch/x86/lib/inat.c                        |    2 
 tools/arch/x86/lib/insn.c                        |  222 +++-
 tools/arch/x86/lib/memcpy_64.S                   |   14 
 tools/arch/x86/lib/memset_64.S                   |    8 
 tools/include/asm/alternative-asm.h              |   10 
 tools/include/asm/alternative.h                  |   10 
 tools/include/linux/kconfig.h                    |   67 +
 tools/include/linux/objtool.h                    |   14 
 tools/objtool/Documentation/stack-validation.txt |   16 
 tools/objtool/Makefile                           |    4 
 tools/objtool/arch.h                             |   13 
 tools/objtool/arch/x86/decode.c                  |   58 -
 tools/objtool/arch/x86/include/arch_special.h    |    2 
 tools/objtool/builtin-check.c                    |    6 
 tools/objtool/builtin-orc.c                      |    6 
 tools/objtool/builtin.h                          |    3 
 tools/objtool/cfi.h                              |    2 
 tools/objtool/check.c                            | 1140 +++++++++++++++++------
 tools/objtool/check.h                            |   35 
 tools/objtool/elf.c                              |  435 +++++++-
 tools/objtool/elf.h                              |   22 
 tools/objtool/objtool.c                          |    2 
 tools/objtool/objtool.h                          |    5 
 tools/objtool/orc_gen.c                          |  324 +++---
 tools/objtool/special.c                          |   22 
 tools/objtool/sync-check.sh                      |   17 
 tools/objtool/weak.c                             |    7 
 tools/perf/check-headers.sh                      |   15 
 209 files changed, 4611 insertions(+), 1935 deletions(-)

Alexandre Chartre (2):
      x86/bugs: Report AMD retbleed vulnerability
      x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
      x86/cpu/amd: Enumerate BTC_NO

Arnaldo Carvalho de Melo (5):
      tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy'
      tools arch x86: Sync the msr-index.h copy with the kernel sources
      tools headers cpufeatures: Sync with the kernel sources
      tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy' - again
      tools headers: Remove broken definition of __LITTLE_ENDIAN

Ben Hutchings (3):
      x86: Add insn_decode_kernel()
      Makefile: Set retpoline cflags based on CONFIG_CC_IS_{CLANG,GCC}
      x86/xen: Fix initialisation in hypercall_page after rethunk

Borislav Petkov (8):
      x86/insn: Rename insn_decode() to insn_decode_from_regs()
      x86/insn: Add a __ignore_sync_check__ marker
      x86/insn: Add an insn_decode() API
      x86/insn-eval: Handle return values from the decoder
      x86/alternative: Use insn_decode()
      x86/alternative: Optimize single-byte NOPs at an arbitrary position
      kvm/emulate: Fix SETcc emulation function offsets with SLS
      tools/insn: Restore the relative include paths for cross building

Greg Kroah-Hartman (2):
      x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted
      Linux 5.10.133

Jiri Slaby (1):
      x86/asm/32: Fix ANNOTATE_UNRET_SAFE use on 32-bit

Joe Lawrence (1):
      objtool: Make .altinstructions section entry size consistent

Josh Poimboeuf (24):
      objtool: Refactor ORC section generation
      objtool: Add 'alt_group' struct
      objtool: Support stack layout changes in alternatives
      objtool: Support retpoline jump detection for vmlinux.o
      objtool: Assume only ELF functions do sibling calls
      objtool: Combine UNWIND_HINT_RET_OFFSET and UNWIND_HINT_FUNC
      x86/xen: Support objtool validation in xen-asm.S
      x86/xen: Support objtool vmlinux.o validation in xen-head.S
      objtool: Support asm jump tables
      objtool: Don't make .altinstructions writable
      objtool: Remove reloc symbol type checks in get_alt_entry()
      x86/bugs: Do IBPB fallback check only once
      x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
      x86/speculation: Fix firmware entry SPEC_CTRL handling
      x86/speculation: Fix SPEC_CTRL write on SMT state change
      x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
      x86/speculation: Remove x86_spec_ctrl_mask
      objtool: Re-add UNWIND_HINT_{SAVE_RESTORE}
      KVM: VMX: Flatten __vmx_vcpu_run()
      KVM: VMX: Convert launched argument to flags
      KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
      KVM: VMX: Fix IBRS handling after vmexit
      x86/speculation: Fill RSB on vmexit for IBRS
      x86/ftrace: Add UNWIND_HINT_FUNC annotation for ftrace_stub

Juergen Gross (4):
      x86/alternative: Merge include files
      x86/alternative: Support not-feature
      x86/alternative: Support ALTERNATIVE_TERNARY
      x86/alternative: Use ALTERNATIVE_TERNARY() in _static_cpu_has()

Kim Phillips (3):
      x86/sev: Avoid using __x86_return_thunk
      x86/bugs: Enable STIBP for JMP2RET
      x86/bugs: Remove apostrophe typo

Konrad Rzeszutek Wilk (1):
      x86/kexec: Disable RET on kexec

Linus Torvalds (2):
      objtool: print out the symbol type when complaining about it
      kvm: fix objtool relocation warning

Mikulas Patocka (1):
      objtool: Fix objtool regression on x32 systems

Nathan Chancellor (1):
      x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Paolo Bonzini (1):
      KVM: emulate: do not adjust size of fastop and setcc subroutines

Pawan Gupta (3):
      x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
      x86/bugs: Add Cannon lake to RETBleed affected CPU list
      x86/speculation: Disable RRSBA behavior

Peter Zijlstra (77):
      x86/alternatives: Optimize optimize_nops()
      x86/retpoline: Simplify retpolines
      objtool: Correctly handle retpoline thunk calls
      objtool: Handle per arch retpoline naming
      objtool: Rework the elf_rebuild_reloc_section() logic
      objtool: Add elf_create_reloc() helper
      objtool: Create reloc sections implicitly
      objtool: Extract elf_strtab_concat()
      objtool: Extract elf_symbol_add()
      objtool: Add elf_create_undef_symbol()
      objtool: Keep track of retpoline call sites
      objtool: Cache instruction relocs
      objtool: Skip magical retpoline .altinstr_replacement
      objtool/x86: Rewrite retpoline thunk calls
      objtool: Fix .symtab_shndx handling for elf_create_undef_symbol()
      objtool: Only rewrite unconditional retpoline thunk calls
      objtool/x86: Ignore __x86_indirect_alt_* symbols
      objtool: Teach get_alt_entry() about more relocation types
      objtool: Introduce CFI hash
      objtool: Handle __sanitize_cov*() tail calls
      objtool: Classify symbols
      objtool: Explicitly avoid self modifying code in .altinstr_replacement
      objtool,x86: Replace alternatives with .retpoline_sites
      x86/retpoline: Remove unused replacement symbols
      x86/asm: Fix register order
      x86/asm: Fixup odd GEN-for-each-reg.h usage
      x86/retpoline: Move the retpoline thunk declarations to nospec-branch.h
      x86/retpoline: Create a retpoline thunk array
      x86/alternative: Implement .retpoline_sites support
      x86/alternative: Handle Jcc __x86_indirect_thunk_\reg
      x86/alternative: Try inline spectre_v2=retpoline,amd
      x86/alternative: Add debug prints to apply_retpolines()
      bpf,x86: Simplify computing label offsets
      bpf,x86: Respect X86_FEATURE_RETPOLINE*
      x86/lib/atomic64_386_32: Rename things
      x86: Prepare asm files for straight-line-speculation
      x86: Prepare inline-asm for straight-line-speculation
      x86/alternative: Relax text_poke_bp() constraint
      objtool: Add straight-line-speculation validation
      x86: Add straight-line-speculation mitigation
      objtool: Default ignore INT3 for unreachable
      crypto: x86/poly1305 - Fixup SLS
      objtool: Fix SLS validation for kcov tail-call replacement
      objtool: Fix code relocs vs weak symbols
      objtool: Fix type of reloc::addend
      objtool: Fix symbol creation
      x86/entry: Remove skip_r11rcx
      x86/kvm/vmx: Make noinstr clean
      x86/cpufeatures: Move RETPOLINE flags to word 11
      x86/retpoline: Cleanup some #ifdefery
      x86/retpoline: Swizzle retpoline thunk
      x86/retpoline: Use -mfunction-return
      x86: Undo return-thunk damage
      x86,objtool: Create .return_sites
      x86,static_call: Use alternative RET encoding
      x86/ftrace: Use alternative RET encoding
      x86/bpf: Use alternative RET encoding
      x86/kvm: Fix SETcc emulation for return thunks
      x86/vsyscall_emu/64: Don't use RET in vsyscall emulation
      x86: Use return-thunk in asm code
      objtool: Treat .text.__x86.* as noinstr
      x86: Add magic AMD return-thunk
      x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
      x86/entry: Add kernel IBRS implementation
      x86/bugs: Optimize SPEC_CTRL MSR writes
      x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
      x86/bugs: Report Intel retbleed vulnerability
      intel_idle: Disable IBRS during long idle
      objtool: Update Retpoline validation
      x86/xen: Rename SYS* entry points
      x86/bugs: Add retbleed=ibpb
      objtool: Add entry UNRET validation
      x86/cpu/amd: Add Spectral Chicken
      x86/common: Stamp out the stepping madness
      x86/retbleed: Add fine grained Kconfig knobs
      um: Add missing apply_returns()
      x86: Use -mindirect-branch-cs-prefix for RETPOLINE builds

Thadeu Lima de Souza Cascardo (5):
      x86/realmode: build with -D__DISABLE_EXPORTS
      objtool: skip non-text sections when adding return-thunk sites
      x86/bugs: Do not enable IBPB-on-entry when IBPB is not supported
      efi/x86: use naked RET on mixed mode call wrapper
      x86/kvm: fix FASTOP_SIZE when return thunks are enabled

Thomas Gleixner (1):
      x86/static_call: Serialize __static_call_fixup() properly

Uros Bizjak (2):
      KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S
      KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw

Vasily Gorbik (1):
      objtool: Fix elf_create_undef_symbol() endianness

