Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727B449BC63
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiAYTm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiAYTml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:41 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142DDC06173B;
        Tue, 25 Jan 2022 11:42:41 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i8so19071856pgt.13;
        Tue, 25 Jan 2022 11:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sXtKJXiPTm9fphtCY1N57796+JzIKGIG5Zq7MdkZmXc=;
        b=TC7pnkDEBnzuHNS2yxC+dWjNGHDaDuPWCuIZrPRyfCJtgtlzp+yEMC+V8/SMvkTove
         7cNAKdr+9zmoC9wjFXp59CjAkpsC3eCGRxbHHEmhlAe42JTrIvKYu21JCkv8CvAOW3ws
         rOAWnl8s7eeScibqvIXvZ9SQGnjxIUWsxwYhr5LezW9aYhzQd9dmCgnsJa2orfWVENRv
         14PIOa4Vkf11WFCH++UUY4DMF9LxGdjkPxbX+nhHmpOMbFS3FskBFi4AsULFjTTZ08mv
         uxecTV+sL+L2EO46hLuDc5BWfFbcjuZysbDXpFhBSFnNFcx4PTTkgU/pC5e6uTR6fT0a
         kYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sXtKJXiPTm9fphtCY1N57796+JzIKGIG5Zq7MdkZmXc=;
        b=c+RjL7Ektzy4aXBEDVKoCeZczZq+ObCyyTZniHVDfnj+9sRrmIk1Bp9bL2DNyXVEPd
         ibgFx4iNkaXDstppNnJ4cq65PLohXoCDgoQaYuxUkpTgJyN5mHV+IaS3Xwfme7mAw6sn
         6ZpGimlVkM5TzmrW9o49GOey4rJwdIDecQjZkLAckTTB1gb/KaZ1MZeXEu9bequo4/ul
         697YuxJsvCyCZG0eobjU8eHl0XkxpNLp2+tLt/C98fpu+4kuI8AbTzPK7N8y2lgH7vGT
         vvTJ1ZXHhK8W2akF/irqHpLCvZc7RZtB1QbFZezG1JE2wuQlXkRFfm/NoaCiINFbKoOn
         SPFA==
X-Gm-Message-State: AOAM533Jm86ESZkxKg0ZyO+bJgkWS/jHL/zmdl0q6Xws4o2fTQxHzm1U
        VoOi9dFnxxuk7MJXh+4xbsYCC8jthYo=
X-Google-Smtp-Source: ABdhPJz4D7GrsnDYxHCSJszLD5YywGaIgspkAqlQoWSBVRXRy00G9TOiqQ3S1/QCcvuppSw93Xwr8Q==
X-Received: by 2002:a63:9545:: with SMTP id t5mr16357666pgn.446.1643139760175;
        Tue, 25 Jan 2022 11:42:40 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:39 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Phil Elwell <phil@raspberrypi.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-rpi-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM
        BCM2711/BCM2835 ARM ARCHITECTURE)
Subject: [PATCH stable 5.4 6/7] pinctrl: bcm2835: Change init order for gpio hogs
Date:   Tue, 25 Jan 2022 11:42:21 -0800
Message-Id: <20220125194222.12783-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit 266423e60ea1b953fcc0cd97f3dad85857e434d1 upstream

...and gpio-ranges

pinctrl-bcm2835 is a combined pinctrl/gpio driver. Currently the gpio
side is registered first, but this breaks gpio hogs (which are
configured during gpiochip_add_data). Part of the hog initialisation
is a call to pinctrl_gpio_request, and since the pinctrl driver hasn't
yet been registered this results in an -EPROBE_DEFER from which it can
never recover.

Change the initialisation sequence to register the pinctrl driver
first.

This also solves a similar problem with the gpio-ranges property, which
is required in order for released pins to be returned to inputs.

Fixes: 73345a18d464b ("pinctrl: bcm2835: Pass irqchip when adding gpiochip")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211206092237.4105895-2-phil@raspberrypi.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 29 +++++++++++++++------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 436184ebd2ef..fa742535f679 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1241,6 +1241,18 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		raw_spin_lock_init(&pc->irq_lock[i]);
 	}
 
+	pc->pctl_desc = *pdata->pctl_desc;
+	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
+	if (IS_ERR(pc->pctl_dev)) {
+		gpiochip_remove(&pc->gpio_chip);
+		return PTR_ERR(pc->pctl_dev);
+	}
+
+	pc->gpio_range = *pdata->gpio_range;
+	pc->gpio_range.base = pc->gpio_chip.base;
+	pc->gpio_range.gc = &pc->gpio_chip;
+	pinctrl_add_gpio_range(pc->pctl_dev, &pc->gpio_range);
+
 	girq = &pc->gpio_chip.irq;
 	girq->chip = &bcm2835_gpio_irq_chip;
 	girq->parent_handler = bcm2835_gpio_irq_handler;
@@ -1248,8 +1260,10 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	girq->parents = devm_kcalloc(dev, BCM2835_NUM_IRQS,
 				     sizeof(*girq->parents),
 				     GFP_KERNEL);
-	if (!girq->parents)
+	if (!girq->parents) {
+		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
 		return -ENOMEM;
+	}
 
 	if (is_7211) {
 		pc->wake_irq = devm_kcalloc(dev, BCM2835_NUM_IRQS,
@@ -1300,21 +1314,10 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	err = gpiochip_add_data(&pc->gpio_chip, pc);
 	if (err) {
 		dev_err(dev, "could not add GPIO chip\n");
+		pinctrl_remove_gpio_range(pc->pctl_dev, &pc->gpio_range);
 		return err;
 	}
 
-	pc->pctl_desc = *pdata->pctl_desc;
-	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
-	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
-		return PTR_ERR(pc->pctl_dev);
-	}
-
-	pc->gpio_range = *pdata->gpio_range;
-	pc->gpio_range.base = pc->gpio_chip.base;
-	pc->gpio_range.gc = &pc->gpio_chip;
-	pinctrl_add_gpio_range(pc->pctl_dev, &pc->gpio_range);
-
 	return 0;
 }
 
-- 
2.25.1

