Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE234337C4D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCKSR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:29 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34427 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229674AbhCKSRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4DA011C0B;
        Thu, 11 Mar 2021 13:17:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I4uKfr
        fZU/mf1RGaZjdb1EPUNt0ZbvOrrlQ9pqIzFdg=; b=XB1ihOSOnt9+d3bGv2PMCf
        rxOr9gCq+AI9k4Ix5nt1zsyJrfmbidqTVGlH4VWDu74uXiUlnkeUWh9dfafozupy
        hIzcAgNIEjZRhte90IMq2NzUuoFfWKmdklfjxG/cNleh1TGgm6WK8Uv9YnHi77af
        21MCk11Tnb3QZZZTxpHMoUIIkiMcyL42hrBB3OANuzJ2ACzriopkwSmZ2joDWnZa
        MKWMUCVvWI+cYMwgNP/OhNHKl3jXOgUryf/MzXlIS8PBvq2E+i7GZgcyh/VBdS/X
        fH/m1ghZ1KW85DjxUCNYA3BIX0v1Tm5S8FuajSC8Sq7cJKOovSn7HWRdguiWNeiw
        ==
X-ME-Sender: <xms:pV5KYEBXlsdmeyiR58e5PT-UhgIJvQQQcbndNiytOaCoDrZFSYo6sQ>
    <xme:pV5KYGjCXES2ZvBslLzFBFco8NLLL8LSCAz2jTFYOovKkTJVL5UqGQKw5tenMcnOR
    2SiW83Im0CPJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:pV5KYHmOaNHVwH9zQ7u0_mV3BPxIXoIlmV9jdfg2-HLqmxs9twRwWw>
    <xmx:pV5KYKzL9KMs871ij9NfzjCiBq1LPSfzi14ZGYFkubvnaYc5um3-fA>
    <xmx:pV5KYJQEC-Va-jgUBv5k0aHZa-5EFIpZzy-MEYBpC4JBicwo4Z6JXA>
    <xmx:pV5KYIIgQYxUlODg-Bmg5181aXzPG_bN5M2DWwnxObfHBWwKRh5up7PzzBc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 98EE924005D;
        Thu, 11 Mar 2021 13:17:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 4.9-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:17:02 +0100
Message-ID: <1615486622668@kroah.com>
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

