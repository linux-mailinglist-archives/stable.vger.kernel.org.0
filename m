Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061F25BEBA0
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 19:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiITRLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 13:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiITRLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 13:11:07 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A3732EE7
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 10:11:02 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id h194so2846364iof.4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 10:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=O7ytbqe6pVXPKn3iwKh9mY6CEL72Jgs7iEKkL0LhVbs=;
        b=JdDoIafpjc0KAZrMJe2Hq9W444dqYlBlCY4+SXElJz2zFAWzKBT+TMAjf1WD7Uqc7L
         8ercw89DHikKCgksXvr5NG2CeKDQ8CdiOTBh0mpHXIcf1oRkh9UOzzm7gqPoA5cedb/W
         hckQBJHtJ0x26cXFZSN6pbWNiCr7e37PLkEfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=O7ytbqe6pVXPKn3iwKh9mY6CEL72Jgs7iEKkL0LhVbs=;
        b=f/h+S94vBFJOOypeUiXCTrmHU5xIOQPyHwolTuKHJ1qsSrtzV99C7Nvaua1znnLAog
         1BWgWoxVD6KWVIhdZi/qRs00cfRleXy7A3W6mbu+TW1Y3n0nDwK2RY9tJxygFeIcpk9Y
         GuOuXtVy0IFDKI4NQwSSYjZxcYBppNobjRI9Yh9aPh5i+XuAHKoPi1Jv8/roZrYsClj2
         TaU4/yDMLNTYoOP8kRHr3NHeOO853t7zZRpAHDJs+Vk6xM3oSxhON9i1iH0i4TDYOG8B
         BRPOIt6ngwxCGNQF1uFMZ/KqqXbA6ZkAPwpmFBSkuPoXsZ/Hhoy37ZnwZvdJOiDN9DNw
         sFtw==
X-Gm-Message-State: ACrzQf15cyiIbtEa8Oqdo2fchyPqNdPA7HcQrnr1Ym8PDFxqGjVWXjkw
        cN3HxuPLhwPntIdmKGvGNYW271me3cBhh+RW4jwOBA==
X-Google-Smtp-Source: AMsMyM4WXHOfpPkGnaL7Unbx7ksz0tMuEQElxEqjzmapmTseoy904gX3GMBEDrPchr12o8drl0O2QjiQRTYe4pJSULo=
X-Received: by 2002:a02:c047:0:b0:35a:5fdc:1793 with SMTP id
 u7-20020a02c047000000b0035a5fdc1793mr11314390jam.155.1663693862018; Tue, 20
 Sep 2022 10:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com> <20220913163510.GR6477@pengutronix.de>
In-Reply-To: <20220913163510.GR6477@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 20 Sep 2022 19:10:48 +0200
Message-ID: <CABGWkvpur+A1UHwhJ6CCStyaYH79_aqJo4eWOW-s1p2jakbFMA@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 1/2] dmaengine: mxs: use platform_driver_register
To:     Vinod Koul <vkoul@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vinoud,

On Tue, Sep 13, 2022 at 6:35 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> Hi Dario,
>
> On Sun, Sep 04, 2022 at 04:10:19PM +0200, Dario Binacchi wrote:
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
>
> How I see it v3 of this patch is perfectly fine and should be taken
> instead of this one. I just commented that to v3.
>
> Not sure if Vinod would take v3, or if you should resend v3 as v6
> instead. If you do, you can add my Acked-by.
>
> Vinod, please let us know what you prefer.

Could you please let me know how to proceed? This patch has been pending for
a while and it's a real shame as the change is minimal and fixes a
real issue that is
still present in the mainline and stable kernels.

Thanks and regards,
Dario

>
> Sascha
>
> >
> > ---
> >
> > Changes in v5:
> > - Update the commit message.
> > - Add the patch "dmaengine: mxs: fix section mismatch" to remove the
> >   warning raised by this patch.
> >
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
>
> --
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |



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
