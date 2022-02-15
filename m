Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927274B7A0F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiBOV40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 16:56:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiBOV4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 16:56:25 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2B0B7C6A
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:56:14 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id l125so270800ybl.4
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 13:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZ5q++YgykAGpmunP4misegIALHkWjqPtYqC2VXU0d0=;
        b=EJtxPtg7dBta1ocWaVmXeFyVO/Fb3XKx+YPBWIpfdoG8+4qvhGacxIFYFnoRVa9ihX
         48TG7nxBsmcmuQE75OzQjZInI0jpBDR78nEmbdu6u/Sxj4qmDpL9hbigkZrjgCCHEo2t
         Dw6pFYQn/jWQu3DqqkFE8L9+/5vJQmAmY/K4SJZE0CbMp1xHthRZ8srcDLxnBELwWvYp
         6HzczCqa3wRWxfxW/dMldH4MBzMGWaW23FWBO/HqUCJO2HFh1KMEG3sJ/iuSdjc5FScg
         zL7Yd65Rj13CIDMQ0F/CESvlPi5/+XFBpvq3HV1ZBAHmiS5bnFTzUKu+Wu+a7HY1TzgA
         PrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZ5q++YgykAGpmunP4misegIALHkWjqPtYqC2VXU0d0=;
        b=EdMX9hPpY7Sb/r5N7YmaWp/ZQ5mwgjRUtD+cTOGzfV9bm9vwmD0Y32aTl6vp1MOIK/
         R7Bu76oSFVRHoQkU0po3ufy8mMgcAUq/dICqoYzHUj9MnjStxr6rlwKo3gZn0d23I06i
         ekZPnxWvWz+rnT/vFYnlofbJF/GbUL1zQC/Q4fNDvfbM9s/Y5HFv1DT57BN0FmLUiHSa
         6zuKcYy3K2Zo36U/8ZJMEf+a9jXVuMcAivSLRGEulfRDgGycHd7o43xeknQ0e793psZG
         ZkAjF/O3LUWXeD4Db6kPQbnReBZj8d7isOZh6+CVhsLAi5e0c5xU5lqXr6sjmRI42KCX
         la4Q==
X-Gm-Message-State: AOAM532sNpLOEUCmzRSTXbsQ0M4lIeLeG1BBrdUc//0NI/QBCmZtc8Oy
        /nWx7Rvkm9kC5hSz4xIAtSMlukA9BCpTp3fs3XsyfQ==
X-Google-Smtp-Source: ABdhPJzG0B+DhMonvyx1eAizm9Pr/8IzyJW1KRh1R1rK2yw6uE2Ix/pSISU0TKx7BOD9f6MfvQqvqmB2Bqzfyfuor6U=
X-Received: by 2002:a5b:f4b:: with SMTP id y11mr866089ybr.634.1644962173974;
 Tue, 15 Feb 2022 13:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
 <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
 <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com> <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com>
In-Reply-To: <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 15 Feb 2022 22:56:01 +0100
Message-ID: <CACRpkdZGVq19GZuOP1BwLB2-qxj1_=O9tHMVRvphvy3m6KbNig@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Cc:     stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Bartosz Golaszewski <brgl@bgdev.pl>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 12:24 AM Marcelo Roberto Jimenez
<marcelo.jimenez@gmail.com> wrote:
> On Sat, Feb 12, 2022 at 1:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> > I am curious about the usecases and how deeply you have built
> > yourselves into this.
>
> I don't know if I understand what you mean, sorry.

Why does the user need the sysfs ABI? What is it used for?

I.e what is the actual use case?

> > > In any case, the upstream file should be enough to test the issue reported here.
> >
> > The thing is that upstream isn't super happy that you have been
> > making yourselves dependent on features that we are actively
> > discouraging and then demanding that we support these features.
>
> Hum, demanding seems to be a strong word for what I am doing here.
>
> Deprecated should not mean broken. My point is: the API seems to be
> currently broken. User space apps got broken, that's a fact. I even
> took the time to bisect the kernel and show you which commit broke it.
> So, no, I am not demanding. More like reporting and providing a
> temporary solution to those with a similar problem.
>
> Maybe it is time to remove the API, but this is up to "upstream".
> Leaving the API broken seems pointless and unproductive.
>
> Sorry for the "not super happiness of upstream", but maybe upstream
> got me wrong.
>
> We are not "making ourselves dependent on features ...". The API was
> there. We used it. Now it is deprecated, ok, we should move on. I got
> the message.

Ouch I deserved some slamming for this.

I'm sorry if I came across as harsh :(

I just don't know how to properly push for this.

I have even pushed the option of the deprecated sysfs ABI
behind the CONFIG_EXPERT option, which should mean that
the kernel config has been made by someone who has checked
the option "yes I am an expert I know what I am doing"
yet failed to observe that this ABI is obsoleted since 5 years
and hence failed to be an expert.

Of course the ABI (not API really) needs to be fixed if we can find the
problem. It's frustrating that fixing it seems to fix broken other
features which are not deprecated, hence the annoyance on my
part.

> And I will also tell the dev team that they must use the GPIO char dev
> and libgpiod from now on and must port everything to it. And we will
> likely have another group of people who are not super happy, but
> that's life... :)

I'm happy to hear this!

Yours,
Linus Walleij
