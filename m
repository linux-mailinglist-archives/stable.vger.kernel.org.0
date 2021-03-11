Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C973337C4B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCKSR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:27 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52735 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhCKSRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8D1C51C05;
        Thu, 11 Mar 2021 13:17:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:17:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VOIt/x
        cPGTjSAWOL98tBCF4YIMsCQPP5Iwh+KMFKFcg=; b=YxhMb+boHi6m6ozWTvxP+v
        75IurNymjp73fMITIoDZvFq//yTGPiHQT64J5mND8ie098MG09qd/TpxbSSQX7yU
        ypidK2ZL3fOcn0MNnH0je7G0NsQdfznSnmzL5JzT4Z0FQfAJSXSN2u4ZqUf8ERH9
        xnlDnGJzbEMzyPGlzydDBwUfKsuAvUUMv1EpHfdTNhUX1g86RKByn8MU/k9wPwkx
        KxPCMJvDhpYlK/3uMBM4av4skH79Zl65HxFSydeVV6/94Lz61A4dL2a+SSiMWpfV
        aZRba3lMJ1MnX48A5u34oR+UKrIpK3oHxqS8B2CqzD2hEFOgyqQlgQyJGz7KwY5Q
        ==
X-ME-Sender: <xms:nV5KYMNkDtu3clwZYZp35i5sehT9mb2cU3C37LWClqQl9qz1zOv0jQ>
    <xme:nV5KYC81Ynn3_x_-C16eor1GgRBTtie2djB_Qn8HLd39AA-LOMBy7qI9fLjfPIB5M
    FIQRQyC-dOdlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:nV5KYDQ3TasiJUPxAKlc3e_pfHKkRWbBgGAWZkLB8UoZw7UBGkEatQ>
    <xmx:nV5KYEulTJCi9cxEgdRkczMNg9nlUSmRW_8I3Wv8vHbAJvchePIxwg>
    <xmx:nV5KYEeHi_QYnk4sHzrUUgGZuYMqnyFXV39W-hgSvbFV0ejmPgw2Ug>
    <xmx:nV5KYAHvuMhbt54yweHMOHZNrWVME3qXk3ddnsmihyhld1oaWPXPHCxphxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF11F240054;
        Thu, 11 Mar 2021 13:17:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.10-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:16:57 +0100
Message-ID: <161548661710833@kroah.com>
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

