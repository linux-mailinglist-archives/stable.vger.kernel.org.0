Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB9337B29
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhCKRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:41:57 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48327 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhCKRlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:41:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6346D1940BE4;
        Thu, 11 Mar 2021 12:41:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:41:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VOIt/x
        cPGTjSAWOL98tBCF4YIMsCQPP5Iwh+KMFKFcg=; b=jlrQVNG2qQMQFqS8arICDH
        7FtZjZBDDKAg9TonCs0bhPptJVCcJZS1Km011Lh2rLr0Oll7XLNjVU5Gxd2v+0HA
        d/1tUB0vp+C1fsnjUp221eSqtSZpz+Qkntwj47jF+/npti/sH8pz6ySa2B97gOn1
        KaSh/8OERna9mb3PKzORzVAzbQkjgaW6I8neUg/MwtCsuFTSRIs1B2BIyLhanXhF
        b9ezUTGhLa77hOGbTotBnhBjO2MByWr5mCXViUFcKFq0jL0aG/XtqpEyuHJ5M2HA
        05Hm7jy4GucogDFXSe4yIacncp+X3eH8sa0gKIvuxCSAVZqxeljZZ/F9ReEnDE4g
        ==
X-ME-Sender: <xms:YVZKYEieY_FQbKQ2o6ZNFcdT9vAmHUyHZfBwCwguz0eH4bPfvfUugg>
    <xme:YVZKYNAw9elZhoGEjLZiZSeUCDcRTeZoypX22wy3bZIfu-FU3W0u4PfyemNcveVnV
    8DVMOCwPXQ6uA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YVZKYMEAYT4xjax2fFMEcZEanJaGMTHQH5qSHWYIl3HeOebFdYy_yg>
    <xmx:YVZKYFQkygqPkHEYJyWS04nrjYjf-1vQrqvFhbYV9Eu4nzKBJgYg0w>
    <xmx:YVZKYBy0aMYc0OBH61763RRmwHC5p8pMUCIkmHEZfUzMDhNZK8LeDw>
    <xmx:YVZKYCrmGXh6KY8sKrG5xUr9VaguzJQ58atVFNy6LgMzNSw_Fk1asg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1177024005A;
        Thu, 11 Mar 2021 12:41:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.10-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:41:40 +0100
Message-ID: <1615484500158218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

