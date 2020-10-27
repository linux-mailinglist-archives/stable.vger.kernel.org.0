Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863D929AD7A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752308AbgJ0NgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:36:13 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52603 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752315AbgJ0NgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:36:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8AB9910E3;
        Tue, 27 Oct 2020 09:36:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 27 Oct 2020 09:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jtspPd
        ica1o9/gdPCB1RQODh62zKyHxQM+EJ84IQIXI=; b=AkHJYLSUYHZmc/j6DKLqDs
        c1oTs0iipDlwbqziGO/8deRPlVzpnoPq7VRJHteBT7ajHgR28cQI16Dahsesm89S
        71MsDISIy+cFVrO4fcpN/MUYmVkSYOda0KreD3TPd/H57JMcXfbPZeiC2MGeHIEL
        Pjmy474Kij2jEpErXj/zeB+FFqLBcW+mxz1+WQZrO/HoOgsMMtRbOlv996zYmMM3
        nAOYEZdmi9e1UNNzm2j5VnYC+q+AxuiO8emP4FTKITRQxeDdsMHLi6iVW740njv0
        vODninnC5yvRJXGFh0szc8u/FWxsxHxHUaZuHl3XOJ2el0f6qMxeLl7hGb7iqo6w
        ==
X-ME-Sender: <xms:SiKYX42urO0ElyAZ7KF0vdfusCY5Qu1C0Xb8uEZ_lnFOOi7FUMcgbw>
    <xme:SiKYXzEcS8_TkomkjWWdwBtNkuix9i-4hqVzEfMW9YRB0Syc8ys0aCRtaHhV8KbGh
    RFQN_1zMVw_6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SiKYXw5f2zCXyi_bLwiYHBkItdVyyU3r95IlVSDtcFoRA2zW7nn0TQ>
    <xmx:SiKYXx15me6ajycv83ip82rMtMKF3hZRM006OCtP21PTXym3ERQ9HQ>
    <xmx:SiKYX7FjKINCUw6qtm5a4kvw9XA6Wc2CUqdcMoxfv4zMqRhxNOKeMA>
    <xmx:SyKYX-MPpCNgtrt1AYIV8yOQW_U-5TVYZLIjQNiUGCwIeenPqm9FqK3953o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F4473064680;
        Tue, 27 Oct 2020 09:36:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: serial: lpuart: fix lpuart32_write usage" failed to apply to 4.14-stable tree
To:     peng.fan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 14:37:01 +0100
Message-ID: <160380582192232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9ea40db477c024dcb87321b7f32bd6ea12130ac2 Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Tue, 29 Sep 2020 17:19:20 +0800
Subject: [PATCH] tty: serial: lpuart: fix lpuart32_write usage

The 2nd and 3rd parameter were wrongly used, and cause kernel abort when
doing kgdb debug.

Fixes: 1da17d7cf8e2 ("tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929091920.22612-1-peng.fan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 5a5a22d77841..645bbb24b433 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -649,26 +649,24 @@ static int lpuart32_poll_init(struct uart_port *port)
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	/* Disable Rx & Tx */
-	lpuart32_write(&sport->port, UARTCTRL, 0);
+	lpuart32_write(&sport->port, 0, UARTCTRL);
 
 	temp = lpuart32_read(&sport->port, UARTFIFO);
 
 	/* Enable Rx and Tx FIFO */
-	lpuart32_write(&sport->port, UARTFIFO,
-		       temp | UARTFIFO_RXFE | UARTFIFO_TXFE);
+	lpuart32_write(&sport->port, temp | UARTFIFO_RXFE | UARTFIFO_TXFE, UARTFIFO);
 
 	/* flush Tx and Rx FIFO */
-	lpuart32_write(&sport->port, UARTFIFO,
-		       UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH);
+	lpuart32_write(&sport->port, UARTFIFO_TXFLUSH | UARTFIFO_RXFLUSH, UARTFIFO);
 
 	/* explicitly clear RDRF */
 	if (lpuart32_read(&sport->port, UARTSTAT) & UARTSTAT_RDRF) {
 		lpuart32_read(&sport->port, UARTDATA);
-		lpuart32_write(&sport->port, UARTFIFO, UARTFIFO_RXUF);
+		lpuart32_write(&sport->port, UARTFIFO_RXUF, UARTFIFO);
 	}
 
 	/* Enable Rx and Tx */
-	lpuart32_write(&sport->port, UARTCTRL, UARTCTRL_RE | UARTCTRL_TE);
+	lpuart32_write(&sport->port, UARTCTRL_RE | UARTCTRL_TE, UARTCTRL);
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return 0;
@@ -677,7 +675,7 @@ static int lpuart32_poll_init(struct uart_port *port)
 static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 {
 	lpuart32_wait_bit_set(port, UARTSTAT, UARTSTAT_TDRE);
-	lpuart32_write(port, UARTDATA, c);
+	lpuart32_write(port, c, UARTDATA);
 }
 
 static int lpuart32_poll_get_char(struct uart_port *port)

