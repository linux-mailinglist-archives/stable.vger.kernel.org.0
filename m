Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0E3B86C6
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhF3QJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 12:09:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58646 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhF3QJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 12:09:17 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 75057227B0;
        Wed, 30 Jun 2021 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625069207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBNiV6X0VvlmzrRNeG+hYxpG//2MEO+8fJ4cDyFMQwA=;
        b=dsWMrTvUIWwexSA0D6TJZtTzYZOdJPoWiSvHc5uQ5t3b3CFUStMzVNvczeq5c8k6ONH7O0
        AbBOEqD+xWwoGhURkD7tVccp+dU0QAjUTnwJqgetFx3A3SbYvg0vZrfwN8owATAgkfZgRS
        dHPzxGryLaxU9QJUh9Lglc3Sos1g24k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625069207;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBNiV6X0VvlmzrRNeG+hYxpG//2MEO+8fJ4cDyFMQwA=;
        b=PzDLD4QIByLU+vENG1u/VMNfEqMPqCJLGHcKM7+ekQUuQMP+KiGzrTQl6OtshS4vTlbkxA
        WWNWZMiRU0xFjICw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 575F9118DD;
        Wed, 30 Jun 2021 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625069207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBNiV6X0VvlmzrRNeG+hYxpG//2MEO+8fJ4cDyFMQwA=;
        b=dsWMrTvUIWwexSA0D6TJZtTzYZOdJPoWiSvHc5uQ5t3b3CFUStMzVNvczeq5c8k6ONH7O0
        AbBOEqD+xWwoGhURkD7tVccp+dU0QAjUTnwJqgetFx3A3SbYvg0vZrfwN8owATAgkfZgRS
        dHPzxGryLaxU9QJUh9Lglc3Sos1g24k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625069207;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBNiV6X0VvlmzrRNeG+hYxpG//2MEO+8fJ4cDyFMQwA=;
        b=PzDLD4QIByLU+vENG1u/VMNfEqMPqCJLGHcKM7+ekQUuQMP+KiGzrTQl6OtshS4vTlbkxA
        WWNWZMiRU0xFjICw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id TlMwFJeW3GD9WAAALh3uQQ
        (envelope-from <bp@suse.de>); Wed, 30 Jun 2021 16:06:47 +0000
Date:   Wed, 30 Jun 2021 18:06:46 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org, tglx@linutronix.de
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Make init_fpstate correct with
 optimized XSAVE" failed to apply to 4.4-stable tree
Message-ID: <YNyWlkF9BdYcdwBs@zn.tnic>
References: <1624803899162147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1624803899162147@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 27, 2021 at 04:24:59PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From f9dfb5e390fab2df9f7944bb91e7705aba14cd26 Mon Sep 17 00:00:00 2001
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 18 Jun 2021 16:18:25 +0200
> Subject: [PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE

Let's try this: it boots in a VM so it should be good. I had to remove
some of the newly added XSTATE states. tglx, can you have a quick look
pls?

---
From 4b4b8d7511d8f65da389074248c974317b75ddba Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 18 Jun 2021 16:18:25 +0200
Subject: [PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE

Commit f9dfb5e390fab2df9f7944bb91e7705aba14cd26 upstream.

The XSAVE init code initializes all enabled and supported components with
XRSTOR(S) to init state. Then it XSAVEs the state of the components back
into init_fpstate which is used in several places to fill in the init state
of components.

This works correctly with XSAVE, but not with XSAVEOPT and XSAVES because
those use the init optimization and skip writing state of components which
are in init state. So init_fpstate.xsave still contains all zeroes after
this operation.

There are two ways to solve that:

   1) Use XSAVE unconditionally, but that requires to reshuffle the buffer when
      XSAVES is enabled because XSAVES uses compacted format.

   2) Save the components which are known to have a non-zero init state by other
      means.

Looking deeper, #2 is the right thing to do because all components the
kernel supports have all-zeroes init state except the legacy features (FP,
SSE). Those cannot be hard coded because the states are not identical on all
CPUs, but they can be saved with FXSAVE which avoids all conditionals.

Use FXSAVE to save the legacy FP/SSE components in init_fpstate along with
a BUILD_BUG_ON() which reminds developers to validate that a newly added
component has all zeroes init state. As a bonus remove the now unused
copy_xregs_to_kernel_booting() crutch.

The XSAVE and reshuffle method can still be implemented in the unlikely
case that components are added which have a non-zero init state and no
other means to save them. For now, FXSAVE is just simple and good enough.

  [ bp: Fix a typo or two in the text. ]

Fixes: 6bad06b76892 ("x86, xsave: Use xsaveopt in context-switch path when supported")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
[ bp: 4.4 backport: Drop XFEATURE_MASK_{PKRU,PASID} which are not there yet. ]
Link: https://lkml.kernel.org/r/20210618143444.587311343@linutronix.de
---
 arch/x86/include/asm/fpu/internal.h | 30 +++++++----------------
 arch/x86/kernel/fpu/xstate.c        | 37 ++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 66a5e60f60c4..4fb38927128c 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -217,6 +217,14 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 	}
 }
 
+static inline void fxsave(struct fxregs_state *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (*fx));
+	else
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (*fx));
+}
+
 /* These macros all use (%edi)/(%rdi) as the single memory argument. */
 #define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
 #define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
@@ -286,28 +294,6 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
 
-/*
- * This function is called only during boot time when x86 caps are not set
- * up and alternative can not be used yet.
- */
-static inline void copy_xregs_to_kernel_booting(struct xregs_state *xstate)
-{
-	u64 mask = -1;
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	WARN_ON(system_state != SYSTEM_BOOTING);
-
-	if (static_cpu_has(X86_FEATURE_XSAVES))
-		XSTATE_OP(XSAVES, xstate, lmask, hmask, err);
-	else
-		XSTATE_OP(XSAVE, xstate, lmask, hmask, err);
-
-	/* We should never fault when copying to a kernel buffer: */
-	WARN_ON_FPU(err);
-}
-
 /*
  * This function is called only during boot time when x86 caps are not set
  * up and alternative can not be used yet.
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 3fa200ecca62..1ff1adbc843b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -292,6 +292,23 @@ static void __init setup_xstate_comp(void)
 	}
 }
 
+/*
+ * All supported features have either init state all zeros or are
+ * handled in setup_init_fpu() individually. This is an explicit
+ * feature list and does not use XFEATURE_MASK*SUPPORTED to catch
+ * newly added supported features at build time and make people
+ * actually look at the init state for the new feature.
+ */
+#define XFEATURES_INIT_FPSTATE_HANDLED		\
+	(XFEATURE_MASK_FP |			\
+	 XFEATURE_MASK_SSE |			\
+	 XFEATURE_MASK_YMM |			\
+	 XFEATURE_MASK_OPMASK |			\
+	 XFEATURE_MASK_ZMM_Hi256 |		\
+	 XFEATURE_MASK_Hi16_ZMM	 |		\
+	 XFEATURE_MASK_BNDREGS |		\
+	 XFEATURE_MASK_BNDCSR)
+
 /*
  * setup the xstate image representing the init state
  */
@@ -299,6 +316,8 @@ static void __init setup_init_fpu_buf(void)
 {
 	static int on_boot_cpu = 1;
 
+	BUILD_BUG_ON(XCNTXT_MASK != XFEATURES_INIT_FPSTATE_HANDLED);
+
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
 
@@ -319,10 +338,22 @@ static void __init setup_init_fpu_buf(void)
 	copy_kernel_to_xregs_booting(&init_fpstate.xsave);
 
 	/*
-	 * Dump the init state again. This is to identify the init state
-	 * of any feature which is not represented by all zero's.
+	 * All components are now in init state. Read the state back so
+	 * that init_fpstate contains all non-zero init state. This only
+	 * works with XSAVE, but not with XSAVEOPT and XSAVES because
+	 * those use the init optimization which skips writing data for
+	 * components in init state.
+	 *
+	 * XSAVE could be used, but that would require to reshuffle the
+	 * data when XSAVES is available because XSAVES uses xstate
+	 * compaction. But doing so is a pointless exercise because most
+	 * components have an all zeros init state except for the legacy
+	 * ones (FP and SSE). Those can be saved with FXSAVE into the
+	 * legacy area. Adding new features requires to ensure that init
+	 * state is all zeroes or if not to add the necessary handling
+	 * here.
 	 */
-	copy_xregs_to_kernel_booting(&init_fpstate.xsave);
+	fxsave(&init_fpstate.fxsave);
 }
 
 static int xfeature_is_supervisor(int xfeature_nr)
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
