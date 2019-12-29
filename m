Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4812C347
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 17:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfL2QGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 11:06:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56877 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbfL2QGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 11:06:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 316F321B36;
        Sun, 29 Dec 2019 11:06:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 11:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dYKKmf
        t2kJ6iwGl6c2sj+nGxThnVFr9CrZeQDP2SW94=; b=Mb1RWcqH2BiAnDaE2trjIu
        gmTi0ShbohxfukJmiKU5jURUQc8aqjsUBDLieeHaPNTVmlQKUK5CNuITvNIOhifr
        s+n6mHx+4E0qXXGKxMillOWzsuPsLTfu3ALYtw281ty/EeOh5VDLR0bNvxhb2hnZ
        HTm5fxxlWrFcA6ecqiBwyVQa1DAXNuEx9PuWcB6iSxFso26mo4zhovymT0nhh4Bu
        2a6tBf0KokWVDF6RVOM9H47TmKkrkjjRBsgtGubnCjbdsQ0bJdIMQTvM6CZvch4a
        UmGbiJqhyPBh9VPK6nVVqN+tkOsqdNLZQ3mK/0q5c10OED6NyYLqjVQTqNUEztuA
        ==
X-ME-Sender: <xms:Bc8IXqeBpvmtLweui9gKxpzLRRBg09AvDkz5KVpHCm320Wpeq5gHDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdplhhunhigphdrtghomhenucfkph
    epkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:Bc8IXsG0N9dmd2fwC6yuyh0VNJ5N3Gl58q28coCZKpaDl4tfrQEHfA>
    <xmx:Bc8IXhd1eBICe0O4wehZS8Rfvvg1YyhbyuH0YBxI-9kZ1mMNLFQPXA>
    <xmx:Bc8IXrljxMrbx4tbjWUL3mzCoOZCaAkmhcs844mXfeYC-ud5sG-ckg>
    <xmx:Bc8IXjgGNPKJu01wjNn86LF_znXblyk3DQNn1mNQ8MKiGmdnHDrQZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6EB83060A32;
        Sun, 29 Dec 2019 11:06:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround" failed to apply to 4.14-stable tree
To:     yangbo.lu@nxp.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 17:06:18 +0100
Message-ID: <1577635578956@kroah.com>
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

From f667216c5c7c967c3e568cdddefb51fe606bfe26 Mon Sep 17 00:00:00 2001
From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Thu, 19 Dec 2019 11:23:35 +0800
Subject: [PATCH] mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

The erratum A-009204 workaround patch was reverted because of
incorrect implementation.

8b6dc6b mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add
        erratum A-009204 support"

This patch is to re-implement the workaround (add a 5 ms delay
before setting SYSCTL[RSTD] to make sure all the DMA transfers
are finished).

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Link: https://lore.kernel.org/r/20191219032335.26528-1-yangbo.lu@nxp.com
Fixes: 5dd195522562 ("mmc: sdhci-of-esdhc: add erratum A-009204 support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 4ca640e6fd55..500f70a6ee42 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -80,6 +80,7 @@ struct sdhci_esdhc {
 	bool quirk_tuning_erratum_type1;
 	bool quirk_tuning_erratum_type2;
 	bool quirk_ignore_data_inhibit;
+	bool quirk_delay_before_data_reset;
 	bool in_sw_tuning;
 	unsigned int peripheral_clock;
 	const struct esdhc_clk_fixup *clk_fixup;
@@ -759,6 +760,11 @@ static void esdhc_reset(struct sdhci_host *host, u8 mask)
 	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
 	u32 val;
 
+	if (esdhc->quirk_delay_before_data_reset &&
+	    (mask & SDHCI_RESET_DATA) &&
+	    (host->flags & SDHCI_REQ_USE_DMA))
+		mdelay(5);
+
 	sdhci_reset(host, mask);
 
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
@@ -1218,6 +1224,10 @@ static void esdhc_init(struct platform_device *pdev, struct sdhci_host *host)
 	if (match)
 		esdhc->clk_fixup = match->data;
 	np = pdev->dev.of_node;
+
+	if (of_device_is_compatible(np, "fsl,p2020-esdhc"))
+		esdhc->quirk_delay_before_data_reset = true;
+
 	clk = of_clk_get(np, 0);
 	if (!IS_ERR(clk)) {
 		/*

