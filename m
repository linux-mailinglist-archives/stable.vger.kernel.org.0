Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD7D3A9BD0
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhFPNV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 09:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFPNVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 09:21:55 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0040C061760
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 06:19:48 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id p15so2987026ybe.6
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 06:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KKFaNOwJJ64HA8ycqQn/B1R6RULjAs1yadcEz9FL+Y=;
        b=SvHBAiYWj2gb1Kt2U4ro6iveRaJsLCayhCgHPdsYZnulD/5J//5IlSdxpNfQ+IGMBE
         LaMZprglaEJ7LN9/91lYEewFQ9EHDnC6a/YrjQZkhJKhyU281o/ms5k6bDfo53gH7mYl
         MgtEI9bGDvNgcbwzvPQj+ccSw9/dn3ZD3r9Aep8jJCYJMqD86gaDEpSUGEw2JzD9T0gK
         oYKg46u2TpAPsJeezXTkqcfR5LBFpYHfW2o9NhP70jyjpwzszoo2WfoWz0g00ewzMHqu
         Qei9buSfeLUNPLjpv37PF3lt7m+HqwRqXaS21dKeTfKCdvSH4buNCdM/hoEj8pzIJTkw
         Ypkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KKFaNOwJJ64HA8ycqQn/B1R6RULjAs1yadcEz9FL+Y=;
        b=VW5/+jTvt1Q0K9oxmdA+/Mnfo2lD1v+jfj59+Gkx0Fy3yxqP6LREtujbScsyJ+79n7
         ISyqH6ywfOlEMkuBMrVRmurKD0Crtojvd0xTSVdLyiGiSvnZmo3ANs86JbYLiHnKhL0K
         FC46SWJ30zerYe8AISIkwfPKutmtwp00qTpmjUdBfOFFEoIShDQN4+3khjvylM+q0uUy
         qRMwOOVaQTkNnMEKTLO5yAj4Y1vfNgNxq3IxpaHkMlqGpQbViZH28IwbovcvfNM5J73S
         sRANIwrZTuik5SRBtA3dBNYhTJ0sqPKjy6uQPbkZ7rlVYyJDWa0ut5ARxEYF0F6atBhL
         MSZg==
X-Gm-Message-State: AOAM531mXqzQUgXAmKeE9VnIU0Kz7wU4S0nvaoFY7n6fWD0UMI1XIHPP
        o+LFiCoS6ToUTHO7GPHUaFY7qqCJHJHGOpiKJ+MsgQ==
X-Google-Smtp-Source: ABdhPJyD6+8mGf3jT8Jh+SCs5I4T5guERNb2S8GwEwtPq1cl1WRnWZ2lnFKBAIrGCBOSuWk8GPK+qm9V9cvBEV8M6DA=
X-Received: by 2002:a25:7ac5:: with SMTP id v188mr6959662ybc.132.1623849587386;
 Wed, 16 Jun 2021 06:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com> <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
In-Reply-To: <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 16 Jun 2021 15:19:35 +0200
Message-ID: <CANn89iKsJieaBwtb1DbxCbdsSYCQfO6MiUb0JDkWdCp7JnL-kw@mail.gmail.com>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
To:     David Laight <David.Laight@aculab.com>
Cc:     Amit Klein <aksecurity@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 12:19 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Amit Klein
> > Sent: 16 June 2021 10:17
> ...
> > -#define IP_IDENTS_SZ 2048u
> > -
> > +/* Hash tables of size 2048..262144 depending on RAM size.
> > + * Each bucket uses 8 bytes.
> > + */
> > +static u32 ip_idents_mask __read_mostly;
> ...
> > +    /* For modern hosts, this will use 2 MB of memory */
> > +    idents_hash = alloc_large_system_hash("IP idents",
> > +                          sizeof(*ip_idents) + sizeof(*ip_tstamps),
> > +                          0,
> > +                          16, /* one bucket per 64 KB */
> > +                          HASH_ZERO,
> > +                          NULL,
> > +                          &ip_idents_mask,
> > +                          2048,
> > +                          256*1024);
> > +
>
> Can someone explain why this is a good idea for a 'normal' system?
>
> Why should my desktop system 'waste' 2MB of memory on a massive
> hash table that I don't need.

Only if your desktop has a lot of RAM.

Otherwise the table will be smaller (like it was before this patch)

> It might be needed by systems than handle massive numbers
> of concurrent connections - but that isn't 'most systems'.
>
> Surely it would be better to detect when the number of entries
> is comparable to the table size and then resize the table.

Please send a patch, instead of always complaining about what others do.

Security comes first.

Then eventually we can ' optimize' .

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
