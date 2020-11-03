Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8D2A4A6C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgKCP4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:56:13 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38763 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCP4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:56:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C8277D4E;
        Tue,  3 Nov 2020 10:56:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Z/a3JY
        rDeS9ko3Y/wHpAELsBm7Ck805ov778N8Zbnf0=; b=J7vdJb+jQzycbdQ6hKqU6u
        CMzMpwXtjZLsCxzcFPLo3HWBOmrb4vW2MNQNpUV9/AI+yZ8rkI9+dTsD07S48dqL
        u47dYOG0F9spzufVR8zf5stLiQFoifNqtea1G1Vpa/k/aHdsBl8sLq0kzs+/jn6U
        +vhIn7RWwoNQs4ofcdT8Uvdp/eXGA+XLipOrvpEFugWswsIrP6cHB35kvE4DrIFo
        hkxXpyzbqjhlq3vLXD0yoZmy5/iH//XRTmv4kqz2cSR+/CoUcl04pKSAm6sOzPBG
        IuytI2hnDzeQrLRWbO7+lrnN+mSOP2IgKNJ8JiapEVsEr6i9yyjwarUZA7y8D05w
        ==
X-ME-Sender: <xms:nH2hX--0tKmmMK3AbnbXrUInobbhJeSW2QAd4myTXIQ1sYhgzQ9P8Q>
    <xme:nH2hX-vfyfIz09AaB_SjJFc7HCjE1K1PnKP9PI38THmXCtfXSegdHeBBso5Xi70FC
    WMdWCs1P6BRqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nH2hX0DRJe2i7roP3gDFotPSeHlogNJ8IWhqlloI9aZXObTkVLqr5A>
    <xmx:nH2hX2cE_Z6fXqoIy27_xNzoGPQjOd9MTD1bw_zCgouRgcJixQgIwQ>
    <xmx:nH2hXzMu56DZgbNeIZpJt19Y83gt4yQ05Ue0Z4JuQ57zdS2xuZnf7g>
    <xmx:nH2hX52Vk1uzNMRfsAYBSV8FKezHXpQMsq0CPvcGzGuVGwjceBUwD_9t-TM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B95D4306467E;
        Tue,  3 Nov 2020 10:56:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0" failed to apply to 4.9-stable tree
To:     ansuelsmth@gmail.com, bjorn.andersson@linaro.org,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:57:05 +0100
Message-ID: <160441902571236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

