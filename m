Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BEA249FB5
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgHSNZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:25:33 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60229 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728531AbgHSNYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:24:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CC7511942BBA;
        Wed, 19 Aug 2020 09:24:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zEeKYM
        PxQ5ZqMVow5M09MbdK1MrIl0Uo8E9fisWK9Ig=; b=HVU1kJ8WTfPkU7akuJtNEL
        5Z2k3Z4lI2MjKamU7RFl12ShXifBQ5s+wOJwZi5Mj8ybsQqpaKIqsq2gLXOSCkJ1
        NdYsclzgXa47gld8U2Cw3RLhAOafNbTSJPCzTSLQSAcGer6a/ZkomIFm6HQQcnBM
        KwBq1iMSkt+jnUxvplzpPCTWgLWVDlrkeFDRITbm9+DQJkWeozrnmnczFXuYixT6
        VATTldKgbms8NenDjaBspSptpC9ScywdLuYTzdgHWNKx5K0rVlU5q4f8EianAvo6
        IZYSTz/RD1ZTFjAWWNC7D50JpdVposVKiVCXNsO0dfcoOL3KFl6TgCAyLxi7fCsA
        ==
X-ME-Sender: <xms:FSg9X6HgT69ikaT55sdis72Fu4yGP6FHVOlO1yu-AZo6o4VzzMuLvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:FSg9X7VmNWPukNpHT2nD1FWW-eIYdrBkbci8bVh8vemoxGg7hTl13Q>
    <xmx:FSg9X0KxP9Q0CR4_AaWIvq_YQS0jPAKCNvdodGR9VPUHe89IKaOxug>
    <xmx:FSg9X0ExG4L9D9LwesqoM1K9wRHxdqgEkO-doRVaRTpekDgQ-N_q9w>
    <xmx:FSg9X9irzA9bFvlmP7y4FbTNOwhsED8bYoxHGF4LDwwJpcJHtfgZZA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4088D3060067;
        Wed, 19 Aug 2020 09:24:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/imx: imx-ldb: Disable both channels for split mode in" failed to apply to 4.4-stable tree
To:     victor.liu@nxp.com, kernel@pengutronix.de, linux-imx@nxp.com,
        p.zabel@pengutronix.de, s.hauer@pengutronix.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:24:59 +0200
Message-ID: <1597843499228188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b2a999582c467d1883716b37ffcc00178a13713 Mon Sep 17 00:00:00 2001
From: Liu Ying <victor.liu@nxp.com>
Date: Thu, 9 Jul 2020 10:28:52 +0800
Subject: [PATCH] drm/imx: imx-ldb: Disable both channels for split mode in
 enc->disable()

Both of the two LVDS channels should be disabled for split mode
in the encoder's ->disable() callback, because they are enabled
in the encoder's ->enable() callback.

Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 909682a74474..8791d60be92e 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -296,18 +296,19 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux, ret;
 
 	drm_panel_disable(imx_ldb_ch->panel);
 
-	if (imx_ldb_ch == &ldb->channel[0])
+	if (imx_ldb_ch == &ldb->channel[0] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
-	else if (imx_ldb_ch == &ldb->channel[1])
+	if (imx_ldb_ch == &ldb->channel[1] || dual)
 		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
 
-	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
+	if (dual) {
 		clk_disable_unprepare(ldb->clk[0]);
 		clk_disable_unprepare(ldb->clk[1]);
 	}

