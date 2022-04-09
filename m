Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819EA4FA23A
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 06:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiDIEPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 00:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiDIEPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 00:15:03 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6348ED399D;
        Fri,  8 Apr 2022 21:12:57 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 953413201FED;
        Sat,  9 Apr 2022 00:12:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 09 Apr 2022 00:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=4IOIHeCPahu18m
        XrSxL18izkRq7PcU2ik7+XDSoutzQ=; b=APB0YY7IuFNdX0tRyjaWJ2ji1+8e4H
        oe+DmPaIVCp68N7ERJT2afcFSYTrYuGDOV5/CLdJW4R/M2yqPF2jqYvURSR4XweN
        C4baOJooMG7wKxbmSfOnndIV6q/xlkBey2lGxAoxLFu43NgXGfo4F5k05w+FtjxP
        iG/hHr6mUYLFpTkEzpTHpV9r6GBdL1mrAPpwVE2W4CfjQzxQAHXclOTTne1JkTTJ
        aCAj71nK1sD4KUdQYmGXKSZxfNY8tsCMSku5k1wR3Y+J3lC8yWMuqfXLCtoHoqfK
        fmV6Xl0n8QqZ1WHPQbiZg8lUF2bK9Px2FBNWC+m+seeWxzK6S52dy2IA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4IOIHe
        CPahu18mXrSxL18izkRq7PcU2ik7+XDSoutzQ=; b=TJHeDKptwJcAYqlnKQEKGq
        3x48SXXw6MuBE0M7wBwqsuLR8hYZWWKiLx+R527mKqAUcSv+Cqa6dVbiO7Sq2mij
        HJ0eFsj917POjnfiC9tiUqgUL1RftvVsRB0RJ5oV9VSqdL/CvSMgj/B2VewH2aUd
        9pwpM8yw4xZXr4x+YT9yTUr7lQ5BetcFSVYDHW/fto8KmtzAQmLSkJUXHcOgmbDf
        b3VTXH3I3YgoEpJAtyzXppyN581DkyDSrRe3F4Wre0Sk+YytRS0iQn2JpgOAKfU9
        JQPVBlsR8QCKThfUztaqD2Z3yfcRs3ojjWhE+BgpZbGnHBak6dymYUSjJXNcTL2Q
        ==
X-ME-Sender: <xms:yAdRYsKkR6fsXQcy5Ul-ulGk0PckdjjsZjSv4r-sO6VmYQCzsRlVqg>
    <xme:yAdRYsKOVf42OpUF6T5D8WHO3SOCOsoPtyoizN6c9CL2k-kMC1UMXq2qgV-grAg9b
    TGFZ0VNJNYv6MoKyxk>
X-ME-Received: <xmr:yAdRYsts6Pa8J9QJmtZL_QuTl9XzDZzCciJ79REVzzwY33rbadr3RClNdBqTAfl057-5xa4ULu0SX6lJKVe2PR-MEc1cC0DIlg9yYmbqcw_wWbmifH8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekuddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefvrghkrghs
    hhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjh
    hpqeenucggtffrrghtthgvrhhnpeevfefffeektefgveegfeelheffhfeujedtjeevtefh
    keevkedtjeejvddtjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjhhp
X-ME-Proxy: <xmx:yAdRYpYgvIxax5GQvs0APY_MjMRZIlPJo48dd2t5_81tdihfjPh52A>
    <xmx:yAdRYjZo7EspOiSbAk4-fJ4c9t0_r1CJpi6Vrgccv3vVPpPNogioCA>
    <xmx:yAdRYlB_9x-rWPvkO8_PNr0RQZlPmFbHlupl4rVgi4oHEfUtRRKIkA>
    <xmx:yAdRYiUyTCcFik1ZRixzVGiNLxErsSoVoOh7G8i4vDHUMtV8kYtSkw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 9 Apr 2022 00:12:54 -0400 (EDT)
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     tiwai@suse.de
Cc:     linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Niels Dossche <dossche.niels@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] firewire: core: extend card->lock in fw_core_handle_bus_reset
Date:   Sat,  9 Apr 2022 13:12:43 +0900
Message-Id: <20220409041243.603210-4-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220409041243.603210-1-o-takashi@sakamocchi.jp>
References: <20220409041243.603210-1-o-takashi@sakamocchi.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

card->local_node and card->bm_retries are both always accessed under
card->lock.
fw_core_handle_bus_reset has a check whose condition depends on
card->local_node and whose body writes to card->bm_retries.
Both of these accesses are not under card->lock. Move the lock acquiring
of card->lock to before this check such that these accesses do happen
when card->lock is held.
fw_destroy_nodes is called inside the check.
Since fw_destroy_nodes already acquires card->lock inside its function
body, move this out to the callsites of fw_destroy_nodes.
Also add a comment to indicate which locking is necessary when calling
fw_destroy_nodes.

Cc: <stable@vger.kernel.org>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 drivers/firewire/core-card.c     | 3 +++
 drivers/firewire/core-topology.c | 9 +++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 54be88167c60..f3b3953cac83 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -668,6 +668,7 @@ EXPORT_SYMBOL_GPL(fw_card_release);
 void fw_core_remove_card(struct fw_card *card)
 {
 	struct fw_card_driver dummy_driver = dummy_driver_template;
+	unsigned long flags;
 
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
@@ -682,7 +683,9 @@ void fw_core_remove_card(struct fw_card *card)
 	dummy_driver.stop_iso		= card->driver->stop_iso;
 	card->driver = &dummy_driver;
 
+	spin_lock_irqsave(&card->lock, flags);
 	fw_destroy_nodes(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	/* Wait for all users, especially device workqueue jobs, to finish. */
 	fw_card_put(card);
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index b63d55f5ebd3..f40c81534381 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -375,16 +375,13 @@ static void report_found_node(struct fw_card *card,
 	card->bm_retries = 0;
 }
 
+/* Must be called with card->lock held */
 void fw_destroy_nodes(struct fw_card *card)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&card->lock, flags);
 	card->color++;
 	if (card->local_node != NULL)
 		for_each_fw_node(card, card->local_node, report_lost_node);
 	card->local_node = NULL;
-	spin_unlock_irqrestore(&card->lock, flags);
 }
 
 static void move_tree(struct fw_node *node0, struct fw_node *node1, int port)
@@ -510,6 +507,8 @@ void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
 	struct fw_node *local_node;
 	unsigned long flags;
 
+	spin_lock_irqsave(&card->lock, flags);
+
 	/*
 	 * If the selfID buffer is not the immediate successor of the
 	 * previously processed one, we cannot reliably compare the
@@ -521,8 +520,6 @@ void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
 		card->bm_retries = 0;
 	}
 
-	spin_lock_irqsave(&card->lock, flags);
-
 	card->broadcast_channel_allocated = card->broadcast_channel_auto_allocated;
 	card->node_id = node_id;
 	/*
-- 
2.34.1

