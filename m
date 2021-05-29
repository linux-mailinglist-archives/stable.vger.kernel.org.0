Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4E394CB4
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhE2PRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:36 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43855 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id BE7A41940DC0;
        Sat, 29 May 2021 11:15:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 29 May 2021 11:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0roPoW
        Uaujd9xSAkCmE2mKoYdetwnEExnpo3TtBX270=; b=U3UjtBg/4VKPrH4fxh2sxE
        okDaU4K9IkD7R9ck4nUxeR2ri9kSXNM+ihPv53lLBM/ddemh7E9DRq+VEEUajzsU
        /Kh/+09XDXJ2Rf4R74jaAz80iDqdWYOR5+BS7WKkGIYpNQUldoghc3JSCYIBDmZZ
        pix+xrAsWZrBEu3DiLMCv4up+AtkO7gVMvmuWB3DpgRtXstVq3yQE/ShnAkrGC+Q
        +73hm3zJ1RCgxsZDHG5YycfrkgSG9DAo58WgwFZC8gD5+pe19xopPSbqCSGMFZ1E
        cyTjfAszBVGtTrCllJHKOGL+mQX9R53fgDvK4G2JSiBpTDe+MZgYP06YG4Odh7Ow
        ==
X-ME-Sender: <xms:r1qyYAvy7pUb2uBUIAPZGcXIKK4ens35zAh5CheQdXPo2T1nYKm14A>
    <xme:r1qyYNcMTXhGHW8V6Aghdw3EuR_nYsTjnO9yMgYGRyb9ayC7O16anvGpaIXpLYPmf
    D4qE2INLhYv7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:r1qyYLz567GoCWmPC4EZxjhQ2LJbq7aqBMVAA9E1HpAB6bW9FN6DjQ>
    <xmx:r1qyYDOpC0rTOTf-XSjVR7vfZ2Avgk9B1dw3H4mIKmAtWXKLWnwWCw>
    <xmx:r1qyYA-hQnKA3tSGUrrFh1PQy0P2PgJFzlWuAi4RUcczs_6ylmaFrw>
    <xmx:r1qyYOmHTQaEuChG_HZlSeex6M_30u6ABa_-9Ham6eY74g9XdNKOVg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:15:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for PCIe" failed to apply to 4.4-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:15:48 +0200
Message-ID: <162230134820945@kroah.com>
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
 

