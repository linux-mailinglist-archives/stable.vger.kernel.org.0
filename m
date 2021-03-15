Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98A933ADBA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCOIka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:40:30 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:58147 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhCOIkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:40:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E7CB919408EA;
        Mon, 15 Mar 2021 04:40:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=od7ugO
        AYc66bIFBlYQc+3tMqf/1g+Y2LiX0mZWPRdmg=; b=dQ4w4bpxu5DYHv7GyQJPll
        31qhzdLRm01htw2x1D2QiuwAdU57BR/jFFabm3DY7lDEZD46q27kRE0CND4VIedA
        RX+Hj0wuhSrHhYRbb1CdOir2AjI5KYIAje5QiWFy/oqyFd2dNnN5uyjW68wQYm33
        Q9j8wVcWIce03SIu3zp2oLc1d9SqVAXv8hcJfxHvHn7bXTBukr4zzsWpDV82wbnY
        D3jruM5hkHejvQf9lpaD/LvBhPsSKZGffrB/Da7wEimD10VIB0imq1palxI6fQZO
        f0U4a6xE7ttFYdpDNw0CgMk6IUm6JrFTpaq+g2+fF3ivK9JZE9VItwL5fyRBPiIw
        ==
X-ME-Sender: <xms:dh1PYNBuqjI4o-7U3AruFoFgIZhgmszcyc0iLFbJE0qpGG5KAHt8ew>
    <xme:dh1PYLgq1oGVSeZaOW6zUhDobHtZvjya-HXsyDH_-3i0jU0Dm3xsDmxasIOR_GRXm
    3pq2Df9IIjvlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecuogfuohhrthgvugftvggtihhpvdculdegtddmne
    cujfgurhepuffvhfffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeelle
    elvdegfeelledtteegudegfffghfduffduudekgeefleegieegkeejhfelveenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:dh1PYInYkZubrq_sxfag7fisrOHGbRHinpAS4P9aTjnhtGnzWQP74g>
    <xmx:dh1PYHy00_b-Suja_jG25gmSTjT3vEaHuI_dSog7cJVQXYM6M53fuA>
    <xmx:dh1PYCQF33KvQ57N_taEFJZCekTz7d2z-rCiR_HNAFV6GMWU60ZuQQ>
    <xmx:dx1PYDL241iXRipo_N_8KsyLfTpFb2GYDJXVEebInFZ7GUEajoxrPzohsc4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1906424005A;
        Mon, 15 Mar 2021 04:40:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] linux/compiler-clang.h: define HAVE_BUILTIN_BSWAP*" failed to apply to 5.4-stable tree
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
Date:   Mon, 15 Mar 2021 09:40:20 +0100
Message-ID: <1615797620203184@kroah.com>
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

