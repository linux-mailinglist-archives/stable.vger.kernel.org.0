Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67093381D93
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhEPJPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:15:49 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48889 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhEPJPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:15:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id C7F16FCA;
        Sun, 16 May 2021 05:14:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 16 May 2021 05:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=otnYl9
        KRsrWAdYBqaMmqrG9emILWIfnYyyIHtYzoNic=; b=T91qEJiaETnAeuE5zCZmd7
        u7181SyLlrQxI0nH+pXTlZtoIK7wZ6OWqDB9C7imv1N3tYLw9TO/YiGd0hUQZuSO
        QiYKO2c0ijQXvqnuiht/y0bcc+hpKraCdu9+tJtLG6T9afoNSMAu4hh3mW0sGw5K
        GV25/ZpDnqRkfKca1hr8WAHs2hhLWBUNIexLrcIZlbKne/Yh+ekQdqNTgUC00gRH
        z6vDq3UXD1dcdpln38WwiwB8xP4f/2f+m6L08i45ps5O3BZjS9PSFKtlhadRb5t0
        OvYat8GX57epk6MkgvMjYlltKenueWdsLZbeixTyeSlZL3TrwEZoORyRrlvJhdsw
        ==
X-ME-Sender: <xms:eeKgYLEyGW8IlaeKzPHiMnUq6uTBLHhSdqP3_JCxsFk6vCobKsdcOQ>
    <xme:eeKgYIW3Z3Lal_fY4dFWwdipwNyCx8NNv_ShfOmk5u4dlFR4WOJdhrTd868PGfq0f
    RhNoQlZ7ULHEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:eeKgYNL5BmERQ9-LgodjvtxYQK2ooENfs3VTfkvevzNEsG03iWpGZA>
    <xmx:eeKgYJF25kI_H6bXCwtCq5w3Gy7GQP75905lvXmu_LWZNf-blc6grg>
    <xmx:eeKgYBWGltLxd2vb3YuHfbcw3yQC4Zrz9NeuJEPouR6Eh3CGDSHWJw>
    <xmx:euKgYAB2V7spDf1tK9wnUKGMF7C_CbHla0UkRptb3RrfSajQ2gIIMpPCddQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:14:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64s: Fix crashes when toggling stf barrier" failed to apply to 4.4-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:14:31 +0200
Message-ID: <1621156471101242@kroah.com>
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

From 8ec7791bae1327b1c279c5cd6e929c3b12daaf0a Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 6 May 2021 14:49:58 +1000
Subject: [PATCH] powerpc/64s: Fix crashes when toggling stf barrier

The STF (store-to-load forwarding) barrier mitigation can be
enabled/disabled at runtime via a debugfs file (stf_barrier), which
causes the kernel to patch itself to enable/disable the relevant
mitigations.

However depending on which mitigation we're using, it may not be safe to
do that patching while other CPUs are active. For example the following
crash:

  User access of kernel address (c00000003fff5af0) - exploit attempt? (uid: 0)
  segfault (11) at c00000003fff5af0 nip 7fff8ad12198 lr 7fff8ad121f8 code 1
  code: 40820128 e93c00d0 e9290058 7c292840 40810058 38600000 4bfd9a81 e8410018
  code: 2c030006 41810154 3860ffb6 e9210098 <e94d8ff0> 7d295279 39400000 40820a3c

Shows that we returned to userspace without restoring the user r13
value, due to executing the partially patched STF exit code.

Fix it by doing the patching under stop machine. The CPUs that aren't
doing the patching will be spinning in the core of the stop machine
logic. That is currently sufficient for our purposes, because none of
the patching we do is to that code or anywhere in the vicinity.

Fixes: a048a07d7f45 ("powerpc/64s: Add support for a store forwarding barrier at kernel entry/exit")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210506044959.1298123-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/lib/feature-fixups.c b/arch/powerpc/lib/feature-fixups.c
index 1fd31b4b0e13..10083add8b33 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/sched/mm.h>
+#include <linux/stop_machine.h>
 #include <asm/cputable.h>
 #include <asm/code-patching.h>
 #include <asm/page.h>
@@ -227,11 +228,25 @@ static void do_stf_exit_barrier_fixups(enum stf_barrier_type types)
 		                                           : "unknown");
 }
 
+static int __do_stf_barrier_fixups(void *data)
+{
+	enum stf_barrier_type *types = data;
+
+	do_stf_entry_barrier_fixups(*types);
+	do_stf_exit_barrier_fixups(*types);
+
+	return 0;
+}
 
 void do_stf_barrier_fixups(enum stf_barrier_type types)
 {
-	do_stf_entry_barrier_fixups(types);
-	do_stf_exit_barrier_fixups(types);
+	/*
+	 * The call to the fallback entry flush, and the fallback/sync-ori exit
+	 * flush can not be safely patched in/out while other CPUs are executing
+	 * them. So call __do_stf_barrier_fixups() on one CPU while all other CPUs
+	 * spin in the stop machine core with interrupts hard disabled.
+	 */
+	stop_machine(__do_stf_barrier_fixups, &types, NULL);
 }
 
 void do_uaccess_flush_fixups(enum l1d_flush_type types)

