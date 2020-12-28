Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D055B2E3625
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgL1LB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:01:28 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47963 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1LB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:01:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0FA7F666;
        Mon, 28 Dec 2020 06:00:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RTJ7FI
        00kUK/WusTHp0AZ9SGYyMpSto6AFElIdGaDCo=; b=FMbCdzRR3MFn4SKb9eHCB6
        gPrOE8v31dAkS0Wqv3S6toCgb+uHRiDdGUq2jwgyT8TDrj8mNZCTSwoRMtpaWf+z
        43HX57sMTF7h1SOeQA1Potms4+bLGR6LXY8J33NrXope9J0gIsu02c6VLsRktrVz
        4KWWPvk/6doUseGHUL1JHkhE3W0cdOiH62n/YR/cVzL+6aW73YAWaO0tZ+rvwvCx
        qodpvJbrq9Y2S4fCdMLyo4l5by7IcZgj3x/yrXvFNgmdvRBU4Z3YeobUGoWQztI1
        8rwU3AveAVVZc3JP6r87XpjpMHQ/x2kAtBy+qcbJg+QanVTeQisdxir2Dhd5T/tA
        ==
X-ME-Sender: <xms:xbrpX4z_892VI4tDQIJtcXgXRI4mc7sgfhp3PIZMKD_ntebczoR5Cg>
    <xme:xbrpX8Sygf2CKUEYSbfeeLkpDd8Itn39tn4NX8FXFNqB_iEhXCgYQrw-VP9yGFeJN
    MY4ty-36O2BwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xbrpX6WN5TJN10LfbTW2K5DzPS42TwuWVFLBXc2sdibOS68oU447yQ>
    <xmx:xbrpX2j5_tcBS3z3VBbER-CLumPHI2JObI9BgWo-jk74qJcqOkQj1g>
    <xmx:xbrpX6Blx2PYoe0c-QhcycPUEdxg7VaKoQ6CGNZQeoj2Z_WH64Oe0g>
    <xmx:xbrpX9OGvYEseN2R1uE38u2ZkssSomNuGZUQc_JgtsaBE6fErn6hXYhvvWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E10711080064;
        Mon, 28 Dec 2020 06:00:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: spi-geni-qcom: Fix use-after-free on unbind" failed to apply to 5.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, girishm@codeaurora.org,
        rnayak@codeaurora.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:01:44 +0100
Message-ID: <16091533040136@kroah.com>
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

From 8f96c434dfbc85ffa755d6634c8c1cb2233fcf24 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:02 +0100
Subject: [PATCH] spi: spi-geni-qcom: Fix use-after-free on unbind

spi_geni_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Moreover, since commit 1a9e489e6128 ("spi: spi-geni-qcom: Use OPP API to
set clk/perf state"), spi_geni_probe() leaks the spi_master allocation
if the calls to dev_pm_opp_set_clkname() or dev_pm_opp_of_add_table()
fail.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound and also
avoids the spi_master leak on probe.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.20+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Cc: Girish Mahadevan <girishm@codeaurora.org>
Link: https://lore.kernel.org/r/dfa1d8c41b8acdfad87ec8654cd124e6e3cb3f31.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 25810a7eef10..0e3d8e6c08f4 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -603,7 +603,7 @@ static int spi_geni_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	spi = spi_alloc_master(dev, sizeof(*mas));
+	spi = devm_spi_alloc_master(dev, sizeof(*mas));
 	if (!spi)
 		return -ENOMEM;
 
@@ -673,7 +673,6 @@ static int spi_geni_probe(struct platform_device *pdev)
 	free_irq(mas->irq, spi);
 spi_geni_probe_runtime_disable:
 	pm_runtime_disable(dev);
-	spi_master_put(spi);
 	dev_pm_opp_of_remove_table(&pdev->dev);
 put_clkname:
 	dev_pm_opp_put_clkname(mas->se.opp_table);

