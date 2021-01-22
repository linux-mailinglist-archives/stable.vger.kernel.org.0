Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3FF30080C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbhAVQAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 11:00:42 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54191 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729347AbhAVQAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 11:00:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CE9391623;
        Fri, 22 Jan 2021 10:59:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 10:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wMUBtA
        xqiwQx8vynpLx0xPdz/NkpGFWka7pOb7Ram4Y=; b=qzOrKhY2RYps6wdSO6i962
        kymPOpaZDeXqcOMjtlV0weMtnEJ/CqForvS8Lxr94/VIPSCMbLtZsCW/I3Yy87uv
        yByDv5cj92cgmScNHgf/4MnBxN/9kNitjVpyuzrRm2wIzMTr1Fmujjf5M0u8wqJL
        Q3v/IPoriH/5yhRd07FdkTDa0HRTReZrI1lcTPHbFr17hk25eS//nTp2YurBrDDg
        VCUQY9b5nor4a3hihtPbJ/BI/Ad8BOK7hZlKl3wTagDAQX7ZqKsEgrWHSUK/J2tK
        eq4X4fbeJR4hmZFroQaGgjI8HS/O8Ei6i+0xEc71CfIKlb6HMH4ttw83WeG+U03w
        ==
X-ME-Sender: <xms:YfYKYF6obTy7VInJ4PGcdfxuy-KNyVVvtirm7aW0CWjbuM9Ewjo4Og>
    <xme:YfYKYC5Ak0KLdPr2GCWSAdd3n7Jn73frIGYbtjvTKrsFPkpCJ_gUgzfV8QN1ueu-A
    AwKtZEldHcQEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:YfYKYMf_I6p8VQRNZ5EvHwbOUvjJTyZQ2ararc7uDB4QlDKaOwpN9g>
    <xmx:YfYKYOIdeGubQxODn7N1R04VhBKQYZzAuM7QjSrVvgitbOzSLvaPag>
    <xmx:YfYKYJKJmXFOuI3jTF3htewQyXm8PtKchHlpjOViVD-gkvAbL2p5yA>
    <xmx:YfYKYLyukANX7a8F5R6LN5RDEwY29ZrFVWUjCRWfz7zgFLDn9JBikPjq0Wo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3AD3108005B;
        Fri, 22 Jan 2021 10:59:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps" failed to apply to 4.9-stable tree
To:     viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 16:59:18 +0100
Message-ID: <161133115870131@kroah.com>
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

