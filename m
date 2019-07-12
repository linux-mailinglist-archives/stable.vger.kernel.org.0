Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22C566996
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfGLJGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:06:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41171 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfGLJGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 05:06:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A6F322377;
        Fri, 12 Jul 2019 05:06:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 05:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/bVqRE
        UqYzTx32SIRXI/UafYJ1qgpCFnWmq+0MT07p8=; b=j9O2te/TKwt55pFsNwKFJA
        Gr94EXJTQUUWXVb5Nx4Y3G5dUKKcshRX6eIUQLNEbPP56jPuWsL+yRqfErutpfyU
        TXr18DqEmVGQgbmY01E6EtZ1GTEwE4I6blF0X01OuwEgxYFCQXI1L62WdDER1aVz
        BPgKR1U3ffywSn1r0ApvAF83xqOJj0sqdEaUk2RAMZfaSP0PaoRpJeu3DYOu6R4d
        QLGS9Loblx0ltj6Jbu7P1QPMk1OMpKaVfvBK4I+w9x8OEYFfpQ6I+E+s5F1njhzN
        av8aADarnneuVV6wzqfwIBBArfVMSlCUPTf27n+EFE0cFN6EQDw9X+Rr8YWlh+lg
        ==
X-ME-Sender: <xms:oU0oXdJm_a9AMNCqP7gYGiWCdgTrBNI4G3xIE8hn7U-3x2eiYlh-Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:oU0oXeBKr_uPs-W19RhjZjpI1u8qEvGsk1EF_-88XwYbPZWTsutgow>
    <xmx:oU0oXeRptCC1v7n4w9pleNzw42Uxil3DCNxGn_IRa458FpazGPOghg>
    <xmx:oU0oXfo8JzbjFMLBlTCWYsf3FirF-BxjVpbCOWFttfa4UUnxdAel-Q>
    <xmx:oU0oXXUy0xsaSXj-Ekxo2fQxdyS1TbqUzPEhmTlDVN4rXcvLL3yBiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4F63380076;
        Fri, 12 Jul 2019 05:06:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coresight: tmc-etr: alloc_perf_buf: Do not call" failed to apply to 5.1-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 11:06:39 +0200
Message-ID: <1562922399190180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a8710392db2c70f74aed6f06b16e8bec0f05a35 Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Thu, 20 Jun 2019 16:12:34 -0600
Subject: [PATCH] coresight: tmc-etr: alloc_perf_buf: Do not call
 smp_processor_id from preemptible

During a perf session we try to allocate buffers on the "node" associated
with the CPU the event is bound to. If it is not bound to a CPU, we
use the current CPU node, using smp_processor_id(). However this is unsafe
in a pre-emptible context and could generate the splats as below :

 BUG: using smp_processor_id() in preemptible [00000000] code: perf/1743
 caller is tmc_alloc_etr_buffer+0x1bc/0x1f0
 CPU: 1 PID: 1743 Comm: perf Not tainted 5.1.0-rc6-147786-g116841e #344
 Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
 Call trace:
  dump_backtrace+0x0/0x150
  show_stack+0x14/0x20
  dump_stack+0x9c/0xc4
  debug_smp_processor_id+0x10c/0x110
  tmc_alloc_etr_buffer+0x1bc/0x1f0
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

Fixes: 22f429f19c4135d51e9 ("coresight: etm-perf: Add support for ETR backend")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable <stable@vger.kernel.org> # 4.20+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190620221237.3536-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 7c81f634ecb4..5d2bf6d18961 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -1184,14 +1184,11 @@ static struct etr_buf *
 alloc_etr_buf(struct tmc_drvdata *drvdata, struct perf_event *event,
 	      int nr_pages, void **pages, bool snapshot)
 {
-	int node, cpu = event->cpu;
+	int node;
 	struct etr_buf *etr_buf;
 	unsigned long size;
 
-	if (cpu == -1)
-		cpu = smp_processor_id();
-	node = cpu_to_node(cpu);
-
+	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
 	/*
 	 * Try to match the perf ring buffer size if it is larger
 	 * than the size requested via sysfs.

