Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D534B7B52
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 00:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbiBOXqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 18:46:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbiBOXqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 18:46:35 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF323C
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 15:46:23 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id 24so382875ioe.7
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 15:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D1y9JY/TcIg793QohbrVLgdALG9bj0J1UUN+R+ZXyQ=;
        b=BOz+RWVBzt+//OXyKfTapB3uNHmGuMA1zjAC7Tb8wkL/9bCFb79wWGfCYyPhCB+ELd
         fuPAa5qV5KQWaKfTKAQl0ZRqb9B2ai8PkbnB0pjiKf4HArUsyeEMZGcEHWbaTQrmMajN
         VozDS2JfO/MkwzIZUMHByJIj65YP5IVXqNmMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D1y9JY/TcIg793QohbrVLgdALG9bj0J1UUN+R+ZXyQ=;
        b=khAcZoL50OklZRdx4MWP3TLrX0ne5u+mZhzzNeLFoO47dwSsaQCyeohKk6jX47ta62
         vALkehMzHP8geeCstUAVgDexSrCkGU5xumTwhlhfOKJiLYF8mcSg9SqdJXdG0tO3uMNv
         UaN19C7Aji/9M9+pfykVnwO/qD33TYKdVCaLhKxuYOoLOwG3TOreHgjGbphjshkY7Q5k
         yLJ0Z2ooNlLFBMsisLG7f1t3W5+WmOEhd+xbX8NgMEvKPEPpw3dyKbbZf3Rl+Dx5MQ8c
         TgGi/15X0743cNOSvUxB8vk0faqwZlE3sAI0nYbj5A8U3WUvuppvhWdWPQX2IKpjk9I6
         6BgQ==
X-Gm-Message-State: AOAM530BMUKDgZYsx+RcLe0Mh7kdN7zrZkyh3/RnHxftkzlCXjLoJWvj
        Ynf8hXTUqQAIj9JMYWBJVDErW/eaoh+m5Q==
X-Google-Smtp-Source: ABdhPJz91usDlOiwqdmM2n8X+VZzFsctFC/BZAi7v3N3mskyZpTY9tnz85q4P7HAcEtvNQ6pMGP4Tw==
X-Received: by 2002:a02:70c4:0:b0:314:1fd1:f143 with SMTP id f187-20020a0270c4000000b003141fd1f143mr63843jac.18.1644968783133;
        Tue, 15 Feb 2022 15:46:23 -0800 (PST)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com. [209.85.166.172])
        by smtp.gmail.com with ESMTPSA id f16sm3535052ioz.49.2022.02.15.15.46.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 15:46:22 -0800 (PST)
Received: by mail-il1-f172.google.com with SMTP id e11so243261ils.3
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 15:46:22 -0800 (PST)
X-Received: by 2002:a05:6e02:12ef:b0:2be:2c34:17b2 with SMTP id
 l15-20020a056e0212ef00b002be2c3417b2mr108639iln.120.1644968782044; Tue, 15
 Feb 2022 15:46:22 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <CAD=FV=XU0bYVZk+-jPWZVoODW79QXOJ=NQy+RH=fYyX+LCZb2Q@mail.gmail.com> <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com>
In-Reply-To: <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 15 Feb 2022 15:46:10 -0800
X-Gmail-Original-Message-ID: <CAD=FV=VYe1rLKANQ8eom7g8x1v6_s_OYnX819Ax4m7O3UwDHmg@mail.gmail.com>
Message-ID: <CAD=FV=VYe1rLKANQ8eom7g8x1v6_s_OYnX819Ax4m7O3UwDHmg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Brian Norris <briannorris@chromium.org>
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

Hi,

On Tue, Feb 15, 2022 at 2:52 PM Brian Norris <briannorris@chromium.org> wrote:
>
> On Tue, Feb 15, 2022 at 1:31 PM Doug Anderson <dianders@chromium.org> wrote:
> >
> > Hi,
>
> Hi!
>
> > On Fri, Oct 1, 2021 at 2:50 PM Brian Norris <briannorris@chromium.org> wrote:
> > >
> > > If the display is not enable()d, then we aren't holding a runtime PM
> > > reference here. Thus, it's easy to accidentally cause a hang, if user
> > > space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
> > >
> > > Let's get the panel and PM state right before trying to talk AUX.
>
> > > diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > > index b7d2e4449cfa..6fc46ac93ef8 100644
> > > --- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > > +++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
> > > @@ -1632,8 +1632,27 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
> ...
> > > +       pm_runtime_get_sync(dp->dev);
> > > +       ret = analogix_dp_transfer(dp, msg);
> > > +       pm_runtime_put(dp->dev);
> >
> > I've spent an unfortunate amount of time digging around the DP AUX bus
> > recently, so I can at least say that I have some experience and some
> > opinions here.
>
> Thanks! Experience is welcome, and opinions too sometimes ;)
>
> > IMO:
> >
> > 1. Don't power the panel on. If the panel isn't powered on then the DP
> > AUX transfer will timeout. Tough nuggies. Think of yourself more like
> > an i2c controller and of this as an i2c transfer implementation. The
> > i2c controller isn't in charge of powering up the i2c devices on the
> > bus. If userspace does an "i2c detect" on an i2c bus and some of the
> > devices aren't powered then they won't be found. If you try to
> > read/write from a powered off device that won't work either.
>
> I guess this, paired with the driver examples below (ti-sn65dsi86.c,
> especially, which specifically throws errors if the panel isn't on),
> makes some sense. It's approximately (but more verbosely) what Andrzej
> was recommending too, I guess. It still makes me wonder what the point
> of the /dev/drm_dp_aux<N> interface is though, because it seems like
> you're pretty much destined to not have reliable operation through
> that means.

I can't say I have tons of history for those files. I seem to recall
maybe someone using them to have userspace tweak the embedded
backlight on some external DP connected panels? I think we also might
use it in Chrome OS to update the firmware of panels (dunno if
internal or external) in some cases too? I suspect that it works OK
for certain situations but it's really not going to work in all
cases...


> Also note: I found that the AUX bus is really not working properly at
> all (even with this patch) in some cases due to self-refresh. Not only
> do we need the panel enabled, but we need to not be in self-refresh
> mode. Self-refresh is not currently exposed to user space, so user
> space has no way of knowing the panel is currently active, aside from
> racily inducing artificial display activity.

I suppose this just further proves the point that this is really not a
great interface to rely on. It's fine for debugging during hardware
bringup and I guess in limited situations it might be OK, but it's
really not something we want userspace tweaking with anyway, right? In
general I expect it's up to the kernel to be controlling peripherals
on the DP AUX bus. The kernel should have a backlight driver and
should do the AUX transfers needed. Having userspace in there mucking
with things is just a bad idea. I mean, userspace also doesn't know
when a panel has been power cycled and potentially lost any changes
that they might have written, right?

I sorta suspect that most of the uses of these files are there because
there wasn't a kernel driver and someone thought that doing it in
userspace was the way to go?


> But if we're OK with "just throw errors" or "just let stuff time out",
> then I guess that's not a big deal. My purpose is to avoid hanging the
> system, not to make /dev/drm_dp_aux<N> useful.
>
> > 2. In theory if the DP driver can read HPD (I haven't looked through
> > the analogix code to see how it handles it) then you can fail an AUX
> > transfer right away if HPD isn't asserted instead of timing out. If
> > this is hard, it's probably fine to just time out though.
>
> This driver does handle HPD, but it also has overrides because
> apparently it doesn't work on some systems. I might see if we can
> leverage it, or I might just follow the bridge-enabled state (similar
> to ti-sn65dsi86.c's 'comms_enabled').

The "comms_enabled" is a bit ugly and is mostly there because we
couldn't enable the bridge chip at the right time for some (probably
unused) configuration, so I wouldn't necessarily say that it's the
best model to follow. That being said, happy to review something if
this model looks like the best way to go.


> > 3. Do the "pm_runtime" calls, but enable "autosuspend" with something
> > ~1 second autosuspend delay. When using the AUX bus to read an EDID
> > the underlying code will call your function 16 times in quick
> > succession. If you're powering up and down constantly that'll be a bit
> > of a waste.
>
> Does this part really matter? For properly active cases, the bridge
> remains enabled, and it holds a runtime PM reference. For "maybe
> active" (your "tough nuggies" situation above), you're probably right
> that it's inefficient, but does it matter, when it's going to be a
> slow timed-out operation anyway? The AUX failure will be much slower
> than the PM transition.
>
> I guess I can do this anyway, but frankly, I'll just be copy/pasting
> stuff from other drivers, because the runtime PM documentation still
> confuses me, and moreso once you involve autosuspend.

For the ti-sn65dsi86 it could take a few ms to power it up and down
each time and it seemed wasteful to do this over and over again.
Agreed that pm_runtime can easily get confusing.

-Doug
