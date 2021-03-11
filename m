Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3652337C79
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCKSYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:24:09 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58511 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230158AbhCKSXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:23:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CFCAC1C0F;
        Thu, 11 Mar 2021 13:23:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:23:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EZtw1Y
        Jl0yhbCnl91jwFdperNqUqfZ7O5Hcks77F+z0=; b=wnFJpb99sHxbWKbG5v68nF
        vSmabLR1N+Vq2zGpLjVv5/n6ndNoVriGoFCPqZIPFI2cls0F0bOyyEyvO+ajsOhY
        DywF20qxhWmYnmA8hRqk/+0V2VMK68eEB4EKefH1ESOtIi50PeKWjmYtR5DuV0Pe
        Cw8XEBJMn7M3BGd3TdlTh2oCizAZ8LI0ZfTxWjF2HfTHaeAzonEhH6xdK5sar/Ft
        c1ZUydzsBjKI0kg9U7WbhbkPWUUtzi7qTb3QvPaimyiWQHzvxS4jv5T24qoLQA2j
        SqJ8ZwkgTQzfkWP3Jx4OKPnkLosb3eZfQUoaQMjwEsr7fTMoU8Kn9sOKeoUWwivQ
        ==
X-ME-Sender: <xms:NWBKYDX53C6DJ2H9nhBnhtWL8br5XiNYw9LmGf3UTL7mzTafBGI31A>
    <xme:NWBKYCegBEr7Sc0OllFLpVyqwwcqmmz-qkgrKL9MxZy-hRRN4_sdd-wQO3q3hwj3-
    RG_YxutgOZL3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvjeetgfegtdfhheehteetudeuudegvdduheffhf
    evvdekiedtudfhieektdevheenucffohhmrghinhepnhgvthhfihhlthgvrhdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NWBKYHvN4cRlZG3vS_3grwayi8pmuCCAH9pvi3LzCRp7Gf187Ynkog>
    <xmx:NWBKYJ8pxk-O9Jg2TIxMl1Ou9FwzgqMkNJAe9F6RWDgL4K1hLSR6Hg>
    <xmx:NWBKYK1PbnbmMwxWLVEW2xHVfbjpGB3nFgrncFdWvLTPh930tjd_EA>
    <xmx:NWBKYMqbOsjNezo6wbvEwBdJgyqbJYOrWYj6v5y7hgRA3f5i9OLdcx0ygek>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03F8724005B;
        Thu, 11 Mar 2021 13:23:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: nf_nat: undo erroneous tcp edemux lookup" failed to apply to 4.9-stable tree
To:     fw@strlen.de, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:23:45 +0100
Message-ID: <1615487025137151@kroah.com>
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

From 03a3ca37e4c6478e3a84f04c8429dd5889e107fd Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 24 Feb 2021 17:23:19 +0100
Subject: [PATCH] netfilter: nf_nat: undo erroneous tcp edemux lookup

Under extremely rare conditions TCP early demux will retrieve the wrong
socket.

1. local machine establishes a connection to a remote server, S, on port
   p.

   This gives:
   laddr:lport -> S:p
   ... both in tcp and conntrack.

2. local machine establishes a connection to host H, on port p2.
   2a. TCP stack choses same laddr:lport, so we have
   laddr:lport -> H:p2 from TCP point of view.
   2b). There is a destination NAT rewrite in place, translating
        H:p2 to S:p.  This results in following conntrack entries:

   I)  laddr:lport -> S:p  (origin)  S:p -> laddr:lport (reply)
   II) laddr:lport -> H:p2 (origin)  S:p -> laddr:lport2 (reply)

   NAT engine has rewritten laddr:lport to laddr:lport2 to map
   the reply packet to the correct origin.

   When server sends SYN/ACK to laddr:lport2, the PREROUTING hook
   will undo-the SNAT transformation, rewriting IP header to
   S:p -> laddr:lport

   This causes TCP early demux to associate the skb with the TCP socket
   of the first connection.

   The INPUT hook will then reverse the DNAT transformation, rewriting
   the IP header to H:p2 -> laddr:lport.

Because packet ends up with the wrong socket, the new connection
never completes: originator stays in SYN_SENT and conntrack entry
remains in SYN_RECV until timeout, and responder retransmits SYN/ACK
until it gives up.

To resolve this, orphan the skb after the input rewrite:
Because the source IP address changed, the socket must be incorrect.
We can't move the DNAT undo to prerouting due to backwards
compatibility, doing so will make iptables/nftables rules to no longer
match the way they did.

After orphan, the packet will be handed to the next protocol layer
(tcp, udp, ...) and that will repeat the socket lookup just like as if
early demux was disabled.

Fixes: 41063e9dd1195 ("ipv4: Early TCP socket demux.")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1427
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index e87b6bd6b3cd..4731d21fc3ad 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -646,8 +646,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
@@ -659,6 +659,23 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
+static unsigned int
+nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	__be32 saddr = ip_hdr(skb)->saddr;
+	struct sock *sk = skb->sk;
+	unsigned int ret;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+
+	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
+	    !inet_sk_transparent(sk))
+		skb_orphan(skb); /* TCP edemux obtained wrong socket */
+
+	return ret;
+}
+
 static unsigned int
 nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 		const struct nf_hook_state *state)
@@ -736,7 +753,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
-		.hook		= nf_nat_ipv4_in,
+		.hook		= nf_nat_ipv4_pre_routing,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
@@ -757,7 +774,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	},
 	/* After packet filtering, change source */
 	{
-		.hook		= nf_nat_ipv4_fn,
+		.hook		= nf_nat_ipv4_local_in,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,

