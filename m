Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4978B394CB6
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhE2PRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:45 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51197 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id B03311940DB6;
        Sat, 29 May 2021 11:16:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=phWRlU
        M2SAC/HCWKY3isDXrWMT21bfJZe/cpOQvp4yA=; b=BprU3ycSwsz6IuEHVk/CbA
        Dr8q73g/NomWutMoQtmzOxsaFtekIdC7ah+sbuR4H5fxhUFZgYgK0wWXBv83R7pL
        BrH5DAr2QE5LE8GdyDrlZg0+NtNc2+X6sgiQJ4OpSoG3NBNyyM16jjNFCRSlqGDN
        9+Cp8/NxaeKa12UB0C5TBHFo8s4pj9v+Fk2gOLCvtP0BgzqFFuSemzr4zhaI0jva
        VzUTtmiB6o4UN2Oh7o7WFCbNg/+m3QVLNJzeLD0aR6ZeB6p3Bbw+eOsdqv6yS791
        sJxpxxwx0RW4mtgI+lrvxiUPLHyuVB2Y9nBzgaa+TZFMWeqhQf1P0u7Wl+nMxLyg
        ==
X-ME-Sender: <xms:uFqyYFjBWd2pTLEFDjM6HB6Hn6weapbXyzvW0BcXiEb3r6guAqazVg>
    <xme:uFqyYKB-ArgvcuIYqR2kT5S3haW7-1RbEVVIAu25spsFkXE-DKyrZ7E08ZfLg9LXz
    zojJxdmS3CX-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:uFqyYFECtAn7Nt0y3Bj-9sxRalesoShohG4WPQ5JegyHXMB3jtAIYg>
    <xmx:uFqyYKQuSYF8bkNJvbuzV3Z-6ZJ77RRavC1Z4uFey4VY5neIOorL1g>
    <xmx:uFqyYCz4gz_0KYKkJSnLNH1QmsF1Mwk35SyzTRU6lug1em4Ub-mGag>
    <xmx:uFqyYHrqcdN_gEOSxmDAMB8hp1SpufmvLs728qRBx6MNb7KbrXaX5Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop fragments with multicast DA for SDIO" failed to apply to 4.19-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:07 +0200
Message-ID: <16223013676232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

