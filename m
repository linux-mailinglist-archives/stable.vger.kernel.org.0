Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5466E337B24
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:41:57 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35093 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhCKRlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:41:52 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1168C1940EA5;
        Thu, 11 Mar 2021 12:41:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 11 Mar 2021 12:41:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oKMRQS
        tvFCGQXPPxWmG2DfQuwg3xI78tRWweOd68/Rw=; b=arobDZkufmDIO1Nj0fpOlI
        oNid9AHk/LgKWUOsWzqMC+hc42ljqXkSW6bFmJmgsi8TCYZoB9jwf1PUcd7MeiND
        4fYTpQU1CMP0heMLozNJ4i4PTbNbwcu0qQunCdDZWZtkp56Akd63RZSvRRLsd2Qm
        8ZIgrNaTiHYmvqZ1TaQKP3PFS4GVFbV8ZTxZYbenpTqDd1vbT712NC5aXkcMFJ0w
        n8xGkeJiPDl6f6+fqlSP4aQ3+JwV0UJ0nOJNSt/NBmwkH2ZQdFreysyqchBrXfsx
        zb+nPzsKTkpLhBIq0QMATrpKCsM0ClLqhCMv7Xtm+dfbJbkhBKahN38KX2MjOVnQ
        ==
X-ME-Sender: <xms:X1ZKYAVpRbAhKo2NcBX02lIfM8-xeRHBb2tvDCc0WhW8Su3B7g_khQ>
    <xme:X1ZKYBcKohfkwdx7wJBCZLfKD2BZhXx6xoqXheK53pUYNWK_MbNw0xeIb2KqKybHZ
    JP0mey6esB98Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:X1ZKYEKrz_GeEXVJdaKfMWlmxRJ6HCh9YR5xtMQcou9gWCLUd65NFg>
    <xmx:X1ZKYOxmoSc00RKTxapAUrhNc7Q1zXCR8rbqiViQlzLHBkFUGhcFGw>
    <xmx:X1ZKYKuQYn2j-1kbZTrlITeGt_qYJBDwth3l1svunsRoBjHPfRED6g>
    <xmx:YFZKYBHjhXGfiFgDNHOx8EfTTKjTy2sHlFVna77_0Pz9l2agQ9gs7w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 682B1108005F;
        Thu, 11 Mar 2021 12:41:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.4-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:41:40 +0100
Message-ID: <161548450011383@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

