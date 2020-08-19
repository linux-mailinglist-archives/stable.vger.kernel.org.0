Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BE2249A42
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHSKXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:23:47 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43325 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726782AbgHSKXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:23:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3D589194240A;
        Wed, 19 Aug 2020 06:23:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8O48LX
        jXjNBHG25cldbGmK/x1ZpxeOPqAlm6v622s4o=; b=Rgh/uTlbkGzxxxIOAUhsC+
        GHloYDUWjaRBIM4wkcPsnMn1bH24gjeqkGDjDXK2XPBObEuYH3G81eAUmP/7TgYA
        5cBJ1XAtQj5ovrw2ZhF8E1TL1DZObX9qh0i8znRk7Xlw4Sd5WV9PnvZKhHOaE9KV
        SuriWfMekjW+2LXUAVBwTuSpLR6+DYCIXE0lOHtNHLiPGxZdVhWZiVQhegPGe4b3
        gU7JE47KIAINEy+8cwJ80XO/ze1PBe9TmyO/Dc9Hr7tl87JjbdHC7iM7+a6QkJBB
        a6DFGDsA/hL4rGbgVKTZ+DYBLvhYZk8KfEw8MRn9i3f435aKFn1RoSVqtDCEaLfQ
        ==
X-ME-Sender: <xms:sP08Xxs-pMN8uuPKFvBW8HWZFFxlEkdbxt8wjauoiCjIXPOunJB_og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sP08X6fPlM-z6fJYubufC6gp_-YCNVIIrYSR36v0vZCnaYu2ytt63Q>
    <xmx:sP08X0zMQExDiAHU2SN6Sm__YGuZwOCwcVkgiJsewYXbAb4EoIJfmQ>
    <xmx:sP08X4OwFjLhsVqbH0RF5k8RYl_nY3fRIFdu9sa4BmMb4689eDodFQ>
    <xmx:sP08Xzkp1IcceKdm1pWVbgZuCm_8Wd-MZM8P_qPh6CCTx3c4KkcE7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1A0F328005E;
        Wed, 19 Aug 2020 06:23:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Define some PARF params needed for ipq8064 SoC" failed to apply to 4.9-stable tree
To:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com, robh@kernel.org,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:23:59 +0200
Message-ID: <159783263919336@kroah.com>
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

From 5149901e9e6deca487c01cc434a3ac4125c7b00b Mon Sep 17 00:00:00 2001
From: Ansuel Smith <ansuelsmth@gmail.com>
Date: Mon, 15 Jun 2020 23:06:03 +0200
Subject: [PATCH] PCI: qcom: Define some PARF params needed for ipq8064 SoC

Set some specific value for Tx De-Emphasis, Tx Swing and Rx equalization
needed on some ipq8064 based device (Netgear R7800 for example). Without
this the system locks on kernel load.

Link: https://lore.kernel.org/r/20200615210608.21469-8-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v4.5+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 8cb36cbcde46..69c7b119e81a 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -77,6 +77,18 @@
 #define DBI_RO_WR_EN				1
 
 #define PERST_DELAY_US				1000
+/* PARF registers */
+#define PCIE20_PARF_PCS_DEEMPH			0x34
+#define PCS_DEEMPH_TX_DEEMPH_GEN1(x)		((x) << 16)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(x)	((x) << 8)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(x)	((x) << 0)
+
+#define PCIE20_PARF_PCS_SWING			0x38
+#define PCS_SWING_TX_SWING_FULL(x)		((x) << 8)
+#define PCS_SWING_TX_SWING_LOW(x)		((x) << 0)
+
+#define PCIE20_PARF_CONFIG_BITS		0x50
+#define PHY_RX0_EQ(x)				((x) << 24)
 
 #define PCIE20_v3_PARF_SLV_ADDR_SPACE_SIZE	0x358
 #define SLV_ADDR_SPACE_SZ			0x10000000
@@ -293,6 +305,7 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
+	struct device_node *node = dev->of_node;
 	u32 val;
 	int ret;
 
@@ -347,6 +360,17 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 	val &= ~BIT(0);
 	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
 
+	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
+		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(34),
+		       pcie->parf + PCIE20_PARF_PCS_DEEMPH);
+		writel(PCS_SWING_TX_SWING_FULL(120) |
+			       PCS_SWING_TX_SWING_LOW(120),
+		       pcie->parf + PCIE20_PARF_PCS_SWING);
+		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
+	}
+
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
 	val |= BIT(16);

