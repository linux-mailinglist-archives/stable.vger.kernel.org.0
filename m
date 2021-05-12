Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7FF37B8F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhELJTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:19:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58447 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhELJTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:19:23 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 309B8140F;
        Wed, 12 May 2021 05:18:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 05:18:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1AGd6m
        4ExGlaJJyB2B4gECiVZQZKSWWIeDQQfVHPGek=; b=S2mWbowdpHSUAp8V8uN1VO
        VLv/aHO2jvWzGRKCJX4vFww1XBgHuqhBTJXLpgL8Z0up7E+gHNCL3DR5RB5CTJo6
        1sAjXwxBiSt1iNF3XsNq8Wo+2K06HTNVqr6kQJH4P769crXyJffG425duLSmsRLr
        sLb3QJnJU05mM2q8ugyVRT1gWiWqI/Ew1vdZrEiwkA4I3bFj3R0Y1vWRGZdsRFRS
        VjVwZen4TGiCF8glxZ+EtC3Ueoi5awPKOW4o1cL6WhUoGuUJyVcMU+zWEb3aXdtV
        AeAp94Sf2ArSHVcSgASDDb9WKRIP48Ya7FW2pjz6a1nGD0t6NCKteWMwRnqUZjoA
        ==
X-ME-Sender: <xms:VZ2bYH3c3TgYgMoHtWKWQNgMmCcAH59jlDUFx94z4WDKqhaUc0Q_DA>
    <xme:VZ2bYGFLwXvNN8-STGEkgyyXD4p1tYbNt1vAVXx6pkj0wqgXg5vLK_kY5uWM_IGkz
    lOr9oYEJkJFtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VZ2bYH6W0u1jIhT9SoSjq9cSLtYx1RPhQnur3ZSwtOfrqcD7B1wb4A>
    <xmx:VZ2bYM2z6rqsA0KtosANfniY8cucB72OvLX0GELtu-LvXt6kfN53nQ>
    <xmx:VZ2bYKGAuDaoVnNuCGkD98fal_BfXYGDqlewuDg8T4UQibbdaqk_Eg>
    <xmx:Vp2bYPSgvPgbFGl7y6r4NEmKbgh5aqPB8tZJJ8TlbPhbdXuLxEp7u59hkwQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:18:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] phy: cadence: Sierra: Fix PHY power_on sequence" failed to apply to 5.4-stable tree
To:     kishon@ti.com, p.zabel@pengutronix.de, stable@vger.kernel.org,
        vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:18:11 +0200
Message-ID: <162081109123047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b4f5757f83be34d1428a1ffbb68d4a1966e9aae Mon Sep 17 00:00:00 2001
From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Fri, 19 Mar 2021 18:11:16 +0530
Subject: [PATCH] phy: cadence: Sierra: Fix PHY power_on sequence

Commit 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
de-asserts PHY_RESET even before the configurations are loaded in
phy_init(). However PHY_RESET should be de-asserted only after
all the configurations has been initialized, instead of de-asserting
in probe. Fix it here.

Fixes: 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20210319124128.13308-2-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index 26a0badabe38..19f32ae877b9 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -319,6 +319,12 @@ static int cdns_sierra_phy_on(struct phy *gphy)
 	u32 val;
 	int ret;
 
+	ret = reset_control_deassert(sp->phy_rst);
+	if (ret) {
+		dev_err(dev, "Failed to take the PHY out of reset\n");
+		return ret;
+	}
+
 	/* Take the PHY lane group out of reset */
 	ret = reset_control_deassert(ins->lnk_rst);
 	if (ret) {
@@ -616,7 +622,6 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	reset_control_deassert(sp->phy_rst);
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 put_child:

