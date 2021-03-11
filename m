Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4AB337C36
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCKSNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:13:11 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:49575 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCKSNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:13:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EB9511B71;
        Thu, 11 Mar 2021 13:13:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/XjKps
        RsOe3dSR2TLLmB+yyiD+SYvKYy0pQTDf/ynIA=; b=XH1B5C5l0Cv6044r0/Dueb
        4puBQzMVi9KGE2gk41yYMbPNHkCm2mPTvcE3D7FdM2+tiRN7CNFsdhXuPx4BMSnd
        rcry6Pu+Le3BKperttLyeeuwAIst4LaXJok4zqJDkjnyX6c15k2naXgPO/xwY3KS
        ZSnxWWtsUkYqK7Dft3uyug785nkKUuirr7fGpH3irbEt4mpgBqQx36JXAiFztgcW
        ZrOoTWraIUOc1OUmchgH4aPbe3y3gWRmBMdtKN4JilVtIB+W8us/kmr9WgMZNPMx
        Y/arGWDh1N5hZRy4CdvWANz1ib7fhtVwAUOj9Ayk4ypaoQVh8/5hR4Eoa77GdGtw
        ==
X-ME-Sender: <xms:s11KYLhRmYHGuW9vZuaEaYHnf2uDXCADx8gL18qC3oqg2-ujCq5OIA>
    <xme:s11KYIA3SRvBGoVy9-Bb-f6ljOODIF4JBUF0NvEhyCs5zRsnaFCmQcX0vQi9P2Clv
    EGppyOvQRJugg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:s11KYLH5aYcYNrKZR_jsd-Rws83xTBx3C8gAMLGXcrUcuGgf95U8mg>
    <xmx:s11KYITCg9BfH74-ww2BLvQjJc64MEav7zajEBFK7gTD_hQbWx37Wg>
    <xmx:s11KYIwu0C7xxziU6bgbubAMunCEgiJEdvaHgFMSI3phZW0Bj-D4yg>
    <xmx:s11KYFoaN-tjTHcQDiXLLbKr-ducwFH_51ZfGM6fv4UNT7cZ9PvFTYZM-Xk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23DE4240065;
        Thu, 11 Mar 2021 13:13:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.10-stable tree
To:     andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:12:55 +0100
Message-ID: <161548637597119@kroah.com>
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

From 62d5247d239d4b48762192a251c647d7c997616a Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 Feb 2021 18:33:18 +0200
Subject: [PATCH] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk

On some systems the ACPI tables has wrong pin number and instead of
having a relative one it provides an absolute one in the global GPIO
number space.

Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk to cope with such cases.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 86efa2d9bf7f..0fa0127d50ec 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -677,6 +677,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 	if (!lookup->desc) {
 		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
 		bool gpioint = agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
+		struct gpio_desc *desc;
 		u16 pin_index;
 
 		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ONLY_GPIOIO && gpioint)
@@ -689,8 +690,12 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 		if (pin_index >= agpio->pin_table_length)
 			return 1;
 
-		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
+		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER)
+			desc = gpio_to_desc(agpio->pin_table[pin_index]);
+		else
+			desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
 					      agpio->pin_table[pin_index]);
+		lookup->desc = desc;
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.debounce = agpio->debounce_timeout;
 		lookup->info.gpioint = gpioint;
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index ef49307611d2..c73b25bc9213 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -674,6 +674,8 @@ struct acpi_gpio_mapping {
  * get GpioIo type explicitly, this quirk may be used.
  */
 #define ACPI_GPIO_QUIRK_ONLY_GPIOIO		BIT(1)
+/* Use given pin as an absolute GPIO number in the system */
+#define ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER		BIT(2)
 
 	unsigned int quirks;
 };

