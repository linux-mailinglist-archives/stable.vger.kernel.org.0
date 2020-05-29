Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23731E86EC
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgE2SqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 14:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgE2SqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 14:46:07 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE9EC03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 11:46:06 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id w20so1160408uaa.2
        for <stable@vger.kernel.org>; Fri, 29 May 2020 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tNT7fd5a5yCD0C0Z2Z4mwv1x2FkdYNtaJ3P0m6Fclrk=;
        b=b1MYcNOgv1z4rpkHsSr88+iEZMenD4UkJ6g3KlTefzvkaBidRRIzFtkNptDlZrSp5o
         N1vDR/d6VlcU0pdFdhgaWiSpIs3B218HmqY6GbOiQah2GZt6ephq1jdGWEduptGQpYY2
         AoiTcDDN5kg6WG93MEIYvJDL6nzG8WMOiJMX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tNT7fd5a5yCD0C0Z2Z4mwv1x2FkdYNtaJ3P0m6Fclrk=;
        b=m8vP9N9AnUItAXSnE8H0BIz3Z4UtoWfpBZ0NLj0s34zREwD7yj4d9i/mfpoV7SyAlN
         UoiyeAkQri7oDflk2LLMVTqYauH3iUDGXMyKMXXxtGVDKicFYP3K+lwTAq8RFE3hI57r
         oe1ZgIsACu1PZryshGfxa8zugQAdgp4ze/Iyy+UpOa2Ft53EJuk30Pi3O30LRr2dOjk5
         sHaLT2EhSL6giE5aqkJMLsVO5e2DK3sTZIiKMDrvLklnyBfnxuifW0PXYLNUstZmFtVo
         2yNeb3S5wESp91j5cd89WMCrV84n4IAdckn/z2d1dvnUH0rsi0m2xEH3Qtv6HdFUI+Ys
         08ag==
X-Gm-Message-State: AOAM5300UfelN0pDRsRRL4XEdWXdcxrcAcz2AwreFJRyEJFx9/RS3TZ8
        LC7h223k1aBV651PxrpbCEJW+F4V2II=
X-Google-Smtp-Source: ABdhPJwlf6RoiYdbaCx0D75Rk+tPYaaF8T5VjwczWHvb1/6g2rjZrpRHnDuBnrFRruvqAS7hG4bA8g==
X-Received: by 2002:ab0:7406:: with SMTP id r6mr7150240uap.83.1590777965667;
        Fri, 29 May 2020 11:46:05 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id a4sm1261150uak.13.2020.05.29.11.46.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 11:46:05 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id w20so1160389uaa.2
        for <stable@vger.kernel.org>; Fri, 29 May 2020 11:46:05 -0700 (PDT)
X-Received: by 2002:a9f:24c1:: with SMTP id 59mr7147726uar.91.1590777964650;
 Fri, 29 May 2020 11:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
 <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com> <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
In-Reply-To: <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 29 May 2020 11:45:53 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
Message-ID: <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Frank Mori Hess <fmh6jj@gmail.com>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, May 29, 2020 at 11:21 AM Frank Mori Hess <fmh6jj@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 1:53 PM Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > I don't get it.  A hypothetical machine could have literally anything
> > > sharing the IRQ line, right?
> >
> > It's not a real physical line, though?  I don't think it's common to
> > have a shared interrupt between different IP blocks in a given SoC.
> > Even if it existed, all the drivers should disable their interrupts?
>
> I don't know, it's a hypothetical machine so it can be whatever you
> want.  The driver requests shared irqs, if it doesn't actually support
> irq sharing, it shouldn't request them.

I guess?  As I understood it drivers have to be very carefully coded
up to support sharing their IRQ with someone else and I'm not
convinced dwc2 does that anyway.  Certainly it doesn't hurt to keep
dwc2 clean, but until I see someone that's actually sharing dwc2's
interrupt and I can actually see an example I'm not sure I'm going to
spend too much time thinking about it.


> > > Anyways, my screaming interrupt occurs after a a new kernel has been
> > > booted with kexec.  In this case, it doesn't matter if the old kernel
> > > called disable_irq or not.  As soon as the new kernel re-enables the
> > > interrupt line, the kernel immediately disables it again with a
> > > backtrace due to the unhandled screaming interrupt.  That's why the
> > > dwc2 hardware needs to have its interrupts turned off when the old
> > > kernel is shutdown.
> >
> > Isn't that a bug with your new kernel?  I've seen plenty of bugs where
> > drivers enable their interrupt before their interrupt handler is set
> > to handle it.  You never know what state the bootloader (or previous
> > kernel) might have left things in and if an interrupt was pending it
> > shouldn't kill you.
>
> It wouldn't hurt to add disabling of the dwc2 irq early in dwc2
> initialization,

More than it not hurting, I'd consider it a bug in the driver (and a
much more serious one than shutdown not disabling the interrupt).


> but why leave the irq screaming after shutdown?

Sure.  So I guess the answer is to just do both disable the interrupt
and make sure that the interrupt handler has finished.

dwc2_disable_global_interrupts(hsotg);
disable_irq(hsotg->irq);


-Doug
