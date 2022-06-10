Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447DB54689E
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbiFJOof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiFJOo1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 10:44:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E2C1E6F81
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:44:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u2so24051190pfc.2
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 07:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGXmxiPiq/H1UclMpVPv5/Qgfv06wSp3ksL9v9oLJgc=;
        b=bZRdzxBN7gMLZi4+/x+OVWdO8Cd8DRvRKJ3ZFBiiUVqxmiW3fmbankCJjLDq9LfF+8
         ci0xANErpGOXSnk7DpMOACO5MlDA+/N5gtJshZaSvKD2YStHViDZli1vrxT4b/uhcXgf
         Ml3wTvLKSptzRQEr442XA36K95P8i+p2i1EAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGXmxiPiq/H1UclMpVPv5/Qgfv06wSp3ksL9v9oLJgc=;
        b=StEqmPoZqqAv4nn4BmNLJ/Vrd5g3Y47tIU5kmeaL/oFHOpRvJBYxKg6W7lT39EsCHD
         Qf4AM77h1pY8lrbKFoaPPpUdBjUe8F/4oKdLKpPUeLAW84YAb7pTMyyHO7GjVDYddY30
         9o/b5Quz5HofCY3aTb7HrZGI51zqRLoMb4VzL7tkkz21O5ItPp+3rd4zaGdFR0GcLGUL
         pxcI6bP9CUkaG5jPyLMFEkPVXjiqtuZrUCy1t39pLUN/3hGscxuah6gkfWH7wCLK+EKB
         ToPmCPxVOjED6EsQfCUV/A7xiQ/DLcaWSZ7EdN2SUf6r909IinVwGzMxXYXF7cJU2vKk
         Tiiw==
X-Gm-Message-State: AOAM530n/Bb8JbezsDlx0+jkjihdn1csf7+34Ypnbanct7gVEVsdeOpx
        s0KWrXHS7ih6CIQYbFVscCB7qg/FGFi4gEXFdvWw4w==
X-Google-Smtp-Source: ABdhPJw4wcjZSOMWeVevnGECplKcQZYTs22PVBsIbmPSyjOHqhMtqvvKvcsYCz1Wm3UM/2xfLr8+s/JQ/74QhCOoSgU=
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id
 z2-20020a056a00240200b004e13df25373mr113238475pfh.40.1654872262293; Fri, 10
 Jun 2022 07:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com>
 <YqGJnORzbp2xiEU3@matsya> <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
 <YqGODNACHfKKHBOf@matsya> <CAOf5uw=8j1F3tLE9fLAjFGhVt4WXsU7GJdCkEhPtAAxvzM2fyg@mail.gmail.com>
 <YqNLmixdb3fv7Cgs@matsya>
In-Reply-To: <YqNLmixdb3fv7Cgs@matsya>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Fri, 10 Jun 2022 16:44:10 +0200
Message-ID: <CAOf5uwmYCi0EfOL7M5yKpN8U5Hidn8uTpGwh_dZMHu8ZNioGEw@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] dmaengine: mxs: fix driver registering
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI

On Fri, Jun 10, 2022 at 3:48 PM Vinod Koul <vkoul@kernel.org> wrote:
>
> On 09-06-22, 08:18, Michael Nazzareno Trimarchi wrote:
> > Hi Vinod
> >
> > On Thu, Jun 9, 2022 at 8:07 AM Vinod Koul <vkoul@kernel.org> wrote:
> > >
> > > On 09-06-22, 08:01, Michael Nazzareno Trimarchi wrote:
> > > > Hi
> > > >
> > > > On Thu, Jun 9, 2022 at 7:48 AM Vinod Koul <vkoul@kernel.org> wrote:
> > > > >
> > > > > On 07-06-22, 11:58, Dario Binacchi wrote:
> > > > > > Driver registration fails on SOC imx8mn as its supplier, the clock
> > > > > > control module, is not ready. Since platform_driver_probe(), as
> > > > > > reported by its description, is incompatible with deferred probing,
> > > > > > we have to use platform_driver_register().
> > > > > >
> > > > > > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > > > > > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > > > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > >
> > > > > > ---
> > > > > >
> > > > > > Changes in v2:
> > > > > > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> > > > > >
> > > > > >  drivers/dma/mxs-dma.c | 11 ++++-------
> > > > > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > > > > > index 994fc4d2aca4..b8a3e692330d 100644
> > > > > > --- a/drivers/dma/mxs-dma.c
> > > > > > +++ b/drivers/dma/mxs-dma.c
> > > > > > @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> > > > > >       return mxs_chan->status;
> > > > > >  }
> > > > > >
> > > > > > -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > > > > +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > > > >
> > > > > why drop __init for these...?
> > > > >
> > > >
> > > > I think that you refer to the fact that it can not be compiled as a
> > > > module, am I right?
> > >
> > > It is still declared as a module_platform_driver... From changelog I can
> > > understand that you are changing init level from subsys to module (in
> > > fact clocks should be moved up as arch level and dmaengine users as
> > > module) ...
> >
> > The way the driver was using to register was:
> > platform_driver_probe(&driver, driver_probe);
> >
> > The function try to register the driver, one time and if the
> > dependences is not satisfied,
> > then there will not a next try, so the driver initialized that way can
> > not depends to anything
> > apart himself, or all the dependencies should be ready at the time the
> > driver_probe is called
>
> There are two ways to solve this, you lowered the init level of this
> driver but your consumers are going to have same issue...
>

Consumers are platform drivers that support -EPROBE_DEFER. Is a problem
this approach?

> >
> > >
> > > But why remove __init declaration from these? Whatever purpose that may
> > > solve needs to be documented in changelog and perhaps a different patch
> > >
> >
> > I was thinking that driver can be compiled as module as other driver
> > but is bool and not tristate
>
> Ok, but why drop __init()

Was a mistake. Things marked as __init are dropped in the init
section. As I said this driver
can not be a .ko and must be in the kernel image, the __init can stay
there. Now I don't remember
how init section are used when a part of the kernel is compiled as
module, but anyway this driver
as only one initialization time

Sorry Vinod, but if you are not happy with the answer, I have the
feeling that you need to give more large
lesson on this topic

Michael


>
> --
> ~Vinod



-- 
Michael Nazzareno Trimarchi
Co-Founder & Chief Executive Officer
M. +39 347 913 2170
michael@amarulasolutions.com
__________________________________

Amarula Solutions BV
Joop Geesinkweg 125, 1114 AB, Amsterdam, NL
T. +31 (0)85 111 9172
info@amarulasolutions.com
www.amarulasolutions.com
