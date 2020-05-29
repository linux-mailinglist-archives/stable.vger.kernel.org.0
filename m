Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14081E85CD
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgE2RxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 13:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgE2RxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 13:53:00 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BC5C03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 10:53:00 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id j28so883313vkn.8
        for <stable@vger.kernel.org>; Fri, 29 May 2020 10:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXouIx5WMRfY8w9hWVivEqxw6CeWAJ8tU5AUL0ftr0c=;
        b=UHgWYH6We6HynzL26DIG9y/wKuyOjYnXyQVbzX1eR7m7DNouwHSPro7wd2ZVIfDcLh
         delkUc2rpChJ76CzVAtqkYqUKG8JzL49FCiymRse13GqVozituA3LV1anhsI71dnw9te
         TSWoo7jARxDanxDtkdrq4UpySKLXD4TSwtdF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXouIx5WMRfY8w9hWVivEqxw6CeWAJ8tU5AUL0ftr0c=;
        b=BE5IrG1awpHY2ElOhq3jVMF9yAmdIUHfCjuwnLncuxWLdM+MM0VeQBgVQ2I0ihKbAt
         atotQLzbFlLBuwxGKrqKMeZ6jvebus379otuh7wpxXgIKERB5NGgBftedB61n394GBst
         s8I7Pp4FTUVY4pTPcAclIQ7xOWpob0hkCvG+8jLOd1qCzQwpUlQwKkF4yqLnk6tF+ED4
         1JorUjgwXU2/FS8OLk6YgdUzpM5Mye5zXfOFEZBIKMjrYMfBli/ztc7eWuFLkW1K/Z3e
         JRDUoRj9Zp2+kzKeT3shN5m3wLqdD/+H7mTVAnvFyAr6Lfw5ymjnBWNICKEf900rs2hX
         NdSA==
X-Gm-Message-State: AOAM533AeOq7T/a6Ua4u9n/ZFNzw6+vejDBl81oCaV1AZ9PQbKpBeKjI
        rg2uc1j5LikUSrilXFGMvOwvu5DmnFg=
X-Google-Smtp-Source: ABdhPJx5MyNa52BoUoUunDBhwfFHIlULnpIxjnnr3Xv2jAVwzRITS+gy9cjEeiBpHUZBydI66qnz2A==
X-Received: by 2002:a1f:6014:: with SMTP id u20mr7237844vkb.37.1590774779290;
        Fri, 29 May 2020 10:52:59 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id s2sm1254127uaq.11.2020.05.29.10.52.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 10:52:58 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id g129so2002568vsc.4
        for <stable@vger.kernel.org>; Fri, 29 May 2020 10:52:58 -0700 (PDT)
X-Received: by 2002:a67:b14b:: with SMTP id z11mr6770843vsl.109.1590774778291;
 Fri, 29 May 2020 10:52:58 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
In-Reply-To: <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 29 May 2020 10:52:47 -0700
X-Gmail-Original-Message-ID: <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
Message-ID: <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Frank Mori Hess <fmh6jj@gmail.com>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko.stuebner@collabora.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, May 29, 2020 at 10:45 AM Frank Mori Hess <fmh6jj@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 12:37 PM Doug Anderson <dianders@chromium.org> wrote:
> >
> > I'm not sure I understand.  Are you saying that you'll just add
> > shutdown callbacks to all the drivers using this IRQ and call
> > disable_irq() there?  That seems like the best solution to me.
>
> I don't get it.  A hypothetical machine could have literally anything
> sharing the IRQ line, right?

It's not a real physical line, though?  I don't think it's common to
have a shared interrupt between different IP blocks in a given SoC.
Even if it existed, all the drivers should disable their interrupts?


> If it is important to call disable_irq
> during shutdown (I have no idea if it is) then shouldn't the kernel
> core just disable all irqs after calling all the driver shutdown
> callbacks?

It seems like a reasonable idea for this to be in the core but I
haven't dug into whether the core has enough knowledge or if there
would be other problems.


> Anyways, my screaming interrupt occurs after a a new kernel has been
> booted with kexec.  In this case, it doesn't matter if the old kernel
> called disable_irq or not.  As soon as the new kernel re-enables the
> interrupt line, the kernel immediately disables it again with a
> backtrace due to the unhandled screaming interrupt.  That's why the
> dwc2 hardware needs to have its interrupts turned off when the old
> kernel is shutdown.

Isn't that a bug with your new kernel?  I've seen plenty of bugs where
drivers enable their interrupt before their interrupt handler is set
to handle it.  You never know what state the bootloader (or previous
kernel) might have left things in and if an interrupt was pending it
shouldn't kill you.

-Doug
