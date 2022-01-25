Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC9949BC59
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiAYTm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiAYTmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:42:37 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B5BC061744;
        Tue, 25 Jan 2022 11:42:35 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id a8so15383927pfa.6;
        Tue, 25 Jan 2022 11:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxqlDLmZJgxjUCsP0FCIBoO5ZvudEfErx4WpcVVz2is=;
        b=jbqkzgQbio3speo4hV8gz+HrDtMKsHChLVQlRRsoOF0awP/KS5RKTGq1Ze4fydJu0S
         IL14RYh0LNcZq2SrD2bFBznincs+qPEj8AYRL4UWT/IUhLiryr7Km5xIDsXvekrS9PfQ
         s78EdUkAcVpgnp3VG/+rCWEOLKsZqxj1teLB4bJ07UTMLPk/iRJAWIQ3fI5VMc+1QlaG
         Pa7ZwOdEZPqsxgAhMElBBbcW0pZ4+84UPRZ69qGNEIut9Ve/EuJoDUVzgCd6/GVSEB0m
         geqOnUDLBluzsajhOMu5i7vVa2O4Flk/Lhs0UZLINIFNrT/OubNkWCfUvEnySxxUOCOq
         UpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxqlDLmZJgxjUCsP0FCIBoO5ZvudEfErx4WpcVVz2is=;
        b=yMJrUz8UabVMbvPVeroowehUgdxim11Moflk2K+J6Cfx+uwmqj34Vo4HKJd6CIDtjg
         u40Yn+uJfRZtg/J2mpz08xJYqSJr6nHGg7Z/gcnK2ij6i9LLQZSyREVbtGlFDiLSlw6x
         bWSkmUkUAgisf8ShToouaeFonZ0cZ//zbpj0uVIlDPIEUplG8Iv9k7s++IjWzx4QIpRH
         24M3HyxnWDo2AnO/+U8Ke7G6xLkibZ/BsHVgP7gXXYxcn79Jx1CBCxenJj2cGlru/mor
         fEK1QNECMg1wfJYvsBHB+fAKpSF7FAESg2E0r2/3lMETji7PmAu1X2UV9h/J2AP5k253
         BP0w==
X-Gm-Message-State: AOAM530sWUuudNwM5xaxMn7oNyMHg4jf/1qJC2n39T5KlQO6BW5QZqHh
        JRE2bglwaLGcfLnLha0uy8JMvAEYM5A=
X-Google-Smtp-Source: ABdhPJyTtR7DQSBRuRNmRF1u+U9ozmchNil7WrqnrG5UHBJ+Eb9eCo02HX8XCpTOFwGY1YRusKEs2w==
X-Received: by 2002:a05:6a00:23c1:b0:4c9:f220:2379 with SMTP id g1-20020a056a0023c100b004c9f2202379mr7465944pfc.65.1643139754492;
        Tue, 25 Jan 2022 11:42:34 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a1sm15087343pgm.83.2022.01.25.11.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:42:33 -0800 (PST)
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
Subject: [PATCH stable 5.4 3/7] pinctrl: bcm2835: Add support for all GPIOs on BCM2711
Date:   Tue, 25 Jan 2022 11:42:18 -0800
Message-Id: <20220125194222.12783-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125194222.12783-1-f.fainelli@gmail.com>
References: <20220125194222.12783-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit b1d84a3d0a26c5844a22bc09a42704b9371208bb upstream

The BCM2711 supports 58 GPIOs. So extend pinctrl and GPIOs accordingly.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1581166975-22949-4-git-send-email-stefan.wahren@i2se.com
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 54 +++++++++++++++++++++------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 7f0a9c647927..061e70ed17a7 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -37,6 +37,7 @@
 
 #define MODULE_NAME "pinctrl-bcm2835"
 #define BCM2835_NUM_GPIOS 54
+#define BCM2711_NUM_GPIOS 58
 #define BCM2835_NUM_BANKS 2
 #define BCM2835_NUM_IRQS  3
 
@@ -78,7 +79,7 @@ struct bcm2835_pinctrl {
 
 	/* note: locking assumes each bank will have its own unsigned long */
 	unsigned long enabled_irq_map[BCM2835_NUM_BANKS];
-	unsigned int irq_type[BCM2835_NUM_GPIOS];
+	unsigned int irq_type[BCM2711_NUM_GPIOS];
 
 	struct pinctrl_dev *pctl_dev;
 	struct gpio_chip gpio_chip;
@@ -145,6 +146,10 @@ static struct pinctrl_pin_desc bcm2835_gpio_pins[] = {
 	BCM2835_GPIO_PIN(51),
 	BCM2835_GPIO_PIN(52),
 	BCM2835_GPIO_PIN(53),
+	BCM2835_GPIO_PIN(54),
+	BCM2835_GPIO_PIN(55),
+	BCM2835_GPIO_PIN(56),
+	BCM2835_GPIO_PIN(57),
 };
 
 /* one pin per group */
@@ -203,6 +208,10 @@ static const char * const bcm2835_gpio_groups[] = {
 	"gpio51",
 	"gpio52",
 	"gpio53",
+	"gpio54",
+	"gpio55",
+	"gpio56",
+	"gpio57",
 };
 
 enum bcm2835_fsel {
@@ -353,6 +362,22 @@ static const struct gpio_chip bcm2835_gpio_chip = {
 	.can_sleep = false,
 };
 
+static const struct gpio_chip bcm2711_gpio_chip = {
+	.label = "pinctrl-bcm2711",
+	.owner = THIS_MODULE,
+	.request = gpiochip_generic_request,
+	.free = gpiochip_generic_free,
+	.direction_input = bcm2835_gpio_direction_input,
+	.direction_output = bcm2835_gpio_direction_output,
+	.get_direction = bcm2835_gpio_get_direction,
+	.get = bcm2835_gpio_get,
+	.set = bcm2835_gpio_set,
+	.set_config = gpiochip_generic_config,
+	.base = -1,
+	.ngpio = BCM2711_NUM_GPIOS,
+	.can_sleep = false,
+};
+
 static void bcm2835_gpio_irq_handle_bank(struct bcm2835_pinctrl *pc,
 					 unsigned int bank, u32 mask)
 {
@@ -399,7 +424,7 @@ static void bcm2835_gpio_irq_handler(struct irq_desc *desc)
 		bcm2835_gpio_irq_handle_bank(pc, 0, 0xf0000000);
 		bcm2835_gpio_irq_handle_bank(pc, 1, 0x00003fff);
 		break;
-	case 2: /* IRQ2 covers GPIOs 46-53 */
+	case 2: /* IRQ2 covers GPIOs 46-57 */
 		bcm2835_gpio_irq_handle_bank(pc, 1, 0x003fc000);
 		break;
 	}
@@ -618,7 +643,7 @@ static struct irq_chip bcm2835_gpio_irq_chip = {
 
 static int bcm2835_pctl_get_groups_count(struct pinctrl_dev *pctldev)
 {
-	return ARRAY_SIZE(bcm2835_gpio_groups);
+	return BCM2835_NUM_GPIOS;
 }
 
 static const char *bcm2835_pctl_get_group_name(struct pinctrl_dev *pctldev,
@@ -776,7 +801,7 @@ static int bcm2835_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
 		err = of_property_read_u32_index(np, "brcm,pins", i, &pin);
 		if (err)
 			goto out;
-		if (pin >= ARRAY_SIZE(bcm2835_gpio_pins)) {
+		if (pin >= pc->pctl_desc.npins) {
 			dev_err(pc->dev, "%pOF: invalid brcm,pins value %d\n",
 				np, pin);
 			err = -EINVAL;
@@ -852,7 +877,7 @@ static int bcm2835_pmx_get_function_groups(struct pinctrl_dev *pctldev,
 {
 	/* every pin can do every function */
 	*groups = bcm2835_gpio_groups;
-	*num_groups = ARRAY_SIZE(bcm2835_gpio_groups);
+	*num_groups = BCM2835_NUM_GPIOS;
 
 	return 0;
 }
@@ -1055,7 +1080,7 @@ static const struct pinconf_ops bcm2711_pinconf_ops = {
 static const struct pinctrl_desc bcm2835_pinctrl_desc = {
 	.name = MODULE_NAME,
 	.pins = bcm2835_gpio_pins,
-	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
+	.npins = BCM2835_NUM_GPIOS,
 	.pctlops = &bcm2835_pctl_ops,
 	.pmxops = &bcm2835_pmx_ops,
 	.confops = &bcm2835_pinconf_ops,
@@ -1063,9 +1088,9 @@ static const struct pinctrl_desc bcm2835_pinctrl_desc = {
 };
 
 static const struct pinctrl_desc bcm2711_pinctrl_desc = {
-	.name = MODULE_NAME,
+	.name = "pinctrl-bcm2711",
 	.pins = bcm2835_gpio_pins,
-	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
+	.npins = BCM2711_NUM_GPIOS,
 	.pctlops = &bcm2835_pctl_ops,
 	.pmxops = &bcm2835_pmx_ops,
 	.confops = &bcm2711_pinconf_ops,
@@ -1077,6 +1102,11 @@ static const struct pinctrl_gpio_range bcm2835_pinctrl_gpio_range = {
 	.npins = BCM2835_NUM_GPIOS,
 };
 
+static const struct pinctrl_gpio_range bcm2711_pinctrl_gpio_range = {
+	.name = "pinctrl-bcm2711",
+	.npins = BCM2711_NUM_GPIOS,
+};
+
 struct bcm_plat_data {
 	const struct gpio_chip *gpio_chip;
 	const struct pinctrl_desc *pctl_desc;
@@ -1090,9 +1120,9 @@ static const struct bcm_plat_data bcm2835_plat_data = {
 };
 
 static const struct bcm_plat_data bcm2711_plat_data = {
-	.gpio_chip = &bcm2835_gpio_chip,
+	.gpio_chip = &bcm2711_gpio_chip,
 	.pctl_desc = &bcm2711_pinctrl_desc,
-	.gpio_range = &bcm2835_pinctrl_gpio_range,
+	.gpio_range = &bcm2711_pinctrl_gpio_range,
 };
 
 static const struct of_device_id bcm2835_pinctrl_match[] = {
@@ -1118,8 +1148,8 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	int err, i;
 	const struct of_device_id *match;
 
-	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_pins) != BCM2835_NUM_GPIOS);
-	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_groups) != BCM2835_NUM_GPIOS);
+	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_pins) != BCM2711_NUM_GPIOS);
+	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_groups) != BCM2711_NUM_GPIOS);
 
 	pc = devm_kzalloc(dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc)
-- 
2.25.1

