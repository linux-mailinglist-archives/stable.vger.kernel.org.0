Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0EE394C8C
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 16:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhE2Ox3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 10:53:29 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59779 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhE2Ox3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 10:53:29 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 36BC81940931;
        Sat, 29 May 2021 10:51:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 29 May 2021 10:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R348zF
        +uOXRGDY5Ki1ET5AW7dxMzJ6eDNC7bVbMSghA=; b=eKag0po4ehu+DD45/FUkBE
        2Qypl6oxH/qsr2epXkXrWm4dwQ16F0gb6KXW7TZ4gyR8clBBE6/YQUzqA3NhptWr
        PHH+BIGJGxeHTJ8mjbdyu3TI/ptk767niq3ynVt9ThjknSl1d9CWQ1roWJGSo4b1
        qOXXTiPtULWgWgkV1s99Co9DsRpdFLQyiUOv00yJmWIBzJAWaZ8edoJMxDGvWQqp
        v+ytM9UpSB6eBvqVDtqSLJ2lFQJemYrJEv6iavsJ3p0d2vjQ30ryHMuUQzMqOLYd
        ICxXRhDu3Qns+MSu/SibyEpQ8eT9U/rEQ7omsAp6Z0uo8IazisI4mn7z9gj30Yzw
        ==
X-ME-Sender: <xms:B1WyYE9W7TmaHDo0t7z2Nz5WtfA2SqXGDDaDu4HHghxvTQjxCJqJqQ>
    <xme:B1WyYMvVYkC-lPlP771dfA-shttVKJfcZnS4_45KKhAihgU8Va2TlVa3-R4Mlds4j
    69doPbUoIp6PA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B1WyYKDBrU7SG4Bykk7BogX-hN9pQu2JwP6Z9G409liVcQ6iQ2YdIA>
    <xmx:B1WyYEedVCAbHRLnV4WiUoG-DY9Qvo0TXEn6OXGcf42zwVIy3NZ-LQ>
    <xmx:B1WyYJOFDJXkaNccTrQsSqdTluuFYFlz57812qTLfuxvZcwuKQlhdQ>
    <xmx:CFWyYLVyFZTEh3x1t1lS34n-2hoqq_VIpwJOpdBfIqkfy0w7tdI66A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 10:51:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: properly handle A-MSDUs that start with an RFC 1042" failed to apply to 4.4-stable tree
To:     Mathy.Vanhoef@kuleuven.be, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 16:51:48 +0200
Message-ID: <16222999088319@kroah.com>
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

