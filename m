Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB557074E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiGKPog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiGKPog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:44:36 -0400
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22DF27B30
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:44:34 -0700 (PDT)
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BDLhZs016906;
        Mon, 11 Jul 2022 17:44:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=AfHoh3IzVP1ccpo2tEpmiZOVbjxt+wjM4g+RQuY+50U=;
 b=KifBnxrDdhUUCi3BjpvIZNK98G9HAA6Gi7qdJYV1I2jxS/kKFSBusiMg3t7cAFVfXs7X
 YL7DNBWLtEUkxblt721KP6/piguop2fEKSmTVlkryRn+oQdfsESPuoYObR8mfZfSqANP
 yjjuezkq82hqdP6YyoxmH9UnU81qfwTvHDi7qpqVAwF/PTW4gfyTMdVM7C3nUfO7TejO
 dVHRRcUZV9dMZqMZOeQnRQTEmcedYBD/6XHMQff02l76HL+z/J7bMtdC2S3LtYjSwddf
 HxIIvbp3qV6P52BmDx8WjYntxJQ+Df0gfyf6X2trp7eFuXdW2r4ddgSOJLzzIlIo+bdk oA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3h70jk3xws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 17:44:32 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 643E410002A;
        Mon, 11 Jul 2022 17:44:30 +0200 (CEST)
Received: from Webmail-eu.st.com (eqndag1node6.st.com [10.75.129.135])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 5089D229A87;
        Mon, 11 Jul 2022 17:44:30 +0200 (CEST)
Received: from [10.48.1.150] (10.75.127.47) by EQNDAG1NODE6.st.com
 (10.75.129.135) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 11 Jul
 2022 17:44:30 +0200
Message-ID: <d696b6bb-3a2a-f179-aaed-8155dbf4af1f@foss.st.com>
Date:   Mon, 11 Jul 2022 17:44:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: FAILED: patch "[PATCH] pinctrl: stm32: fix optional IRQ support
 to gpios" failed to apply to 5.18-stable tree
Content-Language: en-US
To:     <gregkh@linuxfoundation.org>, <linus.walleij@linaro.org>
CC:     <stable@vger.kernel.org>
References: <1657523339795@kroah.com>
From:   Fabien DESSENNE <fabien.dessenne@foss.st.com>
In-Reply-To: <1657523339795@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To EQNDAG1NODE6.st.com
 (10.75.129.135)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_20,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/07/2022 09:08, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From a1d4ef1adf8bbd302067534ead671a94759687ed Mon Sep 17 00:00:00 2001
> From: Fabien Dessenne <fabien.dessenne@foss.st.com>
> Date: Mon, 27 Jun 2022 16:23:50 +0200
> Subject: [PATCH] pinctrl: stm32: fix optional IRQ support to gpios
> 
> To act as an interrupt controller, a gpio bank relies on the
> "interrupt-parent" of the pin controller.
> When this optional "interrupt-parent" misses, do not create any IRQ domain.
> 
> This fixes a "NULL pointer in stm32_gpio_domain_alloc()" kernel crash when
> the interrupt-parent = <exti> property is not declared in the Device Tree.
> 
> Fixes: 0eb9f683336d ("pinctrl: Add IRQ support to STM32 gpios")
> Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
> Link: https://lore.kernel.org/r/20220627142350.742973-1-fabien.dessenne@foss.st.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
> index 57a33fb0f2d7..14bcca73238a 100644
> --- a/drivers/pinctrl/stm32/pinctrl-stm32.c
> +++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
> @@ -1338,16 +1338,18 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
>   	bank->secure_control = pctl->match_data->secure_control;
>   	spin_lock_init(&bank->lock);
>   
> -	/* create irq hierarchical domain */
> -	bank->fwnode = fwnode;
> +	if (pctl->domain) {
> +		/* create irq hierarchical domain */
> +		bank->fwnode = fwnode;
>   
> -	bank->domain = irq_domain_create_hierarchy(pctl->domain, 0,
> -					STM32_GPIO_IRQ_LINE, bank->fwnode,
> -					&stm32_gpio_domain_ops, bank);
> +		bank->domain = irq_domain_create_hierarchy(pctl->domain, 0, STM32_GPIO_IRQ_LINE,
> +							   bank->fwnode, &stm32_gpio_domain_ops,
> +							   bank);
>   
> -	if (!bank->domain) {
> -		err = -ENODEV;
> -		goto err_clk;
> +		if (!bank->domain) {
> +			err = -ENODEV;
> +			goto err_clk;
> +		}
>   	}
>   
>   	err = gpiochip_add_data(&bank->gpio_chip, bank);
> @@ -1510,6 +1512,8 @@ int stm32_pctl_probe(struct platform_device *pdev)
>   	pctl->domain = stm32_pctrl_get_irq_domain(pdev);
>   	if (IS_ERR(pctl->domain))
>   		return PTR_ERR(pctl->domain);
> +	if (!pctl->domain)
> +		dev_warn(dev, "pinctrl without interrupt support\n");
>   
>   	/* hwspinlock is optional */
>   	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);
> 

Hi,

Below is an updated patch which fixes the problem on all 5.x releases 
(5.18, 5.15, 5.10, 5.4).
The initial patch can be dropped on any 4.x releases.

BR,
Fabien




 From d82f7a72e3b1c7b6ed86c17b2108db6f97b61dc7 Mon Sep 17 00:00:00 2001
From: Fabien Dessenne <fabien.dessenne@foss.st.com>
Date: Mon, 27 Jun 2022 14:55:35 +0200
Subject: [PATCH] pinctrl: stm32: fix optional IRQ support to gpios

To act as an interrupt controller, a gpio bank relies on the
"interrupt-parent" of the pin controller.
When this optional "interrupt-parent" misses, do not create any IRQ domain.

This fixes a "NULL pointer in stm32_gpio_domain_alloc()" kernel crash when
the interrupt-parent = <exti> property is not declared in the Device Tree.

Fixes: 0eb9f683336d ("pinctrl: Add IRQ support to STM32 gpios")

Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
---
  drivers/pinctrl/stm32/pinctrl-stm32.c | 18 +++++++++++-------
  1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c 
b/drivers/pinctrl/stm32/pinctrl-stm32.c
index f7c9459f6628..edd0d0af5c14 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1299,15 +1299,17 @@ static int stm32_gpiolib_register_bank(struct 
stm32_pinctrl *pctl,
  	bank->bank_ioport_nr = bank_ioport_nr;
  	spin_lock_init(&bank->lock);

-	/* create irq hierarchical domain */
-	bank->fwnode = of_node_to_fwnode(np);
+	if (pctl->domain) {
+		/* create irq hierarchical domain */
+		bank->fwnode = of_node_to_fwnode(np);

-	bank->domain = irq_domain_create_hierarchy(pctl->domain, 0,
-					STM32_GPIO_IRQ_LINE, bank->fwnode,
-					&stm32_gpio_domain_ops, bank);
+		bank->domain = irq_domain_create_hierarchy(pctl->domain, 0, 
STM32_GPIO_IRQ_LINE,
+							   bank->fwnode, &stm32_gpio_domain_ops,
+							   bank);

-	if (!bank->domain)
-		return -ENODEV;
+		if (!bank->domain)
+			return -ENODEV;
+	}

  	err = gpiochip_add_data(&bank->gpio_chip, bank);
  	if (err) {
@@ -1466,6 +1468,8 @@ int stm32_pctl_probe(struct platform_device *pdev)
  	pctl->domain = stm32_pctrl_get_irq_domain(np);
  	if (IS_ERR(pctl->domain))
  		return PTR_ERR(pctl->domain);
+	if (!pctl->domain)
+		dev_warn(dev, "pinctrl without interrupt support\n");

  	/* hwspinlock is optional */
  	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);
-- 
2.25.1



