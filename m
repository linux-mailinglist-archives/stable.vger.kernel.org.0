Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4A56699A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfGLJHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:07:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46361 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfGLJHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 05:07:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C4B362094D;
        Fri, 12 Jul 2019 05:07:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 05:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qEjZpq
        5tPCi92qS9B3L8xFo82dVb58L9wv+sJTCpyl0=; b=18kxeEvXRU4mf5q102HsZI
        LEGa0+0nFMbojTP/Of77b+CgeJouh0vqOgwNGcgS64/30l2pkL7r4rFFVE3KPseX
        kBRrzCG7VPZrX7jgndGW3pUwmh6Aql14Xiy4sCrUu5qEzPzyCUOmU9TWgrPUs9jn
        sbKznXOje3OwEVuKToYS3YbqU/itG0EZBtFOuNLFJDYhlynkk5gQ8Lle++jmxSIY
        D9g+/oUJyY4ZrSs9FeVmgbwioQppQJpzAqtV0s992SDfqFp+MPLlqWPqgrOiq/cM
        6NQ4qJG1CkpdeNFDZR82LMWgDign85Kax0/iDy1NGyb840+cgtKNWyde9wRnre7Q
        ==
X-ME-Sender: <xms:wE0oXf_-xU0xKmzmvDlqwFIsqLjLwSc6u5COysW7iOIf8TOkXAL-xQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:wE0oXRPMGYD2Tzn0OR6bOIvZup6liNSOdIgGuS4H6fZIx0boS9U2Mw>
    <xmx:wE0oXVWN87UXZU0Eiv-ZYyHc17rDxnK-DJBWHFHyl_ujA4gx0rQHSA>
    <xmx:wE0oXZhKwOVOTBlvGu2Gir4gaYIoIbu2E6C6hciNjSYsgtxrWK8FXw>
    <xmx:wE0oXWpnXTJI5nLjkGAg5babXmCN1jEC7BsUYMXqhGgtCdj3OYvRUQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C078380084;
        Fri, 12 Jul 2019 05:07:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coresight: tmc-etf: Do not call smp_processor_id from" failed to apply to 4.14-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 11:07:10 +0200
Message-ID: <1562922430194231@kroah.com>
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

From 024c1fd9dbcc1d8a847f1311f999d35783921b7f Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Thu, 20 Jun 2019 16:12:35 -0600
Subject: [PATCH] coresight: tmc-etf: Do not call smp_processor_id from
 preemptible

During a perf session we try to allocate buffers on the "node" associated
with the CPU the event is bound to. If it is not bound to a CPU, we
use the current CPU node, using smp_processor_id(). However this is unsafe
in a pre-emptible context and could generate the splats as below :

 BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
 caller is tmc_alloc_etf_buffer+0x5c/0x60
 CPU: 2 PID: 2544 Comm: perf Not tainted 5.1.0-rc6-147786-g116841e #344
 Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
 Call trace:
  dump_backtrace+0x0/0x150
  show_stack+0x14/0x20
  dump_stack+0x9c/0xc4
  debug_smp_processor_id+0x10c/0x110
  tmc_alloc_etf_buffer+0x5c/0x60
  etm_setup_aux+0x1c4/0x230
  rb_alloc_aux+0x1b8/0x2b8
  perf_mmap+0x35c/0x478
  mmap_region+0x34c/0x4f0
  do_mmap+0x2d8/0x418
  vm_mmap_pgoff+0xd0/0xf8
  ksys_mmap_pgoff+0x88/0xf8
  __arm64_sys_mmap+0x28/0x38
  el0_svc_handler+0xd8/0x138
  el0_svc+0x8/0xc

Use NUMA_NO_NODE hint instead of using the current node for events
not bound to CPUs.

Fixes: 2e499bbc1a929ac ("coresight: tmc: implementing TMC-ETF AUX space API")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable <stable@vger.kernel.org> # 4.7+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190620221237.3536-4-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index b89e29c5b39d..23b7ff00af5c 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -377,12 +377,10 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev,
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
 
 	/* Allocate memory structure for interaction with Perf */
 	buf = kzalloc_node(sizeof(struct cs_buffers), GFP_KERNEL, node);

