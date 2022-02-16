Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0856E4B8BA0
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 15:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiBPOk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 09:40:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbiBPOk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 09:40:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D1B2A64EA
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 06:40:44 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i11so2635048eda.9
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 06:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwCOPh0vRYc0rMMINwUc1NnDsZj7q4kEpI6uYr3S44w=;
        b=ZxEdZA1qN1/D+uanHD1nOwRY1fjdnFNilLiq3Az4CxUoOImnImATPgyQJK5MLdNwVu
         T820pMXYvYBR4unh3scc2DzLbJCnWi+Klwa8nKTsuFgobjtOuH1RmMyZ54oVKR0tWg37
         3E1H6tNypf4SCf5jMu0PWDitey3D1xJovQWBgIstmxvEbtO2WmtXBvx/jYDLrruvHFXN
         XRfDM1/Zs0x/fJzrkmuNYHaOTYq3AqBYFhiUNw1UIo0p5Ua6Nz0L0WY8yXRjSfp/vS/t
         fwrCsP3HpVZKqdp7BDlP7A/Funrb4gdyMGEQlv9eJyezwn29MKErNtlNNnmbkQMARhQl
         LNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwCOPh0vRYc0rMMINwUc1NnDsZj7q4kEpI6uYr3S44w=;
        b=VS1sap5j/MyokNZGlehINoGRgksuw90u4lIF2aJyg0LdivL2aUs4eUaa64HWMo9+yr
         7lFakm9D+6VnJU6/jtGIAkQ2Pj8lKA5tqnEXp73jDl4Dpb0+NphXVxWgBYjxppxDNia4
         OiK30KbmL2ZeNrE5S+1GZ+cs8XVv8TjD847zT9aOrpt7ZUp0axs6/7mCh8hFrUSBKqAl
         7WJjNUS7hAY0YfTuJZ7QjQPfkt0dbrKUMi6JsHVIqtGV4SGSqKMtjlnB4MJLl32Qz/c+
         e56yYpx154XfaQcUWfs8EN7oViw5TLVJO8/pbKup9ISfb6DzJG8MoxQIojzTGouDRgOx
         t06A==
X-Gm-Message-State: AOAM531hAWdmEh6cdEhUN+6U07kpk1OWIqlNZIdUyzNQFSiwjmXaIBgY
        yMy5VFq3X1UjNjje0keGRXHc8AXClwSkyBqFvTiLA2FIwxw=
X-Google-Smtp-Source: ABdhPJxkkCo2WKdfCWHk8mNzhrjwtKZpMi6oKRXESBDBJAJ5jIQfE8MBX1Wwhu/L4VqMuHCiMjQdEOrhBapf0MBbar0=
X-Received: by 2002:a50:fc81:0:b0:408:4c2d:bf69 with SMTP id
 f1-20020a50fc81000000b004084c2dbf69mr3321789edq.229.1645022442889; Wed, 16
 Feb 2022 06:40:42 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
 <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
 <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
 <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com> <CACRpkdZGVq19GZuOP1BwLB2-qxj1_=O9tHMVRvphvy3m6KbNig@mail.gmail.com>
In-Reply-To: <CACRpkdZGVq19GZuOP1BwLB2-qxj1_=O9tHMVRvphvy3m6KbNig@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 16 Feb 2022 15:40:32 +0100
Message-ID: <CAMRc=McPSFQFPP1nSTXj3snKWqQyzNgz0j_J5ooyUrhRFRMqJQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 10:56 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Mon, Feb 14, 2022 at 12:24 AM Marcelo Roberto Jimenez
> <marcelo.jimenez@gmail.com> wrote:
> > On Sat, Feb 12, 2022 at 1:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> > > I am curious about the usecases and how deeply you have built
> > > yourselves into this.
> >
> > I don't know if I understand what you mean, sorry.
>
> Why does the user need the sysfs ABI? What is it used for?
>
> I.e what is the actual use case?
>
> > > > In any case, the upstream file should be enough to test the issue reported here.
> > >
> > > The thing is that upstream isn't super happy that you have been
> > > making yourselves dependent on features that we are actively
> > > discouraging and then demanding that we support these features.
> >
> > Hum, demanding seems to be a strong word for what I am doing here.
> >
> > Deprecated should not mean broken. My point is: the API seems to be
> > currently broken. User space apps got broken, that's a fact. I even
> > took the time to bisect the kernel and show you which commit broke it.
> > So, no, I am not demanding. More like reporting and providing a
> > temporary solution to those with a similar problem.
> >
> > Maybe it is time to remove the API, but this is up to "upstream".
> > Leaving the API broken seems pointless and unproductive.
> >
> > Sorry for the "not super happiness of upstream", but maybe upstream
> > got me wrong.
> >
> > We are not "making ourselves dependent on features ...". The API was
> > there. We used it. Now it is deprecated, ok, we should move on. I got
> > the message.
>
> Ouch I deserved some slamming for this.
>
> I'm sorry if I came across as harsh :(
>
> I just don't know how to properly push for this.
>
> I have even pushed the option of the deprecated sysfs ABI
> behind the CONFIG_EXPERT option, which should mean that
> the kernel config has been made by someone who has checked
> the option "yes I am an expert I know what I am doing"
> yet failed to observe that this ABI is obsoleted since 5 years
> and hence failed to be an expert.
>
> Of course the ABI (not API really) needs to be fixed if we can find the
> problem. It's frustrating that fixing it seems to fix broken other
> features which are not deprecated, hence the annoyance on my
> part.
>

I'm afraid we'll earn ourselves a good old LinusRant if we keep
pushing the character device as a solution to the problem here.
Marcelo is right after all: he used an existing user interface, the
interface broke, it must be fixed.

I would prefer to find a solution that fixes Marcelo's issue while
keeping the offending patches in tree but it seems like the issue is
more complicated and will require some rework of the sysfs interface.

In which case unless there are objections I lean towards reverting the
relevant commits.

Bart

> > And I will also tell the dev team that they must use the GPIO char dev
> > and libgpiod from now on and must port everything to it. And we will
> > likely have another group of people who are not super happy, but
> > that's life... :)
>
> I'm happy to hear this!
>
> Yours,
> Linus Walleij
