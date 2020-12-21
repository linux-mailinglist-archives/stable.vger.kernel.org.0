Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1C2DFA1E
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgLUIsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLUIsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:14 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ED1C0611C5
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:34 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a109so8238092otc.1
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jfEy6OA7Jpnp8cSsusvCd4sjnDQSeNnNzB3FZXduis8=;
        b=BQuPQn1zKXlLW+WGq78h3CvAeOpll+co+8Me5JZF23tKdKWeGgzZ5wneqgsolrqkQ7
         h8h+9Rgz8IBOAqXfFUDrI/sJXVjM5c7y8QLl+5QJIhBTtQ/d+zuA1BCp2sCODklSIYIX
         LRe140SnDLso7N5Bki84ZhBjsLiS/pA63dke3Xgplsf28ZYhmavwl1k9uIAn+GdVp1jp
         IlhRYozdLUMya9xkO6sKdWpPfVeMhcbJb8XVHXPThns8+pjmEQu3fjAgPZFfhRARyUea
         wqXLgobaSSfUTc3dj20sarLMX0jkSE0ldNrA65hQSBKi+q+Q8YctibxCHi9/VhQSmsxB
         0U6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jfEy6OA7Jpnp8cSsusvCd4sjnDQSeNnNzB3FZXduis8=;
        b=N0wKOqoYGbwKVBP0pY27VimTFDKe40NTrG03XVf22HhQWiMUdv7zyaHRD93Macm4DZ
         zqD+WukzH/KMkPh2ZLYkBeAEHNRykgEtcn+HZIYXb/E8rk2ubcRPweef03a0UgRUfsiQ
         Ay4EpqOL/vDXox4xA5NdvRp177u8BZe4sO4jsd3ElZY1zPZX1piOxGPCATc6X75Y2KCz
         6S/n4jHBCsw7cNeU+Guq2I6X4Vy+lfLHS29S1szEsTo9i8M8JLfaLAcVN/XgHoofDKHD
         JQ8EySQkxfyulY1+aclR2FbhceO824awknln4gWvGCRx/le5JpsowAkn5Pl595JbrDvg
         l9TQ==
X-Gm-Message-State: AOAM53251fY49nTWQsVBJJfl5vza1WpITwCk1ZLrZROdgtgLoNnSFL0m
        6h9pSKvlr8MaGaGVpZlKX2datg2e5SE8eeeL
X-Google-Smtp-Source: ABdhPJxNrgPeIkgBRAGYoikYvFFRnylLm5HcPxEmzJQyU/aUxcTcnEpf7TI3ohvf+V3Qyr9Qfp+84w==
X-Received: by 2002:a05:6830:1349:: with SMTP id r9mr11391643otq.256.1608540454138;
        Mon, 21 Dec 2020 00:47:34 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:33 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 03/14] Revert "serial: uartps: Change uart ID port allocation"
Date:   Mon, 21 Dec 2020 02:47:08 -0600
Message-Id: <1608540439-28772-4-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 72d68197281e2ad313960504d10b0c41ff87fd55 upstream.

This reverts commit ae1cca3fa3478be92948dbbcd722390272032ade.

With setting up NR_PORTS to 16 to be able to use serial2 and higher
aliases and don't loose functionality which was intended by these changes.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a94931b65ce0089f76fb1fe6b446a08731bff754.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 111 +++++--------------------------------
 1 file changed, 13 insertions(+), 98 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index d1d889d..3b497f3 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -27,6 +27,7 @@
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
 #define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_NR_PORTS	16
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
 #define TX_TIMEOUT		500000
@@ -1415,90 +1416,6 @@ static const struct of_device_id cdns_uart_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
-/*
- * Maximum number of instances without alias IDs but if there is alias
- * which target "< MAX_UART_INSTANCES" range this ID can't be used.
- */
-#define MAX_UART_INSTANCES	32
-
-/* Stores static aliases list */
-static DECLARE_BITMAP(alias_bitmap, MAX_UART_INSTANCES);
-static int alias_bitmap_initialized;
-
-/* Stores actual bitmap of allocated IDs with alias IDs together */
-static DECLARE_BITMAP(bitmap, MAX_UART_INSTANCES);
-/* Protect bitmap operations to have unique IDs */
-static DEFINE_MUTEX(bitmap_lock);
-
-static int cdns_get_id(struct platform_device *pdev)
-{
-	int id, ret;
-
-	mutex_lock(&bitmap_lock);
-
-	/* Alias list is stable that's why get alias bitmap only once */
-	if (!alias_bitmap_initialized) {
-		ret = of_alias_get_alias_list(cdns_uart_of_match, "serial",
-					      alias_bitmap, MAX_UART_INSTANCES);
-		if (ret && ret != -EOVERFLOW) {
-			mutex_unlock(&bitmap_lock);
-			return ret;
-		}
-
-		alias_bitmap_initialized++;
-	}
-
-	/* Make sure that alias ID is not taken by instance without alias */
-	bitmap_or(bitmap, bitmap, alias_bitmap, MAX_UART_INSTANCES);
-
-	dev_dbg(&pdev->dev, "Alias bitmap: %*pb\n",
-		MAX_UART_INSTANCES, bitmap);
-
-	/* Look for a serialN alias */
-	id = of_alias_get_id(pdev->dev.of_node, "serial");
-	if (id < 0) {
-		dev_warn(&pdev->dev,
-			 "No serial alias passed. Using the first free id\n");
-
-		/*
-		 * Start with id 0 and check if there is no serial0 alias
-		 * which points to device which is compatible with this driver.
-		 * If alias exists then try next free position.
-		 */
-		id = 0;
-
-		for (;;) {
-			dev_info(&pdev->dev, "Checking id %d\n", id);
-			id = find_next_zero_bit(bitmap, MAX_UART_INSTANCES, id);
-
-			/* No free empty instance */
-			if (id == MAX_UART_INSTANCES) {
-				dev_err(&pdev->dev, "No free ID\n");
-				mutex_unlock(&bitmap_lock);
-				return -EINVAL;
-			}
-
-			dev_dbg(&pdev->dev, "The empty id is %d\n", id);
-			/* Check if ID is empty */
-			if (!test_and_set_bit(id, bitmap)) {
-				/* Break the loop if bit is taken */
-				dev_dbg(&pdev->dev,
-					"Selected ID %d allocation passed\n",
-					id);
-				break;
-			}
-			dev_dbg(&pdev->dev,
-				"Selected ID %d allocation failed\n", id);
-			/* if taking bit fails then try next one */
-			id++;
-		}
-	}
-
-	mutex_unlock(&bitmap_lock);
-
-	return id;
-}
-
 /**
  * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
@@ -1532,17 +1449,21 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	if (!cdns_uart_uart_driver)
 		return -ENOMEM;
 
-	cdns_uart_data->id = cdns_get_id(pdev);
+	/* Look for a serialN alias */
+	cdns_uart_data->id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (cdns_uart_data->id < 0)
-		return cdns_uart_data->id;
+		cdns_uart_data->id = 0;
+
+	if (cdns_uart_data->id >= CDNS_UART_NR_PORTS) {
+		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
+		return -ENODEV;
+	}
 
 	/* There is a need to use unique driver name */
 	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
 				     CDNS_UART_NAME, cdns_uart_data->id);
-	if (!driver_name) {
-		rc = -ENOMEM;
-		goto err_out_id;
-	}
+	if (!driver_name)
+		return -ENOMEM;
 
 	cdns_uart_uart_driver->owner = THIS_MODULE;
 	cdns_uart_uart_driver->driver_name = driver_name;
@@ -1571,7 +1492,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	rc = uart_register_driver(cdns_uart_uart_driver);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Failed to register driver\n");
-		goto err_out_id;
+		return rc;
 	}
 
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
@@ -1722,10 +1643,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	clk_disable_unprepare(cdns_uart_data->pclk);
 err_out_unregister_driver:
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-err_out_id:
-	mutex_lock(&bitmap_lock);
-	clear_bit(cdns_uart_data->id, bitmap);
-	mutex_unlock(&bitmap_lock);
+
 	return rc;
 }
 
@@ -1748,9 +1666,6 @@ static int cdns_uart_remove(struct platform_device *pdev)
 #endif
 	rc = uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
 	port->mapbase = 0;
-	mutex_lock(&bitmap_lock);
-	clear_bit(cdns_uart_data->id, bitmap);
-	mutex_unlock(&bitmap_lock);
 	clk_disable_unprepare(cdns_uart_data->uartclk);
 	clk_disable_unprepare(cdns_uart_data->pclk);
 	pm_runtime_disable(&pdev->dev);
-- 
2.7.4

