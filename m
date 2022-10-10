Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3370B5F984F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 08:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiJJGYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 02:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiJJGYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 02:24:06 -0400
X-Greylist: delayed 392 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Oct 2022 23:24:02 PDT
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7784E550AD
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 23:24:02 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        by gw.atmark-techno.com (Postfix) with ESMTPS id B85686010A
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 15:17:28 +0900 (JST)
Received: by mail-pj1-f71.google.com with SMTP id y16-20020a17090aa41000b001fdf0a76a4eso4645244pjp.3
        for <stable@vger.kernel.org>; Sun, 09 Oct 2022 23:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhY/YBolv8hSqOo4abkV8XSXC2M5ryJYicZWaAOYbjY=;
        b=NHqWTWUreJK4RI+0xoANkMi+KtucaACClP11/FC8MoPKLaIBLqwLT/jjSBWJ4xXOAY
         jrZqTaGlGx4CucULq6WEmKcNn41ETkAeOjBfHuJAnPzIS6pkFynY2DLRbuL8hnKx7IaS
         dAVHzmM1OK6crKPQg+KSkJ2jCLloPYzS9mnydO0wOSvUMBz+dVMZkoW2CDOlkmsj0xFl
         daiErJCc6AM8X/saCu6aJHyUsobNf1pEqpjkOtIT/+9dRBSg4QuHe6YqOpBMn2hbewX1
         eAcL+RX9LPGGk378II9fM3nrqsSRUrHMlxEo2q8gtkiBKGkiKX0RDH9JCwedY9QLINO8
         7gyg==
X-Gm-Message-State: ACrzQf0zseubGpPTZqrEHHTmzfxVSd9md9z3g8SqKwR0LcrXx2W9Magv
        iR7goiHQ/Vuf5WwGZ7o3mg0VBhu3aeCdlpgrLJqpqTG2Xg3Kl95NM3jjZ9+YVLlqWl+D5hO1Wtz
        dNlWIQt7L7ocHi1ZPDs4U
X-Received: by 2002:a17:903:22c8:b0:17f:7039:a2d4 with SMTP id y8-20020a17090322c800b0017f7039a2d4mr17774189plg.2.1665382647639;
        Sun, 09 Oct 2022 23:17:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7wCJtVEObVEUdWCWNNYw39aS08xIF7xSWA9UN1W/C+mlmVKBmLQW4p7XQbRpgO7YTJkMZoHQ==
X-Received: by 2002:a17:903:22c8:b0:17f:7039:a2d4 with SMTP id y8-20020a17090322c800b0017f7039a2d4mr17774173plg.2.1665382647220;
        Sun, 09 Oct 2022 23:17:27 -0700 (PDT)
Received: from pc-zest.atmarktech (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a2c0900b00202fbd9c21dsm5322580pjd.48.2022.10.09.23.17.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Oct 2022 23:17:26 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1ohm6O-007qTx-1V;
        Mon, 10 Oct 2022 15:17:24 +0900
Date:   Mon, 10 Oct 2022 15:17:14 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] serial: Deassert Transmit Enable on probe in
 driver-specific way
Message-ID: <Y0O46rcQap99fZVC@atmark-techno.com>
References: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2de36eba3fbe11278d5002e4e501afe0ceaca039.1663863805.git.lukas@wunner.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Cc stable

Lukas Wunner wrote on Thu, Sep 22, 2022 at 06:27:33PM +0200:
> When a UART port is newly registered, uart_configure_port() seeks to
> deassert RS485 Transmit Enable by setting the RTS bit in port->mctrl.
> However a number of UART drivers interpret a set RTS bit as *assertion*
> instead of deassertion:  Affected drivers include those using
> serial8250_em485_config() (except 8250_bcm2835aux.c) and some using
> mctrl_gpio (e.g. imx.c).
> 
> Since the interpretation of the RTS bit is driver-specific, it is not
> suitable as a means to centrally deassert Transmit Enable in the serial
> core.  Instead, the serial core must call on drivers to deassert it in
> their driver-specific way.  One way to achieve that is to call
> ->rs485_config().  It implicitly deasserts Transmit Enable.
> 
> So amend uart_configure_port() and uart_resume_port() to invoke
> uart_rs485_config().  That allows removing calls to uart_rs485_config()
> from drivers' ->probe() hooks and declaring the function static.
> 
> Skip any invocation of ->set_mctrl() if RS485 is enabled.  RS485 has no
> hardware flow control, so the modem control lines are irrelevant and
> need not be touched.  When leaving RS485 mode, reset the modem control
> lines to the state stored in port->mctrl.  That way, UARTs which are
> muxed between RS485 and RS232 transceivers drive the lines correctly
> when switched to RS232.  (serial8250_do_startup() historically raises
> the OUT1 modem signal because otherwise interrupts are not signaled on
> ancient PC UARTs, but I believe that no longer applies to modern,
> RS485-capable UARTs and is thus safe to be skipped.)
> 
> imx.c modifies port->mctrl whenever Transmit Enable is asserted and
> deasserted.  Stop it from doing that so port->mctrl reflects the RS232
> line state.
> 
> 8250_omap.c deasserts Transmit Enable on ->runtime_resume() by calling
> ->set_mctrl().  Because that is now a no-op in RS485 mode, amend the
> function to call serial8250_em485_stop_tx().
> 
> fsl_lpuart.c retrieves and applies the RS485 device tree properties
> after registering the UART port.  Because applying now happens on
> registration in uart_configure_port(), move retrieval of the properties
> ahead of uart_add_one_port().
> 
> Fixes: d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart open")

Thanks for this fix!
We also noticed rs485 DE was initially wrong last week and I noticed
this when I was about to send a patch that just inverted the
SER_RS485_RTS_AFTER_SEND check in uart_configure_port, but after reading
the commit message here it's a lot more complicated than that depending
on the serial driver...
(fixing commit 2dd8a74fddd2 ("serial: core: Initialize rs485 RTS
polarity already on probe"), but it's actually the same problem in the
opposite direction)


Unfortunately you've marked this for v4.14+ stable, but it doesn't even
apply to 5.19.14 due to (at least) commit d8fcd9cfbde5 ("serial: core:
move sanitizing of RS485 delays into own function"), so it hasn't been
picked up yet; since quite a bit of code was cleaned up/moved one will
need to pay a bit attention when doing that.

What would you like to do for stable branches?
Would you be able to send a patch that applies on older 5.10 and 5.15
where commit d3b3404df318 ("serial: Fix incorrect rs485 polarity on uart
open") has been backported?

If that sounds too complicated we could probably just revert a handful
of serial_core/rs485 commits, but going forward sounds more future-proof
to me.

Thanks!
(nothing below, leaving quote for stable@)

> Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Tested-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Link: https://lore.kernel.org/all/20220329085050.311408-1-matthias.schiffer@ew.tq-group.com/
> Reported-by: Roosen Henri <Henri.Roosen@ginzinger.com>
> Link: https://lore.kernel.org/all/8f538a8903795f22f9acc94a9a31b03c9c4ccacb.camel@ginzinger.com/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v4.14+
> ---
>  v1 -> v2:
>  Deassert RTS in serial8250_em485_init() only if no transmission is
>  currently ongoing (Ilpo)
> 
>  v2 -> v3:
>  Drop superfluous newline
> 
>  v3 -> v4:
>  Resend with changelog at maintainer's request
> 
>  drivers/tty/serial/8250/8250_omap.c |  3 +++
>  drivers/tty/serial/8250/8250_pci.c  |  9 +--------
>  drivers/tty/serial/8250/8250_port.c | 12 +++++++-----
>  drivers/tty/serial/fsl_lpuart.c     | 10 ++++------
>  drivers/tty/serial/imx.c            |  8 ++------
>  drivers/tty/serial/serial_core.c    | 36 ++++++++++++++++++++----------------
>  include/linux/serial_core.h         |  1 -
>  7 files changed, 37 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
> index b43894e..2e67754 100644
> --- a/drivers/tty/serial/8250/8250_omap.c
> +++ b/drivers/tty/serial/8250/8250_omap.c
> @@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
>  	omap8250_update_mdr1(up, priv);
>  
>  	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
> +
> +	if (up->port.rs485.flags & SER_RS485_ENABLED)
> +		serial8250_em485_stop_tx(up);
>  }
>  
>  /*
> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index 6f66dc2..b260c55 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1627,7 +1627,6 @@ static int pci_fintek_init(struct pci_dev *dev)
>  	resource_size_t bar_data[3];
>  	u8 config_base;
>  	struct serial_private *priv = pci_get_drvdata(dev);
> -	struct uart_8250_port *port;
>  
>  	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
>  			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
> @@ -1674,13 +1673,7 @@ static int pci_fintek_init(struct pci_dev *dev)
>  
>  		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
>  
> -		if (priv) {
> -			/* re-apply RS232/485 mode when
> -			 * pciserial_resume_ports()
> -			 */
> -			port = serial8250_get_port(priv->line[i]);
> -			uart_rs485_config(&port->port);
> -		} else {
> +		if (!priv) {
>  			/* First init without port data
>  			 * force init to RS232 Mode
>  			 */
> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> index 907c5ff..b21550c 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -600,7 +600,7 @@ void serial8250_rpm_put(struct uart_8250_port *p)
>  static int serial8250_em485_init(struct uart_8250_port *p)
>  {
>  	if (p->em485)
> -		return 0;
> +		goto deassert_rts;
>  
>  	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
>  	if (!p->em485)
> @@ -616,7 +616,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
>  	p->em485->active_timer = NULL;
>  	p->em485->tx_stopped = true;
>  
> -	p->rs485_stop_tx(p);
> +deassert_rts:
> +	if (p->em485->tx_stopped)
> +		p->rs485_stop_tx(p);
>  
>  	return 0;
>  }
> @@ -2047,6 +2049,9 @@ void serial8250_do_set_mctrl(struct uart_port *port, unsigned int mctrl)
>  
>  static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
>  {
> +	if (port->rs485.flags & SER_RS485_ENABLED)
> +		return;
> +
>  	if (port->set_mctrl)
>  		port->set_mctrl(port, mctrl);
>  	else
> @@ -3189,9 +3194,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
>  	if (flags & UART_CONFIG_TYPE)
>  		autoconfig(up);
>  
> -	if (port->rs485.flags & SER_RS485_ENABLED)
> -		uart_rs485_config(port);
> -
>  	/* if access method is AU, it is a 16550 with a quirk */
>  	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
>  		up->bugs |= UART_BUG_NOMSR;
> diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
> index e9d5b48..dfc73fe 100644
> --- a/drivers/tty/serial/fsl_lpuart.c
> +++ b/drivers/tty/serial/fsl_lpuart.c
> @@ -2724,15 +2724,13 @@ static int lpuart_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto failed_reset;
>  
> -	ret = uart_add_one_port(&lpuart_reg, &sport->port);
> -	if (ret)
> -		goto failed_attach_port;
> -
>  	ret = uart_get_rs485_mode(&sport->port);
>  	if (ret)
>  		goto failed_get_rs485;
>  
> -	uart_rs485_config(&sport->port);
> +	ret = uart_add_one_port(&lpuart_reg, &sport->port);
> +	if (ret)
> +		goto failed_attach_port;
>  
>  	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
>  				DRIVER_NAME, sport);
> @@ -2742,9 +2740,9 @@ static int lpuart_probe(struct platform_device *pdev)
>  	return 0;
>  
>  failed_irq_request:
> -failed_get_rs485:
>  	uart_remove_one_port(&lpuart_reg, &sport->port);
>  failed_attach_port:
> +failed_get_rs485:
>  failed_reset:
>  	lpuart_disable_clks(sport);
>  	return ret;
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 5875ee6..05b432d 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -380,8 +380,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
>  {
>  	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
>  
> -	sport->port.mctrl |= TIOCM_RTS;
> -	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
> +	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
>  }
>  
>  /* called with port.lock taken and irqs caller dependent */
> @@ -390,8 +389,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
>  	*ucr2 &= ~UCR2_CTSC;
>  	*ucr2 |= UCR2_CTS;
>  
> -	sport->port.mctrl &= ~TIOCM_RTS;
> -	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
> +	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
>  }
>  
>  static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
> @@ -2347,8 +2345,6 @@ static int imx_uart_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev,
>  			"low-active RTS not possible when receiver is off, enabling receiver\n");
>  
> -	uart_rs485_config(&sport->port);
> -
>  	/* Disable interrupts before requesting them */
>  	ucr1 = imx_uart_readl(sport, UCR1);
>  	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index c711318..179ee19 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -158,15 +158,10 @@ static void uart_start(struct tty_struct *tty)
>  	unsigned long flags;
>  	unsigned int old;
>  
> -	if (port->rs485.flags & SER_RS485_ENABLED) {
> -		set &= ~TIOCM_RTS;
> -		clear &= ~TIOCM_RTS;
> -	}
> -
>  	spin_lock_irqsave(&port->lock, flags);
>  	old = port->mctrl;
>  	port->mctrl = (old & ~clear) | set;
> -	if (old != port->mctrl)
> +	if (old != port->mctrl && !(port->rs485.flags & SER_RS485_ENABLED))
>  		port->ops->set_mctrl(port, port->mctrl);
>  	spin_unlock_irqrestore(&port->lock, flags);
>  }
> @@ -1391,7 +1386,7 @@ static void uart_set_rs485_termination(struct uart_port *port,
>  				 !!(rs485->flags & SER_RS485_TERMINATE_BUS));
>  }
>  
> -int uart_rs485_config(struct uart_port *port)
> +static int uart_rs485_config(struct uart_port *port)
>  {
>  	struct serial_rs485 *rs485 = &port->rs485;
>  	int ret;
> @@ -1405,7 +1400,6 @@ int uart_rs485_config(struct uart_port *port)
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(uart_rs485_config);
>  
>  static int uart_get_rs485_config(struct uart_port *port,
>  			 struct serial_rs485 __user *rs485)
> @@ -1444,8 +1438,13 @@ static int uart_set_rs485_config(struct tty_struct *tty, struct uart_port *port,
>  
>  	spin_lock_irqsave(&port->lock, flags);
>  	ret = port->rs485_config(port, &tty->termios, &rs485);
> -	if (!ret)
> +	if (!ret) {
>  		port->rs485 = rs485;
> +
> +		/* Reset RTS and other mctrl lines when disabling RS485 */
> +		if (!(rs485.flags & SER_RS485_ENABLED))
> +			port->ops->set_mctrl(port, port->mctrl);
> +	}
>  	spin_unlock_irqrestore(&port->lock, flags);
>  	if (ret)
>  		return ret;
> @@ -2352,7 +2351,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  
>  		spin_lock_irq(&uport->lock);
>  		ops->stop_tx(uport);
> -		ops->set_mctrl(uport, 0);
> +		if (!(uport->rs485.flags & SER_RS485_ENABLED))
> +			ops->set_mctrl(uport, 0);
>  		/* save mctrl so it can be restored on resume */
>  		mctrl = uport->mctrl;
>  		uport->mctrl = 0;
> @@ -2440,7 +2440,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  
>  		uart_change_pm(state, UART_PM_STATE_ON);
>  		spin_lock_irq(&uport->lock);
> -		ops->set_mctrl(uport, 0);
> +		if (!(uport->rs485.flags & SER_RS485_ENABLED))
> +			ops->set_mctrl(uport, 0);
>  		spin_unlock_irq(&uport->lock);
>  		if (console_suspend_enabled || !uart_console(uport)) {
>  			/* Protected by port mutex for now */
> @@ -2451,7 +2452,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  				if (tty)
>  					uart_change_speed(tty, state, NULL);
>  				spin_lock_irq(&uport->lock);
> -				ops->set_mctrl(uport, uport->mctrl);
> +				if (!(uport->rs485.flags & SER_RS485_ENABLED))
> +					ops->set_mctrl(uport, uport->mctrl);
> +				else
> +					uart_rs485_config(uport);
>  				ops->start_tx(uport);
>  				spin_unlock_irq(&uport->lock);
>  				tty_port_set_initialized(port, 1);
> @@ -2558,10 +2562,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
>  		 */
>  		spin_lock_irqsave(&port->lock, flags);
>  		port->mctrl &= TIOCM_DTR;
> -		if (port->rs485.flags & SER_RS485_ENABLED &&
> -		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
> -			port->mctrl |= TIOCM_RTS;
> -		port->ops->set_mctrl(port, port->mctrl);
> +		if (!(port->rs485.flags & SER_RS485_ENABLED))
> +			port->ops->set_mctrl(port, port->mctrl);
> +		else
> +			uart_rs485_config(port);
>  		spin_unlock_irqrestore(&port->lock, flags);
>  
>  		/*
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 02a4299..0354369 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -933,5 +933,4 @@ static inline int uart_handle_break(struct uart_port *port)
>  					 !((cflag) & CLOCAL))
>  
>  int uart_get_rs485_mode(struct uart_port *port);
> -int uart_rs485_config(struct uart_port *port);
>  #endif /* LINUX_SERIAL_CORE_H */
-- 
Dominique Martinet
