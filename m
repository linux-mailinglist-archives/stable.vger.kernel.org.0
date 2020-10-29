Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB61229EC13
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgJ2Mmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:42:46 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50339 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbgJ2Mmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:42:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 01F6E86F;
        Thu, 29 Oct 2020 08:42:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 08:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Z6Bh54
        CPmcrAUXZHG1cCjOHW2CaY0Sb3V0sfMvxHdI4=; b=ezuNNRAHbrhd4ErHecZyp1
        3jB0L6SSlvTPKxcao+5wLZtFtkyTU+N44nnegBl3E04nVwpl79srcAXW1KTBYElg
        veTBNYNt5aHoIKosAfqbMtn9D9ru0x47oL2h0LytK5SHxAbt7W+sWFrU0GLRFpyx
        oR8xcoG6WatcV7TiZrTdxuLvMWouUY++MNQdxoctVeO0iOoJfiEwizMAxy3/oVi/
        Gd9n977O6O6O2SU6NGcZE3K6RupFVXHvtczhD7dmvBgmW/WOeBKVnfgdUSKSsbbz
        V11DJ+cSeq7+59NHMx2ybS9hUXc5/B+KDiYQS2WynkiFMkTEexCNGxs7NkjYVinQ
        ==
X-ME-Sender: <xms:w7iaX35ZcSVJpu-qRUpYNYr7YRyTYqvJcLcn7XclLx1wBGwwdO-hxw>
    <xme:w7iaX85qyNO14r53zRHMoFwDQ-zc7XnzA_bmX_MkEkUZIQUmJcQLGHlSfkHvyJxuR
    nkiwkMskd3GtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehleefgeeufeevuedtfedvvefhtdduteffffekiedtke
    fhjeeuteetiedvledvueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdeigedrshgs
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepjeenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w7iaX-flkk2fgBr3gtz3Glc-SEvPZ35txyc-fibdlL787s0yvqB_Fw>
    <xmx:w7iaX4LZ8ImyHbsRa-0rjIGvHL6aD-5GKnsezXmeqwdIqijGlkNT2g>
    <xmx:w7iaX7IsE5tOzz5oSDbvcTkrlUsXbwkwqeqy5hsB1funYHM1ohY1GQ>
    <xmx:w7iaXz1dmMPbBdO7e3zL_NXEeI8tOaKNdhnynCOay8HzthOdroso6TNfayY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 300A63064687;
        Thu, 29 Oct 2020 08:42:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/copy_mc: Introduce copy_mc_enhanced_fast_string()" failed to apply to 4.9-stable tree
To:     dan.j.williams@intel.com, bp@suse.de, erwin.tsaur@intel.com,
        lkp@intel.com, stable@vger.kernel.org, tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Oct 2020 13:43:34 +0100
Message-ID: <16039754147867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5da8e4a658109e3b7e1f45ae672b7c06ac3e7158 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Oct 2020 20:40:25 -0700
Subject: [PATCH] x86/copy_mc: Introduce copy_mc_enhanced_fast_string()

The motivations to go rework memcpy_mcsafe() are that the benefit of
doing slow and careful copies is obviated on newer CPUs, and that the
current opt-in list of CPUs to instrument recovery is broken relative to
those CPUs.  There is no need to keep an opt-in list up to date on an
ongoing basis if pmem/dax operations are instrumented for recovery by
default. With recovery enabled by default the old "mcsafe_key" opt-in to
careful copying can be made a "fragile" opt-out. Where the "fragile"
list takes steps to not consume poison across cachelines.

The discussion with Linus made clear that the current "_mcsafe" suffix
was imprecise to a fault. The operations that are needed by pmem/dax are
to copy from a source address that might throw #MC to a destination that
may write-fault, if it is a user page.

So copy_to_user_mcsafe() becomes copy_mc_to_user() to indicate
the separate precautions taken on source and destination.
copy_mc_to_kernel() is introduced as a non-SMAP version that does not
expect write-faults on the destination, but is still prepared to abort
with an error code upon taking #MC.

The original copy_mc_fragile() implementation had negative performance
implications since it did not use the fast-string instruction sequence
to perform copies. For this reason copy_mc_to_kernel() fell back to
plain memcpy() to preserve performance on platforms that did not indicate
the capability to recover from machine check exceptions. However, that
capability detection was not architectural and now that some platforms
can recover from fast-string consumption of memory errors the memcpy()
fallback now causes these more capable platforms to fail.

Introduce copy_mc_enhanced_fast_string() as the fast default
implementation of copy_mc_to_kernel() and finalize the transition of
copy_mc_fragile() to be a platform quirk to indicate 'copy-carefully'.
With this in place, copy_mc_to_kernel() is fast and recovery-ready by
default regardless of hardware capability.

Thanks to Vivek for identifying that copy_user_generic() is not suitable
as the copy_mc_to_user() backend since the #MC handler explicitly checks
ex_has_fault_handler(). Thanks to the 0day robot for catching a
performance bug in the x86/copy_mc_to_user implementation.

 [ bp: Add the "why" for this change from the 0/2th message, massage. ]

Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Reported-by: 0day robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/160195562556.2163339.18063423034951948973.stgit@dwillia2-desk3.amr.corp.intel.com

diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 2633635530b7..c13e8c9ee926 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -45,6 +45,8 @@ void enable_copy_mc_fragile(void)
 #define copy_mc_fragile_enabled (0)
 #endif
 
+unsigned long copy_mc_enhanced_fast_string(void *dst, const void *src, unsigned len);
+
 /**
  * copy_mc_to_kernel - memory copy that handles source exceptions
  *
@@ -52,9 +54,11 @@ void enable_copy_mc_fragile(void)
  * @src:	source address
  * @len:	number of bytes to copy
  *
- * Call into the 'fragile' version on systems that have trouble
- * actually do machine check recovery. Everyone else can just
- * use memcpy().
+ * Call into the 'fragile' version on systems that benefit from avoiding
+ * corner case poison consumption scenarios, For example, accessing
+ * poison across 2 cachelines with a single instruction. Almost all
+ * other uses case can use copy_mc_enhanced_fast_string() for a fast
+ * recoverable copy, or fallback to plain memcpy.
  *
  * Return 0 for success, or number of bytes not copied if there was an
  * exception.
@@ -63,6 +67,8 @@ unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigne
 {
 	if (copy_mc_fragile_enabled)
 		return copy_mc_fragile(dst, src, len);
+	if (static_cpu_has(X86_FEATURE_ERMS))
+		return copy_mc_enhanced_fast_string(dst, src, len);
 	memcpy(dst, src, len);
 	return 0;
 }
@@ -72,11 +78,19 @@ unsigned long __must_check copy_mc_to_user(void *dst, const void *src, unsigned
 {
 	unsigned long ret;
 
-	if (!copy_mc_fragile_enabled)
-		return copy_user_generic(dst, src, len);
+	if (copy_mc_fragile_enabled) {
+		__uaccess_begin();
+		ret = copy_mc_fragile(dst, src, len);
+		__uaccess_end();
+		return ret;
+	}
+
+	if (static_cpu_has(X86_FEATURE_ERMS)) {
+		__uaccess_begin();
+		ret = copy_mc_enhanced_fast_string(dst, src, len);
+		__uaccess_end();
+		return ret;
+	}
 
-	__uaccess_begin();
-	ret = copy_mc_fragile(dst, src, len);
-	__uaccess_end();
-	return ret;
+	return copy_user_generic(dst, src, len);
 }
diff --git a/arch/x86/lib/copy_mc_64.S b/arch/x86/lib/copy_mc_64.S
index c3b613c4544a..892d8915f609 100644
--- a/arch/x86/lib/copy_mc_64.S
+++ b/arch/x86/lib/copy_mc_64.S
@@ -124,4 +124,40 @@ EXPORT_SYMBOL_GPL(copy_mc_fragile)
 	_ASM_EXTABLE(.L_write_words, .E_write_words)
 	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
 #endif /* CONFIG_X86_MCE */
+
+/*
+ * copy_mc_enhanced_fast_string - memory copy with exception handling
+ *
+ * Fast string copy + fault / exception handling. If the CPU does
+ * support machine check exception recovery, but does not support
+ * recovering from fast-string exceptions then this CPU needs to be
+ * added to the copy_mc_fragile_key set of quirks. Otherwise, absent any
+ * machine check recovery support this version should be no slower than
+ * standard memcpy.
+ */
+SYM_FUNC_START(copy_mc_enhanced_fast_string)
+	movq %rdi, %rax
+	movq %rdx, %rcx
+.L_copy:
+	rep movsb
+	/* Copy successful. Return zero */
+	xorl %eax, %eax
+	ret
+SYM_FUNC_END(copy_mc_enhanced_fast_string)
+
+	.section .fixup, "ax"
+.E_copy:
+	/*
+	 * On fault %rcx is updated such that the copy instruction could
+	 * optionally be restarted at the fault position, i.e. it
+	 * contains 'bytes remaining'. A non-zero return indicates error
+	 * to copy_mc_generic() users, or indicate short transfers to
+	 * user-copy routines.
+	 */
+	movq %rcx, %rax
+	ret
+
+	.previous
+
+	_ASM_EXTABLE_FAULT(.L_copy, .E_copy)
 #endif /* !CONFIG_UML */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 893f021fec63..b3e4efcf7ca6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -550,6 +550,7 @@ static const char *uaccess_safe_builtin[] = {
 	"csum_partial_copy_generic",
 	"copy_mc_fragile",
 	"copy_mc_fragile_handle_tail",
+	"copy_mc_enhanced_fast_string",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
 };

