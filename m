Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA6A72D7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfICSxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:53:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41855 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfICSxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:53:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8A5DE22023;
        Tue,  3 Sep 2019 14:53:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=d60O1S
        Gl2wNS+Feo8OITspYXoJbEFH6pqy6Ev822qLA=; b=GLae8SLE+hnON2f7bg3rYd
        dFVlEPmpu0507O9Exji/zek+m8ej24y3panCSv1nT4ZSe1aCKeuAFTq+d3hVwB50
        NZgsNXr4AV8r64Km6Pl28eWFHlCIF1auZapt9rnYJF+PetJmUMHj2/9ffy6yQa0o
        e+ZfUbDSABOtXjlBtHhmNEPXskRdgBHT/ma8NYnEkNCMwSj1K/wNV+XL20aPEv2J
        +jtEF/IraSi7hkoVNQuS5+Aj26xYZUcdjeFu8TNQ2ts+TKncgOIr9zQGXrFIgGmY
        h2ACo2QrhRqzEZxa60eN9U342kFf9zye1arPkGkiaOjrbm9sKZDFY7s4brx/kaAQ
        ==
X-ME-Sender: <xms:uLZuXfX5f79ggi53zcluxw8b-Jrs5eMwWTOErz0iolUVllIuFZMgbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:uLZuXVKREMdccbTZXoD7Z-EzGfETtamJJuYRGX80YWYHk3mXWixfsg>
    <xmx:uLZuXctj0oCcv2dBr8u_ZK4VeP2c96kruP-VplsIckK99HITmRgofw>
    <xmx:uLZuXUuEciAawCaQYKfwLtSVr5pnRfFWFH25Mfdd1EfUCQHDh6rrdQ>
    <xmx:ubZuXbPvY2VczK0ZEdchlVj3jHXdRsbwGCQCseAIPy-YH1i6kVlk1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8A1FD60057;
        Tue,  3 Sep 2019 14:53:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-sprd: clear the UHS-I modes read from registers" failed to apply to 5.2-stable tree
To:     chunyan.zhang@unisoc.com, baolin.wang@linaro.org,
        ulf.hansson@linaro.org, zhang.lyra@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:53:43 +0200
Message-ID: <15675368231148@kroah.com>
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

From 2f765c175e1d1acae911f889e71e5933c6488929 Mon Sep 17 00:00:00 2001
From: Chunyan Zhang <chunyan.zhang@unisoc.com>
Date: Wed, 28 Aug 2019 10:17:36 +0800
Subject: [PATCH] mmc: sdhci-sprd: clear the UHS-I modes read from registers

sprd's sd host controller supports SDR50/SDR104/DDR50 though, the UHS-I
mode used by the specific card can be selected via devicetree only.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linaro.org>
Tested-by: Baolin Wang <baolin.wang@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index ba777f0c77d1..d07b9793380f 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -509,7 +509,8 @@ static void sdhci_sprd_phy_param_parse(struct sdhci_sprd_host *sprd_host,
 
 static const struct sdhci_pltfm_data sdhci_sprd_pdata = {
 	.quirks = SDHCI_QUIRK_BROKEN_CARD_DETECTION |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK,
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
+		  SDHCI_QUIRK_MISSING_CAPS,
 	.quirks2 = SDHCI_QUIRK2_BROKEN_HS200 |
 		   SDHCI_QUIRK2_USE_32BIT_BLK_CNT |
 		   SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
@@ -614,6 +615,16 @@ static int sdhci_sprd_probe(struct platform_device *pdev)
 
 	sdhci_enable_v4_mode(host);
 
+	/*
+	 * Supply the existing CAPS, but clear the UHS-I modes. This
+	 * will allow these modes to be specified only by device
+	 * tree properties through mmc_of_parse().
+	 */
+	host->caps = sdhci_readl(host, SDHCI_CAPABILITIES);
+	host->caps1 = sdhci_readl(host, SDHCI_CAPABILITIES_1);
+	host->caps1 &= ~(SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_SDR104 |
+			 SDHCI_SUPPORT_DDR50);
+
 	ret = sdhci_setup_host(host);
 	if (ret)
 		goto pm_runtime_disable;

