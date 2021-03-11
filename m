Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9C337CAA
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCKS2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:28:23 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39837 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229938AbhCKS2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:28:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 41D391C09;
        Thu, 11 Mar 2021 13:28:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JUi5tm
        i0OtNztMtWHzISc/fv7CQPSllf0c38O3yrEZE=; b=IPY2aZCYYfZ59tEGmgxP6E
        pCG+Ek9rD72QAkyQredXHAMJ6JfnOwaOlMb6ntFlvUIz1UPJvV3YAzwT8HAdd1pM
        gHXXLdelmsw+NdzocCpPZdugq6KhjecIAcNfZIwQ89hZFTM8X2lNsaHHSfLS0J8G
        uTXabrdEf7SHJnm3RvWLC2xwSpFDV8dE8Q0jbgSmHTWSudGnBpw7hMkML6OXyhdC
        gyOmG8Gr9nZDqFYqo1QzyxMLhw/qoJQv7AM6F4i//7eHC9C3j1C+78kaoo61NKQt
        9jqK77ZcQI1Bcb7400tU0YhalaGNnfxCsGHMNr8rP3G4ej7k9BCwwujdpUuHri6Q
        ==
X-ME-Sender: <xms:PWFKYJI6kbkzwL8aCeKWAuftxB6YKG6R-UIQu59fjhNSmdwcdxH_0g>
    <xme:PWFKYFI4A2BJ_1xz326JKVv8BZSTbyPM0tzbrAsRCxxlGYJKcItNUoi-JwdOGnr6O
    xPsdq_L0I_8Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefgge
    dvuedufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:PWFKYBv_8MStFSo5t-GHu9bLu7xaqCYIejK1bO6TsLYW0_u17UeKAQ>
    <xmx:PWFKYKZMljsPh6kD912h_wMHlkCKGtoPcd6dk0_g4bfZteDelpIlmw>
    <xmx:PWFKYAaLJ0FoHhaqHXMMaD5cRj7mdUllngslSOVm_w6BPqvgDfstkQ>
    <xmx:PWFKYLwGUFEsUQDmZZHUEWe_Stn1YRaC5AYgHiOdQf6ATWArA4GNcgT4K_g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2385E108005F;
        Thu, 11 Mar 2021 13:28:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2" failed to apply to 5.10-stable tree
To:     andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:28:11 +0100
Message-ID: <161548729112453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From eb441337c7147514ab45036cadf09c3a71e4ce31 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 Feb 2021 18:33:20 +0200
Subject: [PATCH] gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The commit 0ea683931adb ("gpio: dwapb: Convert driver to using the
GPIO-lib-based IRQ-chip") indeliberately made a regression on how
IRQ line from GPIO I²C expander is handled. I.e. it reveals that
the quirk for Intel Galileo Gen 2 misses the part of setting IRQ type
which previously was predefined by gpio-dwapb driver. Now, we have to
reorganize the approach to call necessary parts, which can be done via
ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk.

Without this fix and with above mentioned change the kernel hangs
on the first IRQ event with:

    gpio gpiochip3: Persistence not supported for GPIO 1
    irq 32, desc: 62f8fb50, depth: 0, count: 0, unhandled: 0
    ->handle_irq():  41c7b0ab, handle_bad_irq+0x0/0x40
    ->irq_data.chip(): e03f1e72, 0xc2539218
    ->action(): 0ecc7e6f
    ->action->handler(): 8a3db21e, irq_default_primary_handler+0x0/0x10
       IRQ_NOPROBE set
    unexpected IRQ trap at vector 20

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 5ea09fd01544..c91d05651596 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -113,8 +113,29 @@ MODULE_DEVICE_TABLE(i2c, pca953x_id);
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 
 #include <linux/dmi.h>
-#include <linux/gpio.h>
-#include <linux/list.h>
+
+static const struct acpi_gpio_params pca953x_irq_gpios = { 0, 0, true };
+
+static const struct acpi_gpio_mapping pca953x_acpi_irq_gpios[] = {
+	{ "irq-gpios", &pca953x_irq_gpios, 1, ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
+	{ }
+};
+
+static int pca953x_acpi_get_irq(struct device *dev)
+{
+	int ret;
+
+	ret = devm_acpi_dev_add_driver_gpios(dev, pca953x_acpi_irq_gpios);
+	if (ret)
+		dev_warn(dev, "can't add GPIO ACPI mapping\n");
+
+	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0);
+	if (ret < 0)
+		return ret;
+
+	dev_info(dev, "ACPI interrupt quirk (IRQ %d)\n", ret);
+	return ret;
+}
 
 static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
 	{
@@ -133,59 +154,6 @@ static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
 	},
 	{}
 };
-
-#ifdef CONFIG_ACPI
-static int pca953x_acpi_get_pin(struct acpi_resource *ares, void *data)
-{
-	struct acpi_resource_gpio *agpio;
-	int *pin = data;
-
-	if (acpi_gpio_get_irq_resource(ares, &agpio))
-		*pin = agpio->pin_table[0];
-	return 1;
-}
-
-static int pca953x_acpi_find_pin(struct device *dev)
-{
-	struct acpi_device *adev = ACPI_COMPANION(dev);
-	int pin = -ENOENT, ret;
-	LIST_HEAD(r);
-
-	ret = acpi_dev_get_resources(adev, &r, pca953x_acpi_get_pin, &pin);
-	acpi_dev_free_resource_list(&r);
-	if (ret < 0)
-		return ret;
-
-	return pin;
-}
-#else
-static inline int pca953x_acpi_find_pin(struct device *dev) { return -ENXIO; }
-#endif
-
-static int pca953x_acpi_get_irq(struct device *dev)
-{
-	int pin, ret;
-
-	pin = pca953x_acpi_find_pin(dev);
-	if (pin < 0)
-		return pin;
-
-	dev_info(dev, "Applying ACPI interrupt quirk (GPIO %d)\n", pin);
-
-	if (!gpio_is_valid(pin))
-		return -EINVAL;
-
-	ret = gpio_request(pin, "pca953x interrupt");
-	if (ret)
-		return ret;
-
-	ret = gpio_to_irq(pin);
-
-	/* When pin is used as an IRQ, no need to keep it requested */
-	gpio_free(pin);
-
-	return ret;
-}
 #endif
 
 static const struct acpi_device_id pca953x_acpi_ids[] = {

