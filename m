Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1AD2DFA1D
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgLUIsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgLUIsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:14 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA48C061257
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:33 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id 15so10582076oix.8
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5tyO3gOAdAop7FeEMTkXw2r4S17bIEhF+dVP7aebCoo=;
        b=Dh9b0y46sZGVv2TqnYZb5Zx0Qhu/aaidUSX9mSHROEZPYzw0qQPg5QNsDJWF/rOwFh
         ly9wItBUuWRXmjk6UnCRt+kJ8goYZuolrxWKT00Ja01DNHXZp7D4wUXmkNrx4O4AqGRt
         TaPQUtobhQ1KEnfo+T75Zp0VBv9MGEjUQ7WB0HFwP8goc5NteZpTSZr0KbWczY1Dy/vt
         Vy7RqkEuhfXnENrqV1rQe9AOHj7Xd4FLSshaN4NjqwHn5uP2cijHBWICtLw7xNqUdL2I
         mogRGoFHom/+YXnV85lzIvC0ucEmoA1ofp226pwlmYUAKk4rJCnY5b/Lr/HWo0D+h1A8
         NWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5tyO3gOAdAop7FeEMTkXw2r4S17bIEhF+dVP7aebCoo=;
        b=JvpRvnCg++eQYbEoDMVIcK2VBKQ/5exAKSRsExeOvoS7sJxrKqJwEOu0PffZd96z4H
         StyaaQbptQsmlyb55dwqkVySsMB8ucPaMZs8PgOlF1wUaIF2bjxbMZ6fNnLUuw6GamD8
         MQEJijP7DI3bk9My2cFgo+4nhBWIc46mcAUamHrl51YmpLHyuT0UDNyFaP6YaN4jJaac
         uRwigrV+CDKy4SEht8PPk0//qF7nsWf+lPmPyGio5BEA2jgGZE14kOSblpkG2JFAPXGk
         JSgn+rwv6dAugQ9btoltz7LwtACwJektvqdRP62kRQuUg+U4L/qfBoDlJT8g8y7zT9pb
         M0Hg==
X-Gm-Message-State: AOAM531Jk3p7grif1zi9bGj8fLovyR7wsOm2s/5bYf8RXM1MWu2N+w0C
        80hC67oHcNb0ieYSHtQcxC8=
X-Google-Smtp-Source: ABdhPJyNX6p/VM5LfgRbb+sW5F26W2EIsOZE32+0/KGxKqZymIREZViPEnUWetdSraIC3Lskp7i9zQ==
X-Received: by 2002:aca:b707:: with SMTP id h7mr10490258oif.46.1608540453415;
        Mon, 21 Dec 2020 00:47:33 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:32 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 02/14] Revert "serial: uartps: Do not allow use aliases >= MAX_UART_INSTANCES"
Date:   Mon, 21 Dec 2020 02:47:07 -0600
Message-Id: <1608540439-28772-3-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 91c9dfa25c7f95b543c280e0edf1fd8de6e90985 upstream.

This reverts commit 2088cfd882d0403609bdf426e9b24372fe1b8337.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/dac3898e3e32d963f357fb436ac9a7ac3cbcf933.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index f9297ee..d1d889d 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1724,8 +1724,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 err_out_id:
 	mutex_lock(&bitmap_lock);
-	if (cdns_uart_data->id < MAX_UART_INSTANCES)
-		clear_bit(cdns_uart_data->id, bitmap);
+	clear_bit(cdns_uart_data->id, bitmap);
 	mutex_unlock(&bitmap_lock);
 	return rc;
 }
@@ -1750,8 +1749,7 @@ static int cdns_uart_remove(struct platform_device *pdev)
 	rc = uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
 	port->mapbase = 0;
 	mutex_lock(&bitmap_lock);
-	if (cdns_uart_data->id < MAX_UART_INSTANCES)
-		clear_bit(cdns_uart_data->id, bitmap);
+	clear_bit(cdns_uart_data->id, bitmap);
 	mutex_unlock(&bitmap_lock);
 	clk_disable_unprepare(cdns_uart_data->uartclk);
 	clk_disable_unprepare(cdns_uart_data->pclk);
-- 
2.7.4

