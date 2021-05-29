Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79BB394CDA
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhE2PVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:21:06 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51467 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229754AbhE2PVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:21:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A8B201940E09;
        Sat, 29 May 2021 11:19:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 29 May 2021 11:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4pVGYY
        fG0f9+IktEf2SYNH4qPBOcQc+nSrr77wwxElY=; b=tt/8JXWX6XAyL2FDAv44Eg
        B9T8KLJg2Zb0JNP88mo6Cu7Cz4YaS7b+/0Ct3W5da5YotM/h+Zzk9m1hjfYzXNOM
        8eVS16NLBYJAnmrK7Cr4hfHzWc5Kx+Sl/CPdoH/1F9kxlCH/hIe7hCyYdSHOyWy5
        yLqJHU0SM5ZOs0FdThz8fMMY2IQ9vUzx/psPNEjHXmnqXmXyUsX1u0GNz3cKSRFd
        IMGd5BXO7p2erX0syZ3hc8DbvcgkcJ8cLnB+trhr1Zs+t5yd5XYDBOGEhMKT0P+G
        +CjEWqTq61RzXqggzXczL5FnbyAfhxQmelQ2Rkhbryf7Tx+eFDyPHiRAj7+tY/LA
        ==
X-ME-Sender: <xms:gVuyYFWi6WDU0bWRDGPPfSvpfwkAIGuOVQWkcE6pBXwb6BCE_1eKCA>
    <xme:gVuyYFmYpM-GyLVn-L1nQ4Inh7mQTiLq73D-lK7qRROKsxiR_rsiwQqklM0XIGowr
    ZUgpFc4uLVmEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gVuyYBYsYeFvooY7hLNB3MVyHTvVxmo8xoS1sqpIW01M6wCoZNnzKg>
    <xmx:gVuyYIX1JkFykiW7xJZteqcBMpGAZUc2jj5aGy3R9lzYAeQKtvyUYw>
    <xmx:gVuyYPnLC6daXFiM_4-UaS5p8BsxXqiztclxCen4Xun2zbFzVy17JQ>
    <xmx:gVuyYHtME8s2B2iAJZ4QbHALHZvrePamwRqum7jKPFfSU0ExCvjNDQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:19:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath11k: Drop multicast fragments" failed to apply to 5.4-stable tree
To:     srirrama@codeaurora.org, johannes.berg@intel.com,
        jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:19:23 +0200
Message-ID: <16223015631132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 210f563b097997ce917e82feab356b298bfd12b0 Mon Sep 17 00:00:00 2001
From: Sriram R <srirrama@codeaurora.org>
Date: Tue, 11 May 2021 20:02:59 +0200
Subject: [PATCH] ath11k: Drop multicast fragments

Fragmentation is used only with unicast frames. Drop multicast fragments
to avoid any undesired behavior.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01734-QCAHKSWPL_SILICONZ-1 v2

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.1d53bfd20a8b.Ibb63283051bb5e2c45951932c6e1f351d5a73dc3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 3382f8bfcb48..603d2f93ac18 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -260,6 +260,16 @@ static void ath11k_dp_rxdesc_set_msdu_len(struct ath11k_base *ab,
 	ab->hw_params.hw_ops->rx_desc_set_msdu_len(desc, len);
 }
 
+static bool ath11k_dp_rx_h_attn_is_mcbc(struct ath11k_base *ab,
+					struct hal_rx_desc *desc)
+{
+	struct rx_attention *attn = ath11k_dp_rx_get_attention(ab, desc);
+
+	return ath11k_dp_rx_h_msdu_end_first_msdu(ab, desc) &&
+		(!!FIELD_GET(RX_ATTENTION_INFO1_MCAST_BCAST,
+		 __le32_to_cpu(attn->info1)));
+}
+
 static void ath11k_dp_service_mon_ring(struct timer_list *t)
 {
 	struct ath11k_base *ab = from_timer(ab, t, mon_reap_timer);
@@ -3468,6 +3478,7 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 	u8 tid;
 	int ret = 0;
 	bool more_frags;
+	bool is_mcbc;
 
 	rx_desc = (struct hal_rx_desc *)msdu->data;
 	peer_id = ath11k_dp_rx_h_mpdu_start_peer_id(ar->ab, rx_desc);
@@ -3475,6 +3486,11 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 	seqno = ath11k_dp_rx_h_mpdu_start_seq_no(ar->ab, rx_desc);
 	frag_no = ath11k_dp_rx_h_mpdu_start_frag_no(ar->ab, msdu);
 	more_frags = ath11k_dp_rx_h_mpdu_start_more_frags(ar->ab, msdu);
+	is_mcbc = ath11k_dp_rx_h_attn_is_mcbc(ar->ab, rx_desc);
+
+	/* Multicast/Broadcast fragments are not expected */
+	if (is_mcbc)
+		return -EINVAL;
 
 	if (!ath11k_dp_rx_h_mpdu_start_seq_ctrl_valid(ar->ab, rx_desc) ||
 	    !ath11k_dp_rx_h_mpdu_start_fc_valid(ar->ab, rx_desc) ||

