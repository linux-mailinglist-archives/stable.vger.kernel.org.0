Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A57337B2B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCKRm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:42:29 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47361 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhCKRl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:41:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0311D1940FEE;
        Thu, 11 Mar 2021 12:41:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zlRncg
        uTo80EUp4f9yhPd0R7Ve1+j/XSbf2iUFvaQK8=; b=sDWtL3jE8mq9cBAyYsgp/g
        GdluTu3y7xeVNzrNVKWgf6iCNOL/mxExS6RQ8/c4HQoTZ9//dp1sLGu9z/9hqX5g
        hxknXS0Q2wdPBg8/H1flPLp+YeidXJbOraYPJa9FulrbUWo8bW/2xLt6rt0TkPZx
        GZ0wJz0dIv61ilJiBKv+Riync1aT4KBh+7W7BxGbvn7butxrHteCltLKCpBYq/HS
        m1IZ+AP/VmNODYd0SMeCvU5z6z8nP41eg0yBqL0DMpXJeU+i2INj8xDBtWA7S9eO
        y3nTvdSeuw//QqZaZNIdq9+GLreOebT6XrawfMIlzNtNOZMq2cj+UPEScO8wPltQ
        ==
X-ME-Sender: <xms:ZFZKYIWZ0bkmE9akPP7-X5u2qmEOY4cEPB6pH4L5FShqzn9BNLEfPQ>
    <xme:ZFZKYMn3vZLp5YZpkOmfuTXD7HBj1YD0uVj4Wvh2nUzUClHLj4J1UONhcNF6iZktz
    UKw3BPBzsvL9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZFZKYMZuLdpEIAkq-k7NgArp8BmluBR1RbvUrggWexPZySs2GG_ulQ>
    <xmx:ZFZKYHV6Sc5maC9d2MEHTHAfUhEeC8npiVc9Ksvhprt-RltW0ZDk6g>
    <xmx:ZFZKYCkGbm-jBeb2gjdLSKzAFDJCtJUU2IJrtE6pH15gVO2ZNNvJRw>
    <xmx:ZVZKYGt_x7PlQhVVW8ywwAKckFqzmpPYW7_gIqBH4Ux_0rr73lvkFQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 999A324005A;
        Thu, 11 Mar 2021 12:41:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.11-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:41:41 +0100
Message-ID: <16154845012114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

