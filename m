Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFA6889B3
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 23:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBBW1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 17:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjBBW1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 17:27:10 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAA2CC04
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 14:27:09 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id j17so5197434lfr.3
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 14:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNl1d9WjdzfG8r6+o/TTbbJlOXijTqxl4wlecMFWfHc=;
        b=W86IfmDtu2J4p+3OYOZAQ2kPhD4TOuckQrtBxpeHkGS4TFNPokFEKLLjCxRVjJzpnT
         /tMtxDN6d3ao0Yr4ZUPI8JgXfGBBZR0Zrlcu3uRRYTTwu2dDMHLktXbmieOoq62CMAMz
         8Rb5vGERLKakT/KMKZHBcOQs8aXITcg3SPmhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNl1d9WjdzfG8r6+o/TTbbJlOXijTqxl4wlecMFWfHc=;
        b=VouiWBcAC/9JXHcMY2eB4DVrAlUvJzXL+VFTJ0jinjDeheMGZJi71KtMVDt6YD9a6j
         Lkaf0rccMlI0lWHT4yh9vesgO8GYd/Rj7H9YP1NQ5JJwwGXVeF9K4vWlQA6LqAWE1mM7
         jP+nQr22/Hjngpu6nnbvCsGiyAnN+z8+P0m1E7QrZWd+5LhqY13q0X0LgAIMHKKSqN1/
         /HZy66mS/Sk75ssFHt02eRnkRe5ffgFuGkctptUekgokTv5asZCeSaSpGUtV1rJwYW4M
         iCdtOP4y22E0UdXnH8XURLO0WFC1WAn25RCJGPiWzKQygWM9anwNWgDJTPZvE1yWMQky
         frrg==
X-Gm-Message-State: AO0yUKVLjciKeS4qlKgH0mg2EeXdTSM7WDSTZrEHS7nG1p1tX9YUI21R
        ZmrzzEtjktybqmCP5q+EEEorYCHmksw5tF7dRIEELQ==
X-Google-Smtp-Source: AK7set8BLWiiUSmP1ZnKxPXJ1C4jOaYXgC8mhhJgjy8MjW3z0hLNlQVz0f5qVXMSJuwF1hP61XhwjGdZrkB7RksH74E=
X-Received: by 2002:ac2:5a19:0:b0:4d8:775b:a58f with SMTP id
 q25-20020ac25a19000000b004d8775ba58fmr1607468lfn.73.1675376827426; Thu, 02
 Feb 2023 14:27:07 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Feb 2023 14:27:06 -0800
MIME-Version: 1.0
In-Reply-To: <Y81G3X7TSNk57hqc@kroah.com>
References: <20230113204548.578798-1-swboyd@chromium.org> <Y81G3X7TSNk57hqc@kroah.com>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Thu, 2 Feb 2023 14:27:06 -0800
Message-ID: <CAE-0n52WYuDhozGijwJoMOL9PLRQshLCMAJsWvudz4KdS+jN=Q@mail.gmail.com>
Subject: Re: [PATCH 5.15.y v2 0/5] phy: qcom-qmp-combo: Backport some stable fixes
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2023-01-22 06:23:25)
> On Fri, Jan 13, 2023 at 12:45:43PM -0800, Stephen Boyd wrote:
> > After the qmp phy driver was split it looks like 5.15.y stable kernels
> > aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
> > broken power on") which is tagged for stable 5.10. Trogdor boards use
> > the qmp phy on 5.15.y kernels, so I backported the fixes I could find
> > that looked like we may possibly trip over at some point.
> >
> > USB and DP work on my Trogdor.Lazor board with this set.
> >
> > Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
> >  * New patch for memleak on probe deferal to avoid compat issues
> >  * Update "fix broken power on" patch for pcie/ufs phy
> >
> > Johan Hovold (5):
> >   phy: qcom-qmp-combo: disable runtime PM on unbind
> >   phy: qcom-qmp-combo: fix memleak on probe deferral
> >   phy: qcom-qmp-usb: fix memleak on probe deferral
> >   phy: qcom-qmp-combo: fix broken power on
> >   phy: qcom-qmp-combo: fix runtime suspend
> >
> >  drivers/phy/qualcomm/phy-qcom-qmp.c | 97 ++++++++++++++++++-----------
> >  1 file changed, 61 insertions(+), 36 deletions(-)
> >
> > Cc: Johan Hovold <johan+linaro@kernel.org>
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> >
> > base-commit: d57287729e229188e7d07ef0117fe927664e08cb
> > --
> > https://chromeos.dev
> >
>
> For obvious reasons, I can't take this series if newer kernel releases
> do not also contain all of these (no would you want me to.)
>
> So can you please also provide a backported series for 6.1.y so that
> these can be considered?

Sure. All of the patches have been applied to 6.1.y except for the last
one, which picks cleanly, c7b98de745cf ("phy: qcom-qmp-combo: fix
runtime suspend"). I can send that over.
