Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF483B53C2
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhF0O1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:27:34 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58387 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhF0O1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:27:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3B0C4194064C;
        Sun, 27 Jun 2021 10:25:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 27 Jun 2021 10:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fJ/WHR
        USynxyqnCIqXS0rv9sPsb58AYbQbvwLXht2KA=; b=vGDFbcMg8JyDsKK30Fk8wF
        doyoKHVSHAM8eExlnYg6krWw9YF6ESFRI5YrvS8OwjQsMAjTlC9lU1dkFWA5EIck
        FAX2EhOOuy3DOH9yAVQzUmcqjU2wd7xcvjbbbVEvfJsTIqY1dTVpX1EsGFhZgAhm
        YDTrTayZOJqhr6oBogT8GH16k6XuQR0gJyYtqd2TSW56le91XKSW/ESrRVKXDAtB
        uhKDbaVm/fbRKq+bNbMyBYNANdF3EUqP06HfBeTHep74Uy4Ge7XO6oBrf17I+d/J
        i9nQvJGVpFfhyUNXKmVTLKNIcN8qNJpA6jD9PS1zvts3qo0Fi4lZlFxDsmE/tVkg
        ==
X-ME-Sender: <xms:RorYYP7yr_GNiP0WVyFNMfqzPJ6HxLaFACyQERdPZlqJ932txMTfEQ>
    <xme:RorYYE7GWIoH_2FD9p6WAC8fXPGbxJ9ppUbr20aVsuQTH4LSRXLEqjAsiH61LBGQa
    KlvOV5hVqQ0-w>
X-ME-Received: <xmr:RorYYGfbPhWfVzrjtML58bF7_aS9_v6lgE4ifYbB7XUyMmDhy5UpoHrNiLBSOzqvauDSHAVkBWpII88nlNdNWOslOH3-aQ9_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:RorYYAJhuV6pDBuI4tHInqq5QeAyquzeI_aKEmympcy6wDrsnPaYjA>
    <xmx:RorYYDLeMUhcsxu0HgHxXRCiWHRib62Xrn13byQuQTCtqvLQRjLMrA>
    <xmx:RorYYJwj2z2EMUIzvNAZit-D1hBi4z1WWozOzOtHkGDwZ19Nu32_hw>
    <xmx:RorYYJjKxrddMkRquviz4NF7iAe6ZStGJiIV1ApKjyYPyYkBJBu2PQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:25:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE" failed to apply to 5.4-stable tree
To:     tglx@linutronix.de, bp@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:25:04 +0200
Message-ID: <162480390420065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9dfb5e390fab2df9f7944bb91e7705aba14cd26 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 18 Jun 2021 16:18:25 +0200
Subject: [PATCH] x86/fpu: Make init_fpstate correct with optimized XSAVE

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
Link: https://lkml.kernel.org/r/20210618143444.587311343@linutronix.de

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index fdee23ea4e17..16bf4d4a8159 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -204,6 +204,14 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state.fxsave));
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
@@ -268,28 +276,6 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
 
-/*
- * This function is called only during boot time when x86 caps are not set
- * up and alternative can not be used yet.
- */
-static inline void copy_xregs_to_kernel_booting(struct xregs_state *xstate)
-{
-	u64 mask = xfeatures_mask_all;
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	WARN_ON(system_state != SYSTEM_BOOTING);
-
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
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
index d0eef963aad1..1cadb2faf740 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -440,6 +440,25 @@ static void __init print_xstate_offset_size(void)
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
+	 XFEATURE_MASK_PKRU |			\
+	 XFEATURE_MASK_BNDREGS |		\
+	 XFEATURE_MASK_BNDCSR |			\
+	 XFEATURE_MASK_PASID)
+
 /*
  * setup the xstate image representing the init state
  */
@@ -447,6 +466,10 @@ static void __init setup_init_fpu_buf(void)
 {
 	static int on_boot_cpu __initdata = 1;
 
+	BUILD_BUG_ON((XFEATURE_MASK_USER_SUPPORTED |
+		      XFEATURE_MASK_SUPERVISOR_SUPPORTED) !=
+		     XFEATURES_INIT_FPSTATE_HANDLED);
+
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
 
@@ -466,10 +489,22 @@ static void __init setup_init_fpu_buf(void)
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
 
 static int xfeature_uncompacted_offset(int xfeature_nr)

