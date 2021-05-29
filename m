Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED930394CA1
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhE2PPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:15:21 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:52205 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:15:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CC49319403FC;
        Sat, 29 May 2021 11:13:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 29 May 2021 11:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ge83S8
        o79rfQ5bmJ8OpO2xnFfMPYwo69JedT4PEp3kA=; b=pWCA0LiFaP7FC6BF7jBZCi
        aOuXqWJUD0vHpSUydP9XAzMdsgW75867aJUigLclgrLF3o8jhG9OfyLD4P8bHuxd
        qt55hJMbIH0HGFwLSQjTEVId/PKJGsSt96JeV8vrC7/L0D/+2X0YHKQAP9ToCD5O
        yvxMjX9mx1xkf99iPAG4LcyBYTVlYRie1dOnaFAXgZzQTqNEhlrmvIXkFhlEp0yv
        AsB9JRjbLzTRAX4+GtxlETwj5AWTHlRDeIJIFvWnthwB0DflgEgScIs/UAaClD1B
        +cufQ+FW6YUklPRB73m6fRpcg41z35VaaOo4+hsVd58CIF5HXJ8boLUyr1OIzlbw
        ==
X-ME-Sender: <xms:J1qyYF46mdG575_FCZvi35RKdyMe2OgrscikS9J-Xb8dL21pMuGIlw>
    <xme:J1qyYC5qTIO5ptW7ndQC_o3lQMibGXAwzOPLt-u3hXTI-QxbKRElUVzpupgtryNAN
    8L_CtDIkhgChA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:J1qyYMfhtkxq7MGnndTGC9JGGjs3k8E6m_qKm0uZ5O0_CKi5Vq3nLQ>
    <xmx:J1qyYOJXDvM4qXpFdXoWmQFGUJem0EEw2-t6hWxdzysxFgnqLcxbAA>
    <xmx:J1qyYJI7rJzI-gf25Ey5naEwRDrdtMhc8tJjjjNkTh0ngUcW9aSb3A>
    <xmx:J1qyYLzQ3dwhi8dvcLU_Adkn-hiG35g6b8qwRzEVHEBoxbWe0ZfgEA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:13:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: do not accept/forward invalid EAPOL frames" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:13:32 +0200
Message-ID: <1622301212241171@kroah.com>
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

From a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 11 May 2021 20:02:50 +0200
Subject: [PATCH] mac80211: do not accept/forward invalid EAPOL frames

EAPOL frames are used for authentication and key management between the
AP and each individual STA associated in the BSS. Those frames are not
supposed to be sent by one associated STA to another associated STA
(either unicast for broadcast/multicast).

Similarly, in 802.11 they're supposed to be sent to the authenticator
(AP) address.

Since it is possible for unexpected EAPOL frames to result in misbehavior
in supplicant implementations, it is better for the AP to not allow such
cases to be forwarded to other clients either directly, or indirectly if
the AP interface is part of a bridge.

Accept EAPOL (control port) frames only if they're transmitted to the
own address, or, due to interoperability concerns, to the PAE group
address.

Disable forwarding of EAPOL (or well, the configured control port
protocol) frames back to wireless medium in all cases. Previously, these
frames were accepted from fully authenticated and authorized stations
and also from unauthenticated stations for one of the cases.

Additionally, to avoid forwarding by the bridge, rewrite the PAE group
address case to the local MAC address.

Cc: stable@vger.kernel.org
Co-developed-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.cb327ed0cabe.Ib7dcffa2a31f0913d660de65ba3c8aca75b1d10f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4454ec47283f..22a925899a9e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2531,13 +2531,13 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 
 	/*
-	 * Allow EAPOL frames to us/the PAE group address regardless
-	 * of whether the frame was encrypted or not.
+	 * Allow EAPOL frames to us/the PAE group address regardless of
+	 * whether the frame was encrypted or not, and always disallow
+	 * all other destination addresses for them.
 	 */
-	if (ehdr->h_proto == rx->sdata->control_port_protocol &&
-	    (ether_addr_equal(ehdr->h_dest, rx->sdata->vif.addr) ||
-	     ether_addr_equal(ehdr->h_dest, pae_group_addr)))
-		return true;
+	if (unlikely(ehdr->h_proto == rx->sdata->control_port_protocol))
+		return ether_addr_equal(ehdr->h_dest, rx->sdata->vif.addr) ||
+		       ether_addr_equal(ehdr->h_dest, pae_group_addr);
 
 	if (ieee80211_802_1x_port_control(rx) ||
 	    ieee80211_drop_unencrypted(rx, fc))
@@ -2562,8 +2562,28 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
 	} else {
+		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+
 		memset(skb->cb, 0, sizeof(skb->cb));
 
+		/*
+		 * 802.1X over 802.11 requires that the authenticator address
+		 * be used for EAPOL frames. However, 802.1X allows the use of
+		 * the PAE group address instead. If the interface is part of
+		 * a bridge and we pass the frame with the PAE group address,
+		 * then the bridge will forward it to the network (even if the
+		 * client was not associated yet), which isn't supposed to
+		 * happen.
+		 * To avoid that, rewrite the destination address to our own
+		 * address, so that the authenticator (e.g. hostapd) will see
+		 * the frame, but bridge won't forward it anywhere else. Note
+		 * that due to earlier filtering, the only other address can
+		 * be the PAE group address.
+		 */
+		if (unlikely(skb->protocol == sdata->control_port_protocol &&
+			     !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
+			ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
+
 		/* deliver to local stack */
 		if (rx->list)
 			list_add_tail(&skb->list, rx->list);
@@ -2603,6 +2623,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
+	    ehdr->h_proto != rx->sdata->control_port_protocol &&
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->u.vlan.sta)) {
 		if (is_multicast_ether_addr(ehdr->h_dest) &&
 		    ieee80211_vif_get_num_mcast_if(sdata) != 0) {

