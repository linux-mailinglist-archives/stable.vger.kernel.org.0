Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB02B4E98
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbgKPRy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731494AbgKPRyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:54:25 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16540C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 09:54:25 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cq7so19623803edb.4
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 09:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=taitradio.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ztCADOef0xN2Nlzfl3hjhCeSuSHCvwqqdCsKbNXzPa0=;
        b=WxwFWTnlNuS9FyuVPi2LYeQ9BQsHrQNh7baMyQntLt7ICJB96KyaiUOGISEQG/slkj
         V588H2D97wUuphZp04LbQSuAp47EDRfPxFPyJgkE4TwGOPDbVJtcwlHHiaj7006i03Jy
         P7udc241+l1L3HG1XuNDGE45WTyNYDiishwaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ztCADOef0xN2Nlzfl3hjhCeSuSHCvwqqdCsKbNXzPa0=;
        b=Aj/ElDDNxeGYXTXIZB2x5DjEgien5lbBD4J5QVpDpF7gXp/OVRai3XWw5tPM0kZBxy
         0xJ+ZuSXxmCS15KlLV5dALoEiPqsSpQgNxci42kh26mw2nE+YGyW6MI9tWX9XFT/RcnR
         92z5VIeHyws/IMAlsx9GermImehzov5Ja6lS8azafbeHrEgGSv0XV9PzkrEU2wqTnxXY
         2o6pWdm2yUpB0yVGAxNJIBZbwdPAFdsVuYcwMKoKbzGX1dTx/NBcwgtiIs/OvTFwDqQN
         jDVXGRSqmKzb+znV2weASvBAbiKb2i129q8DHvHhG24enWhvm7WyX64gI+wIMGoSpA4a
         84Rg==
X-Gm-Message-State: AOAM5323hG5zEx+Ly5Xm6q/SeOovXLSi/z8GMDzgphmhpvRtQExuvWGw
        k56Fvr0/RTV0VuzRjeboUJJLPGQXrVnyFuEA2lSNnZs2IUSeStscgy4XaXNouSxa8hf6hFkUbGv
        5v91Y/lOWLVs4Yg+yPhETSOCB
X-Google-Smtp-Source: ABdhPJw9yZk/qIRta5T7LaHUQ1oMcQwKrW/hD/l4AxGHx41DDSS2gn8rpmq2TpnzApG5KNRviT5LIyOw6Y+zWOH5+Kc=
X-Received: by 2002:a05:6402:1746:: with SMTP id v6mr13738439edx.90.1605549263774;
 Mon, 16 Nov 2020 09:54:23 -0800 (PST)
MIME-Version: 1.0
References: <16051700065460@kroah.com>
In-Reply-To: <16051700065460@kroah.com>
From:   Samuel Nobs <samuel.nobs@taitradio.com>
Date:   Tue, 17 Nov 2020 06:54:12 +1300
Message-ID: <CAPwCw=-BHUn=rRKVsFDakGL=TWYhBxTHz0SZtdYe_WP1cLP5_g@mail.gmail.com>
Subject: Re: patch "tty: serial: imx: fix potential deadlock" added to tty-linus
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, u.kleine-koenig@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Great, thanks.

Cheers,
Sam


On Thu, Nov 12, 2020 at 9:32 PM <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     tty: serial: imx: fix potential deadlock
>
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-linus branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>
> If you have any questions about this process, please let me know.
>
>
> From 33f16855dcb973f745c51882d0e286601ff3be2b Mon Sep 17 00:00:00 2001
> From: Sam Nobs <samuel.nobs@taitradio.com>
> Date: Tue, 10 Nov 2020 09:50:06 +1300
> Subject: tty: serial: imx: fix potential deadlock
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> Enabling the lock dependency validator has revealed
> that the way spinlocks are used in the IMX serial
> port could result in a deadlock.
>
> Specifically, imx_uart_int() acquires a spinlock
> without disabling the interrupts, meaning that another
> interrupt could come along and try to acquire the same
> spinlock, potentially causing the two to wait for each
> other indefinitely.
>
> Use spin_lock_irqsave() instead to disable interrupts
> upon acquisition of the spinlock.
>
> Fixes: c974991d2620 ("tty:serial:imx: use spin_lock instead of spin_lock_=
irqsave in isr")
> Reviewed-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Sam Nobs <samuel.nobs@taitradio.com>
> Link: https://lore.kernel.org/r/1604955006-9363-1-git-send-email-samuel.n=
obs@taitradio.com
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/imx.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 1731d9728865..3c53a3c89959 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -942,8 +942,14 @@ static irqreturn_t imx_uart_int(int irq, void *dev_i=
d)
>         struct imx_port *sport =3D dev_id;
>         unsigned int usr1, usr2, ucr1, ucr2, ucr3, ucr4;
>         irqreturn_t ret =3D IRQ_NONE;
> +       unsigned long flags =3D 0;
>
> -       spin_lock(&sport->port.lock);
> +       /*
> +        * IRQs might not be disabled upon entering this interrupt handle=
r,
> +        * e.g. when interrupt handlers are forced to be threaded. To sup=
port
> +        * this scenario as well, disable IRQs when acquiring the spinloc=
k.
> +        */
> +       spin_lock_irqsave(&sport->port.lock, flags);
>
>         usr1 =3D imx_uart_readl(sport, USR1);
>         usr2 =3D imx_uart_readl(sport, USR2);
> @@ -1013,7 +1019,7 @@ static irqreturn_t imx_uart_int(int irq, void *dev_=
id)
>                 ret =3D IRQ_HANDLED;
>         }
>
> -       spin_unlock(&sport->port.lock);
> +       spin_unlock_irqrestore(&sport->port.lock, flags);
>
>         return ret;
>  }
> --
> 2.29.2
>
>


--=20
Samuel Nobs
Senior Design Engineer
Tait Communications
DDI: +64 7 825 7538
Email: samuel.nobs@taitradio.com

www.taitradio.com

--=20
This Communication is Confidential. We only send and receive email on the
basis of the terms set out at www.taitradio.com/email_disclaimer=20
<http://www.taitradio.com/email_disclaimer>
