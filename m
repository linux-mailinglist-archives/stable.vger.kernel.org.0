Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B79162D672
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbiKQJVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiKQJVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:06 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65156D48F
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:02 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3697bd55974so13579007b3.15
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FzGFGDKGInoiNmFi9RSpCNvBHUr7kXaVKev/EfQ51o=;
        b=Lf6uAu0Td+CQM4TORv9y3v+VwHyQVrAlGvz3awuWBAjJpdkWDl+gi3MKtIkfyXsXab
         4eYUKJJRrT0zSNmIUQqGDSlBtdmfjAp9Ct+S/+uI+k/6ZvauCGjpdtGl7QNQRZgC4xPg
         BJoldh24GseK08gIpIeydNnAGmod6dhdtkEKyJ2AtEEpMTJ6qiWLCUJEJHHbfMTSuYBl
         P4xaYloCGQNBFqbo6mREbsHFSj6W2PRlwffLdk0R7k4AJDK2yb7p0/AVhqALPlZZaXYU
         qMy9/Pacu7S4YBETM4vD/33DWxdEvB07Npyyq2xvN+quqD9VOKgnkIIwvkostAES7L3O
         p3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FzGFGDKGInoiNmFi9RSpCNvBHUr7kXaVKev/EfQ51o=;
        b=FoELnyC/8CDc3fJ55NHsIUHXl8lb/e3NFBwtUgEaQx3Gwq16vYbGG5x2OcLmhcKuoy
         OdX6i4vN1s0Y37UIO4DIejNoVkDNhpQPrBfOOU1yp+KbqwC+DRatsXmm6RHrqLah6BjG
         5MxUCoJstYuk2iy+pTG9XThz9ofwCGGaY0fM8OfclgOrcdEPYLwdRqgfB3Vb70idBlQ+
         R0588xTA/YQI6t80osir6Hw9/hZRXJ5PWgOzqU16T8zwlOVBuVvArX9qTtvrBEsQy4dH
         BW24pSwAF1IvnqF4LSrpafeqjdaxANucKDQJlbv9gErSq1bPy+ffIehbUQvPLbPy7JJj
         n4nA==
X-Gm-Message-State: ANoB5pmUfIVimVENaeBbZ7ve1g3URomQhOsKrgiYN9CkbRL+TJXPXJbT
        jnFPmN03ZWJ1Ex30/fAjAPabnFRXdHSMXY6KZwyd3v3PEm5RG2vD08rBzSHp8oevYx+BryJUOH/
        94YYHG4wBDXxN9mzppMHml5SXBu0GN38x3ZG/VHakkGFWtBvID5DAoZedRgdstSB6TuY=
X-Google-Smtp-Source: AA0mqf7Dqp2hVktavdYlIkKTIb56YGRRpID7BmkS5OX3D7EN3eX3uikNP73GW+yct8M6oWZGRKP6gFeQfk7LoA==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a81:af53:0:b0:390:63df:952c with SMTP id
 x19-20020a81af53000000b0039063df952cmr0ywj.249.1668676861194; Thu, 17 Nov
 2022 01:21:01 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:31 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-14-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 13/34] x86/entry: Add kernel IBRS implementation
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 2dbb887e875b1de3ca8f40ddf26bcfe55798c609 upstream.

Implement Kernel IBRS - currently the only known option to mitigate RSB
underflow speculation issues on Skylake hardware.

Note: since IBRS_ENTER requires fuller context established than
UNTRAIN_RET, it must be placed after it. However, since UNTRAIN_RET
itself implies a RET, it must come after IBRS_ENTER. This means
IBRS_ENTER needs to also move UNTRAIN_RET.

Note 2: KERNEL_IBRS is sub-optimal for XenPV.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: conflict at arch/x86/entry/entry_64.S, skip_r11rcx]
[cascardo: conflict at arch/x86/entry/entry_64_compat.S]
[cascardo: conflict fixups, no ANNOTATE_NOENDBR]
[cascardo: entry fixups because of missing UNTRAIN_RET]
[cascardo: conflicts on fsgsbase]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/entry/calling.h           | 58 ++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S          | 29 ++++++++++++++-
 arch/x86/entry/entry_64_compat.S   | 11 +++++-
 arch/x86/include/asm/cpufeatures.h |  2 +-
 4 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 90a1297550d3..806729a7172f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -308,6 +310,62 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+/*
+ * IBRS kernel mitigation for Spectre_v2.
+ *
+ * Assumes full context is established (PUSH_REGS, CR3 and GS) and it clobbers
+ * the regs it uses (AX, CX, DX). Must be called before the first RET
+ * instruction (NOTE! UNTRAIN_RET includes a RET instruction)
+ *
+ * The optional argument is used to save/restore the current value,
+ * which is used on the paranoid paths.
+ *
+ * Assumes x86_spec_ctrl_{base,current} to have SPEC_CTRL_IBRS set.
+ */
+.macro IBRS_ENTER save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	rdmsr
+	shl	$32, %rdx
+	or	%rdx, %rax
+	mov	%rax, \save_reg
+	test	$SPEC_CTRL_IBRS, %eax
+	jz	.Ldo_wrmsr_\@
+	lfence
+	jmp	.Lend_\@
+.Ldo_wrmsr_\@:
+.endif
+
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
+/*
+ * Similar to IBRS_ENTER, requires KERNEL GS,CR3 and clobbers (AX, CX, DX)
+ * regs. Must be called after the last RET.
+ */
+.macro IBRS_EXIT save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	mov	\save_reg, %rdx
+.else
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	andl	$(~SPEC_CTRL_IBRS), %edx
+.endif
+
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
 /*
  * Mitigate Spectre v1 for conditional swapgs code paths.
  *
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 35bdbd9d50c6..55b61b34c462 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -235,6 +235,10 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	/* IRQs are off. */
 	movq	%rax, %rdi
 	movq	%rsp, %rsi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
@@ -311,6 +315,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
+	IBRS_EXIT
 	POP_REGS pop_rdi=0
 
 	/*
@@ -684,6 +689,7 @@ GLOBAL(retint_user)
 	TRACE_IRQS_IRETQ
 
 GLOBAL(swapgs_restore_regs_and_return_to_usermode)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -1249,7 +1255,13 @@ ENTRY(paranoid_entry)
 	 */
 	FENCE_SWAPGS_KERNEL_ENTRY
 
-	ret
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+
+	RET
 END(paranoid_entry)
 
 /*
@@ -1277,12 +1289,20 @@ ENTRY(paranoid_exit)
 	jmp	.Lparanoid_exit_restore
 .Lparanoid_exit_no_swapgs:
 	TRACE_IRQS_IRETQ_DEBUG
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3	scratch_reg=%rbx save_reg=%r14
 .Lparanoid_exit_restore:
 	jmp restore_regs_and_return_to_kernel
 END(paranoid_exit)
 
+
 /*
  * Save all registers in pt_regs, and switch GS if needed.
  */
@@ -1302,6 +1322,7 @@ ENTRY(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 .Lerror_entry_from_usermode_after_swapgs:
 	/* Put us onto the real thread stack. */
@@ -1366,6 +1387,7 @@ ENTRY(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1471,6 +1493,8 @@ ENTRY(nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1694,6 +1718,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	do_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 40d2834a8101..85dd05de648c 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -4,7 +4,6 @@
  *
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
  */
-#include "calling.h"
 #include <asm/asm-offsets.h>
 #include <asm/current.h>
 #include <asm/errno.h>
@@ -17,6 +16,8 @@
 #include <linux/linkage.h>
 #include <linux/err.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -106,6 +107,8 @@ ENTRY(entry_SYSENTER_compat)
 	xorl	%r15d, %r15d		/* nospec   r15 */
 	cld
 
+	IBRS_ENTER
+
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -253,6 +256,8 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -262,6 +267,9 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -403,6 +411,7 @@ ENTRY(entry_INT80_compat)
 	 * gate turned them off.
 	 */
 	TRACE_IRQS_OFF
+	IBRS_ENTER
 
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0c6734329ed5..23126290185d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -202,7 +202,7 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-/* FREE!				( 7*32+12) */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
 /* FREE!				( 7*32+13) */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
-- 
2.38.1.431.g37b22c650d-goog

