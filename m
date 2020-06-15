Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53F1F9BDD
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgFOPVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:21:37 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:34163 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730313AbgFOPVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:21:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 102937D4;
        Mon, 15 Jun 2020 11:21:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Pe7QUK
        uFnL+9XvUGB4cBKc7JDO7Xzn8mKoe+Gn2tOxo=; b=swwgLRkyGNTuQAt20+lNp7
        /FbKjtmLtrNlhqDk39g5bpiFga0EU3cboaa+1CJiGCZVi9rgzrNpW+tvQXuTgPhZ
        iKb66kMJOdX1orRA8RHcojHe/J/tfXts9eFk2BRIO9iHIimHZaIdxL6g8L5Gbn0+
        GXLttXG85whWZarXc4IoPpDXsymI0u2IcFdv1wJVKL7CqiCnbTxpgnxrXZxJdujE
        A0BMM2wiOfkIvEXVL51Yeq75NqyzTttmpG2dxvhIe+T3/s4UEchILZL43jU6PcFU
        6qwCJY9+6dxp1+cLsjix7DgzGhKMIIwfkXGabFg/CMUs5AcsWVZq61XI2NsjTPgA
        ==
X-ME-Sender: <xms:_5HnXvZ015LXGByBY7m6UnJT0wdDQa8uUWZi_IBmnsqPHR_Ir024Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_5HnXubsj4eKSoOKeReemvhUKoEo1Yz67LVD7ZyCDXEfLviV-CMZNg>
    <xmx:_5HnXh_ahtZZa6ndPLbtK09Pjzc84xEjNBXc_tdbQhAyB-OsTVjrFQ>
    <xmx:_5HnXlol2rrP-gahYrOVGl-QXkT3cY6-Q7DHkxmFKGAav5uWED1arw>
    <xmx:_5HnXvDBqvou9SAViaCwlEXeHqiJbGUZLM6zTU1pac02GTNoCES7CPA3cXs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 470E03061856;
        Mon, 15 Jun 2020 11:21:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: pxa2xx: Fix controller unregister order" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        broonie@kernel.org, kitakar@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:21:18 +0200
Message-ID: <1592234478161121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 32e5b57232c0411e7dea96625c415510430ac079 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 25 May 2020 14:25:02 +0200
Subject: [PATCH] spi: pxa2xx: Fix controller unregister order

The PXA2xx SPI driver uses devm_spi_register_controller() on bind.
As a consequence, on unbind, __device_release_driver() first invokes
pxa2xx_spi_remove() before unregistering the SPI controller via
devres_release_all().

This order is incorrect:  pxa2xx_spi_remove() disables the chip,
rendering the SPI bus inaccessible even though the SPI controller is
still registered.  When the SPI controller is subsequently unregistered,
it unbinds all its slave devices.  Because their drivers cannot access
the SPI bus, e.g. to quiesce interrupts, the slave devices may be left
in an improper state.

As a rule, devm_spi_register_controller() must not be used if the
->remove() hook performs teardown steps which shall be performed after
unregistering the controller and specifically after unbinding of slaves.

Fix by reverting to the non-devm variant of spi_register_controller().

An alternative approach would be to use device-managed functions for all
steps in pxa2xx_spi_remove(), e.g. by calling devm_add_action_or_reset()
on probe.  However that approach would add more LoC to the driver and
it wouldn't lend itself as well to backporting to stable.

The improper use of devm_spi_register_controller() was introduced in 2013
by commit a807fcd090d6 ("spi: pxa2xx: use devm_spi_register_master()"),
but all earlier versions of the driver going back to 2006 were likewise
broken because they invoked spi_unregister_master() at the end of
pxa2xx_spi_remove(), rather than at the beginning.

Fixes: e0c9905e87ac ("[PATCH] SPI: add PXA2xx SSP SPI Driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v2.6.17+
Cc: Tsuchiya Yuto <kitakar@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206403#c1
Link: https://lore.kernel.org/r/834c446b1cf3284d2660f1bee1ebe3e737cd02a9.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 73d2a65d0b6e..f456ce18f79e 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1884,7 +1884,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
-	status = devm_spi_register_controller(&pdev->dev, controller);
+	status = spi_register_controller(controller);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem registering spi controller\n");
 		goto out_error_pm_runtime_enabled;
@@ -1916,6 +1916,8 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(drv_data->controller);
+
 	/* Disable the SSP at the peripheral and SOC level */
 	pxa2xx_spi_write(drv_data, SSCR0, 0);
 	clk_disable_unprepare(ssp->clk);

