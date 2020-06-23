Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051E220516E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgFWL5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:57:38 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50303 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732333AbgFWL5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:57:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D44A2A16;
        Tue, 23 Jun 2020 07:57:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2xUkgq
        hwpLd2gHcL4e8vRkBe8zo6BtFeh48QKT2dMvY=; b=JEB/lsE2RKdIg/0GFAe/cm
        9ZTl5US66LRn38Pl/ISbmYfRBtMrrb/kdJnpD+lZo1Oizwbr1+042i4IUH+DrT/e
        pMo3qXN+h3tduCpDYXJ/6Mwk7oFXuDt1cnseQq4vdwC7ziS2YwGNYtRYEJiFEl2Q
        fJ4E+6MeEy/jihlvcJsk74OLJggrT1OUbZIsvLQdGBHRVPeLyGRx8zvs/sWmQpwK
        00Up41hwtwk+KkL8TrmXIqAR6MUmKTxshUqhqZ7Vd/WzGpKn71Su6X3kzRrxu8bI
        drq/83t9V95GB1LunXynLIlfpSs4jzePM5vHw670Ieyh7XMX4sr86/OSlXAVS0rg
        ==
X-ME-Sender: <xms:K-7xXu_lbaozL0lvrKv19nt2L27HAbbeU-Qj2O3FZIg0Ur53ejy0WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:K-7xXuu8qc9DYR2cjbrlgB3Sdyq1SCShM8H75o8O9G_NWlIeocri2g>
    <xmx:K-7xXkDqBNXv-l8KA_7t45GmUDi4_op5Ic3HPlEnFjbrKmsFLfCckw>
    <xmx:K-7xXmepcNU04cSO9VzdztZ3LmC00Nq33lmIoCOL_ffuhMOPfvuLRA>
    <xmx:MO7xXsjiwnx4btbmoJ8yN7lGZSLqKVel1AElVOxovx9o_8Ka8wXqRqcsiaLsn-L9>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A40E53280060;
        Tue, 23 Jun 2020 07:57:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kprobes: Fix to protect kick_kprobe_optimizer() by" failed to apply to 4.4-stable tree
To:     mhiramat@kernel.org, anders.roxell@linaro.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        gustavoars@kernel.org, mingo@elte.hu, mingo@kernel.org,
        naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org, zsun@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:57:25 +0200
Message-ID: <1592913445111125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1a0aa991a6274161c95a844c58cfb801d681eb59 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Tue, 12 May 2020 17:02:56 +0900
Subject: [PATCH] kprobes: Fix to protect kick_kprobe_optimizer() by
 kprobe_mutex

In kprobe_optimizer() kick_kprobe_optimizer() is called
without kprobe_mutex, but this can race with other caller
which is protected by kprobe_mutex.

To fix that, expand kprobe_mutex protected area to protect
kick_kprobe_optimizer() call.

Link: http://lkml.kernel.org/r/158927057586.27680.5036330063955940456.stgit@devnote2

Fixes: cd7ebe2298ff ("kprobes: Use text_poke_smp_batch for optimizing")
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ziqian SUN <zsun@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceb0e273bd69..0e185763578b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -592,11 +592,12 @@ static void kprobe_optimizer(struct work_struct *work)
 	mutex_unlock(&module_mutex);
 	mutex_unlock(&text_mutex);
 	cpus_read_unlock();
-	mutex_unlock(&kprobe_mutex);
 
 	/* Step 5: Kick optimizer again if needed */
 	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
 		kick_kprobe_optimizer();
+
+	mutex_unlock(&kprobe_mutex);
 }
 
 /* Wait for completing optimization and unoptimization */

