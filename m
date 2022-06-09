Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1554C544380
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 08:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiFIGBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 02:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiFIGBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 02:01:38 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D62F657
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 23:01:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q140so5867996pgq.6
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 23:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xsmXT+fov1uIJOGfnkx7OBmlj5QB62NlbxLwX/SEf4=;
        b=H7ru7Fa42o1or9lk4g84hPWYoj2W8dWcXzTbIZ3HTOBBxvEaPSfWUf3+rhP0yQICIP
         4bBKZ95hQjqcTYRWktfVDak7d/eQb43QrKDTUv3jGJpHV7RWjK3YTrLnJjj0Sc4MuPr2
         uU53O30l/ROyGi/bIEwkDL91cweIrLYqYTB7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xsmXT+fov1uIJOGfnkx7OBmlj5QB62NlbxLwX/SEf4=;
        b=esYA8npodiHOeKFMZUONul3+tKO6G71VvwkOMEJ+ROtJuQi06qPvEm7S4iW9E5NAts
         ovQZVtkWkwpDwjtvKWruoJ+NHiwzVtpacKlFSJvSMW0VRloaUMoYUZoMirbnNMldcdJE
         76mkcFVbBG9R4ypU+wu+TQoqiz8Dhh6ibS4ZvkwE90YXJf3eAPidWqb3kkx/UiaP2bVy
         k7vRQeuibfOubkvsRYE5Lrxg6rOuIi1HI4NjtJf1rRiPnoj4Hnhkkcz+GZ4uNAJEVMZq
         n/vC1TXY6V/WAddw14NJRitjAUQWC4rwNiA9PalheYIZ32+I0qFgGz1r4RRzDuhiQqoQ
         vtjw==
X-Gm-Message-State: AOAM533wdb3E1yFlCGV7CnK13R+yB4894e2Nmpfj+o2sXR9M6zlS6k/f
        8bkkAfnqFq67uv4nvTbxgDZu8zO6SSgk5L/IZbe6Yw==
X-Google-Smtp-Source: ABdhPJxyHN4S6SbbAv8YyLaVIAoaMOoDSBzlHbhxPE6fBj8v40/93K+NYdZLJIMK0uQ0SOdsVu48SgiDFVDTCNK1/1Q=
X-Received: by 2002:a63:5610:0:b0:3f2:7e19:1697 with SMTP id
 k16-20020a635610000000b003f27e191697mr32916378pgb.74.1654754496325; Wed, 08
 Jun 2022 23:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com> <YqGJnORzbp2xiEU3@matsya>
In-Reply-To: <YqGJnORzbp2xiEU3@matsya>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Thu, 9 Jun 2022 08:01:24 +0200
Message-ID: <CAOf5uwkxit8kAAmwWGgTqR57m_SRmAxere10rCucOuBHU5+8fw@mail.gmail.com>
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

Hi

On Thu, Jun 9, 2022 at 7:48 AM Vinod Koul <vkoul@kernel.org> wrote:
>
> On 07-06-22, 11:58, Dario Binacchi wrote:
> > Driver registration fails on SOC imx8mn as its supplier, the clock
> > control module, is not ready. Since platform_driver_probe(), as
> > reported by its description, is incompatible with deferred probing,
> > we have to use platform_driver_register().
> >
> > Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
> > Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > Cc: stable@vger.kernel.org
> >
> > ---
> >
> > Changes in v2:
> > - Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.
> >
> >  drivers/dma/mxs-dma.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > index 994fc4d2aca4..b8a3e692330d 100644
> > --- a/drivers/dma/mxs-dma.c
> > +++ b/drivers/dma/mxs-dma.c
> > @@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
> >       return mxs_chan->status;
> >  }
> >
> > -static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
> > +static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
>
> why drop __init for these...?
>

I think that you refer to the fact that it can not be compiled as a
module, am I right?

Michael

> >  {
> >       int ret;
> >
> > @@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
> >                                    ofdma->of_node);
> >  }
> >
> > -static int __init mxs_dma_probe(struct platform_device *pdev)
> > +static int mxs_dma_probe(struct platform_device *pdev)
> >  {
> >       struct device_node *np = pdev->dev.of_node;
> >       const struct mxs_dma_type *dma_type;
> > @@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
> >               .name   = "mxs-dma",
> >               .of_match_table = mxs_dma_dt_ids,
> >       },
> > +     .probe = mxs_dma_probe,
> >  };
> >
> > -static int __init mxs_dma_module_init(void)
> > -{
> > -     return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
> > -}
>
> > -subsys_initcall(mxs_dma_module_init);
> > +module_platform_driver(mxs_dma_driver);
> > --
> > 2.32.0
>
> --
> ~Vinod
