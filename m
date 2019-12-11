Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8A811AD09
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfLKOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:06:39 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53759 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfLKOGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:06:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2626AA1E;
        Wed, 11 Dec 2019 09:06:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 09:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UbSXAY
        Y2k6WJU3fAqkpbYOFEcspu5WP2eJ0Ie6B9cDA=; b=uP42Q1luvB8xYhw4et1RIW
        AQTHTHeQRptJCEPlmCXjJ0+l7jTVPO9XRKzcn0ur3a0MjHRQGqUeFM6YU/SCwcH6
        BUFrpjWSIBr8otXv3gRGaqGA2RenI+JBn7URROC4LyF5GCIqujtp+3CuELKD8KAJ
        tjhTtAfJeCrj9emJ93qoRDrL/7K8iOq1PJynKllmzDSkVZ5QRNSJlPdBwUH+ZKBS
        7TwcsEW5EIyB1KeWtSi8wK5hKZoaNMapeFGagi2+g297gUGkEvTlXNh2rLMwdcf7
        DBhh2r9PDSir/FxzhQha3sMGtYBCFZrg5A6Skz9ne4NrXWFK0d5AaO1WLesphqjw
        ==
X-ME-Sender: <xms:7ffwXWfb0t5YtvyjloVp7DOCuqM4ik-jQW5o3uApeQLZX1iMj8NRKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:7ffwXbm0oqBuBUcIlAvIo_xLzV-YvDwo0nnRkGHWN45EDMMi5j1f2Q>
    <xmx:7ffwXa_a3jtb057zAcc7YnxHgdgWBt-tEttdjinyJF7BwMuoZ2xszg>
    <xmx:7ffwXfsFQjPq0HsEl8DMCyfke--vcT2lijpq9pjGLH3p87apHj3XYQ>
    <xmx:7ffwXdmoYq5AD2gqYVpHYPAn0_BzWPlEnYqg0U1UjFYONtCN4w7KnA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 358108005B;
        Wed, 11 Dec 2019 09:06:37 -0500 (EST)
Subject: WTF: patch "[PATCH] net: wireless: ti: wl1251 add device tree support" was seriously submitted to be applied to the 5.4-stable tree?
To:     hns@goldelico.com, kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:06:33 +0100
Message-ID: <1576073193178125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.4-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b8d7072d6552ee5c57e5765f211f267041f9557 Mon Sep 17 00:00:00 2001
From: "H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 7 Nov 2019 11:30:35 +0100
Subject: [PATCH] net: wireless: ti: wl1251 add device tree support

We will have the wl1251 defined as a child node of the mmc interface
and can read setup for gpios, interrupts and the ti,use-eeprom
property from there instead of pdata to be provided by pdata-quirks.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: <stable@vger.kernel.org> # v4.7+
[Ulf: Fixed up some complaints from checkpatch]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index 677f1146ccf0..f1224b948f83 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -16,6 +16,9 @@
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 
 #include "wl1251.h"
 
@@ -217,6 +220,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	struct ieee80211_hw *hw;
 	struct wl1251_sdio *wl_sdio;
 	const struct wl1251_platform_data *wl1251_board_data;
+	struct device_node *np = func->dev.of_node;
 
 	hw = wl1251_alloc_hw();
 	if (IS_ERR(hw))
@@ -248,6 +252,17 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		wl->power_gpio = wl1251_board_data->power_gpio;
 		wl->irq = wl1251_board_data->irq;
 		wl->use_eeprom = wl1251_board_data->use_eeprom;
+	} else if (np) {
+		wl->use_eeprom = of_property_read_bool(np,
+						       "ti,wl1251-has-eeprom");
+		wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);
+		wl->irq = of_irq_get(np, 0);
+
+		if (wl->power_gpio == -EPROBE_DEFER ||
+		    wl->irq == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto disable;
+		}
 	}
 
 	if (gpio_is_valid(wl->power_gpio)) {

