Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E93C3CBA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKNIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:08:39 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49163 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhGKNIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:08:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3D0CC1AC04BC;
        Sun, 11 Jul 2021 09:05:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 09:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Mx71Qh
        2deobOXHyGCJFch/7fYmqQjKJmvf8eOhlTLV4=; b=XnvgLyZKuKYr7U/+VJM2G+
        jsm5Gq4RqcFpNdPperx3tODV7VCiiFHXJsOREkzlqSEkr7e+FQCK3XEl57E3MYx8
        pJqDOj1xiNbXNOwsoQH61gK7U1RSPLPlv4ApWo6ZUEsui38xzlhePvyHZ5mdAbg8
        5ap3Gfb5Z9XgWsE8PpOm7Jl+JxV4Lx8jT3IMX0bwvf3D6xFNA2DzF1tuuV55zntj
        bvVCbwnEFuKwz9j0xdE0unnBhAFDGa8WGBRLDjY+nYssu26x2ABpbVHOtxkYu5YH
        ffwt+h3+yZ9W5UAi66EWVJGIhNcpz7B6Ua8NiNK6MRgXOrknZ7/5Fa0q8rYXRfKw
        ==
X-ME-Sender: <xms:r-zqYBLZvXle0jcOZD2RXOBwb99IPEQ9UKAlB6Z5ZyyP31th4xsJhg>
    <xme:r-zqYNK0aWd-4TzawkT9dhFv63f8iYkETqUOvtEmB0yqFnxtGQfseIHGTTaVZC2_3
    AiO9J23G1pxog>
X-ME-Received: <xmr:r-zqYJsBb8WKkUBp_2FG1ulbSlOfsrYci98zNEma7Xmt8u1CmkXqgSzL2VeiAvgJy63B4kc-jQnuwS10XdoV3QM2RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeegheeggedujefghfevleffjeefgfehvefgleeuuddtue
    fgveelfefftdffgfelleenucffohhmrghinhepshhpihhnihgtshdrnhgvthdpkhgvrhhn
    vghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:r-zqYCZdfPWSQRlUF7tLwYgTq17NXteXqDZl5PUtMBMRXT0JZk-6jg>
    <xmx:r-zqYIaR71BkhaHOPpQlEiS5Hrp2x4h59T6_am7XZgq10QSgwLNQkA>
    <xmx:r-zqYGD2LY_0c7Sq_IuoRRC-G-oKd77wGgkp5JLD_m8dvUcDu7OETQ>
    <xmx:r-zqYDyntw4HqR68YRacJsIuKW3X4xJQDE_tfsb-GBBmj0t_xrceYNmR3Xw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:05:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rsi: fix AP mode with WPA failure due to encrypted EAPOL" failed to apply to 4.14-stable tree
To:     martin.fuzzey@flowbird.group, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:05:49 +0200
Message-ID: <16260087499216@kroah.com>
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

From 314538041b5632ffaf64798faaeabaf2793fe029 Mon Sep 17 00:00:00 2001
From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Tue, 1 Jun 2021 18:19:53 +0200
Subject: [PATCH] rsi: fix AP mode with WPA failure due to encrypted EAPOL

In AP mode WPA2-PSK connections were not established.

The reason was that the AP was sending the first message
of the 4 way handshake encrypted, even though no pairwise
key had (correctly) yet been set.

Encryption was enabled if the "security_enable" driver flag
was set and encryption was not explicitly disabled by
IEEE80211_TX_INTFL_DONT_ENCRYPT.

However security_enable was set when *any* key, including
the AP GTK key, had been set which was causing unwanted
encryption even if no key was avaialble for the unicast
packet to be sent.

Fix this by adding a check that we have a key and drop
the old security_enable driver flag which is insufficient
and redundant.

The Redpine downstream out of tree driver does it this way too.

Regarding the Fixes tag the actual code being modified was
introduced earlier, with the original driver submission, in
dad0d04fa7ba ("rsi: Add RS9113 wireless driver"), however
at that time AP mode was not yet supported so there was
no bug at that point.

So I have tagged the introduction of AP support instead
which was part of the patch set "rsi: support for AP mode" [1]

It is not clear whether AP WPA has ever worked, I can see nothing
on the kernel side that broke it afterwards yet the AP support
patch series says "Tests are performed to confirm aggregation,
connections in WEP and WPA/WPA2 security."

One possibility is that the initial tests were done with a modified
userspace (hostapd).

[1] https://www.spinics.net/lists/linux-wireless/msg165302.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: 38ef62353acb ("rsi: security enhancements for AP mode")
CC: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index ab837921d9a4..99b21a2c8386 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -203,7 +203,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
-	    (common->secinfo.security_enable)) {
+	    info->control.hw_key) {
 		if (rsi_is_cipher_wep(common))
 			ieee80211_size += 4;
 		else
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index d9f1e73293aa..b66975f54567 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1045,7 +1045,6 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 	mutex_lock(&common->mutex);
 	switch (cmd) {
 	case SET_KEY:
-		secinfo->security_enable = true;
 		status = rsi_hal_key_config(hw, vif, key, sta);
 		if (status) {
 			mutex_unlock(&common->mutex);
@@ -1064,8 +1063,6 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 		break;
 
 	case DISABLE_KEY:
-		if (vif->type == NL80211_IFTYPE_STATION)
-			secinfo->security_enable = false;
 		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
 		memset(key, 0, sizeof(struct ieee80211_key_conf));
 		status = rsi_hal_key_config(hw, vif, key, sta);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index dffe1d6cc592..891fd5f0fa76 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1803,8 +1803,7 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 			RSI_WIFI_MGMT_Q);
 	cmd_frame->desc.desc_dword0.frame_type = WOWLAN_CONFIG_PARAMS;
 	cmd_frame->host_sleep_status = sleep_status;
-	if (common->secinfo.security_enable &&
-	    common->secinfo.gtk_cipher)
+	if (common->secinfo.gtk_cipher)
 		flags |= RSI_WOW_GTK_REKEY;
 	if (sleep_status)
 		cmd_frame->wow_flags = flags;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a1065e5a92b4..0f535850a383 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -151,7 +151,6 @@ enum edca_queue {
 };
 
 struct security_info {
-	bool security_enable;
 	u32 ptk_cipher;
 	u32 gtk_cipher;
 };

