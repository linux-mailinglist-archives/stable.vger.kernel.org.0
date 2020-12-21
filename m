Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33642DFA20
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgLUIsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLUIsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:16 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147E1C0611CB
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:36 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id d8so8218712otq.6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JG8SIoKNNK7D2be1BMI076Sef2xNS4jk9wzXH8T6m48=;
        b=eNefK2PTjrZbUpgJAxXcfllArOX4/aNDRxl+9xF8GgsMa95UQE4FlbQnAR5anS6bhc
         NvT2X9rQ3oYTdr5/PdRCZZkm8RKtSEo7ksSOBZUWY+8QOy0e1ZePkBWbysADqkjWtmvp
         EbcsoMUNZHRGVX91hEHH0xs4WlW5/H7ILbwqqZ8vHG57UO7yKvT1rO5Qm+bmCk6tPBzL
         gEJnz3EFwmKdvJNWaJ4iAcI0MNZPGPREeh6XoKkioq2caFsx7BTV6nd41C8mjiE8HBXL
         3Y72E502r6kwCJamMBQaIhtiaddz7euonk8pThYqPG16Z1xIS+Feen+Fk4l6dWjjIPut
         bAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JG8SIoKNNK7D2be1BMI076Sef2xNS4jk9wzXH8T6m48=;
        b=YVaUsK2Ud2IquOOJSCyHnh9q4eq4JL+kNTwJE60HapcKs4EUBSLekri/39SsHLeiF5
         nOFas4RQ+JL2I/9/mMwyyJoGQB3M8d6nl0OFX/9MuBdgkgbRXnHKghLrpC2HyCj5R5wW
         W9X6grGLgwXijNbshDQr2ByYeyt0A3psxPrRZTpPV1FZ8vqhdewBbtvWgWLAUqeGNxCv
         0WR3hTOHjd0g3dpaWKTc+G6o5QXI1GZS5GUV5xd9UASDMM4pCiaafzdM8/uliL7Xi2uS
         2hTEpM+nGKadKudwL+wIFuH6MGxZnij4vadOXrKSvDUM/7pjtnIFPhzJE6aAzmPuzY6t
         PECg==
X-Gm-Message-State: AOAM531qsnabyt6SkwqXKRuujhS6Ar0Sk0uNTjDdCzcTcbypwtYYPbLs
        sNTPg920nrVR8UdSSOgOe5w=
X-Google-Smtp-Source: ABdhPJwmPVeth6IQdVR3uWQ9RqxAdEJBYySFZzgDnbRZtLzLz2NBSVcVD0AeBwqHmxFq0QiMSobG0g==
X-Received: by 2002:a9d:38e:: with SMTP id f14mr11324387otf.201.1608540455525;
        Mon, 21 Dec 2020 00:47:35 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:35 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 05/14] Revert "serial: uartps: Register own uart console and driver structures"
Date:   Mon, 21 Dec 2020 02:47:10 -0600
Message-Id: <1608540439-28772-6-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 18cc7ac8a28e28cd005c2475f52576cfe10cabfb upstream.

This reverts commit 024ca329bfb9a948f76eaff3243e21b7e70182f2.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1ee35667e36a8efddee381df5fe495ad65f4d15c.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 95 ++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index e7b8cb9..7a9b360 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -27,6 +27,7 @@
 #define CDNS_UART_TTY_NAME	"ttyPS"
 #define CDNS_UART_NAME		"xuartps"
 #define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_MINOR		0	/* works best with devtmpfs */
 #define CDNS_UART_NR_PORTS	16
 #define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
 #define CDNS_UART_REGISTER_SPACE	0x1000
@@ -1144,6 +1145,8 @@ static const struct uart_ops cdns_uart_ops = {
 #endif
 };
 
+static struct uart_driver cdns_uart_uart_driver;
+
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
  * cdns_uart_console_putchar - write the character to the FIFO buffer
@@ -1283,6 +1286,16 @@ static int cdns_uart_console_setup(struct console *co, char *options)
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
+
+static struct console cdns_uart_console = {
+	.name	= CDNS_UART_TTY_NAME,
+	.write	= cdns_uart_console_write,
+	.device	= uart_console_device,
+	.setup	= cdns_uart_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1, /* Specified on the cmdline (e.g. console=ttyPS ) */
+	.data	= &cdns_uart_uart_driver,
+};
 #endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
 
 #ifdef CONFIG_PM_SLEEP
@@ -1414,6 +1427,9 @@ static const struct of_device_id cdns_uart_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
+/* Temporary variable for storing number of instances */
+static int instances;
+
 /**
  * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
@@ -1427,11 +1443,6 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct cdns_uart *cdns_uart_data;
 	const struct of_device_id *match;
-	struct uart_driver *cdns_uart_uart_driver;
-	char *driver_name;
-#ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	struct console *cdns_uart_console;
-#endif
 
 	cdns_uart_data = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_data),
 			GFP_KERNEL);
@@ -1441,12 +1452,6 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	if (!port)
 		return -ENOMEM;
 
-	cdns_uart_uart_driver = devm_kzalloc(&pdev->dev,
-					     sizeof(*cdns_uart_uart_driver),
-					     GFP_KERNEL);
-	if (!cdns_uart_uart_driver)
-		return -ENOMEM;
-
 	/* Look for a serialN alias */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (id < 0)
@@ -1457,50 +1462,25 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	/* There is a need to use unique driver name */
-	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
-				     CDNS_UART_NAME, id);
-	if (!driver_name)
-		return -ENOMEM;
-
-	cdns_uart_uart_driver->owner = THIS_MODULE;
-	cdns_uart_uart_driver->driver_name = driver_name;
-	cdns_uart_uart_driver->dev_name	= CDNS_UART_TTY_NAME;
-	cdns_uart_uart_driver->major = CDNS_UART_MAJOR;
-	cdns_uart_uart_driver->minor = id;
-	cdns_uart_uart_driver->nr = 1;
-
+	if (!cdns_uart_uart_driver.state) {
+		cdns_uart_uart_driver.owner = THIS_MODULE;
+		cdns_uart_uart_driver.driver_name = CDNS_UART_NAME;
+		cdns_uart_uart_driver.dev_name = CDNS_UART_TTY_NAME;
+		cdns_uart_uart_driver.major = CDNS_UART_MAJOR;
+		cdns_uart_uart_driver.minor = CDNS_UART_MINOR;
+		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	cdns_uart_console = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_console),
-					 GFP_KERNEL);
-	if (!cdns_uart_console)
-		return -ENOMEM;
-
-	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
-		sizeof(cdns_uart_console->name));
-	cdns_uart_console->index = id;
-	cdns_uart_console->write = cdns_uart_console_write;
-	cdns_uart_console->device = uart_console_device;
-	cdns_uart_console->setup = cdns_uart_console_setup;
-	cdns_uart_console->flags = CON_PRINTBUFFER;
-	cdns_uart_console->data = cdns_uart_uart_driver;
-	cdns_uart_uart_driver->cons = cdns_uart_console;
+		cdns_uart_uart_driver.cons = &cdns_uart_console;
 #endif
 
-	rc = uart_register_driver(cdns_uart_uart_driver);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "Failed to register driver\n");
-		return rc;
+		rc = uart_register_driver(&cdns_uart_uart_driver);
+		if (rc < 0) {
+			dev_err(&pdev->dev, "Failed to register driver\n");
+			return rc;
+		}
 	}
 
-	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
-
-	/*
-	 * Setting up proper name_base needs to be done after uart
-	 * registration because tty_driver structure is not filled.
-	 * name_base is 0 by default.
-	 */
-	cdns_uart_uart_driver->tty_driver->name_base = id;
+	cdns_uart_data->cdns_uart_driver = &cdns_uart_uart_driver;
 
 	match = of_match_node(cdns_uart_of_match, pdev->dev.of_node);
 	if (match && match->data) {
@@ -1578,6 +1558,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	port->ops	= &cdns_uart_ops;
 	port->fifosize	= CDNS_UART_FIFO_SIZE;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_XILINX_PS_UART_CONSOLE);
+	port->line	= id;
 
 	/*
 	 * Register the port.
@@ -1609,7 +1590,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		console_port = port;
 #endif
 
-	rc = uart_add_one_port(cdns_uart_uart_driver, port);
+	rc = uart_add_one_port(&cdns_uart_uart_driver, port);
 	if (rc) {
 		dev_err(&pdev->dev,
 			"uart_add_one_port() failed; err=%i\n", rc);
@@ -1619,12 +1600,15 @@ static int cdns_uart_probe(struct platform_device *pdev)
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 	/* This is not port which is used for console that's why clean it up */
 	if (console_port == port &&
-	    !(cdns_uart_uart_driver->cons->flags & CON_ENABLED))
+	    !(cdns_uart_uart_driver.cons->flags & CON_ENABLED))
 		console_port = NULL;
 #endif
 
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
+
+	instances++;
+
 	return 0;
 
 err_out_pm_disable:
@@ -1640,8 +1624,8 @@ static int cdns_uart_probe(struct platform_device *pdev)
 err_out_clk_dis_pclk:
 	clk_disable_unprepare(cdns_uart_data->pclk);
 err_out_unregister_driver:
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-
+	if (!instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 
@@ -1676,7 +1660,8 @@ static int cdns_uart_remove(struct platform_device *pdev)
 		console_port = NULL;
 #endif
 
-	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
+	if (!--instances)
+		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
 
-- 
2.7.4

