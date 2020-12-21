Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863132DFA1F
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgLUIsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLUIsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:15 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B42C0611CA
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:35 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id q25so8193391otn.10
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uy0Lfp6m3Dd5zVtzkp9DaTD9/xutDJouxGZqrA/B3+I=;
        b=jO1LlZxmNIqylRjroAyPMfRv1iXZ+pG6vVPbIuEZwgScL6gVNmiOG3qg3BsN2hCt6g
         TmF1oXnC4jnnz3ttK/9MK38Zwwvbnu8Yw0FS0h9eUgYZPBJXuLk3J8VbtqMbYjtyjqni
         5k9ywjrD2YX9GOha+8bfY+RhH55q6xIMX2YhY0BTUEku3BcvsooUyt1xQlLvtcEIfeyv
         XGvWuqNE301dah6e4QDuI0/zsei6eMjKMA1ymYQJ07dEeF8tLEHe+YEEkdaAqxCGZsz5
         HX1YRq1H7rJnjrdhkYRXDLsIt8FOxMvznp4HlUohBcp+IlAZyPVv+OK5X0cAGExXiTP7
         DEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uy0Lfp6m3Dd5zVtzkp9DaTD9/xutDJouxGZqrA/B3+I=;
        b=cTcJJFJHnXohnZzJI9gldReTvOJhXY+wyiDAbqov2e2T/XQqkxqA0aoiPFhsEjZZjJ
         21sHuJSQDChWpRqgeScB5T/zy9KN6UfeCs4JDRt8BzBw8OUeZUPEj2phCLxqI5S6L5PO
         iBKQVDt30PmeTSIhA5B3R6c/LrB3nCpzLFW+adkU3P9GL7tkUtyNh6HJqbhNbpCREJ0Z
         LxUiBdhpQOLwU8cseITASq48g/N/SR7hXLsMmmKyhyOizo3lMI3pGiFLNZlU22AHXXWg
         go1Wc3U3W1WU+GWC2filSe9+eW7nykxLGJfek7FE/hDRPstWhvEwHC55Ykf/cFGNtAvC
         jpcg==
X-Gm-Message-State: AOAM530XiKp/wGR8UTvvK8+Tsm0fN/Iy0Xs0N0krqjGPC4j56GXB1S7s
        pMhiqYJTY3BwPnKvDjstmJ9JuFDqN64sUiZV
X-Google-Smtp-Source: ABdhPJz2seBIgV0CgTHGWIp3cy3xuuouJ14POvoaFtUW0pnv2PgCHJELPsuxzyA1E5pwRODrj2HL/g==
X-Received: by 2002:a9d:17cb:: with SMTP id j69mr9749873otj.6.1608540454809;
        Mon, 21 Dec 2020 00:47:34 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:34 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 04/14] Revert "serial: uartps: Move Port ID to device data structure"
Date:   Mon, 21 Dec 2020 02:47:09 -0600
Message-Id: <1608540439-28772-5-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 492cc08bc16c44e2e587362ada3f6269dee2be22 upstream.

This reverts commit bed25ac0e2b6ab8f9aed2d20bc9c3a2037311800.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/eb0ec98fecdca9b79c1a3ac0c30c668b6973b193.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 3b497f3..e7b8cb9 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -189,7 +189,6 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
  * @pclk:		APB clock
  * @cdns_uart_driver:	Pointer to UART driver
  * @baud:		Current baud rate
- * @id:			Port ID
  * @clk_rate_change_nb:	Notifier block for clock changes
  * @quirks:		Flags for RXBS support.
  */
@@ -199,7 +198,6 @@ struct cdns_uart {
 	struct clk		*pclk;
 	struct uart_driver	*cdns_uart_driver;
 	unsigned int		baud;
-	int			id;
 	struct notifier_block	clk_rate_change_nb;
 	u32			quirks;
 	bool cts_override;
@@ -1424,7 +1422,7 @@ MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
  */
 static int cdns_uart_probe(struct platform_device *pdev)
 {
-	int rc, irq;
+	int rc, id, irq;
 	struct uart_port *port;
 	struct resource *res;
 	struct cdns_uart *cdns_uart_data;
@@ -1450,18 +1448,18 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* Look for a serialN alias */
-	cdns_uart_data->id = of_alias_get_id(pdev->dev.of_node, "serial");
-	if (cdns_uart_data->id < 0)
-		cdns_uart_data->id = 0;
+	id = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (id < 0)
+		id = 0;
 
-	if (cdns_uart_data->id >= CDNS_UART_NR_PORTS) {
+	if (id >= CDNS_UART_NR_PORTS) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
 		return -ENODEV;
 	}
 
 	/* There is a need to use unique driver name */
 	driver_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s%d",
-				     CDNS_UART_NAME, cdns_uart_data->id);
+				     CDNS_UART_NAME, id);
 	if (!driver_name)
 		return -ENOMEM;
 
@@ -1469,7 +1467,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	cdns_uart_uart_driver->driver_name = driver_name;
 	cdns_uart_uart_driver->dev_name	= CDNS_UART_TTY_NAME;
 	cdns_uart_uart_driver->major = CDNS_UART_MAJOR;
-	cdns_uart_uart_driver->minor = cdns_uart_data->id;
+	cdns_uart_uart_driver->minor = id;
 	cdns_uart_uart_driver->nr = 1;
 
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
@@ -1480,7 +1478,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 
 	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
 		sizeof(cdns_uart_console->name));
-	cdns_uart_console->index = cdns_uart_data->id;
+	cdns_uart_console->index = id;
 	cdns_uart_console->write = cdns_uart_console_write;
 	cdns_uart_console->device = uart_console_device;
 	cdns_uart_console->setup = cdns_uart_console_setup;
@@ -1502,7 +1500,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	 * registration because tty_driver structure is not filled.
 	 * name_base is 0 by default.
 	 */
-	cdns_uart_uart_driver->tty_driver->name_base = cdns_uart_data->id;
+	cdns_uart_uart_driver->tty_driver->name_base = id;
 
 	match = of_match_node(cdns_uart_of_match, pdev->dev.of_node);
 	if (match && match->data) {
-- 
2.7.4

