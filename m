Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7736573187
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 10:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiGMIth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 04:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiGMItT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 04:49:19 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CE92A41C
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 01:49:09 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id e28so14370009lfj.4
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 01:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwMvLqGgcP0wBR0bNhcuKfU0ATNdPUk3da6NoGKAPGU=;
        b=RnR+F7eDnXF+oCIhwuc2bmXGzJZ5W2NIgWHR/GqFvsHL1l4l/E+zRzBisFMQNa53/1
         vcZPxlhGpcCglpBgM1baJfOR+yFISFoD+5l0ttc3ZCL7m4eR2ZTJuol5UchCvuEoV/Md
         P+NsU0qws8fo5srpfPQjxLsqhMRTNMrMis0bY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwMvLqGgcP0wBR0bNhcuKfU0ATNdPUk3da6NoGKAPGU=;
        b=1hmhU7XCT2wWLYw7r3xOvwljSoPWss5PVQDLMnTPbJkn77ZyqqWJP0SFd7F07wgRvN
         73KHU3x2qLf+hqK+YsebRRTVatkTLur6Aiv9f0jvResS9kPPet9w8N6q4oCF+ORh63gq
         vc98kkglXEmX5GaKKxoAHuWYYKPIs/nE0oGlVdhS7pX5T0ojM+i3nD/dSOEIQJNGpT03
         Hgrm85ZDsLOvi277pctyJLuqg8rkgc2o4HnPmlSWPlUnXNJ5kb5gddJa1rfLDxdvh7GB
         fj7vaYCH0fiYTZxP/+4p76u7O9S+XVBrwf0CEQPzJrE91eJ8SlWZJyM2I/+tk59zqUFP
         yI3Q==
X-Gm-Message-State: AJIora+w20twz3NXI2Xy2nb5Iq3mmjK4HGAmT2tzipmx/3Zw5TpG+jK8
        92lDRd4s7phSp7nba4eVTEvDUkG3zlJK96X6TZH6Ug==
X-Google-Smtp-Source: AGRyM1skpvUZak2idool7Js6Y/L6HiwNPp6zYDM5amQt/6ERfK+IG2HX8hrY5FvX1KrZdj1fhTjdXSg4Li1wYqa5xdk=
X-Received: by 2002:ac2:54a3:0:b0:486:76a9:29d0 with SMTP id
 w3-20020ac254a3000000b0048676a929d0mr1270009lfk.172.1657702148139; Wed, 13
 Jul 2022 01:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220712160909.2054141-1-dario.binacchi@amarulasolutions.com> <20220713084036.ipcd6bhcdb574w7h@pengutronix.de>
In-Reply-To: <20220713084036.ipcd6bhcdb574w7h@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Wed, 13 Jul 2022 10:48:57 +0200
Message-ID: <CABGWkvpJ5Hc8pQ-Rzu8z6Y_Cfa2pEC0C2ABT_FGp6r9Vyz-Gmw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] dmaengine: mxs: use platform_driver_register
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dmaengine@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marco,

On Wed, Jul 13, 2022 at 10:40 AM Marco Felsch <m.felsch@pengutronix.de> wrote:
>
> Hi Dario,
>
> On 22-07-12, Dario Binacchi wrote:
> > Driver registration fails on SOC imx8mn as its supplier, the clock
> > control module, is probed later than subsys initcall level. This driver
> > uses platform_driver_probe which is not compatible with deferred probing
> > and won't be probed again later if probe function fails due to clock not
> > being available at that time.
> >
> > This patch replaces the use of platform_driver_probe with
> > platform_driver_register which will allow probing the driver later again
> > when the clock control module will be available.
> >
> > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > Cc: stable@vger.kernel.org
> >
> > ---
> >
> > Changes in v5:
> > - Update the commit message.
> > - Create a new patch to remove the warning generated by this patch.
>
> Please squash this new patch into this patch since you introduce the
> warning with this patch.

In version 4 I had only one patch, but Vinod told me to separate the
patches like
this. I also think like you, but I did what Vinod asked me to do.
So, can you agree and actually tell me what to do?

Thanks and regards,
Dario

>
> Regards,
>   Marco
>
> > Changes in v4:
> > - Restore __init in front of mxs_dma_probe() definition.
> > - Rename the mxs_dma_driver variable to mxs_dma_driver_probe.
> > - Update the commit message.
> > - Use builtin_platform_driver() instead of module_platform_driver().
> >
> > Changes in v3:
> > - Restore __init in front of mxs_dma_init() definition.
> >
> > Changes in v2:
> > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> >
> >  drivers/dma/mxs-dma.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > index 994fc4d2aca4..18f8154b859b 100644
> > --- a/drivers/dma/mxs-dma.c
> > +++ b/drivers/dma/mxs-dma.c
> > @@ -839,10 +839,6 @@ static struct platform_driver mxs_dma_driver = {
> >               .name   = "mxs-dma",
> >               .of_match_table = mxs_dma_dt_ids,
> >       },
> > +     .probe = mxs_dma_probe,
> >  };
> > -
> > -static int __init mxs_dma_module_init(void)
> > -{
> > -     return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> > -}
> > -subsys_initcall(mxs_dma_module_init);
> > +builtin_platform_driver(mxs_dma_driver);
> > --
> > 2.32.0
> >
> >
> >



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
