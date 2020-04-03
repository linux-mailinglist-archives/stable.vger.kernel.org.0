Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D874B19DB88
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404495AbgDCQYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 12:24:03 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38128 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgDCQYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 12:24:02 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so3150195pje.3;
        Fri, 03 Apr 2020 09:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHZL7VkAiKyU+OLHV3Q6UdUVJcGFPeA3Rqtpg/t6Yag=;
        b=dwy+bq652NZlCPKGx5RgdbE2OCzGh0yfXL9N8TXnYdtV2PAgt+wHhZP0nI7MgdbW+z
         V4Fdv6jBOOMTO20U07atV5R/0L7kcbcoNMV8j22XiaHaa4Pl24XCrp5FVsPXj+iSxqts
         FLFCWZpMIBghvL4H82MK9mnaLSH/B1y2Hu9JwxUAv45WxaCg9Kkfm/fgd+FGp6pb66V3
         o/RYVkAUGZ/qYcpE3w4+DyNgwURQMfkbFc/eV8BzqxUlhohMVFRvnz18/P24DGqd4WBL
         AYq+RCRw4E68lWbCmkwSFLWmxXlHFWZKNCv84RhYqfZg2X9b2RBKkMo3vxiDoAOuyqST
         e5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VHZL7VkAiKyU+OLHV3Q6UdUVJcGFPeA3Rqtpg/t6Yag=;
        b=eO09LTc84W7s0pi5qVqjHKAMNlOxDnyCIj99bcSYYRJr6iWWjbGG/h79MDXZ/RY/tP
         NxEPT4Yq3pBxBEpwco77Tqeqce9jM/n04f5oYqEC5cEtHzTiuquCozdPAZ+4VD3ImDEV
         v9eJWv8GfcDJF0GuoZBiKGmLW/sLisHEcVuShVPmDo3y1PEB/V7KWb85N2shu7WaiKm6
         ba5n1fU5nC3ecOIbfQJ99fu0EqAQGNfp39xOBFOWUQdLsFIOW3WS0+ELR9zDf0+7s1xK
         CEH0ax19v7so5aT+lcFtqUslk+HQ4yqd4eDWDppPQ2er5JRDeC+nS5y8jzft/DtwV3m7
         k8YA==
X-Gm-Message-State: AGi0PuZ0HmAKjXxhghuvoZkUJaqOJ591raq9fNrj8E03IMMvHq/e3r68
        Njy0tBnmDmJob8kQq7Yx6ZCFiK2DrFC8VTzvfNI=
X-Google-Smtp-Source: APiQypJ45+3EwU1AMNAqrlW12hA1LE6C4EtPe9jefycJESLHDJfelc4gB2zOt0moSFww3plOb4WBlmvfq/lhal9a/eU=
X-Received: by 2002:a17:902:b190:: with SMTP id s16mr8506114plr.262.1585931041577;
 Fri, 03 Apr 2020 09:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200403154834.303105-1-hdegoede@redhat.com> <20200403154834.303105-2-hdegoede@redhat.com>
 <3798902.sSGyZ91sKY@kreacher>
In-Reply-To: <3798902.sSGyZ91sKY@kreacher>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 3 Apr 2020 19:23:54 +0300
Message-ID: <CAHp75VfThW1CrkneP5kEm_7KejQgS2dhDi0YyDrL4y3=uY9ZbA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 3, 2020 at 7:08 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> On Friday, April 3, 2020 5:48:34 PM CEST Hans de Goede wrote:
> > The Power Management Events (PMEs) the INT0002 driver listens for get
> > signalled by the Power Management Controller (PMC) using the same IRQ
> > as used for the ACPI SCI.
> >
> > Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
> > waking up the system") the SCI triggering, without there being a wakeup
> > cause recognized by the ACPI sleep code, will no longer wakeup the system.
> >
> > This breaks PMEs / wakeups signalled to the INT0002 driver, the system
> > never leaves the s2idle_loop() now.
> >
> > Use acpi_register_wakeup_handler() to register a function which checks
> > the GPE0a_STS register for a PME and trigger a wakeup when a PME has
> > been signalled.
> >
> > Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
> > Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> Andy, any objections?

No,
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Hans, just today when testing some other stuff noticed this

[   49.279001] irq 9: nobody cared (try booting with the "irqpoll" option)
[   49.289176] CPU: 0 PID: 168 Comm: irq/123-ATML100 Not tainted
5.6.0-next-20200403+ #212
[   49.300915] Hardware name: Intel Corporation CHERRYVIEW D0
PLATFORM/Braswell CRB, BIOS BRAS.X64.B082.R00.150727 0557 07/27/2015
[   49.316520] Call Trace:
[   49.322093]  <IRQ>
[   49.327193]  dump_stack+0x50/0x70
[   49.333744]  __report_bad_irq+0x30/0xa2
[   49.340858]  note_interrupt.cold+0xb/0x62
...
[   49.685087] handlers:
[   49.690307] [<000000000ab3cf88>] acpi_irq
[   49.697463] [<00000000e5d78029>] int0002_irq [intel_int0002_vgpio]
[   49.707063] Disabling IRQ #9

Is this what your series fixes?

>
> > ---
> > Changes in v3:
> > - Keep the pm_wakeup_hard_event() call
> >
> > Changes in v2:
> > - Adjust for the wakeup-handler registration function being renamed to
> >   acpi_register_wakeup_handler()
> > ---
> >  drivers/platform/x86/intel_int0002_vgpio.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
> > index f14e2c5f9da5..55f088f535e2 100644
> > --- a/drivers/platform/x86/intel_int0002_vgpio.c
> > +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> > @@ -127,6 +127,14 @@ static irqreturn_t int0002_irq(int irq, void *data)
> >       return IRQ_HANDLED;
> >  }
> >
> > +static bool int0002_check_wake(void *data)
> > +{
> > +     u32 gpe_sts_reg;
> > +
> > +     gpe_sts_reg = inl(GPE0A_STS_PORT);
> > +     return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
> > +}
> > +
> >  static struct irq_chip int0002_byt_irqchip = {
> >       .name                   = DRV_NAME,
> >       .irq_ack                = int0002_irq_ack,
> > @@ -220,6 +228,7 @@ static int int0002_probe(struct platform_device *pdev)
> >               return ret;
> >       }
> >
> > +     acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
> >       device_init_wakeup(dev, true);
> >       return 0;
> >  }
> > @@ -227,6 +236,7 @@ static int int0002_probe(struct platform_device *pdev)
> >  static int int0002_remove(struct platform_device *pdev)
> >  {
> >       device_init_wakeup(&pdev->dev, false);
> > +     acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
> >       return 0;
> >  }
> >
> >
>
>
>
>


-- 
With Best Regards,
Andy Shevchenko
