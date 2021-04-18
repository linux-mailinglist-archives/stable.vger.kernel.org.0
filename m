Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5393E3634A1
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhDRKfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:35:37 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35319 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhDRKfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:35:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 760D019406F8;
        Sun, 18 Apr 2021 06:35:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Hz9dhl
        UXSIewdAtXsZ693+xEkw5/FgPF5To8JaGqml0=; b=W3PJh1fVespwilBS/fgoPz
        F0R9yrSK9s6M5zy1ZjGYwfXJEgrNmnVeIQ4LaFH/kkiLNcvaiJu7sGFW3EB/z4LH
        ij/6xCftmga/uA/pKjxNPUR4IcFDv1EOS5GJzGO6Bf17eQMRJjf+tE5f9KTPYgc0
        D02bdjDTb0pOKC3WxK8jUi/nJwdVoMfrtPxLzPNmmg7QCpL6RpiWj2Y1JhlOWxTR
        ZIwpqQLWNE6/MjZdTMP3YSGx9DDLuEWGuzzfDtPVPJOC8Xbv8oEGDA1f/SkRnXLN
        FF6lD7M6C0Q1okaopP9BvXYPPbkuxLAngfyGrzWeqEwMS29ypBjS9eM5b25hqIsw
        ==
X-ME-Sender: <xms:WAt8YCe0uSsjj5d8jR8__ZiXyHE1LDqw-PRwJIeRjEWMh4sNH2jZ3Q>
    <xme:WAt8YMPa1qMfmmzYuM2_5_B8xuYhguI7nzicagms-l2FotmftLbC0a4X_H7iaQKNb
    2gI31qYZJ5Svg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepudevtdehffejgfffkefhheehjeehkedttddttddvue
    fgheejhefgtddvvdduueetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpshhlvggv
    phdrshgspdeigedrshgsnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:WAt8YDivKogB-v8vGZz-pkKiO1_wz3jqui7x6KYHtRUNiQcUkcgAIg>
    <xmx:WAt8YP9WHLDQF4OfKHmTuzygM0j5AS2BpSh8sUug-KqPrbwQSUAMpQ>
    <xmx:WAt8YOvokQPZMLrsEbnP5lWKiEciwpB5SEiMJp6taDgxcm6C9azpxw>
    <xmx:WQt8YL-bCHpWTOPtPDVLKnnCJC9ebq3ONRUdoUfGeElG7o-knrsRKQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FB0A108005F;
        Sun, 18 Apr 2021 06:35:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kasan: remove redundant config option" failed to apply to 5.11-stable tree
To:     walter-zh.wu@mediatek.com, akpm@linux-foundation.org,
        andreyknvl@google.com, arnd@arndb.de, dvyukov@google.com,
        glider@google.com, natechancellor@gmail.com,
        ryabinin.a.a@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:35:02 +0200
Message-ID: <161874210212568@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 02c587733c8161355a43e6e110c2e29bd0acff72 Mon Sep 17 00:00:00 2001
From: Walter Wu <walter-zh.wu@mediatek.com>
Date: Fri, 16 Apr 2021 15:46:00 -0700
Subject: [PATCH] kasan: remove redundant config option

CONFIG_KASAN_STACK and CONFIG_KASAN_STACK_ENABLE both enable KASAN stack
instrumentation, but we should only need one config, so that we remove
CONFIG_KASAN_STACK_ENABLE and make CONFIG_KASAN_STACK workable.  see [1].

When enable KASAN stack instrumentation, then for gcc we could do no
prompt and default value y, and for clang prompt and default value n.

This patch fixes the following compilation warning:

  include/linux/kasan.h:333:30: warning: 'CONFIG_KASAN_STACK' is not defined, evaluates to 0 [-Wundef]

[akpm@linux-foundation.org: fix merge snafu]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210221 [1]
Link: https://lkml.kernel.org/r/20210226012531.29231-1-walter-zh.wu@mediatek.com
Fixes: d9b571c885a8 ("kasan: fix KASAN_STACK dependency for HW_TAGS")
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index 5bfd9b87f85d..4ea9392f86e0 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -134,7 +134,7 @@ SYM_FUNC_START(_cpu_resume)
 	 */
 	bl	cpu_do_resume
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	mov	x0, sp
 	bl	kasan_unpoison_task_stack_below
 #endif
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 56b6865afb2a..d5d8a352eafa 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -115,7 +115,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	movq	pt_regs_r14(%rax), %r14
 	movq	pt_regs_r15(%rax), %r15
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 	/*
 	 * The suspend path may have poisoned some areas deeper in the stack,
 	 * which we now need to unpoison.
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index b91732bd05d7..14f72ec96492 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -330,7 +330,7 @@ static inline bool kasan_check_byte(const void *address)
 
 #endif /* CONFIG_KASAN */
 
-#if defined(CONFIG_KASAN) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
 void kasan_unpoison_task_stack(struct task_struct *task);
 #else
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index fba9909e31b7..cffc2ebbf185 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -138,9 +138,10 @@ config KASAN_INLINE
 
 endchoice
 
-config KASAN_STACK_ENABLE
+config KASAN_STACK
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
+	default y if CC_IS_GCC
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
@@ -154,12 +155,6 @@ config KASAN_STACK_ENABLE
 	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
 	  to use and enabled by default.
 
-config KASAN_STACK
-	int
-	depends on KASAN_GENERIC || KASAN_SW_TAGS
-	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
-	default 0
-
 config KASAN_SW_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
 	depends on KASAN_SW_TAGS
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b5e08d4cefec..7b53291dafa1 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -63,7 +63,7 @@ void __kasan_unpoison_range(const void *address, size_t size)
 	kasan_unpoison(address, size);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 8c55634d6edd..3436c6bf7c0c 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -231,7 +231,7 @@ void *kasan_find_first_bad_addr(void *addr, size_t size);
 const char *kasan_get_bug_type(struct kasan_access_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
-#if defined(CONFIG_KASAN_GENERIC) && CONFIG_KASAN_STACK
+#if defined(CONFIG_KASAN_GENERIC) && defined(CONFIG_KASAN_STACK)
 void kasan_print_address_stack_frame(const void *addr);
 #else
 static inline void kasan_print_address_stack_frame(const void *addr) { }
diff --git a/mm/kasan/report_generic.c b/mm/kasan/report_generic.c
index 41f374585144..de732bc341c5 100644
--- a/mm/kasan/report_generic.c
+++ b/mm/kasan/report_generic.c
@@ -128,7 +128,7 @@ void kasan_metadata_fetch_row(char *buffer, void *row)
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
-#if CONFIG_KASAN_STACK
+#ifdef CONFIG_KASAN_STACK
 static bool __must_check tokenize_frame_descr(const char **frame_descr,
 					      char *token, size_t max_tok_len,
 					      unsigned long *value)
diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 127012f45166..3d791908ed36 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -4,6 +4,12 @@ KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SHADOW_OFFSET)
 
 cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
 
+ifdef CONFIG_KASAN_STACK
+	stack_enable := 1
+else
+	stack_enable := 0
+endif
+
 ifdef CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_INLINE
@@ -27,7 +33,7 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(CONFIG_KASAN_STACK)) \
+	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
@@ -42,7 +48,7 @@ else
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		$(call cc-param,hwasan-instrument-stack=$(CONFIG_KASAN_STACK)) \
+		$(call cc-param,hwasan-instrument-stack=$(stack_enable)) \
 		$(call cc-param,hwasan-use-short-granules=0) \
 		$(instrumentation_flags)
 
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 269967c4fc1b..a56c36470cb1 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -64,7 +64,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF
 		bool "zero-init structs passed by reference (strong)"
 		depends on GCC_PLUGINS
-		depends on !(KASAN && KASAN_STACK=1)
+		depends on !(KASAN && KASAN_STACK)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any structures on the stack that may
@@ -82,7 +82,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
 		bool "zero-init anything passed by reference (very strong)"
 		depends on GCC_PLUGINS
-		depends on !(KASAN && KASAN_STACK=1)
+		depends on !(KASAN && KASAN_STACK)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any stack variables that may be passed

