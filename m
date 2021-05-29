Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE43394CB9
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhE2PR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:58 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35173 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id B02D51940DC6;
        Sat, 29 May 2021 11:16:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wqeqI9
        yYGXjk7Ds/3EH2YMafjRR+KU89cSdQus4XLZo=; b=Uga0GQppdYNCnobmHEmKt6
        Jd+awD3dndYO3VGJQsZC7VQ8nDVgYy8Y1uXju1zEDS2Md3N6RyUrF4YdoofmnQon
        LQmAv0TJhqWxuowWBa3c6T2aa0r4Es6qtwrG8ooaNunj04agReczYgTjLlnlbSkq
        /wDSAvMFo505yMr0u6W+zhixAsSJBwWzcNs+P1ASSV74eax1vJhI+qNzDT8oVFIB
        54GdtVJs+Fqy1bOlYKvQ7xzQdwP3/CsNqDEEXWOoCarLfIv32zJAru/YGOmU8/A3
        kbSGx9nzpWsCXHAz9hvRV004cnP0OmxxdMRpYqMlyZcijfKYtVw52n/fGzOPeA5Q
        ==
X-ME-Sender: <xms:xFqyYAwtXYe3OiNC7QFClNcMtZDNfdpMP484qbVg0KhiyqqxRv8h4w>
    <xme:xFqyYEQSK5BoYlG0l68mStyZC8ydUTIKwEi7MuEYYLw_rFgczgnwWb3EzANsoRacF
    exsLXZ9jqgAvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xFqyYCU30NrBB_uvw-MP3ULrbOdPSLIxgomFpbxvL68oOSzKGb-Dvg>
    <xmx:xFqyYOgkMm3HjRVPhmSav2gANNPXcxBpR6Wz2y3r8SFocEnX85_UqA>
    <xmx:xFqyYCDrpf05NUAu9HW_cPPhtZ4SqlVQfZ0UQEZtqpW1VOkwllMjhg>
    <xmx:xFqyYD7lQcG1xo-kTgtAteLLeI9bbkOR35U8kJv-HyVLmj8DPm182g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for SDIO" failed to apply to 4.4-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:08 +0200
Message-ID: <1622301368092@kroah.com>
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
 

