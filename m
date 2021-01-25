Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91BC3032C6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbhAZEir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:38:47 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42595 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729307AbhAYOM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:12:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4BDACB32;
        Mon, 25 Jan 2021 09:11:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B4sTxr
        mMQXFnDCyFfX6ha7IsYA3ZRNNYLsGfWqenrcw=; b=lJ7FnxIa7gxVDxOtdpA4KF
        xhwbuTa/LqUGxtw5xhpuOTUC/21M0HxfG1nSxbxX8fqWudftWU0jJFyWkKqMs2EI
        K178fg+jpdDBjovlVwHPb/nh1QamTLp0BCGo6M+4SuCBe9qg4W7yUwH23yX6u6YD
        cMXF9BPVQnv1n93DbovQT9KGiSvnq4mbeGN5HFB5lSDD5dc9UBtv1Rn4npWzlBU0
        uLecWatt8PuuRhp5zpwTQjBXMMtO75CnK66S8BEB4AlEjbFG/x6nKvAdyiCx98fW
        kpsuGgDjnlWPZVTSH/83CmEoI9H4PaUxM8Xx1XBhwoiawfCKAfJmoMeb4qZhQ5SQ
        ==
X-ME-Sender: <xms:gtEOYKtHCcSbAXAfuhzNZks_XCFZlhencpflEoP6_og9BXSqjwjsLg>
    <xme:gtEOYPdB8XGaYBoa-YeQBOD6Uruxh73liofubmqUw6TjC6QBcYIblQxcZV5hIlzK1
    WQIff_g8ulabQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeegveelueegtdejkeffkeffkeeujeehgfejgfdvheefgf
    elveffgfehgedthfehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdeigedrshgs
    pdgvgigtvghpthhiohhnshdqieegshdrshgspdhlughsrdhssgenucfkphepkeefrdekie
    drjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gtEOYFxYET6NBZc2DYQVL6ZcKCd8UtCCwDOf6EKHuxj-xXNhsgoWXQ>
    <xmx:gtEOYFOzeIQ2vX31EgoZhu215oab9mTBMwRz8jKSyIc8NkuhJCe8dQ>
    <xmx:gtEOYK-wSF_J1Yu_sC8pbzqPEpSuGHjW_85rtyD2VRvnEnfLqubSHA>
    <xmx:gtEOYAm2RZ5Kie_wspHTvUKjKB92WCJcHgCqbdtVYY4M_MqgRLjHM8Xj-S8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BE6C240057;
        Mon, 25 Jan 2021 09:11:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/64s: fix scv entry fallback flush vs interrupt" failed to apply to 4.19-stable tree
To:     npiggin@gmail.com, mpe@ellerman.id.au, tuliom@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:11:10 +0100
Message-ID: <1611583870231110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 08685be7761d69914f08c3d6211c543a385a5b9c Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Mon, 11 Jan 2021 16:24:08 +1000
Subject: [PATCH] powerpc/64s: fix scv entry fallback flush vs interrupt

The L1D flush fallback functions are not recoverable vs interrupts,
yet the scv entry flush runs with MSR[EE]=1. This can result in a
timer (soft-NMI) or MCE or SRESET interrupt hitting here and overwriting
the EXRFI save area, which ends up corrupting userspace registers for
scv return.

Fix this by disabling RI and EE for the scv entry fallback flush.

Fixes: f79643787e0a0 ("powerpc/64s: flush L1D on kernel entry")
Cc: stable@vger.kernel.org # 5.9+ which also have flush L1D patch backport
Reported-by: Tulio Magno Quites Machado Filho <tuliom@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210111062408.287092-1-npiggin@gmail.com

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 1d32b174ab6a..c1a8aac01cf9 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -63,6 +63,12 @@
 	nop;								\
 	nop;
 
+#define SCV_ENTRY_FLUSH_SLOT						\
+	SCV_ENTRY_FLUSH_FIXUP_SECTION;					\
+	nop;								\
+	nop;								\
+	nop;
+
 /*
  * r10 must be free to use, r13 must be paca
  */
@@ -70,6 +76,13 @@
 	STF_ENTRY_BARRIER_SLOT;						\
 	ENTRY_FLUSH_SLOT
 
+/*
+ * r10, ctr must be free to use, r13 must be paca
+ */
+#define SCV_INTERRUPT_TO_KERNEL						\
+	STF_ENTRY_BARRIER_SLOT;						\
+	SCV_ENTRY_FLUSH_SLOT
+
 /*
  * Macros for annotating the expected destination of (h)rfid
  *
diff --git a/arch/powerpc/include/asm/feature-fixups.h b/arch/powerpc/include/asm/feature-fixups.h
index f6d2acb57425..ac605fc369c4 100644
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -240,6 +240,14 @@ label##3:					       	\
 	FTR_ENTRY_OFFSET 957b-958b;			\
 	.popsection;
 
+#define SCV_ENTRY_FLUSH_FIXUP_SECTION			\
+957:							\
+	.pushsection __scv_entry_flush_fixup,"a";	\
+	.align 2;					\
+958:							\
+	FTR_ENTRY_OFFSET 957b-958b;			\
+	.popsection;
+
 #define RFI_FLUSH_FIXUP_SECTION				\
 951:							\
 	.pushsection __rfi_flush_fixup,"a";		\
@@ -273,10 +281,12 @@ label##3:					       	\
 
 extern long stf_barrier_fallback;
 extern long entry_flush_fallback;
+extern long scv_entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
 extern long __start___uaccess_flush_fixup, __stop___uaccess_flush_fixup;
 extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
+extern long __start___scv_entry_flush_fixup, __stop___scv_entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
 extern long __start__btb_flush_fixup, __stop__btb_flush_fixup;
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index aa1af139d947..33ddfeef4fe9 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -75,7 +75,7 @@ BEGIN_FTR_SECTION
 	bne	.Ltabort_syscall
 END_FTR_SECTION_IFSET(CPU_FTR_TM)
 #endif
-	INTERRUPT_TO_KERNEL
+	SCV_INTERRUPT_TO_KERNEL
 	mr	r10,r1
 	ld	r1,PACAKSAVE(r13)
 	std	r10,0(r1)
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index e02ad6fefa46..6e53f7638737 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2993,6 +2993,25 @@ TRAMP_REAL_BEGIN(entry_flush_fallback)
 	ld	r11,PACA_EXRFI+EX_R11(r13)
 	blr
 
+/*
+ * The SCV entry flush happens with interrupts enabled, so it must disable
+ * to prevent EXRFI being clobbered by NMIs (e.g., soft_nmi_common). r10
+ * (containing LR) does not need to be preserved here because scv entry
+ * puts 0 in the pt_regs, CTR can be clobbered for the same reason.
+ */
+TRAMP_REAL_BEGIN(scv_entry_flush_fallback)
+	li	r10,0
+	mtmsrd	r10,1
+	lbz	r10,PACAIRQHAPPENED(r13)
+	ori	r10,r10,PACA_IRQ_HARD_DIS
+	stb	r10,PACAIRQHAPPENED(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	L1D_DISPLACEMENT_FLUSH
+	ld	r11,PACA_EXRFI+EX_R11(r13)
+	li	r10,MSR_RI
+	mtmsrd	r10,1
+	blr
+
 TRAMP_REAL_BEGIN(rfi_flush_fallback)
 	SET_SCRATCH0(r13);
 	GET_PACA(r13);
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4ab426b8b0e0..72fa3c00229a 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -145,6 +145,13 @@ SECTIONS
 		__stop___entry_flush_fixup = .;
 	}
 
+	. = ALIGN(8);
+	__scv_entry_flush_fixup : AT(ADDR(__scv_entry_flush_fixup) - LOAD_OFFSET) {
+		__start___scv_entry_flush_fixup = .;
+		*(__scv_entry_flush_fixup)
+		__stop___scv_entry_flush_fixup = .;
+	}
+
 	. = ALIGN(8);
 	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_OFFSET) {
 		__start___stf_exit_barrier_fixup = .;
diff --git a/arch/powerpc/lib/feature-fixups.c b/arch/powerpc/lib/feature-fixups.c
index 47821055b94c..1fd31b4b0e13 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -290,9 +290,6 @@ void do_entry_flush_fixups(enum l1d_flush_type types)
 	long *start, *end;
 	int i;
 
-	start = PTRRELOC(&__start___entry_flush_fixup);
-	end = PTRRELOC(&__stop___entry_flush_fixup);
-
 	instrs[0] = 0x60000000; /* nop */
 	instrs[1] = 0x60000000; /* nop */
 	instrs[2] = 0x60000000; /* nop */
@@ -312,6 +309,8 @@ void do_entry_flush_fixups(enum l1d_flush_type types)
 	if (types & L1D_FLUSH_MTTRIG)
 		instrs[i++] = 0x7c12dba6; /* mtspr TRIG2,r0 (SPR #882) */
 
+	start = PTRRELOC(&__start___entry_flush_fixup);
+	end = PTRRELOC(&__stop___entry_flush_fixup);
 	for (i = 0; start < end; start++, i++) {
 		dest = (void *)start + *start;
 
@@ -328,6 +327,25 @@ void do_entry_flush_fixups(enum l1d_flush_type types)
 		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
 	}
 
+	start = PTRRELOC(&__start___scv_entry_flush_fixup);
+	end = PTRRELOC(&__stop___scv_entry_flush_fixup);
+	for (; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+
+		patch_instruction((struct ppc_inst *)dest, ppc_inst(instrs[0]));
+
+		if (types == L1D_FLUSH_FALLBACK)
+			patch_branch((struct ppc_inst *)(dest + 1), (unsigned long)&scv_entry_flush_fallback,
+				     BRANCH_SET_LINK);
+		else
+			patch_instruction((struct ppc_inst *)(dest + 1), ppc_inst(instrs[1]));
+
+		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
+	}
+
+
 	printk(KERN_DEBUG "entry-flush: patched %d locations (%s flush)\n", i,
 		(types == L1D_FLUSH_NONE)       ? "no" :
 		(types == L1D_FLUSH_FALLBACK)   ? "fallback displacement" :

