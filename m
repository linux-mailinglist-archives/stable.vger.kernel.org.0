Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB7257732
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgHaKUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:20:33 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:32825 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgHaKUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 06:20:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 581055E6;
        Mon, 31 Aug 2020 06:20:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 06:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NNTe3e
        rd3sn4BEOp+TA4ocgA+Shs3SxuUzXtx9YmGj0=; b=Peqd/zzYgISKZd3N020TTY
        zzn/Kyq6joeI6R3uDcVjfVwYNfVbza2wDRcmDS5HVsZd2rUrrWluTEcNxuKUOpxF
        T2T83Him1AeTmF1YNhoxyGk80irXbHn+59LkN8eWciG1Eg2+z9oNNxNKKAiVE0Fv
        inbn9UNIGrIfcrt0TFd3XG1e4SNkU8uSqv4u5N8+TL9LBStdPvtynd9Xxp2b4tvF
        AbMh517RMiR7GpDjQqAVKpQmaqLdRYO6C1WeZXycBVlYMZ1NZw7+Yg++ih6urbLv
        igJh5lm0sMuLQ8I6XQZDlE+ZWyW+3D0EbS7zGSomLZcRYT0VRAHcbEPCgMcCvpFA
        ==
X-ME-Sender: <xms:7s5MX7MTVr8S9A2Z-oX_KH9LsDJ3Z4N4w99_DrQmKlYPaHnDd3upMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepudfhkeffgfeifeffvdejieeihfehledtffehudeuhf
    fhhedtudejleeuheehvdffnecuffhomhgrihhnpehhhihpqdgvnhhtrhihrdhssgenucfk
    phepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7s5MX19RU3iMLEjc2eidQancBTlPTrH-k-vHAS5jR3PrI4HdRYiTNg>
    <xmx:7s5MX6RXiXO2cdn4xd4Kn9RYumso6bnb08RiHTDuDSoPuyAIOkKwEg>
    <xmx:7s5MX_sUS96zHLuyNwaHjfMvcXm6p_hNjJcD3e1akpNYhf6stvaZOg>
    <xmx:785MXzlFJOGH8NjWo4RImUCZK0A99ioOJvO9RCJ2STi6krXAvtAX6-3zCxo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CD4330600A6;
        Mon, 31 Aug 2020 06:20:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Survive synchronous exceptions caused by AT" failed to apply to 5.8-stable tree
To:     james.morse@arm.com, catalin.marinas@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:20:31 +0200
Message-ID: <1598869231206251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 88a84ccccb3966bcc3f309cdb76092a9892c0260 Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Fri, 21 Aug 2020 15:07:06 +0100
Subject: [PATCH] KVM: arm64: Survive synchronous exceptions caused by AT
 instructions

KVM doesn't expect any synchronous exceptions when executing, any such
exception leads to a panic(). AT instructions access the guest page
tables, and can cause a synchronous external abort to be taken.

The arm-arm is unclear on what should happen if the guest has configured
the hardware update of the access-flag, and a memory type in TCR_EL1 that
does not support atomic operations. B2.2.6 "Possible implementation
restrictions on using atomic instructions" from DDI0487F.a lists
synchronous external abort as a possible behaviour of atomic instructions
that target memory that isn't writeback cacheable, but the page table
walker may behave differently.

Make KVM robust to synchronous exceptions caused by AT instructions.
Add a get_user() style helper for AT instructions that returns -EFAULT
if an exception was generated.

While KVM's version of the exception table mixes synchronous and
asynchronous exceptions, only one of these can occur at each location.

Re-enter the guest when the AT instructions take an exception on the
assumption the guest will take the same exception. This isn't guaranteed
to make forward progress, as the AT instructions may always walk the page
tables, but guest execution may use the translation cached in the TLB.

This isn't a problem, as since commit 5dcd0fdbb492 ("KVM: arm64: Defer guest
entry when an asynchronous exception is pending"), KVM will return to the
host to process IRQs allowing the rest of the system to keep running.

Cc: stable@vger.kernel.org # <v5.3: 5dcd0fdbb492 ("KVM: arm64: Defer guest entry when an asynchronous exception is pending")
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 63350f0e3453..6f98fbd0ac81 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -169,6 +169,34 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 		*__hyp_this_cpu_ptr(sym);				\
 	 })
 
+#define __KVM_EXTABLE(from, to)						\
+	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
+	"	.align		3\n"					\
+	"	.long		(" #from " - .), (" #to " - .)\n"	\
+	"	.popsection\n"
+
+
+#define __kvm_at(at_op, addr)						\
+( { 									\
+	int __kvm_at_err = 0;						\
+	u64 spsr, elr;							\
+	asm volatile(							\
+	"	mrs	%1, spsr_el2\n"					\
+	"	mrs	%2, elr_el2\n"					\
+	"1:	at	"at_op", %3\n"					\
+	"	isb\n"							\
+	"	b	9f\n"						\
+	"2:	msr	spsr_el2, %1\n"					\
+	"	msr	elr_el2, %2\n"					\
+	"	mov	%w0, %4\n"					\
+	"9:\n"								\
+	__KVM_EXTABLE(1b, 2b)						\
+	: "+r" (__kvm_at_err), "=&r" (spsr), "=&r" (elr)		\
+	: "r" (addr), "i" (-EFAULT));					\
+	__kvm_at_err;							\
+} )
+
+
 #else /* __ASSEMBLY__ */
 
 .macro hyp_adr_this_cpu reg, sym, tmp
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index e47547e276d8..46b4dab933d0 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -167,13 +167,19 @@ el1_error:
 	b	__guest_exit
 
 el2_sync:
-	/* Check for illegal exception return, otherwise panic */
+	/* Check for illegal exception return */
 	mrs	x0, spsr_el2
+	tbnz	x0, #20, 1f
 
-	/* if this was something else, then panic! */
-	tst	x0, #PSR_IL_BIT
-	b.eq	__hyp_panic
+	save_caller_saved_regs_vect
+	stp     x29, x30, [sp, #-16]!
+	bl	kvm_unexpected_el2_exception
+	ldp     x29, x30, [sp], #16
+	restore_caller_saved_regs_vect
+
+	eret
 
+1:
 	/* Let's attempt a recovery from the illegal exception return */
 	get_vcpu_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IL
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6d8d4ed4287c..5b6b8fa00f0a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -146,10 +146,10 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg(par_el1);
-	asm volatile("at s1e1r, %0" : : "r" (far));
-	isb();
-
-	tmp = read_sysreg(par_el1);
+	if (!__kvm_at("s1e1r", far))
+		tmp = read_sysreg(par_el1);
+	else
+		tmp = SYS_PAR_EL1_F; /* back to the guest */
 	write_sysreg(par, par_el1);
 
 	if (unlikely(tmp & SYS_PAR_EL1_F))

