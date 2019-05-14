Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A261C5F2
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENJWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 05:22:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51065 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbfENJWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 05:22:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 38408245C1;
        Tue, 14 May 2019 05:22:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 14 May 2019 05:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=y2gPqX
        D1tPZ4dZsekDWckzHjH/ds537pHcZhVbYhpoM=; b=wwkfUxFz4qdVbxU1sbZp8v
        D8N22zdbULs4l9k4FZfmXeXzE1NfWZaK2R3dp2e6evC2Qp207p32YzVdjCIgsv5/
        U7/daaWguvqQnwH/VNRi6M/NZM1wjKsuw7S4khQ2RQM0iHhk9Dp2ySHJR8j34GAW
        o/t14B/MsPKyK8xw7fanS8GLBRrMi0vjj9/nNRTOUX21o+tFbgGYZ17WwzzbhJsh
        Ap4PyabIkjNyYDEjgV7SW0Uw4vTUilv7a9D9G0TvLArn1yLpQk+FN0rlzWfFJz6/
        WsfnrdRRzxuOzRHZV0VIOu6LGOtN4ZYspqOVz3CkkQI71VMNOQolVK9S0SZHWDbA
        ==
X-ME-Sender: <xms:3ojaXDxGGSRDmuIxAnL4RwtaWGo8a-V7YI8duGJwmk3xt5vtBCTgbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepohhpvghnfihrthdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3ojaXCMtEPA4gnIfhF8QlI0mnHspY7AdxXkDexEX8Gl1Vo-RY11uQA>
    <xmx:3ojaXCb8o2cVnHSTe2c3pK2zeMIFcEjK00DfxQhLBkfugdZKYC6rCA>
    <xmx:3ojaXEq4GgENfziEMVAEZLMFqQ0gsv7TwTnb0WgjC3mBohd0nwRg7Q>
    <xmx:34jaXNBf8Q-nnl6THPMOV5noOG_T1J-_iq5hNHP6UOA1l-xUuoCDMQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5091180059;
        Tue, 14 May 2019 05:22:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mwl8k: Fix rate_idx underflow" failed to apply to 4.9-stable tree
To:     ynezz@true.cz, bunnier@gmail.com, kvalo@codeaurora.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 May 2019 11:22:36 +0200
Message-ID: <155782575614882@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6b583201fa219b7b1b6aebd8966c8fd9357ef9f4 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Date: Thu, 11 Apr 2019 20:13:30 +0200
Subject: [PATCH] mwl8k: Fix rate_idx underflow
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It was reported on OpenWrt bug tracking system[1], that several users
are affected by the endless reboot of their routers if they configure
5GHz interface with channel 44 or 48.

The reboot loop is caused by the following excessive number of WARN_ON
messages:

 WARNING: CPU: 0 PID: 0 at backports-4.19.23-1/net/mac80211/rx.c:4516
                             ieee80211_rx_napi+0x1fc/0xa54 [mac80211]

as the messages are being correctly emitted by the following guard:

 case RX_ENC_LEGACY:
      if (WARN_ON(status->rate_idx >= sband->n_bitrates))

as the rate_idx is in this case erroneously set to 251 (0xfb). This fix
simply converts previously used magic number to proper constant and
guards against substraction which is leading to the currently observed
underflow.

1. https://bugs.openwrt.org/index.php?do=details&task_id=2218

Fixes: 854783444bab ("mwl8k: properly set receive status rate index on 5 GHz receive")
Cc: <stable@vger.kernel.org>
Tested-by: Eubert Bao <bunnier@gmail.com>
Reported-by: Eubert Bao <bunnier@gmail.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index e0df51b62e97..70e69305197a 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -441,6 +441,9 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_BASTREAM		0x1125
 
+#define MWL8K_LEGACY_5G_RATE_OFFSET \
+	(ARRAY_SIZE(mwl8k_rates_24) - ARRAY_SIZE(mwl8k_rates_50))
+
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
 	u16 command = le16_to_cpu(cmd);
@@ -1016,8 +1019,9 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}
@@ -1124,8 +1128,9 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	if (rxd->channel > 14) {
 		status->band = NL80211_BAND_5GHZ;
-		if (!(status->encoding == RX_ENC_HT))
-			status->rate_idx -= 5;
+		if (!(status->encoding == RX_ENC_HT) &&
+		    status->rate_idx >= MWL8K_LEGACY_5G_RATE_OFFSET)
+			status->rate_idx -= MWL8K_LEGACY_5G_RATE_OFFSET;
 	} else {
 		status->band = NL80211_BAND_2GHZ;
 	}

