Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99E4249DD9
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgHSM3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:29:45 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52937 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgHSM3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:29:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 77F829CD;
        Wed, 19 Aug 2020 08:29:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0YOxsP
        2oLMk5NB76b6Sh2OXvwiGRnCsGRsakEREqn/4=; b=kfbkG9eKNRsRNKu4GPXNdI
        v6ZKTduuVdjaPN31srOXpDeZP9+P9XiJJvi9ese4aiYMlYNp1iRMaC+DMl4ZWr5S
        X+WecWKtn8kw7RQ2mp4veEMz6QGbImXBcAhTrg94V9inFNjsZflaF6sKTDr1Kjfr
        QegbDlBc2u6SLnK0rQiQoOVunsiQk5psCzgiplTJf7ioaWycNuyppB7hxI5T3OXS
        mPNwcI0j9Oxl4LVTHpI/T8zgwacRsmw+5mR8qjwRD2HzmjKNL7geXCh6PCTGxdpu
        vI6l/+/zR44HM/W4WYWIqYpj0hPV1+ae7X8OY6QO6ePI61dYAa41DWLBou3kVOmg
        ==
X-ME-Sender: <xms:Nhs9X5GZhAVcjWPB_Mfgh6tRryH5Ll6aE5BEJ9MOI7YNIId7d91blQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Nhs9X-XEDxOVxmgzDgEU1WlMIGBH_PdUvmG9PIw1ZsBiCcMY5luu8w>
    <xmx:Nhs9X7LrGFmRKkTPDrXFYws-0VKo7-AGFlhzVhaMcW3gMTC5kpgP5A>
    <xmx:Nhs9X_GyWTw49hPcEeuIbnwpV3772La4nNrEojItk5Keessjd0pxpw>
    <xmx:Nxs9XwcNob3UKAxuyHx9n0W52_gjFEb_wuBoxwTKQEjWOlUsmLW3EWj3o1c>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83BF5328005E;
        Wed, 19 Aug 2020 08:29:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing/hwlat: Honor the tracing_cpumask" failed to apply to 4.9-stable tree
To:     haokexin@gmail.com, mingo@redhat.com, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:30:05 +0200
Message-ID: <1597840205103185@kroah.com>
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

From 96b4833b6827a62c295b149213c68b559514c929 Mon Sep 17 00:00:00 2001
From: Kevin Hao <haokexin@gmail.com>
Date: Thu, 30 Jul 2020 16:23:18 +0800
Subject: [PATCH] tracing/hwlat: Honor the tracing_cpumask

In calculation of the cpu mask for the hwlat kernel thread, the wrong
cpu mask is used instead of the tracing_cpumask, this causes the
tracing/tracing_cpumask useless for hwlat tracer. Fixes it.

Link: https://lkml.kernel.org/r/20200730082318.42584-2-haokexin@gmail.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 0330f7aa8ee6 ("tracing: Have hwlat trace migrate across tracing_cpumask CPUs")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index ddb528a6cd51..17873e5d0353 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -283,6 +283,7 @@ static bool disable_migrate;
 static void move_to_next_cpu(void)
 {
 	struct cpumask *current_mask = &save_cpumask;
+	struct trace_array *tr = hwlat_trace;
 	int next_cpu;
 
 	if (disable_migrate)
@@ -296,7 +297,7 @@ static void move_to_next_cpu(void)
 		goto disable;
 
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	next_cpu = cpumask_next(smp_processor_id(), current_mask);
 	put_online_cpus();
 
@@ -372,7 +373,7 @@ static int start_kthread(struct trace_array *tr)
 
 	/* Just pick the first CPU on first iteration */
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	put_online_cpus();
 	next_cpu = cpumask_first(current_mask);
 

