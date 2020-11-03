Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685A92A4A6F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgKCP4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:56:24 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49063 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCP4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:56:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 21D93D38;
        Tue,  3 Nov 2020 10:56:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ndRJ3w
        VroTAstCSlMhMsHYuJUfjYttHAx6q7ppdi7wg=; b=egh7FpOzCTvuO+k4O+UGN9
        Y1e4KXAJHb+bEMMDfcV6bw6fnIzCvDcJuznbqZO9iXpDi8kk6KljfFBTeD3RrIDP
        QCxwHepejUDo6c7K0Cu9H/lBCH4EAeGxCG3eh5Bf+RpWuCer0IcWzCuIPYaNHmBO
        zPsXLG5V/L0YQFeRusTdW+c0Xj//I1sWp0KIcFdW8zNcicdK/iA2DiiKBiUnvClC
        udzEo47fSR26GB42d2AhT5r5PWYAnglzNY5fpMNqKIFVdO4EzRvakpg+ko4WVHlm
        lhp2Oz7YmBVIZm6jdvNvc9KpN9dwAhmjwsUg29ryinXKNOuN4F3gGsG3Pf1AgPWg
        ==
X-ME-Sender: <xms:pX2hX_QhvIifInT83SXW4ibT1q4j7YoPiyDy47syJEGXJsbsN4-W4g>
    <xme:pX2hXwzJgWuCzLzgj8WdBdoLnuIwIo4rini5uvaNcGh261hxjJFFyseQWbdPU7ARq
    8J_7T6R_qGFsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pX2hX026UxfsE9iQ-7ESfXR90w-7e6bpnjyVRU26rMHSd4wlxkPzjg>
    <xmx:pX2hX_Ds5vFCKjkGKrtrxcB1-n2YtvyRgLn6APJZY69PUJw7Q44-TQ>
    <xmx:pX2hX4hGtkGF3A14tWK9J8D1Vc22laR79UxCrNIjRGo-AfNvmQYzRA>
    <xmx:pX2hX0am9AWCUDVtLKTnRQu4FPrwMcjkIsyDH9tBde6gsCK7S38wTbkk9k8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4683B3280066;
        Tue,  3 Nov 2020 10:56:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0" failed to apply to 4.14-stable tree
To:     ansuelsmth@gmail.com, bjorn.andersson@linaro.org,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:57:06 +0100
Message-ID: <160441902624324@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d3d4d028afb785e52c55024d779089654f8302e7 Mon Sep 17 00:00:00 2001
From: Ansuel Smith <ansuelsmth@gmail.com>
Date: Tue, 1 Sep 2020 14:49:54 +0200
Subject: [PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0

Qsdk U-Boot can incorrectly leave the PCIe interface in an undefined
state if bootm command is used instead of bootipq. This is caused by the
not deinit of PCIe when bootm is called. Reset the PCIe before init
anyway to fix this U-Boot bug.

Link: https://lore.kernel.org/r/20200901124955.137-1-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org # v4.19+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 3aac77a295ba..82336bbaf8dc 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -302,6 +302,9 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
 	reset_control_assert(res->por_reset);
 	reset_control_assert(res->ext_reset);
 	reset_control_assert(res->phy_reset);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
 }
 
@@ -314,6 +317,16 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	u32 val;
 	int ret;
 
+	/* reset the PCIe interface as uboot can leave it undefined state */
+	reset_control_assert(res->pci_reset);
+	reset_control_assert(res->axi_reset);
+	reset_control_assert(res->ahb_reset);
+	reset_control_assert(res->por_reset);
+	reset_control_assert(res->ext_reset);
+	reset_control_assert(res->phy_reset);
+
+	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
 	if (ret < 0) {
 		dev_err(dev, "cannot enable regulators\n");

