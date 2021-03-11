Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23539337B26
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCKRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:41:57 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52101 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhCKRlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:41:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 02DD91940F21;
        Thu, 11 Mar 2021 12:41:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nAhP77
        Zz/ucw6B0VdBYplJVl8/NSgvM07zvLVdY89AA=; b=S9fRNT4eiBO7GZh/7VBp6F
        YIuxkFCUu8Owb2FzoLi8d6ePnJCpcnCijgpmFjSDepjs8w1vZnztKF0OJaz9jtbM
        wiZKMc7yLXU1qAVPqsZDRfisOgEHUwFfQNb+PFWr+NCb0lAtIyLYvmc+HmLMkv29
        4opovtgr2keSzskade5DiNIJygQnYJl6vn6G7KJM6M24PsDHeHEW/QDqyo0xxCXZ
        KkfUz+ARYK6AIjfXw254dy3eJ7LpK790e+dE+8d9ZCCasKyyxlb2yZQ4ZJ++XN0F
        QKhekvdhwgcz54l3LjsEs6xctb6OR2O706xXq4XpOOfIY5DnrkpYnzuarP7q4y1w
        ==
X-ME-Sender: <xms:YlZKYAN1fMwJo-PxzgIrsJPDSc34s5xeE1A0CfGxmxVCQPZOWzIOEA>
    <xme:YlZKYG-g2KIT5MmweMwBehOFidB359Rp4CFkGTx8rb-k_oJSqhcb5c_RPuJ76DmSY
    H6EM_RJvIeSkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YlZKYHRhFBafd9pONSqmyx0LqF6n-D1kY99DF-kkudGla_eprKY_Gg>
    <xmx:YlZKYIsiD2ov1MwIoM7cG36RXilxd7sOGZh3lDgP8AkTVZX5WYrTZQ>
    <xmx:YlZKYIdb4l9FSkVUb8XxnUCj8xI3rfQELwzmGiFwc8_pAT4RxPQA0w>
    <xmx:Y1ZKYEHU1YBqqtKCRFCz6uH7swJfxU6p7JOAZnxQCD6gW97V0eJlxA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D8221080054;
        Thu, 11 Mar 2021 12:41:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 4.19-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:41:40 +0100
Message-ID: <1615484500066@kroah.com>
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

