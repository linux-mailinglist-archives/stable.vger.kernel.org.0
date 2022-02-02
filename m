Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FA74A7910
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 20:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiBBT5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 14:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBBT5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 14:57:07 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7C6C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 11:57:07 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id d186so385287pgc.9
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 11:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZTT53hOvxzC4jRzgSFGGP6CGC7r44T776i787MRjwro=;
        b=ne/2NjGWQKO09LzxbY4/I+EBKjAqd2R4ZnZwvwZzLqZ3TYJ14fQVny3xFw3zU6Voj6
         7W8386rMlIZP2M3SiRQjl85xQ8CgdPSWCN9mZ8ctwuigvveFDENSRQnDSWJ7fMQ4wCP3
         F2hWzAbUXgM8CL3QQgWDfRWqzcYhxox/R1/Wl+79Bs6ZBwE4oIETBOINNwQ3sBcFUhWZ
         LxCl2dlnuXNj4h6K8DtnoldAtMvAgjKAsaWcV+M4pCXottAylrt7sm+4TndTQx6wKJBL
         92IMy1DyxOTQygijxffAi+XQ5tGlkqmWZiOjezkAb2EFReWC7SqddfEii8MU6hTztNva
         XZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZTT53hOvxzC4jRzgSFGGP6CGC7r44T776i787MRjwro=;
        b=IrzbqIYLowgQVBGMFi0COQabKONeIi4OnGtGvUV0WAngNiaf5cxYw1FztzPdrgz91F
         HM69jDH/GyggNJq4xD7LX6Q4vGzDqV2WVxuEbZco1ILeCT6TEgqcsVivKghce44iK8yz
         Ks/Llo4R86IupSmMNSbm+DnDUrSXOd/Aw8fCo4U1OV0HO8MPzYtT0K/pL+T9jKR+S91D
         Ekt8v0Xozkjc0lW99bsHxbvmxnGb8jQv4sjp/qZyFsVdyixIGUnOyZG8Z72bHYSLHmZy
         P5r9PvocZfk3i2DMxU8MlI9ABoc0IUyV3EGpbw8/wOUArOaMDGLi4KMTG0bD47CzYzJx
         ZE7Q==
X-Gm-Message-State: AOAM531cy0YfgC7XaWgG4x3jmSaHGIoKWlP2Lf4P6VwVd/e3MNtCoj4i
        kHRKGjhxOMQFzRfNhYJogVJ6eZ+NZYcYmw==
X-Google-Smtp-Source: ABdhPJzEzc5PevqW7UJBJRRoq4rSUTfzpOyiVtBgvO/p3joYfmzbLu9ry1IC2CWmikucZ9NuJ8I0Ng==
X-Received: by 2002:a05:6a00:1ac9:: with SMTP id f9mr29310066pfv.65.1643831826345;
        Wed, 02 Feb 2022 11:57:06 -0800 (PST)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id 202sm35862755pga.72.2022.02.02.11.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 11:57:05 -0800 (PST)
From:   Kevin Hilman <khilman@baylibre.com>
To:     stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>
Subject: [PATCH] Revert "drivers: bus: simple-pm-bus: Add support for probing simple bus only devices"
Date:   Wed,  2 Feb 2022 11:57:05 -0800
Message-Id: <20220202195705.3598798-1-khilman@baylibre.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d5f13bbb51046537b2c2b9868177fb8fe8a6a6e9.

This change related to fw_devlink was backported to v5.10 but has
severaly other dependencies that were not backported.  As discussed
with the original author, the best approach for v5.10 is to revert.

Link: https://lore.kernel.org/linux-omap/7hk0efmfzo.fsf@baylibre.com
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/bus/simple-pm-bus.c | 39 +------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/bus/simple-pm-bus.c b/drivers/bus/simple-pm-bus.c
index 244b8f3b38b4..c5eb46cbf388 100644
--- a/drivers/bus/simple-pm-bus.c
+++ b/drivers/bus/simple-pm-bus.c
@@ -16,33 +16,7 @@
 
 static int simple_pm_bus_probe(struct platform_device *pdev)
 {
-	const struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
-	const struct of_device_id *match;
-
-	/*
-	 * Allow user to use driver_override to bind this driver to a
-	 * transparent bus device which has a different compatible string
-	 * that's not listed in simple_pm_bus_of_match. We don't want to do any
-	 * of the simple-pm-bus tasks for these devices, so return early.
-	 */
-	if (pdev->driver_override)
-		return 0;
-
-	match = of_match_device(dev->driver->of_match_table, dev);
-	/*
-	 * These are transparent bus devices (not simple-pm-bus matches) that
-	 * have their child nodes populated automatically.  So, don't need to
-	 * do anything more. We only match with the device if this driver is
-	 * the most specific match because we don't want to incorrectly bind to
-	 * a device that has a more specific driver.
-	 */
-	if (match && match->data) {
-		if (of_property_match_string(np, "compatible", match->compatible) == 0)
-			return 0;
-		else
-			return -ENODEV;
-	}
+	struct device_node *np = pdev->dev.of_node;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
@@ -56,25 +30,14 @@ static int simple_pm_bus_probe(struct platform_device *pdev)
 
 static int simple_pm_bus_remove(struct platform_device *pdev)
 {
-	const void *data = of_device_get_match_data(&pdev->dev);
-
-	if (pdev->driver_override || data)
-		return 0;
-
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
-#define ONLY_BUS	((void *) 1) /* Match if the device is only a bus. */
-
 static const struct of_device_id simple_pm_bus_of_match[] = {
 	{ .compatible = "simple-pm-bus", },
-	{ .compatible = "simple-bus",	.data = ONLY_BUS },
-	{ .compatible = "simple-mfd",	.data = ONLY_BUS },
-	{ .compatible = "isa",		.data = ONLY_BUS },
-	{ .compatible = "arm,amba-bus",	.data = ONLY_BUS },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, simple_pm_bus_of_match);
-- 
2.34.0

