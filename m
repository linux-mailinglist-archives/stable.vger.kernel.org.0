Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71182FA491
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393421AbhARPYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:24:14 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40195 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393414AbhARPYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 10:24:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7F54119C3992;
        Mon, 18 Jan 2021 10:23:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 10:23:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cyUakN
        h/L+hDuf+jjj8SZv2nK+xcvHzzyKK2MJ8UFtU=; b=dq6KA9IkWdq3t3rYt6J6w8
        BvZDcI1/0OkQlyF8swBmbF2Zi4QY/GWmfnDelmuwuzCq1qYNNhxzQISpILgVQVi3
        INsos5nH7m9mkL4bf4g9hMWzx8+A8e8kYTgid20OtxXDTYNcSY69MOxxDEUVs8Ew
        6yPsygEwyv5sO6MlRGcsHwXmiQ5MDGr+oS+/0mI4gMOUgPlzIQLf1myGwgs27y1a
        DT3oCFqmuDIfEop0jHpaT4Yi6Dh6IKRPQNsLjvWwh3uTWjgLdIPh+SYZNcifgMMx
        o6WpBVBKwvdgZYrONgDQsIiZh1yNIa8P9bIbY/w0Vrirz0yZqEVxiHl8wqi/acSg
        ==
X-ME-Sender: <xms:6qcFYLlUlR4nn9Ye4yRagVwzJw4riMCEEPAHe9Em_clTYjgSQ4ffgw>
    <xme:6qcFYO1kNQCGMimlIr1hbA9SGGHpiqD7AHZsBU7E3d8CXRGXYVv1EPw__TDdwLyVh
    Zl3Tqc6A_odbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:6qcFYBo_RZcj8i0ou9q1owfyFbeG-kUdy3NXl_vZNMIivSvnMiKHyQ>
    <xmx:6qcFYDmmCJy2HU_LIexzTtuvHXj9JsDv2tdtU4aFtPORgdM39FzQag>
    <xmx:6qcFYJ3A1RshosR0EGAqxb17TblraSyZMWelrgenDNwIxyn2vfFnIQ>
    <xmx:6qcFYG9lLe8iPpUSabqpZY2pbZxrt8hCipS83BcPUuG8vwexZCYj7Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2080C24005C;
        Mon, 18 Jan 2021 10:23:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps" failed to apply to 5.4-stable tree
To:     viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 16:23:20 +0100
Message-ID: <1610983400132215@kroah.com>
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

