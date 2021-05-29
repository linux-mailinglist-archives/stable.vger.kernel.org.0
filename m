Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB3394CBA
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhE2PSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:18:07 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:39991 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhE2PSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:18:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 97E691940DC0;
        Sat, 29 May 2021 11:16:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TtqowI
        hi++u4KEBVgU1u26Eks3xuDrEuvBuoyXLDhfM=; b=qn1ogliU4U0kAxqvYCucvF
        BwAO1rNp8Dl0FZpLT/x4V+OLiC9nokXlpUJPt8UrDIbABLLnG4N2AMx+Go7jODHk
        0479BukwrrUOWx4mO1Dr8huaStB2/PxjWBhFQwbxYDo0fXhOG0uHRfDUoiXQFdF+
        +OIQ/rQUqJ9JhXc8fb039XqJLQqHjulxdbnAE+HA/ezRXx8mBp42LEMrxEmORGIc
        9GgIDGpogGUDBXJldWkLHYL5l4ZxDe+6+1pIiSNOLMZJpnYTn3xOrnR7kJGtDSpG
        H/gcBRrMhXa9Bo58fUvIXj0Oeigu8ZqLOkcnfZe2NI3FG6yW0ItJIR1CtIDJfHyw
        ==
X-ME-Sender: <xms:zlqyYKY4-gCYZq5RTeu7HM5SC74zp3q-5ajLfGuy2fh2ebI9fe9XQA>
    <xme:zlqyYNZeba75MeB58p9sKI6qTIlBH2NmUiPYrvepAuhWB1Fe4tLHW-I-ltZKfm3wH
    f8OS-MzQJ0tIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zlqyYE_9bYBsSNOkR9rQ_hhlIKtyb3UxXd_V8Pa1O2c65Cs5Lautew>
    <xmx:zlqyYMpAIczoSRU9PzRKBYsHEE9Lg7fVg8hCBhtaeGyCVHi-p6UO5w>
    <xmx:zlqyYFrW2ey2IC3SLwn51sGgtF5bJSoWRyHnP4UDOqsvjTMRirjV_w>
    <xmx:zlqyYGDbD-ZWcfqjRh4GnHQQhmoAjsum39w6_gYN191x3N95eNhgoQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:16:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: drop MPDU which has discard flag set by firmware for" failed to apply to 4.19-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:16:29 +0200
Message-ID: <1622301389157114@kroah.com>
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

