Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4069849BC5C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiAYTm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiAYTmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:39 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3780AC06173B;
        Tue, 25 Jan 2022 11:42:39 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 133so19154079pgb.0;
        Tue, 25 Jan 2022 11:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/khXbDZHB903lyF75ChxyVG7aO9Sd0AWOKns64QBkow=;
        b=QK3JpG+rFIyG0q98TAtuuizI1sCbgM0gzYnBXEH4FZoGbY/XoIQ6Y5bHvAPtfwRyJH
         +hCVof1nkcnpeaLZR9mvt5wqyTUTEBLb+No+Wi2kiJkS6rsvh0rwwyO9rs0G2j5Ok/l5
         pkc4rxCBAQ9L+lvwZbPeWpiLW6lQ1/0bjOCjwJ/3qDCmCZlw2bSFhZvIFFbJF9e51iu9
         7Ef1v+rRfJcvREvE1Kz4hQeI7r10NO6cAqe+gwDkhEChnWxfjXJ7swePqlWXwFo9Pnti
         1zXXozK6yNS8w8/9hJil63Rj24cJUCpCULxyVdGJvLq5Stu5nG3Jc2A/gPJVfd/w81Gu
         Qm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/khXbDZHB903lyF75ChxyVG7aO9Sd0AWOKns64QBkow=;
        b=M8NWy+REXBwoFmYjVd0MCf2CWTHMW1CmBMx2hJOS0Wbuqx2Qp8ySOGVeaTqRaomBzT
         ogyT0gD3EG9A5JVz7m/i9cHFuJ5U86+JTVDkPiyop2B0PFhlggBzpnDeBy4leW7hdC6l
         ixhvgeE7HlXFI4HMGPguzLVgrKsxWsAj4j5/OcrBv0g2VZCnIfjt3HVJ1/sTf4Rm8pRo
         dxG3CI1bJTfZm5DVc/c5Ejoq6bwA4fnbj8gwtpnXbVJNHJnleA149TcjQWQmdQzlDv0j
         ZJ5UFbxWuVkZNKWW1NXpqFlfxp/9MW2reH0e9WpkwgtnhePvwsLN98C+BsFYEDynyEo7
         alRg==
X-Gm-Message-State: AOAM530BHLj6l9uoLxXrvN+1pKZbi+xPGYkghS2nzo6J8ycHIbVrOxbj
        5cj+EYOO1V+iAzTUNLhmLWetzWQEbnw=
X-Google-Smtp-Source: ABdhPJxIS4IZAaUWIo7Tzhth7/fpBFqVOPVfTpo4lJ3F0h+dyi/yqdeVFb6nyaYWtgSt5JHA4Pn/iA==
X-Received: by 2002:a63:f452:: with SMTP id p18mr16354782pgk.545.1643139758349;
        Tue, 25 Jan 2022 11:42:38 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Phil Elwell <phil@raspberrypi.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 5/7] pinctrl: bcm2835: Add support for wake-up interrupts
Date:   Tue, 25 Jan 2022 11:42:20 -0800
Message-Id: <20220125194222.12783-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 920fecc1aa4591da27ef9dcb338fc5da86b404d7 upstream

Leverage the IRQCHIP_MASK_ON_SUSPEND flag in order to avoid having to
specifically treat the GPIO interrupts during suspend and resume, and
simply implement an irq_set_wake() callback that is responsible for
enabling the parent wake-up interrupt as a wake-up interrupt.

To avoid allocating unnecessary resources for other chips, the wake-up
interrupts are only initialized if we have a brcm,bcm7211-gpio
compatibility string.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20200531001101.24945-5-f.fainelli@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 76 ++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index e763c680b9c2..436184ebd2ef 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/irqdesc.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/of_address.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -76,6 +77,7 @@
 struct bcm2835_pinctrl {
 	struct device *dev;
 	void __iomem *base;
+	int *wake_irq;
 
 	/* note: locking assumes each bank will have its own unsigned long */
 	unsigned long enabled_irq_map[BCM2835_NUM_BANKS];
@@ -432,6 +434,11 @@ static void bcm2835_gpio_irq_handler(struct irq_desc *desc)
 	chained_irq_exit(host_chip, desc);
 }
 
+static irqreturn_t bcm2835_gpio_wake_irq_handler(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
 static inline void __bcm2835_gpio_irq_config(struct bcm2835_pinctrl *pc,
 	unsigned reg, unsigned offset, bool enable)
 {
@@ -631,6 +638,34 @@ static void bcm2835_gpio_irq_ack(struct irq_data *data)
 	bcm2835_gpio_set_bit(pc, GPEDS0, gpio);
 }
 
+static int bcm2835_gpio_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(data);
+	struct bcm2835_pinctrl *pc = gpiochip_get_data(chip);
+	unsigned gpio = irqd_to_hwirq(data);
+	unsigned int irqgroup;
+	int ret = -EINVAL;
+
+	if (!pc->wake_irq)
+		return ret;
+
+	if (gpio <= 27)
+		irqgroup = 0;
+	else if (gpio >= 28 && gpio <= 45)
+		irqgroup = 1;
+	else if (gpio >= 46 && gpio <= 57)
+		irqgroup = 2;
+	else
+		return ret;
+
+	if (on)
+		ret = enable_irq_wake(pc->wake_irq[irqgroup]);
+	else
+		ret = disable_irq_wake(pc->wake_irq[irqgroup]);
+
+	return ret;
+}
+
 static struct irq_chip bcm2835_gpio_irq_chip = {
 	.name = MODULE_NAME,
 	.irq_enable = bcm2835_gpio_irq_enable,
@@ -639,6 +674,8 @@ static struct irq_chip bcm2835_gpio_irq_chip = {
 	.irq_ack = bcm2835_gpio_irq_ack,
 	.irq_mask = bcm2835_gpio_irq_disable,
 	.irq_unmask = bcm2835_gpio_irq_enable,
+	.irq_set_wake = bcm2835_gpio_irq_set_wake,
+	.flags = IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static int bcm2835_pctl_get_groups_count(struct pinctrl_dev *pctldev)
@@ -1151,6 +1188,7 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	struct resource iomem;
 	int err, i;
 	const struct of_device_id *match;
+	int is_7211 = 0;
 
 	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_pins) != BCM2711_NUM_GPIOS);
 	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_groups) != BCM2711_NUM_GPIOS);
@@ -1177,6 +1215,7 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	pdata = match->data;
+	is_7211 = of_device_is_compatible(np, "brcm,bcm7211-gpio");
 
 	pc->gpio_chip = *pdata->gpio_chip;
 	pc->gpio_chip.parent = dev;
@@ -1211,6 +1250,15 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 				     GFP_KERNEL);
 	if (!girq->parents)
 		return -ENOMEM;
+
+	if (is_7211) {
+		pc->wake_irq = devm_kcalloc(dev, BCM2835_NUM_IRQS,
+					    sizeof(*pc->wake_irq),
+					    GFP_KERNEL);
+		if (!pc->wake_irq)
+			return -ENOMEM;
+	}
+
 	/*
 	 * Use the same handler for all groups: this is necessary
 	 * since we use one gpiochip to cover all lines - the
@@ -1218,8 +1266,34 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	 * bank that was firing the IRQ and look up the per-group
 	 * and bank data.
 	 */
-	for (i = 0; i < BCM2835_NUM_IRQS; i++)
+	for (i = 0; i < BCM2835_NUM_IRQS; i++) {
+		int len;
+		char *name;
+
 		girq->parents[i] = irq_of_parse_and_map(np, i);
+		if (!is_7211)
+			continue;
+
+		/* Skip over the all banks interrupts */
+		pc->wake_irq[i] = irq_of_parse_and_map(np, i +
+						       BCM2835_NUM_IRQS + 1);
+
+		len = strlen(dev_name(pc->dev)) + 16;
+		name = devm_kzalloc(pc->dev, len, GFP_KERNEL);
+		if (!name)
+			return -ENOMEM;
+
+		snprintf(name, len, "%s:bank%d", dev_name(pc->dev), i);
+
+		/* These are optional interrupts */
+		err = devm_request_irq(dev, pc->wake_irq[i],
+				       bcm2835_gpio_wake_irq_handler,
+				       IRQF_SHARED, name, pc);
+		if (err)
+			dev_warn(dev, "unable to request wake IRQ %d\n",
+				 pc->wake_irq[i]);
+	}
+
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_level_irq;
 
-- 
2.25.1

