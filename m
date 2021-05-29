Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F50394CB3
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhE2PRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:35 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:50235 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A7BC91940DC0;
        Sat, 29 May 2021 11:15:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 29 May 2021 11:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gktx7R
        g8VDDjMw7Dw1fOhxMlREo6Gw38dqUr93JbyAU=; b=g9yBYgaDhVf1rSlvF2lLMz
        OK1GiiI9BlyhhlV4+J0uZhMCzWst/UrzWOlACSV9lRBAuVXiqmT9EBWxCwrCbTrw
        pyap8HipwdLn85iwdkBDHIUBEFj6PNCxpb00Yz2X4iu3ZSfrA0zUNmauMyrmnYY8
        hVrC31IuWGNeIf3eay4i82GFog6M8FGg+LNhFWfN5/1bY1yX6sjq256tQ5Mz4E6+
        nNbJAYw55ixId+GyuCkpct9Z9ZLFJwMeD1j753XZo6yaEaB2eHKtwSdVw5twuALD
        k7Fc48bC34DjvW/eVGx8QeUQ0wzY5MjyFIrhb5Z3daumKnumN7s8eCSc3JygT27w
        ==
X-ME-Sender: <xms:rVqyYL9hLxXaU0xMaBIelwKOOm7mKdWkAQMYv4oHVNwmgMLeZAMVhA>
    <xme:rVqyYHtUCJ2XaFOBOEP8gbjoWoBQfLv3AVs-wBgItw2Qf60LzgE_K2dIe9C3wJMdv
    FlOWHe16Yb7fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rVqyYJDSNttDCRCjMb8Ncw2sACduuRMBcpxzKnL3DKbGqwa6N3jWvg>
    <xmx:rVqyYHdzKNkxanMD7G-gm5dpcxsxXhFIcGvr1-Mk0ZhJ2H-KxyHyQA>
    <xmx:rVqyYAPY7a0wQ5L59btPRs8oUls4xoT-G3Z45VEeyY-vj4XlbMxV9Q>
    <xmx:rVqyYK3Wd9KFQvzFJsJs4ml0l5oxABScZ4M2BILlO_mxjEarJSwsfg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:15:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for PCIe" failed to apply to 4.14-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:15:47 +0200
Message-ID: <1622301347112152@kroah.com>
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
 

