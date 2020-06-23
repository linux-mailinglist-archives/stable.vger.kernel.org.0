Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E638205170
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbgFWL5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:57:41 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:38389 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732333AbgFWL5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:57:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E9F6FA08;
        Tue, 23 Jun 2020 07:57:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:57:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dDuH1H
        0V9u3pMDq/z1Hm52809nnWdTdnI8bDYbMEDbU=; b=E9m1LwdVCto9vmco86+7t/
        2nYyThnclYkTh6WSodjDmzTo+axhYm6kOyNZQpIz9pQQtbpLZkBgeT2f6HDBM2Vl
        0yvP3Sev5q2viSWZ051w03tqbKMAW1EnmahNoZwHVwXi+7MNzfHMLJ6vpYY5q7/b
        /Z0s22PYjQ7G+NEv/1b1k3jskxUWwm1fDrhN+mdNkDLu8l52KsfC/qzpaCVQ0tfd
        yXm0CozmPPElrmnIWxZE3ZLBp0iL1AlUKJG3h9Y5y67al2/DA1KSUEa8FadfsV52
        DgzjTeTige1hvcA3hD0EGleMqzils865SyhMK7e4JeP49qaWYrFxP97XWiV6I3uA
        ==
X-ME-Sender: <xms:M-7xXsCsxqODS0tO9yqI4653hfAhFXZStPiM-vmu2R69J4tsPFanDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M-7xXugpwkNxuMQRtLk8HJvTaE9_LgjXkmHeqNxdqwfQFAPxeQ0Kaw>
    <xmx:M-7xXvmfkhRj3fE2GgBmANmPXsJoMD10whs4ddnkciOYjsVwj4deJA>
    <xmx:M-7xXiw_lyrSZqS5qbyVbF2v7UNqyG4rXMkViwSDS9jzmZSR9LKEQQ>
    <xmx:M-7xXsF4_XKWqqhwcuRmFKYyOmNPSKSnecz_QfWuqwUHEBrQbg_Z7-OdygXLYWE0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21077328005D;
        Tue, 23 Jun 2020 07:57:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kprobes: Fix to protect kick_kprobe_optimizer() by" failed to apply to 4.9-stable tree
To:     mhiramat@kernel.org, anders.roxell@linaro.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        gustavoars@kernel.org, mingo@elte.hu, mingo@kernel.org,
        naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        rostedt@goodmis.org, zsun@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:57:26 +0200
Message-ID: <159291344624382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

