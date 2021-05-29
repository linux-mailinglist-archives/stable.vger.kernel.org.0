Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ACA394CC3
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhE2PTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:19:13 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:32865 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:19:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B3BA1940DEA;
        Sat, 29 May 2021 11:17:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=onYfr1
        kQXIKuhSRGVHEo0bk2rWSGaGNxjSAkLWysda4=; b=wj4cfrkvBQI/x8Ve1Q9Bvs
        NEKy0uv3txHlIsY3f5RoworSeMvECV0ujQTFNnc0JjooTQcGcCHY36H51wi9UMoN
        iMlTx99aZjRcomVOaBIcAHAam36ICDwOThxgOfxw+iYY3CloT3JN4IFtUY06jqWP
        6GktMwBUu5Kd8yMTSCu56Kga73FDuBvrWQ5ibiB/a/U1j7XVrVNU4LemuwIJbiyO
        Aa0juApzC6faJBpoCzYXzW3Jx2Qu439XWZfIkHVCY9QNi4L2tXFryuvNsm3nwWwm
        cgl6GBTWKuTnaEou5UQpYFjraTN4DVZZHPnRBVWxhQlV5pQytHXvZcLsqLvCYkfw
        ==
X-ME-Sender: <xms:EFuyYBobKhOdzbEjppJbYr3bQzpIZQ03xFqT93-Mzw-FF8HAlNEISA>
    <xme:EFuyYDoCNc2uJjzAcZDNQNv6OCLxZRNU3yxoW__d9iYG3aUq4pSpO3RlJnNoUly0B
    SWS8SAO5mt_iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EFuyYONmalDhYy4lQq1AcxXODRlb8NzlzNr4OkSUDS96gmgJZAZzpA>
    <xmx:EFuyYM4s5c1NfGCUwzP23UTrxCPo4V7CTmMHFeOTDEDD-3_cLL5WHQ>
    <xmx:EFuyYA7sAL-RfrxjUYwTsIgePZiPoFm-TPVoQ6RFWSYljDXX61aDhQ>
    <xmx:EFuyYOTDe2imaTtO7aVkRXzTM-n6jRmSzQEr5ftj9P87CmHM6s-UZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:17:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: Fix TKIP Michael MIC verification for PCIe" failed to apply to 4.4-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:17:25 +0200
Message-ID: <162230144517216@kroah.com>
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
 

