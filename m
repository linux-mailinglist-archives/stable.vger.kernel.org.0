Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F791E80D7
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 16:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgE2Otl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 10:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2Otk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 10:49:40 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AB5C08C5C6
        for <stable@vger.kernel.org>; Fri, 29 May 2020 07:49:40 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y123so1637660vsb.6
        for <stable@vger.kernel.org>; Fri, 29 May 2020 07:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nPyJC3VeuXg+H4EiFhdOWQz8oRE+V996il06Y+eqzcw=;
        b=TTNgrE0fEe/q3F/coMGbxfkgkX50UYx1VgY7fEF/oknOvyTTvhLP7jRbPpUO/oFeJm
         3LbB3rTbTpYIQXlCjvlv4abFocWq80dQLWLfiD3DrvzXVGJiH14O9GyY2phHKt7CtrUi
         6Rin5OH80b64AijExWRmKBFeEHebz2xmbWMt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nPyJC3VeuXg+H4EiFhdOWQz8oRE+V996il06Y+eqzcw=;
        b=qUfTDw+GQ0evNwrdGcHd8co1usS1Rc75M8TLE7ZsNHYD9XDmf60sS0hhHaNWKio7+W
         IzPXm0PhfmIs0b3eSs+eVawdI1iboNe+OB84e3a1BbBXME8/VYOmcKRq+wFGVBnR9DsC
         zhQL52pswq5hbCuzNTeQIJLTxLo0/6zT+OVuGdcdqcZwAqK7H6/iDHRmbyYUxhwy1bCR
         0BxQAn1bNYvzXeJGL5zBa4OHVRXQpvBuBZ6I/FoFf0prjS442DCxuDs16Y9JU8gEVeGk
         5dPa/ziWs2/taIyjknZyx91i0efVDaShX/xEsfWf1mU8N8JnVloLRCFYDidrpEmrsSsF
         sPhQ==
X-Gm-Message-State: AOAM530kBaiSLnff1zoEn32ZyA0iqsyrCj4vcDtCFKcnRKaJIQ0WVMOC
        fBI90oKa8mMNijaKSEln5hQQ/tqTvqw=
X-Google-Smtp-Source: ABdhPJxMJEDppTPflXM1UhI7a6PJJLlIajHyTacVFJckg4F28RDYmnxcLb3PVaOrejKtkvGy3qyxEg==
X-Received: by 2002:a67:ef4a:: with SMTP id k10mr5692934vsr.20.1590763779614;
        Fri, 29 May 2020 07:49:39 -0700 (PDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id d184sm1213877vkf.37.2020.05.29.07.49.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 07:49:38 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id r11so725125vkf.11
        for <stable@vger.kernel.org>; Fri, 29 May 2020 07:49:38 -0700 (PDT)
X-Received: by 2002:a1f:5cd0:: with SMTP id q199mr6343966vkb.34.1590763778261;
 Fri, 29 May 2020 07:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
In-Reply-To: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 29 May 2020 07:49:26 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
Message-ID: <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko.stuebner@collabora.com>,
        "# 4.0+" <stable@vger.kernel.org>,
        Frank Mori Hess <fmh6jj@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, May 29, 2020 at 4:51 AM Minas Harutyunyan
<Minas.Harutyunyan@synopsys.com> wrote:
>
> To avoid lot of interrupts from dwc2 core, which can be asserted in
> specific conditions need to disable interrupts on HW level instead of
> disable IRQs on Kernel level, because of IRQ can be shared between
> drivers.
>
> Cc: stable@vger.kernel.org
> Fixes: a40a00318c7fc ("usb: dwc2: add shutdown callback to platform variant")
> Tested-by: Frank Mori Hess <fmh6jj@gmail.com>
> Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
> ---
>  drivers/usb/dwc2/platform.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index e571c8ae65ec..ada5b66b948e 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -342,7 +342,7 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
>  {
>         struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
>
> -       disable_irq(hsotg->irq);
> +       dwc2_disable_global_interrupts(hsotg);
>  }

I could be wrong, but I think it would be better to instead end up
with both calls, like:

dwc2_disable_global_interrupts(hsotg);
disable_irq(hsotg->irq);

To some extent it's slightly overkill, but the disable_irq() function
has the nice "and wait for completion" bit.  Your new call doesn't do
this.

That being said, though, you still won't wait for the completion of
the IRQ handler for the "other drivers" you reference, right.  Maybe a
better fix would be to add a shutdown callback for those other drivers
and just keep relying on disable_irq()?


-Doug
