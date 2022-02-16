Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436804B8FE6
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiBPSKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 13:10:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiBPSKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 13:10:44 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EC92A4A36
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 10:10:32 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e11so418091ils.3
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 10:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhg8ObNqJqU9MXgC8htbZHEYozTLZfTKNUE4M3ppPEQ=;
        b=X3YBCQPLYrjbSwdYieYTzfp5aHHmxsfeg3RTf4qZg0wFQ6+c9DxcKdaAJmOlc37Dsv
         CTdEpl0BzCTg87o7PF2lX4vr7saXRgNN4zH/iPLgcyLTPMZGhRdeuiUlyPMWzB1yffkQ
         L1SizYyjHV+Gfh5MA9OSmEyn4e1glalJ49FS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhg8ObNqJqU9MXgC8htbZHEYozTLZfTKNUE4M3ppPEQ=;
        b=OK1ol5Mm3ulh0wfdYt/S/INvmWSIrGrmFNhWT1qANIoXouxhdp4hmpl6gRhZwmMSFS
         mFujkRm0zxiROjybvG+pMzdoj/r0oJ8hfk2Q8OSw7QOzCLU1idn8jisI3ss7wieaYXWG
         Ob9T6cliF3GbEaH8fBFq+HSkoDs9GMdN+D/YGm8PeLL5fkw4Wla/ixriFyp16eZfS4Om
         tJzMWhi1NPKXamAs9JcIydoguAWbumUJybrL9CgmTjxGIbFpTNqVv9PTnAzwRjBiA0vG
         06LzRUnjJqq1NlYXzivpqUw0XXl5a3EQQkKX3SLTMxzuKYyBoY2cuqmgrAN3dRiu6xyX
         dgng==
X-Gm-Message-State: AOAM533qwY/WTeCp5h0yHiaoDLF2F40N+qynqAHhFVG7n2PHotTBF/WG
        ugwkTAenMMJAUAYdKv9xkFrNMFV0wcMipQ==
X-Google-Smtp-Source: ABdhPJwszLSJ3Q6Ocp1kVj6nBK8wbZnqYgsOv33VOybmUot9ETj+9SmLkR20TsUcSz7Uai8Da+vZgQ==
X-Received: by 2002:a92:cdaf:0:b0:2ba:671e:123c with SMTP id g15-20020a92cdaf000000b002ba671e123cmr2552378ild.242.1645035031539;
        Wed, 16 Feb 2022 10:10:31 -0800 (PST)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com. [209.85.166.171])
        by smtp.gmail.com with ESMTPSA id u26sm244106ior.52.2022.02.16.10.10.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 10:10:29 -0800 (PST)
Received: by mail-il1-f171.google.com with SMTP id k18so391913ils.11
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 10:10:28 -0800 (PST)
X-Received: by 2002:a05:6e02:144f:b0:2bd:da3d:f50b with SMTP id
 p15-20020a056e02144f00b002bdda3df50bmr2425111ilo.165.1645035028535; Wed, 16
 Feb 2022 10:10:28 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
 <CAD=FV=XU0bYVZk+-jPWZVoODW79QXOJ=NQy+RH=fYyX+LCZb2Q@mail.gmail.com>
 <CA+ASDXPXKVwcZGYoagJYPm4E7DzaJmEVEv2FANhLH-juJw+r+Q@mail.gmail.com>
 <CAD=FV=VYe1rLKANQ8eom7g8x1v6_s_OYnX819Ax4m7O3UwDHmg@mail.gmail.com> <CA+ASDXO8c4dK31p=kvBABJQsDUs20qVHM6NxYf1JQDCr2oswAw@mail.gmail.com>
In-Reply-To: <CA+ASDXO8c4dK31p=kvBABJQsDUs20qVHM6NxYf1JQDCr2oswAw@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 16 Feb 2022 10:10:16 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XivCxy-7Wszv9pnHELi=gRCMeVasEweza17XTtEoiT4A@mail.gmail.com>
Message-ID: <CAD=FV=XivCxy-7Wszv9pnHELi=gRCMeVasEweza17XTtEoiT4A@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Feb 15, 2022 at 4:41 PM Brian Norris <briannorris@chromium.org> wrote:
>
> On Tue, Feb 15, 2022 at 3:46 PM Doug Anderson <dianders@chromium.org> wrote:
> > On Tue, Feb 15, 2022 at 2:52 PM Brian Norris <briannorris@chromium.org> wrote:
> > > It still makes me wonder what the point
> > > of the /dev/drm_dp_aux<N> interface is though, because it seems like
> > > you're pretty much destined to not have reliable operation through
> > > that means.
> >
> > I can't say I have tons of history for those files. I seem to recall
> > maybe someone using them to have userspace tweak the embedded
> > backlight on some external DP connected panels? I think we also might
> > use it in Chrome OS to update the firmware of panels (dunno if
> > internal or external) in some cases too? I suspect that it works OK
> > for certain situations but it's really not going to work in all
> > cases...
>
> Yes, I believe I'm only submitting patches like this because fwupd
> apparently likes to indiscriminately whack at dpaux devices:
> https://github.com/fwupd/fwupd/tree/main/plugins/synaptics-mst#kernel-dp-aux-interface
>
> That seems like a bad idea.
>
> (We've already disabled that plugin on these systems, but it seems
> wise not to leave the stumbling block here for the next time.)

Yeah, it doesn't seem great. I guess it's _slightly_ less bad since
it's for an external device. As I understand it, they never really
turn off in the same way. It still feels like letting userspace
indiscriminately whack at DP AUX registers isn't a great idea, though.
