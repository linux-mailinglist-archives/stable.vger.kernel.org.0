Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3164A5AC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiLLRPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiLLRPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:15:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231EA12762
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0FEBB80DD3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 17:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5AEC433EF;
        Mon, 12 Dec 2022 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670865316;
        bh=1r4VeIPQoxBxr+R/GTIMW5mPAXzswVki/cBhc9Sm3EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSSWVAtr8pvsCd4WGz3z0UbXPFf1saPmad6R1+2dGMtSpeviasUnz773qCSEn+aGY
         d/Ii3qrtUjTkpkGo4LCD9cmotgrEA9xNXubfMwUG2P/9W4fayubcyhVUQ4svgpb4wP
         q4XWHS/V+nB/7/cVbnS7os+oJq/xd5iau5nTn31E=
Date:   Mon, 12 Dec 2022 18:15:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local
 variables
Message-ID: <Y5dhoACgKZDWAYne@kroah.com>
References: <20221212130926.811961601@linuxfoundation.org>
 <20221212130929.453689464@linuxfoundation.org>
 <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 03:30:14PM +0100, Bartosz Golaszewski wrote:
> On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Bartosz Golaszewski <brgl@bgdev.pl>
> >
> > [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
> >
> > Drop unneeded whitespaces and put the variables of the same type
> > together for consistency with the rest of the code.
> >
> > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpio/gpiolib.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 320baed949ee..a87c4cd94f7a 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
> >                                struct lock_class_key *request_key)
> >  {
> >         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> > -       unsigned long   flags;
> > -       int             ret = 0;
> > -       unsigned        i;
> > -       int             base = gc->base;
> >         struct gpio_device *gdev;
> > +       unsigned long flags;
> > +       int base = gc->base;
> > +       unsigned int i;
> > +       int ret = 0;
> >
> >         /*
> >          * First: allocate and populate the internal stat container, and
> > --
> > 2.35.1
> >
> >
> >
> 
> This isn't a fix, please drop it from stable.

It's required for a follow-on fix in the series, based on the line:

	Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")

Do you want that one?  If not, then we can drop them all.

thanks,

greg k-h
