Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1328927B606
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 22:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgI1UNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 16:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1UNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 16:13:35 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93731C0613CF
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:13:35 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id h15so2640681uab.3
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKmy3/ej2CG/v3dkID5ukRA7UHlXu83nJYoCeRGRTRo=;
        b=NhgBjcSWcCYK10M+tDx1DDwEk6saRHYtvQn59YqnUfvnHVEsjdmilUF+vAUFKNYLGO
         6+TNQntYCawfDFXwINjvm7om9UoL6Dss7U+J8Wwrdl4WU1uaCyNFG+L49KJKgtwvgH0A
         b8mMxxbeh2QZFZ6eshOWl+iaLY/zchPMuZ2WxSUDreGjobMd8CsEKUteNwBT6+DdYy8W
         3Wyxor8traemXBLiIwZvoRZa+QCN+WnOdYuWqqIXTPIr/CkDkgntnH+TghUuPLJ567s1
         2eTQV1lxJ/my3nOSTTVCrDyL/XNFD40eUW5dvgdPCm1HhAewyYKL9qfPO7NHNxMItAXh
         YBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKmy3/ej2CG/v3dkID5ukRA7UHlXu83nJYoCeRGRTRo=;
        b=Z68UytHSEkPrAtLZ7fEW2znplUcF8tIgeVN2dnRd24ZUGC7frEwkW7PgQXAnnVG8K+
         DFFOq0zEBIYa/ncUaoky9XhPiCfDYOvAF60j//LJ2dTbxXB6HsNcI6H8k/QRIkELOMgn
         D6bOJsXJqaRx/FeInuhbs1CrU39uepq/6P7GZUYSltIqH8Fu5ONjrhVYpZgQkM8ndFVR
         G+45rtMK+02C0S/gsuKEdl9yssaK2leW1tvxdsPmVupd1mTB5nYjXwKiORDpJwYNrvNS
         HJ2BtzaGoNer4WXJlZ1JT2TVq0UN0BOJoimD+i6N9g417mBfh5BlDIa4DAs9VA6mh6Ya
         HVOw==
X-Gm-Message-State: AOAM531j+ng2ihC6ZEtWNLORBYMOAOS6RdSYoXhWfc0OKNp4NATV1Jf6
        C/dC8SkerCbKtzWHhhAv9COxKVzTYJS5j15iY/ccDw==
X-Google-Smtp-Source: ABdhPJxoN7JeEsyIWinDK9sxwN7udNdcRoxDqo1yKP9DEzwbZRsWc/07ONbm7vtaFGb6e9hVfjF1e42n93qfAZbczt0=
X-Received: by 2002:ab0:2c1a:: with SMTP id l26mr2140518uar.6.1601324014711;
 Mon, 28 Sep 2020 13:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200918021455.2067301-1-sashal@kernel.org> <20200918021455.2067301-64-sashal@kernel.org>
 <CA+G9fYuT_qF2sbmCV76C3B=KS7tSjo9XDkCLwm0A4ZBLJ_eBtw@mail.gmail.com>
In-Reply-To: <CA+G9fYuT_qF2sbmCV76C3B=KS7tSjo9XDkCLwm0A4ZBLJ_eBtw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Sep 2020 01:43:22 +0530
Message-ID: <CA+G9fYtRj=+KM0CJZjPnfCn6OHcW7iFAkE=ECKiz4uOOyq=B2Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 64/90] serial: uartps: Wait for tx_empty in
 console setup
To:     Sasha Levin <sashal@kernel.org>,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 at 01:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Fri, 18 Sep 2020 at 07:55, Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
> >
> > [ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]
> >
> > On some platforms, the log is corrupted while console is being
> > registered. It is observed that when set_termios is called, there
> > are still some bytes in the FIFO to be transmitted.
> >
> > So, wait for tx_empty inside cdns_uart_console_setup before calling
> > set_termios.
> >
> > Signed-off-by: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
> > Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> > Link: https://lore.kernel.org/r/1586413563-29125-2-git-send-email-raviteja.narayanam@xilinx.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> stable rc 4.9 arm64 build broken.

and stable rc 4.9 arm build broken.

>
> drivers/tty/serial/xilinx_uartps.c: In function 'cdns_uart_console_setup':
> drivers/tty/serial/xilinx_uartps.c:1286:40: error: 'TX_TIMEOUT'
> undeclared (first use in this function); did you mean 'ETIMEDOUT'?
>   time_out = jiffies + usecs_to_jiffies(TX_TIMEOUT);
>                                         ^~~~~~~~~~
>                                         ETIMEDOUT
> drivers/tty/serial/xilinx_uartps.c:1286:40: note: each undeclared
> identifier is reported only once for each function it appears in
>   CC      drivers/usb/core/port.o
> scripts/Makefile.build:304: recipe for target
> 'drivers/tty/serial/xilinx_uartps.o' failed
> make[5]: *** [drivers/tty/serial/xilinx_uartps.o] Error 1
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> full test log link,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.9/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/996/consoleText
>
>
> > ---
> >  drivers/tty/serial/xilinx_uartps.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
> > index eb61a07fcbbc3..07ea71a611678 100644
> > --- a/drivers/tty/serial/xilinx_uartps.c
> > +++ b/drivers/tty/serial/xilinx_uartps.c
> > @@ -1268,6 +1268,7 @@ static int cdns_uart_console_setup(struct console *co, char *options)
> >         int bits = 8;
> >         int parity = 'n';
> >         int flow = 'n';
> > +       unsigned long time_out;
> >
> >         if (co->index < 0 || co->index >= CDNS_UART_NR_PORTS)
> >                 return -EINVAL;
> > @@ -1281,6 +1282,13 @@ static int cdns_uart_console_setup(struct console *co, char *options)
> >         if (options)
> >                 uart_parse_options(options, &baud, &parity, &bits, &flow);
> >
> > +       /* Wait for tx_empty before setting up the console */
> > +       time_out = jiffies + usecs_to_jiffies(TX_TIMEOUT);
> > +
> > +       while (time_before(jiffies, time_out) &&
> > +              cdns_uart_tx_empty(port) != TIOCSER_TEMT)
> > +               cpu_relax();
> > +
> >         return uart_set_options(port, co, baud, parity, bits, flow);
> >  }
> >
> > --
> > 2.25.1
> >
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
