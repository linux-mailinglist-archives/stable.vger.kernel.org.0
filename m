Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861AF29AD79
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752322AbgJ0NgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:36:16 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47521 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752315AbgJ0NgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 09:36:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7680C10DB;
        Tue, 27 Oct 2020 09:36:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 27 Oct 2020 09:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xZHtJh
        VvhKAHfXmFrOtVPOxd5mNDjOzXUmLd9zHIlmc=; b=EeIjE7s6psp0d9QQq5dm8T
        HokUSi35DepQRrp3lflt+Exfq3tlJNW7Uk4Zw1lzynqZ5zqy4+h7JWYoSuGBOyGj
        UUFORtrcYBoFXSxVOcM60MTDRgigx9sdk8mEBGPXOJbjdH69XFbHXbfGnpDBA6Z5
        T04KBApyw24vKroyNLcv4DOuBFGCr9AVYptiTVebdyW+bJDrHl0FoGhHo87sBpie
        uRbWoq0l0fo7XdaXm7Lo8F7+PeKS6rm9UGLc0ZG7u8RPUaq3mF6c2Y8UeJ3F8l6U
        qkMKSmdhxWe9Tabug0rnzyOhoRbUWDn/rPxHqLOJLtlwHO0pXgpo1Ij8SVGwTB/Q
        ==
X-ME-Sender: <xms:TiKYX1QNElM2sVto2_2n0Wwahcne7wHSmIWdDCcp8nWbXPu3E0x0mQ>
    <xme:TiKYX-xADwBxAPpXAo_Fd5ip2x0reKy_utfa3seX8gcSOqMgrSEyB4S6xBjVGZgjz
    fzxpJykFmmPKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkeelgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TyKYX60EwzPUigjOhP0YTbseh4iwSm0wUWtvV8nCqtWsBAnLt-DTaQ>
    <xmx:TyKYX9DXm9reXMWGFUhbXcdJEyyoGPuKTqqZ9fguO3MvS4okpwRQmQ>
    <xmx:TyKYX-iHQ6hAnrC_MYR6sGba-9ILh8Wn1BKfu4vM_YduNpN-j0Tj1g>
    <xmx:TyKYX2IqWRTW3TvGs5OCapHYMmoI-i-d587PtAbA2AkbKDh79pfxjkfd6Q4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E003328005E;
        Tue, 27 Oct 2020 09:36:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: serial: lpuart: fix lpuart32_write usage" failed to apply to 4.19-stable tree
To:     peng.fan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Oct 2020 14:37:01 +0100
Message-ID: <1603805821617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

