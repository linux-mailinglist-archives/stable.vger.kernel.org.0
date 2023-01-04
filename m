Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2522065D5BB
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbjADOdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239539AbjADOcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:32:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989B8395C2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45B81B81677
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA34C433EF;
        Wed,  4 Jan 2023 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842751;
        bh=ie0mm+rB0Z7Y5PH1HfQK5A0twUv20Xq/bJLpLSplCHE=;
        h=Subject:To:Cc:From:Date:From;
        b=xU47xlLOmW/Rzl2QwVMLartMl1N8DtydmcEltGVSTBBn8PMxaJ+6U8guhbIIqwO1Q
         qMYXpUJ1XsG6yPFVZ9SleBwMMgzNlrbt3WORpeHZegsdggpZwFVl7jrFtXZXCBXkmk
         X0yJnwIdT48csOD2Nb8mY4SOui81Pf963P3g3d2k=
Subject: FAILED: patch "[PATCH] phy: qcom-qmp-combo: fix broken power on" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, dmitry.baryshkov@linaro.org,
        vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:32:21 +0100
Message-ID: <1672842741103181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7a7d86d14d07 ("phy: qcom-qmp-combo: fix broken power on")
d4b81490fe44 ("phy: qcom-qmp-combo: drop start and pwrdn-ctrl abstraction")
f7075f4905e7 ("phy: qcom-qmp-combo: clean up status polling")
acfee73b635b ("phy: qcom-qmp-combo: drop power-down delay config")
d71eb7083e5e ("phy: qcom-qmp-combo: drop sc8280xp power-down delay")
2e52ddf045a0 ("phy: qcom-qmp-combo: clean up power-down handling")
9d943961912c ("phy: qcom-qmp-combo: drop redundant DP config flag")
099155615ac2 ("phy: qcom-qmp-combo: consolidate lane config")
f5d6b5d613e9 ("phy: qcom-qmp-combo: fix sc8280xp PCS_USB offset")
064bbdba4f8d ("phy: qcom-qmp-combo: drop unused legacy DT workaround")
2de8a325b108 ("phy: qcom-qmp-combo: fix memleak on probe deferral")
e5cedefa7203 ("phy: qcom-qmp-combo: shorten function prefixes")
beee6ed1d63f ("phy: qcom-qmp-combo: drop unused defines")
ac439ce88edf ("phy: qcom-qmp: drop dual-lane comments")
a2e927b0e50d ("phy: qcom-qmp-combo: Add sc8280xp USB/DP combo phys")
c0c7769cdae2 ("phy: qcom-qmp: Add SC8280XP USB3 UNI phy")
712e5dffe911 ("phy: qcom-qmp-combo: Parameterize swing and pre_emphasis tables")
d88497fb6bbd ("phy: qualcomm: phy-qcom-qmp: add support for combo USB3+DP phy on SDM845")
5fc21d1bd3d7 ("phy: qcom-qmp: split allegedly 4.20 and 5.20 TX/RX registers")
87d71378c61a ("phy: qcom-qmp: move PCIE QHP registers to separate header")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a7d86d14d073dfa3429c550667a8e78b99edbd4 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 14 Nov 2022 09:13:44 +0100
Subject: [PATCH] phy: qcom-qmp-combo: fix broken power on

The PHY is powered on during phy-init by setting the SW_PWRDN bit in the
COM_POWER_DOWN_CTRL register and then setting the same bit in the in the
PCS_POWER_DOWN_CONTROL register that belongs to the USB part of the
PHY.

Currently, whether power on succeeds depends on probe order and having
the USB part of the PHY be initialised first. In case the DP part of the
PHY is instead initialised first, the intended power on of the USB block
results in a corrupted DP_PHY register (e.g. DP_PHY_AUX_CFG8).

Add a pointer to the USB part of the PHY to the driver data and use that
to power on the PHY also if the DP part of the PHY is initialised first.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Cc: stable@vger.kernel.org	# 5.10
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 40c25a0ead23..17707f68d482 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -932,6 +932,7 @@ struct qcom_qmp {
 	struct regulator_bulk_data *vregs;
 
 	struct qmp_phy **phys;
+	struct qmp_phy *usb_phy;
 
 	struct mutex phy_mutex;
 	int init_count;
@@ -1911,7 +1912,7 @@ static int qmp_combo_com_init(struct qmp_phy *qphy)
 {
 	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
-	void __iomem *pcs = qphy->pcs;
+	struct qmp_phy *usb_phy = qmp->usb_phy;
 	void __iomem *dp_com = qmp->dp_com;
 	int ret;
 
@@ -1963,7 +1964,8 @@ static int qmp_combo_com_init(struct qmp_phy *qphy)
 	qphy_clrbits(dp_com, QPHY_V3_DP_COM_SWI_CTRL, 0x03);
 	qphy_clrbits(dp_com, QPHY_V3_DP_COM_SW_RESET, SW_RESET);
 
-	qphy_setbits(pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL], SW_PWRDN);
+	qphy_setbits(usb_phy->pcs, usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
+			SW_PWRDN);
 
 	mutex_unlock(&qmp->phy_mutex);
 
@@ -2831,6 +2833,8 @@ static int qmp_combo_probe(struct platform_device *pdev)
 				goto err_node_put;
 			}
 
+			qmp->usb_phy = qmp->phys[id];
+
 			/*
 			 * Register the pipe clock provided by phy.
 			 * See function description to see details of this pipe clock.
@@ -2846,6 +2850,9 @@ static int qmp_combo_probe(struct platform_device *pdev)
 		id++;
 	}
 
+	if (!qmp->usb_phy)
+		return -EINVAL;
+
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 
 	return PTR_ERR_OR_ZERO(phy_provider);

