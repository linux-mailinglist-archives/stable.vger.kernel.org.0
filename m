Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0117249A49
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgHSKYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:24:25 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53099 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgHSKYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:24:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8EA0A194237B;
        Wed, 19 Aug 2020 06:24:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=J+88WO
        FoGuHyREoGeT7frY+RldstzgUg9g3iuwzdrxc=; b=TFyfGJzMwqw5iGCI68o8Rq
        DQQ+GRytStWpuTl1MXqd867KUW45ddaqNj1/1JZSXbOSoDSrJ5UwFgYAC4gpsmVu
        5zHDh9q1A45qI+oqQAZn1ggSl0iQKaQCYr3hG/upflLwdo64RYUXFltDJe4LkXYx
        vti7cIdXmAEavRmUqkyS3s/VREa4BHEt+FzDQoNcz7MCE6yHVsWnRBcwMmPzId1n
        GLxcDI6j4gX5hoSlfOFAmGZnSYSHtj/LPJV3UGRfi8Qj6/L+NVTZnLskMLazd81w
        VLMvqfWoLEMAUwmBLx0YHerZjiPIdrlGnYnJoO4brL3mdNa66BkOTVT3HK5eVeNA
        ==
X-ME-Sender: <xms:1P08X8FJPDIHUyoa9dmWmwiFA0FIgqHBwafW-hC6vacz6Tf8tdq2mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1P08X1Xp0DFx4Kvd2k79L6dVx-N92BA7XH-qxkWzX012nEG2LIfa8w>
    <xmx:1P08X2IPUq8olbphDGFKFuANRRERFXl30I7q-1kpzeMaMQyvDyTE0Q>
    <xmx:1P08X-EE_s5q2Khghq1w58ZPfaSYLT15pJ3sH-NDMBs7jLs6N40Nkw>
    <xmx:1P08X1drogJOzTmYl4eRy78naBgkapQ9Y31C5eeJPeaUOZQFMc7EMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30EBB328005D;
        Wed, 19 Aug 2020 06:24:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: qcom: Add support for tx term offset for rev 2.1.0" failed to apply to 4.14-stable tree
To:     ansuelsmth@gmail.com, lorenzo.pieralisi@arm.com,
        smuthayy@codeaurora.org, svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:24:43 +0200
Message-ID: <159783268345165@kroah.com>
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

From de3c4bf648975ea0b1d344d811e9b0748907b47c Mon Sep 17 00:00:00 2001
From: Ansuel Smith <ansuelsmth@gmail.com>
Date: Mon, 15 Jun 2020 23:06:04 +0200
Subject: [PATCH] PCI: qcom: Add support for tx term offset for rev 2.1.0

Add tx term offset support to pcie qcom driver need in some revision of
the ipq806x SoC. Ipq8064 needs tx term offset set to 7.

Link: https://lore.kernel.org/r/20200615210608.21469-9-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v4.5+

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 69c7b119e81a..34d961e492fd 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -45,7 +45,13 @@
 #define PCIE_CAP_CPL_TIMEOUT_DISABLE		0x10
 
 #define PCIE20_PARF_PHY_CTRL			0x40
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET_MASK	GENMASK(20, 16)
+#define PHY_CTRL_PHY_TX0_TERM_OFFSET(x)		((x) << 16)
+
 #define PCIE20_PARF_PHY_REFCLK			0x4C
+#define PHY_REFCLK_SSP_EN			BIT(16)
+#define PHY_REFCLK_USE_PAD			BIT(12)
+
 #define PCIE20_PARF_DBI_BASE_ADDR		0x168
 #define PCIE20_PARF_SLV_ADDR_SPACE_SIZE		0x16C
 #define PCIE20_PARF_MHI_CLOCK_RESET_CTRL	0x174
@@ -371,9 +377,18 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
 		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
 	}
 
+	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
+		/* set TX termination offset */
+		val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
+		val &= ~PHY_CTRL_PHY_TX0_TERM_OFFSET_MASK;
+		val |= PHY_CTRL_PHY_TX0_TERM_OFFSET(7);
+		writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
+	}
+
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
-	val |= BIT(16);
+	val &= ~PHY_REFCLK_USE_PAD;
+	val |= PHY_REFCLK_SSP_EN;
 	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
 
 	/* wait for clock acquisition */

