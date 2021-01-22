Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE4B300A27
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 18:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbhAVR1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 12:27:51 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36045 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbhAVQAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 11:00:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 767D11642;
        Fri, 22 Jan 2021 10:59:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 10:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=q4C2gO
        DrNnuaOVzcMN8FkrPguOut48ANLdxD1r7bSQ8=; b=KwzQFJJ6UexNbIKvxP3moe
        wYL4HFccO6OOgbch0IRgnd2V6HRU16VwSejqIPsIOwdvfqt27FPCCvU4q5ZJIf+1
        xyNR0prgkxu2qJtFHp1tE/PmzAXUrheG+cWwZqculKOBXs6waGbAzyUhgxUWW8oo
        76DxyeUNPaUZazoGoo+lBuc8UB9byezwujIKrGYDU1bgBFsxUG789mTjz8gLrrHZ
        QKph/bK4sdqBhibr4+2gE/L1j5csIWRQi1U6KIpFnBbiIHrW34LK3OWjpE2yaxem
        6PIx4BeZj1o9fw0P5LWrO8EKzLGnZtS9gWs4QKueGSP+Q2qpfTcyvtOTpJ8f32cA
        ==
X-ME-Sender: <xms:WPYKYHCGEIUvQvXay5cjVgM0DygnJgeqedoxzuIdPr3nACyoJ-y6gQ>
    <xme:WPYKYNj5B9gqKYijyGu0cos6ZgHa6RTsFGgvYTYYEJO0iPYUXlF0JwPSNZx2H38Fr
    cOpE31hJYTuSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:WPYKYCnJXcDrdXqAYjP_9a7LspABXwg3TAdRXgQUBFUVcJ1Cuc-yVw>
    <xmx:WPYKYJzoWG-ojpPWH34TZ1XApzHJaaEEytaRZvkwJLkKxpqb512_Xg>
    <xmx:WPYKYMT26j1DYkPV5dnYfUNQyxkzr04n3jx-wlo09Sqxjdt4EFxbpQ>
    <xmx:WfYKYF6CQb5jxuOWHmZZlpU1IETYRmhjlANetEjXqyaH3BOoMK5hjkCmwL8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66AA4240065;
        Fri, 22 Jan 2021 10:59:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps" failed to apply to 4.4-stable tree
To:     viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 16:59:17 +0100
Message-ID: <161133115747242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 698222457465ce343443be81c5512edda86e5914 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 24 Dec 2020 19:44:38 +0000
Subject: [PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Patches that introduced NT_FILE and NT_SIGINFO notes back in 2012
had taken care of native (fs/binfmt_elf.c) and compat (fs/compat_binfmt_elf.c)
coredumps; unfortunately, compat on mips (which does not go through the
usual compat_binfmt_elf.c) had not been noticed.

As the result, both N32 and O32 coredumps on 64bit mips kernels
have those sections malformed enough to confuse the living hell out of
all gdb and readelf versions (up to and including the tip of binutils-gdb.git).

Longer term solution is to make both O32 and N32 compat use the
regular compat_binfmt_elf.c, but that's too much for backports.  The minimal
solution is to do in arch/mips/kernel/binfmt_elf[on]32.c the same thing
those patches have done in fs/compat_binfmt_elf.c

Cc: stable@kernel.org # v3.7+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 6ee3f7218c67..c4441416e96b 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -103,4 +103,11 @@ jiffies_to_old_timeval32(unsigned long jiffies, struct old_timeval32 *value)
 #undef ns_to_kernel_old_timeval
 #define ns_to_kernel_old_timeval ns_to_old_timeval32
 
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t             compat_long_t
+#define user_siginfo_t          compat_siginfo_t
+#define copy_siginfo_to_external        copy_siginfo_to_external32
+
 #include "../../../fs/binfmt_elf.c"
diff --git a/arch/mips/kernel/binfmt_elfo32.c b/arch/mips/kernel/binfmt_elfo32.c
index 6dd103d3cebb..7b2a23f48c1a 100644
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -106,4 +106,11 @@ jiffies_to_old_timeval32(unsigned long jiffies, struct old_timeval32 *value)
 #undef ns_to_kernel_old_timeval
 #define ns_to_kernel_old_timeval ns_to_old_timeval32
 
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t             compat_long_t
+#define user_siginfo_t          compat_siginfo_t
+#define copy_siginfo_to_external        copy_siginfo_to_external32
+
 #include "../../../fs/binfmt_elf.c"

