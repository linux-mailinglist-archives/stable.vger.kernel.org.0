Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC3F66995
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfGLJGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:06:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40649 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfGLJGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 05:06:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8AE762235B;
        Fri, 12 Jul 2019 05:06:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 05:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bwj5bo
        hDgBY5bxVKnm+WeKQYQFCNSDAxJHsQ38S2k4w=; b=qNPHMJJlA/WLur7q4lxge1
        srTFF5rJZC5kgQzNpOCrh6hoGmI7sDcSsGYbGvbhZDwFqWcHGXTD/CGM03EnWB2w
        3zEcj1y5gZQlZIiA7LCwfRWUjd/T96POg/ZQacBV/z237tr34fDJrDq7d6K00eQA
        YtbawSnvU0+VROSNQgtCysnNnK9sw4CMfGgvdojtbccZiRqb4xIjArrwL2nBgL/v
        5zPEm4Yob+cTHgAoaxbTHCtKbK2fLLoup4WEiuXWRHqE9GMcDmDdc+ciWCYr0t3Z
        Ig4z9Vs0jeNVxCfggqgPWeqi5xuPc5IPSZp0H2q0BoVWQIXRXUerkVfqIrTxangw
        ==
X-ME-Sender: <xms:fk0oXSO8svURb00agdGVoBxuIRsYcLpI20IUIiYJNS8qKNrs63VIng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:fk0oXeVkg1grYXC-wbYdjCquwzkwkq1OI8_v70MAxtAdJRfDzGtSJw>
    <xmx:fk0oXQkrti4PPr_61opJon__gfjLOSVjcP0mVN4LEkdEHJAJH8UJ8Q>
    <xmx:fk0oXdPRRpyR7VJFPEH_vtWm-1dm_iKVjC8Jl75fH837t7FsuyN7Kg>
    <xmx:fk0oXSkzfU1T-EhcwZyUdi8gEq7IasblrO9Zhje5XlCplhNXIzHRRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05308380085;
        Fri, 12 Jul 2019 05:06:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coresight: etb10: Do not call smp_processor_id from" failed to apply to 4.9-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 11:05:59 +0200
Message-ID: <1562922359158251@kroah.com>
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

From 730766bae3280a25d40ea76a53dc6342e84e6513 Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Thu, 20 Jun 2019 16:12:36 -0600
Subject: [PATCH] coresight: etb10: Do not call smp_processor_id from
 preemptible

During a perf session we try to allocate buffers on the "node" associated
with the CPU the event is bound to. If it is not bound to a CPU, we
use the current CPU node, using smp_processor_id(). However this is unsafe
in a pre-emptible context and could generate the splats as below :

 BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544

Use NUMA_NO_NODE hint instead of using the current node for events
not bound to CPUs.

Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable <stable@vger.kernel.org> # 4.6+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
index d5b9edecf76e..3810290e6d07 100644
--- a/drivers/hwtracing/coresight/coresight-etb10.c
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -374,12 +374,10 @@ static void *etb_alloc_buffer(struct coresight_device *csdev,
 			      struct perf_event *event, void **pages,
 			      int nr_pages, bool overwrite)
 {
-	int node, cpu = event->cpu;
+	int node;
 	struct cs_buffers *buf;
 
-	if (cpu == -1)
-		cpu = smp_processor_id();
-	node = cpu_to_node(cpu);
+	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
 
 	buf = kzalloc_node(sizeof(struct cs_buffers), GFP_KERNEL, node);
 	if (!buf)

