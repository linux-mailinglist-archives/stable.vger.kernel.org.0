Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501FD381D94
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhEPJP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:15:57 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:49239 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231771AbhEPJP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:15:57 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id C76671018;
        Sun, 16 May 2021 05:14:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 16 May 2021 05:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gLS3pL
        qvBlsfyX3ytKt18D1Sn+TVDqM7PE15y3uPGh4=; b=m18bw1J6Y6seKhgn+XMyHr
        nCtXCIhLdS21cJF0zpQyHiip6ml4o9aTChIbH9otAokd4I7GJ6ynVCZIVzeZ792X
        b3lJv32/vr2szXXmYkyWDhL0XKA4LvwXJ8xLJCPSGRm4NVGVckKisl236Mj1zKgo
        l/OCt0Uja5K/YStEzjaRXs4W3NnJ5uJcXd43JEtt9s9zq089eByFcn4GTpJWuu/H
        ewDM9hVLzUgVUgaoxIWDHdUFFLWS0RGEksa600meDMtsYjdrulWkY5PjvMu4TEBJ
        gBtXelbNNjr6O+JHMM+LkiLC6dklkqGG926/OKpmOYTfoAXFuNwy3uHz+91uedyw
        ==
X-ME-Sender: <xms:guKgYIS6PsiSZiY69_XtGQWCxQiwCEXe35WBC3OwxLEnjQ5yVmJNvw>
    <xme:guKgYFwe7k_HB-UfyQ3q8gjQISjEnsvoUSdT_8ooqB_oEO0l96D8CpRgkl0sgjU3j
    dFzmJCCoghUpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:guKgYF3t2bPG0TvlW4y8L7wmVnik0K8lVoPrX24_9sb2Nqddc31V2A>
    <xmx:guKgYMAKqxvFswfpIKADfVhJvtfyPDYveWFbJ1FC1xpfmgKg7pRhYw>
    <xmx:guKgYBjYvxi75zTWL_Bz97blPJsRxY_BDC65EOlSa-2jAH4R-CjZGA>
    <xmx:guKgYLdAnSniUCTZXvFRNTdtT2KQKDwBy8lta5UjxA_TSLzmyhzMpHOND1w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:14:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64s: Fix crashes when toggling stf barrier" failed to apply to 4.9-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:14:32 +0200
Message-ID: <162115647217185@kroah.com>
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

