Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B096C1AA04D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393972AbgDOMZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:25:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38321 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409173AbgDOLpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:45:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5970F5C0181;
        Wed, 15 Apr 2020 07:45:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WMyrnH
        i4ZWfvyuD+1TmOibS/4igfZQsw5MUC8I/3ZeE=; b=FCNsKuDpUzL1Jz2nrUyMi0
        23G7btvCr1sJ6WofJRdekZ1YDprcwzN/K3RQ/CX2fuM9d4jGdwIlL9hKW/18LAs3
        ZBvApWGTUorb8nnGmT/jocqsvTn4zypEdXDpl49TjAHzjovh5SigNcAEnjtvBrUh
        rvNSOqug8sAyqAwS+nnvTisLLPylSffM7byH4Bem2Mz26QpgouYMfUOqRf6PItAM
        irvJzZxlAawOkYpwejPvyxTiPpbq4k0xBh96icrlzw1I6ogctq6GylVXeNNg6oZC
        rfPri/6QcEcbgNynbK48yTR5iSARsc7/SwqiaZL8XmN9Rf4ex9CbMI2loTjMcjrA
        ==
X-ME-Sender: <xms:2POWXn9cg3sGk9qpgGI8lQFfEO_xHjwZn9jT7yohlvM1_Cu23MZisg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2POWXiFmj1bEud1zDwnlFLoxZ-_PRWEr9vgiacH95mysU6WOGSkNrQ>
    <xmx:2POWXhDbp_CN24-Y_DA5pvSQp6mLAVCwzI-EBnROG-Y77a_xLl1cWg>
    <xmx:2POWXmk8ZNngleUnchdAaZLlOmKcy5SpWb5Kyle5TW5ZN0gDL_gCZw>
    <xmx:2POWXuIGVt0GZU2o2LpmsGp4B8xI1TSyRx7J1agTRB02wHF5irZLFA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2396328005A;
        Wed, 15 Apr 2020 07:45:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events" failed to apply to 4.14-stable tree
To:     mhiramat@kernel.org, rostedt@goodmis.org, treeze.taeung@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:45:26 +0200
Message-ID: <158695112664211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6a13a0d7b4d1171ef9b80ad69abc37e1daa941b3 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Tue, 24 Mar 2020 16:34:48 +0900
Subject: [PATCH] ftrace/kprobe: Show the maxactive number on kprobe_events

Show maxactive parameter on kprobe_events.
This allows user to save the current configuration and
restore it without losing maxactive parameter.

Link: http://lkml.kernel.org/r/4762764a-6df7-bc93-ed60-e336146dce1f@gmail.com
Link: http://lkml.kernel.org/r/158503528846.22706.5549974121212526020.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 696ced4fb1d76 ("tracing/kprobes: expose maxactive for kretprobe in kprobe_events")
Reported-by: Taeung Song <treeze.taeung@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 362cca52f5de..d0568af4a0ef 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1078,6 +1078,8 @@ static int trace_kprobe_show(struct seq_file *m, struct dyn_event *ev)
 	int i;
 
 	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
+	if (trace_kprobe_is_return(tk) && tk->rp.maxactive)
+		seq_printf(m, "%d", tk->rp.maxactive);
 	seq_printf(m, ":%s/%s", trace_probe_group_name(&tk->tp),
 				trace_probe_name(&tk->tp));
 

