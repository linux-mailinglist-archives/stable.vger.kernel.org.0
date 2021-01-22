Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33940300422
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbhAVN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:27:00 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51169 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbhAVN07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:26:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7089017B1;
        Fri, 22 Jan 2021 08:26:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 08:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=10dc5T
        BmWkclHLLwxQyt9/NIDqHlDY+le4/BSdtdK2c=; b=LTGeVgZnEbnII+XQmV45LF
        3dsIbKFPIYfuFBfM7GndoSWBKGxCV1k4dJddbzHGWz9vr+iOP+p0jEj4SanknK3X
        1Swr57U5fecxLxOsKLco8muXRzgOW28P0OrBcDbOM9tNYAhWqJbsq1hhyldHAokv
        a6zDA0uLko38J0mK5ryk4d0rqqUabDyNtyrDeoyLwH1n/U33/wmtxOGOrjDLMC1G
        oqoqa1JOftoyrR6KIyiiFfQJ9sSrIYUtEsu1xN7UKu0j/VIUO28XP1V5EOJ+xuMe
        jIq7+ltCvKpydBhQklSahiCVpzqEqgHEpyhHhY7mx14H/Mi2IgN8G20xvhiovUzA
        ==
X-ME-Sender: <xms:ctIKYMC2_0toAfUjH5BGkF4ZJ4hK6CsMYMLhTZevUky-Uvuwpi1idQ>
    <xme:ctIKYOhrB1vDwzuwxeWac_qKAKuAajR-Gjhok7dkF5snKdcdsmiSBCoKNBpxsCW94
    bxduZa_g2ue1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ctIKYPm5Ww5k3rW3ch1Vd7H1k2UPdNQT_lFovVwxRez85vPXceLFgg>
    <xmx:ctIKYCxRkyrui4ViGykf0gIbpGlOQP6WucU0cnf1uYjcrP-I4oMADA>
    <xmx:ctIKYBTcerR0PBSVpMj8maHgbPj4S15XCUL-9RQOMG_XSO5YfM_tLw>
    <xmx:c9IKYALWGieVo-lR9Xpj7lSGUq4pgueomwEc0xRCs5dfy_8-L1bAMdQtc4w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93E10240057;
        Fri, 22 Jan 2021 08:26:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: ipv6: Validate GSO SKB before finish IPv6 processing" failed to apply to 4.4-stable tree
To:     ayal@nvidia.com, kuba@kernel.org, tariqt@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jan 2021 14:26:08 +0100
Message-ID: <161132196819254@kroah.com>
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

