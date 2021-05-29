Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C03394CBD
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhE2PSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:18:17 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:58273 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:18:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id BC1241940DEB;
        Sat, 29 May 2021 11:16:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XCsVdv
        wi15GYHgLyfpPMazG5J/Ig23QzzTS+tqRWoG4=; b=Wi+khCMUeff3kI3D9PJuZE
        AmoMoPhVIemMyNHoMW9x1popair8O5TrkyBA8jUOo7qOans/9reonJaC4A1Vek35
        7e9AmTIvdmuaXYaOsGpUAmhFHogaEYwKfMkeFUXtUV8t7aMmXHAejPhETsi+750W
        Z7kC7hkEjU8vtLDG6mfmEVX3eEm229HPXXTwmSUhQgnHwltLJNsrTBS5h8cka+op
        J2NQYuTnoX8LZygazkTwW05c5rA5h7UgJCujjVXI5yt4lHaOhHEuHdeGzp4RkxwC
        rG2RVqQgcNM9haSn7aJbTWTzMDhQvl5Zun3BiI5YmiRopH3wXP5VDIt95pfJpJ0g
        ==
X-ME-Sender: <xms:11qyYIkmcQqbNa_o272PDnVX7zhiaLwlZ_uE3nt3pj9Ru5975Cm8pg>
    <xme:11qyYH2aDrcCNBWmP4zb7nX_iP1xPxPit8LeFrOU9haqrbsR3wI3c4_i-l5fkEBJO
    WOn1_VHyOuhaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:11qyYGptoNiGUyAgESvccWh_s3rP4HpLLHwKGyw54MikmogjcGXQQQ>
    <xmx:11qyYEk-N21XhDRt4tcHfFux26BPFwKwY41LXTEadDTQPj26xJXaoA>
    <xmx:11qyYG3fChhLK28Uep1MJDZjxQsYdJo7pnDhdg_j7-SNd28uBHqADQ>
    <xmx:11qyYL9pstaUJ7vehvYEnedPl4VeycFdLmJuLCWQJHU4MLkyX54omQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop MPDU which has discard flag set by firmware for" failed to apply to 4.14-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:29 +0200
Message-ID: <162230138911789@kroah.com>
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

From 079a108feba474b4b32bd3471db03e11f2f83b81 Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:55 +0200
Subject: [PATCH] ath10k: drop MPDU which has discard flag set by firmware for
 SDIO

When the discard flag is set by the firmware for an MPDU, it should be
dropped. This allows a mitigation for CVE-2020-24588 to be implemented
in the firmware.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.11968c725b5c.Idd166365ebea2771c0c0a38c78b5060750f90e17@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index b1d93ff5215a..12451ab66a19 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2312,6 +2312,11 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
 	fw_desc = &rx->fw_desc;
 	rx_desc_len = fw_desc->len;
 
+	if (fw_desc->u.bits.discard) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt discard mpdu\n");
+		goto err;
+	}
+
 	/* I have not yet seen any case where num_mpdu_ranges > 1.
 	 * qcacld does not seem handle that case either, so we introduce the
 	 * same limitiation here as well.
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index f2b6bf8f0d60..705b6295e466 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -1282,7 +1282,19 @@ struct fw_rx_desc_base {
 #define FW_RX_DESC_UDP              (1 << 6)
 
 struct fw_rx_desc_hl {
-	u8 info0;
+	union {
+		struct {
+		u8 discard:1,
+		   forward:1,
+		   any_err:1,
+		   dup_err:1,
+		   reserved:1,
+		   inspect:1,
+		   extension:2;
+		} bits;
+		u8 info0;
+	} u;
+
 	u8 version;
 	u8 len;
 	u8 flags;

