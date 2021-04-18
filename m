Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15A936350D
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhDRMQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:16:15 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42109 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhDRMQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:16:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C8AA31AEA;
        Sun, 18 Apr 2021 08:15:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=V9GxRx
        DZvrf/izqrjYtiQfCcq9RWIVfLfaRVHbzy/eM=; b=kzGAXMTShzHoFFGBY/N6j7
        CeV/cS7cZ7/TRMtnoIeK7Onx3gCvrSm5RCf4TBHYxbaHz+aSszWuHAExNH9Ih/rN
        AnfvkgzGQUqUUZ9h/OvIn9o8HkxYZMUBTuzzgz7gQUy41L0VjdWiR/BWWqmAgKlx
        6FZbsf42Lz77TvznAptNOGaphMjH4EYF6D8B6bCfHVtqtcsRAl4FH3Ucu1Wy/+i4
        VtV/N3hGxKk2CYGjmfFemBB01CRosr0xn7YJgwR4QiXQO2dnitrS5oK7vGKuz2cg
        UBFPEPEjsikcP5IZl1Rs/baFKKYUTlqHP/tgemk8n/QGkE/F+HsQHQ0+PhP2rQew
        ==
X-ME-Sender: <xms:8SJ8YHAvZnZYawFtxvSi-WszyQPjLLjja_jPn4lsl4ur2Sg0Z5xMCQ>
    <xme:8SJ8YNjuVlsHaquZeQEaoOSoPKeA7R8ywasRbQSGLgcg1Y1qmncTh3CBbyKQiXgvK
    AGqds_ut38hqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8SJ8YCkaGnWvH2IKI7sHtPIz1If4Fsswrai7hiQdBZFEHslIqmBcXg>
    <xmx:8SJ8YJxlTUAoqi29pDiyMEKvda93RbRS9Z5ZcbNSU_BHaLOBpGWBSA>
    <xmx:8SJ8YMQvUhoiTzSdI0LNyfBeyUB77admV22LiZp82PPnKin-AS1k0w>
    <xmx:8iJ8YF7z1rUZ93ubUFOfMNwxpgA9-qzLRa_wZ3UVHaO4GK1exPrwDYUQh3U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 597B1108005F;
        Sun, 18 Apr 2021 08:15:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] netfilter: arp_tables: add pre_exit hook for table unregister" failed to apply to 4.9-stable tree
To:     fw@strlen.de, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:15:43 +0200
Message-ID: <161874814314175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d163a925ebbc6eb5b562b0f1d72c7e817aa75c40 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 7 Apr 2021 21:43:40 +0200
Subject: [PATCH] netfilter: arp_tables: add pre_exit hook for table unregister

Same problem that also existed in iptables/ip(6)tables, when
arptable_filter is removed there is no longer a wait period before the
table/ruleset is free'd.

Unregister the hook in pre_exit, then remove the table in the exit
function.
This used to work correctly because the old nf_hook_unregister API
did unconditional synchronize_net.

The per-net hook unregister function uses call_rcu instead.

Fixes: b9e69e127397 ("netfilter: xtables: don't hook tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 7d3537c40ec9..26a13294318c 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -52,8 +52,9 @@ extern void *arpt_alloc_initial_table(const struct xt_table *);
 int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops);
+void arpt_unregister_table(struct net *net, struct xt_table *table);
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d1e04d2b5170..6c26533480dd 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1539,10 +1539,15 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table(struct net *net, struct xt_table *table,
-			   const struct nf_hook_ops *ops)
+void arpt_unregister_table_pre_exit(struct net *net, struct xt_table *table,
+				    const struct nf_hook_ops *ops)
 {
 	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
+
+void arpt_unregister_table(struct net *net, struct xt_table *table)
+{
 	__arpt_unregister_table(net, table);
 }
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c216b9ad3bb2..6c300ba5634e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -56,16 +56,24 @@ static int __net_init arptable_filter_table_init(struct net *net)
 	return err;
 }
 
+static void __net_exit arptable_filter_net_pre_exit(struct net *net)
+{
+	if (net->ipv4.arptable_filter)
+		arpt_unregister_table_pre_exit(net, net->ipv4.arptable_filter,
+					       arpfilter_ops);
+}
+
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
 	if (!net->ipv4.arptable_filter)
 		return;
-	arpt_unregister_table(net, net->ipv4.arptable_filter, arpfilter_ops);
+	arpt_unregister_table(net, net->ipv4.arptable_filter);
 	net->ipv4.arptable_filter = NULL;
 }
 
 static struct pernet_operations arptable_filter_net_ops = {
 	.exit = arptable_filter_net_exit,
+	.pre_exit = arptable_filter_net_pre_exit,
 };
 
 static int __init arptable_filter_init(void)

