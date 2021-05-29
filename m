Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2AE394C97
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhE2PB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:01:56 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57217 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhE2PB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:01:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id A83D21940E3E;
        Sat, 29 May 2021 11:00:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 29 May 2021 11:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7FkFj8
        CdHQT5I1ZIvBi4lQbvzW7r7ECPnQBtqCIgRc0=; b=daYaPn4VkSzBZ5dNnL17qt
        xlgtK8YpDBB2i3Dmff6WDv0axNQ8oKWzgJJETwx+KRFVIzoVg/LdHN49VXmcrBoC
        PUl3/DtMgj1FU5JRT1vcAyam22/a17u1gamYgHMEhrUCgKnkW8rMICbNh30VKgFf
        CXNoI6twZwc1w/sVXTl+qZuOH1ZBrr6EMpaMERvfFUQLZU5S++RCEalCvyMUDjHk
        6RCDbTPpUZ3pk6HT/BwnIOTQEeJy0m5G2ytiIEJJuGJ+tYQAtKDRm2SpX3RHkD0E
        uuADWrx746qk6n2llErFBoqCdPzDxOA4P1pjO1AsJ1RDKGn2iNlADNPlgYA1vizQ
        ==
X-ME-Sender: <xms:A1eyYBFwX0kQQ8wB2MOABlnmEyeyDQMCER6D84VbyacTrxOAEc8BMw>
    <xme:A1eyYGUZ9FGZpT0X0g-BFQKdi8i-oEQryQCpRAG50klE5eks4JsfMEljZTYRG9E7P
    lDrL4GlGlI3kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:A1eyYDLmOypol33Kiryys3FX1lD_WrM1XHJ4pJWGZ-3wb5yVChRjpw>
    <xmx:A1eyYHFbTaPT8g66uJybfWvb8Mo3GP8dlWb2CmaHlflchTQ1IyXyAg>
    <xmx:A1eyYHU5h44OIO17g3VVGGFbfNWI932JBAge7boirq3MTo3Lr9kksg>
    <xmx:A1eyYOAzmgIItsYLZE_0xeOkwHai8hpWnvt_DiOr-crWP6cZ4a4jHg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:00:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: check defrag PN against current frame" failed to apply to 4.4-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:00:16 +0200
Message-ID: <16223004161447@kroah.com>
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

From bf30ca922a0c0176007e074b0acc77ed345e9990 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 11 May 2021 20:02:48 +0200
Subject: [PATCH] mac80211: check defrag PN against current frame

As pointed out by Mathy Vanhoef, we implement the RX PN check
on fragmented frames incorrectly - we check against the last
received PN prior to the new frame, rather than to the one in
this frame itself.

Prior patches addressed the security issue here, but in order
to be able to reason better about the code, fix it to really
compare against the current frame's PN, not the last stored
one.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.bfbc340ff071.Id0b690e581da7d03d76df90bb0e3fd55930bc8a0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4c714375bad0..214404a558fb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -223,8 +223,15 @@ struct ieee80211_rx_data {
 	 */
 	int security_idx;
 
-	u32 tkip_iv32;
-	u16 tkip_iv16;
+	union {
+		struct {
+			u32 iv32;
+			u16 iv16;
+		} tkip;
+		struct {
+			u8 pn[IEEE80211_CCMP_PN_LEN];
+		} ccm_gcm;
+	};
 };
 
 struct ieee80211_csa_settings {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7212a1bebd0c..b619c47e1d12 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2308,7 +2308,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	if (entry->check_sequential_pn) {
 		int i;
 		u8 pn[IEEE80211_CCMP_PN_LEN], *rpn;
-		int queue;
 
 		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
@@ -2323,8 +2322,8 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			if (pn[i])
 				break;
 		}
-		queue = rx->security_idx;
-		rpn = rx->key->u.ccmp.rx_pn[queue];
+
+		rpn = rx->ccm_gcm.pn;
 		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 91bf32af55e9..bca47fad5a16 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -3,6 +3,7 @@
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
+ * Copyright (C) 2020-2021 Intel Corporation
  */
 
 #include <linux/netdevice.h>
@@ -167,8 +168,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 
 update_iv:
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->security_idx].iv32 = rx->tkip.iv32;
+	rx->key->u.tkip.rx[rx->security_idx].iv16 = rx->tkip.iv16;
 
 	return RX_CONTINUE;
 
@@ -294,8 +295,8 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
 					  hdr->addr1, hwaccel, rx->security_idx,
-					  &rx->tkip_iv32,
-					  &rx->tkip_iv16);
+					  &rx->tkip.iv32,
+					  &rx->tkip.iv16);
 	if (res != TKIP_DECRYPT_OK)
 		return RX_DROP_UNUSABLE;
 
@@ -553,6 +554,8 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 		}
 
 		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove CCMP header and MIC */
@@ -781,6 +784,8 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 		}
 
 		memcpy(key->u.gcmp.rx_pn[queue], pn, IEEE80211_GCMP_PN_LEN);
+		if (unlikely(ieee80211_is_frag(hdr)))
+			memcpy(rx->ccm_gcm.pn, pn, IEEE80211_CCMP_PN_LEN);
 	}
 
 	/* Remove GCMP header and MIC */

