Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84154249A39
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgHSKXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:23:23 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56563 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgHSKXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:23:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AE6851942390;
        Wed, 19 Aug 2020 06:23:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gUhbXz
        t0FwkTpQEJtjsmRu0BP75KGGpJY30SFawgFGc=; b=SZsAiuSBmBMytU4PMKdmax
        Cpm+WRQ2dh4B1K5T9cFctZhOh0YBFHbs/4blxGYjBT5Tnfmz5EqaHMy9RfIjOJWS
        fY35KfgY3WPWOc9kdHhzDXezxRWBZjaXKuRhGlZkG3oMxkuP+0OHc67Ol7yxfr4E
        b8LOQnW4yJahGxUrBSdh39xoIqXbz05qEa+DIvVr2t5AFcBVfo+GHe0lDmEQUMRS
        2Toy4z8NOO+nf0nQX4eTgeZ2M1sLIdReozBRlOjMbYThV3HBOg7wOr/e1PTbSMdW
        TmasQBuVHotdt6izi1nQz3aeJyxsJkLnZ1s7xM3d0glhyZTXcNTXAsszDCuAj4Lg
        ==
X-ME-Sender: <xms:kf08X5J9tVrrrD0_UjZXfDTHfplsdEo621wjxtenr2v8VX6ANAO1kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kf08X1K_pVQS2tet03tMvcMI2cV7nyK0fTDPyc_Gn6fJYPo2N3huJQ>
    <xmx:kf08Xxt6bmcNv5PdHzq3URJ4144REF7AN-3f_ZNun6IA8uysuMjy3Q>
    <xmx:kf08X6arhYs5auBOrLRkXlOVyfIJQFBlNfY4S5eblAfMNzXdcSqG_Q>
    <xmx:kf08X4HKgJ9SAeegV1Fg10eYvRQs9qrtnpvcX8k7f6z4waylEIvBgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3BB8B306005F;
        Wed, 19 Aug 2020 06:23:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Add missing reset for ipq806x" failed to apply to 4.14-stable tree
To:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, robh@kernel.org, smuthayy@codeaurora.org,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:23:28 +0200
Message-ID: <159783260833162@kroah.com>
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

From ee367e2cdd2202b5714982739e684543cd2cee0e Mon Sep 17 00:00:00 2001
From: Ansuel Smith <ansuelsmth@gmail.com>
Date: Mon, 15 Jun 2020 23:06:00 +0200
Subject: [PATCH] PCI: qcom: Add missing reset for ipq806x

Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.

Link: https://lore.kernel.org/r/20200615210608.21469-5-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v4.5+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index bae5158a9854..fcd265067f34 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -95,6 +95,7 @@ struct qcom_pcie_resources_2_1_0 {
 	struct reset_control *ahb_reset;
 	struct reset_control *por_reset;
 	struct reset_control *phy_reset;
+	struct reset_control *ext_reset;
 	struct regulator_bulk_data supplies[QCOM_PCIE_2_1_0_MAX_SUPPLY];
 };
 
@@ -272,6 +273,10 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
 	if (IS_ERR(res->por_reset))
 		return PTR_ERR(res->por_reset);
 
+	res->ext_reset = devm_reset_control_get_optional_exclusive(dev, "ext");
+	if (IS_ERR(res->ext_reset))
+		return PTR_ERR(res->ext_reset);
+
 	res->phy_reset = devm_reset_control_get_exclusive(dev, "phy");
 	return PTR_ERR_OR_ZERO(res->phy_reset);
 }
@@ -285,6 +290,7 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->axi_reset);
 	reset_control_assert(res->ahb_reset);
 	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
 	clk_disable_unprepare(res->iface_clk);
 	clk_disable_unprepare(res->core_clk);
@@ -343,6 +349,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		goto err_deassert_ahb;
 	}
 
+	ret = reset_control_deassert(res->ext_reset);
+	if (ret) {
+		dev_err(dev, "cannot deassert ext reset\n");
+		goto err_deassert_ahb;
+	}
+
 	/* enable PCIe clocks and resets */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
 	val &= ~BIT(0);

