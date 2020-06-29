Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C254820D194
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgF2SmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:18 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33545 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgF2Slw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D9BAA6F4;
        Mon, 29 Jun 2020 05:22:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 05:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RKUHPO
        aSN9BMAjyiXmkYQC6PDg1RZA2L0MoF98V1VaI=; b=IOxYEe/0aUCTiv9om5gQjD
        gbSDcuge7k7QMGjSSg1Dp6+AU+9j6ktOl2bjROlbenJJfUHtQHWE5gJtRWHICEiO
        IWYNX7CWhqzJizmAVl/hB34WbeO2E7SiqpdYj0FPTIr+gqu9Fd/bQlA98DFn6Jk2
        eaKfVNfDa5WntAOQ5MX7Sw2MDPjBxn7njgkA8WgbBrDnxjSE6kkzghpQXAnPCHpO
        fvTr4BqbNjaEEJblm566NGyXcEOq+0d24FJOOT3w94OJbl9IBRTZHNYIqUSEVbL9
        D96DC1FbM0drQcmAA8ZIjQ2CnbGoE7drTnpbCC4XT5NqkeI1kay4A4llPpXtUl3g
        ==
X-ME-Sender: <xms:2rL5XlhgKgLFM18xm2yvPzfZu2_lNuUD79VckmIMj5caMPq9pXkUaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2rL5XqAxsGe1_GJujppOusnvi1CeaS5fxmzJY21UMcBPIhjpajlIKw>
    <xmx:2rL5XlE5e-lLNWOh7W4R6ROc63RPx70H3fcJNUidhGmj6PG9KGXWYQ>
    <xmx:2rL5XqSZhXj57CvpNw-9sVAsINuxApx8DgPhBQkZZ4rVEfI3pd0t4A>
    <xmx:2rL5Xnv4bMhEnEYl2cbD-hDV8HctVHgatj4Lrxhf155Dt1ipF-wYYq9wlJc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23F27328005D;
        Mon, 29 Jun 2020 05:22:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/cpu: Use pinning mask for CR4 bits needing to be 0" failed to apply to 4.14-stable tree
To:     keescook@chromium.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 11:22:16 +0200
Message-ID: <1593422536207107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a13b9d0b97211579ea63b96c606de79b963c0f47 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Mon, 8 Jun 2020 20:15:09 -0700
Subject: [PATCH] x86/cpu: Use pinning mask for CR4 bits needing to be 0

The X86_CR4_FSGSBASE bit of CR4 should not change after boot[1]. Older
kernels should enforce this bit to zero, and newer kernels need to
enforce it depending on boot-time configuration (e.g. "nofsgsbase").
To support a pinned bit being either 1 or 0, use an explicit mask in
combination with the expected pinned bit values.

[1] https://lore.kernel.org/lkml/20200527103147.GI325280@hirez.programming.kicks-ass.net

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/202006082013.71E29A42@keescook

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 043d93cdcaad..95c090a45b4b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -347,6 +347,9 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	cr4_clear_bits(X86_CR4_UMIP);
 }
 
+/* These bits should not change their value after CPU init is finished. */
+static const unsigned long cr4_pinned_mask =
+	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
@@ -371,20 +374,20 @@ EXPORT_SYMBOL(native_write_cr0);
 
 void native_write_cr4(unsigned long val)
 {
-	unsigned long bits_missing = 0;
+	unsigned long bits_changed = 0;
 
 set_register:
 	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
 
 	if (static_branch_likely(&cr_pinning)) {
-		if (unlikely((val & cr4_pinned_bits) != cr4_pinned_bits)) {
-			bits_missing = ~val & cr4_pinned_bits;
-			val |= bits_missing;
+		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
+			bits_changed = (val & cr4_pinned_mask) ^ cr4_pinned_bits;
+			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
 			goto set_register;
 		}
-		/* Warn after we've set the missing bits. */
-		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
-			  bits_missing);
+		/* Warn after we've corrected the changed bits. */
+		WARN_ONCE(bits_changed, "pinned CR4 bits changed: 0x%lx!?\n",
+			  bits_changed);
 	}
 }
 #if IS_MODULE(CONFIG_LKDTM)
@@ -419,7 +422,7 @@ void cr4_init(void)
 	if (boot_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
 	if (static_branch_likely(&cr_pinning))
-		cr4 |= cr4_pinned_bits;
+		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
 
 	__write_cr4(cr4);
 
@@ -434,10 +437,7 @@ void cr4_init(void)
  */
 static void __init setup_cr_pinning(void)
 {
-	unsigned long mask;
-
-	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
-	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
+	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
 	static_key_enable(&cr_pinning.key);
 }
 

