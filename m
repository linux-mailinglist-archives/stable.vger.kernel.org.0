Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF58394CBE
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhE2PST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:18:19 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:48087 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:18:18 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id A66C31940DC0;
        Sat, 29 May 2021 11:16:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 29 May 2021 11:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HgMimh
        WkjMjOBvnwxu3WSOq7sHvbD+5xfTjwm6UdUiA=; b=h8xdir+wGJ7GJCYs4Rg8zO
        pePpEl4CklDySII/fXpuxc9a8ZXg3pQ6qCstdqEVBZae8wqnMonHNTtjTnZFZ63w
        xTtO5FGcEGctvsD8MpGLfQXwl4wfXP1d5fc4KWOKj2xxhkFo6aG/0LVHoO/UiZxj
        8gADXBu2lnCpsrb6T6xjBL4Ut7X0YV6aJL3YXCkErWrXa0WU58aUKTQy59+th4dR
        JIuyLpkpRwI0KpC+kycFUgig3Qmis3YkGu9kVkvDGmJxlBXsZj21ZhLpWkJ80i8l
        sx7nW5Q7L9+McMC0K4M6i2eyKhk8Z8Ua4COO7v+8x05NKlgkArkZqwuMUQSTsf1A
        ==
X-ME-Sender: <xms:2VqyYDPXVzoY1krIEsrNLtPBn6ER3cA3rnoOcn6qiX2D8ZQhayJCwA>
    <xme:2VqyYN-OuKfTNHevHAroEA5OH7HO9muG61WSZfQM49UiGuF6Pbhcbe7-mhJd3rNrS
    BMkTnebTkGL0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2VqyYCSH5UhVTPRJM_tcY2ZKAZjggCkAJYqviO5FJj5sRkSwO95koQ>
    <xmx:2VqyYHtOOFP0WJ1hJ7yHp12T-fvtuWLkRKeDLjmmA-xt5WvkxAtWzA>
    <xmx:2VqyYLewI0WUPvlIkWzlcJuZCkDvuXsNF60KItxlxlmIvM_JNu2GZQ>
    <xmx:2VqyYDGOHoshQGWS3oPk72SawcaS1jBBBPsYgA7681OsQmRpVgZPvg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop MPDU which has discard flag set by firmware for" failed to apply to 4.9-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:29 +0200
Message-ID: <1622301389146126@kroah.com>
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

