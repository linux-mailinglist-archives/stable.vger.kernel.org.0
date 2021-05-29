Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3548394CD7
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhE2PVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:21:02 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59893 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhE2PVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:21:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id ECFC81940DFF;
        Sat, 29 May 2021 11:19:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tbTy6Y
        84BXBW8uLbbu6Uukh7toSWGPT3igdI4sP0GCs=; b=TaURIHt/f6IAj6TRVOcAyY
        neBLV2ZA7u/HzWSe6Hq5scRhOZ88D58AfsLIURlKeMv4mp+MC7O3wJCe+kt2Pv9x
        NPx7L9pOXh5/JhAfVpIXJInjCKCKVcfpufbkxs5XFAupmaBL/OaFp0BIMK2Qnemp
        m+kzKfumaZqlSNwHrtJQ+NCWgaeG2rLADtYuebHvWRMFZdTzeDvawvDosNzyyEzV
        +C3LajDCgh9273wCPxbLo9NV8BnXmao1408DHh/bhePUGPjZcDY87oEPT5dEp37M
        8eH28iOzI9qOUyCuAJZC+IsBQ64TZyU6n3EjnKCI263DGbSl1FSD2DFFPpqD0H5A
        ==
X-ME-Sender: <xms:e1uyYAr768mIHMWlVQzMRs_ZAMhXKq4En9do4AhoqAT-sMU_ZmPwxA>
    <xme:e1uyYGr7Ml4U0rmRlCBGNPTHd22GrZDpjGdnWnTSJt-mkC_JUsCSBvxYB6uai5s4T
    QYsd2Yiygd7VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:e1uyYFOgrpIpqeVd8mg3u0gDk7PkeaLXk3SLJMnlqIlFhAxS_TT4Gw>
    <xmx:e1uyYH5BzGOkZQyBf0coJGgRllQEo11vD6R9Cob_K5E4pxl4gr86tg>
    <xmx:e1uyYP7aOuE6E5meyWsRlEJW8NL9SDw6aJBaQ_XSDd_UcWt4wU8f6Q>
    <xmx:e1uyYJS-jo5S53pPLvmm6r1IyZXcdE4UhytUbjezquHV1LmQlFt-DQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:19:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath11k: Drop multicast fragments" failed to apply to 4.4-stable tree
To:     srirrama@codeaurora.org, johannes.berg@intel.com,
        jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:19:22 +0200
Message-ID: <162230156247114@kroah.com>
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

