Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7FD7169A
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbfGWKz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:55:27 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53129 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728856AbfGWKz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:55:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 538C111F9;
        Tue, 23 Jul 2019 06:55:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WEOIZN
        w9HqFQDA4urK1eChGy89ePWfE/TgV8DHjjhe0=; b=kcBUGb965HmfAQ6ZuBR8NG
        d8VgOGGw/cMoTKBjIZZwLGgio93uluJ5TgDdhK8FTVggaPFspbmyu3ZhNF2BwdlE
        ttAwG2tN5tGRbdbwDhvSXr0xr9D9sKrFRAW8nc+yr1F8ZI51/r63J6xLHpOfdN8G
        5lj0dD+iMKE/GWS/P2zNpWbQyIMrGTQkXVQwiuuytquK3f2Nxophd/1Zrll1AppU
        447gt1HFZGuSGcMMDCmRnEqNmlMCy6QRm0dTfTX24HlWXtGXawsRA26TVadjLZKq
        qAvGSAfQEllXHD+acQ552ot6pyz1YfRTGiH7o9BhSzg1z9zNDzc1ef9xpFVxkIug
        ==
X-ME-Sender: <xms:nOc2XaRCOJXFlfrCSI5vh41EpEGMjQiqizmG1P40TZUUSTSgZ9D3kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepshhpihhnihgtshdrnhgvthdpvghnthhrhidrshgsnecukfhppe
    ekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehk
    rhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nOc2Xb1oArkRrw0LPY-gsm9qsfezoXu5bzCWy-DENtU5RvGJGz2mnQ>
    <xmx:nOc2XTJcy72gKiUrOvS3fKEQ8406s9tgb_40Buj6v8SANkvUpsKMMg>
    <xmx:nOc2XU-K7-J2ocVS5Gk05QPxdbfZK9sbXGyU4TVfGcGZfa9kHWmXxQ>
    <xmx:nec2XQN-PGun4QOYZfMRxBznzqC3aC-Uwbl15DSuIHG0kv6Z0rmb-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FA9180064;
        Tue, 23 Jul 2019 06:55:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Fix incorrect irqflag restore for priority masking" failed to apply to 5.1-stable tree
To:     julien.thierry@arm.com, catalin.marinas@arm.com,
        christoffer.dall@arm.com, james.morse@arm.com, liwei391@huawei.com,
        marc.zyngier@arm.com, oleg@redhat.com, rostedt@goodmis.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com,
        will.deacon@arm.com, yuzenghui@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:51:02 +0200
Message-ID: <1563879062242194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd82d4bd21880b7c4d5f5756be435095d6ae07b5 Mon Sep 17 00:00:00 2001
From: Julien Thierry <julien.thierry@arm.com>
Date: Tue, 11 Jun 2019 10:38:10 +0100
Subject: [PATCH] arm64: Fix incorrect irqflag restore for priority masking

When using IRQ priority masking to disable interrupts, in order to deal
with the PSR.I state, local_irq_save() would convert the I bit into a
PMR value (GIC_PRIO_IRQOFF). This resulted in local_irq_restore()
potentially modifying the value of PMR in undesired location due to the
state of PSR.I upon flag saving [1].

In an attempt to solve this issue in a less hackish manner, introduce
a bit (GIC_PRIO_IGNORE_PMR) for the PMR values that can represent
whether PSR.I is being used to disable interrupts, in which case it
takes precedence of the status of interrupt masking via PMR.

GIC_PRIO_PSR_I_SET is chosen such that (<pmr_value> |
GIC_PRIO_PSR_I_SET) does not mask more interrupts than <pmr_value> as
some sections (e.g. arch_cpu_idle(), interrupt acknowledge path)
requires PMR not to mask interrupts that could be signaled to the
CPU when using only PSR.I.

[1] https://www.spinics.net/lists/arm-kernel/msg716956.html

Fixes: 4a503217ce37 ("arm64: irqflags: Use ICC_PMR_EL1 for interrupt masking")
Cc: <stable@vger.kernel.org> # 5.1.x-
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Li <liwei391@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 14b41ddc68ba..9e991b628706 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -163,7 +163,9 @@ static inline bool gic_prio_masking_enabled(void)
 
 static inline void gic_pmr_mask_irqs(void)
 {
-	BUILD_BUG_ON(GICD_INT_DEF_PRI <= GIC_PRIO_IRQOFF);
+	BUILD_BUG_ON(GICD_INT_DEF_PRI < (GIC_PRIO_IRQOFF |
+					 GIC_PRIO_PSR_I_SET));
+	BUILD_BUG_ON(GICD_INT_DEF_PRI >= GIC_PRIO_IRQON);
 	gic_write_pmr(GIC_PRIO_IRQOFF);
 }
 
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index db452aa9e651..f93204f319da 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -18,6 +18,7 @@
 
 #include <linux/irqflags.h>
 
+#include <asm/arch_gicv3.h>
 #include <asm/cpufeature.h>
 
 #define DAIF_PROCCTX		0
@@ -32,6 +33,11 @@ static inline void local_daif_mask(void)
 		:
 		:
 		: "memory");
+
+	/* Don't really care for a dsb here, we don't intend to enable IRQs */
+	if (system_uses_irq_prio_masking())
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+
 	trace_hardirqs_off();
 }
 
@@ -43,7 +49,7 @@ static inline unsigned long local_daif_save(void)
 
 	if (system_uses_irq_prio_masking()) {
 		/* If IRQs are masked with PMR, reflect it in the flags */
-		if (read_sysreg_s(SYS_ICC_PMR_EL1) <= GIC_PRIO_IRQOFF)
+		if (read_sysreg_s(SYS_ICC_PMR_EL1) != GIC_PRIO_IRQON)
 			flags |= PSR_I_BIT;
 	}
 
@@ -59,36 +65,44 @@ static inline void local_daif_restore(unsigned long flags)
 	if (!irq_disabled) {
 		trace_hardirqs_on();
 
-		if (system_uses_irq_prio_masking())
-			arch_local_irq_enable();
-	} else if (!(flags & PSR_A_BIT)) {
-		/*
-		 * If interrupts are disabled but we can take
-		 * asynchronous errors, we can take NMIs
-		 */
 		if (system_uses_irq_prio_masking()) {
-			flags &= ~PSR_I_BIT;
+			gic_write_pmr(GIC_PRIO_IRQON);
+			dsb(sy);
+		}
+	} else if (system_uses_irq_prio_masking()) {
+		u64 pmr;
+
+		if (!(flags & PSR_A_BIT)) {
 			/*
-			 * There has been concern that the write to daif
-			 * might be reordered before this write to PMR.
-			 * From the ARM ARM DDI 0487D.a, section D1.7.1
-			 * "Accessing PSTATE fields":
-			 *   Writes to the PSTATE fields have side-effects on
-			 *   various aspects of the PE operation. All of these
-			 *   side-effects are guaranteed:
-			 *     - Not to be visible to earlier instructions in
-			 *       the execution stream.
-			 *     - To be visible to later instructions in the
-			 *       execution stream
-			 *
-			 * Also, writes to PMR are self-synchronizing, so no
-			 * interrupts with a lower priority than PMR is signaled
-			 * to the PE after the write.
-			 *
-			 * So we don't need additional synchronization here.
+			 * If interrupts are disabled but we can take
+			 * asynchronous errors, we can take NMIs
 			 */
-			arch_local_irq_disable();
+			flags &= ~PSR_I_BIT;
+			pmr = GIC_PRIO_IRQOFF;
+		} else {
+			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
 		}
+
+		/*
+		 * There has been concern that the write to daif
+		 * might be reordered before this write to PMR.
+		 * From the ARM ARM DDI 0487D.a, section D1.7.1
+		 * "Accessing PSTATE fields":
+		 *   Writes to the PSTATE fields have side-effects on
+		 *   various aspects of the PE operation. All of these
+		 *   side-effects are guaranteed:
+		 *     - Not to be visible to earlier instructions in
+		 *       the execution stream.
+		 *     - To be visible to later instructions in the
+		 *       execution stream
+		 *
+		 * Also, writes to PMR are self-synchronizing, so no
+		 * interrupts with a lower priority than PMR is signaled
+		 * to the PE after the write.
+		 *
+		 * So we don't need additional synchronization here.
+		 */
+		gic_write_pmr(pmr);
 	}
 
 	write_sysreg(flags, daif);
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index fbe1aba6ffb3..a1372722f12e 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -67,43 +67,46 @@ static inline void arch_local_irq_disable(void)
  */
 static inline unsigned long arch_local_save_flags(void)
 {
-	unsigned long daif_bits;
 	unsigned long flags;
 
-	daif_bits = read_sysreg(daif);
-
-	/*
-	 * The asm is logically equivalent to:
-	 *
-	 * if (system_uses_irq_prio_masking())
-	 *	flags = (daif_bits & PSR_I_BIT) ?
-	 *			GIC_PRIO_IRQOFF :
-	 *			read_sysreg_s(SYS_ICC_PMR_EL1);
-	 * else
-	 *	flags = daif_bits;
-	 */
 	asm volatile(ALTERNATIVE(
-			"mov	%0, %1\n"
-			"nop\n"
-			"nop",
-			__mrs_s("%0", SYS_ICC_PMR_EL1)
-			"ands	%1, %1, " __stringify(PSR_I_BIT) "\n"
-			"csel	%0, %0, %2, eq",
-			ARM64_HAS_IRQ_PRIO_MASKING)
-		: "=&r" (flags), "+r" (daif_bits)
-		: "r" ((unsigned long) GIC_PRIO_IRQOFF)
-		: "cc", "memory");
+		"mrs	%0, daif",
+		__mrs_s("%0", SYS_ICC_PMR_EL1),
+		ARM64_HAS_IRQ_PRIO_MASKING)
+		: "=&r" (flags)
+		:
+		: "memory");
 
 	return flags;
 }
 
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	int res;
+
+	asm volatile(ALTERNATIVE(
+		"and	%w0, %w1, #" __stringify(PSR_I_BIT),
+		"eor	%w0, %w1, #" __stringify(GIC_PRIO_IRQON),
+		ARM64_HAS_IRQ_PRIO_MASKING)
+		: "=&r" (res)
+		: "r" ((int) flags)
+		: "memory");
+
+	return res;
+}
+
 static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
 
 	flags = arch_local_save_flags();
 
-	arch_local_irq_disable();
+	/*
+	 * There are too many states with IRQs disabled, just keep the current
+	 * state if interrupts are already disabled/masked.
+	 */
+	if (!arch_irqs_disabled_flags(flags))
+		arch_local_irq_disable();
 
 	return flags;
 }
@@ -124,21 +127,5 @@ static inline void arch_local_irq_restore(unsigned long flags)
 		: "memory");
 }
 
-static inline int arch_irqs_disabled_flags(unsigned long flags)
-{
-	int res;
-
-	asm volatile(ALTERNATIVE(
-			"and	%w0, %w1, #" __stringify(PSR_I_BIT) "\n"
-			"nop",
-			"cmp	%w1, #" __stringify(GIC_PRIO_IRQOFF) "\n"
-			"cset	%w0, ls",
-			ARM64_HAS_IRQ_PRIO_MASKING)
-		: "=&r" (res)
-		: "r" ((int) flags)
-		: "cc", "memory");
-
-	return res;
-}
 #endif
 #endif
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4bcd9c1291d5..33410635b015 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -608,11 +608,12 @@ static inline void kvm_arm_vhe_guest_enter(void)
 	 * will not signal the CPU of interrupts of lower priority, and the
 	 * only way to get out will be via guest exceptions.
 	 * Naturally, we want to avoid this.
+	 *
+	 * local_daif_mask() already sets GIC_PRIO_PSR_I_SET, we just need a
+	 * dsb to ensure the redistributor is forwards EL2 IRQs to the CPU.
 	 */
-	if (system_uses_irq_prio_masking()) {
-		gic_write_pmr(GIC_PRIO_IRQON);
+	if (system_uses_irq_prio_masking())
 		dsb(sy);
-	}
 }
 
 static inline void kvm_arm_vhe_guest_exit(void)
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index b2de32939ada..da2242248466 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -35,9 +35,15 @@
  * means masking more IRQs (or at least that the same IRQs remain masked).
  *
  * To mask interrupts, we clear the most significant bit of PMR.
+ *
+ * Some code sections either automatically switch back to PSR.I or explicitly
+ * require to not use priority masking. If bit GIC_PRIO_PSR_I_SET is included
+ * in the  the priority mask, it indicates that PSR.I should be set and
+ * interrupt disabling temporarily does not rely on IRQ priorities.
  */
-#define GIC_PRIO_IRQON		0xf0
-#define GIC_PRIO_IRQOFF		(GIC_PRIO_IRQON & ~0x80)
+#define GIC_PRIO_IRQON			0xc0
+#define GIC_PRIO_IRQOFF			(GIC_PRIO_IRQON & ~0x80)
+#define GIC_PRIO_PSR_I_SET		(1 << 4)
 
 /* Additional SPSR bits not exposed in the UABI */
 #define PSR_IL_BIT		(1 << 20)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 6d5966346710..165da78815c5 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -258,6 +258,7 @@ alternative_else_nop_endif
 	/*
 	 * Registers that may be useful after this macro is invoked:
 	 *
+	 * x20 - ICC_PMR_EL1
 	 * x21 - aborted SP
 	 * x22 - aborted PC
 	 * x23 - aborted PSTATE
@@ -449,6 +450,24 @@ alternative_endif
 	.endm
 #endif
 
+	.macro	gic_prio_kentry_setup, tmp:req
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	mov	\tmp, #(GIC_PRIO_PSR_I_SET | GIC_PRIO_IRQON)
+	msr_s	SYS_ICC_PMR_EL1, \tmp
+	alternative_else_nop_endif
+#endif
+	.endm
+
+	.macro	gic_prio_irq_setup, pmr:req, tmp:req
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	orr	\tmp, \pmr, #GIC_PRIO_PSR_I_SET
+	msr_s	SYS_ICC_PMR_EL1, \tmp
+	alternative_else_nop_endif
+#endif
+	.endm
+
 	.text
 
 /*
@@ -627,6 +646,7 @@ el1_dbg:
 	cmp	x24, #ESR_ELx_EC_BRK64		// if BRK64
 	cinc	x24, x24, eq			// set bit '0'
 	tbz	x24, #0, el1_inv		// EL1 only
+	gic_prio_kentry_setup tmp=x3
 	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
@@ -644,12 +664,10 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
+	gic_prio_irq_setup pmr=x20, tmp=x1
 	enable_da_f
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
-alternative_if ARM64_HAS_IRQ_PRIO_MASKING
-	ldr	x20, [sp, #S_PMR_SAVE]
-alternative_else_nop_endif
 	test_irqs_unmasked	res=x0, pmr=x20
 	cbz	x0, 1f
 	bl	asm_nmi_enter
@@ -679,8 +697,9 @@ alternative_else_nop_endif
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 	/*
-	 * if IRQs were disabled when we received the interrupt, we have an NMI
-	 * and we are not re-enabling interrupt upon eret. Skip tracing.
+	 * When using IRQ priority masking, we can get spurious interrupts while
+	 * PMR is set to GIC_PRIO_IRQOFF. An NMI might also have occurred in a
+	 * section with interrupts disabled. Skip tracing in those cases.
 	 */
 	test_irqs_unmasked	res=x0, pmr=x20
 	cbz	x0, 1f
@@ -809,6 +828,7 @@ el0_ia:
 	 * Instruction abort handling
 	 */
 	mrs	x26, far_el1
+	gic_prio_kentry_setup tmp=x0
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -854,6 +874,7 @@ el0_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x26, far_el1
+	gic_prio_kentry_setup tmp=x0
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -888,6 +909,7 @@ el0_dbg:
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
+	gic_prio_kentry_setup tmp=x3
 	mrs	x0, far_el1
 	mov	x1, x25
 	mov	x2, sp
@@ -909,7 +931,9 @@ ENDPROC(el0_sync)
 el0_irq:
 	kernel_entry 0
 el0_irq_naked:
+	gic_prio_irq_setup pmr=x20, tmp=x0
 	enable_da_f
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
@@ -931,6 +955,7 @@ ENDPROC(el0_irq)
 el1_error:
 	kernel_entry 1
 	mrs	x1, esr_el1
+	gic_prio_kentry_setup tmp=x2
 	enable_dbg
 	mov	x0, sp
 	bl	do_serror
@@ -941,6 +966,7 @@ el0_error:
 	kernel_entry 0
 el0_error_naked:
 	mrs	x1, esr_el1
+	gic_prio_kentry_setup tmp=x2
 	enable_dbg
 	mov	x0, sp
 	bl	do_serror
@@ -965,6 +991,7 @@ work_pending:
  */
 ret_to_user:
 	disable_daif
+	gic_prio_kentry_setup tmp=x3
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -981,6 +1008,7 @@ ENDPROC(ret_to_user)
  */
 	.align	6
 el0_svc:
+	gic_prio_kentry_setup tmp=x1
 	mov	x0, sp
 	bl	el0_svc_handler
 	b	ret_to_user
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 3767fb21a5b8..58efc3727778 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -94,7 +94,7 @@ static void __cpu_do_idle_irqprio(void)
 	 * be raised.
 	 */
 	pmr = gic_read_pmr();
-	gic_write_pmr(GIC_PRIO_IRQON);
+	gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 
 	__cpu_do_idle();
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index bb4b3f07761a..4deaee3c2a33 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -192,11 +192,13 @@ static void init_gic_priority_masking(void)
 
 	WARN_ON(!(cpuflags & PSR_I_BIT));
 
-	gic_write_pmr(GIC_PRIO_IRQOFF);
-
 	/* We can only unmask PSR.I if we can take aborts */
-	if (!(cpuflags & PSR_A_BIT))
+	if (!(cpuflags & PSR_A_BIT)) {
+		gic_write_pmr(GIC_PRIO_IRQOFF);
 		write_sysreg(cpuflags & ~PSR_I_BIT, daif);
+	} else {
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+	}
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8799e0c267d4..b89fcf0173b7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -615,7 +615,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * Naturally, we want to avoid this.
 	 */
 	if (system_uses_irq_prio_masking()) {
-		gic_write_pmr(GIC_PRIO_IRQON);
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 		dsb(sy);
 	}
 

