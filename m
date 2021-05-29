Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBCF394C91
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhE2O4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 10:56:35 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36133 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229698AbhE2O4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 10:56:34 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id E37DA1940DEA;
        Sat, 29 May 2021 10:54:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 29 May 2021 10:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aYXv+r
        Yiu3QpzoF3q80FZ7WsGkHrWQoxrQrFshHCqzk=; b=EHCg4cuQLbh7taZXiUnZBo
        OEdBgATU/fIwpR+bPBxXVc9P/oOizZ70+tGYtCNdafIWtz0t1kjrM95vMwTY1D7y
        wzA8SgPt08EMpaGZPm839B5hNZC0DeHJzBPMYNHJgECvFk0d/YyIYKSblVT0BLg1
        Z8jTy9mR469eJAP8ejqdcFgVsM1w62FVIKD+h1Xxls7o+MTI+KAril4Oe60v2/+F
        Cy8jWVtHjFkBTyjTShZ8jk6R7Rolncxr6KeLzoiVgQe6EV+g1uvCoFA44fAnxUcv
        S7tFXPMwVqCM3+jKzVcKzmWYkg4Be+uQMhMnPmz3ZfRQURfViTNZGzWB2m4zZ9KA
        ==
X-ME-Sender: <xms:wVWyYDFzDtCT9_az_XwqU3Uxu-8jM8ndSEf4xLJpMPbkzoz4uR3PHQ>
    <xme:wVWyYAUux4ipfFDWvc3bzWjuoeV4NTDzxXrligbPhFtaEyjFqFKN1kNO4pU-2yGVd
    JZOgQxDwrtewg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wVWyYFJuI-rJqxVeo_EAJnLrOQcR-ot49KKajkxnsexBqcB49fW2FQ>
    <xmx:wVWyYBERr5rl9X_o2kWMN6OEWJQutacOJnm2sASW5RIhGPr3b9OgJg>
    <xmx:wVWyYJVOz9shB12wsMmksOT6pe7EvIMOidEY8_SfTi5i7_QInGxsFA>
    <xmx:wVWyYIA8v4j4BIZgcwjVqVygV8bETzT7j-kRIlg08xYotMZSKXKTDg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 10:54:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: drop A-MSDUs on old ciphers" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 16:54:48 +0200
Message-ID: <1622300088174156@kroah.com>
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

From 270032a2a9c4535799736142e1e7c413ca7b836e Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 11 May 2021 20:02:46 +0200
Subject: [PATCH] mac80211: drop A-MSDUs on old ciphers

With old ciphers (WEP and TKIP) we shouldn't be using A-MSDUs
since A-MSDUs are only supported if we know that they are, and
the only practical way for that is HT support which doesn't
support old ciphers.

However, we would normally accept them anyway. Since we check
the MMIC before deaggregating A-MSDUs, and the A-MSDU bit in
the QoS header is not protected in TKIP (or WEP), this enables
attacks similar to CVE-2020-24588. To prevent that, drop A-MSDUs
completely with old ciphers.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.076543300172.I548e6e71f1ee9cad4b9a37bf212ae7db723587aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f14d32a5001d..8a72d48ad6e0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -6,7 +6,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #include <linux/jiffies.h>
@@ -2739,6 +2739,23 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (is_multicast_ether_addr(hdr->addr1))
 		return RX_DROP_UNUSABLE;
 
+	if (rx->key) {
+		/*
+		 * We should not receive A-MSDUs on pre-HT connections,
+		 * and HT connections cannot use old ciphers. Thus drop
+		 * them, as in those cases we couldn't even have SPP
+		 * A-MSDUs or such.
+		 */
+		switch (rx->key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+			return RX_DROP_UNUSABLE;
+		default:
+			break;
+		}
+	}
+
 	return __ieee80211_rx_h_amsdu(rx, 0);
 }
 

