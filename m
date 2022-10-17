Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9988600634
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 07:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJQFRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 01:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJQFRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 01:17:48 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1965D52E72
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 22:17:47 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 1AEDA6010B
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 14:17:46 +0900 (JST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 9601F60115
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 14:17:45 +0900 (JST)
Received: by mail-pj1-f72.google.com with SMTP id a20-20020a17090acb9400b0020aff595f9eso3901164pju.5
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 22:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2oqZoh5S+HA6R2UZtCjMNYSUIMAZMBLXhJcKoLlANY=;
        b=ceNKUdB6V4bsRl7liSXWDUbls0LgLysU74ZJjP6LelTUxwvOHMCT76KXBJeSUf4key
         zXl4LEDQi8mWBdb8SQDOE3yN8yHZYC9gP6d2oW/XvyP52c2+Yhqgh5z3o7TsbhjO6Z4Z
         PpGt40axDbFNhvHBqg4jPoeGZjpWCRwE1XThbXdCTbyun5krXThQ1oynbNBdfWh4FAfR
         AtJQUY8HcCzZBh3Uttg/S1WBO9EpcIWNuO4whCdOsgrnxyK/p5gyggav056wsEmiuOdY
         Yxz3GSD2EPH9Tf7iy6mmv44/PmiscQj17x4KPSYoUIsIW2S4y5aZaYrBqjsl26CCc9mR
         BKlQ==
X-Gm-Message-State: ACrzQf3+lgWdX6GeoLVJpXBglXBtqn/HM3VaYWEhenE6FgYrSXjLDS+S
        C2ESH2oTB1RI1Y0bkIVwgwXNizJcUPHlu1GCJTwVfUx67pc8kB0Nfuhmn205B9p8OLSYlsRJaLa
        cQqEihwSa8ZeNOR3O4GL2
X-Received: by 2002:a17:903:2cb:b0:171:4f0d:beb6 with SMTP id s11-20020a17090302cb00b001714f0dbeb6mr9976939plk.53.1665983865135;
        Sun, 16 Oct 2022 22:17:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Eam64TwakGzeoHvFJoSgSevI3X4tqNjabFxua24F3qIRXhDrpvxMhbgheutoiBfznGJ1Z0g==
X-Received: by 2002:a17:903:2cb:b0:171:4f0d:beb6 with SMTP id s11-20020a17090302cb00b001714f0dbeb6mr9976915plk.53.1665983864802;
        Sun, 16 Oct 2022 22:17:44 -0700 (PDT)
Received: from pc-0115 (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id 21-20020a630f55000000b00469e09532e0sm5194138pgp.18.2022.10.16.22.17.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Oct 2022 22:17:44 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.96)
        (envelope-from <martinet@pc-0115>)
        id 1okIVR-000DSc-3B;
        Mon, 17 Oct 2022 14:17:42 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 v2 2/2] serial: Deassert Transmit Enable on probe in driver-specific way
Date:   Mon, 17 Oct 2022 14:17:37 +0900
Message-Id: <20221017051737.51727-2-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
References: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

When a UART port is newly registered, uart_configure_port() seeks to
deassert RS485 Transmit Enable by setting the RTS bit in port->mctrl.
However a number of UART drivers interpret a set RTS bit as *assertion*
instead of deassertion:  Affected drivers include those using
serial8250_em485_config() (except 8250_bcm2835aux.c) and some using
mctrl_gpio (e.g. imx.c).

Since the interpretation of the RTS bit is driver-specific, it is not
suitable as a means to centrally deassert Transmit Enable in the serial
core.  Instead, the serial core must call on drivers to deassert it in
their driver-specific way.  One way to achieve that is to call
->rs485_config().  It implicitly deasserts Transmit Enable.

So amend uart_configure_port() and uart_resume_port() to invoke
uart_rs485_config().  That allows removing calls to uart_rs485_config()
from drivers' ->probe() hooks and declaring the function static.

Skip any invocation of ->set_mctrl() if RS485 is enabled.  RS485 has no
hardware flow control, so the modem control lines are irrelevant and
need not be touched.  When leaving RS485 mode, reset the modem control
lines to the state stored in port->mctrl.  That way, UARTs which are
muxed between RS485 and RS232 transceivers drive the lines correctly
when switched to RS232.  (serial8250_do_startup() historically raises
the OUT1 modem signal because otherwise interrupts are not signaled on
ancient PC UARTs, but I believe that no longer applies to modern,
RS485-capable UARTs and is thus safe to be skipped.)

imx.c modifies port->mctrl whenever Transmit Enable is asserted and
deasserted.  Stop it from doing that so port->mctrl reflects the RS232
line state.

8250_omap.c deasserts Transmit Enable on ->runtime_resume() by calling
->set_mctrl().  Because that is now a no-op in RS485 mode, amend the
function to call serial8250_em485_stop_tx().

fsl_lpuart.c retrieves and applies the RS485 device tree properties
after registering the UART port.  Because applying now happens on
registration in uart_configure_port(), move retrieval of the properties
ahead of uart_add_one_port().

Link: https://lore.kernel.org/all/20220329085050.311408-1-matthias.schiffer@ew.tq-group.com/
Link: https://lore.kernel.org/all/8f538a8903795f22f9acc94a9a31b03c9c4ccacb.camel@ginzinger.com/
Fixes: d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart open")
Cc: stable@vger.kernel.org # v4.14+
Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reported-by: Roosen Henri <Henri.Roosen@ginzinger.com>
Tested-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Upstream commit 7c7f9bc986e698873b489c371a08f206979d06b7 ]
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
Follow-up of https://lkml.kernel.org/r/20221017013807.34614-1-dominique.martinet@atmark-techno.com

v1 -> v2: remove port.rs485_config() in fsl lpuart driver

 drivers/tty/serial/8250/8250_omap.c |  3 +++
 drivers/tty/serial/8250/8250_pci.c  |  9 +--------
 drivers/tty/serial/8250/8250_port.c | 12 +++++++-----
 drivers/tty/serial/fsl_lpuart.c     |  8 +++-----
 drivers/tty/serial/imx.c            |  8 ++------
 drivers/tty/serial/serial_core.c    | 30 ++++++++++++++++-------------
 6 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 537bee8d2258..f3744ac805ec 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	omap8250_update_mdr1(up, priv);
 
 	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+
+	if (up->port.rs485.flags & SER_RS485_ENABLED)
+		serial8250_em485_stop_tx(up);
 }
 
 /*
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index df10cc606582..b6656898699d 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1531,7 +1531,6 @@ static int pci_fintek_init(struct pci_dev *dev)
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1578,13 +1577,7 @@ static int pci_fintek_init(struct pci_dev *dev)
 
 		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
 
-		if (priv) {
-			/* re-apply RS232/485 mode when
-			 * pciserial_resume_ports()
-			 */
-			port = serial8250_get_port(priv->line[i]);
-			pci_fintek_rs485_config(&port->port, NULL);
-		} else {
+		if (!priv) {
 			/* First init without port data
 			 * force init to RS232 Mode
 			 */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 9d60418e4adb..e6cadb23850a 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -592,7 +592,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -608,7 +608,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2030,6 +2032,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3159,9 +3164,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		port->rs485_config(port, &port->rs485);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index a2c4eab0b470..698e7b5e1f05 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2667,10 +2667,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_irq_request;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2682,7 +2678,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	    sport->port.rs485.delay_rts_after_send)
 		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
 
-	sport->port.rs485_config(&sport->port, &sport->port.rs485);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	return 0;
 
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index bfbca711bbf9..cf3d53165776 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -398,8 +398,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -408,8 +407,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2381,8 +2379,6 @@ static int imx_uart_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	imx_uart_rs485_config(&sport->port, &sport->port.rs485);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6cc909d44a81..605f928f0636 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -149,15 +149,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		set &= ~TIOCM_RTS;
-		clear &= ~TIOCM_RTS;
-	}
-
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
-	if (old != port->mctrl)
+	if (old != port->mctrl && !(port->rs485.flags & SER_RS485_ENABLED))
 		port->ops->set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -1359,8 +1354,13 @@ static int uart_set_rs485_config(struct uart_port *port,
 
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
-	if (!ret)
+	if (!ret) {
 		port->rs485 = rs485;
+
+		/* Reset RTS and other mctrl lines when disabling RS485 */
+		if (!(rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
@@ -2335,7 +2335,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2346,7 +2347,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 				if (tty)
 					uart_change_speed(tty, state, NULL);
 				spin_lock_irq(&uport->lock);
-				ops->set_mctrl(uport, uport->mctrl);
+				if (!(uport->rs485.flags & SER_RS485_ENABLED))
+					ops->set_mctrl(uport, uport->mctrl);
+				else
+					uport->rs485_config(uport, &uport->rs485);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2444,10 +2448,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
-		if (port->rs485.flags & SER_RS485_ENABLED &&
-		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
-			port->mctrl |= TIOCM_RTS;
-		port->ops->set_mctrl(port, port->mctrl);
+		if (!(port->rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+		else
+			port->rs485_config(port, &port->rs485);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
-- 
2.35.1


