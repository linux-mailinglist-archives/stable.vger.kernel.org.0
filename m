Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13720363506
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhDRMMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:12:33 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40871 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:12:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7594CB0C;
        Sun, 18 Apr 2021 08:12:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Eb/Wu3
        0D1EUuY/KB/e/eunTPNZTbnkvPalzkEPjWJTc=; b=Zq9W27OQLRHsi/FrZuTe1b
        BV7l+JHzqQVI5GOrWyn4kPgwETAxq1+ATpF6m2TFqu0r2bGlMbsUsToeezHhTsz/
        kY8Ik2x1K8/M6m8/A9/jRDCprr7lGbZXJUeeG5av3iJfvOeKgPbeebC+1f02yiOp
        MruU+Qn1OoBHItdU5c1mfyH9HT4aHsVJVeMeVKoMfILUr5GdOSJ/mbitAgyYg1oZ
        m+NHlFds8qvcOkIFA7AAlNzcnq3FSjEd6njzvPkvxPG2b/SqqcQfC+rn73+oMD/X
        uCP/6s9NQm0GSuKv0KJJ+tmmXmwNn3VkoTX2PwRpXAz64MpvEPrHBjPBrhJ/HmJg
        ==
X-ME-Sender: <xms:EiJ8YNSeAb_x4njgNxnqUhiuZ8xPrZlCZtF5TpSKws3CPdKORlwk9Q>
    <xme:EiJ8YGw0yVOwp6cEZdRB2iRzrVQHYqbUuM9z4zCUm4u_Tn6y4R7M1TcVFf1hZZwzV
    lzqB_KqW_2M6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:EiJ8YC2ytGTyeBWqP3KVVawFJZqpDgRhlJmOLKGdLjloT2BDJrRtbA>
    <xmx:EiJ8YFC3Y8VyxVPqvOAabTh-a8cxIYz6l7lRpizJGpZ56pnvkknhlQ>
    <xmx:EiJ8YGixKjxoLl0KUfpC6soDurtsO7GB92CYdUkpCiV6pGhoEzHSXw>
    <xmx:FCJ8YOIHwxHNhsqJ6aK-OFXGqMpfzVoLjXDAXJRiZCW8Q8v89SowV2-App8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B87024005C;
        Sun, 18 Apr 2021 08:12:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] netfilter: bridge: add pre_exit hooks for ebtable" failed to apply to 4.19-stable tree
To:     fw@strlen.de, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:12:00 +0200
Message-ID: <161874792013155@kroah.com>
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

From 7ee3c61dcd28bf6e290e06ad382f13511dc790e9 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 7 Apr 2021 21:43:39 +0200
Subject: [PATCH] netfilter: bridge: add pre_exit hooks for ebtable
 unregistration

Just like ip/ip6/arptables, the hooks have to be removed, then
synchronize_rcu() has to be called to make sure no more packets are being
processed before the ruleset data is released.

Place the hook unregistration in the pre_exit hook, then call the new
ebtables pre_exit function from there.

Years ago, when first netns support got added for netfilter+ebtables,
this used an older (now removed) netfilter hook unregister API, that did
a unconditional synchronize_rcu().

Now that all is done with call_rcu, ebtable_{filter,nat,broute} pernet exit
handlers may free the ebtable ruleset while packets are still in flight.

This can only happens on module removal, not during netns exit.

The new function expects the table name, not the table struct.

This is because upcoming patch set (targeting -next) will remove all
net->xt.{nat,filter,broute}_table instances, this makes it necessary
to avoid external references to those member variables.

The existing APIs will be converted, so follow the upcoming scheme of
passing name + hook type instead.

Fixes: aee12a0a3727e ("ebtables: remove nf_hook_register usage")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 2f5c4e6ecd8a..3a956145a25c 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -110,8 +110,9 @@ extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
 			      struct ebt_table **res);
-extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
-				 const struct nf_hook_ops *);
+extern void ebt_unregister_table(struct net *net, struct ebt_table *table);
+void ebt_unregister_table_pre_exit(struct net *net, const char *tablename,
+				   const struct nf_hook_ops *ops);
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index 66e7af165494..32bc2821027f 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -105,14 +105,20 @@ static int __net_init broute_net_init(struct net *net)
 				  &net->xt.broute_table);
 }
 
+static void __net_exit broute_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "broute", &ebt_ops_broute);
+}
+
 static void __net_exit broute_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.broute_table, &ebt_ops_broute);
+	ebt_unregister_table(net, net->xt.broute_table);
 }
 
 static struct pernet_operations broute_net_ops = {
 	.init = broute_net_init,
 	.exit = broute_net_exit,
+	.pre_exit = broute_net_pre_exit,
 };
 
 static int __init ebtable_broute_init(void)
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 78cb9b21022d..bcf982e12f16 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -99,14 +99,20 @@ static int __net_init frame_filter_net_init(struct net *net)
 				  &net->xt.frame_filter);
 }
 
+static void __net_exit frame_filter_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "filter", ebt_ops_filter);
+}
+
 static void __net_exit frame_filter_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_filter, ebt_ops_filter);
+	ebt_unregister_table(net, net->xt.frame_filter);
 }
 
 static struct pernet_operations frame_filter_net_ops = {
 	.init = frame_filter_net_init,
 	.exit = frame_filter_net_exit,
+	.pre_exit = frame_filter_net_pre_exit,
 };
 
 static int __init ebtable_filter_init(void)
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 0888936ef853..0d092773f816 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -99,14 +99,20 @@ static int __net_init frame_nat_net_init(struct net *net)
 				  &net->xt.frame_nat);
 }
 
+static void __net_exit frame_nat_net_pre_exit(struct net *net)
+{
+	ebt_unregister_table_pre_exit(net, "nat", ebt_ops_nat);
+}
+
 static void __net_exit frame_nat_net_exit(struct net *net)
 {
-	ebt_unregister_table(net, net->xt.frame_nat, ebt_ops_nat);
+	ebt_unregister_table(net, net->xt.frame_nat);
 }
 
 static struct pernet_operations frame_nat_net_ops = {
 	.init = frame_nat_net_init,
 	.exit = frame_nat_net_exit,
+	.pre_exit = frame_nat_net_pre_exit,
 };
 
 static int __init ebtable_nat_init(void)
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ebe33b60efd6..d481ff24a150 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1232,10 +1232,34 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	return ret;
 }
 
-void ebt_unregister_table(struct net *net, struct ebt_table *table,
-			  const struct nf_hook_ops *ops)
+static struct ebt_table *__ebt_find_table(struct net *net, const char *name)
+{
+	struct ebt_table *t;
+
+	mutex_lock(&ebt_mutex);
+
+	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&ebt_mutex);
+			return t;
+		}
+	}
+
+	mutex_unlock(&ebt_mutex);
+	return NULL;
+}
+
+void ebt_unregister_table_pre_exit(struct net *net, const char *name, const struct nf_hook_ops *ops)
+{
+	struct ebt_table *table = __ebt_find_table(net, name);
+
+	if (table)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+}
+EXPORT_SYMBOL(ebt_unregister_table_pre_exit);
+
+void ebt_unregister_table(struct net *net, struct ebt_table *table)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ebt_unregister_table(net, table);
 }
 

