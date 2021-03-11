Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9103A337C4C
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCKSR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:27 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38413 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhCKSRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:00 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 955191C02;
        Thu, 11 Mar 2021 13:16:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zlRncg
        uTo80EUp4f9yhPd0R7Ve1+j/XSbf2iUFvaQK8=; b=OQg8FJymkLO2OjTyFr9MCE
        lqc8eTKKmPfHjpGwpytxtWPKSmHMDZyfDVavv5PoWprXBRii8lCl6CNczsqR3I4G
        r+KqCIjbw6OBqZgQLBedE5MHAMzK9RrTRjMQo1RvPJW3SlPHLW9gPTrdd10TSPDT
        o8CZVWDNTuzdmw35YtIHIy07F/fztZxIhE3Yj19zv9mJaMVUbxNY0HoEaQ8Y60tM
        CZZ0uf2JAVJraH6r4uoUkz0UZ4JQAenBAKDXwZj1DjXpbAAahi3sj1YDYhGhBSx9
        QuFjuwQ9YWHFEkjvGi7Xcsox0+jAvEDZ1G16PpPemV6JlztBVtLMnYQCvJRokdXw
        ==
X-ME-Sender: <xms:mV5KYBKoABgCIlC0rXRGjx8AC3GAMPUeGjM-8066gWXcId0qR_X4wg>
    <xme:mV5KYNLX1aMuZzfWjB0tICMAgornFMFjuBt8zzJ8nd37T_QDpmsXifZazdYCNZr1O
    oQGb7n3qPcLSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ml5KYJvo6-ra7iuJhVotyljczOIDRerrMJGibqxlqjTRGxHKE5C45w>
    <xmx:ml5KYCa4NBeHznqzfFHBaxA_GN8fGfJkutrG0xHQk7q7MOMVtZDd1A>
    <xmx:ml5KYIZQMDI3kxiJmxvFY9-4rM_BPJI-OuS-al0C1YI4ZwakUcl38Q>
    <xmx:m15KYDxiAA9al2tEwVHg740W4iKq55VP2TCEZ39ZiPugFG3DnPyCktmAI1M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 906C7108005C;
        Thu, 11 Mar 2021 13:16:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.11-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:16:55 +0100
Message-ID: <161548661510059@kroah.com>
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

