Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471E9394C8D
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhE2Oxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 10:53:37 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:53597 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhE2Oxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 10:53:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 57DB3194079F;
        Sat, 29 May 2021 10:52:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 29 May 2021 10:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rB271+
        4DzDg0li1W+MhGVPl/LnQuk0i+ai6K306Dbck=; b=UNkbYPA30806PTICpdTAHC
        jWe5HVKuqg66VkxpAwgX3GXY4jfaJt3y04JmzDJSCdJUB7B62opUBEucvCy28weE
        DuSRfHTFVC9U4lC34uOAwHJ2nzxVarPRuPRpEdc03sG8sTM4RVSxFJwUu6/fDjtr
        MuwcI5wowpy/HHWMqE2dCr7jnn2RP3W+iVHGecxizlWAQlhdj05KBGWqLpEYN5r8
        81wAWo32asv1wvwFzdU9zsYkC0oNmu/NR+A/hKqKdaXBU4dXm36dGzhEy6v8kzli
        hgRyQGpYMm/vaEr4BpCRlm02XTEuLmoJVa1kMK7M3bMRj3lBk9tbQUC/KbwozHJQ
        ==
X-ME-Sender: <xms:EFWyYPUvg0EYQZSHfDqNq3Cc36DqDAI4T4vcL6sQVOo49gNWfjVq9A>
    <xme:EFWyYHmlw7UkXp8Q83z3CpLIvwXQpcYSUP-t-n7Nr2sKQd9bqdGHU9JPwx4X3h4SJ
    MskuArqGEhu1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EFWyYLaC5Juu1el0thLcVfwgXbpi9O4XY0TNCOK1vIJsdcC1ylnzUA>
    <xmx:EFWyYKWXZkYhkHYH02OGJ_-gzxH_Yc5AEglRRCgGJWwTEwqvm4Ikuw>
    <xmx:EFWyYJmTTESc8kbcK0m--OjkVh8J-YYEyjMKy4GVFH1-SBA88la9uw>
    <xmx:EFWyYIsAPxx6O6UK6uiTqkfjS9l6iu6IiZDHo0uwwwaXId5EEBgesg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 10:51:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: properly handle A-MSDUs that start with an RFC 1042" failed to apply to 4.9-stable tree
To:     Mathy.Vanhoef@kuleuven.be, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 16:51:49 +0200
Message-ID: <162229990924111@kroah.com>
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

From a1d5ff5651ea592c67054233b14b30bf4452999c Mon Sep 17 00:00:00 2001
From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Date: Tue, 11 May 2021 20:02:44 +0200
Subject: [PATCH] mac80211: properly handle A-MSDUs that start with an RFC 1042
 header

Properly parse A-MSDUs whose first 6 bytes happen to equal a rfc1042
header. This can occur in practice when the destination MAC address
equals AA:AA:03:00:00:00. More importantly, this simplifies the next
patch to mitigate A-MSDU injection attacks.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.0b2b886492f0.I23dd5d685fe16d3b0ec8106e8f01b59f499dffed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5224f885a99a..58c2cd417e89 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5760,7 +5760,7 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
  */
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 				  const u8 *addr, enum nl80211_iftype iftype,
-				  u8 data_offset);
+				  u8 data_offset, bool is_amsdu);
 
 /**
  * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
@@ -5772,7 +5772,7 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 static inline int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 					 enum nl80211_iftype iftype)
 {
-	return ieee80211_data_to_8023_exthdr(skb, NULL, addr, iftype, 0);
+	return ieee80211_data_to_8023_exthdr(skb, NULL, addr, iftype, 0, false);
 }
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 531232b91bc4..f14d32a5001d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2682,7 +2682,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 	if (ieee80211_data_to_8023_exthdr(skb, &ethhdr,
 					  rx->sdata->vif.addr,
 					  rx->sdata->vif.type,
-					  data_offset))
+					  data_offset, true))
 		return RX_DROP_UNUSABLE;
 
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 382c5262d997..39966a873e40 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
 int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 				  const u8 *addr, enum nl80211_iftype iftype,
-				  u8 data_offset)
+				  u8 data_offset, bool is_amsdu)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct {
@@ -629,7 +629,7 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 	skb_copy_bits(skb, hdrlen, &payload, sizeof(payload));
 	tmp.h_proto = payload.proto;
 
-	if (likely((ether_addr_equal(payload.hdr, rfc1042_header) &&
+	if (likely((!is_amsdu && ether_addr_equal(payload.hdr, rfc1042_header) &&
 		    tmp.h_proto != htons(ETH_P_AARP) &&
 		    tmp.h_proto != htons(ETH_P_IPX)) ||
 		   ether_addr_equal(payload.hdr, bridge_tunnel_header)))

