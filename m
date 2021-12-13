Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59E4733A2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbhLMSJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241719AbhLMSJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:09:11 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6385FC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:09:11 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id 13so24809087ljj.11
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQW2ZFhmnqpsnpdPNVH4cTtkoY4ngbDa2/F0iHqH+bY=;
        b=kDehNABqxYDeLiHJG1O+FlMob3glyIaqxBkYyOBFsj3jRUKxN7KhK+7563l8vW2MhH
         nGcik84hG5k5J5lkfiTg0ZXYzh8PvRR2aE9GGWieivhPop4xKJOsCJ9LFV0+cbAELSbh
         gbVgcbuoAz7/uXaLtK3uCcnVbeem4TFh7XadoaclIO8VirOBJfLkC87KH8nC4uL6kRju
         aiyOJj+H/XzK3Z15csl9ucFicm4YuB+/qR2GC139l0gZ9eN4yLwK9OKM4gxiKMQ4s2Cn
         jbEIqHFleorFwY1R8BK118nuviK4jd157vO5UBCXfAB8+BPlneG2KyTE/W4/DWNLmiht
         0Kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQW2ZFhmnqpsnpdPNVH4cTtkoY4ngbDa2/F0iHqH+bY=;
        b=AxAr0X3Z8JEV+G6rK/UH/IhLnuTW09+9rHvB+qSOoWZ07fyA5iY0eddw/VXaUIWCnC
         u4Z5MZ0iycKOPU+9HEZ6AxrTkbpy0cI5fgO/JC9US2U5aJyPsFD/M2SNyH2tysiUywwC
         kodeifMcx4tYNxSV+g66CmPMFfCM2+EzUXyf88H0I+qjqF5pOPN1nL/zKu6AVashx3Hm
         MjaosupiaeJUzY7enWNNyF/u5SQha3IjZXe5KbQ3Ne0zAp3B12aBmgTn8CnX0O2feV/h
         jZfTK/yTy+y9yu1AFS0LkwZyohlCfeqHqc3Y2vW/KLU56YzIWdF86hWn5oHifb/ieQIE
         NAlg==
X-Gm-Message-State: AOAM530nEtoxIBNFSwqFUoVLAMxsu6uCaMLip7Ge8Cn1FiNxBrrLfsmE
        /GILpz5wCTyp46eGG5VE7lKCnPnYh72Enw1/
X-Google-Smtp-Source: ABdhPJxJkB/Pni8AHU6FGqIeAmy2P7h8c1BhZt7L3mOWOAnkYghmdLnBl+QngMNVzUKWj04FaYQAyw==
X-Received: by 2002:a2e:9d3:: with SMTP id 202mr98307ljj.165.1639418949675;
        Mon, 13 Dec 2021 10:09:09 -0800 (PST)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id k23sm1562092ljg.139.2021.12.13.10.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:09:09 -0800 (PST)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, nikita.yoush@cogentembedded.com
Subject: [PATCH 5.10] staging: most: dim2: use device release method
Date:   Mon, 13 Dec 2021 21:08:54 +0300
Message-Id: <20211213180854.987473-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <163774098424117@kroah.com>
References: <163774098424117@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit d445aa402d60014a37a199fae2bba379696b007d.

Commit 723de0f9171e ("staging: most: remove device from interface
structure") moved registration of driver-provided struct device to
the most subsystem. This updated dim2 driver as well.

However, struct device passed to register_device() becomes refcounted,
and must not be explicitly deallocated, but must provide release method
instead. Which is incompatible with managing it via devres.

This patch makes the device structure allocated without devres, adds
device release method, and moves device destruction there.

Fixes: 723de0f9171e ("staging: most: remove device from interface structure")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Link: https://lore.kernel.org/r/20211005143448.8660-2-nikita.yoush@cogentembedded.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/most/dim2/dim2.c | 55 +++++++++++++++++---------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 8c2f384233aa..2fd6886f7728 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -723,6 +723,23 @@ static int get_dim2_clk_speed(const char *clock_speed, u8 *val)
 	return -EINVAL;
 }
 
+static void dim2_release(struct device *d)
+{
+	struct dim2_hdm *dev = container_of(d, struct dim2_hdm, dev);
+	unsigned long flags;
+
+	kthread_stop(dev->netinfo_task);
+
+	spin_lock_irqsave(&dim_lock, flags);
+	dim_shutdown();
+	spin_unlock_irqrestore(&dim_lock, flags);
+
+	if (dev->disable_platform)
+		dev->disable_platform(to_platform_device(d->parent));
+
+	kfree(dev);
+}
+
 /*
  * dim2_probe - dim2 probe handler
  * @pdev: platform device structure
@@ -743,7 +760,7 @@ static int dim2_probe(struct platform_device *pdev)
 
 	enum { MLB_INT_IDX, AHB0_INT_IDX };
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
@@ -755,25 +772,27 @@ static int dim2_probe(struct platform_device *pdev)
 				      "microchip,clock-speed", &clock_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "missing dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	ret = get_dim2_clk_speed(clock_speed, &dev->clk_speed);
 	if (ret) {
 		dev_err(&pdev->dev, "bad dt property clock-speed\n");
-		return ret;
+		goto err_free_dev;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->io_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dev->io_base))
-		return PTR_ERR(dev->io_base);
+	if (IS_ERR(dev->io_base)) {
+		ret = PTR_ERR(dev->io_base);
+		goto err_free_dev;
+	}
 
 	of_id = of_match_node(dim2_of_match, pdev->dev.of_node);
 	pdata = of_id->data;
 	ret = pdata && pdata->enable ? pdata->enable(pdev) : 0;
 	if (ret)
-		return ret;
+		goto err_free_dev;
 
 	dev->disable_platform = pdata ? pdata->disable : NULL;
 
@@ -864,24 +883,19 @@ static int dim2_probe(struct platform_device *pdev)
 	dev->most_iface.request_netinfo = request_netinfo;
 	dev->most_iface.driver_dev = &pdev->dev;
 	dev->most_iface.dev = &dev->dev;
-	dev->dev.init_name = "dim2_state";
+	dev->dev.init_name = dev->name;
 	dev->dev.parent = &pdev->dev;
+	dev->dev.release = dim2_release;
 
-	ret = most_register_interface(&dev->most_iface);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register MOST interface\n");
-		goto err_stop_thread;
-	}
-
-	return 0;
+	return most_register_interface(&dev->most_iface);
 
-err_stop_thread:
-	kthread_stop(dev->netinfo_task);
 err_shutdown_dim:
 	dim_shutdown();
 err_disable_platform:
 	if (dev->disable_platform)
 		dev->disable_platform(pdev);
+err_free_dev:
+	kfree(dev);
 
 	return ret;
 }
@@ -895,17 +909,8 @@ static int dim2_probe(struct platform_device *pdev)
 static int dim2_remove(struct platform_device *pdev)
 {
 	struct dim2_hdm *dev = platform_get_drvdata(pdev);
-	unsigned long flags;
 
 	most_deregister_interface(&dev->most_iface);
-	kthread_stop(dev->netinfo_task);
-
-	spin_lock_irqsave(&dim_lock, flags);
-	dim_shutdown();
-	spin_unlock_irqrestore(&dim_lock, flags);
-
-	if (dev->disable_platform)
-		dev->disable_platform(pdev);
 
 	return 0;
 }
-- 
2.30.2

