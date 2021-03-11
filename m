Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2B337C4F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCKSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:28 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50733 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhCKSRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B44991C1E;
        Thu, 11 Mar 2021 13:17:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z+KfG+
        UTtKcN/4SBw/P2r1GY+5S2KN5ejoSmW6CPlpw=; b=ByWfwDZSWXLg3o90yFJ3G2
        LweFL2RlhGp2AODVexGltpJqT/G6/R0uLU8CpJvcyLoKahSv12JAH2GAe7lT1OCW
        ar9xEsAHVh1O0Q34hRcGhamaUPl0NOowCFsrB8AcowIfqXgqdXGwIK0oaPqYeulF
        co3HnBgJCvS5ig/+oa5v4AO7Xzcg/2abUHzF1auSypK+vVM98XexkYWLKzqAXoac
        t+rDCSU0qY6u7Lf0Dfw8EB+0v4jb6zo9owjgOtYPkn9/o09eSmbicjVESt0VIrJw
        ne9cq3kNM9S+8Val4iDqF/i5WmiBVgKXuPfxcpbaOmTQ1Uwq9ENizUVaISV+KM1g
        ==
X-ME-Sender: <xms:pF5KYDvCAxernekRFs-QdHcHKS-YjQaEQawmWuuf-f5RaxhiNa6mvA>
    <xme:pF5KYEfRdK2VURIK3yKrC0roOyDRaChRxlWgFnIYXcRoX1tw2kM1AE7wT0q87ZOzW
    ixomoRyuUNSBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:pF5KYGw9l0UjZgtWRv0V02dbSX2lzb3q5vqALNQdcuB2mY5hU-dTuw>
    <xmx:pF5KYCObBw_WPkIn2GhUt5K0L6-eKs9QjNioe31kopszdzMhgvfRpw>
    <xmx:pF5KYD9EJtaZj52a0GLxMzS3mAwYtLDGlP_Z_BNq5cXaCVuPLkoJFw>
    <xmx:pF5KYNnHu-3F9eT291KvyyyLkN_uZsTGRo-c9kkIgy9Xs6sFsNovSgQI980>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B5E51080057;
        Thu, 11 Mar 2021 13:17:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 4.14-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:17:01 +0100
Message-ID: <161548662119119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

