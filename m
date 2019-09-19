Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C9BB812C
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392223AbfISTG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:06:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55197 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392222AbfISTG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 15:06:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C33A2108A;
        Thu, 19 Sep 2019 15:06:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 15:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B5/xPx
        sHwS2Cve6UV+6zEqiZbnLDEvhmyk42pCW0grg=; b=Nw4rLoStMiHs+wSZK+X/Ob
        BsY42hO9pKrKJp2lD9sgBMp1+7O1nDYbBBn/W3qnLXpLFcKsYrEC/2y02LqNv8uq
        Q+obsKXWuKAHGg9IACdyVD9LxBMVv7BfIP1G6oLZKuHOf4Dm9C1/+6tyquEhTP3T
        iEvG2bDLPNmZmZ8IGMzjcE7GexOGLOX+VsgQxoa5aY/sZ3eU92YzdTG+f7VwtKDv
        eW8u4OO55T0zPRc3nnFF4tt4GggIem+sYg4i2YkSi1Bm522gcVtQlE+/qM+PZKum
        Ag1BDoBG1wDsIjyFCftPItjTichdu5XmZrvh+DHywvFpkHFIp4D5q4R96b2+0kHQ
        ==
X-ME-Sender: <xms:sNGDXRvB3eJMFPQmoPapF8eYVB6bbtIwzmh6DpVPuxD1km2u5nhA8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:sdGDXZf51BjcuoAqjI7SLJeT-z3MlNZqGaAlDbp0PHw_rY1MxRbBPw>
    <xmx:sdGDXU7Pe51rROHf9Zc_wdqs4wImEg7lsAiWCzHxHQST_WWIZ0yrgw>
    <xmx:sdGDXak_bnglNBcUS_BRJ4qczZL_8FGNzP1ZW4iSuHMIbjwbzhUnjw>
    <xmx:sdGDXbfe9wxXmGHxgoUWnYIkgXlOO3tr6ZaE79Mmnpb2KzzTHgZmlg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94CE280062;
        Thu, 19 Sep 2019 15:06:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] phy: qcom-qmp: Correct ready status, again" failed to apply to 5.2-stable tree
To:     bjorn.andersson@linaro.org, evgreen@chromium.org, kishon@ti.com,
        marc.w.gonzalez@free.fr, niklas.cassel@linaro.org,
        vivek.gautam@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Sep 2019 21:06:23 +0200
Message-ID: <1568919983199175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 14ced7e3a1ae9bed7051df3718c8c7b583854a5c Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Mon, 5 Aug 2019 17:42:56 -0700
Subject: [PATCH] phy: qcom-qmp: Correct ready status, again

Despite extensive testing of commit 885bd765963b ("phy: qcom-qmp: Correct
READY_STATUS poll break condition") I failed to conclude that the
PHYSTATUS bit of the PCS_STATUS register used in PCIe and USB3 falls as
the PHY gets ready. Similar to the prior bug with UFS the code will
generally get past the check before the transition and thereby
"succeed".

Correct the name of the register used PCIe and USB3 PHYs, replace
mask_pcs_ready with a constant expression depending on the type of the
PHY and check for the appropriate ready state.

Cc: stable@vger.kernel.org
Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Niklas Cassel <niklas.cassel@linaro.org>
Reported-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Fixes: 885bd765963b ("phy: qcom-qmp: Correct READY_STATUS poll break condition")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index e7b8283acce8..39e8deb8001e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -35,7 +35,7 @@
 #define PLL_READY_GATE_EN			BIT(3)
 /* QPHY_PCS_STATUS bit */
 #define PHYSTATUS				BIT(6)
-/* QPHY_COM_PCS_READY_STATUS bit */
+/* QPHY_PCS_READY_STATUS & QPHY_COM_PCS_READY_STATUS bit */
 #define PCS_READY				BIT(0)
 
 /* QPHY_V3_DP_COM_RESET_OVRD_CTRL register bits */
@@ -115,6 +115,7 @@ enum qphy_reg_layout {
 	QPHY_SW_RESET,
 	QPHY_START_CTRL,
 	QPHY_PCS_READY_STATUS,
+	QPHY_PCS_STATUS,
 	QPHY_PCS_AUTONOMOUS_MODE_CTRL,
 	QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR,
 	QPHY_PCS_LFPS_RXTERM_IRQ_STATUS,
@@ -133,7 +134,7 @@ static const unsigned int pciephy_regs_layout[] = {
 	[QPHY_FLL_MAN_CODE]		= 0xd4,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x174,
+	[QPHY_PCS_STATUS]		= 0x174,
 };
 
 static const unsigned int usb3phy_regs_layout[] = {
@@ -144,7 +145,7 @@ static const unsigned int usb3phy_regs_layout[] = {
 	[QPHY_FLL_MAN_CODE]		= 0xd0,
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x17c,
+	[QPHY_PCS_STATUS]		= 0x17c,
 	[QPHY_PCS_AUTONOMOUS_MODE_CTRL]	= 0x0d4,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR]  = 0x0d8,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_STATUS] = 0x178,
@@ -153,7 +154,7 @@ static const unsigned int usb3phy_regs_layout[] = {
 static const unsigned int qmp_v3_usb3phy_regs_layout[] = {
 	[QPHY_SW_RESET]			= 0x00,
 	[QPHY_START_CTRL]		= 0x08,
-	[QPHY_PCS_READY_STATUS]		= 0x174,
+	[QPHY_PCS_STATUS]		= 0x174,
 	[QPHY_PCS_AUTONOMOUS_MODE_CTRL]	= 0x0d8,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_CLEAR]  = 0x0dc,
 	[QPHY_PCS_LFPS_RXTERM_IRQ_STATUS] = 0x170,
@@ -911,7 +912,6 @@ struct qmp_phy_cfg {
 
 	unsigned int start_ctrl;
 	unsigned int pwrdn_ctrl;
-	unsigned int mask_pcs_ready;
 	unsigned int mask_com_pcs_ready;
 
 	/* true, if PHY has a separate PHY_COM control block */
@@ -1074,7 +1074,6 @@ static const struct qmp_phy_cfg msm8996_pciephy_cfg = {
 
 	.start_ctrl		= PCS_START | PLL_READY_GATE_EN,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 	.mask_com_pcs_ready	= PCS_READY,
 
 	.has_phy_com_ctrl	= true,
@@ -1106,7 +1105,6 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 /* list of resets */
@@ -1136,7 +1134,6 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_phy_com_ctrl	= false,
 	.has_lane_rst		= false,
@@ -1167,7 +1164,6 @@ static const struct qmp_phy_cfg qmp_v3_usb3phy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1199,7 +1195,6 @@ static const struct qmp_phy_cfg qmp_v3_usb3_uniphy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= POWER_DOWN_DELAY_US_MIN,
@@ -1226,7 +1221,6 @@ static const struct qmp_phy_cfg sdm845_ufsphy_cfg = {
 
 	.start_ctrl		= SERDES_START,
 	.pwrdn_ctrl		= SW_PWRDN,
-	.mask_pcs_ready		= PCS_READY,
 
 	.is_dual_lane_phy	= true,
 	.no_pcs_sw_reset	= true,
@@ -1254,7 +1248,6 @@ static const struct qmp_phy_cfg msm8998_pciephy_cfg = {
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
-	.mask_pcs_ready		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg msm8998_usb3phy_cfg = {
@@ -1279,7 +1272,6 @@ static const struct qmp_phy_cfg msm8998_usb3phy_cfg = {
 
 	.start_ctrl             = SERDES_START | PCS_START,
 	.pwrdn_ctrl             = SW_PWRDN,
-	.mask_pcs_ready         = PHYSTATUS,
 
 	.is_dual_lane_phy       = true,
 };
@@ -1457,7 +1449,7 @@ static int qcom_qmp_phy_enable(struct phy *phy)
 	void __iomem *pcs = qphy->pcs;
 	void __iomem *dp_com = qmp->dp_com;
 	void __iomem *status;
-	unsigned int mask, val;
+	unsigned int mask, val, ready;
 	int ret;
 
 	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
@@ -1545,10 +1537,17 @@ static int qcom_qmp_phy_enable(struct phy *phy)
 	/* start SerDes and Phy-Coding-Sublayer */
 	qphy_setbits(pcs, cfg->regs[QPHY_START_CTRL], cfg->start_ctrl);
 
-	status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
-	mask = cfg->mask_pcs_ready;
+	if (cfg->type == PHY_TYPE_UFS) {
+		status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
+		mask = PCS_READY;
+		ready = PCS_READY;
+	} else {
+		status = pcs + cfg->regs[QPHY_PCS_STATUS];
+		mask = PHYSTATUS;
+		ready = 0;
+	}
 
-	ret = readl_poll_timeout(status, val, val & mask, 10,
+	ret = readl_poll_timeout(status, val, (val & mask) == ready, 10,
 				 PHY_INIT_COMPLETE_TIMEOUT);
 	if (ret) {
 		dev_err(qmp->dev, "phy initialization timed-out\n");

