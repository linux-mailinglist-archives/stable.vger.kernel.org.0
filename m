Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169496CFF61
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjC3JAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjC3JAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 05:00:07 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A217AAD;
        Thu, 30 Mar 2023 02:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+ugixZ+XkTxTts9N5EMc/TLOjDm371nmVYbvX6WXngU=; b=tgz+mdgIsXdvtU+Q1LbH3Vxbq6
        nC/m5JeiJYf4Jgy6qxBg8ZXAHgu+uschcXXx/h3/2ukaGkQp51aV09xvTf5bbf6HUbkSPiI+CqMgp
        Sv9p4YnqXLzIipHp/YtWTRuUeNXO1WkdqhdaZly93Rl8D+mom2bbdjSGT9qZ/wrzcdsc=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pho8Y-008U3j-5R; Thu, 30 Mar 2023 11:00:02 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Subject: [PATCH wireless 1/2] wifi: mac80211: drop bogus static keywords in A-MSDU rx
Date:   Thu, 30 Mar 2023 11:00:00 +0200
Message-Id: <20230330090001.60750-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These were unintentional copy&paste mistakes.

Cc: stable@vger.kernel.org
Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7e270eaeef72..b7b584a28163 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2899,7 +2899,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
-	static ieee80211_rx_result res;
+	ieee80211_rx_result res;
 	struct ethhdr ethhdr;
 	const u8 *check_da = ethhdr.h_dest, *check_sa = ethhdr.h_source;
 
@@ -3040,7 +3040,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
-	static ieee80211_rx_result res;
+	ieee80211_rx_result res;
 	bool port_control;
 	int err;
 
-- 
2.39.0

