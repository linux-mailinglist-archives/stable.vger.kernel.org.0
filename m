Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0624300423
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbhAVN1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:27:08 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39395 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbhAVN1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:27:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 31EAD19F9;
        Fri, 22 Jan 2021 08:26:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 08:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nB39DK
        3oZp57FNmjym8gZXGLwCNjI6jujyESHy42Bp0=; b=UlWmuXnWlA8oz9c6kx/3ZU
        nuWnIaHhdEwACaMFwTkrIb/A8WgJp7ApoKIr96JFiUehYmzNzr/dFzJU+5Gp3DgZ
        dRPPZKfyVA3kAVZZwTtBt6qkt95BTMQ7LxMx1JAfn4gtCZAzKnb8TuCymNywbASm
        W44XWJ5xcsvjFqY0Psh+pJKwGxnoYZrRYukZTmIV0hvpO2rYNhhq9YqGbZaRZY8t
        HkdP9ikSVekdTIaO2E9Uu6DbULelpnn52pSiCjKT8+VLKG0UzYcjdFoPb5Gj1dva
        SzxFvf6wZr+CpYJrU/HtCTDDNmpOwXYuc3DjgifyygfCwCy0MJDvkPH+uKjEi1HA
        ==
X-ME-Sender: <xms:e9IKYDfrC0GBO6gOIz3_ge8JKmiG7AMcnKAxwyd19dBe3x2NneimZQ>
    <xme:e9IKYJOsEDj1Xb0Jbsaca_a6LV32Ly0dv_6wAt1Z10VKFaffdFthxsAr6lhbcx2jm
    GlDnLAGFeOQvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:e9IKYMjkCWPxGfZvK-yNRl0lqioZz_Ob6DuGhOil0blxJT5l9T6dTw>
    <xmx:e9IKYE-FBazu0RuGMxvL3Z31MO4nWNB_DP23adlluOFOGviSyXBG0w>
    <xmx:e9IKYPuANtc6PADs2AtOigOpfMOFjGnH2jJk6ltXdK4ekJ6yO2qglw>
    <xmx:e9IKYIVLRAshweMB3mfjMaRBAtfBLvFxQnGLmQYxs4Z6LIyUJpkOkGuKctw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 677B4108005B;
        Fri, 22 Jan 2021 08:26:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: ipv6: Validate GSO SKB before finish IPv6 processing" failed to apply to 4.9-stable tree
To:     ayal@nvidia.com, kuba@kernel.org, tariqt@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 14:26:09 +0100
Message-ID: <1611321969160123@kroah.com>
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

From b210de4f8c97d57de051e805686248ec4c6cfc52 Mon Sep 17 00:00:00 2001
From: Aya Levin <ayal@nvidia.com>
Date: Thu, 7 Jan 2021 15:50:18 +0200
Subject: [PATCH] net: ipv6: Validate GSO SKB before finish IPv6 processing

There are cases where GSO segment's length exceeds the egress MTU:
 - Forwarding of a TCP GRO skb, when DF flag is not set.
 - Forwarding of an skb that arrived on a virtualisation interface
   (virtio-net/vhost/tap) with TSO/GSO size set by other network
   stack.
 - Local GSO skb transmitted on an NETIF_F_TSO tunnel stacked over an
   interface with a smaller MTU.
 - Arriving GRO skb (or GSO skb in a virtualised environment) that is
   bridged to a NETIF_F_TSO tunnel stacked over an interface with an
   insufficient MTU.

If so:
 - Consume the SKB and its segments.
 - Issue an ICMP packet with 'Packet Too Big' message containing the
   MTU, allowing the source host to reduce its Path MTU appropriately.

Note: These cases are handled in the same manner in IPv4 output finish.
This patch aligns the behavior of IPv6 and the one of IPv4.

Fixes: 9e50849054a4 ("netfilter: ipv6: move POSTROUTING invocation before fragmentation")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/1610027418-30438-1-git-send-email-ayal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 749ad72386b2..077d43af8226 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -125,8 +125,43 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	return -EINVAL;
 }
 
+static int
+ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, unsigned int mtu)
+{
+	struct sk_buff *segs, *nskb;
+	netdev_features_t features;
+	int ret = 0;
+
+	/* Please see corresponding comment in ip_finish_output_gso
+	 * describing the cases where GSO segment length exceeds the
+	 * egress MTU.
+	 */
+	features = netif_skb_features(skb);
+	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	if (IS_ERR_OR_NULL(segs)) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	consume_skb(skb);
+
+	skb_list_walk_safe(segs, segs, nskb) {
+		int err;
+
+		skb_mark_not_on_list(segs);
+		err = ip6_fragment(net, sk, segs, ip6_finish_output2);
+		if (err && ret == 0)
+			ret = err;
+	}
+
+	return ret;
+}
+
 static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	unsigned int mtu;
+
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
@@ -135,7 +170,11 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
 	}
 #endif
 
-	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
+	mtu = ip6_skb_dst_mtu(skb);
+	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
+		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
+
+	if ((skb->len > mtu && !skb_is_gso(skb)) ||
 	    dst_allfrag(skb_dst(skb)) ||
 	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
 		return ip6_fragment(net, sk, skb, ip6_finish_output2);

