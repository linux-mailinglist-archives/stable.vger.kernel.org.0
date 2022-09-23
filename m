Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB25E75A5
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 10:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiIWIZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 04:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiIWIZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 04:25:09 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4FBFFA40
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 01:25:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d12-20020a05600c3acc00b003b4c12e47f3so2759396wms.4
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ke09TjycQ0LINpMRhSyB/jx12xEQs5rDcMmrlCsezKA=;
        b=ZmFhiTFV585Hf9AhTdWzZQnGaLPHIGDz9k60x/LzqDMttxUXfFxC/ce+x5z8AVl5lm
         v7A6PYU09n3KQPe8XYIpUgbif2bkvnxVrMPWiL5u0bzA8xV3Ko/MF5Z9yqp4peitktgJ
         kYHlT+FQd9a6oa7vaGtxsfUnvp/6mwzV2DI8hzhczdXOISZN7vRCH3BwqR7G0BREmEEo
         pIt6AYadCT4G8pvctbwbR+70O4gtvCoW+LA96Hj5qeAzs4cQn0BAkHQDzg9B8zVWYdKJ
         U3sOm4H7HmviYywDRcjwcmjMHFr4rG21bKYL6SdSFdpfyWQVpbTdwyFbtGg0ierX8d/s
         pQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ke09TjycQ0LINpMRhSyB/jx12xEQs5rDcMmrlCsezKA=;
        b=Zo469FYVEixdvfGJIkKAho1thT4DxsOX3O6ku2Kr7z3B8l7L1PxOcRTqpq03LtWrng
         VBopyk18SStX1IwltUqNzkhQjFNHUYD0RmhrT5wzWkMhp+MKmFBLOetdeGiqTjS/h1fZ
         vgqQd1zqVfkitnnfuZMc239fQi0g95q9MgS/DvlG8sUzAcApiS+n7MLYn6AE38vGRQsF
         hJSiRS+rGoZWh5NSxze3RWWfN8cClgdmamP9CQTtnPr51/9EeFp21RT6C2UkpsJ8SImz
         DeovVBLGPINXSAh4cBZX13Z8uOpXJJykTuR+MLQWdxbOgFxSlkos2YRPlTDBc+aGpjmQ
         feYQ==
X-Gm-Message-State: ACrzQf3S8ciTsG09Eg0Cg3VVxl1bXTwZLmCFaKEaMTYcRnNznLVMtwqq
        BFnKZfjI9rd12NO7QP/evwRptscZipiZ3ymUnA307A==
X-Google-Smtp-Source: AMsMyM5rR5jhX+vNbFH9pE5yPOQkUsNINX6qJT7F9rZsp53/ty7BgPHKXULs6U/AyqAQPTQxa5wG3Y+Qobzw2qStsKU=
X-Received: by 2002:a7b:ca54:0:b0:3b4:fb06:9b1 with SMTP id
 m20-20020a7bca54000000b003b4fb0609b1mr4945582wml.67.1663921506179; Fri, 23
 Sep 2022 01:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220919122033.86126-1-ulf.hansson@linaro.org>
 <20220921155634.owr5lncydsfpo7ua@bogus> <CAPDyKFpgHDzc5Rv+0Tn4zegDTrc_wuymez02XLEdVUaEOornNw@mail.gmail.com>
 <20220922110406.cuovmxtw2jkn4f4h@bogus>
In-Reply-To: <20220922110406.cuovmxtw2jkn4f4h@bogus>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 23 Sep 2022 10:24:29 +0200
Message-ID: <CAPDyKFoACBZJVfdcbVd8hnw=BP-OH6kk06jpYqUsDHRAgjrTbQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "firmware: arm_scmi: Add clock management to the
 SCMI power domain"
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Dien Pham <dien.pham.ry@renesas.com>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        linux-arm-kernel@lists.infradead.org, Peng Fan <peng.fan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Pitre <npitre@baylibre.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Sept 2022 at 13:04, Sudeep Holla <sudeep.holla@arm.com> wrote:
>
> On Wed, Sep 21, 2022 at 08:46:21PM +0200, Ulf Hansson wrote:
> > On Wed, 21 Sept 2022 at 17:56, Sudeep Holla <sudeep.holla@arm.com> wrote:
> > >
> > > Hi Dien, Gaku,
> > >
> > > On Mon, Sep 19, 2022 at 02:20:33PM +0200, Ulf Hansson wrote:
> > > > This reverts commit a3b884cef873 ("firmware: arm_scmi: Add clock management
> > > > to the SCMI power domain").
> > > >
> > > > Using the GENPD_FLAG_PM_CLK tells genpd to gate/ungate the consumer
> > > > device's clock(s) during runtime suspend/resume through the PM clock API.
> > > > More precisely, in genpd_runtime_resume() the clock(s) for the consumer
> > > > device would become ungated prior to the driver-level ->runtime_resume()
> > > > callbacks gets invoked.
> > > >
> > > > This behaviour isn't a good fit for all platforms/drivers. For example, a
> > > > driver may need to make some preparations of its device in its
> > > > ->runtime_resume() callback, like calling clk_set_rate() before the
> > > > clock(s) should be ungated. In these cases, it's easier to let the clock(s)
> > > > to be managed solely by the driver, rather than at the PM domain level.
> > > >
> > > > For these reasons, let's drop the use GENPD_FLAG_PM_CLK for the SCMI PM
> > > > domain, as to enable it to be more easily adopted across ARM platforms.
> > > >
> > > > Fixes: a3b884cef873 ("firmware: arm_scmi: Add clock management to the SCMI power domain")
> > > > Cc: Nicolas Pitre <npitre@baylibre.com>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > ---
> > > >
> > > > To get some more background to $subject patch, please have a look at the
> > > > lore-link below.
> > > >
> > > > https://lore.kernel.org/all/DU0PR04MB94173B45A2CFEE3BF1BD313A88409@DU0PR04MB9417.eurprd04.prod.outlook.com/
> > > >
> > >
> > > If you have any objections, this is your last chance to speak up before
> > > the original change gets reverted in the mainline with this patch.
> > >
> > > Hi Ulf,
> > >
> > > I don't have any other SCMI changes for v6.0 fixes or v6.1
> > > I am fine if you are happy to take this via your tree or I can send it
> > > to SoC team. Let me know. I will give final one or 2 days for Renesas
> > > to get back if they really care much.
> >
> > I have a slew of fixes for mmc that I intend to send next week, I can
> > funnel them through that pull request.
> >
> > Assuming, Renesas folkz are okay, I consider that as an ack from you, right?
> >
>
> Yes for official reasons, here is the formal :)
>
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>
>

Thanks!

> in case you manage to get this in via your tree.

I have now queued up the patch through
git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git fixes

Let's see how it goes when it gets tested in linux-next.

>
> --
> Regards,
> Sudeep

Kind regards
Uffe
