Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E24F338D0C
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhCLM1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:27:12 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35801 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhCLM1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:27:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id F13C71941398;
        Fri, 12 Mar 2021 07:27:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:27:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+5O6x5
        4FEQnjS+aFSKaVkhcJU28JWbWY0Hob4Dgd5nA=; b=bzPI4sZzigjteDJhHiMWz2
        I/sxVd68Qef9V9V4Rm+COScwDz4ntkJRGWP89dg0DW9BXejUldpAA4hLnIYaXuvq
        xoIjM33KwnqrrqTM6Ehw6WfcnSOmHHnNYz2aQdRyPhK4MVY9Wz0WD4uSA3WaBnk9
        /Va+K5A3mV71+U2Az3cNOmKWMn/H6dfyxn8D1M+6NaNGdGMPZDT0ZBiDXTHtIqo9
        7aa8aGrobEEnAQPWB5Kp/U448b42rA8OmyUgWXN+E2QaXo557bdLSADYZ/XLOknQ
        E0mjS+NslLuzyce0P2WiUqLeECugi0/3FXo/FR/rvDPL+Xy1sAEuY+3z8i/mRstQ
        ==
X-ME-Sender: <xms:HF5LYC8ko2t0HM2jT_16k90oIWupP3qQL4E5fzevcXWqSHv6BpOZHA>
    <xme:HF5LYCu-Qsww8Di33yUlRFvbL0QphTGvlxAlcUFo-xaSPFxOSVtb9-qFUYpy_QX5e
    vxZFcd1mIgKTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:HF5LYIDySYD4FWWkuYSk-JI1ilcUlSXGyAqyg9damodZqVW8TTWQDw>
    <xmx:HF5LYKesPuLdC7dhLLSGDt6kZD3QF8LO67KrC5WZcOC8LJ3nTF7l-w>
    <xmx:HF5LYHNRBdxy_uPeItF7DHSvP6TKpi6b0xq49ych7hP35dRlxiRHzw>
    <xmx:HF5LYN0Fyt89jiWpRI3JR8Vhj_IMyzJicMJJnwYwi_ZS6xNg7P17ig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 149F8108005C;
        Fri, 12 Mar 2021 07:27:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2" failed to apply to 5.4-stable tree
To:     andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:27:06 +0100
Message-ID: <1615552026254228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

