Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC947B47E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhLTUmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLTUmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:42:01 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272ACC061574;
        Mon, 20 Dec 2021 12:42:01 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id g11-20020a4a754b000000b002c679a02b18so3427437oof.3;
        Mon, 20 Dec 2021 12:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gRvhlXLq7L2YbTCbc1T1kLAsYxro2S3SeoZnogVM8pY=;
        b=ZvD1Th8rpbQRSrioTCscGQZd7Z2rdh/FlGxKSl8P5IBz/+JlSMyMV86iRVOlEP5Gaj
         WKWq1WVjhYCAZToQLKIsWSgUcFj0Tb4aijNJ2lClVU6RNeaQjcZgDhn/jZsUalgBZoh5
         WkVYMFUFkrRgbP+lkn//4bL4NK+yH1UuRieGk+o2do/xdf5ppW/WAwYUfS1jp0L5A60c
         jSngayaVl4dBuaJZDq56gbUSpmCMKWrNQHut7LV+0KQcT14/twBxY8CYBxGgXQGFL4Fo
         o5rlqr6Mt3cHqyKtDWbtzmklk6OG4R6i+cf/P9Zx6i2P9TDxzgoq0aXcxU3z1xkUg2pT
         NYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gRvhlXLq7L2YbTCbc1T1kLAsYxro2S3SeoZnogVM8pY=;
        b=HM5/F7gfOEIWYNgPjEWXvy6oXx1a3HPFAooQaDand5PMvggQSTpL6j7XTE3e1jO8R4
         lLpZM0Z4vFsi9YmliFQDULcoUf+xOhl9I+TqFsDmNcmC/tfDfO4X+J/j/Szojzbnn89L
         u8RdBuklgJT9/hvpwWLrpw0rkfoS9fryvfGhGT1IuCOeEZ1dlHcB7+e28Fpfi4MZrO7V
         xprUCHedY6QzuKso8zRaz8X/vNUvUtZk5dQmUfYDzk5T+0/Fi9Bvzx2TwhtSWUPPyCPO
         LZN9dDeMP0VKTDseZcf6KsU0mMSeSKirF2FyPLv5yMZLf+7r3oSKZakaSOlgDd++8N31
         nTpw==
X-Gm-Message-State: AOAM530JlnfQArisx7DoOE3Zo2xgbZQspkZH0FE0XbIUepslB0IT0bd1
        2YbLnoZg68Uj0LN7x2hgM1DAnNk0upkwRMkWxpo=
X-Google-Smtp-Source: ABdhPJy1MZs4O+yyJBNYKMLmmBoVIsXRs8uqhfPBXDSfWex6X7qLQ7uu2VtlPx2eCyvlficUTrBR3AAGoUG9iNqDV8M=
X-Received: by 2002:a4a:3511:: with SMTP id l17mr11541366ooa.74.1640032920411;
 Mon, 20 Dec 2021 12:42:00 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info> <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CAMuHMdVp621B0DywkW6sx6wNcPFez9=3-=cfSo7UoRttJ6QXCg@mail.gmail.com>
In-Reply-To: <CAMuHMdVp621B0DywkW6sx6wNcPFez9=3-=cfSo7UoRttJ6QXCg@mail.gmail.com>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Mon, 20 Dec 2021 17:41:34 -0300
Message-ID: <CACjc_5qaGFiuTyEHt5sy_EkCBd6bGgQp-T19GyATQw=jeoLGpg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert,

On Mon, Dec 20, 2021 at 12:14 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> On Mon, Dec 20, 2021 at 3:57 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> > <regressions@leemhuis.info> wrote:
> > > [TLDR: I'm adding this regression to regzbot, the Linux kernel
> > > regression tracking bot; most text you find below is compiled from a few
> > > templates paragraphs some of you might have seen already.]
> > >
> > > On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > > > Some GPIO lines have stopped working after the patch
> > > > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> > > >
> > > > And this has supposedly been fixed in the following patches
> > > > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > > > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> > >
> > > There seems to be a backstory here. Are there any entries and bug
> > > trackers or earlier discussions everyone that looks into this should be
> > > aware of?
> > >
> >
> > Agreed with Thorsten. I'd like to first try to determine what's wrong
> > before reverting those, as they are correct in theory but maybe the
> > implementation missed something.
> >
> > Have you tried tracing the execution on your platform in order to see
> > what the driver is doing?
>
> Looking at commits that have related Fixes tags:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bf781869e5cf3e4ec1a47dad69b6f0df97629cbd
> https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git/commit/?id=e8f24c58d1b69ecf410a673c22f546dc732bb879
>

Interesting. These seem to imply that gpiolib-sysfs.c should be
allocating a pinctrl list. That seems very easy to do in the DTD,
although I don't really know if that is the right thing to do. Doing
it in the code seems more appropriate, what do you think?

> Gr{oetje,eeting}s,
>
>                         Geert

Regards,
Marcelo.
