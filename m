Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D922B8649
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 22:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgKRVJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 16:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRVJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 16:09:20 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AAC0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 13:09:18 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b6so3599651wrt.4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 13:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=cI3BTmcxL/ITRvBSKgRw5uGvV+zOKXMtuF+NCGXpaxc=;
        b=SO1HvYgnN6QsBbvwdiWo+xjfifa3R4gIBrBjEfG3JOdmX0BYApyieWg/oa4xgLTlZj
         xb3RkgNpuXPBJ6iZiK6U1bMbH97z/QD+B6E5TVJvkYVnfGRJ1KLEtb/+87p2bMy3I9yI
         A5oMDIQLBGQl2ZiBHxemFlUgC+/PFocvxnDrSAhGJ5nuH+TYMdr/Ch0+8gWM2o+ELy6U
         7G7NMtvgHKu8d80UsTgLgy9VmZCQzuI3AmbjOQIBrwb+wnOA61dVOegaNzPUf6TsnuRv
         1fXhpigTVE/nT9zxzAYdfxrWO+jgfWa6SXOhYLQFZLMgZ/ivz/qPbZHkCqA//gVM6rzU
         Bgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cI3BTmcxL/ITRvBSKgRw5uGvV+zOKXMtuF+NCGXpaxc=;
        b=c7d+KXAuBRmryP7ktz0+fVs0GUW3pBabKl+x2eYptqUxaVgXVmJHcWqF7YlEK30U6I
         R7K1wkYgMNtMfyOlviMuvITG9ptivyzVIan8sIGo+DbVfiEMVFLEipEGzGQHcv+ZqZGu
         0UwKu+dApCPDHuacfJXDwE8ZGM8qEkaxKTIAMEqn9lsfenbLebKyow2FhDyAvVUYjFVi
         05Xqyl2ZpSx5fZX/HNGfb30hzEKxt3C8r/fnR/82/jHrEWthPNzmIz0XCYu2VXAU3NYR
         wEetod36R1L51IGotg/Owy5Ywkpw/O0X07VUeN+keHs2iP64avpQcmYTw0J/dWidQr14
         GjxA==
X-Gm-Message-State: AOAM530Su6p8LM4oHrnvoXsHef4tzAInWoPEf64Q8eXhKUQtCq4tdPUx
        mshS+IxHrGRaeCGEn16lWGM=
X-Google-Smtp-Source: ABdhPJy7drmtBStmPAL6BjJYoH8Ux5bEUzrcas3kVnzkL2pc6vunUBecOQTTpvCuUVp/PypxKMeEnA==
X-Received: by 2002:adf:d188:: with SMTP id v8mr6605110wrc.167.1605733757273;
        Wed, 18 Nov 2020 13:09:17 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id b14sm35690884wrx.35.2020.11.18.13.09.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 13:09:16 -0800 (PST)
Date:   Wed, 18 Nov 2020 21:09:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: backport of e50e4f0b85be ("i2c: imx: Fix external abort on interrupt
 in exit paths") for v4.4.y
Message-ID: <20201118210914.67lheikunk2b6i5f@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mczgm5bslrtgmqeu"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mczgm5bslrtgmqeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

This was missing in 4.4-stable. It was easier to backport than picking
all the other commits needed to aply it cleanly. It has been manually
backported with an extra label for goto. I will prefer an Ack from
Wolfram or Krzysztof or Oleksij before you add it to your queue.


--
Regards
Sudip

--mczgm5bslrtgmqeu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-i2c-imx-Fix-external-abort-on-interrupt-in-exit-path.patch"

From 8f36face3f2dfd3c97885e1102a322d28e440a78 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Sun, 20 Sep 2020 23:12:38 +0200
Subject: [PATCH] i2c: imx: Fix external abort on interrupt in exit paths

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
[sudip: manual backport with extra label for goto]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/i2c/busses/i2c-imx.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d121c5732d7d..37303a7a2e73 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1093,20 +1093,20 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		goto clk_disable;
 	}
 
-	/* Request IRQ */
-	ret = devm_request_irq(&pdev->dev, irq, i2c_imx_isr, 0,
-				pdev->name, i2c_imx);
-	if (ret) {
-		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
-		goto clk_disable;
-	}
-
 	/* Init queue */
 	init_waitqueue_head(&i2c_imx->queue);
 
 	/* Set up adapter data */
 	i2c_set_adapdata(&i2c_imx->adapter, i2c_imx);
 
+	/* Request IRQ */
+	ret = request_threaded_irq(irq, i2c_imx_isr, NULL, 0,
+				   pdev->name, i2c_imx);
+	if (ret) {
+		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
+		goto clk_disable;
+	}
+
 	/* Set up clock divider */
 	i2c_imx->bitrate = IMX_I2C_BIT_RATE;
 	ret = of_property_read_u32(pdev->dev.of_node,
@@ -1125,7 +1125,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_imx->adapter);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "registration failed\n");
-		goto clk_disable;
+		goto clk_free_irq;
 	}
 
 	/* Set up platform driver data */
@@ -1143,6 +1143,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 	return 0;   /* Return OK */
 
+clk_free_irq:
+	free_irq(irq, i2c_imx);
 clk_disable:
 	clk_disable_unprepare(i2c_imx->clk);
 	return ret;
@@ -1151,6 +1153,7 @@ clk_disable:
 static int i2c_imx_remove(struct platform_device *pdev)
 {
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
+	int irq;
 
 	/* remove adapter */
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
@@ -1165,6 +1168,10 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0)
+		free_irq(irq, i2c_imx);
+
 	return 0;
 }
 
-- 
2.11.0


--mczgm5bslrtgmqeu--
