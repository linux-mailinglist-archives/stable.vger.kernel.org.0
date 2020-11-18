Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652DC2B860F
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 21:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgKRU5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 15:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRU5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 15:57:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F36DC0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 12:57:20 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id a186so1576614wme.1
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 12:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=FAIndFe0uZwmA715NUnnpL0WEuWqC3awQTR5JgHY8O8=;
        b=apzttABaddjCVxxoABe+ESMBdRcewoiof9VkwJxzHTgLkXkqTpk65i9poqyF0PfllU
         WuLD7/KvOjVCbk8bdzYGWQc9ieBoBWpRiMXQlTDqj+9rI7dPGdbKfkQ5xdkPDXvcfbaf
         Ri/bAr1DZvoIIWcfH11spIMgT0h5irozXy4OHVtvPoLVsu8AkKpE6AYGAal1VyW+QdiE
         LlbGRegrVtUqouGEjRXfJb3I0Nfv7lJ1FRwurIpsn7f/Kbc2tnF1XjAZ9famFo5iwWlk
         EHova4NPIzoVI7Xm+1Z5OxytpWeVud24WMsLH8Mvrfwrd94hP5gTEcMbzG6a5yXAtzmf
         d5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=FAIndFe0uZwmA715NUnnpL0WEuWqC3awQTR5JgHY8O8=;
        b=gXzZmZFcGUAappbDlYdWuLSjHpvYfCA1JpdKr1fNtY5YcDyfxXDCfeCXvSCPhfNh9w
         QPckujw+CA4hWiXpgXw68+MQDjqgBONmkG9f/N0ew2go9FjrFwN1JkEtc8VOT8Bl2wjP
         EvdFthbrbuAF5Pld25UV1BH+GxsczwO6JVrHGbVt8VqkdorkDPi7+B2pZAd3suLNzl4Z
         DMC0xLrztlvTIXLUKgqdumLkLJIyhUcA3izWSXu3LRtdZwcROprNfmYfGnD9bcY96wVs
         OSGJGqSFkKeIIzogm/BF59R1UX2kXfVs27ACDqQpRqLfyVnn0W1SDchcZFJPAwjUvhXS
         LQbw==
X-Gm-Message-State: AOAM5326DjFd+mnFHiRjF6a+3zHNMJlET5RquPFmd5PhzdeFidP6ozKA
        eL9u26xxtFkgjXq3UgzGQaR1oiHCbxM9hw==
X-Google-Smtp-Source: ABdhPJxRHFf6fHaMSByRErOOSZrlXbP0hu0mdtH/ijgm8TSWbgA7MaKnCx2t1ta/0jj1dT3z7il9Yw==
X-Received: by 2002:a05:600c:22d7:: with SMTP id 23mr988887wmg.67.1605733039290;
        Wed, 18 Nov 2020 12:57:19 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id 6sm32410299wrn.72.2020.11.18.12.57.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 12:57:18 -0800 (PST)
Date:   Wed, 18 Nov 2020 20:57:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: backport of e50e4f0b85be ("i2c: imx: Fix external abort on interrupt
 in exit paths") for v4.14.y
Message-ID: <20201118205716.yv36spexfy5v452x@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xxvqzfczffuqdoxy"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xxvqzfczffuqdoxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

This was missing in 4.14-stable. First patch is only needed so that
applying the second patch becomes easy. If its not accepted I can manually
backport it. Please add it to your queue.


--
Regards
Sudip

--xxvqzfczffuqdoxy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-i2c-imx-use-clk-notifier-for-rate-changes.patch"

From 46a682fddb93b514557815493c317cd641984532 Mon Sep 17 00:00:00 2001
From: Lucas Stach <l.stach@pengutronix.de>
Date: Thu, 8 Mar 2018 14:25:17 +0100
Subject: [PATCH 1/2] i2c: imx: use clk notifier for rate changes

commit 90ad2cbe88c22d0215225ab9594eeead0eb24fde upstream

Instead of repeatedly calling clk_get_rate for each transfer, register
a clock notifier to update the cached divider value each time the clock
rate actually changes.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/i2c/busses/i2c-imx.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 26f83029f64a..70eafab5f6b7 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -194,6 +194,7 @@ struct imx_i2c_dma {
 struct imx_i2c_struct {
 	struct i2c_adapter	adapter;
 	struct clk		*clk;
+	struct notifier_block	clk_change_nb;
 	void __iomem		*base;
 	wait_queue_head_t	queue;
 	unsigned long		i2csr;
@@ -468,15 +469,14 @@ static int i2c_imx_acked(struct imx_i2c_struct *i2c_imx)
 	return 0;
 }
 
-static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx)
+static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx,
+			    unsigned int i2c_clk_rate)
 {
 	struct imx_i2c_clk_pair *i2c_clk_div = i2c_imx->hwdata->clk_div;
-	unsigned int i2c_clk_rate;
 	unsigned int div;
 	int i;
 
 	/* Divider value calculation */
-	i2c_clk_rate = clk_get_rate(i2c_imx->clk);
 	if (i2c_imx->cur_clk == i2c_clk_rate)
 		return;
 
@@ -511,6 +511,20 @@ static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx)
 #endif
 }
 
+static int i2c_imx_clk_notifier_call(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct clk_notifier_data *ndata = data;
+	struct imx_i2c_struct *i2c_imx = container_of(&ndata->clk,
+						      struct imx_i2c_struct,
+						      clk);
+
+	if (action & POST_RATE_CHANGE)
+		i2c_imx_set_clk(i2c_imx, ndata->new_rate);
+
+	return NOTIFY_OK;
+}
+
 static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
 {
 	unsigned int temp = 0;
@@ -518,8 +532,6 @@ static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
 
 	dev_dbg(&i2c_imx->adapter.dev, "<%s>\n", __func__);
 
-	i2c_imx_set_clk(i2c_imx);
-
 	imx_i2c_write_reg(i2c_imx->ifdr, i2c_imx, IMX_I2C_IFDR);
 	/* Enable I2C controller */
 	imx_i2c_write_reg(i2c_imx->hwdata->i2sr_clr_opcode, i2c_imx, IMX_I2C_I2SR);
@@ -1131,6 +1143,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
 				   "clock-frequency", &i2c_imx->bitrate);
 	if (ret < 0 && pdata && pdata->bitrate)
 		i2c_imx->bitrate = pdata->bitrate;
+	i2c_imx->clk_change_nb.notifier_call = i2c_imx_clk_notifier_call;
+	clk_notifier_register(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	i2c_imx_set_clk(i2c_imx, clk_get_rate(i2c_imx->clk));
 
 	/* Set up chip registers to defaults */
 	imx_i2c_write_reg(i2c_imx->hwdata->i2cr_ien_opcode ^ I2CR_IEN,
@@ -1141,12 +1156,12 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	ret = i2c_imx_init_recovery_info(i2c_imx, pdev);
 	/* Give it another chance if pinctrl used is not ready yet */
 	if (ret == -EPROBE_DEFER)
-		goto rpm_disable;
+		goto clk_notifier_unregister;
 
 	/* Add I2C adapter */
 	ret = i2c_add_numbered_adapter(&i2c_imx->adapter);
 	if (ret < 0)
-		goto rpm_disable;
+		goto clk_notifier_unregister;
 
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
@@ -1162,6 +1177,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 	return 0;   /* Return OK */
 
+clk_notifier_unregister:
+	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -1195,6 +1212,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
+	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 	clk_disable_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.11.0


--xxvqzfczffuqdoxy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-i2c-imx-Fix-external-abort-on-interrupt-in-exit-path.patch"

From 9af0a648252a96cb9428101fed0e225cef7b1c09 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Sun, 20 Sep 2020 23:12:38 +0200
Subject: [PATCH 2/2] i2c: imx: Fix external abort on interrupt in exit paths

commit e50e4f0b85be308a01b830c5fbdffc657e1a6dd0 upstream

If interrupt comes late, during probe error path or device remove (could
be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
i2c_imx_isr() will access registers with the clock being disabled.  This
leads to external abort on non-linefetch on Toradex Colibri VF50 module
(with Vybrid VF5xx):

    Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003
    Internal error: : 1008 [#1] ARM
    Modules linked in:
    CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
      (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
      (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
      (really_probe) from [<80580380>] (driver_probe_device+0x60/0x170)
      (driver_probe_device) from [<80580630>] (device_driver_attach+0x58/0x60)
      (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/0xc0)
      (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
      (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1ec)
      (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
      (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
      (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178/0x1dc)
      (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
      (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)

Additionally, the i2c_imx_isr() could wake up the wait queue
(imx_i2c_struct->queue) before its initialization happens.

The resource-managed framework should not be used for interrupt handling,
because the resource will be released too late - after disabling clocks.
The interrupt handler is not prepared for such case.

Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/i2c/busses/i2c-imx.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 70eafab5f6b7..ce7a2bfd1dd8 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1111,14 +1111,6 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Request IRQ */
-	ret = devm_request_irq(&pdev->dev, irq, i2c_imx_isr, IRQF_SHARED,
-				pdev->name, i2c_imx);
-	if (ret) {
-		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
-		goto clk_disable;
-	}
-
 	/* Init queue */
 	init_waitqueue_head(&i2c_imx->queue);
 
@@ -1137,6 +1129,14 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto rpm_disable;
 
+	/* Request IRQ */
+	ret = request_threaded_irq(irq, i2c_imx_isr, NULL, IRQF_SHARED,
+				   pdev->name, i2c_imx);
+	if (ret) {
+		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
+		goto rpm_disable;
+	}
+
 	/* Set up clock divider */
 	i2c_imx->bitrate = IMX_I2C_BIT_RATE;
 	ret = of_property_read_u32(pdev->dev.of_node,
@@ -1179,13 +1179,12 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-
-clk_disable:
 	clk_disable_unprepare(i2c_imx->clk);
 	return ret;
 }
@@ -1193,7 +1192,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 static int i2c_imx_remove(struct platform_device *pdev)
 {
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
-	int ret;
+	int irq, ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
@@ -1213,6 +1212,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0)
+		free_irq(irq, i2c_imx);
 	clk_disable_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.11.0


--xxvqzfczffuqdoxy--
