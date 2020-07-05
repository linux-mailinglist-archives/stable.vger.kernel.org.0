Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E14A214B43
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 11:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGEJJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 05:09:09 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:16273 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgGEJJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jul 2020 05:09:09 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 05 Jul 2020 02:09:08 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 05 Jul 2020 02:09:07 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id 9A60A213C8; Sun,  5 Jul 2020 14:39:03 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     sivaprak@codeaurora.org
Cc:     stable@vger.kernel.org,
        Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Subject: [PATCH 5/9] phy: qcom-qmp: use correct values for ipq8074 gen2 pcie phy init
Date:   Sun,  5 Jul 2020 14:38:57 +0530
Message-Id: <1593940141-28516-6-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593940141-28516-1-git-send-email-sivaprak@codeaurora.org>
References: <1593940141-28516-1-git-send-email-sivaprak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There were some problem in ipq8074 gen2 pcie phy init sequence, fix
these to make gen2 pcie port on ipq8074 to work.

Fixes: eef243d04b2b6 ("phy: qcom-qmp: Add support for IPQ8074")

Cc: stable@vger.kernel.org
Co-developed-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Selvam Sathappan Periakaruppan <speriaka@codeaurora.org>
Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 16 +++++++++-------
 drivers/phy/qualcomm/phy-qcom-qmp.h |  2 ++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index e91040af3394..ba277136f52b 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -504,8 +504,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
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
@@ -531,7 +531,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN1_MODE0, 0x0),
 	QMP_PHY_INIT_CFG(QSERDES_COM_INTEGLOOP_GAIN0_MODE0, 0x80),
 	QMP_PHY_INIT_CFG(QSERDES_COM_BIAS_EN_CTRL_BY_PSM, 0x1),
-	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_CTRL, 0xa),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_EN_CENTER, 0x1),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER1, 0x31),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_PER2, 0x1),
@@ -540,7 +539,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_serdes_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE1, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SSC_STEP_SIZE2, 0x19),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_EP_DIV, 0x19),
-	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x7),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
@@ -548,6 +546,8 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_tx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x6),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RES_CODE_LANE_OFFSET, 0x2),
 	QMP_PHY_INIT_CFG(QSERDES_TX_RCV_DETECT_LVL_2, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_TX_EMP_POST1_LVL, 0x36),
+	QMP_PHY_INIT_CFG(QSERDES_TX_SLEW_CNTL, 0x0a),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
@@ -558,7 +558,6 @@ static const struct qmp_phy_init_tbl ipq8074_pcie_rx_tbl[] = {
 	QMP_PHY_INIT_CFG(QSERDES_RX_RX_EQU_ADAPTOR_CNTRL4, 0xdb),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_SATURATION_AND_ENABLE, 0x4b),
 	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN, 0x4),
-	QMP_PHY_INIT_CFG(QSERDES_RX_UCDR_SO_GAIN_HALF, 0x4),
 };
 
 static const struct qmp_phy_init_tbl ipq8074_pcie_pcs_tbl[] = {
@@ -1673,6 +1672,9 @@ static const struct qmp_phy_cfg msm8996_usb3phy_cfg = {
 	.pwrdn_ctrl		= SW_PWRDN,
 };
 
+static const char * const ipq8074_pciephy_clk_l[] = {
+	"aux", "cfg_ahb",
+};
 /* list of resets */
 static const char * const ipq8074_pciephy_reset_l[] = {
 	"phy", "common",
@@ -1690,8 +1692,8 @@ static const struct qmp_phy_cfg ipq8074_pciephy_cfg = {
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
index 6d017a0c0c8d..832b3d098403 100644
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
-- 
2.7.4

