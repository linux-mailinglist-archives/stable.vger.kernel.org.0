Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E318C394CB8
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhE2PR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:56 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:46921 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:55 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id E9B041940DE7;
        Sat, 29 May 2021 11:16:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 29 May 2021 11:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JzpFgT
        h61KO6WbjXzeY1vOo1rho3q0xy4gnaSgg+pcw=; b=PnuVXsvqWSyZ6fQ4JZeXjW
        3AYJLtm7qPezE9EHgICAkg6u0cfS5ChlgyBo3S7ERobgIIeVb902d8IkwlQYZ8xO
        QUsDNRvYLSR3mPkquWY7nXy2JyH3LBfb+0xhkpo7SrYZPVYmqlCYo248D94Pla6L
        VODETnlJzT8OR3lvFnqbuMlIBmf15vR9RdTjqs+VupvsWPFDFDj2j1IVWVdpSPJH
        /YOJColLeJfuwaHchXoJPcWeuR5QS1yx8kVG8W9jRHH3alADnNkXS0oLXYegKX89
        x0TgJ8VhayEryxZwYGnwey7kTsgKlouNS+sKHa3BtWdo13l3B497SzG8swYo+wvA
        ==
X-ME-Sender: <xms:wlqyYFZ317uOSUCzh3ic1cNVmbacguAAISjfs1PCr_hZ9nsUILfhmw>
    <xme:wlqyYMYvM2-oEkkAEejfBLfDjyIPyXkR-0xnxAV6lfvo-9LSCJ7n5HT5vQxZbh88j
    KLUbFP9XXro1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wlqyYH-TnwsB46oX_CuhLsHnRxuq7mbgZRYvbbbmWxLL3JmrRVdEuQ>
    <xmx:wlqyYDpTbbGCVEMfV2rniyalYmRFUtdU-t1jmFG6KIa-6ASrkJNx2A>
    <xmx:wlqyYApQDgaAVKMnLyBxI9UqRngr5t4f4mVnUeqnYfbDFi5P0qCiqQ>
    <xmx:wlqyYNDLge7g5aK1Ylsg5HNZE9kNKgK2mgzHQErYwrnRrCqxtrM3fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for SDIO" failed to apply to 4.9-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:07 +0200
Message-ID: <1622301367452@kroah.com>
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

From 40e7462dad6f3d06efdb17d26539e61ab6e34db1 Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:54 +0200
Subject: [PATCH] ath10k: drop fragments with multicast DA for SDIO

Fragmentation is not used with multicast frames. Discard unexpected
fragments with multicast DA. This fixes CVE-2020-26145.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.9ca6ca7945a9.I1e18b514590af17c155bda86699bc3a971a8dcf4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cb04848ed5cb..b1d93ff5215a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2617,6 +2617,13 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 	rx_desc = (struct htt_hl_rx_desc *)(skb->data + tot_hdr_len);
 	rx_desc_info = __le32_to_cpu(rx_desc->info);
 
+	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		/* Discard the fragment with multicast DA */
+		goto err;
+	}
+
 	if (!MS(rx_desc_info, HTT_RX_DESC_HL_INFO_ENCRYPTED)) {
 		spin_unlock_bh(&ar->data_lock);
 		return ath10k_htt_rx_proc_rx_ind_hl(htt, &resp->rx_ind_hl, skb,
@@ -2624,8 +2631,6 @@ static bool ath10k_htt_rx_proc_rx_frag_ind_hl(struct ath10k_htt *htt,
 						    HTT_RX_NON_TKIP_MIC);
 	}
 
-	hdr = (struct ieee80211_hdr *)((u8 *)rx_desc + rx_hl->fw_desc.len);
-
 	if (ieee80211_has_retry(hdr->frame_control))
 		goto err;
 

