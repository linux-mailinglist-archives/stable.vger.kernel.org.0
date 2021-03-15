Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C7233ADC1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhCOIlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:41:04 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34209 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229540AbhCOIkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:40:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C9B52194195B;
        Mon, 15 Mar 2021 04:40:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Mar 2021 04:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dWaprm
        yy5g0jq9LPpRZiTjRbY0dUGuOl/kGEPdxgDQQ=; b=DDXuiUcCpCnSRVq8pBNuV3
        LhzROR6IG/XeBA0zYbeTCIfmNBnkFly3z5yBOcb9r252/d5s0OYkk/Hf9Z9rTTDu
        qepe9gEhLIid/D61T1yCFW+KamTuXNFCg7uCVja19g06I1TOvN8DtbXlK6f6VhAG
        AGb/6VJf+1t72UpmG+eVMxkXyD1B1ErkaD0nLzJu4YDeI3+L7aGUcsLkQkiAplBX
        5WQOlssZrG8S1lIyWTascwuBbLedilesikxQBClVQYj9pYffTn96Byy5B2OzqJlr
        +vzv4PzgsfUnjDcS4qeI902zjL/N5yBi60aAKHMT+Kvbuo/y7xSm/W017L7E+q+w
        ==
X-ME-Sender: <xms:fx1PYNSsgR6xzQAqt2kzgzAqkRTEAkWoJ8fk2tQyY4bjpH0LInuHyw>
    <xme:fx1PYGuPYhLRA9KEvnAnTrZFX7GbyvU13IGiJY6oSwVbYnYDxY192g-iK7KYpJL8H
    he8Hdnq-nwYOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecuogfuohhrthgvugftvggtihhpvdculdegtddmne
    cujfgurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeelle
    elvdegfeelledtteegudegfffghfduffduudekgeefleegieegkeejhfelveenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:fx1PYPsnmgL9lm8e3lVq4gy1c0VYvG58B_BBXVh-tUtww4Jw0yZcwQ>
    <xmx:fx1PYMx0neK7KGKj5301U5T-ipS7UySrh1eM2WCYdGJACeb8ITTDJA>
    <xmx:fx1PYFgMCZcdiP_j8UYtTSNV569gcPh3jP5Mg3S5dHW9vxG_168DZw>
    <xmx:gB1PYB0n-Rol570CR-XBaFqRntB1vQXUD7IpocT_vtQOvJzjZtPgJc-WGCw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFFF6108005F;
        Mon, 15 Mar 2021 04:40:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*" failed to apply to 4.19-stable tree
To:     arnd@arndb.de, akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        deanbo422@gmail.com, elver@google.com, green.hu@gmail.com,
        guoren@kernel.org, keescook@chromium.org,
        luc.vanoostenryck@gmail.com, masahiroy@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, nickhu@andestech.com,
        nivedita@alum.mit.edu, ojeda@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, rdunlap@infradead.org,
        samitolvanen@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:40:21 +0100
Message-ID: <161579762118239@kroah.com>
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

From 97e4910232fa1f81e806aa60c25a0450276d99a2 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 12 Mar 2021 21:07:47 -0800
Subject: [PATCH] linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*

Separating compiler-clang.h from compiler-gcc.h inadventently dropped the
definitions of the three HAVE_BUILTIN_BSWAP macros, which requires falling
back to the open-coded version and hoping that the compiler detects it.

Since all versions of clang support the __builtin_bswap interfaces, add
back the flags and have the headers pick these up automatically.

This results in a 4% improvement of compilation speed for arm defconfig.

Note: it might also be worth revisiting which architectures set
CONFIG_ARCH_USE_BUILTIN_BSWAP for one compiler or the other, today this is
set on six architectures (arm32, csky, mips, powerpc, s390, x86), while
another ten architectures define custom helpers (alpha, arc, ia64, m68k,
mips, nios2, parisc, sh, sparc, xtensa), and the rest (arm64, h8300,
hexagon, microblaze, nds32, openrisc, riscv) just get the unoptimized
version and rely on the compiler to detect it.

A long time ago, the compiler builtins were architecture specific, but
nowadays, all compilers that are able to build the kernel have correct
implementations of them, though some may not be as optimized as the inline
asm versions.

The patch that dropped the optimization landed in v4.19, so as discussed
it would be fairly safe to backport this revert to stable kernels to the
4.19/5.4/5.10 stable kernels, but there is a remaining risk for
regressions, and it has no known side-effects besides compile speed.

Link: https://lkml.kernel.org/r/20210226161151.2629097-1-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20210225164513.3667778-1-arnd@kernel.org/
Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Guo Ren <guoren@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index 04c0a5a717f7..d217c382b02d 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -31,6 +31,12 @@
 #define __no_sanitize_thread
 #endif
 
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
 #if __has_feature(undefined_behavior_sanitizer)
 /* GCC does not have __SANITIZE_UNDEFINED__ */
 #define __no_sanitize_undefined \

