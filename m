Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11E02E361E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgL1K6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:58:43 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40809 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1K6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:58:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 782C17C7;
        Mon, 28 Dec 2020 05:57:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:57:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SkhEJS
        5mpF85b1pdFdkfUN5yCyhHsEnW2dWBs9Q8y2o=; b=Drdaf05BI8Wwa7eluZoR5J
        Me4BghivPoTzxOFlYU3/EREQg5pjitrzFTyANVbPSfK0IBhoC05Hf8HhFzOSWQut
        v6kmHD7n5aVP0dcGGTORx9i7r7WOTXD4+D8Dm9xgpqvrgqCOaAbaLhMP0IqqqBeq
        SURfL9nORaM7AXxO3L0LdowjKosYoCGEv2nnm3wRJ3cZm5wLFJdVUBTD45cE8K0W
        QSKJAgLd0bTn0pylOOw085ZBJWItW8N2oMbOvAR39PKY0AQAlbzlDldHfQdqZMEM
        5S6+NgAgWKQKdbhXGRyk4JNF4y4JCYy8K6HSbo4rG4ITD0fAd92aMTMD6Vrd07eQ
        ==
X-ME-Sender: <xms:NLrpX2ci0aNkadhQkkXAXC4Qpkh8L7pPRoStwlMyZ1OMJJ7Ta4F9bQ>
    <xme:NLrpXwNM3vXc1hgvDEsKgl80Xoc_mAzhUKVllqmBnXqm8ytlAXN4RaRc6NDJvAfGF
    pWSfb0IlpyKxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NLrpX3hnFQzde-0eJfBv5zESWMl4qm7OeTgw0TCMqSuzZUnw0dWGoA>
    <xmx:NLrpXz9Klhf0S6P0u7Y5kvuRP-R9LITHIqzD_NTKnn33nvP7VN0iEw>
    <xmx:NLrpXyv7CWJe_z-RLNKJJF8y33vOAr7Vir2dwredl3-xowr0G9BVaw>
    <xmx:NbrpX2KIW-yDZ9ksIXwTBA1acpJuS7PcG6aYaf-ufSqvrq7fEUQ2iF4m_Dc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C5B1240057;
        Mon, 28 Dec 2020 05:57:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: gpio: Don't leak SPI master in probe error path" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, andrew.smirnov@gmail.com, broonie@kernel.org,
        linus.walleij@linaro.org, navid.emamdoost@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:59:19 +0100
Message-ID: <1609153159153229@kroah.com>
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

From 7174dc655ef0578877b0b4598e69619d2be28b4d Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:09 +0100
Subject: [PATCH] spi: gpio: Don't leak SPI master in probe error path

If the call to devm_spi_register_master() fails on probe of the GPIO SPI
driver, the spi_master struct is erroneously not freed:

After allocating the spi_master, its reference count is 1.  The driver
unconditionally decrements the reference count on unbind using a devm
action.  Before calling devm_spi_register_master(), the driver
unconditionally increments the reference count because on success,
that function will decrement the reference count on unbind.  However on
failure, devm_spi_register_master() does *not* decrement the reference
count, so the spi_master is leaked.

The issue was introduced by commits 8b797490b4db ("spi: gpio: Make sure
spi_master_put() is called in every error path") and 79567c1a321e ("spi:
gpio: Use devm_spi_register_master()"), which sought to plug leaks
introduced by 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO
descriptors") but missed this remaining leak.

The situation was later aggravated by commit d3b0ffa1d75d ("spi: gpio:
prevent memory leak in spi_gpio_probe"), which introduced a
use-after-free because it releases a reference on the spi_master if
devm_add_action_or_reset() fails even though the function already
does that.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO descriptors")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <stable@vger.kernel.org> # v4.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.1-: 8b797490b4db: spi: gpio: Make sure spi_master_put() is called in every error path
Cc: <stable@vger.kernel.org> # v5.1-: 45beec351998: spi: bitbang: Introduce spi_bitbang_init()
Cc: <stable@vger.kernel.org> # v5.1-: 79567c1a321e: spi: gpio: Use devm_spi_register_master()
Cc: <stable@vger.kernel.org> # v5.4-: d3b0ffa1d75d: spi: gpio: prevent memory leak in spi_gpio_probe
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Link: https://lore.kernel.org/r/86eaed27431c3d709e3748eb76ceecbfc790dd37.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 7ceb0ba27b75..0584f4d2fde2 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -350,11 +350,6 @@ static int spi_gpio_probe_pdata(struct platform_device *pdev,
 	return 0;
 }
 
-static void spi_gpio_put(void *data)
-{
-	spi_master_put(data);
-}
-
 static int spi_gpio_probe(struct platform_device *pdev)
 {
 	int				status;
@@ -363,16 +358,10 @@ static int spi_gpio_probe(struct platform_device *pdev)
 	struct device			*dev = &pdev->dev;
 	struct spi_bitbang		*bb;
 
-	master = spi_alloc_master(dev, sizeof(*spi_gpio));
+	master = devm_spi_alloc_master(dev, sizeof(*spi_gpio));
 	if (!master)
 		return -ENOMEM;
 
-	status = devm_add_action_or_reset(&pdev->dev, spi_gpio_put, master);
-	if (status) {
-		spi_master_put(master);
-		return status;
-	}
-
 	if (pdev->dev.of_node)
 		status = spi_gpio_probe_dt(pdev, master);
 	else
@@ -432,7 +421,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 	if (status)
 		return status;
 
-	return devm_spi_register_master(&pdev->dev, spi_master_get(master));
+	return devm_spi_register_master(&pdev->dev, master);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);

