Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FB337B21
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCKRl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:41:56 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47459 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229632AbhCKRln (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:41:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BA92A1940233;
        Thu, 11 Mar 2021 12:41:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I4uKfr
        fZU/mf1RGaZjdb1EPUNt0ZbvOrrlQ9pqIzFdg=; b=sCphWh3LkTDY/CNjdvmhS3
        fICD2ZOP1L65wgJv81LyPovThb1EAOBIA6EhfTebEVyYU6lqWxWIdQ0EH+1GGGlU
        A1Ria+mWNUyHiFhLT3bfxkUZCaE5+I7AkihS3J0o3AF6ASR43bS70prlrFicnupF
        +bvTQ1UbosTiezsfMcvouNn9TFL5FJXUrx9mx5m2Y/gwu+wNWO24NppaxOHQZiHG
        YnBlc4Jvdb3ZCtCu7A6y//sbpeH+bnSig22NaneXsn/GCw8bNPd9UxVDlC3UCBy2
        dJKg7ybw2B5xVhwUt5u8CHUEi3LBbR6JMynogBeEzJiydZO98zJl06eAJrhNELew
        ==
X-ME-Sender: <xms:VVZKYO6wKMywhOzTMg4ii4QdnOYhSQZ12Z0jUSlicCuJjRkMEp3RYQ>
    <xme:VVZKYH5Fp0OoSv7XN9fWpqEb58EF39-W9HNUUJdcXlyHS0YiSpakw2zJldCUQl9Bh
    u6DWHjWxGJIlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:VVZKYNciMGJV7NIiirPYU388FD3fZ4SMfMVfA7GnveyLPWnf5HhL5w>
    <xmx:VVZKYLJr4-ItjpBqtYBnxLGLQ7ds6CNA3ZKRPnJlH9LnYxm3i37XvQ>
    <xmx:VVZKYCKL8s0KK98OjjcQhn4OEXO5NcBiSm3ImQ0i4UkBPSGzVFnUfA>
    <xmx:VlZKYEh7RbmOReueWKGUZFKziAvMxpo4WhPw_2L8m9Mb0jtEHds3HQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB45F108005C;
        Thu, 11 Mar 2021 12:41:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 4.9-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:41:39 +0100
Message-ID: <161548449925127@kroah.com>
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

From cf25ef6b631c6fc6c0435fc91eba8734cca20511 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 1 Mar 2021 10:05:19 +0100
Subject: [PATCH] gpio: fix gpio-device list corruption

Make sure to hold the gpio_lock when removing the gpio device from the
gpio_devices list (when dropping the last reference) to avoid corrupting
the list when there are concurrent accesses.

Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
Cc: stable@vger.kernel.org      # 4.6
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6e0572515d02..4253837f870b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
 static void gpiodevice_release(struct device *dev)
 {
 	struct gpio_device *gdev = container_of(dev, struct gpio_device, dev);
+	unsigned long flags;
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
 	ida_free(&gpio_ida, gdev->id);
 	kfree_const(gdev->label);
 	kfree(gdev->descs);

