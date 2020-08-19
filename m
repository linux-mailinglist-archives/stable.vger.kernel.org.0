Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE64D249FB3
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgHSNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:25:22 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47185 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728548AbgHSNY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:24:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 919A41942CA0;
        Wed, 19 Aug 2020 09:24:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mHeWbO
        YURKbh/lrSEvcdsUZr8W5bL60ayhU3m6VdEto=; b=s+lJLwzPF7OmK6l+crrR6Z
        wyxGEyOFeUWm5LPapnf/ttuXpRAz0OHmEQYGmE87JwwG2FjH3r0S7r64KUSt5FaB
        1f0zo6FJBZSz5Ty1AGE5s75M4MXSppYOrLzcMB/ECWphIPUpd9LHlouJOkn2iOc4
        lHM1C4qlgNuhGoOZukagHf3OcrrK4mhF0BzMptNW5cUagRTDcZaqou/kDJdSEBsX
        Vkg6S+r4nJBcHR9tprzt89gGlQX03R1/8zf/kqN99Gppo+l9H6+KfQWqyz3QALIg
        kswFPGJC1TqOmz1olorQU1UWRilweQqFRsEnO8f2VFxTf3tM42P+3phVlDvl3P9A
        ==
X-ME-Sender: <xms:HSg9X7hv5GMGf-PGXzH3cN2Q4LEvZxkejjI4VhB43UWHmHN6ZwxWrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:HSg9X4D9OJovF5KE01kTnzhDzijcZKgWa3AkZeP5H6lqWe-acE8RcA>
    <xmx:HSg9X7FHZYe1UOPgRtyNVqkuLWDWcqTHtTdwYcobCeVfzh3Yk0ww-g>
    <xmx:HSg9X4T4l36MGWOhqn9gMmPqJip_WiK4WbuRFUMTbOsIbfxrGnNy9Q>
    <xmx:HSg9Xz-_hqlIujbdgtJ6MGDKg8SwkrBI9AzPRQ-6Jc64ujWToXZx7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 264F930600A9;
        Wed, 19 Aug 2020 09:24:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/imx: imx-ldb: Disable both channels for split mode in" failed to apply to 4.9-stable tree
To:     victor.liu@nxp.com, kernel@pengutronix.de, linux-imx@nxp.com,
        p.zabel@pengutronix.de, s.hauer@pengutronix.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:25:00 +0200
Message-ID: <1597843500209116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

