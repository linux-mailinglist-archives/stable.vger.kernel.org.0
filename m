Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3874300973
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbhAVQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 11:00:43 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53427 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729357AbhAVQAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 11:00:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 913592D7;
        Fri, 22 Jan 2021 10:59:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 10:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=EsLgj1
        RzsIfXjQZubpoxEXNsa3f8t9RzxPLwZ2tJRZs=; b=RpMZcIi2iL2KyBKLxUSOax
        TtAUBHZy91rvY0ERhkifI2KdOxYZWd3EsNR7d8djCSSxNKPQY2Gz1GU2vDtEvWvZ
        Fwe4Ikj5i2Dwrge4xY6cZqOy0rArq4YRZX+EfNQBMDc17aVJRGU2ZjEmlcTYsHVn
        dtAiNSrZNbJmgrItfb4To8Xwidnsp7yuLT/iYjd9LSERYpGEXU8/mgFbh6PCqtpI
        sdQ+5pZtLfkNWNqiCb5oumIPyxqBohhw2wsGuH1lw0TVctBSXwQKP1RlIVBLQB46
        xxWaYqMlv/fwd24Wx8EVj5zjR5jwf5yntqSCja8/TJZzO8wPXditmGMlMDAiFkdQ
        ==
X-ME-Sender: <xms:Y_YKYEvwjMDK9NUQqofLwbTE--Q4BBC1qVTWopm33mHJHMRnxnWQ8Q>
    <xme:Y_YKYBfO_3LcgXR-JusXDGodMZ0lvCgifr7KvwNhd8ZcsWxjttbhTLvA-zpHwCal1
    P8_RmEbPzvVzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Y_YKYPzBp7CXHS5oOP5fKusiTeskAIA1Ae11rHMQoo7fKEHFrcA67Q>
    <xmx:Y_YKYHNs6ZDFa63homRzeVG9yriYU6f4JfkGUFpoHiQmqA3zcRbQ6Q>
    <xmx:Y_YKYE9DGlvvfJPxuOKivTLAhSlsxDKnA-DGzd5o96kMAnaswQLN-Q>
    <xmx:Y_YKYJGi1KxVz-HDQDFwkx4aukzClgVJAvkiULU3XqAtERqnp7m7Miw_t2g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD0C0240057;
        Fri, 22 Jan 2021 10:59:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps" failed to apply to 4.14-stable tree
To:     viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 16:59:19 +0100
Message-ID: <1611331159146155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

