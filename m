Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078264B7AB8
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244267AbiBOWwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 17:52:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbiBOWwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 17:52:11 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED648302F
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 14:52:00 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id q8so620438oiw.7
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1FB9vEgE7XNXDYnECZNocmKPYP8d5C7TWz0lgDEn7xk=;
        b=fjG712BlrOTYrfwnSRNCBRY8yRQW9o6qR1hiZlZWQq91Sm5fVmIhzlRa+s7C/PBz2T
         eJ4cgsB9JemF8urXL4CrzCBOFzhtwz5N7W5Kotgar0OKQBgyUhdOiRujxY9FKvRk0roG
         NZoBf1wVhyOnoD6NCrsjPrRQ5hEQ7qliayxC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1FB9vEgE7XNXDYnECZNocmKPYP8d5C7TWz0lgDEn7xk=;
        b=4fia3iwsTDrLYuD1nJEmuOFG80AtIY39LohQv9Obc/pUIPVbfllMOU8PeUgW7m7X9j
         WspHvCQAg83EW2nYkGZ3x808lYhT/BPrkNgsKTuc4Q3BgGmAA41dRDEJtkGfX9KNbAYu
         4+gesnzXsmLgdtQgW6AL9dtu/4AaLokV8wzVSHqyRMjr0OgwhbyCeEmX799AYxIh6LwI
         ZIN3Kx/PynTw8+j/zv6i3mhtLki7ZI1robSfVGHIBze9ftpe266jVueRgbxYFs04Gu+L
         SoLQuczcVvEBJxKrZGVUPV6nLUGCVWm0ODyqkKXJuIKYoSA9mob7GhOMDtBA5TNRqqy+
         Z23w==
X-Gm-Message-State: AOAM533emRs+j+FDxTrhG1Mqhkoj+6+wThRWuyvVk5cCGltMu+pu28VF
        W/xs4kst155P5f05Iuzgdza2FMfwU+MY2Q==
X-Google-Smtp-Source: ABdhPJy11L5+OoPfVPaunc0VS4aKkOlHSsVVpCA97n4bPUspq68WRbjqbuuQcmG/VMxA/GYihrVwhQ==
X-Received: by 2002:aca:f00b:0:b0:2d4:1749:40fe with SMTP id o11-20020acaf00b000000b002d4174940femr56964oih.166.1644965519534;
        Tue, 15 Feb 2022 14:51:59 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id k19sm14154217oot.41.2022.02.15.14.51.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 14:51:58 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id l7-20020a9d6a87000000b005aceba2aea1so317685otq.4
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 14:51:58 -0800 (PST)
X-Received: by 2002:a9d:755a:: with SMTP id b26mr513845otl.230.1644965517513;
 Tue, 15 Feb 2022 14:51:57 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <CAD=FV=XU0bYVZk+-jPWZVoODW79QXOJ=NQy+RH=fYyX+LCZb2Q@mail.gmail.com>
In-Reply-To: <CAD=FV=XU0bYVZk+-jPWZVoODW79QXOJ=NQy+RH=fYyX+LCZb2Q@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 15 Feb 2022 14:51:46 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com>
Message-ID: <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Doug Anderson <dianders@chromium.org>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        LKML <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 1:31 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,

Hi!

> On Fri, Oct 1, 2021 at 2:50 PM Brian Norris <briannorris@chromium.org> wrote:
> >
> > If the display is not enable()d, then we aren't holding a runtime PM
> > reference here. Thus, it's easy to accidentally cause a hang, if user
> > space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
> >
> > Let's get the panel and PM state right before trying to talk AUX.

> > diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > index b7d2e4449cfa..6fc46ac93ef8 100644
> > --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > @@ -1632,8 +1632,27 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
...
> > +       pm_runtime_get_sync(dp->dev);
> > +       ret = analogix_dp_transfer(dp, msg);
> > +       pm_runtime_put(dp->dev);
>
> I've spent an unfortunate amount of time digging around the DP AUX bus
> recently, so I can at least say that I have some experience and some
> opinions here.

Thanks! Experience is welcome, and opinions too sometimes ;)

> IMO:
>
> 1. Don't power the panel on. If the panel isn't powered on then the DP
> AUX transfer will timeout. Tough nuggies. Think of yourself more like
> an i2c controller and of this as an i2c transfer implementation. The
> i2c controller isn't in charge of powering up the i2c devices on the
> bus. If userspace does an "i2c detect" on an i2c bus and some of the
> devices aren't powered then they won't be found. If you try to
> read/write from a powered off device that won't work either.

I guess this, paired with the driver examples below (ti-sn65dsi86.c,
especially, which specifically throws errors if the panel isn't on),
makes some sense. It's approximately (but more verbosely) what Andrzej
was recommending too, I guess. It still makes me wonder what the point
of the /dev/drm_dp_aux<N> interface is though, because it seems like
you're pretty much destined to not have reliable operation through
that means.

Also note: I found that the AUX bus is really not working properly at
all (even with this patch) in some cases due to self-refresh. Not only
do we need the panel enabled, but we need to not be in self-refresh
mode. Self-refresh is not currently exposed to user space, so user
space has no way of knowing the panel is currently active, aside from
racily inducing artificial display activity.

But if we're OK with "just throw errors" or "just let stuff time out",
then I guess that's not a big deal. My purpose is to avoid hanging the
system, not to make /dev/drm_dp_aux<N> useful.

> 2. In theory if the DP driver can read HPD (I haven't looked through
> the analogix code to see how it handles it) then you can fail an AUX
> transfer right away if HPD isn't asserted instead of timing out. If
> this is hard, it's probably fine to just time out though.

This driver does handle HPD, but it also has overrides because
apparently it doesn't work on some systems. I might see if we can
leverage it, or I might just follow the bridge-enabled state (similar
to ti-sn65dsi86.c's 'comms_enabled').

> 3. Do the "pm_runtime" calls, but enable "autosuspend" with something
> ~1 second autosuspend delay. When using the AUX bus to read an EDID
> the underlying code will call your function 16 times in quick
> succession. If you're powering up and down constantly that'll be a bit
> of a waste.

Does this part really matter? For properly active cases, the bridge
remains enabled, and it holds a runtime PM reference. For "maybe
active" (your "tough nuggies" situation above), you're probably right
that it's inefficient, but does it matter, when it's going to be a
slow timed-out operation anyway? The AUX failure will be much slower
than the PM transition.

I guess I can do this anyway, but frankly, I'll just be copy/pasting
stuff from other drivers, because the runtime PM documentation still
confuses me, and moreso once you involve autosuspend.

> For a reference, you could look at
> `drivers/gpu/drm/bridge/ti-sn65dsi86.c`. Also
> `drivers/gpu/drm/bridge/parade-ps8640.c`

Thanks for these. They look like reasonable patterns to follow.


Brian
