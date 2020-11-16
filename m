Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2402B4A5D
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgKPQL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:11:58 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43651 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKPQL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:11:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 75DBE19432B8;
        Mon, 16 Nov 2020 11:11:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZGG8qC
        a5wLuFe5mcHvFURwYW2MmQOORQDw2XhJlEp5I=; b=oVgVyLD52g0uGYYR0s2CXG
        BUhfntrE5gU2aeqLAqsTJwCKEVfStMsMhFug01mu0YSRnDdUYlo3ufaKezn+AwEh
        wZQY5WbJCWAAsnNhuwpGdQBxD511vkWwFr1fZJUao4HMLu+N9XFkRNEOoxfnsTry
        B98rMqRccox6UGHaL8wS0VNujrH3ZcFZV7xKgp9xNsp1era1TvgNMyJt2NGi5r4o
        Yvak/IAuOgHh+sHGLkgTKpj+9hyKUs1FVfcfI7EHT6gJF4R1/Gy25T7QuNlti9BK
        BNxwMfQ21KLKE8W3nc8fh7GEC2Xq7f3xMUh4i4hAlw357hIxzNM7WtsQ/2QA2jtw
        ==
X-ME-Sender: <xms:y6SyX2oAtDB-4PrxUQ-rFYdqplVu_lK055TrcSXzfZJc8yUExWvH2A>
    <xme:y6SyX0qFsQrmZOP8vNl-Ya0MSpK7NIf0pDJZTLQnLiPClBSf5aHvYbIplfNzwgD5U
    Wj70uAnDpiI0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepudfhgfeuudffjeeuuddvjeeilefghfekueeivdetje
    evvdeiffeihfettefhueeunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdplhhlvhhm
    rdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:y6SyX7OU7g7a7o_hbu4nUzjOz4OSpX_ExFUrVrBMpW-qphvfu4R_nw>
    <xmx:y6SyX16OFUmlYj_P-JzgjCJscAUj-8q6y02bwzxpAieEMiU8TMPxxg>
    <xmx:y6SyX17WAXsplwTeHY0xkEPUg32dZRlG-pPh7eOydK6hSxL7ZEPuGg>
    <xmx:zKSyX41VpjtkcMOd4KU4eA2Ewazmkfh2QsUEnSnok-UG6kAb64ohmw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 620D23064AAE;
        Mon, 16 Nov 2020 11:11:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] compiler.h: fix barrier_data() on clang" failed to apply to 5.4-stable tree
To:     nivedita@alum.mit.edu, akpm@linux-foundation.org,
        keescook@chromium.org, ndesaulniers@google.com,
        rdunlap@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:12:46 +0100
Message-ID: <1605543166238208@kroah.com>
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

From 3347acc6fcd4ee71ad18a9ff9d9dac176b517329 Mon Sep 17 00:00:00 2001
From: Arvind Sankar <nivedita@alum.mit.edu>
Date: Fri, 13 Nov 2020 22:51:59 -0800
Subject: [PATCH] compiler.h: fix barrier_data() on clang

Commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
mutually exclusive") neglected to copy barrier_data() from
compiler-gcc.h into compiler-clang.h.

The definition in compiler-gcc.h was really to work around clang's more
aggressive optimization, so this broke barrier_data() on clang, and
consequently memzero_explicit() as well.

For example, this results in at least the memzero_explicit() call in
lib/crypto/sha256.c:sha256_transform() being optimized away by clang.

Fix this by moving the definition of barrier_data() into compiler.h.

Also move the gcc/clang definition of barrier() into compiler.h,
__memory_barrier() is icc-specific (and barrier() is already defined
using it in compiler-intel.h) and doesn't belong in compiler.h.

[rdunlap@infradead.org: fix ALPHA builds when SMP is not enabled]

Link: https://lkml.kernel.org/r/20201101231835.4589-1-rdunlap@infradead.org
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201014212631.207844-1-nivedita@alum.mit.edu
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 798027bb89be..640f09479bdf 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -13,6 +13,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
 #include <asm/rwonce.h>
 
 #ifndef nop
diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index 230604e7f057..dd7233c48bf3 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -60,12 +60,6 @@
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
-/* The following are for compatibility with GCC, from compiler-gcc.h,
- * and may be redefined here because they should not be shared with other
- * compilers, like ICC.
- */
-#define barrier() __asm__ __volatile__("" : : : "memory")
-
 #if __has_feature(shadow_call_stack)
 # define __noscs	__attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 5deb37024574..74c6c0486eed 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -15,25 +15,6 @@
 # error Sorry, your version of GCC is too old - please use 4.9 or newer.
 #endif
 
-/* Optimization barrier */
-
-/* The "volatile" is due to gcc bugs */
-#define barrier() __asm__ __volatile__("": : :"memory")
-/*
- * This version is i.e. to prevent dead stores elimination on @ptr
- * where gcc and llvm may behave differently when otherwise using
- * normal barrier(): while gcc behavior gets along with a normal
- * barrier(), llvm needs an explicit input variable to be assumed
- * clobbered. The issue is as follows: while the inline asm might
- * access any memory it wants, the compiler could have fit all of
- * @ptr into memory registers instead, and since @ptr never escaped
- * from that, it proved that the inline asm wasn't touching any of
- * it. This version works well with both compilers, i.e. we're telling
- * the compiler that the inline asm absolutely may see the contents
- * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
- */
-#define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
-
 /*
  * This macro obfuscates arithmetic on a variable address so that gcc
  * shouldn't recognize the original var, and make assumptions about it.
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index e512f5505dad..b8fe0c23cfff 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -80,11 +80,25 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 
 /* Optimization barrier */
 #ifndef barrier
-# define barrier() __memory_barrier()
+/* The "volatile" is due to gcc bugs */
+# define barrier() __asm__ __volatile__("": : :"memory")
 #endif
 
 #ifndef barrier_data
-# define barrier_data(ptr) barrier()
+/*
+ * This version is i.e. to prevent dead stores elimination on @ptr
+ * where gcc and llvm may behave differently when otherwise using
+ * normal barrier(): while gcc behavior gets along with a normal
+ * barrier(), llvm needs an explicit input variable to be assumed
+ * clobbered. The issue is as follows: while the inline asm might
+ * access any memory it wants, the compiler could have fit all of
+ * @ptr into memory registers instead, and since @ptr never escaped
+ * from that, it proved that the inline asm wasn't touching any of
+ * it. This version works well with both compilers, i.e. we're telling
+ * the compiler that the inline asm absolutely may see the contents
+ * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
+ */
+# define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
 #endif
 
 /* workaround for GCC PR82365 if needed */

