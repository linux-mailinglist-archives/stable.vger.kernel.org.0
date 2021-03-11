Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72816337C7E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhCKSYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:24:09 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43481 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhCKSXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:23:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2E8B91C05;
        Thu, 11 Mar 2021 13:23:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Nzc9Wo
        8YMf2CLEcbXCqrUohGSnMIH8F0FvHb5VjhqS4=; b=rK2xqBCjTGl9IG2LhIKigz
        BdZs62sxNeeqdSuXtdVp8NjeGEd3GZ7StlRHmskTtlDswJyN1CwuYR/X8v2NQQOY
        qyzsDLjuExT++Eow5sUjlj5W8hAYMl4AFc+td6p4Wb9oZWF5BwJy9EoHU2C5kBnm
        jwkKHqNX8OdaQjfIg51jUCpwTbmHSbeWJpBdXOHdYdLeyFDSDkslY1dfUbVEUIGB
        CaRCGBqBI7PQEZBlThfdBgk05A3+ZHWDz14GqsGldqEALXQwAq4Sx4J4UyEOjkS/
        sHG9jQze4nKe5mmiiTnS5LuExjwWkotWz7ptm31n/agyafzbf9YB+n6Fe051jE9g
        ==
X-ME-Sender: <xms:OWBKYN7rzA7hHBEPCiWd0K792qxTfteXazs6rIAZEwLfnA02_o61sw>
    <xme:OWBKYK79x6Wb7IrSN5sfvfpaN8_t8vFNeyMHkTJv_slVPJALf-RtoADtc3SiWOjBz
    FYZc_Xknnt0FQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvjeetgfegtdfhheehteetudeuudegvdduheffhf
    evvdekiedtudfhieektdevheenucffohhmrghinhepnhgvthhfihhlthgvrhdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OWBKYEev2fuXhnka4B3YamdBZbJS3bZ5eNbUVZz1gxdU9FL829-BSg>
    <xmx:OWBKYGLXgDu5VTcJMwcl5z07jwLwV9JkPRAdjiyZ_nOxde7yy0-Piw>
    <xmx:OWBKYBKF-d3MbCaV9FIFrywQJ4LETf9y57A1iKGd2bzEg9Wfn3sUWw>
    <xmx:OWBKYDzOfEEsXIdZSxPm2LB6eQA9Ln3EVIh0PLGnm8LjxZMItavEUBKSQqw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D8001080057;
        Thu, 11 Mar 2021 13:23:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: nf_nat: undo erroneous tcp edemux lookup" failed to apply to 4.4-stable tree
To:     fw@strlen.de, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:23:46 +0100
Message-ID: <1615487026179174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

