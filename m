Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BD394CCC
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhE2PTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:19:54 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:52949 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhE2PTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:19:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 96CA71940DD5;
        Sat, 29 May 2021 11:18:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 29 May 2021 11:18:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=J0rtsJ
        zz7+TuIhf9rKHgErl0pnBKfobVlXcP86smkvE=; b=ZmwUOSKcgl2tBWpNzu7uCj
        n1l7qjiEvLZpA7tiawVM+D8sJFY4CCk9eDJiUZq6FYvUv0VFCTQGLwvSl2CVcFss
        10ScfwCzO8nhKpWmRC3vi62haK2QqRjPcSnJ6gsNXClLo59Ov5sV4Iw1VKTqrdzN
        /MElTJbVMesCaDukjthVCqf/XAg0AH6Jfozxd0zbK5Jx03RXmre724wrfMznBo2o
        K/lW14YaAFVQq8djLSjYbAqHc5AcHYCUIc7SNLzQm607dPa9VzO6FOiBcB3BAbe/
        i8HSQ1+aeL6VQPet0EZZTahVlWawou4kkee8AdT5+tYytiOPoAonZVUiSy1R+sIg
        ==
X-ME-Sender: <xms:OFuyYP_KdxjIk5LQNz4uM9M0fdNMcJDKolpqGV2Cxgfy-FCMCYoxnA>
    <xme:OFuyYLukbJghpcTIKSNVFZninN7u5ubY1Ltv9-XltzBobA-cylXsTrw-AJOswTDka
    BakJTN8XQZAkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OFuyYNB9BoDLFeUr0gcVe3cDy4WppPmrMR4hwS63g78rSwxlp78fzQ>
    <xmx:OFuyYLfdb_ggRhm529UgAF9gO_De0L4zbxrHHfVB70eHsycxiQi0RA>
    <xmx:OFuyYEOVy5uadzpyRbB667TQEItTGFQ8TgEWI8upSgQGnocwKGLB-A>
    <xmx:OFuyYO1I6lARfvJ1ZulicRyxOE33QslqdTN0R6M_TFwOWLpLcEi1CA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:18:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: Validate first subframe of A-MSDU before processing" failed to apply to 4.4-stable tree
To:     srirrama@codeaurora.org, johannes.berg@intel.com,
        jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:18:14 +0200
Message-ID: <1622301494125187@kroah.com>
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

From 62a8ff67eba52dae9b107e1fb8827054ed00a265 Mon Sep 17 00:00:00 2001
From: Sriram R <srirrama@codeaurora.org>
Date: Tue, 11 May 2021 20:02:57 +0200
Subject: [PATCH] ath10k: Validate first subframe of A-MSDU before processing
 the list

In certain scenarios a normal MSDU can be received as an A-MSDU when
the A-MSDU present bit of a QoS header gets flipped during reception.
Since this bit is unauthenticated, the hardware crypto engine can pass
the frame to the driver without any error indication.

This could result in processing unintended subframes collected in the
A-MSDU list. Hence, validate A-MSDU list by checking if the first frame
has a valid subframe header.

Comparing the non-aggregated MSDU and an A-MSDU, the fields of the first
subframe DA matches the LLC/SNAP header fields of a normal MSDU.
In order to avoid processing such frames, add a validation to
filter such A-MSDU frames where the first subframe header DA matches
with the LLC/SNAP header pattern.

Tested-on: QCA9984 hw1.0 PCI 10.4-3.10-00047

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.e6f5eb7b9847.I38a77ae26096862527a5eab73caebd7346af8b66@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 87196f9bbdea..7ffb5d5b2a70 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2108,14 +2108,62 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 	ath10k_unchain_msdu(amsdu, unchain_cnt);
 }
 
+static bool ath10k_htt_rx_validate_amsdu(struct ath10k *ar,
+					 struct sk_buff_head *amsdu)
+{
+	u8 *subframe_hdr;
+	struct sk_buff *first;
+	bool is_first, is_last;
+	struct htt_rx_desc *rxd;
+	struct ieee80211_hdr *hdr;
+	size_t hdr_len, crypto_len;
+	enum htt_rx_mpdu_encrypt_type enctype;
+	int bytes_aligned = ar->hw_params.decap_align_bytes;
+
+	first = skb_peek(amsdu);
+
+	rxd = (void *)first->data - sizeof(*rxd);
+	hdr = (void *)rxd->rx_hdr_status;
+
+	is_first = !!(rxd->msdu_end.common.info0 &
+		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
+	is_last = !!(rxd->msdu_end.common.info0 &
+		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
+
+	/* Return in case of non-aggregated msdu */
+	if (is_first && is_last)
+		return true;
+
+	/* First msdu flag is not set for the first msdu of the list */
+	if (!is_first)
+		return false;
+
+	enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_ENCRYPT_TYPE);
+
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
+
+	subframe_hdr = (u8 *)hdr + round_up(hdr_len, bytes_aligned) +
+		       crypto_len;
+
+	/* Validate if the amsdu has a proper first subframe.
+	 * There are chances a single msdu can be received as amsdu when
+	 * the unauthenticated amsdu flag of a QoS header
+	 * gets flipped in non-SPP AMSDU's, in such cases the first
+	 * subframe has llc/snap header in place of a valid da.
+	 * return false if the da matches rfc1042 pattern
+	 */
+	if (ether_addr_equal(subframe_hdr, rfc1042_header))
+		return false;
+
+	return true;
+}
+
 static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
 					struct sk_buff_head *amsdu,
 					struct ieee80211_rx_status *rx_status)
 {
-	/* FIXME: It might be a good idea to do some fuzzy-testing to drop
-	 * invalid/dangerous frames.
-	 */
-
 	if (!rx_status->freq) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT, "no channel configured; ignoring frame(s)!\n");
 		return false;
@@ -2126,6 +2174,11 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
 		return false;
 	}
 
+	if (!ath10k_htt_rx_validate_amsdu(ar, amsdu)) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "invalid amsdu received\n");
+		return false;
+	}
+
 	return true;
 }
 

