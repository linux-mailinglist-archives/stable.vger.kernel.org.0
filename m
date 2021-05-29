Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA61394C9A
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2PCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:02:48 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:53953 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhE2PCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:02:48 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id A739E1940E68;
        Sat, 29 May 2021 11:01:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 29 May 2021 11:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NTlrOk
        MleHxc7OdW881NAsCtHGpLqUqMfM6Odmi3SAE=; b=IynFiQMgWa0b3p9R7oDzu1
        l/tkVhFA/lf20yl0lElqkPdF6XCPthWH+1Pxf74oK4kg2T1a+ENLU5GFKcGNS7fX
        h0LUO5JZlff4GfVpdDDshrvbDXWcwTqnzRANxpSB5YHDtuijXK/MmEiFj/fUQ4WQ
        ksRblmZ0jkEjTayKPpbaYikZXsQpHIT93XhUJau4NocHhvhB79DBWltI1AGHFOd8
        hEADoy4WB2I52bT1RYj9/mHycYLUytGQf0hOtxizt509m0ObleaAl7q+oQua23jU
        9HXx6QX9Wd1oRRsJtZDoT++5NPxLjKR/SNRsL6Nxi4NPlokbiz1W0Clrn2hkF56g
        ==
X-ME-Sender: <xms:N1eyYL4OnTGVOsF3AegSHMrVBXrWCaBaw4YaVD1NqChvCCX51SXTEA>
    <xme:N1eyYA4XPN5ilZUDGoZssQkrqdq6rhvmpcZf-SsOfd30kLazCJ0yclpJ_Tc2kf2AD
    vjm2fOG_zjyUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:N1eyYCe9lPgEx5a5iN1FTzCGiASXa4_X7iUCCWDN5Whs_BpJ9E8XHw>
    <xmx:N1eyYML_HPC6n9UUApH0nN6S3UEMGNqPbTNe9Syv3n_4OwXbO5RCeA>
    <xmx:N1eyYPL1PIke6DMc3NTAbyFprhiwKuJOl-ZCZucCs1lQHOQz7lJKBA>
    <xmx:N1eyYKnd2m7njYXkE8TxMBJlgbsrQbha_wCX2PnAdEzNFJmGa_5kHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:01:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: prevent attacks on TKIP/WEP as well" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:00:59 +0200
Message-ID: <162230045920794@kroah.com>
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

