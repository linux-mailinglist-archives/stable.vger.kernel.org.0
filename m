Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F250F12C323
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfL2PqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:13 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47251 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2PqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3645741A;
        Sun, 29 Dec 2019 10:46:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=b7copE
        x/iJwS/FhjYCY4i465tHxW/jmSBtM+701HIq8=; b=qy8LUoekfnXL2zhDZ8BTyj
        FbDwMxRTbEofxwD1Q4PJIv8ZOrYIkzrhNuyDrfc9QGFzVoMIwB9HR1guWv3GaODB
        lHKTf2a3shbSXiSVaMKy8Kk/c4Y9RdinBfNzVyMf7TvCx8x8GSjuC8EWpULiPtLP
        v1R71CNG4KAd9xXXbscI/0jrvWovMoUPqKSOQOtDe9qq8vgr3w+0qGxMaDLQZrWY
        V3OAh//QoodvST4Pp/uMxox1fVDQfVnHAmCt2UA63crmhflTS/V+OQwNxLIQjQI6
        zPbM+XT/CQJwNihKcU/HFVY7BrGX4CIF1E7C85denD3RWiGRLliDMQjrM7kO1umg
        ==
X-ME-Sender: <xms:Q8oIXgMaCd7UzmoVwUKfaTVS2J1Zszw5iKByk73BAUZP-guEsG0sYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:Q8oIXiX47-ifdUK3r_JgNwqjmj-lIOk71LuGk_X_n6Tg2DKcnpK_sg>
    <xmx:Q8oIXlDooa6lAczjM1MhhobkMH8Qo3uCZHaEYvYoynbAEcqtQVrdcg>
    <xmx:Q8oIXvMAlynzM5wo49rtmcpDRE4g0B6nQ6wZlJ2Aje6vdmmY_Yy39w>
    <xmx:Q8oIXp-UaAsz4HmABnjn0f3z7-h9l88SkhjUUpQZXirPjeoLGkwA6g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E7F280059;
        Sun, 29 Dec 2019 10:46:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] tty/serial: atmel: fix out of range clock divider handling" failed to apply to 4.9-stable tree
To:     david.engraf@sysgo.com, gregkh@linuxfoundation.org,
        ludovic.desroches@microchip.com, richard.genoud@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:45:59 +0100
Message-ID: <157763435917639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb47b9f8630ae3fa3f5fbd0c7003faba7abdf711 Mon Sep 17 00:00:00 2001
From: David Engraf <david.engraf@sysgo.com>
Date: Mon, 16 Dec 2019 09:54:03 +0100
Subject: [PATCH] tty/serial: atmel: fix out of range clock divider handling

Use MCK_DIV8 when the clock divider is > 65535. Unfortunately the mode
register was already written thus the clock selection is ignored.

Fix by doing the baud rate calulation before setting the mode.

Fixes: 5bf5635ac170 ("tty/serial: atmel: add fractional baud rate support")
Signed-off-by: David Engraf <david.engraf@sysgo.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191216085403.17050-1-david.engraf@sysgo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a8dc8af83f39..1ba9bc667e13 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2270,27 +2270,6 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 		mode |= ATMEL_US_USMODE_NORMAL;
 	}
 
-	/* set the mode, clock divisor, parity, stop bits and data size */
-	atmel_uart_writel(port, ATMEL_US_MR, mode);
-
-	/*
-	 * when switching the mode, set the RTS line state according to the
-	 * new mode, otherwise keep the former state
-	 */
-	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
-		unsigned int rts_state;
-
-		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
-			/* let the hardware control the RTS line */
-			rts_state = ATMEL_US_RTSDIS;
-		} else {
-			/* force RTS line to low level */
-			rts_state = ATMEL_US_RTSEN;
-		}
-
-		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
-	}
-
 	/*
 	 * Set the baud rate:
 	 * Fractional baudrate allows to setup output frequency more
@@ -2317,6 +2296,28 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (!(port->iso7816.flags & SER_ISO7816_ENABLED))
 		atmel_uart_writel(port, ATMEL_US_BRGR, quot);
+
+	/* set the mode, clock divisor, parity, stop bits and data size */
+	atmel_uart_writel(port, ATMEL_US_MR, mode);
+
+	/*
+	 * when switching the mode, set the RTS line state according to the
+	 * new mode, otherwise keep the former state
+	 */
+	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
+		unsigned int rts_state;
+
+		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
+			/* let the hardware control the RTS line */
+			rts_state = ATMEL_US_RTSDIS;
+		} else {
+			/* force RTS line to low level */
+			rts_state = ATMEL_US_RTSEN;
+		}
+
+		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
+	}
+
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_TXEN | ATMEL_US_RXEN);
 	atmel_port->tx_stopped = false;

