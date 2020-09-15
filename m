Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37526B83C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgIPAj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:39:29 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59827 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgIONIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 09:08:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id ECFA71942851;
        Tue, 15 Sep 2020 09:08:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 09:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tWWX8k
        O5PJmS+jLu8vu446rzUZQzLtd9bSLXFN2eTtU=; b=Mf3TvDO24VLBTmIKGlUxfR
        m4Rd4lDvZWawUPHuQv8sOy3WD5COTXQjeSFwz1gNbraCWyC3vDuog5ZIZGji6gAc
        kXzksY0+4dnyxJycri+Zker+2cZvpHbUkO9tDMoaOuE3vWIHOsg9ajFsV+hrHrCd
        mY7CKmfFHiAyMBUurJuz+wrz0C6/julz2NueykkmzyocPJKBbCOJdAIdqj4ThUkn
        M/1q0XJniG9A0fHhht7yblloWUONaP/vFk1mynZ2pHIXUAgPyR+r1RfBZTl0jLGp
        OWOpMam1NQre2GfYPm30TGRZxf09+JOMMzgCpR/GW0CGOyEA0XYbJ3S/IJo/Wo1Q
        ==
X-ME-Sender: <xms:wLxgX3SL9dgIXRNJHKbR8wY_29d6jQnTrFwJ4DRict80wNAyxTktmg>
    <xme:wLxgX4y0vGp0IWffnk1EBlyAP_TlDhsr5H2esxTVkbI8W1NC8wTmU3LwFqpiMfefV
    bFwzAI1PiI7wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wLxgX83__swzfIE8Sdm2J113n2Je5EPdLIBWBZKC5zHLSWhKaBLisw>
    <xmx:wLxgX3CERD4Wc4zFCQ4zBpV917IGPsORmbF48B12TTlTvScmDaX8EA>
    <xmx:wLxgXwjIrIWpr27gUMJok813MO2Hzd--gGe8TAzcKLQQGyF6akBLAQ>
    <xmx:wLxgX8atnWS_ulq86x8M4uHyZtMxB5sf6UYkWSpGlGHHvw7Tfkj4iQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3487B328005D;
        Tue, 15 Sep 2020 09:08:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY" failed to apply to 4.14-stable tree
To:     sivaprak@codeaurora.org, speriaka@codeaurora.org, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 15:08:14 +0200
Message-ID: <1600175294175255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From afd55e6d1bd35b4b36847869011447a83a81c8e0 Mon Sep 17 00:00:00 2001
From: Sivaprakash Murugesan <sivaprak@codeaurora.org>
Date: Wed, 29 Jul 2020 21:00:03 +0530
Subject: [PATCH] phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY
 init

There were some problem in ipq8074 Gen2 PCIe phy init sequence.

1. Few register values were wrongly updated in the phy init sequence.
2. The register QSERDES_RX_SIGDET_CNTRL is a RX tuning parameter
   register which is added in serdes table causing the wrong register
   was getting updated.
3. Clocks and resets were not added in the phy init.

Fix these to make Gen2 PCIe port on ipq8074 devices to work.

Fixes: eef243d04b2b6 ("phy: qcom-qmp: Add support for IPQ8074")
Cc: stable@vger.kernel.org
Co-developed-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
Link: https://lore.kernel.org/r/1596036607-11877-4-git-send-email-sivaprak@codeaurora.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 562053ce9455..6e6f992a9524 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -604,8 +604,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_BG_TRIM, 0xf),
 	QMP_PHY_INIT_CFG(QSERDES_COM_LOCK_CMP_EN, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_MAP, 0x0),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0x1f),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x3f),
+	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER1, 0xff),
+	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_TIMER2, 0x1f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CMN_CONFIG, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_COM_PLL_IVCO, 0xf),
 	QMP_PHY_INIT_CFG(QSERDES_COM_HSCLK_SEL, 0x0),
@@ -631,7 +631,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x0),
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
 	QMP_PHY_INIT_CFG(QSERDES_COM_BIAS_EN_CTRL_BY_PSM, 0x1),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_CTRL, 0xa),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_EN_CENTER, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER1, 0x31),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER2, 0x1),
@@ -640,7 +639,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE1, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE2, 0x19),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_EP_DIV, 0x19),
-	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x7),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
@@ -648,6 +646,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RES_CODE_LANE_OFFSET, 0x2),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RCV_DETECT_LVL_2, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_TX_EMP_POST1_LVL, 0x36),
+	QMP_PHY_INIT_CFG(QSERDES_TX_SLEW_CNTL, 0x0a),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
@@ -658,7 +658,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL4, 0xdb),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE, 0x4b),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN, 0x4),
-	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN_HALF, 0x4),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_pcs_tbl[] = {
@@ -2046,6 +2045,9 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 	.pwrdn_ctrl		= SW_PWRDN,
 };
 
+static const char * const ipq8074_pciephy_clk_l[] = {
+	"aux", "cfg_ahb",
+};
 /* list of resets */
 static const char * const ipq8074_pciephy_reset_l[] = {
 	"phy", "common",
@@ -2063,8 +2065,8 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
 	.rx_tbl_num		= ARRAY_SIZE(ipq8074_pcie_rx_tbl),
 	.pcs_tbl		= ipq8074_pcie_pcs_tbl,
 	.pcs_tbl_num		= ARRAY_SIZE(ipq8074_pcie_pcs_tbl),
-	.clk_list		= NULL,
-	.num_clks		= 0,
+	.clk_list		= ipq8074_pciephy_clk_l,
+	.num_clks		= ARRAY_SIZE(ipq8074_pciephy_clk_l),
 	.reset_list		= ipq8074_pciephy_reset_l,
 	.num_resets		= ARRAY_SIZE(ipq8074_pciephy_reset_l),
 	.vreg_list		= NULL,
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
index 4277f592684b..904b80ab9009 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -77,6 +77,8 @@
 #define QSERDES_COM_CORECLK_DIV_MODE1			0x1bc
 
 /* Only for QMP V2 PHY - TX registers */
+#define QSERDES_TX_EMP_POST1_LVL			0x018
+#define QSERDES_TX_SLEW_CNTL				0x040
 #define QSERDES_TX_RES_CODE_LANE_OFFSET			0x054
 #define QSERDES_TX_DEBUG_BUS_SEL			0x064
 #define QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_DRVR_EN	0x068

