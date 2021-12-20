Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BB047B47B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhLTUly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhLTUlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:41:53 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3418C061574;
        Mon, 20 Dec 2021 12:41:53 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso14037250otr.2;
        Mon, 20 Dec 2021 12:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1bAoxn3SWu3BR7U54EL+ODdosFSa9pvjsulKehydkZU=;
        b=AwObBPlb4sHQUAx/63u36oQ+nzUt1Z9G1cx2CpjKAJg49K71g2/JpuZ90aXAVjZwyG
         Zmwz1e7qTlsqdtAWOoiRj6dPjtnRrQa6p4moM5JL281oAFKwgBtC6tAHZXwgYzymPrMO
         Aal2NcgT61+6uBsT0AmwpA7nu190F0blunGOZUzorBR52aMqZFMAjS/2bhQ9z8P5BpjZ
         hh+NPc5V2M8/ca+x/BH/w+qFekM6dOEk1F3gIjRn7xvYYY4Z5Flq2tEnVI20rPfAzD8p
         GOJ8Oln0fN65FNpvdVQ3SEWcWT4J0agXEJHFE8xapYUoj47EimehrV2md5HrVNOH1O0T
         4oQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1bAoxn3SWu3BR7U54EL+ODdosFSa9pvjsulKehydkZU=;
        b=jwnAdWsVn76REZSySk9aXwDOY/FQzZ6Gm6tqyf8Z+7Jvb/0EB14curX6dIkY0W+dlY
         ydW2nc+jYXKb8bRKc1MPpO+LxWyo34nLCXoY7hw5YEoimxxNjT0kaN4br0JvI77lnfaV
         mmeLPIAsnIhN2O7kzlFazryVf4f7zBFDbPqFoeI/fk/wZpf5yrniISznIsx5VJjNLH7n
         Iz9g7cjK2BWZBayqEsDaYvwGdrFzzWzHKJb+sUuvrG5Z628PkT33evdiSoBY2zW0B3F/
         jNgttcIqJ4ZUxAT5ltU4ZRWcPCrhQW0T0fwc8SaxfrhNFG8bEWdkg38+eQyJdV7b7sGO
         v+aw==
X-Gm-Message-State: AOAM530S7cMaL/LuDSw9yTzsqd6UlZjXhQNJrkDLaKcQ1vOGwwiBW1xb
        fF1yZ+xis7LcUCGQdCBg6c0FXHYyPbeWk6BH1ZgnrNb+
X-Google-Smtp-Source: ABdhPJwcpwgOLeS67uvf8iN1ICtw078ovGMMts9dIyNOOJiyTdlZ1E/OGpblwdsx7t8LRPAE5ZPVCiG9Caneuj/pXg4=
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr12414227oto.312.1640032912957;
 Mon, 20 Dec 2021 12:41:52 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info> <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
In-Reply-To: <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Mon, 20 Dec 2021 17:41:27 -0300
Message-ID: <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bart,

On Mon, Dec 20, 2021 at 11:57 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > [TLDR: I'm adding this regression to regzbot, the Linux kernel
> > regression tracking bot; most text you find below is compiled from a few
> > templates paragraphs some of you might have seen already.]
> >
> > On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > > Some GPIO lines have stopped working after the patch
> > > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> > >
> > > And this has supposedly been fixed in the following patches
> > > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> >
> > There seems to be a backstory here. Are there any entries and bug
> > trackers or earlier discussions everyone that looks into this should be
> > aware of?
> >
>
> Agreed with Thorsten. I'd like to first try to determine what's wrong
> before reverting those, as they are correct in theory but maybe the
> implementation missed something.
>
> Have you tried tracing the execution on your platform in order to see
> what the driver is doing?

Yes. The problem is that there is no list defined for the sysfs-gpio
interface. The driver will not perform pinctrl_gpio_request() and will
return zero (failure).

I don't know if this is the case to add something to a global DTD or
to fix it in the sysfs-gpio code.

> Bart

Regards,
Marcelo.
