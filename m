Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300E2197D01
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgC3NeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:34:01 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:35739 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgC3NeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 09:34:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3301F5FC;
        Mon, 30 Mar 2020 09:34:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 09:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TomnyI
        +lunWDmukAnYGYZNDxIM0bTVYBIjQecqMipSg=; b=FFlE2BkP/xtGDFQ8BiENvN
        RA3OPIpx1jYiSZYQYkQBCkYFctzwgPYke7NYVgvXLC6pf/h0rgVAdFfqA5zCUiS8
        9Lz6HQQxbSqeocYJj4ds7qcUD+sIjn2coyhXsNBE2Dp+uFJV/z9pLBQphwW5yfYr
        DHMnOeZ0CBdXB8FYjwOK/tqq5OxLJC6tYH+uXUqQ89MZc45ep+GxDIbH+XqLSO20
        k3h1ymN0XRoUIeh7inY6EGFz6aDS4V18ZRbAesqW7B8fD/ysZnM5iNxMWoTonDLh
        3ESqPllTWi+5qO9SBJP5sGFOiVA/ZIw5xjXUwqBVv+jfxFpd+0d5t6vfs26a4uNA
        ==
X-ME-Sender: <xms:R_WBXjVI38SHl1eJlA4BSezsIPVl3hU1CP9AWf52fLSJ-fFVlnNZoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:R_WBXv1R8pXMHHGr9NX_lXQCMu41gC-fFGCYH2aiWfsUHOD8EL_myw>
    <xmx:R_WBXqYjvUp00y9u72VluoV7CN6FTsu7WOW3Q-VudPo3fBjkyHXp6g>
    <xmx:R_WBXipblqCwA0Zt0MFdrZKFUbx9PgjHE0a7BSIPiA3zZCvzW7y8ww>
    <xmx:R_WBXqhX70rjrPy08_SUmDjU03n1vpXsL3EmQWoyki4ZsJut8ZwxGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E6B84306C9CA;
        Mon, 30 Mar 2020 09:33:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211" failed to apply to 4.19-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Mar 2020 15:33:56 +0200
Message-ID: <158557523660185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From b95d2ccd2ccb834394d50347d0e40dc38a954e4a Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 26 Mar 2020 15:53:34 +0100
Subject: [PATCH] mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211
 TX

When a frame is transmitted via the nl80211 TX rather than as a
normal frame, IEEE80211_TX_CTRL_PORT_CTRL_PROTO wasn't set and
this will lead to wrong decisions (rate control etc.) being made
about the frame; fix this.

Fixes: 911806491425 ("mac80211: Add support for tx_control_port")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200326155333.f183f52b02f0.I4054e2a8c11c2ddcb795a0103c87be3538690243@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 455eb8e6a459..d9cca6dbd870 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018, 2020 Intel Corporation
  *
  * Transmit and frame generation functions.
  */
@@ -5149,6 +5149,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ethhdr *ehdr;
+	u32 ctrl_flags = 0;
 	u32 flags;
 
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
@@ -5158,6 +5159,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	    proto != cpu_to_be16(ETH_P_PREAUTH))
 		return -EINVAL;
 
+	if (proto == sdata->control_port_protocol)
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+
 	if (unencrypted)
 		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	else
@@ -5183,7 +5187,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, ctrl_flags);
 	local_bh_enable();
 
 	return 0;

