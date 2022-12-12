Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87764A6B2
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 19:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiLLSKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 13:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiLLSId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 13:08:33 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1042663
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 10:08:18 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id q7so316518vka.7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 10:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vXLSgPHrhLyITa/VJ/SmFb1U95aXrYkUr0JoPBjWHPI=;
        b=Cf+XEqzxD/Jq5nBI5Tko9b7o50fvBuJP9OEBjB4shGnHMizeg1uIzzoc1ajw2beUOq
         ASUbV7Zqg3NhKiRTALczuxgcZjY9nd4Uc6XKY8M3mlXqIYwA8mYJLeqqshIiHlSMAH3Z
         MFEf47SqRhKEPSlV3vhDjWrj69wCKv8zo8LMvTwdSkLndbId7zyOHjk0jL3dWkmTAe+Z
         4S3/6IHe4mHJRAXSig6noLWi9xXgpkGUTwDL+xz9ebGeILJHGbWCojMLvJOs99oXisfW
         J/rRaWeUffLX5k7Uaz+0QHz59OKuu5MoNN414uE8VbFptoZn5TI6vAbYDW9+tf/gcvWy
         R93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXLSgPHrhLyITa/VJ/SmFb1U95aXrYkUr0JoPBjWHPI=;
        b=H88VD/YTmhzyvbxH6RvzSZEJL2zpg+1wWHc6sWOid0ycbbLsekknMikkzkG9gMEYA3
         80WMDwmjo4CrtPiUtfblmOOx0WBFXox19uowvg7VmK1zej+6LgBIcp0Pk4Ubbr0lSc8p
         KIXMAygj5/bceEymCVwv4LcWVgDEEpRWISsy03XrdeX/vhLpvbntLYFXvproNbwwDP30
         8RpKH18hFKhxO69qgTJ2ivy0kUNiZlXQkSgmdwnBCqilxWPoQJfp9wRQJ8yyr0NEEkZL
         heR+39tj5FDxM/uwpQRu3Z8qtzufDQ8T/mt+IIbVbjMU/854j5vcohps9m1/kOVcKd1i
         MmEQ==
X-Gm-Message-State: ANoB5pmI+RaO+Mnp2OaVUjuW5NDQnqKEZv7rR59IkXRz2ZXeEqrRvBF3
        +rhiGIrNNCLSkju4/YqNLxarJPc7V7aXUCLijMVraznZqTRmDw==
X-Google-Smtp-Source: AA0mqf6PMa/zNy1AtzEoewEX6ozwo2cSWoIteF78CEb+GDa5WMnsSISjyhgnOpOv5CVmDuGmXrVRiNtk6C6nw2CJHcs=
X-Received: by 2002:a05:6122:20a9:b0:3c1:534:8487 with SMTP id
 i41-20020a05612220a900b003c105348487mr416037vkd.33.1670868497805; Mon, 12 Dec
 2022 10:08:17 -0800 (PST)
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.453689464@linuxfoundation.org>
 <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com> <Y5dhoACgKZDWAYne@kroah.com>
In-Reply-To: <Y5dhoACgKZDWAYne@kroah.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 12 Dec 2022 19:08:06 +0100
Message-ID: <CAMRc=MemrLEFgRX+ru=iN_pW6hqVkMYxzCrohUdNLqD4-TcLaw@mail.gmail.com>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local variables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 6:15 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 12, 2022 at 03:30:14PM +0100, Bartosz Golaszewski wrote:
> > On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Bartosz Golaszewski <brgl@bgdev.pl>
> > >
> > > [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
> > >
> > > Drop unneeded whitespaces and put the variables of the same type
> > > together for consistency with the rest of the code.
> > >
> > > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/gpio/gpiolib.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > > index 320baed949ee..a87c4cd94f7a 100644
> > > --- a/drivers/gpio/gpiolib.c
> > > +++ b/drivers/gpio/gpiolib.c
> > > @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
> > >                                struct lock_class_key *request_key)
> > >  {
> > >         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> > > -       unsigned long   flags;
> > > -       int             ret = 0;
> > > -       unsigned        i;
> > > -       int             base = gc->base;
> > >         struct gpio_device *gdev;
> > > +       unsigned long flags;
> > > +       int base = gc->base;
> > > +       unsigned int i;
> > > +       int ret = 0;
> > >
> > >         /*
> > >          * First: allocate and populate the internal stat container, and
> > > --
> > > 2.35.1
> > >
> > >
> > >
> >
> > This isn't a fix, please drop it from stable.
>
> It's required for a follow-on fix in the series, based on the line:
>
>         Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
>
> Do you want that one?  If not, then we can drop them all.
>
> thanks,
>
> greg k-h

Yes, we do want it. Go ahead then, thanks!

Bart
