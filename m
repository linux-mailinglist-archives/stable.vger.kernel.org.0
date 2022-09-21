Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5485BFE6E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIUMwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIUMwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8679698762;
        Wed, 21 Sep 2022 05:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D3BDB82109;
        Wed, 21 Sep 2022 12:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F88BC433D6;
        Wed, 21 Sep 2022 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663764628;
        bh=kLAs3Of68tjCVcClxahDtNTJthmU+CNanmr3EQ7GBFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/3gn7vNZX+AgEMNdBAeJVaqjY9XuCF3vYoSTPMNAhdqDeGxmvFI+pSvBKa9xmqmW
         oLzMcxCxxhDmM+gs845MPcVfsv+iNN3+9XTP8xtFuIE9KG3YO50qezAWqXAZ3C5Baj
         PwEPbjDhzBveKOgp29P2N1azYzLpqFExjU/NwB1gAOWd/kkjbjq8KhUf2B4VIhMBBk
         kL5ziCe4KpCjpyJjV0ZURr4iw4il46YbqQA8x8D3vpHlde0bcgcxfsyztvghkY3fRn
         3TQSM+yTa22ZFFaYODJtxLvRkV4+yP7YXr3mTWrMb+LQQI2tBzVfb3+dlFYTWEMJMt
         2wyYZMY7vC9LA==
Date:   Wed, 21 Sep 2022 18:20:24 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH v5 1/2] dmaengine: mxs: use
 platform_driver_register
Message-ID: <YysIkA1zcql2JysN@matsya>
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
 <20220913163510.GR6477@pengutronix.de>
 <CABGWkvpur+A1UHwhJ6CCStyaYH79_aqJo4eWOW-s1p2jakbFMA@mail.gmail.com>
 <YyqDq9FL1W5gMveQ@matsya>
 <20220921103930.GM12909@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921103930.GM12909@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-09-22, 12:39, Sascha Hauer wrote:
> On Wed, Sep 21, 2022 at 08:53:23AM +0530, Vinod Koul wrote:
> > On 20-09-22, 19:10, Dario Binacchi wrote:

> > > > How I see it v3 of this patch is perfectly fine and should be taken
> > > > instead of this one. I just commented that to v3.
> > > >
> > > > Not sure if Vinod would take v3, or if you should resend v3 as v6
> > > > instead. If you do, you can add my Acked-by.
> > > >
> > > > Vinod, please let us know what you prefer.
> > > 
> > > Could you please let me know how to proceed? This patch has been pending for
> > > a while and it's a real shame as the change is minimal and fixes a
> > > real issue that is
> > > still present in the mainline and stable kernels.
> > 
> > Ooops, Somehow this seems to have really slipped. Sorry I owe you an
> > apology for this
> > 
> > I am still not sure of this patch yet, lets get it right and merged
> > quickly. I will send my review later today
> 
> I just realized that unlike what I said v3 of this patch is still wrong
> as it leaves the __init annotation on mxs_dma_init() which is called
> from (non __init) mxs_dma_probe(). v3 probably doesn't give a section
> mismatch warning because mxs_dma_init() is inlined.
> 
> Really v2 is the one we should take which is at:

hmmm, looking at the old revs, that does look sane. My question was why
__init change is there, it needs to be documented and if there are two
different reasons, add that

I agree rev 2 is the right things to do and changelog needs to add why
we dropped __init (i dont think this should be a different patchset as
that leads to warnings ...

> https://lore.kernel.org/linux-arm-kernel/20220523132247.1429321-1-dario.binacchi@amarulasolutions.com/T/

-- 
~Vinod
