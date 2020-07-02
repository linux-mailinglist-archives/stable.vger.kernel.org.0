Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D74211F4B
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGBI5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 04:57:17 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:46763 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbgGBI5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 04:57:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 38122A00;
        Thu,  2 Jul 2020 04:57:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 02 Jul 2020 04:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kdrag0n.dev; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=s7+5045RDL/6bm3EmBYWa1nF0t
        eYes17mVjN68BsV4s=; b=MEUQxuCJJ1r4h/+JpF2w5cBdcKo6cDBS0qRTs19J75
        ehTV09Hy2WMOV7jwHl1Q028sdcT3iloru0DPf/OAV+zF0Tc8YHCbQnMezjrQ8SBl
        8JXqnEnayyz1lMXeKqxS6saV5yo+tnfbbljChCpicXScJkaVZMmS70AbU51AhOrf
        2lPuOgWC8+NoaL9yUZwEsoizZe8tBXv38R2Yi28b44EcGFsh/I+fBuasnGQd8JHU
        hnAO0XP4qnzzLiSXes9lkelCifwYLwtb+TkyOd7hagtijYzMNNAVDv4jtJP2loN6
        pPDlKhli20iC2ZK5jF/eovd+4QerMRwWgN9lQquNWlug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=s7+5045RDL/6bm3Em
        BYWa1nF0teYes17mVjN68BsV4s=; b=uIwJGEKl9OOX7XH8TGS0ED0QdtB9UaPg5
        RRmSP3NzkSLLkhg/BmQFJXHUNlsGbiApl5d3zM6CEh039IzO6lWl9ZioOjfWJuci
        XgG+V3wUuU787MzEjfZCDBjPcfAAH0yueAWkbhD84pl5IRyeNdv5znqWhzfZlHbn
        79jzloU/Lhd9lRGLlXon+DPLGCsDHC5tRZVTCtCLFraCpVj8avbHatr7aDrP9YgS
        mVt86StWW4vTo361/uoMyRCgTjTw0M+Yp/3g1xdgY3NlVN6LP4eTelTB9hUhJyQM
        JQs/Fb/T9AdvU417ZVIo8nqDTLVBj+UCG+MiJPgfmeyZaDkNEOYlQ==
X-ME-Sender: <xms:aqH9XvJgSq0_pjEr9zmnGVQ2yFBbyLAW7divZolljUhUTT26hDl-JQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhnhicunfhi
    nhcuoegurghnnhihsehkughrrghgtdhnrdguvghvqeenucggtffrrghtthgvrhhnpedtvd
    etffeukeefuefffeeufedvtddvieegvefffeejfefhtdevjeetfefhgfehheenucffohhm
    rghinhepghhithhhuhgsrdgtohhmpdhlphgsgidruggrthgrnecukfhppedugeelrddvge
    ekrdefkedruddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepuggrnhhnhieskhgurhgrghdtnhdruggvvh
X-ME-Proxy: <xmx:aqH9XjLP0h57_1VRP570Kx4CnKB0JVK0ngAGTPwGHljHkEj2uOpvLA>
    <xmx:aqH9Xnt8YdtZJRT3uT8bXqtWKQ44obxNb5j5OYfInqNKGoCJXRH5xA>
    <xmx:aqH9Xobun66ZchYsENWT79A71NqQsrIInjKBwoos_CqiqyeE0lP2Wg>
    <xmx:aqH9Xu6JNg460E4TCYLAZpdaLKmUc3aN2xWaOajU6nNI-q7yLRneUeAPjwQ>
Received: from pinwheel.localdomain (vsrv_sea01.kdrag0n.dev [149.248.38.11])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB7AC306005C;
        Thu,  2 Jul 2020 04:57:12 -0400 (EDT)
From:   Danny Lin <danny@kdrag0n.dev>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Fangrui Song <maskray@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Danny Lin <danny@kdrag0n.dev>, stable@vger.kernel.org
Subject: [PATCH] vmlinux.lds.h: Coalesce transient LLVM dead code elimination sections
Date:   Thu,  2 Jul 2020 01:54:00 -0700
Message-Id: <20200702085400.2643527-1-danny@kdrag0n.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent LLVM 11 commit [1] made LLD stop implicitly coalescing some
temporary LLVM sections, namely .{data,bss}..compoundliteral.XXX:

  [30] .data..compoundli PROGBITS         ffffffff9ac9a000  19e9a000
       000000000000cea0  0000000000000000  WA       0     0     32
  [31] .rela.data..compo RELA             0000000000000000  40965440
       0000000000001d88  0000000000000018   I      2238    30     8
  [32] .data..compoundli PROGBITS         ffffffff9aca6ea0  19ea6ea0
       00000000000033c0  0000000000000000  WA       0     0     32
  [33] .rela.data..compo RELA             0000000000000000  409671c8
       0000000000000948  0000000000000018   I      2238    32     8
  [...]
  [2213] .bss..compoundlit NOBITS           ffffffffa3000000  1d85c000
       00000000000000a0  0000000000000000  WA       0     0     32
  [2214] .bss..compoundlit NOBITS           ffffffffa30000a0  1d85c000
       0000000000000040  0000000000000000  WA       0     0     32
  [...]

While these extra sections don't typically cause any breakage, they do
inflate the vmlinux size due to the overhead of storing metadata for
thousands of extra sections.

It's also worth noting that for some reason, some downstream Android
kernels can't boot at all if these sections aren't coalesced.

This issue isn't limited to any specific architecture; it affects arm64
and x86 if CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is forced on.

Example on x86 allyesconfig:
    Before: 2241 sections, 1170972 KiB
    After:    56 sections, 1171169 KiB

[1] https://github.com/llvm/llvm-project/commit/9e33c096476ab5e02ab1c8442cc3cb4e32e29f17

Link: https://github.com/ClangBuiltLinux/linux/issues/958
Cc: stable@vger.kernel.org # v4.4+
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Danny Lin <danny@kdrag0n.dev>
---
 include/asm-generic/vmlinux.lds.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db600ef218d7..18968cba87c7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -94,10 +94,10 @@
  */
 #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
-#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
+#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX* .data..compoundliteral*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
-#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
+#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
 #else
 #define TEXT_MAIN .text
-- 
2.27.0

