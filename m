Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C26A7332
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfICTIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:08:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58101 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfICTIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:08:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BEA6222CA;
        Tue,  3 Sep 2019 15:08:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 15:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=r4warM
        qICFTeOT9NB0tdJXGXkmy/thulVmj+4mm33OI=; b=SrvcPlGGrlTrWEgb5FEXi5
        BoUXfMN7DVRtjkawv1uwE8vmkQeBDiTGDh9SaltWqLY1i77YOXGbA7KnF0VYXgkB
        RKFFXykq0XxEcfRpfjmqyBMOSxsepbIA+Ygp6+kLFWSMm9cldQXopGgRJ8uJIwNA
        T+bOcWKkWfxEQ0nVDeI2UC1Hzt73gIEICUwZ74ezaH6h1jDXDnTtkcdXEKNyn06B
        CT2ujaUmQ0HN8+kYhiJJTBE59Lhf0wmXyAv4UZHG0ux/ryqLYXHbVV5e9UeAxWw+
        TFVN3YH95bRK80CpAxUo2Zile1qDYaSJhnueT3YgNFsu4+sQVrVjnk+l7CgM9fEg
        ==
X-ME-Sender: <xms:JLpuXet7nB39ZwxqE2wSvpsqTfS51BGIkpMu7nS5uIy9GpT6C_mXrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:JLpuXcIyCawwjCIWtG_wur7OzhnA1d667p0mtkU-H_wf9Ql-Hp7wsw>
    <xmx:JLpuXZt94n05qRcNRhSjtlez5ZdRizgmmyYCltNyAu3lw_bMHfHO4w>
    <xmx:JLpuXVu1jhia3lXr6aOfXKwcBWvP0FtBhy7VNkKBSHf-6IV9fHn7aQ>
    <xmx:J7puXZq9fEbQ4KnDWNdMnKuTHkxEPR3sZLA6J0vBQJBQ7H8nUA8Vjg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31AF1D6005D;
        Tue,  3 Sep 2019 15:08:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush" failed to apply to 5.2-stable tree
To:     shakeelb@google.com, akpm@linux-foundation.org, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 21:08:18 +0200
Message-ID: <156753769868234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c1c280805ded72eceb2afc1a0d431b256608554 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb@google.com>
Date: Fri, 30 Aug 2019 16:04:53 -0700
Subject: [PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush

Instead of using raw_cpu_read() use per_cpu() to read the actual data of
the corresponding cpu otherwise we will be reading the data of the
current cpu for the number of online CPUs.

Link: http://lkml.kernel.org/r/20190829203110.129263-1-shakeelb@google.com
Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releasing memcg")
Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasing memcg")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a247cb163245..9ec5e12486a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3278,7 +3278,7 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg, bool slab_only)
 
 	for_each_online_cpu(cpu)
 		for (i = min_idx; i < max_idx; i++)
-			stat[i] += raw_cpu_read(memcg->vmstats_percpu->stat[i]);
+			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = min_idx; i < max_idx; i++)
@@ -3296,8 +3296,8 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg, bool slab_only)
 
 		for_each_online_cpu(cpu)
 			for (i = min_idx; i < max_idx; i++)
-				stat[i] += raw_cpu_read(
-					pn->lruvec_stat_cpu->count[i]);
+				stat[i] += per_cpu(
+					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
 			for (i = min_idx; i < max_idx; i++)
@@ -3316,8 +3316,8 @@ static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
 
 	for_each_online_cpu(cpu)
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
-			events[i] += raw_cpu_read(
-				memcg->vmstats_percpu->events[i]);
+			events[i] += per_cpu(memcg->vmstats_percpu->events[i],
+					     cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)

