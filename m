Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A220C65
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfEPP6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42344 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yf-Uo; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001MN-95; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.52852998@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/86] 3.16.68-rc1 review
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.68 release.
There are 86 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon May 20 10:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Andi Kleen (4):
      x86/cpu/bugs: Use __initconst for 'const' init data
         [1de7edbb59c8f1b46071f66c5c97b8a59569eb51]
      x86/headers: Don't include asm/processor.h in asm/atomic.h
         [153a4334c439cfb62e1d31cee0c790ba4157813d]
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
         [6c4dbbd14730c43f4ed808a9c42ca41625925c22]
      x86/speculation/mds: Add basic bug infrastructure for MDS
         [ed5194c2732c8084af9fd159c146ea92bf137128]

Andy Lutomirski (2):
      x86/asm: Add asm macros for static keys/jump labels
         [2671c3e4fe2a34bd9bf2eecdf5d1149d4b55dbdf]
      x86/asm: Error out if asm/jump_label.h is included inappropriately
         [c28454332fe0b65e22c3a2717e5bf05b5b47ca20]

Anton Blanchard (2):
      jump_label: Allow asm/jump_label.h to be included in assembly
         [55dd0df781e58ec23d218376ea4a676e7362a98c]
      jump_label: Allow jump labels to be used in assembly
         [c0ccf6f99e3a43b87980c9df7da48427885206d0]

Ben Hutchings (3):
      sched: Add sched_smt_active()
         [1b568f0aabf280555125bc7cefc08321ff0ebaba]
      x86/bugs: Change L1TF mitigation string to match upstream
         [72c6d2db64fa18c996ece8f06e499509e6c9a37e]
      x86/speculation/l1tf: Document l1tf in sysfs
         [d90a7a0ec83fb86622cd7dae23255d3c50a99ec8]

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment
         [cae5ec342645746d617dd420d206e1588d47768a]

Borislav Petkov (2):
      x86/cpufeature: Add bug flags to /proc/cpuinfo
         [80a208bd3948aceddf0429bd9f9b4cd858d526df]
      x86/cpufeature: Carve out X86_FEATURE_*
         [cd4d09ec6f6c12a2cc3db5b7d8876a325a53545b]

Dominik Brodowski (1):
      x86/speculation: Simplify the CPU bug detection logic
         [8ecc4979b1bd9c94168e6fc92960033b7a951336]

Eduardo Habkost (1):
      kvm: x86: Report STIBP on GET_SUPPORTED_CPUID
         [d7b09c827a6cf291f66637a36f46928dd1423184]

Heiko Carstens (2):
      s390/jump label: add sanity checks
         [5c6497c50f8d809eac6d01512c291a1f67382abd]
      s390/jump label: use different nop instruction
         [d5caa4dbf9bd2ad8cd7f6be0ca76722be947182b]

Ingo Molnar (1):
      jump_label: Fix small typos in the documentation
         [fd3cbdc0d1b5254a2e8793df58c409b469899a3f]

Jason Baron (1):
      jump label, locking/static_keys: Update docs
         [412758cb26704e5087ca2976ec3b28fb2bdbfad4]

Jiang Biao (1):
      x86/speculation: Remove SPECTRE_V2_IBRS in enum spectre_v2_mitigation
         [d9f4426c73002957be5dd39936f44a09498f7560]

Jiri Kosina (3):
      x86/speculation: Apply IBPB more strictly to avoid cross-process data leak
         [dbfe2953f63c640463c630746cd5d9de8b2f63ae]
      x86/speculation: Enable cross-hyperthread spectre v2 STIBP mitigation
         [53c613fe6349994f023245519265999eed75957f]
      x86/speculation: Propagate information about RSB filling mitigation to sysfs
         [bb4b3b7762735cdaba5a40fd94c9303d9ffa147a]

Jonathan Corbet (2):
      locking/static_keys: Fix a silly typo
         [edcd591c77a48da753456f92daf8bb50fe9bac93]
      locking/static_keys: Fix up the static keys documentation
         [1975dbc276c6ab62230cf4f9df5ddc9ff0e0e473]

Josh Poimboeuf (6):
      cpu/speculation: Add 'mitigations=' cmdline option
         [98af8452945c55652de68536afdde3b520fec429]
      x86/speculation/mds: Add 'mitigations=' support for MDS
         [5c14068f87d04adc73ba3f41c2a303d3c3d1fa12]
      x86/speculation/mds: Add SMT warning message
         [39226ef02bfb43248b7db12a4fdccb39d95318e3]
      x86/speculation/mds: Fix documentation typo
         [95310e348a321b45fb746c176961d4da72344282]
      x86/speculation: Move arch_smt_update() call to after mitigation decisions
         [7c3658b20194a5b3209a143f63bc9c643c6a3ae2]
      x86/speculation: Support 'mitigations=' cmdline option
         [d68be4c4d31295ff6ae34a8ddfaa4c1a8ff42812]

Konrad Rzeszutek Wilk (1):
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations off
         [e2c3c94788b08891dcf3dbe608f9880523ecd71b]

Maciej W. Rozycki (2):
      MIPS: jump_label.c: Correct the span of the J instruction
         [99436f7d69045800ffd1d66912f85d37150c7e2b]
      MIPS: jump_label.c: Handle the microMIPS J instruction encoding
         [935c2dbec4d6d3163ee8e7409996904a734ad89a]

Paolo Bonzini (1):
      locking/static_key: Fix concurrent static_key_slow_inc()
         [4c5ea0a9cd02d6aa8adc86e100b2a4cff8d614ff]

Peter Zijlstra (8):
      jump_label, locking/static_keys: Rename JUMP_LABEL_TYPE_* and related helpers to the static_key* pattern
         [a1efb01feca597b2abbc89873b40ef8ec6690168]
      jump_label/x86: Work around asm build bug on older/backported GCCs
         [d420acd816c07c7be31bd19d09cbcb16e5572fa6]
      jump_label: Add jump_entry_key() helper
         [7dcfd915bae51571bcc339d8e3dda027287880e5]
      jump_label: Rename JUMP_LABEL_{EN,DIS}ABLE to JUMP_LABEL_{JMP,NOP}
         [76b235c6bcb16062d663e2ee96db0b69f2e6bc14]
      locking/static_keys: Add a new static_key interface
         [11276d5306b8e5b438a36bbff855fe792d7eaa61]
      locking/static_keys: Rework update logic
         [706249c222f68471b6f8e9e8e9b77665c404b226]
      module, jump_label: Fix module locking
         [bed831f9a251968272dae10a83b512c7db256ef0]
      x86/cpu: Sanitize FAM6_ATOM naming
         [f2c4db1bd80720cd8cb2a5aa220d9bc9f374f04e]

Petr Mladek (1):
      module: add within_module() function
         [9b20a352d78a7651aa68a9220f77ccb03009d892]

Sai Praneeth (1):
      x86/speculation: Support Enhanced IBRS on future CPUs
         [706d51681d636a0c4a5ef53395ec3b803e45ed4d]

Tejun Heo (1):
      jump_label: make static_key_enabled() work on static_key_true/false types too
         [fa128fd735bd236b6b04d3fedfed7a784137c185]

Thomas Gleixner (29):
      Documentation: Add MDS vulnerability documentation
         [5999bbe7a6ea3c62029532ec84dc06003a1fa258]
      Documentation: Move L1TF to separate directory
         [65fd4cb65b2dad97feb8330b6690445910b56d6a]
      x86/Kconfig: Select SCHED_SMT if SMP enabled
         [dbe733642e01dd108f71436aaea7b328cb28fd87]
      x86/msr-index: Cleanup bit defines
         [d8eabc37310a92df40d07c5a8afc53cebf996716]
      x86/process: Consolidate and simplify switch_to_xtra() code
         [ff16701a29cba3aafa0bd1656d766813b2d0a811]
      x86/speculataion: Mark command line parser data __initdata
         [30ba72a990f5096ae08f284de17986461efcc408]
      x86/speculation/mds: Add BUG_MSBDS_ONLY
         [e261f209c3666e842fd645a1e31f001c3a26def9]
      x86/speculation/mds: Add mds_clear_cpu_buffers()
         [6a9e529272517755904b7afa639f6db59ddb793e]
      x86/speculation/mds: Add mitigation control for MDS
         [bc1241700acd82ec69fde98c5763ce51086269f8]
      x86/speculation/mds: Add mitigation mode VMWERV
         [22dd8365088b6403630b82423cf906491859b65e]
      x86/speculation/mds: Add sysfs reporting for MDS
         [8a4b06d391b0a42a373808979b5028f5c84d9c6a]
      x86/speculation/mds: Clear CPU buffers on exit to user
         [04dcbdb8057827b043b3c71aa397c4c63e67d086]
      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
         [07f07f55a29cb705e221eda7894dd67ab81ef343]
      x86/speculation: Add command line control for indirect branch speculation
         [fa1202ef224391b6f5b26cdd44cc50495e8fab54]
      x86/speculation: Add prctl() control for indirect branch speculation
         [9137bb27e60e554dab694eafa4cca241fa3a694f]
      x86/speculation: Add seccomp Spectre v2 user space protection mode
         [6b3e64c237c072797a9ec918654a60e3a46488e2]
      x86/speculation: Avoid __switch_to_xtra() calls
         [5635d99953f04b550738f6f4c1c532667c3fd872]
      x86/speculation: Consolidate CPU whitelists
         [36ad35131adacc29b328b9c8b6277a8bf0d6fd5d]
      x86/speculation: Enable prctl mode for spectre_v2_user
         [7cc765a67d8e04ef7d772425ca5a2a1e2b894c15]
      x86/speculation: Mark string arrays const correctly
         [8770709f411763884535662744a3786a1806afd3]
      x86/speculation: Prepare arch_smt_update() for PRCTL mode
         [6893a959d7fdebbab5f5aa112c277d5a44435ba1]
      x86/speculation: Prepare for conditional IBPB in switch_mm()
         [4c71a2b6fd7e42814aa68a6dec88abf3b42ea573]
      x86/speculation: Prevent stale SPEC_CTRL msr content
         [6d991ba509ebcfcc908e009d1db51972a4f7a064]
      x86/speculation: Provide IBPB always command line options
         [55a974021ec952ee460dc31ca08722158639de72]
      x86/speculation: Rename SSBD update functions
         [26c4d75b234040c11728a8acb796b3a85ba7507c]
      x86/speculation: Reorder the spec_v2 code
         [15d6b7aab0793b2de8a05d8a828777dd24db424e]
      x86/speculation: Rework SMT state change
         [a74cfffb03b73d41e08f84c2e5c87dec0ce3db9f]
      x86/speculation: Split out TIF update
         [e6da8bb6f9abb2628381904b24163c770e630bac]
      x86/speculation: Unify conditional spectre v2 print functions
         [495d470e9828500e0155027f230449ac5e29c025]

Tim Chen (7):
      x86/speculation: Clean up spectre_v2_parse_cmdline()
         [24848509aa55eac39d524b587b051f4e86df3c12]
      x86/speculation: Disable STIBP when enhanced IBRS is in use
         [34bce7c9690b1d897686aac89604ba7adc365556]
      x86/speculation: Move STIPB/IBPB string conditionals out of cpu_show_common()
         [a8f76ae41cd633ac00be1b3019b1eb4741be3828]
      x86/speculation: Prepare for per task indirect branch speculation control
         [5bfbe3ad5840d941b89bcac54b821ba14f50a0ba]
      x86/speculation: Remove unnecessary ret variable in cpu_show_common()
         [b86bda0426853bfe8a3506c7d2a5b332760ae46b]
      x86/speculation: Reorganize speculation control MSRs update
         [01daf56875ee0cd50ed496a09b20eb369b45dfa5]
      x86/speculation: Update the TIF_SSBD comment
         [8eb729b77faf83ac4c1f363a9ad68d042415f24c]

Tony Luck (1):
      locking/static_keys: Provide DECLARE and well as DEFINE macros
         [b8fb03785d4de097507d0cf45873525e0ac4d2b2]

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values
         [ea01668f9f43021b28b3f4d5ffad50106a1e1301]

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation
         [e672f8bf71c66253197e503f75c771dd28ada4a0]

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/mds.rst                      | 305 ++++++++++
 Documentation/kernel-parameters.txt                | 106 +++-
 Documentation/spec_ctrl.rst                        |   9 +
 Documentation/static-keys.txt                      |  99 ++--
 Documentation/x86/mds.rst                          | 225 ++++++++
 Makefile                                           |   5 +-
 arch/arm/include/asm/jump_label.h                  |  30 +-
 arch/arm/kernel/jump_label.c                       |   2 +-
 arch/arm64/include/asm/jump_label.h                |  24 +-
 arch/arm64/kernel/jump_label.c                     |   2 +-
 arch/mips/include/asm/jump_label.h                 |  32 +-
 arch/mips/kernel/jump_label.c                      |  44 +-
 arch/powerpc/include/asm/jump_label.h              |  19 +-
 arch/powerpc/kernel/jump_label.c                   |   2 +-
 arch/s390/include/asm/jump_label.h                 |  29 +-
 arch/s390/kernel/jump_label.c                      |  65 ++-
 arch/sparc/include/asm/jump_label.h                |  38 +-
 arch/sparc/kernel/jump_label.c                     |   2 +-
 arch/x86/Kconfig                                   |   8 +-
 arch/x86/boot/cpuflags.h                           |   2 +-
 arch/x86/boot/mkcpustr.c                           |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c                |   2 +-
 arch/x86/crypto/crc32c-intel_glue.c                |   2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |   2 +-
 arch/x86/ia32/ia32entry.S                          |   2 +
 arch/x86/include/asm/alternative.h                 |   6 -
 arch/x86/include/asm/apic.h                        |   1 -
 arch/x86/include/asm/arch_hweight.h                |   2 +
 arch/x86/include/asm/atomic.h                      |   1 -
 arch/x86/include/asm/atomic64_32.h                 |   1 -
 arch/x86/include/asm/barrier.h                     |   1 +
 arch/x86/include/asm/cmpxchg.h                     |   1 +
 arch/x86/include/asm/cpufeature.h                  | 278 +--------
 arch/x86/include/asm/cpufeatures.h                 | 278 +++++++++
 arch/x86/include/asm/intel-family.h                |  30 +-
 arch/x86/include/asm/irqflags.h                    |   5 +
 arch/x86/include/asm/jump_label.h                  |  85 ++-
 arch/x86/include/asm/mwait.h                       |   7 +
 arch/x86/include/asm/nospec-branch.h               |  83 ++-
 arch/x86/include/asm/processor.h                   |  10 +-
 arch/x86/include/asm/smap.h                        |   2 +-
 arch/x86/include/asm/smp.h                         |   1 -
 arch/x86/include/asm/spec-ctrl.h                   |  20 +-
 arch/x86/include/asm/switch_to.h                   |   3 -
 arch/x86/include/asm/thread_info.h                 |  28 +-
 arch/x86/include/asm/tlbflush.h                    |   7 +
 arch/x86/include/asm/uaccess_64.h                  |   2 +-
 arch/x86/include/uapi/asm/msr-index.h              |  20 +-
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 629 ++++++++++++++++++---
 arch/x86/kernel/cpu/centaur.c                      |   2 +-
 arch/x86/kernel/cpu/common.c                       | 133 +++--
 arch/x86/kernel/cpu/cyrix.c                        |   1 +
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   2 +-
 arch/x86/kernel/cpu/match.c                        |   2 +-
 arch/x86/kernel/cpu/mkcapflags.sh                  |  51 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |   2 +-
 arch/x86/kernel/cpu/proc.c                         |   8 +
 arch/x86/kernel/cpu/transmeta.c                    |   2 +-
 arch/x86/kernel/e820.c                             |   1 +
 arch/x86/kernel/entry_32.S                         |   4 +-
 arch/x86/kernel/entry_64.S                         |   7 +-
 arch/x86/kernel/head_32.S                          |   2 +-
 arch/x86/kernel/hpet.c                             |   1 +
 arch/x86/kernel/jump_label.c                       |   2 +-
 arch/x86/kernel/msr.c                              |   2 +-
 arch/x86/kernel/nmi.c                              |   4 +
 arch/x86/kernel/process.c                          | 101 +++-
 arch/x86/kernel/process.h                          |  39 ++
 arch/x86/kernel/process_32.c                       |   9 +-
 arch/x86/kernel/process_64.c                       |   9 +-
 arch/x86/kernel/traps.c                            |   9 +
 arch/x86/kernel/verify_cpu.S                       |   2 +-
 arch/x86/kvm/cpuid.c                               |   5 +-
 arch/x86/lib/clear_page_64.S                       |   2 +-
 arch/x86/lib/copy_page_64.S                        |   2 +-
 arch/x86/lib/copy_user_64.S                        |   2 +-
 arch/x86/lib/memcpy_64.S                           |   2 +-
 arch/x86/lib/memmove_64.S                          |   2 +-
 arch/x86/lib/memset_64.S                           |   2 +-
 arch/x86/lib/retpoline.S                           |   2 +-
 arch/x86/mm/kaiser.c                               |   4 +-
 arch/x86/mm/setup_nx.c                             |   1 +
 arch/x86/mm/tlb.c                                  | 102 +++-
 arch/x86/oprofile/op_model_amd.c                   |   1 -
 arch/x86/um/asm/barrier.h                          |   2 +-
 arch/x86/vdso/vdso32-setup.c                       |   1 -
 arch/x86/vdso/vma.c                                |   1 +
 drivers/base/cpu.c                                 |   8 +
 include/linux/cpu.h                                |  19 +
 include/linux/jump_label.h                         | 301 +++++++---
 include/linux/module.h                             |   5 +
 include/linux/ptrace.h                             |  21 +-
 include/linux/sched.h                              |   9 +
 include/linux/sched/smt.h                          |  20 +
 include/uapi/linux/prctl.h                         |   1 +
 kernel/cpu.c                                       |  23 +-
 kernel/jump_label.c                                | 159 ++++--
 kernel/module.c                                    |  12 +-
 kernel/ptrace.c                                    |  10 +
 kernel/sched/core.c                                |  19 +
 kernel/sched/sched.h                               |   1 +
 lib/atomic64_test.c                                |   4 +
 105 files changed, 2873 insertions(+), 830 deletions(-)

-- 
Ben Hutchings
Man invented language to satisfy his deep need to complain.
                                                          - Lily Tomlin

