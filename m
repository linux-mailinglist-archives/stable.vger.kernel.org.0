Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EEF37B7EA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELI3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:29:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:55977 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELI3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:29:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 36C4C1525;
        Wed, 12 May 2021 04:28:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rpwsjT
        w+GvrRhuFqeGmwSB+/8V99fvyVU1hM/vD/IY4=; b=Jx5HOfTmyhSAa2F1SZ3YiX
        HIACBAGrRF9rR7nN/9yT0lt8lHmAT2fI9e95IHY/blD0hG8ivCtocI0/wxfFFDvR
        COC4zEv3a2PrkSe2u9Wsk1a48+FT5DgVYu+VwAvSHucIsnYIAcALIkQMV8WsQsiP
        mN4Zyg8iC6u52VUP8LHVyjkqkThBMhuNYnfu5wmvzo5mI3DZksdnUep5TVogQEmE
        6/xrWDItUd0upjCHDp5e4d5mTENM+myeAnJVgo6b5Txei9L3UdnIAFCnaz2pOvVX
        I5gvU1L4bSItYag4U+L5izJzp2yzDSAKyBirRaCjDks01l/WpVh4KdgBaQy2hopQ
        ==
X-ME-Sender: <xms:mJGbYGwglWyiBnfeN4EK1TwnjGIlfNJx-9c-7d9s0g0vkT32bxx3tw>
    <xme:mJGbYCTyJQpjW6mKKyyPeghu6J6uuYre1JSRmLrFxTtY72XL_rHq_YK7k8StRgA75
    B5hjhhxsBDQjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehuddgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mJGbYIXJRNL6ae29fhZ-7BgW1p1HNeiPYV0UdZvkrSXgIB4CU4-nsQ>
    <xmx:mJGbYMi31rUxt8d3zZxd_eUSY-EL1aY8-cy2oGr_IToKRSzY4zA2tg>
    <xmx:mJGbYIC0LW4Fa4cku4wilzJj-o65QtPkLt3_CWv6HA9hx0l977h3Ig>
    <xmx:mJGbYLMkRZTKcIBA_U0zJ4kAA857HuLmLpO530f6T-rx22MVcN83ILlK-_c>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:28:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] serial: stm32: fix threaded interrupt handling" failed to apply to 4.19-stable tree
To:     johan@kernel.org, alexandre.torgue@st.com, gerald.baeza@st.com,
        gregkh@linuxfoundation.org, valentin.caron@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:27:58 +0200
Message-ID: <1620808078143113@kroah.com>
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

From e359b4411c2836cf87c8776682d1b594635570de Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 16 Apr 2021 16:05:56 +0200
Subject: [PATCH] serial: stm32: fix threaded interrupt handling

When DMA is enabled the receive handler runs in a threaded handler, but
the primary handler up until very recently neither disabled interrupts
in the device or used IRQF_ONESHOT. This would lead to a deadlock if an
interrupt comes in while the threaded receive handler is running under
the port lock.

Commit ad7676812437 ("serial: stm32: fix a deadlock condition with
wakeup event") claimed to fix an unrelated deadlock, but unfortunately
also disabled interrupts in the threaded handler. While this prevents
the deadlock mentioned in the previous paragraph it also defeats the
purpose of using a threaded handler in the first place.

Fix this by making the interrupt one-shot and not disabling interrupts
in the threaded handler.

Note that (receive) DMA must not be used for a console port as the
threaded handler could be interrupted while holding the port lock,
something which could lead to a deadlock in case an interrupt handler
ends up calling printk.

Fixes: ad7676812437 ("serial: stm32: fix a deadlock condition with wakeup event")
Fixes: 3489187204eb ("serial: stm32: adding dma support")
Cc: stable@vger.kernel.org      # 4.9
Cc: Alexandre TORGUE <alexandre.torgue@st.com>
Cc: Gerald Baeza <gerald.baeza@st.com>
Reviewed-by: Valentin Caron<valentin.caron@foss.st.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210416140557.25177-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 4d277804c63e..3524ed2c0c73 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -214,14 +214,11 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 	struct tty_port *tport = &port->state->port;
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
-	unsigned long c, flags;
+	unsigned long c;
 	u32 sr;
 	char flag;
 
-	if (threaded)
-		spin_lock_irqsave(&port->lock, flags);
-	else
-		spin_lock(&port->lock);
+	spin_lock(&port->lock);
 
 	while (stm32_usart_pending_rx(port, &sr, &stm32_port->last_res,
 				      threaded)) {
@@ -278,10 +275,7 @@ static void stm32_usart_receive_chars(struct uart_port *port, bool threaded)
 		uart_insert_char(port, sr, USART_SR_ORE, c, flag);
 	}
 
-	if (threaded)
-		spin_unlock_irqrestore(&port->lock, flags);
-	else
-		spin_unlock(&port->lock);
+	spin_unlock(&port->lock);
 
 	tty_flip_buffer_push(tport);
 }
@@ -667,7 +661,8 @@ static int stm32_usart_startup(struct uart_port *port)
 
 	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
 				   stm32_usart_threaded_interrupt,
-				   IRQF_NO_SUSPEND, name, port);
+				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+				   name, port);
 	if (ret)
 		return ret;
 
@@ -1156,6 +1151,13 @@ static int stm32_usart_of_dma_rx_probe(struct stm32_port *stm32port,
 	struct dma_async_tx_descriptor *desc = NULL;
 	int ret;
 
+	/*
+	 * Using DMA and threaded handler for the console could lead to
+	 * deadlocks.
+	 */
+	if (uart_console(port))
+		return -ENODEV;
+
 	/* Request DMA RX channel */
 	stm32port->rx_ch = dma_request_slave_channel(dev, "rx");
 	if (!stm32port->rx_ch) {

