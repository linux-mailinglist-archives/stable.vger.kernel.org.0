Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3694394C99
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhE2PCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:02:46 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35285 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhE2PCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:02:46 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5DB791940E57;
        Sat, 29 May 2021 11:01:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 29 May 2021 11:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HSQr+g
        BwTI7Dv/XgPVRKDWw992kucMVNUke4zM5d4VY=; b=RyuxknmRyR4uNy62Quqi1D
        y2os3CbgeGRPxTVKtANldw/bhbsCHNZNQNKM1dZXysn8IVWxmzh8wJlVIDsMyWto
        mbvqXlBba5tWjP+zFwNE/Slp70/dF5zZRh0vKZRDsHrqLGRh+1Y9ta8IxKu7FIBH
        7x6XnPq9Zv5zL36yPa7s7xqmuIhGsg1XfNgZfOIZMuRbEvP7IAicO/ayrkKxwHBY
        gD0UCyqOoG0FnaqzypY9Wk0/ocSzujs9BFhetjTrPeSwScQ6gohEf4Id5JvqIvsA
        NrvXypQZeCOfV5fE9ylpSPZz4hOn91Pkt+xO/q7ydCZK2p/Ad4i8ns9gRxV3bSng
        ==
X-ME-Sender: <xms:NVeyYE9SP2H5vq_ZyqlCQt_dVLosb_UIQyaahl8bHhJ0io6Ix9ajlw>
    <xme:NVeyYMshs_Z7BptI5zVKP89367NrhaYs09x75oR_WQn5dHJQlla3qc-4NlVFJGca7
    J54_xyQZJ5idQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NVeyYKAdJiNC2GSRq1vCzLRsERumYxw6asmBeDFdpRankZ1TyoEYfw>
    <xmx:NVeyYEfJO4oxeM4CSeamj6MWXDGJ1yLxlEh5A8qkSM46FChVz4Rlcg>
    <xmx:NVeyYJNBAu5IUOUqQDSM4sxTWP-1R9JdEl0AKA3mgXxLLf9W4GJRtw>
    <xmx:NVeyYAajL3abygHx1hN3mF9VYXB05QGaBprTXST9a70I_dWvnggO-w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:01:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: prevent attacks on TKIP/WEP as well" failed to apply to 4.9-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:00:59 +0200
Message-ID: <16223004596050@kroah.com>
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

From 7e44a0b597f04e67eee8cdcbe7ee706c6f5de38b Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 11 May 2021 20:02:49 +0200
Subject: [PATCH] mac80211: prevent attacks on TKIP/WEP as well

Similar to the issues fixed in previous patches, TKIP and WEP
should be protected even if for TKIP we have the Michael MIC
protecting it, and WEP is broken anyway.

However, this also somewhat protects potential other algorithms
that drivers might implement.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.430e8c202313.Ia37e4e5b6b3eaab1a5ae050e015f6c92859dbe27@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b619c47e1d12..4454ec47283f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2274,6 +2274,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
@@ -2286,6 +2287,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
+		} else if (rx->key && ieee80211_has_protected(fc)) {
+			entry->is_protected = true;
+			entry->key_color = rx->key->color;
 		}
 		return RX_QUEUED;
 	}
@@ -2327,6 +2331,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
+	} else if (entry->is_protected &&
+		   (!rx->key || !ieee80211_has_protected(fc) ||
+		    rx->key->color != entry->key_color)) {
+		/* Drop this as a mixed key or fragment cache attack, even
+		 * if for TKIP Michael MIC should protect us, and WEP is a
+		 * lost cause anyway.
+		 */
+		return RX_DROP_UNUSABLE;
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5c56d29a619e..0333072ebd98 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -455,7 +455,8 @@ struct ieee80211_fragment_entry {
 	u16 extra_len;
 	u16 last_frag;
 	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
+	   is_protected:1;
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 	unsigned int key_color;
 };

