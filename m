Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949F22A4AB9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgKCQEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:04:49 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52305 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgKCQEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:04:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E0793424;
        Tue,  3 Nov 2020 11:04:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 11:04:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xPeZ5t
        sS+k5EycxBjeLlu8Cp3evLfZnWSRqqxcL7Plw=; b=m1WwgNbsFXtm53BQ0Ss7nK
        UQsWUaT/y0WGxXp0dNeFYu3qZqFlhay6vNtnyiuWRm9OrCsv0Xy2CfR522rJK12z
        bfUlP6dGrSTH8UJ/2zrJiYp535CIuQrisBJF9+VLJCQV6KxX6NQrGBU82N+UXlrN
        wWcfeTmXWkwxInFLICPV9S63dy1cdr1olOY59le9eEtns8FPpjTIGlk464kpriLk
        HIRdGDuTsXPBo8ridGN8HWBSRkxSMiiYF1OF805osRjm4NMekmx7viH0FCpw4DAI
        KVnNHnW3YD9xyMGBC2cLDGzdrRvTw0x4WxJCbIFiNCj8JyTFHiH9lnOK/ID+Xj3g
        ==
X-ME-Sender: <xms:n3-hX9gx9dZWXilpDwXeqfKYwG87qhw2ngtSbJujopnt55ONAeRiag>
    <xme:n3-hXyBlRFw0S2r2-PSSbLyuQAYA1JLdPaOiUjes2M0CmXBUt4pFQlCpw6SbKECCE
    Ku_TdvYaP6bNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:n3-hX9Em2qyiGOc_lJlpF9GFcVFxEUSY_VVFl6SH--l-ScbAjrLO-w>
    <xmx:n3-hXyS5UeMcQ5GxNvVf_wsaQPYX5FuzZqM4CgfmDEhUEtCNOzn-TQ>
    <xmx:n3-hX6zwlVfUusVYI58z0tmQR_aB9h7C6zZ22f7Ye7d_mzpJnlRDpQ>
    <xmx:n3-hX_pEEUmmL8-IXI4qJUhdlbw2jK0ySCuj4_V-WawVtg9QVbUAlW8kAeU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFE1D3064686;
        Tue,  3 Nov 2020 11:04:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-esdhc: make sure delay chain locked for HS400" failed to apply to 5.4-stable tree
To:     yangbo.lu@nxp.com, adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 17:05:15 +0100
Message-ID: <1604419515138100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 011fde48394b7dc8dfd6660d1013b26a00157b80 Mon Sep 17 00:00:00 2001
From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Tue, 20 Oct 2020 16:11:16 +0800
Subject: [PATCH] mmc: sdhci-of-esdhc: make sure delay chain locked for HS400

For eMMC HS400 mode initialization, the DLL reset is a required step
if DLL is enabled to use previously, like in bootloader.
This step has not been documented in reference manual, but the RM will
be fixed sooner or later.

This patch is to add the step of DLL reset, and make sure delay chain
locked for HS400.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201020081116.20918-1-yangbo.lu@nxp.com
Fixes: 54e08d9a95ca ("mmc: sdhci-of-esdhc: add hs400 mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-esdhc.h b/drivers/mmc/host/sdhci-esdhc.h
index a30796e79b1c..6de02f09c322 100644
--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -5,6 +5,7 @@
  * Copyright (c) 2007 Freescale Semiconductor, Inc.
  * Copyright (c) 2009 MontaVista Software, Inc.
  * Copyright (c) 2010 Pengutronix e.K.
+ * Copyright 2020 NXP
  *   Author: Wolfram Sang <kernel@pengutronix.de>
  */
 
@@ -88,6 +89,7 @@
 /* DLL Config 0 Register */
 #define ESDHC_DLLCFG0			0x160
 #define ESDHC_DLL_ENABLE		0x80000000
+#define ESDHC_DLL_RESET			0x40000000
 #define ESDHC_DLL_FREQ_SEL		0x08000000
 
 /* DLL Config 1 Register */
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index baf7801a1804..bb094459196a 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -4,6 +4,7 @@
  *
  * Copyright (c) 2007, 2010, 2012 Freescale Semiconductor, Inc.
  * Copyright (c) 2009 MontaVista Software, Inc.
+ * Copyright 2020 NXP
  *
  * Authors: Xiaobo Xie <X.Xie@freescale.com>
  *	    Anton Vorontsov <avorontsov@ru.mvista.com>
@@ -19,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/ktime.h>
 #include <linux/dma-mapping.h>
+#include <linux/iopoll.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
 #include "sdhci-pltfm.h"
@@ -743,6 +745,21 @@ static void esdhc_of_set_clock(struct sdhci_host *host, unsigned int clock)
 		if (host->mmc->actual_clock == MMC_HS200_MAX_DTR)
 			temp |= ESDHC_DLL_FREQ_SEL;
 		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+
+		temp |= ESDHC_DLL_RESET;
+		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+		udelay(1);
+		temp &= ~ESDHC_DLL_RESET;
+		sdhci_writel(host, temp, ESDHC_DLLCFG0);
+
+		/* Wait max 20 ms */
+		if (read_poll_timeout(sdhci_readl, temp,
+				      temp & ESDHC_DLL_STS_SLV_LOCK,
+				      10, 20000, false,
+				      host, ESDHC_DLLSTAT0))
+			pr_err("%s: timeout for delay chain lock.\n",
+			       mmc_hostname(host->mmc));
+
 		temp = sdhci_readl(host, ESDHC_TBCTL);
 		sdhci_writel(host, temp | ESDHC_HS400_WNDW_ADJUST, ESDHC_TBCTL);
 

