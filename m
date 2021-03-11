Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F68337C33
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCKSNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:13:10 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41113 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhCKSM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:12:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7B4801B90;
        Thu, 11 Mar 2021 13:12:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:12:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VlcNbU
        tSzvSzgOFsaSpWoL7UvFUVXFjxqSzW7yyJK7s=; b=FKpAPcgV51VzUH+7Qre7ot
        2Zgh7F2lfH6Lo+q261YRWKsg4y16yG/gUHVWDhPrlst8TzjjKMki+54p5pzXncZ0
        fFadk7OFBRQe9YZm0IPSx0G6aOPyIpPLUYZMcnTLWQInUMKW3r9JuEF53ic03KxE
        oLFB2oMJoNAeCPKqa2fvqbuQ3jbW2+2mHOY9sqaPABjDS4prZwRAjIhM+uO0Qm4e
        C/uJMMNuFWSmjcNEerozIWsuJvzOnc+06FnNsyxxg1mjCp8EDzA2C+2lH0XweeHU
        DreF/WZlqJS5kKOGD3+S1JvGnEksSlVUOoL7zQ/7KbHhWNBqtnc3AK9PAFlCidCg
        ==
X-ME-Sender: <xms:qV1KYNPMPJNShF_Xa9QiUTdpP5SNZjEVcsjqk9a0RVYQaDjx85sfgg>
    <xme:qV1KYP_jYmXY2PSj8z84kzGsLq9mCnHXsSK9YunNTEmEAcYq3mUxKcbxQaQKw4akL
    QusRpYaOzaG7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:qV1KYMSFZkwqSktsgzlpT7No-dDbneYGHdV6I08nZrNJpN3ucmEVDw>
    <xmx:qV1KYJt4aDFZlORtRn4g979tWZmMUALBTyLKA2WfSqqXm73IayE-2A>
    <xmx:qV1KYFdg_rrpJhODHryHMzely5bIPZmrSNEVmsn1Xj0h50lS6fMRDg>
    <xmx:ql1KYFHcHRBxstUbWQEX9GN8y0MRf9mHrEy6s1_Zug8SzKnmojeumy3W8js>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 423441080054;
        Thu, 11 Mar 2021 13:12:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.4-stable tree
To:     andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:12:55 +0100
Message-ID: <16154863759340@kroah.com>
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

