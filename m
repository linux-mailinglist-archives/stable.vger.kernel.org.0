Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E47209D15
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404024AbgFYKwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 06:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgFYKwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 06:52:50 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A88CC061573;
        Thu, 25 Jun 2020 03:52:49 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so5994160ljn.4;
        Thu, 25 Jun 2020 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0qf+WwjLjZe3vMqS+VrsoQuseqViWgd3zGOf1M8nB9U=;
        b=Vqg2LD9D0O/2OhntPwkfFH4OpzES5l2IUdWp4EE9OixK9Mfdu1AoSCVbFN6Nbd5Hen
         5INRLzs9cJR28sG3/hAIdsw2i5VahwO5ToPyhJvIWZxuhBrI/5j232shF+cG9W23QU1t
         +vQWkwODYHe7hFq4RlZ8V59ZksoWYxyjXROiy9rEpwVzfFZXosVSMrXHfFgG0nSbVdpl
         9OZysZdpWcNOszUzh/ZNcyDDgYoZe6i6JkLXn2Kl48x9DB7vF9n+Tr3arOswUKnLZLMB
         ZIlfyCBvXrL2H88rEOjo+OchD4emmXkN3A+PxuGxKTEwdyju2HW2WG+5ej+fDDK8XLeL
         9HFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0qf+WwjLjZe3vMqS+VrsoQuseqViWgd3zGOf1M8nB9U=;
        b=LnMIDEccNW5S9sWvG92X0rjaiKvwd1G+UOFe6I5WLGMVnE4HwPJDnTkmwf46GC0IBw
         NnEfqKf8d/UVZMQPWIokpltAZwYeh0hxMmBWCcP0Y3mD94bE0r6GxsNoD7Im0AN/Yk+Q
         Z0m5IU7Q4YGTeEs8CPPCDrm7TxqtCOsWIkBzFv/2Ot7N+yf5bQ+YN7XG+euYUwAUbY3h
         go8tLV1/cGWTVdqTyjmGx6AB1DyB5AVs51h2aedbYP4gAXtTkIHEiF8X6SIfy01sx5Wj
         TYvmhoVNF8qyP6o88ouxRifXQBcFU1OS0vSoANlPLr7ptYp5xHkMXXzgvDeZdYl3XUq6
         7+lA==
X-Gm-Message-State: AOAM531Rf9eLyzFMt4SkK62rJcBQ69j1snJIyF9744AoymLwABK3scLV
        SKrUHNIoUphPxYnanPGOwNR/7a4aGVyBM47hiA==
X-Google-Smtp-Source: ABdhPJwacAJi0USWhyA6c8/w0XjhDAOSmOvEEAf/E2Qkfh26ELP75vacUc++JsD0X1OE2GVKZAfVe6w7qbq1292+z+4=
X-Received: by 2002:a05:651c:119a:: with SMTP id w26mr1664799ljo.126.1593082367574;
 Thu, 25 Jun 2020 03:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com> <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org> <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
In-Reply-To: <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Thu, 25 Jun 2020 12:52:21 +0200
Message-ID: <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
Subject: Re: ath9k broken [was: Linux 5.7.3]
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        angrypenguinpoland@gmail.com, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
<nix.or.die@googlemail.com>:
>
> Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
> >
> > On 25. 06. 20, 0:05, Gabriel C wrote:
> > > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org>:
> > >>
> > >> I'm announcing the release of the 5.7.3 kernel.
> > >>
> > >
> > > Hello Greg,
> > >
> > >> Qiujun Huang (5):
> > >>       ath9k: Fix use-after-free Read in htc_connect_service
> > >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> > >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> > >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> > >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > >>
> > >
> > > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > > while working fine on <5.7.3.
> > >
> > > I don't have myself such HW, and the reported doesn't have any experience
> > > in bisecting the kernel, so we build kernels, each with one of the
> > > above commits reverted,
> > > to find the bad commit.
> > >
> > > The winner is:
> > >
> > > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > > Author: Qiujun Huang <hqjagain@gmail.com>
> > > Date:   Sat Apr 4 12:18:38 2020 +0800
> > >
> > >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > >
> > >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > > ...
> > >
> > > Reverting this one fixed his problem.
> >
> > Obvious question: is 5.8-rc1 (containing the commit) broken too?
>
> Yes, it does, just checked.
>
> git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
> v5.8-rc1
> v5.8-rc2
>

Sorry, I read the wrong, I just woke up.

We didn't test 5.8-rc{1,2} yet but we will today and let you know.

> >
> > I fail to see how the commit could cause an issue like this. Is this
> > really reproducibly broken with the commit and irreproducible without
> > it?
>
> I can't see something obvious wrong either, but yes it's reproducible on his HW.
> Kernel with this commit breaks the dongle, with the commit reverted it works.
>
> >As it looks like a USB/wiring problem:
> > usb 1-2: USB disconnect, device number 2
> > ath: phy0: Reading Magic # failed
> > ath: phy0: Unable to initialize hardware; initialization status: -5
> > ...
> > usb 1-2: device descriptor read/64, error -110
> > usb 1-2: device descriptor read/64, error -71
> >
> > Ccing ath9k maintainers too.
> >
> > > I don't have so much info about the HW, besides a dmesg showing the
> > > phy breaking.
> > > I also added the reporter to CC too.
> > >
> > > https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea
> > >
> > > If you need more info, please let me know and I'll try my best to get
> > > it as fast as possible for you.
> >
>
> Best Regards,
>
> Gabriel C
