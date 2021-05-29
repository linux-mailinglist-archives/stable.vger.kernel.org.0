Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826D8394CC4
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhE2PTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:19:15 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:58931 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:19:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B35B61940DDA;
        Sat, 29 May 2021 11:17:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 29 May 2021 11:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z4cwbp
        V62ZKuJTWqg9FJ2oJsHul5pcRhlSMIIFclAm8=; b=fG4cPvRHnMt32aNDkaXVQ4
        f/npZJAww4iLwkPsFZtjnoDUC8srXS14bu7V+w8T4Nwyyj3yFHd491EusrbteHy9
        rTSZj7VMiDlrc9ng88y0qsh0uNHRoQ+ZzOOL3SFcsvVfm7YBYL/ne+YsuGDWu7n/
        Zuz3xV45yUUmwLRs4XA6LKV0EYNr5MFiMKujDjS1OlrRZGuNaPhQYP/kO7BLjJcO
        7pwL49hvQJSy5PS74akvZUPkFovHykuezHfOyWa2Ype1lQpxnuEuadPZ21TyLPk2
        LXaJYE2UzYEKuWZli/w66n+r+vWhlqJx/Yf9Y2Su+Ggu032Z2ytR6tQempBbOzOQ
        ==
X-ME-Sender: <xms:EluyYDcc9XqD1NQ86EyX-08uNQHn960-tgL444un8w-z9oeOf3fBcA>
    <xme:EluyYJOJYI6im5kR0_VqkftFuN-JsrssaIkjunK1uxmHBJLU0oSkNmvF4Gfsh1trV
    vgu9M162d86Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EluyYMj9mJ8FyveAhFAvxi4J0yN_bRzuSdMqcWoMSzCzdbDSDTQZyg>
    <xmx:EluyYE8qaRHp6v0YSDQYdyULDuu8SbtdYdNJx_NeY34sOa4ENz2PSA>
    <xmx:EluyYPvB4aSrU5v-xBtVdSBr1p1Xi6km-iSvOOalOqBxSBb3gRixMg>
    <xmx:EluyYIWQl9maOPdG6bGx7SuzyuGnNM5uq9nTjO2dSt4Zk_kMnH0oEg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:17:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: Fix TKIP Michael MIC verification for PCIe" failed to apply to 4.9-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:17:25 +0200
Message-ID: <1622301445227146@kroah.com>
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

From 0dc267b13f3a7e8424a898815dd357211b737330 Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:56 +0200
Subject: [PATCH] ath10k: Fix TKIP Michael MIC verification for PCIe

TKIP Michael MIC was not verified properly for PCIe cases since the
validation steps in ieee80211_rx_h_michael_mic_verify() in mac80211 did
not get fully executed due to unexpected flag values in
ieee80211_rx_status.

Fix this by setting the flags property to meet mac80211 expectations for
performing Michael MIC validation there. This fixes CVE-2020-26141. It
does the same as ath10k_htt_rx_proc_rx_ind_hl() for SDIO which passed
MIC verification case. This applies only to QCA6174/QCA9377 PCIe.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.c3f1d42c6746.I795593fcaae941c471425b8c7d5f7bb185d29142@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 12451ab66a19..87196f9bbdea 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1974,6 +1974,11 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 		}
 
 		ath10k_htt_rx_h_csum_offload(msdu);
+
+		if (frag && !fill_crypt_header &&
+		    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
+			status->flag &= ~RX_FLAG_MMIC_STRIPPED;
+
 		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
 					is_decrypted);
 
@@ -1991,6 +1996,11 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 
 		hdr = (void *)msdu->data;
 		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+
+		if (frag && !fill_crypt_header &&
+		    enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
+			status->flag &= ~RX_FLAG_IV_STRIPPED &
+					~RX_FLAG_MMIC_STRIPPED;
 	}
 }
 

