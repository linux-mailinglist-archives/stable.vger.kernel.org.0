Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986D266993
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfGLJGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:06:01 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33887 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfGLJGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 05:06:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5657521B1B;
        Fri, 12 Jul 2019 05:06:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 12 Jul 2019 05:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z6bmpF
        xwvfRCxN6R9AKLzgbQf3DXt0lJl5PDKrfOn+E=; b=QcC9blPSgc5hXhJlabvQ3x
        fddRyAr3M1BjQmn3CsA0yr/ueGZCaDU6tNB96aKmpgWREV4bSj5Jt5jv3HPzoxsL
        nSOZuGZ4Ph7itk3PObJQocj2GmzRXlnpcwrnw35fGFV333Yyx9EO60tQfnUcN7z3
        xYFj5NpifrvX8XtokvOn+qCz/cgzt6QP0Ge3Yf89uDo8+WWNiAJI77GkTllSqkFu
        hjz/noKmK93B8YKqVXFlgyCn0CAY3qlO0EfL4Bb57wbLWwWumxOgQQeWaaxu0mJY
        iAdVXUqbB0e03r4ZguET1xlqVBbuOASjIRUWge+157ohSJJcdnNaiJMCgwVR2juQ
        ==
X-ME-Sender: <xms:eE0oXfkgbOzq_Nh24jJ-SKBoRQCHvI7mzzhC_1zT8H7fisY1hQPKSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedtgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:eE0oXVpPuvz_r_mKe5Tf5AWHRY3NN6SKPR6XXYyFte2yBF9cX_cYJA>
    <xmx:eE0oXbDe_t0WkPNquEwpouStxfm6RLJYzlfGiiBySDqXG6aPmoOyXA>
    <xmx:eE0oXVVwKPqJVUSMVTUE8DpHLiF5DchGehD-wAvlPZZA-QGigkyzgg>
    <xmx:eE0oXdhj8b1P5jsTzy1C-Uxo7UbqvR1deo7L9JW5GbuzOLVq_38dGA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC50A8005C;
        Fri, 12 Jul 2019 05:05:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] coresight: etb10: Do not call smp_processor_id from" failed to apply to 4.19-stable tree
To:     suzuki.poulose@arm.com, gregkh@linuxfoundation.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Jul 2019 11:05:56 +0200
Message-ID: <15629223562247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

