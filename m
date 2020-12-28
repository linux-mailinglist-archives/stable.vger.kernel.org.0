Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD72E3629
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgL1LHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:07:13 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37129 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1LHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:07:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6CBB469B;
        Mon, 28 Dec 2020 06:06:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:06:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cO+KWC
        5HYtcbHpPW0XeXKXx7P8LZUaDyzD24an/zfCU=; b=K1zmqv4MgpDqv3oA0O3pd0
        RgvE+TsNYNmLd0HyjVzjxJDbIktk/htTqvfZ5hh8lkP+kLXNZipQlGC2ZL2M2ENV
        oZwelfn8FyI+jWVoIAVa26XKdE8ichBts5KC4QrxES4tghodIY5uuxGbkdgLsdWh
        x+5kvVrAk/QEonXxm+0P+wqZ9Kuyd0HOjbkhEQchzH+FpM91SdvGIsDcjaELbFjf
        citA3eHKhD4Gcv43tcBZjCNiizhNQUQY4ayteUkKEBOUkUD5MVU6uDCaA6za2hkB
        h7vdQZiczwZbm2vh+xLWgV48vqaZCcTuWcmUKsT42jqEQcxf+GZbPmEoelsowoYg
        ==
X-ME-Sender: <xms:HrzpX1ik0gtTJBWyAbzhonmZYbxSV8_th4iIOAhzNwfHVeoOz9NAaw>
    <xme:HrzpX6AlbWH5Pl0GJRIQLKYXpK6YZzQRM-MqRGTGplf-oVT-adxwKvLXji7e3kPPT
    aZi1V6b4Gw_OA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HrzpX1EdJ_J6A1AdP0BkYDdFFmrKoOUAlcXa30CBG1_hgbtxBi2KKg>
    <xmx:HrzpX6StjchIwWXRBOeleT80m0mfcMNXyvugtZh67dWpLbVu_jwXXw>
    <xmx:HrzpXywLyDUWX30PrTdWrepun7IzTTGkJfTeZh-AAe9luJ7t4uwqMA>
    <xmx:H7zpX3pJJ-npSYcfQYmtTm6bwPZrWCe_nHu-PerakbyDIHKDBL4ADqWuW_c>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57AC5108005B;
        Mon, 28 Dec 2020 06:06:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: mt7621: Don't leak SPI master in probe error path" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, sr@denx.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:07:29 +0100
Message-ID: <1609153649331@kroah.com>
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

From 46b5c4fb87ce8211e0f9b0383dbde72c3652d2ba Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:14 +0100
Subject: [PATCH] spi: mt7621: Don't leak SPI master in probe error path

If the calls to device_reset() or devm_spi_register_controller() fail on
probe of the MediaTek MT7621 SPI driver, the spi_controller struct is
erroneously not freed.  Fix by switching over to the new
devm_spi_alloc_master() helper.

Additionally, there's an ordering issue in mt7621_spi_remove() wherein
the spi_controller is unregistered after disabling the SYS clock.
The correct order is to call spi_unregister_controller() *before* this
teardown step because bus accesses may still be ongoing until that
function returns.

All of these bugs have existed since the driver was first introduced,
so it seems fair to fix them together in a single commit.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Stefan Roese <sr@denx.de>
Cc: <stable@vger.kernel.org> # v4.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.17+
Link: https://lore.kernel.org/r/72b680796149f5fcda0b3f530ffb7ee73b04f224.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index e227700808cb..b4b9b7309b5e 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -350,7 +350,7 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 	if (status)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (!master) {
 		dev_info(&pdev->dev, "master allocation failed\n");
 		clk_disable_unprepare(clk);
@@ -382,7 +382,7 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, master);
+	ret = spi_register_controller(master);
 	if (ret)
 		clk_disable_unprepare(clk);
 
@@ -397,6 +397,7 @@ static int mt7621_spi_remove(struct platform_device *pdev)
 	master = dev_get_drvdata(&pdev->dev);
 	rs = spi_controller_get_devdata(master);
 
+	spi_unregister_controller(master);
 	clk_disable_unprepare(rs->clk);
 
 	return 0;

