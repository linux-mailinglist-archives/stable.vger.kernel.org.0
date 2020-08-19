Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B17249A3A
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHSKXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:23:24 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48939 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727909AbgHSKXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:23:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2F452194239D;
        Wed, 19 Aug 2020 06:23:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=n80YMr
        nwbl6GXryRwJxdb6RRxzjERRNwdqSv2dWKjvw=; b=eDJxYaQqoaEHr5T1MfMPOg
        8b4QVlBCOFlhhvmTCFKdcVdaC5nA1FvvDgEcN0BYNa7Mmy7EONsGMuB9ENjBcWqi
        i/YRs3N+F0bifsEK92h2RP2Xe1O5dPzw4xuGNah22c/ylai6peBlM5FQy3uv6ptn
        SCtJehmnfXNcIoBnPCyIFdPpAAqPPJiGVeEZEJPicHpOMNl4Hn4j6yb3lsaTfEWo
        C4ZKh17oH0+gijkA7wRsVRIZmSASGVQAKTRlm8qR9mMQPOKM5NV7OM/nZUf30xk8
        krHocKHfjakbeGtwPO1xk7PdLPr3UPaHKPNnHDlFQVzgIuXPJbOU7W6FRmUVY22Q
        ==
X-ME-Sender: <xms:kP08X26-VHmIgyt7s-TFdIFn8L56YMEoN7q7fs1HtZPHqYDa3_qjYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kP08X_4EigWQcImotJOTZdDPwmA7qMnIKDalEiNPtZo1fe4h67jUGw>
    <xmx:kP08X1esyDGqKwkK4w0xtgiB7gANmInl3J6Wy9SIaCV0XRlzTQy8jg>
    <xmx:kP08XzL3XhTiAadHxeYMXtfUlX5F0ebmDraCQekovlgpcznSGJB3PQ>
    <xmx:kP08X23gbdE_-fZ5V4hRFfP9fFt1Y7KRZxYZ8mOwlCzrAUNtaT0pwA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9AB330600B4;
        Wed, 19 Aug 2020 06:23:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Add missing reset for ipq806x" failed to apply to 4.9-stable tree
To:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        p.zabel@pengutronix.de, robh@kernel.org, smuthayy@codeaurora.org,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:23:28 +0200
Message-ID: <1597832608236235@kroah.com>
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

