Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F72A4A0B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgKCPlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:41:06 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54843 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727470AbgKCPlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:41:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 244EA3D1;
        Tue,  3 Nov 2020 10:41:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B5qN9U
        Yst2xL/WW3SwABgwN3NIuCqRJbLI2N9lz+Ezs=; b=PG0NMxwJOFYteTZF9UdkKK
        MxhoP4pvpdzz34048BNWh4auNj+RVR1XoJCDZmQEM7kD4fkp44JwL66YuwSVA5IJ
        CKJqJOLird3vQPi0qVxuMci8CCuFYC0qujsh8jqpxrZvdR2MuF9jSe5IHaLJpisj
        oqJGW1nI1ooiOiH+CB4VxtSrsxRY0hvVAqg5gXQd17UX2uliOsdAH1mvY0dRFjm0
        6bgE6LMDWukYyvxQG0wPCUmG/Suxo0uGWqYOuBltDk0atfHVxu+F8pZP/2vvX1VZ
        EApgmDur/SHMB8chtK1ouPfVYC6HmEtNZdgU4FeY40TMQEDYIhiDHsHwvpBWZLew
        ==
X-ME-Sender: <xms:EHqhX02xkWwGQJvk62zF9c_LQVnP8F-sTYPKWsKsVnEUCm0FYFzuGA>
    <xme:EHqhX_HHRaDMzSQzeZo20w3kG-0d9tpJIvERpPXDTH218lACy-tUxF51jtugeQJU2
    DNwQiafRvN-KQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EHqhX87_5DYxL8BoOjlc_BUQ8qJEncPqY68V-9QWB5rpk8I45ApdHg>
    <xmx:EHqhX91qH9jt_oF1OwqpEKI7pxpupT9Ij8A4ICStA68MglWFcFf0fQ>
    <xmx:EHqhX3HSYqV7l_gEa0d5MxC5jrUv_QCLHZwHD74iX_2MZloSnCEpFQ>
    <xmx:EHqhX6MIeWEOB6hmHyYUr7rTuASNDNGJcJb2gvNXhGD--0WIsSYBlslPKU8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43572328005D;
        Tue,  3 Nov 2020 10:41:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] rtc: rx8010: don't modify the global rtc ops" failed to apply to 4.9-stable tree
To:     bgolaszewski@baylibre.com, alexandre.belloni@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:41:49 +0100
Message-ID: <1604418109208158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

