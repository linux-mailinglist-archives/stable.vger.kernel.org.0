Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3381C16FC5A
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBZKgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:36:11 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36481 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgBZKgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:36:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BF3A26BD;
        Wed, 26 Feb 2020 05:36:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=H9xuHG
        iM3hypj6JhOkkiiVSFyd9Qv5HAmC/tNX7fPS4=; b=L/wMYxci/HFndzaJUB7J8d
        igohj5rs38jy7DmIynqFYm/MY7pmKZDly40+XSC+1ReHzEfj3UDI4s2mtVZi4vhu
        JfbbHG7gBRinrif0+vmjfe1CD+ViRFBEuaKJxOVSY2PgN8GRfBR9wgXeAfrPLq8p
        9HLSP6Ej2swUVL3kEy/fVQGwdkPsbvadHmXQLIpdbjxfoFgOIO0fqPes6EsKPUN4
        ovIqilHoA89BJ8033x9T+BrZJEmTCj2GHFURlHD5Yl68FUzHxkWtmWcr3PQga81k
        nntbn83ZqXmvx0uq6jKq5HL/YtT7vOmHwPdI7Sc9kpOR6qt2ipmLTXAS1pNSMXWg
        ==
X-ME-Sender: <xms:GUpWXqDZDUo5xTpcMw9Ls9iq8sb9R7SUSAQ8o6gT_lBxCuS6lFuJNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GUpWXqI3Cqbr6Bt_dQWN3QRCLe4HiFBo0StIrsxvQ7b3FQbtQXY8Lw>
    <xmx:GUpWXiioXKZPXRAVeKfVkVmQ5j9s7IPgPenWueJu1z0g2phjWtjQ7w>
    <xmx:GUpWXpLkfpTNMsHYnGvEElzjJSxtUB2h6dPnWGAxix-5Bmj2oAvXZQ>
    <xmx:GUpWXvSDlYlMYVMT9_dJcaa1a2wTXgzfFL7L_QsoqQ35ovPP7hqY3Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A89C3280062;
        Wed, 26 Feb 2020 05:36:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance" failed to apply to 4.9-stable tree
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        kurt@linutronix.de, lirongqing@baidu.com, stable@vger.kernel.org,
        vikram.pandita@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:36:06 +0100
Message-ID: <158271336615180@kroah.com>
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

From 7febbcbc48fc92e3f33863b32ed715ba4aff18c4 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 11 Feb 2020 15:55:59 +0200
Subject: [PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance

The commit 54e53b2e8081
  ("tty: serial: 8250: pass IRQ shared flag to UART ports")
nicely explained the problem:

---8<---8<---

On some systems IRQ lines between multiple UARTs might be shared. If so, the
irqflags have to be configured accordingly. The reason is: The 8250 port startup
code performs IRQ tests *before* the IRQ handler for that particular port is
registered. This is performed in serial8250_do_startup(). This function checks
whether IRQF_SHARED is configured and only then disables the IRQ line while
testing.

This test is performed upon each open() of the UART device. Imagine two UARTs
share the same IRQ line: On is already opened and the IRQ is active. When the
second UART is opened, the IRQ line has to be disabled while performing IRQ
tests. Otherwise an IRQ might handler might be invoked, but the IRQ itself
cannot be handled, because the corresponding handler isn't registered,
yet. That's because the 8250 code uses a chain-handler and invokes the
corresponding port's IRQ handling routines himself.

Unfortunately this IRQF_SHARED flag isn't configured for UARTs probed via device
tree even if the IRQs are shared. This way, the actual and shared IRQ line isn't
disabled while performing tests and the kernel correctly detects a spurious
IRQ. So, adding this flag to the DT probe solves the issue.

Note: The UPF_SHARE_IRQ flag is configured unconditionally. Therefore, the
IRQF_SHARED flag can be set unconditionally as well.

Example stack trace by performing `echo 1 > /dev/ttyS2` on a non-patched system:

|irq 85: nobody cared (try booting with the "irqpoll" option)
| [...]
|handlers:
|[<ffff0000080fc628>] irq_default_primary_handler threaded [<ffff00000855fbb8>] serial8250_interrupt
|Disabling IRQ #85

---8<---8<---

But unfortunately didn't fix the root cause. Let's try again here by moving
IRQ flag assignment from serial_link_irq_chain() to serial8250_do_startup().

This should fix the similar issue reported for 8250_pnp case.

Since this change we don't need to have custom solutions in 8250_aspeed_vuart
and 8250_of drivers, thus, drop them.

Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
Reported-by: Li RongQing <lirongqing@baidu.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index d657aa14c3e4..c33e02cbde93 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -446,7 +446,6 @@ static int aspeed_vuart_probe(struct platform_device *pdev)
 		port.port.line = rc;
 
 	port.port.irq = irq_of_parse_and_map(np, 0);
-	port.port.irqflags = IRQF_SHARED;
 	port.port.handle_irq = aspeed_vuart_handle_irq;
 	port.port.iotype = UPIO_MEM;
 	port.port.type = PORT_16550A;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 0894a22fd702..f2a33c9082a6 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -174,7 +174,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 	struct hlist_head *h;
 	struct hlist_node *n;
 	struct irq_info *i;
-	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
+	int ret;
 
 	mutex_lock(&hash_mutex);
 
@@ -209,9 +209,8 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 		INIT_LIST_HEAD(&up->list);
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
-		irq_flags |= up->port.irqflags;
 		ret = request_irq(up->port.irq, serial8250_interrupt,
-				  irq_flags, up->port.name, i);
+				  up->port.irqflags, up->port.name, i);
 		if (ret < 0)
 			serial_do_unlink(i, up);
 	}
diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 531ad67395e0..f6687756ec5e 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -202,7 +202,6 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 
 	port->type = type;
 	port->uartclk = clk;
-	port->irqflags |= IRQF_SHARED;
 
 	if (of_property_read_bool(np, "no-loopback-test"))
 		port->flags |= UPF_SKIP_TEST;
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 430e3467aff7..0325f2e53b74 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2177,6 +2177,10 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
 
+	/* Check if we need to have shared IRQs */
+	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
+		up->port.irqflags |= IRQF_SHARED;
+
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
 		/*

