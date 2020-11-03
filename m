Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59B2A4A0A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKCPk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:40:57 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51357 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727470AbgKCPk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:40:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E57E1C84;
        Tue,  3 Nov 2020 10:40:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MiGZw8
        nP6OASJwXOM+tnx4PVavVlue5OipZDa+xR874=; b=XGWzf9fiSk5/c1PulLl7s9
        peaD0wgg0sGs+v4/TkB9Vzg3gqfXmNWZLbRAohXtfRg+b4XvMcPSL61iXhylJ5lE
        93IAwGA5rBpB7CwnzYLFV8YVV/6s7cIXjknFzDYDQ8JALQjhtkRuI5HJHJJeEv2h
        ZuM5yY+OE4IV1q593arghJMZs9C7NbPLRFDU7HvOl1vKldH0/FeXo7L2rXo15VzS
        SAS2ZnHC5RQM3ext1881ANnegDyBgThbM4jZo+wAhk6YUU3nvTXoRr8plhMmrPBF
        zAD8JV2HmCj/YaQyG9jX3XQiF6wbz7QJCAS2NTsRMgeT5jSp84WXc51kMpoj7ILA
        ==
X-ME-Sender: <xms:B3qhX2bWiYleAQb1yh-_XI9y4cTOnJ4-kEcjsiyb93f5sqgxjtnhIg>
    <xme:B3qhX5YJTshwBcJMYVFR73Yg-qloab9-Uyr1npKyG88inCxbWDUj_RPRmTSyWLUrJ
    lshLt7aBB_Bgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B3qhXw8xf0fuc4jyCXjc0Erh9EusjN5dznD3hbv9KWNfZrQiqLsP_w>
    <xmx:B3qhX4rJ8jf-LrCKPecAFwBE8OnSsPS30vLUIW4Aw9E2jo2vqxrTCw>
    <xmx:B3qhXxqQ7aZ6M4a_8KH6emYgd8ePD74j2_jqMG-WBjL3tLBXyiC6lg>
    <xmx:B3qhXwTBVce28rQrpYxYAFmSyTqkrpsJaOs4hUeXpqHyJgqkovNq9wljGYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E82E53064684;
        Tue,  3 Nov 2020 10:40:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] rtc: rx8010: don't modify the global rtc ops" failed to apply to 4.19-stable tree
To:     bgolaszewski@baylibre.com, alexandre.belloni@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:41:48 +0100
Message-ID: <16044181082745@kroah.com>
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

From d3b14296da69adb7825022f3224ac6137eb30abf Mon Sep 17 00:00:00 2001
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Mon, 14 Sep 2020 17:45:48 +0200
Subject: [PATCH] rtc: rx8010: don't modify the global rtc ops

The way the driver is implemented is buggy for the (admittedly unlikely)
use case where there are two RTCs with one having an interrupt configured
and the second not. This is caused by the fact that we use a global
rtc_class_ops struct which we modify depending on whether the irq number
is present or not.

Fix it by using two const ops structs with and without alarm operations.
While at it: not being able to request a configured interrupt is an error
so don't ignore it and bail out of probe().

Fixes: ed13d89b08e3 ("rtc: Add Epson RX8010SJ RTC driver")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200914154601.32245-2-brgl@bgdev.pl

diff --git a/drivers/rtc/rtc-rx8010.c b/drivers/rtc/rtc-rx8010.c
index fe010151ec8f..08c93d492494 100644
--- a/drivers/rtc/rtc-rx8010.c
+++ b/drivers/rtc/rtc-rx8010.c
@@ -407,16 +407,26 @@ static int rx8010_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	}
 }
 
-static struct rtc_class_ops rx8010_rtc_ops = {
+static const struct rtc_class_ops rx8010_rtc_ops_default = {
 	.read_time = rx8010_get_time,
 	.set_time = rx8010_set_time,
 	.ioctl = rx8010_ioctl,
 };
 
+static const struct rtc_class_ops rx8010_rtc_ops_alarm = {
+	.read_time = rx8010_get_time,
+	.set_time = rx8010_set_time,
+	.ioctl = rx8010_ioctl,
+	.read_alarm = rx8010_read_alarm,
+	.set_alarm = rx8010_set_alarm,
+	.alarm_irq_enable = rx8010_alarm_irq_enable,
+};
+
 static int rx8010_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
+	const struct rtc_class_ops *rtc_ops;
 	struct rx8010_data *rx8010;
 	int err = 0;
 
@@ -447,16 +457,16 @@ static int rx8010_probe(struct i2c_client *client,
 
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			client->irq = 0;
-		} else {
-			rx8010_rtc_ops.read_alarm = rx8010_read_alarm;
-			rx8010_rtc_ops.set_alarm = rx8010_set_alarm;
-			rx8010_rtc_ops.alarm_irq_enable = rx8010_alarm_irq_enable;
+			return err;
 		}
+
+		rtc_ops = &rx8010_rtc_ops_alarm;
+	} else {
+		rtc_ops = &rx8010_rtc_ops_default;
 	}
 
 	rx8010->rtc = devm_rtc_device_register(&client->dev, client->name,
-		&rx8010_rtc_ops, THIS_MODULE);
+					       rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rx8010->rtc)) {
 		dev_err(&client->dev, "unable to register the class device\n");

