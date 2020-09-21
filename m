Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489682723D3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgIUMY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:24:59 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60903 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgIUMY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 08:24:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AA90819416D2;
        Mon, 21 Sep 2020 08:24:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 08:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JjgiNs
        f6N1AUmyw8J3BgqB7hIId0idgSUFZgCuQt3S8=; b=qZm82/JwIYFYg0/XE2ByYC
        ujaepJgVUbqf4X96Pw7kFzEGZqqPZX4nm7xjzWRN6I+GC3yhNL7Vrn+EfIzzBnrW
        uh0SYBcEhRZogyfPdk1ZuTLwIAAdkKomKXwoK7yLPV0K1WTNL2/s3COYoIWcleYj
        oqucBY1Srs+jZEiNN5cQklNwQsa0jorvsG6yuv5VsvOZyTGM2y3mSK0tyXhBgI4j
        43X3QN5jqaAqyrBjF6AXlwkRrBR/1O7xTJSmjjeMbm17Vz/L6XulBcZ3J6W6EAdO
        QT3PfUYr5BZGRD9apQHLkJnAr7CFgLT1RGF3vfwgO9vTs5eBpoqX6ZwX1FFqiqnw
        ==
X-ME-Sender: <xms:mptoXzAee4XvdtAY9YRDkCquELDi7QSSE4mA-q6keqnyVl7j6Q0eDA>
    <xme:mptoX5gWwS66mqljazI5TLBuulXvZKomM3J4th1Fd_2TVKvJbtRbVMcYJgkYIaXk7
    Z7ekE2E7nfkkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mptoX-mGA_4obnUaWEvsZeXdfpqwWzNt2AVZBEM8MeGyU2FPJxlPqw>
    <xmx:mptoX1wzZQTcioXrpcaWoVPb8SbUWk0fdREf6s5HQsxQODD1mRmlEw>
    <xmx:mptoX4RKTyj3Y1Mvn8GqHJamzumJ54Ym17hbVPK7TLB-EQMCNikeMw>
    <xmx:mptoX7H7NT-20mPYw2P41TdQtsp_k_V78akSqLmglt-3UmJn0Q8RpKabvG4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FA1C3064610;
        Mon, 21 Sep 2020 08:24:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kprobes: fix kill kprobe which has been marked as gone" failed to apply to 4.19-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, naveen.n.rao@linux.ibm.com,
        rostedt@goodmis.org, songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, zhouchengming@bytedance.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Sep 2020 14:25:20 +0200
Message-ID: <1600691120137153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From b0399092ccebd9feef68d4ceb8d6219a8c0caa05 Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 18 Sep 2020 21:20:21 -0700
Subject: [PATCH] kprobes: fix kill kprobe which has been marked as gone

If a kprobe is marked as gone, we should not kill it again.  Otherwise, we
can disarm the kprobe more than once.  In that case, the statistics of
kprobe_ftrace_enabled can unbalance which can lead to that kprobe do not
work.

Fixes: e8386a0cb22f ("kprobes: support probing module __exit function")
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200822030055.32383-1-songmuchun@bytedance.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 287b263c9cb9..049da84e1952 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2140,6 +2140,9 @@ static void kill_kprobe(struct kprobe *p)
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	if (WARN_ON_ONCE(kprobe_gone(p)))
+		return;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (kprobe_aggrprobe(p)) {
 		/*
@@ -2419,7 +2422,10 @@ static int kprobes_module_callback(struct notifier_block *nb,
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
-		hlist_for_each_entry(p, head, hlist)
+		hlist_for_each_entry(p, head, hlist) {
+			if (kprobe_gone(p))
+				continue;
+
 			if (within_module_init((unsigned long)p->addr, mod) ||
 			    (checkcore &&
 			     within_module_core((unsigned long)p->addr, mod))) {
@@ -2436,6 +2442,7 @@ static int kprobes_module_callback(struct notifier_block *nb,
 				 */
 				kill_kprobe(p);
 			}
+		}
 	}
 	if (val == MODULE_STATE_GOING)
 		remove_module_kprobe_blacklist(mod);

