Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF12360ECF3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 02:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbiJ0AUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 20:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiJ0AUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 20:20:02 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A04139113
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 17:19:53 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id C3EBD60145
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:19:52 +0900 (JST)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 17AA260146
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:19:52 +0900 (JST)
Received: by mail-pf1-f200.google.com with SMTP id i19-20020aa787d3000000b0056bd68d713cso5140710pfo.17
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 17:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNgyr3ceLKAj+gPwJxCfJcfYLV5t1pDqxizUmEVr1mU=;
        b=gnNGWPxj+QVHVO9vJZhSkpn0XqFB+9TJ2729YAhUr1BGCZHDsbyQWDb4xyU+q+OQ/2
         fj6o9vr9qvfhh0hxNWPUcFBAi61F0Nx+qWtV4sC88VM2nKU02Gd2oEbV7iTSCYnMnasK
         nXD9lU7RTlOW0YmsZSgjcSjkHMBC0aHGSsFr3g8KC13k7eEOrpjcXDogKL6Bx/NveVG1
         Jy0/DHzQxGrk0meBBHUE7EmHCbpb19+fJVPkNpTKxPGEc1+/VvNS8e2ejYrOahTs8Lwg
         RqSraTLIydcRAL5QrzhSpRNQAP4V8laIdmhTsO/bXVNwXGkfBudipanR5X7GUmbLyffB
         5Yhg==
X-Gm-Message-State: ACrzQf2h4aCtuegXR90en+oJj9Oqs7kDAdsMRZ2fT5uIb3Ncb38aRoCz
        zj1zbbcPlt0isLhjpgdzahBZFFC4D7400C+PI/q+KWPOEtmvppzd3mO/CpEJg/PGM6yttppVRZb
        ufw+V9MZciAUD8V3nWHmZ
X-Received: by 2002:a17:90b:17ca:b0:20d:76bb:3f8c with SMTP id me10-20020a17090b17ca00b0020d76bb3f8cmr6913447pjb.28.1666829990598;
        Wed, 26 Oct 2022 17:19:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5cdIT7b3WXpJMRFFnHo+hF+dR02E1gN+CVII8cVwmuOeCxTqJWcWSsCbR1XgfuveUiz2mkxw==
X-Received: by 2002:a17:90b:17ca:b0:20d:76bb:3f8c with SMTP id me10-20020a17090b17ca00b0020d76bb3f8cmr6913426pjb.28.1666829990262;
        Wed, 26 Oct 2022 17:19:50 -0700 (PDT)
Received: from pc-zest.atmarktech (178.101.200.35.bc.googleusercontent.com. [35.200.101.178])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902eac300b0017a032d7ae4sm3492705pld.104.2022.10.26.17.19.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2022 17:19:49 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1onqce-002fqM-17;
        Thu, 27 Oct 2022 09:19:48 +0900
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
Subject: [PATCH 5.15 2/2] serial: Deassert Transmit Enable on probe in driver-specific way
Date:   Thu, 27 Oct 2022 09:19:43 +0900
Message-Id: <20221027001943.637449-2-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221027001943.637449-1-dominique.martinet@atmark-techno.com>
References: <20221027001943.637449-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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

[ Upstream commit 7c7f9bc986e698873b489c371a08f206979d06b7 ]
Link: https://lkml.kernel.org/r/20221017051737.51727-2-dominique.martinet@atmark-techno.com
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
Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---

5.15 version of the 5.10 patch:
https://lkml.kernel.org/r/20221017051737.51727-2-dominique.martinet@atmark-techno.com
(only build tested)

 drivers/tty/serial/8250/8250_omap.c |  3 +++
 drivers/tty/serial/8250/8250_pci.c  |  9 +--------
 drivers/tty/serial/8250/8250_port.c | 12 +++++++-----
 drivers/tty/serial/fsl_lpuart.c     |  8 +++-----
 drivers/tty/serial/imx.c            |  8 ++------
 drivers/tty/serial/serial_core.c    | 30 ++++++++++++++++-------------
 6 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 73e5f1dbd075..806f7806d3ca 100644
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
index a16743856fc7..b36f82b3ef18 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1734,7 +1734,6 @@ static int pci_fintek_init(struct pci_dev *dev)
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1781,13 +1780,7 @@ static int pci_fintek_init(struct pci_dev *dev)
 
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
index a5496bd1b650..affb7796be77 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -600,7 +600,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -616,7 +616,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2033,6 +2035,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3188,9 +3193,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		port->rs485_config(port, &port->rs485);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index b6548b910d94..fbdfd503c9b3 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2731,10 +2731,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_reset;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2746,7 +2742,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	    sport->port.rs485.delay_rts_after_send)
 		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
 
-	sport->port.rs485_config(&sport->port, &sport->port.rs485);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
 				DRIVER_NAME, sport);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index b7ef075a4005..c6a93d6a9464 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -380,8 +380,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -390,8 +389,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2318,8 +2316,6 @@ static int imx_uart_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	imx_uart_rs485_config(&sport->port, &sport->port.rs485);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 48dafd1e084b..5f8f0a90ce55 100644
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
@@ -1332,8 +1327,13 @@ static int uart_set_rs485_config(struct uart_port *port,
 
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
@@ -2306,7 +2306,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2317,7 +2318,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
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
@@ -2423,10 +2427,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
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


