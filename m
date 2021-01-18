Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9B22FA54E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405897AbhARP4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:56:42 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38501 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393380AbhARPYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 10:24:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7706D19C394C;
        Mon, 18 Jan 2021 10:22:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 10:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4IwOtI
        L0nzv/SqGZ6zOZHdvXB9hAEVDNav83GZW16w0=; b=krDsrw+9kJ5Nxcynu39xwk
        hmBZId4SuUbAOAgcJiEq/mRXrT9vZOiSM2Kln2tcnlHh0Hnoqyxf7ICNVj+bJLdM
        TGNPAT+oNXMhH+f7iftlFJ3hr3mllb40EHIpHqaMGrofbIpTFfGjqP3vOSZHIaQi
        29SuNEJ87VBZ2kfZUqqN26a/yUAt9nbYlgxZ+8Uz3tRjWxFJ6dz91FJCwp0LTmTZ
        LZ8SwF2ZlFEsi2cplyKcFd8MiULlAxN7KD/qjLq+n47j664pHuBbzi1/q2QDXpU5
        LMDnjniTZK6DHQlcRDTXX/wZMN66yPn8/zyRjZCB0vti/y5GpDhN4kOKoN3js1jw
        ==
X-ME-Sender: <xms:06cFYJK2M9bRkzf-7sstcvCvMWke1gHj8dwfdB8-1tXNOjDlxOwo-Q>
    <xme:06cFYFIEmtzqUIKoJXAOC0H5CYzdT4EEjbAFGZUyK3xY232w6o9XmOu3t-SppzXyF
    UpVdvlo9CjgGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:06cFYBvbbVytcRWOr-sg2HzVVKSyHsnsntCy_hQyCdNjzYAlywS-og>
    <xmx:06cFYKb4Z7nnGJj7eK3pInOvjnHNioPa4NPg-8DZI93uUYS1aBNnuQ>
    <xmx:06cFYAbH9cP0ssD9BdK80vHCEB25PiYZeWuxjRECF2ksOVuIhySCew>
    <xmx:06cFYJAgc73RoCjQ8utrIIR_3qAu0qwllTB8STyEj4DWOi3nNzNxBg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBDEF24005B;
        Mon, 18 Jan 2021 10:22:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps" failed to apply to 4.19-stable tree
To:     viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 16:22:56 +0100
Message-ID: <1610983376200240@kroah.com>
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

