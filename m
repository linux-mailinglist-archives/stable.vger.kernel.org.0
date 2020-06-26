Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A384120B2E2
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgFZNvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZNvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 09:51:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB88FC03E979;
        Fri, 26 Jun 2020 06:51:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so10380910ljg.13;
        Fri, 26 Jun 2020 06:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46r649Uez0rkaurVXfiiV2hDDKBiLO1oIqGfEBxbuiE=;
        b=d+RPOD3LHQ7r6y0UgVav6ml+8pzYPHpwaOSlccfAPLt01I+TC9LCvjYahGn3RthkGp
         i6AqG9q0n1LBZ72ZJH+3RQBoZAafeJWLOrDvuF+/IHdtIzMQXAkOJM61x4An3UjeHXD3
         LfVvO+Y9vEo/sdHfPiJ9p2/Gg1pW86C5ii7dAMvxZVrrFUEjG2ro9hVtEt0yiht+Nyne
         sOYItzi4R7euHw12kDqR5yL+TQjTTDRHApUSCFCtN3s1XvY2cIfCcY0pGw9DcCYPZ8rK
         B6c0l0UEhnvzlG7hQttxDoeag+q6/3y4HJXewqh/6yig8Oqd/fou6CNptI4Li/a70lbW
         +r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46r649Uez0rkaurVXfiiV2hDDKBiLO1oIqGfEBxbuiE=;
        b=GMd43tW+YOLkmYro8KEJoWsq62oO1EmMdCtOfInji1hqQX/fJot0WPzTz0SR6Qq2pl
         pzk5FWCsvHnEDJpHyEkmy45E0Czl+LXlwuUHj0g+3tG2gkQKpi3aPIKTYXvI2lnKF/no
         tamTMcHD9KAjfsPFVGbDnpbiL1JFkFYYs4Cue5GQ3g+ZUfhAgRNmneRBmmDIJUhfdQjE
         gSuq4IU2OgWgiv2u6660Q/Do/be1PGRME/8Qqm60CV2PYX5Y4ZmUTQiihMtcsWMC+X5w
         VokKltmWLTZO5IjOSFXUzMk+b42FSRrKBoXt3po65U7kZJQOnkxfGBTOtUr0569Zuhcc
         LvkQ==
X-Gm-Message-State: AOAM530jyE4P5nO3Au9Fpj4cLHTeOCY+ba44V1F8MbcJ1ogtFpX24v/X
        3IE/As1BTEfN0mJmF9P2BptqIdT/G/1xAY1FPA==
X-Google-Smtp-Source: ABdhPJyGdBesnUK+NuePNwSJyh+NmZYV6mYDBOcR8dt6U4ZGDC40q01ZvVp2zuKNWne3KBw85iKKP/GU123+2cEwEC4=
X-Received: by 2002:a2e:b176:: with SMTP id a22mr1429963ljm.291.1593179511327;
 Fri, 26 Jun 2020 06:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com> <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org> <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
 <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
 <CAEJqkghJWGsLCj2Wvt-yhzMewjXwrXhSEDpar6rbDpbSA6R8kQ@mail.gmail.com> <20200626133959.GA4024297@kroah.com>
In-Reply-To: <20200626133959.GA4024297@kroah.com>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Fri, 26 Jun 2020 15:51:24 +0200
Message-ID: <CAEJqkgiACMar-iWsWQgJPAViBBURaNpcOD4FKtp6M8Aw_D4FOw@mail.gmail.com>
Subject: Re: ath9k broken [was: Linux 5.7.3]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
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

Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
> > Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
> > <nix.or.die@googlemail.com>:
> > >
> > > Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
> > > <nix.or.die@googlemail.com>:
> > > >
> > > > Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
> > > > >
> > > > > On 25. 06. 20, 0:05, Gabriel C wrote:
> > > > > > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org>:
> > > > > >>
> > > > > >> I'm announcing the release of the 5.7.3 kernel.
> > > > > >>
> > > > > >
> > > > > > Hello Greg,
> > > > > >
> > > > > >> Qiujun Huang (5):
> > > > > >>       ath9k: Fix use-after-free Read in htc_connect_service
> > > > > >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> > > > > >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> > > > > >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> > > > > >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > >>
> > > > > >
> > > > > > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > > > > > while working fine on <5.7.3.
> > > > > >
> > > > > > I don't have myself such HW, and the reported doesn't have any experience
> > > > > > in bisecting the kernel, so we build kernels, each with one of the
> > > > > > above commits reverted,
> > > > > > to find the bad commit.
> > > > > >
> > > > > > The winner is:
> > > > > >
> > > > > > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > > > > > Author: Qiujun Huang <hqjagain@gmail.com>
> > > > > > Date:   Sat Apr 4 12:18:38 2020 +0800
> > > > > >
> > > > > >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > >
> > > > > >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > > > > > ...
> > > > > >
> > > > > > Reverting this one fixed his problem.
> > > > >
> > > > > Obvious question: is 5.8-rc1 (containing the commit) broken too?
> > > >
> > > > Yes, it does, just checked.
> > > >
> > > > git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
> > > > v5.8-rc1
> > > > v5.8-rc2
> > > >
> > >
> > > Sorry, I read the wrong, I just woke up.
> > >
> > > We didn't test 5.8-rc{1,2} yet but we will today and let you know.
> > >
> >
> > We tested 5.8-rc2 and it is broken too.
> >
> > The exact HW name is:
> >
> > TP-link tl-wn722n (Atheros AR9271 chip)
>
> Great!
>
> Can you work with the developers to fix this in Linus's tree first?

I'm the man in the middle, but sure we will try patches or any suggestions
from developers to identify and fix the problem.

>
> I bet they want to see the output of 'lsusb -v' for this device to see
> if the endpoint calculations are correct...
>

Working on it. As soon the reporter gives me the output, I will post it here.
I've told him to run it on a broken and one working kernel.

> thanks,
>
> greg k-h

Best Regards,

Gabriel C
