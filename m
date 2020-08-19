Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C0249F76
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgHSNUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:20:49 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41035 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728306AbgHSNUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:20:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B0F27BE3;
        Wed, 19 Aug 2020 09:19:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tfj8ws
        lJEWc3496wgUlAFR3KTyJPu/JgSOgR+YG9SU4=; b=A/Sh4V3lb4LDp8d0VJOKW2
        etlC9WHEU/XNoAIrAEItGB5nfO66miqgcV8nB+e2OPCPcyd01lWRfdKaC+5kHr9y
        9bs9h0PJ247hCMDYRIFBnyE72jfgZz1fzUp0O3V/uhXe/JMeafWqABmENlz/zK2U
        yX27itt7/9E8QcCr8sdJg9sYQJFm7mPOSZ1QvzCtSUzwjaCEkkXlLPTwJjIFYMby
        O0EdCXeUd6xnmLpJCc91/LRfdfUwF7w6jSncL8/QgPO/+kMglkOh5qY4pOl5IGS8
        Wkzz0Tcd47Hj79MQcbR3ar4h0fsmJSMciwDjxJ9LnbjIaF3aYI3MX3tZdz8dJK1Q
        ==
X-ME-Sender: <xms:1iY9X557QRG6qtWbi-y85U0zRO2sBmaJdoDHR6MvuoUIrJpqnMf1lA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepueelleetteehudfgffeujedtgeehueekgfdtvdegle
    ekgfegudffteffveetueejnecuffhomhgrihhnpehnthgvvhhsrdhinhdpkhgvrhhnvghl
    rdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpe
    dunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1iY9X26yj2_7Te1pitHtwOhF1ABpxxv62Ljo-YZUoz01TmVAgQMP3Q>
    <xmx:1iY9XwclRnN6KS6dqlgc-HsnLNvtdE3S2ugA57G0LauTPeTAg1_5zg>
    <xmx:1iY9XyJ6eZPy-PB88DEFi0c-_Xg3eXeKJjJrv02Z0yO0WYHJAJBLTw>
    <xmx:1iY9X0XmUFwvlftzTCP42x9V-EipakRCOaG_30QJaD_g55GEPvWC5m4rA_o>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5A043280060;
        Wed, 19 Aug 2020 09:19:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf probe: Fix memory leakage when the probe point is not" failed to apply to 4.9-stable tree
To:     mhiramat@kernel.org, acme@redhat.com, ak@linux.intel.com,
        oleg@redhat.com, srikar@linux.vnet.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:19:39 +0200
Message-ID: <159784317962126@kroah.com>
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

From 12d572e785b15bc764e956caaa8a4c846fd15694 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Fri, 10 Jul 2020 22:11:23 +0900
Subject: [PATCH] perf probe: Fix memory leakage when the probe point is not
 found

Fix the memory leakage in debuginfo__find_trace_events() when the probe
point is not found in the debuginfo. If there is no probe point found in
the debuginfo, debuginfo__find_probes() will NOT return -ENOENT, but 0.

Thus the caller of debuginfo__find_probes() must check the tf.ntevs and
release the allocated memory for the array of struct probe_trace_event.

The current code releases the memory only if the debuginfo__find_probes()
hits an error but not checks tf.ntevs. In the result, the memory allocated
on *tevs are not released if tf.ntevs == 0.

This fixes the memory leakage by checking tf.ntevs == 0 in addition to
ret < 0.

Fixes: ff741783506c ("perf probe: Introduce debuginfo to encapsulate dwarf information")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/159438668346.62703.10887420400718492503.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9963e4e8ea20..659024342e9a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1467,7 +1467,7 @@ int debuginfo__find_trace_events(struct debuginfo *dbg,
 	if (ret >= 0 && tf.pf.skip_empty_arg)
 		ret = fill_empty_trace_arg(pev, tf.tevs, tf.ntevs);
 
-	if (ret < 0) {
+	if (ret < 0 || tf.ntevs == 0) {
 		for (i = 0; i < tf.ntevs; i++)
 			clear_probe_trace_event(&tf.tevs[i]);
 		zfree(tevs);

