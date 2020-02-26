Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98F16FC61
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgBZKhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:37:31 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50447 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgBZKhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:37:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 337CA69A;
        Wed, 26 Feb 2020 05:37:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=paPwKy
        FiOE8vLyj6EN30LNxVaii2/mau08DyJyTZ+3E=; b=WV3K65CFvPLoRlfAFrNZTZ
        ZYdX8ds0C6jaFEZ9dDoOBDgPD8oO9OwwKt75bJ65Q/1uVGc4BiW+OQPJ3E0l3pgo
        ljYD6uYO3d9MEeSH3y9cUuS7AYBKKlg1sFp3WLI0WQtnJrmtSauY0mdKcsAyILSh
        7q2w/BOE3T9+647M9tJbNAAPWWCWd/7TUlZ0lDxTE9ZkRc+ND2QWblkiO/KBtGhM
        kDharok3M6epwM5+R6YlkZtfkeI/5ztmZ/cef5GaUL8uAcXhz4yDq9vXeZmJm2Lo
        mf0wTrij7LolpwCEhQd7Kntw6AqX+SvLSLuYH/vF4bSVLcED6iMu3+9i4U2kjH5w
        ==
X-ME-Sender: <xms:aUpWXuPFosyY-LVOVyBnnyOSWmFvRvlx-g1JIj12qaYE-J6B1nZ32Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:aUpWXkt2LoFou8TgQGlqv0eo3EqH8OkLdaIVjQFopvvolfzvX21G1Q>
    <xmx:aUpWXqQvRy2VKLKoopscKs2Fg3pks4OpVlXbMTk9G7F_SuRdkx9uGQ>
    <xmx:aUpWXmtbIWEK4KG-8_4nbepo3JAxNMTWUqXRg27EDJgxK3-yamqCvQ>
    <xmx:aUpWXkeSJzvKC-aDl2Da-xVR061HjapqrqD9bmJhZ6RwB_Xqikknjg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 754F33060FCB;
        Wed, 26 Feb 2020 05:37:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] tty: serial: qcom_geni_serial: Fix RX cancel command failure" failed to apply to 4.4-stable tree
To:     skakit@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:37:18 +0100
Message-ID: <158271343829117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 679aac5ead2f18d223554a52b543e1195e181811 Mon Sep 17 00:00:00 2001
From: satya priya <skakit@codeaurora.org>
Date: Tue, 11 Feb 2020 15:43:02 +0530
Subject: [PATCH] tty: serial: qcom_geni_serial: Fix RX cancel command failure

RX cancel command fails when BT is switched on and off multiple times.

To handle this, poll for the cancel bit in SE_GENI_S_IRQ_STATUS register
instead of SE_GENI_S_CMD_CTRL_REG.

As per the HPG update, handle the RX last bit after cancel command
and flush out the RX FIFO buffer.

Signed-off-by: satya priya <skakit@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1581415982-8793-1-git-send-email-skakit@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 191abb18fc2a..0bd1684cabb3 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -129,6 +129,7 @@ static int handle_rx_console(struct uart_port *uport, u32 bytes, bool drop);
 static int handle_rx_uart(struct uart_port *uport, u32 bytes, bool drop);
 static unsigned int qcom_geni_serial_tx_empty(struct uart_port *port);
 static void qcom_geni_serial_stop_rx(struct uart_port *uport);
+static void qcom_geni_serial_handle_rx(struct uart_port *uport, bool drop);
 
 static const unsigned long root_freq[] = {7372800, 14745600, 19200000, 29491200,
 					32000000, 48000000, 64000000, 80000000,
@@ -599,7 +600,7 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 	u32 irq_en;
 	u32 status;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
-	u32 irq_clear = S_CMD_DONE_EN;
+	u32 s_irq_status;
 
 	irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
 	irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
@@ -615,10 +616,19 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 		return;
 
 	geni_se_cancel_s_cmd(&port->se);
-	qcom_geni_serial_poll_bit(uport, SE_GENI_S_CMD_CTRL_REG,
-					S_GENI_CMD_CANCEL, false);
+	qcom_geni_serial_poll_bit(uport, SE_GENI_S_IRQ_STATUS,
+					S_CMD_CANCEL_EN, true);
+	/*
+	 * If timeout occurs secondary engine remains active
+	 * and Abort sequence is executed.
+	 */
+	s_irq_status = readl(uport->membase + SE_GENI_S_IRQ_STATUS);
+	/* Flush the Rx buffer */
+	if (s_irq_status & S_RX_FIFO_LAST_EN)
+		qcom_geni_serial_handle_rx(uport, true);
+	writel(s_irq_status, uport->membase + SE_GENI_S_IRQ_CLEAR);
+
 	status = readl(uport->membase + SE_GENI_STATUS);
-	writel(irq_clear, uport->membase + SE_GENI_S_IRQ_CLEAR);
 	if (status & S_GENI_CMD_ACTIVE)
 		qcom_geni_serial_abort_rx(uport);
 }

