Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502FD327B61
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhCAJ66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:58:58 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:50857 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234033AbhCAJ6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:58:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 274651940B3A;
        Mon,  1 Mar 2021 04:57:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 04:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=liCmom
        r0UhgqJfRLicAQFjqxxB6zUtmCb7pZLVkfugY=; b=Pg2intGPyylMbg1BqJ9WBP
        AGCJbP83AgFE3E4iEJx03/4o1H4UiLNBKuhkeEULo+TRdlC/kotr0Z07QArBLYJL
        JoKWAgKcq+GL038RMubn+INXQQkxjrYibTzuMACsguCNAF+9nxpcjafTfXsBoOc4
        yiPYX6rqRHrs7n7aehkoHonq22wgUX2dQMDkDKW+ZWM7R7q2JxI6qT0rCU7i66uu
        aksMdiEg7cInlGLR5aqRw8eCnkJhQzek925x3b0x8vvX756JLnEq812DAeFHKK6p
        hm0oT1MYFU3Hmn17iuifQM9mWMz9aYnQNlDrzFtJ+kzypI/3FfpZW18UMImFiV5A
        ==
X-ME-Sender: <xms:n7o8YGAaXnXMs1tK3WIBXge10VuyERmzcJdNdKSn-3nLglukom8TzA>
    <xme:n7o8YAiXOV1UfLaumAiPDOhIjlSGu38NNP-LQCLY4nwGV51AEFfgZlHSspemUj5EA
    FRCw6fDr-EDbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:n7o8YJnW9pGE1-eFOuRS2h3ZJs_fd0yBT0fnDF-3FXop8wDo1oQZzQ>
    <xmx:n7o8YExB1rLArzzR2HmKGKAJ-5mvrrKfd3RQ00vibU--jJvBIICMXQ>
    <xmx:n7o8YLTZN_q3M1Q3b4NOycUIADTwNCJGCezRsiWcijeX9LOxFIlkMg>
    <xmx:oLo8YCKqf9_wV4dF9-SUWdzkDK7A8ah8Ib3dXq-NCjNNVVhXpnd-bg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 337B0108005F;
        Mon,  1 Mar 2021 04:57:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: Support binutils configured with" failed to apply to 5.4-stable tree
To:     aurelien@aurel32.net, syq@debian.org, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:57:48 +0100
Message-ID: <1614592668319@kroah.com>
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

From 5373ae67c3aad1ab306cc722b5a80b831eb4d4d1 Mon Sep 17 00:00:00 2001
From: Aurelien Jarno <aurelien@aurel32.net>
Date: Sat, 9 Jan 2021 20:30:47 +0100
Subject: [PATCH] MIPS: Support binutils configured with
 --enable-mips-fix-loongson3-llsc=yes

From version 2.35, binutils can be configured with
--enable-mips-fix-loongson3-llsc=yes, which means it defaults to
-mfix-loongson3-llsc. This breaks labels which might then point at the
wrong instruction.

The workaround to explicitly pass -mno-fix-loongson3-llsc has been
added in Linux version 5.1, but is only enabled when building a Loongson
64 kernel. As vendors might use a common toolchain for building Loongson
and non-Loongson kernels, just move that workaround to
arch/mips/Makefile. At the same time update the comments to reflect the
current status.

Cc: stable@vger.kernel.org # 5.1+
Cc: YunQiang Su <syq@debian.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index cd4343edeb11..5ffdd67093bc 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -136,6 +136,25 @@ cflags-$(CONFIG_SB1XXX_CORELIS)	+= $(call cc-option,-mno-sched-prolog) \
 #
 cflags-y += -fno-stack-check
 
+# binutils from v2.35 when built with --enable-mips-fix-loongson3-llsc=yes,
+# supports an -mfix-loongson3-llsc flag which emits a sync prior to each ll
+# instruction to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h
+# for a description).
+#
+# We disable this in order to prevent the assembler meddling with the
+# instruction that labels refer to, ie. if we label an ll instruction:
+#
+# 1: ll v0, 0(a0)
+#
+# ...then with the assembler fix applied the label may actually point at a sync
+# instruction inserted by the assembler, and if we were using the label in an
+# exception table the table would no longer contain the address of the ll
+# instruction.
+#
+# Avoid this by explicitly disabling that assembler behaviour.
+#
+cflags-y += $(call as-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
+
 #
 # CPU-dependent compiler/assembler options for optimization.
 #
diff --git a/arch/mips/loongson64/Platform b/arch/mips/loongson64/Platform
index ec42c5085905..e2354e128d9a 100644
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -5,28 +5,6 @@
 
 cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,--trap
 
-#
-# Some versions of binutils, not currently mainline as of 2019/02/04, support
-# an -mfix-loongson3-llsc flag which emits a sync prior to each ll instruction
-# to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h for a
-# description).
-#
-# We disable this in order to prevent the assembler meddling with the
-# instruction that labels refer to, ie. if we label an ll instruction:
-#
-# 1: ll v0, 0(a0)
-#
-# ...then with the assembler fix applied the label may actually point at a sync
-# instruction inserted by the assembler, and if we were using the label in an
-# exception table the table would no longer contain the address of the ll
-# instruction.
-#
-# Avoid this by explicitly disabling that assembler behaviour. If upstream
-# binutils does not merge support for the flag then we can revisit & remove
-# this later - for now it ensures vendor toolchains don't cause problems.
-#
-cflags-$(CONFIG_CPU_LOONGSON64)	+= $(call as-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
-
 #
 # binutils from v2.25 on and gcc starting from v4.9.0 treat -march=loongson3a
 # as MIPS64 R2; older versions as just R1.  This leaves the possibility open

