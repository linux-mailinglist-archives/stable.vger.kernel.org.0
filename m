Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F512723D5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIUMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:25:03 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:49395 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbgIUMZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 08:25:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 09A4E1941591;
        Mon, 21 Sep 2020 08:25:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 08:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ie7V1E
        g9R61uteO2wbsos1FcRJAqO4pnBVoktQM5mqc=; b=DotcJGYVXVYTF6He6BOA/K
        XyXDg+8Igg2Vx+BfKhwkdFLo5ZsX27JcBDZQXndsD4lJ5qW64aFTk4IK2gF8W8qU
        U8qPFGBzjeeR8tcTLm0pFcyHiDlqsfDga1AWjN+Mq0KznH19yZ9dVYtn6pbmHj/D
        3RR/8pBDNbtWakVB60GzItWD0wv10PhgyyaXkEY2/X9gt7XisvAoyQKMOZvvwzOG
        I3AnJ7Dfhbc2ROa1M+mimXM1I3DWGFSwoY5QJxnRas3+ssE4tR8n+TzQGRL4cCFQ
        g5AZsFpYyNJEW1wh4QcTwBWIPyuWyeBd3TvM7GjNwR9Al2s0eUY9rNKKJaWjnggg
        ==
X-ME-Sender: <xms:nZtoX4Ah1s450qjH-v6Au24OOLxte6hgJyz8YLc-zf793ErgABfNpA>
    <xme:nZtoX6hfO51Z6VFZ2lDQaDgILIl84dyPM-H8lDtdoQwEgp7iPkGpWjU_nG0ZJdZCU
    aVbmWjs0BLhIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:nZtoX7kCeSBkHsviycD9mso6gmljxRfOBlXRtNfwZ1lwL2k-nniGbQ>
    <xmx:nZtoX-zKZ8H9fJ6WceVle7cASaK-cv52FcsDZWKC8pfg8CmqRXXZ5Q>
    <xmx:nZtoX9QyVY_hpK-z9ItCWgc6blW6l-E4KQPXAFImchfSMQwXydbxXA>
    <xmx:nptoX4ELQgTLcFPnLmcuRamMWMDPqDNOI9R4dVmB63BYKN9rQc8irfqrK3o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57332306467E;
        Mon, 21 Sep 2020 08:25:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kprobes: fix kill kprobe which has been marked as gone" failed to apply to 4.14-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        mhiramat@kernel.org, naveen.n.rao@linux.ibm.com,
        rostedt@goodmis.org, songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, zhouchengming@bytedance.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Sep 2020 14:25:21 +0200
Message-ID: <160069112122176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

