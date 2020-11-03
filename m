Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC652A4A71
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgKCP40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:56:26 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51415 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728106AbgKCP40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:56:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2FE68D55;
        Tue,  3 Nov 2020 10:56:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8O/AYW
        c2VzKXfhbtp7OOn5ucROFHqkZDA4+sf/XHhto=; b=QANKX+MIsPANjkIPy9mEi6
        1IrvrbR2hfBKT2+mW5m/BytmFQjyYGPKE/DXYztnQTvVYDgus+LAMlWZW2ors4it
        rtVfvmJGUolJlvfj3JnqZ8LTv30DUx2ERA54LnLVv+3LD2k0QmKycudYGN7dSKr6
        icX6iI8qgGe/0U0cHOa2qbtc+hGMXgwzuQR7tEVHPOy4h2W48KquWXCXyIWA6ccW
        vPJ3dP+qByFtFnW3oeOUS2oyjakVQ9Zt6VfSKxsVMNESAr9U6o+nAE4YGjJvSwUq
        9JzeiSNDw5fhRKvCTYoeDhh6TcyGbkZwyNqBfTpgFIgL8MWhKCJWkizwmV/pkm8A
        ==
X-ME-Sender: <xms:qH2hX_7oDJ9jNMT16EWx48tj9X0LPro0PQO6bpG1IhUb4YlyrcqL_Q>
    <xme:qH2hX06E8af45iwPDrAANcN4gDArzUEpcNaDZStS2kv38eNyRB0FLtoPQ9ySt8eGJ
    -_OG-YoVHaMHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qH2hX2fB-xG7Xwdl0LAmCS2d6qhB2koq-XTl7adSP_G2fIZ6M5LtHQ>
    <xmx:qH2hXwJPy7kxUSpKLhA9hKLhjTrmSxcSuk2Hf2I668TlZye8nmbenA>
    <xmx:qH2hXzI0qJKC4_M1awC-tSo0EvIa962ZqsgLiHoY63o8v2NlRKDxSA>
    <xmx:qH2hX5h46P1SJALm2O1RqEYkwqNbRH_k1se2iDD-rnFH4obpiXcrwIVEZ_0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E5DC3280068;
        Tue,  3 Nov 2020 10:56:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0" failed to apply to 4.19-stable tree
To:     ansuelsmth@gmail.com, bjorn.andersson@linaro.org,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:57:07 +0100
Message-ID: <160441902787254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

