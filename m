Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA13394CB5
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhE2PRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:38 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:32789 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id B7F7A1940DC0;
        Sat, 29 May 2021 11:16:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wDwnA7
        J/KIhTkgAr3vSdbmc0s7ahfuzxOUPBq9DaGlU=; b=iItMfMTkfIH1sXVXSDr8gk
        Yg7sRYEnaJqciqGlXxO/HPw1+CPfVxvjTQRE7vXO0bH/5yYp+Rkta9VLfcS6IcEK
        V/9aFdlzeKKOMYjIs9tAHukWs066ji9V7mitDuB6XkhemadtqZtDc5RrgTFsLL8A
        d3huOPKZyImK6EEMSTS04UUcDjzvrLSreW3Hcy1YEZp3UHDKHkhGJM8+IGE7ijeh
        X8qJIR39XRup1LwcKXrsDCkq6w7yvpgQwYEYFAlyux3kHzmSv80clV+OhYmbUuX1
        zTFwTB71k9/vSRr1LPr1WzaVj4yH07uVVurvmHTscAnG8kYXrHQYtDPaLCrl+l3w
        ==
X-ME-Sender: <xms:sVqyYD1SmUqqz2hMkv3sEicx40wky66xAsOVAxWcOkiyEtOiFU1yDQ>
    <xme:sVqyYCHuXIH8KgIaarBJRemhKWBNFTE8DPBJD0FVHKvGklqp5qOO_drRS6_WG-5oi
    82z3OthvejiWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sVqyYD5iT674esObL-zlz6v8Ss-Aib9o8BaLktvvrUaTT7AVGeL_Vw>
    <xmx:sVqyYI30GyS-Zg7Fq8Kp-EQHT1tQLXFytlTZuad7S5J3yFj7_ZspiQ>
    <xmx:sVqyYGGS3XFbj5jMDRnG3cGXE2dntxmbhXqiIIM_oPs8ZkuJwsvpUA>
    <xmx:sVqyYIMkNgtTdwXscfVyzPHFKt-2OEm-ZC1wRfb4svqMO3QO1ZGPTQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for PCIe" failed to apply to 4.9-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:15:48 +0200
Message-ID: <162230134878119@kroah.com>
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

From 65c415a144ad8132b6a6d97d4a1919ffc728e2d1 Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:53 +0200
Subject: [PATCH] ath10k: drop fragments with multicast DA for PCIe

Fragmentation is not used with multicast frames. Discard unexpected
fragments with multicast DA. This fixes CVE-2020-26145.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.5a0bd289bda8.Idd6ebea20038fb1cfee6de924aa595e5647c9eae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f1e5bce8b14f..cb04848ed5cb 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1768,6 +1768,16 @@ static u64 ath10k_htt_rx_h_get_pn(struct ath10k *ar, struct sk_buff *skb,
 	return pn;
 }
 
+static bool ath10k_htt_rx_h_frag_multicast_check(struct ath10k *ar,
+						 struct sk_buff *skb,
+						 u16 offset)
+{
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *)(skb->data + offset);
+	return !is_multicast_ether_addr(hdr->addr1);
+}
+
 static bool ath10k_htt_rx_h_frag_pn_check(struct ath10k *ar,
 					  struct sk_buff *skb,
 					  u16 peer_id,
@@ -1839,7 +1849,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	bool is_decrypted;
 	bool is_mgmt;
 	u32 attention;
-	bool frag_pn_check = true;
+	bool frag_pn_check = true, multicast_check = true;
 
 	if (skb_queue_empty(amsdu))
 		return;
@@ -1946,13 +1956,20 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 								      0,
 								      enctype);
 
-		if (!frag_pn_check) {
-			/* Discard the fragment with invalid PN */
+		if (frag)
+			multicast_check = ath10k_htt_rx_h_frag_multicast_check(ar,
+									       msdu,
+									       0);
+
+		if (!frag_pn_check || !multicast_check) {
+			/* Discard the fragment with invalid PN or multicast DA
+			 */
 			temp = msdu->prev;
 			__skb_unlink(msdu, amsdu);
 			dev_kfree_skb_any(msdu);
 			msdu = temp;
 			frag_pn_check = true;
+			multicast_check = true;
 			continue;
 		}
 

