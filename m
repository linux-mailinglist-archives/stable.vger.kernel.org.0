Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E9B48B734
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350815AbiAKTSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350936AbiAKTSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:18:00 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA59C028BB5
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:17:19 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s9so383561oib.11
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XXfEP3eDjuVf2I0hzndCbBZCmDbt3TXTw7VkqrBBp6g=;
        b=GqsQHSUI/DSQ5OHrZM4cAIUTNhygx8SMT8UZeIjwtBBPg0C1RHAiQTcr+e9hK8YBlu
         l8uN7LR5JJfZ1yuZ2HAK/ZI1cEra7YuXTRaICw2tpHE2SpAPNvHUYAQWqMGqoRK2xquF
         NunrkGKuyj1aPAhJandfNKcNq/xbyYZ/ka9wk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XXfEP3eDjuVf2I0hzndCbBZCmDbt3TXTw7VkqrBBp6g=;
        b=lTqgXg0Frl3WYB5k4/kYKux3S41yGme/cpBaia+yEEhwvT7RZWet3r5tfdTUrX7Lp5
         beevRGvonDRnjBWCFwR3Ow0rHc8S65kkB6OIIRYkD48BBXheVsq2p73j7xe6dhZj7uqc
         Apmo9krRf0NBSDuuPDA2IvJ+5OCyvBmHEVXYmitqEWdjKWsIVN4Xf289haWTl0uOK3hd
         MMa8IBU2r4cVKRODkA34g6yOLGvmjET31t+ePhiaxF5h/ZYZysaA/x+0I1cGT2N4HpXj
         6WEpVBMIHFqsqAx1wmnAnQz0PnupbS5BQghklliPNJdPjy8c8dyuAslpfNPmkGYdTwRl
         Ngfw==
X-Gm-Message-State: AOAM532sVOvmc/nZskIVBPWLoEDcGCfc7zTdXZmWYmHxAdfuKyGdZIGp
        JaSoz38DMdcuT6l+7qLuE02sz99XNzbToA==
X-Google-Smtp-Source: ABdhPJzQOkTQynPPUVR+wcPqva2gwOQesqd6CZd+0h9BANwYpFXT/jFZWHFahJATQi7wss0jUjqXfQ==
X-Received: by 2002:a54:400a:: with SMTP id x10mr2924143oie.151.1641928637162;
        Tue, 11 Jan 2022 11:17:17 -0800 (PST)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id e16sm2102751ook.38.2022.01.11.11.17.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 11:17:15 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso19674216otf.12
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:17:15 -0800 (PST)
X-Received: by 2002:a9d:5908:: with SMTP id t8mr2359606oth.186.1641928634923;
 Tue, 11 Jan 2022 11:17:14 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <cd453cd2-e23f-84b9-e7d3-667df2397c45@intel.com>
In-Reply-To: <cd453cd2-e23f-84b9-e7d3-667df2397c45@intel.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 11 Jan 2022 11:17:04 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPu5=kv1KoJ-189uHXGua-vhYJzJ4pNujmVxJf_dWE=Sg@mail.gmail.com>
Message-ID: <CA+ASDXPu5=kv1KoJ-189uHXGua-vhYJzJ4pNujmVxJf_dWE=Sg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Lyude Paul <lyude@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrzej,

On Tue, Jan 11, 2022 at 5:26 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
> I am not DP specialist so CC-ed people working with DP

Thanks for the review regardless! I'll also not claim to be a DP
specialist -- although I've had to learn my fair share to debug a good
handful of issues on an SoC using this driver.

> On 01.10.2021 23:42, Brian Norris wrote:
> > If the display is not enable()d, then we aren't holding a runtime PM
> > reference here. Thus, it's easy to accidentally cause a hang, if user
> > space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
> >
> > Let's get the panel and PM state right before trying to talk AUX.
> >
> > Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
> > Cc: <stable@vger.kernel.org>
> > Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>
>
> Few questions/issues here:
>
> 1. If it is just to avoid accidental 'hangs' it would be better to just
> check if the panel is working before transfer, if not, return error
> code. If there is better reason for this pm dance, please provide it  in
> description.

I'm not that familiar with DP-AUX, but I believe it can potentially
provide a variety of useful information (e.g., EDID?) to users without
the display and primary video link being active. So it doesn't sound
like a good idea to me to purposely leave this interface uninitialized
(and emitting errors) even when the user is asking for communication
(via /dev/drm_dp_aux<N>). Do you want me to document what
/dev/drm_dp_aux<N> does, and why someone would use it, in the commit
message?

> 2. Again I see an assumption that panel-prepare enables power for
> something different than video transmission, accidentally it is true for
> most devices, but devices having more fine grained power management will
> break, or at least will be used inefficiently - but maybe in case of dp
> it is OK ???

For this part, I'm less sure -- I wasn't sure what the general needs
are for AUX communication, and whether we need the panel enabled or
not. It seems logical that we need something powered, and I don't know
of anything besides "prepare()" that ensures that for DP panels.

(NB: the key to _my_ problem is the PM runtime reference. It's
absolutely essential that we don't try to utilize the DP hardware
without powering it up. The panel power state is less critical.)

> 3. More general issue - I am not sure if this should not be handled
> uniformly for all drm_dp devices.

I'm not sure what precisely you mean by #3. But FWIW, this is at least
partially documented ("make sure it's been properly enabled"):

        /**
         * @transfer: transfers a message representing a single AUX
         * transaction.
         *
         * This is a hardware-specific implementation of how
         * transactions are executed that the drivers must provide.
...
         * Also note that this callback can be called no matter the
         * state @dev is in. Drivers that need that device to be powered
         * to perform this operation will first need to make sure it's
         * been properly enabled.
         */
        ssize_t (*transfer)(struct drm_dp_aux *aux,
                            struct drm_dp_aux_msg *msg);

But maybe the definition of "properly enabled" is what you're unsure
about? (I'm also a little unsure.)

Regards,
Brian
