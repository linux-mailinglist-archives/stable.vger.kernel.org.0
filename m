Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6592824666F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 14:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgHQMfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 08:35:55 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34491 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgHQMfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 08:35:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 81B6419414ED;
        Mon, 17 Aug 2020 08:35:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 08:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9cuEWm
        tzYQDX2mUm7Hoqk2rVIC6hsIAMLR3bwAOr0lI=; b=MTljxbVFGcgLsFBy5G56Wm
        wFMaBscdhKL4Lea5wgKX3oNnvlb8EAVgcuCna2H9joZM/oGFYCYLDBmYWsC5PvKt
        X8a6+AcfFQe/ou9f7NIMPrZw9Et7bC29pfOPa2c6NjF5a3WAX7tUo1AasJG612qv
        6fCvXpwpRMaBny1EwMo+dl6SqNWQSLpZQYFHoEc1/svVuxgZ1rZ8IVSOaDpkc0we
        lYll4g0bsicn3N9xedgCSjPRR2FTS6rMaTAhMrrp62BXdCxO+NVBHzUN8xP1MYzl
        Of7biiLGqQ3BXV+OWu9kII1jv7HbdWtLeZ7Nzha96yI9fiDkM/v2cW9YTeKUot2Q
        ==
X-ME-Sender: <xms:qHk6XwGWTPvtBsZjuTQbpOlbJwLpXPGxhgrvnPMPczpPdmKk2rnQ8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:qHk6X5XgQj3P80TdQqYx_xqvquEVfyihvIVp6rHRVK-FhjJda0tJVA>
    <xmx:qHk6X6LV-2HYFnT07DLZN3fLOYxjEU6X8yIePjIhdbPzljrYVRfLIw>
    <xmx:qHk6XyHuZKwZ77qyvLfOXLIZ1U7ki7xObSBlDbFvaNX8kv06eW7Pdw>
    <xmx:qHk6XxCxaN8Yjd0ffIMWVBquf8V5Mb-s2HF_smQCETfCpyWYP-p5Cw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD7E1328005A;
        Mon, 17 Aug 2020 08:35:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu" failed to apply to 5.4-stable tree
To:     maz@kernel.org, cw00.choi@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 14:36:09 +0200
Message-ID: <159766776914832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 63ef91f24f9bfc70b6446319f6cabfd094481372 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Tue, 30 Jun 2020 11:05:46 +0100
Subject: [PATCH] PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu
 is absent

Booting a recent kernel on a rk3399-based system (nanopc-t4),
equipped with a recent u-boot and ATF results in an Oops due
to a NULL pointer dereference.

This turns out to be due to the rk3399-dmc driver looking for
an *undocumented* property (rockchip,pmu), and happily using
a NULL pointer when the property isn't there.

Instead, make most of what was brought in with 9173c5ceb035
("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
to TF-A.") conditioned on finding this property in the device-tree,
preventing the driver from exploding.

Cc: stable@vger.kernel.org
Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
index 24f04f78285b..027769e39f9b 100644
--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -95,18 +95,20 @@ static int rk3399_dmcfreq_target(struct device *dev, unsigned long *freq,
 
 	mutex_lock(&dmcfreq->lock);
 
-	if (target_rate >= dmcfreq->odt_dis_freq)
-		odt_enable = true;
-
-	/*
-	 * This makes a SMC call to the TF-A to set the DDR PD (power-down)
-	 * timings and to enable or disable the ODT (on-die termination)
-	 * resistors.
-	 */
-	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
-		      dmcfreq->odt_pd_arg1,
-		      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
-		      odt_enable, 0, 0, 0, &res);
+	if (dmcfreq->regmap_pmu) {
+		if (target_rate >= dmcfreq->odt_dis_freq)
+			odt_enable = true;
+
+		/*
+		 * This makes a SMC call to the TF-A to set the DDR PD
+		 * (power-down) timings and to enable or disable the
+		 * ODT (on-die termination) resistors.
+		 */
+		arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
+			      dmcfreq->odt_pd_arg1,
+			      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
+			      odt_enable, 0, 0, 0, &res);
+	}
 
 	/*
 	 * If frequency scaling from low to high, adjust voltage first.
@@ -371,13 +373,14 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 	}
 
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
-	if (node) {
-		data->regmap_pmu = syscon_node_to_regmap(node);
-		of_node_put(node);
-		if (IS_ERR(data->regmap_pmu)) {
-			ret = PTR_ERR(data->regmap_pmu);
-			goto err_edev;
-		}
+	if (!node)
+		goto no_pmu;
+
+	data->regmap_pmu = syscon_node_to_regmap(node);
+	of_node_put(node);
+	if (IS_ERR(data->regmap_pmu)) {
+		ret = PTR_ERR(data->regmap_pmu);
+		goto err_edev;
 	}
 
 	regmap_read(data->regmap_pmu, RK3399_PMUGRF_OS_REG2, &val);
@@ -399,6 +402,7 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 		goto err_edev;
 	};
 
+no_pmu:
 	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, 0, 0,
 		      ROCKCHIP_SIP_CONFIG_DRAM_INIT,
 		      0, 0, 0, 0, &res);

