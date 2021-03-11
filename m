Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D97337C4A
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCKSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:17:28 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43099 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhCKSRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:17:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 278BC1C11;
        Thu, 11 Mar 2021 13:17:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oKMRQS
        tvFCGQXPPxWmG2DfQuwg3xI78tRWweOd68/Rw=; b=TvL8SN+WxSqLusyHXxB5kH
        7nY36fhIGVtIUQuNkmUgVm3ZsJYiq7hOTl3WCvWgkpkIyuxaPmdqF8qH1fCXEyPF
        DqraknX0NQwiGSWHqscis1skJY0f3OALSwyeTu0Cvk71kMmcCqw9TjO/vYHaaPmj
        6irEknEeilzhzkRB6qYUtFD+cdB0MRSlhsbGPbsVMsstkB67bbnKesxraI5lhM72
        +7EMjR+JofVErZzACbqBlVmuzvB74FaqRHgO6F4cpexsDd5puoByVhWuRNYFoO5Y
        XJZZAveVCWHYl2HLdccXLe41LkcEu+Y1+myueg02VuoS9gSmI2MA+zP3MPfqZHEg
        ==
X-ME-Sender: <xms:nl5KYCpbt2gRKx1vATESAu8Qc9FLJ19SLO_41t3JLcGXnVNSmTB_ng>
    <xme:nl5KYAqppxCbw33tvuWXsPILaOyUlrUYmYYj1O3J_DOyfZTakBcjA3cIw0Kywpjgz
    nkp5WJdgFCA0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:nl5KYHNN2jHM02w3HdfbtbWNK2Jw3fnYMm7Uq_yp_2iYirriaffOJQ>
    <xmx:nl5KYB64b8CBakNV129tXnNhHrcx2l-tIgCtXVvh5NWrDwGrxBSwuw>
    <xmx:nl5KYB4d6EpRasb5zyppxpdeyTkU9GvbG7l-R5mmEBuAWVL_gfHQXw>
    <xmx:nl5KYDRpbovL6_VGkIPoaexuUlNn52HVJL-GQu9P0yf2Atdl_LZuWoEPQy4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6582B1080054;
        Thu, 11 Mar 2021 13:17:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: fix gpio-device list corruption" failed to apply to 5.4-stable tree
To:     johan@kernel.org, bgolaszewski@baylibre.com, saravanak@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:16:58 +0100
Message-ID: <161548661812553@kroah.com>
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

