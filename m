Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14B349BC56
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiAYTm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiAYTmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:33 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76225C06173B;
        Tue, 25 Jan 2022 11:42:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id e28so16270476pfj.5;
        Tue, 25 Jan 2022 11:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W2puOskk/Ji58wUW2ugwQLrVah690CBvN78hET2BpvA=;
        b=a8kFwxgCXgWpD3vGaYCER36Z1JEw+CeMm3Bsx+Sof03sENhaGKDUdsl/PQKv9HP9Ei
         pAR/i+zvJzuZwdb7G99pd4vNgP9rPgmAFEaIt5x/Q9+i8Cqye3ET5Gn9z8mnGFGta15m
         ln02Xnmcmjd4t7gXE6B7h854wR8B0T5L/i/SA5YQml3g1B2dhxzVY/1LSj/AJwaPA1tR
         Sn88oP++F/DuAl9SuRtBqAUxexFSSJud6mymeOmnfi5noV+h///FezG0mrMf7AnYgZKK
         8tF7gjCmlhjReUpcTmDA/rZwrQxQMGq5su/L715LT/7UdPzZZKgNTwhMMItG0658COUp
         CSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W2puOskk/Ji58wUW2ugwQLrVah690CBvN78hET2BpvA=;
        b=Y+w803Ob9qZ2r6QIU5stMaM5w+BhLTvTM4VZ2od/HJAqydkIqReGaDd39RkFnn9hyC
         OO9cFYfL5MQHMsdLKM9pIEaEtuGEdhmMk9J2y1ZAXPlQfvG3CiiQdyQaoZzx4/s3MpIi
         ezoM/lSt3SqG3TLHoAQCXDpOJATzeNkpDJPvL/2i4Y9IcQg6Nu9uAd3eKWMyAbUnHKSb
         OHFJuSvmIKxRjE2JzBrTy7xSo9CnWIX80WdOawnXgHgvEhbe4oJtB9hYUBLVcsyb/UDZ
         usrUfxxDFjFmAeirvvbj5nMr2vE0dt9I5gwz6df3ucPsihLebcM4MjY0emuRJMXTUOyS
         EmCQ==
X-Gm-Message-State: AOAM530o7upbEmvFk0WnYqEi5hTuL3o5fmql2U5pIjGYHqtKDK5ZO7s7
        Z4LxtROsqjh6Ikhy5IKUMMhvKk1MPM4=
X-Google-Smtp-Source: ABdhPJxuCccb995G/sYt3VUqX2rKr6UW4V5q7BJAN4GRBs7NmSNWNwG5GmpSODAZmXI7Py3w5qIYrw==
X-Received: by 2002:a05:6a00:2189:b0:4bc:3def:b662 with SMTP id h9-20020a056a00218900b004bc3defb662mr20078506pfi.5.1643139752644;
        Tue, 25 Jan 2022 11:42:32 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:32 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH stable 5.4 2/7] pinctrl: bcm2835: Refactor platform data
Date:   Tue, 25 Jan 2022 11:42:17 -0800
Message-Id: <20220125194222.12783-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit 90bfaf028d61a6d523c685b63c2bcc94eebb8057 upstream

This prepares the platform data to be easier to extend for more GPIOs.
Except of this there is no functional change.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1581166975-22949-3-git-send-email-stefan.wahren@i2se.com
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 57 +++++++++++++++++++++------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 3fc26389a573..7f0a9c647927 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -82,6 +82,7 @@ struct bcm2835_pinctrl {
 
 	struct pinctrl_dev *pctl_dev;
 	struct gpio_chip gpio_chip;
+	struct pinctrl_desc pctl_desc;
 	struct pinctrl_gpio_range gpio_range;
 
 	raw_spinlock_t irq_lock[BCM2835_NUM_BANKS];
@@ -1051,7 +1052,7 @@ static const struct pinconf_ops bcm2711_pinconf_ops = {
 	.pin_config_set = bcm2711_pinconf_set,
 };
 
-static struct pinctrl_desc bcm2835_pinctrl_desc = {
+static const struct pinctrl_desc bcm2835_pinctrl_desc = {
 	.name = MODULE_NAME,
 	.pins = bcm2835_gpio_pins,
 	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
@@ -1061,19 +1062,47 @@ static struct pinctrl_desc bcm2835_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
-static struct pinctrl_gpio_range bcm2835_pinctrl_gpio_range = {
+static const struct pinctrl_desc bcm2711_pinctrl_desc = {
+	.name = MODULE_NAME,
+	.pins = bcm2835_gpio_pins,
+	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
+	.pctlops = &bcm2835_pctl_ops,
+	.pmxops = &bcm2835_pmx_ops,
+	.confops = &bcm2711_pinconf_ops,
+	.owner = THIS_MODULE,
+};
+
+static const struct pinctrl_gpio_range bcm2835_pinctrl_gpio_range = {
 	.name = MODULE_NAME,
 	.npins = BCM2835_NUM_GPIOS,
 };
 
+struct bcm_plat_data {
+	const struct gpio_chip *gpio_chip;
+	const struct pinctrl_desc *pctl_desc;
+	const struct pinctrl_gpio_range *gpio_range;
+};
+
+static const struct bcm_plat_data bcm2835_plat_data = {
+	.gpio_chip = &bcm2835_gpio_chip,
+	.pctl_desc = &bcm2835_pinctrl_desc,
+	.gpio_range = &bcm2835_pinctrl_gpio_range,
+};
+
+static const struct bcm_plat_data bcm2711_plat_data = {
+	.gpio_chip = &bcm2835_gpio_chip,
+	.pctl_desc = &bcm2711_pinctrl_desc,
+	.gpio_range = &bcm2835_pinctrl_gpio_range,
+};
+
 static const struct of_device_id bcm2835_pinctrl_match[] = {
 	{
 		.compatible = "brcm,bcm2835-gpio",
-		.data = &bcm2835_pinconf_ops,
+		.data = &bcm2835_plat_data,
 	},
 	{
 		.compatible = "brcm,bcm2711-gpio",
-		.data = &bcm2711_pinconf_ops,
+		.data = &bcm2711_plat_data,
 	},
 	{}
 };
@@ -1082,6 +1111,7 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	const struct bcm_plat_data *pdata;
 	struct bcm2835_pinctrl *pc;
 	struct gpio_irq_chip *girq;
 	struct resource iomem;
@@ -1108,7 +1138,13 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(pc->base))
 		return PTR_ERR(pc->base);
 
-	pc->gpio_chip = bcm2835_gpio_chip;
+	match = of_match_node(bcm2835_pinctrl_match, pdev->dev.of_node);
+	if (!match)
+		return -EINVAL;
+
+	pdata = match->data;
+
+	pc->gpio_chip = *pdata->gpio_chip;
 	pc->gpio_chip.parent = dev;
 	pc->gpio_chip.of_node = np;
 
@@ -1159,19 +1195,14 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	match = of_match_node(bcm2835_pinctrl_match, pdev->dev.of_node);
-	if (match) {
-		bcm2835_pinctrl_desc.confops =
-			(const struct pinconf_ops *)match->data;
-	}
-
-	pc->pctl_dev = devm_pinctrl_register(dev, &bcm2835_pinctrl_desc, pc);
+	pc->pctl_desc = *pdata->pctl_desc;
+	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
 		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-	pc->gpio_range = bcm2835_pinctrl_gpio_range;
+	pc->gpio_range = *pdata->gpio_range;
 	pc->gpio_range.base = pc->gpio_chip.base;
 	pc->gpio_range.gc = &pc->gpio_chip;
 	pinctrl_add_gpio_range(pc->pctl_dev, &pc->gpio_range);
-- 
2.25.1

