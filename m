Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91863337C50
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCKSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:28 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45133 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhCKSRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 135011C18;
        Thu, 11 Mar 2021 13:17:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:17:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nAhP77
        Zz/ucw6B0VdBYplJVl8/NSgvM07zvLVdY89AA=; b=jpFzHWTVuLsrBYNkJqcxBA
        TAjJbj0f8JmK1pZV3lBeqvqCL0vIfRTiRk8CFKUZBDGuGd1z4Wrxw192L7/R5XYM
        QO3VZZ32xWx2SKGr5QSkwt70ZpG+idLlDH19LqLxRjXsfN9+NVy6vgzqfgk8QpqK
        1wxaac/fu581uYoxEagyh2b7w3B2uV4vxRgW8lZaz53fnntnzorFm9nH4IOW5WO1
        RYKjlODY/D11ZQpe9d5sX/T7G6e/MvfWMo4Gz9uIEdp8TpTl3Nh0XoCk2igBM+/C
        K/egKX161suEdGXvqlAWvTLzVDfQmdZ63VXMkE9blTUVLVtK0mAuQicf2KOYWaJg
        ==
X-ME-Sender: <xms:ol5KYE_1sSoOQ0YFMbKbWqtS3yOKwYh9OPxrYK2eLR9qvh0Jteatgg>
    <xme:ol5KYBBYllRfIQWrzjTSJwT1dvxGL0vTf8ugEwwEzZ8pZ9V1av7VVZFjQAU3bJ0Dx
    bTURXS0daG6qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ol5KYJKRdgEfHvVQUKi17wXfcXotdPV11u17fSpCZ7H95DAw4v-fUw>
    <xmx:ol5KYMker6Z0Sc02Exfh7N-o-y0vuztX-QN1L7-2lPuNbPXFq7w-YQ>
    <xmx:ol5KYPG5AjKUweM5bupcK-9S0JEuCA3B3PYLN7mHlIVmP1nMrTASjQ>
    <xmx:ol5KYGnAg-tIY0ReJd2DSyrL8yDFrCtOUBvTn3uFppIEy4LXhv3IkQUpX18>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6670D24005D;
        Thu, 11 Mar 2021 13:17:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 4.19-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:16:59 +0100
Message-ID: <161548661918326@kroah.com>
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

