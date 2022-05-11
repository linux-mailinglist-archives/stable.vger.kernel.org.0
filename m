Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E17523E47
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 22:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347510AbiEKUCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347496AbiEKUCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 16:02:18 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B821D48C7;
        Wed, 11 May 2022 13:02:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w24so3836647edx.3;
        Wed, 11 May 2022 13:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kjm5oS3T2QJVIaXZ5HMZbY1xpEdNpJDDRAUvlhwNL3U=;
        b=fWLBtbzzyS2l1AlhhPCQYPbP0/60RK4VuD7QGsdqBsun6IeBZ6VTM5h24bDkrGOSlr
         lJrBNXdfN4rJXa0yKhXjdEDaWxrDgdI+4G6soL2J+jOZwz5Lt4asExh7ji6syOUh5fWD
         P0ir99Ci4OoyAGJJMxErxke1NVt3tUuzD3aebDWaj+AvgZ/K3vWFcd/hx9riGmx5F9B9
         ufNribfsGhluK6DJsCdb6FE9NZ0Er3WFJ24uFmDoZspty1JQS0h8vT3l8gfltWEbh43v
         hQfndi/TW5GFxdS1q0BmyH7oXU7DR++pXUHbOd2HGgYgqLMfgYdph9MCybFMPiD5Oys/
         YMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kjm5oS3T2QJVIaXZ5HMZbY1xpEdNpJDDRAUvlhwNL3U=;
        b=ssgOTGYqLjtS9ooR6mr6cV+hR5MGmwuRHLNzZqfIh6KRKp7vOxPT0Sada0o9et2t2v
         SbUjEEARBENwt8b/3rtk6ZpqlJKUxfPQ7QL3WZJ+BrXw8KEQl/VEAnYoy1dd0KOVEWYs
         leBJB6Enbau5CYd19xDzTRYKmWa19ghy0b3L2ryZKGXqhnEqQc4QVIIPEqDrRkg0zwoA
         jkF/ykx+JW2TfTN6UPjOkgycDeOo0GbLftoMN6XVheTdtWkqxYC7UEJiVMsdiyUUPtQT
         ZRxhpZY5uidnXR1bpwyZlxo/l9wrrZ6cREuLBGYv15OyrpuI8yPYP81zLB8m6bmXm1At
         OKpw==
X-Gm-Message-State: AOAM533xV/sq7izbeSIcD5QP4eg5lJuaAYS9UwIKu6bNihEZ/Vv1Fr93
        ie4JTgDetVSP6h0LKs+qd54=
X-Google-Smtp-Source: ABdhPJwuzCry90j1P+q2DVpYYiCsCxEejAfdbC7nAd7VZk2GginTD4rVQkbU+m7YqZcYCq5h35e5fg==
X-Received: by 2002:a05:6402:d0e:b0:413:3d99:f2d6 with SMTP id eb14-20020a0564020d0e00b004133d99f2d6mr31504260edb.189.1652299335444;
        Wed, 11 May 2022 13:02:15 -0700 (PDT)
Received: from kista.localdomain (cpe1-3-76.cable.triera.net. [213.161.3.76])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906060800b006f3ef214e0esm1347602ejb.116.2022.05.11.13.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 13:02:14 -0700 (PDT)
From:   Jernej Skrabec <jernej.skrabec@gmail.com>
To:     mturquette@baylibre.com, sboyd@kernel.org, a.zummo@towertech.it,
        alexandre.belloni@bootlin.com
Cc:     wens@csie.org, samuel@sholland.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "clk: sunxi-ng: sun6i-rtc: Add support for H6"
Date:   Wed, 11 May 2022 22:02:06 +0200
Message-Id: <20220511200206.2458274-1-jernej.skrabec@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 1738890a3165ccd0da98ebd3e2d5f9b230d5afa8.

Commit 1738890a3165 ("clk: sunxi-ng: sun6i-rtc: Add support for H6")
breaks HDMI output on Tanix TX6 mini board. Exact reason isn't known,
but because that commit doesn't actually improve anything, let's just
revert it.

Cc: stable@vger.kernel.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
---
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c | 15 ---------------
 drivers/rtc/rtc-sun6i.c              | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c b/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
index 2f3ddc908ebd..d65398497d5f 100644
--- a/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
+++ b/drivers/clk/sunxi-ng/ccu-sun6i-rtc.c
@@ -298,10 +298,6 @@ static const struct sunxi_ccu_desc sun6i_rtc_ccu_desc = {
 	.hw_clks	= &sun6i_rtc_ccu_hw_clks,
 };
 
-static const struct clk_parent_data sun50i_h6_osc32k_fanout_parents[] = {
-	{ .hw = &osc32k_clk.common.hw },
-};
-
 static const struct clk_parent_data sun50i_h616_osc32k_fanout_parents[] = {
 	{ .hw = &osc32k_clk.common.hw },
 	{ .fw_name = "pll-32k" },
@@ -314,13 +310,6 @@ static const struct clk_parent_data sun50i_r329_osc32k_fanout_parents[] = {
 	{ .hw = &osc24M_32k_clk.common.hw }
 };
 
-static const struct sun6i_rtc_match_data sun50i_h6_rtc_ccu_data = {
-	.have_ext_osc32k	= true,
-	.have_iosc_calibration	= true,
-	.osc32k_fanout_parents	= sun50i_h6_osc32k_fanout_parents,
-	.osc32k_fanout_nparents	= ARRAY_SIZE(sun50i_h6_osc32k_fanout_parents),
-};
-
 static const struct sun6i_rtc_match_data sun50i_h616_rtc_ccu_data = {
 	.have_iosc_calibration	= true,
 	.rtc_32k_single_parent	= true,
@@ -335,10 +324,6 @@ static const struct sun6i_rtc_match_data sun50i_r329_rtc_ccu_data = {
 };
 
 static const struct of_device_id sun6i_rtc_ccu_match[] = {
-	{
-		.compatible	= "allwinner,sun50i-h6-rtc",
-		.data		= &sun50i_h6_rtc_ccu_data,
-	},
 	{
 		.compatible	= "allwinner,sun50i-h616-rtc",
 		.data		= &sun50i_h616_rtc_ccu_data,
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index 5b3e4da63406..5252ce4cbda4 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -370,6 +370,23 @@ CLK_OF_DECLARE_DRIVER(sun8i_h3_rtc_clk, "allwinner,sun8i-h3-rtc",
 CLK_OF_DECLARE_DRIVER(sun50i_h5_rtc_clk, "allwinner,sun50i-h5-rtc",
 		      sun8i_h3_rtc_clk_init);
 
+static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
+	.rc_osc_rate = 16000000,
+	.fixed_prescaler = 32,
+	.has_prescaler = 1,
+	.has_out_clk = 1,
+	.export_iosc = 1,
+	.has_losc_en = 1,
+	.has_auto_swt = 1,
+};
+
+static void __init sun50i_h6_rtc_clk_init(struct device_node *node)
+{
+	sun6i_rtc_clk_init(node, &sun50i_h6_rtc_data);
+}
+CLK_OF_DECLARE_DRIVER(sun50i_h6_rtc_clk, "allwinner,sun50i-h6-rtc",
+		      sun50i_h6_rtc_clk_init);
+
 /*
  * The R40 user manual is self-conflicting on whether the prescaler is
  * fixed or configurable. The clock diagram shows it as fixed, but there
-- 
2.36.1

