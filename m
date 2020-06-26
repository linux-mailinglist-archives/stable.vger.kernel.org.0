Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32A520B3CF
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFZOks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgFZOkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 10:40:47 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C51C03E979;
        Fri, 26 Jun 2020 07:40:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t9so5287610lfl.5;
        Fri, 26 Jun 2020 07:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xh7ygJkmCFosm++mxzgG5yyD/OscriXelXv44rdvluw=;
        b=cWJtzdTYk02abJmysxbDCRJskrinaAUAFkO8W1g2vyR9TiVnbKqZlcq4MMMJBwkM7K
         z9ucMwmwgS7vAd7UFJGQ8M42Yf4MhSinMxpYfiEvF9ixBASuqF88xHF9+F3c/HVrbqIq
         G6zjrkeFykRg/fHsILrEzN00IBqfUpw+9zXNo+ha2RpcSdMU2arD+Iyf5yB1+aC+Tnnj
         d4/ZYb6tOvBZUr/8vSdBqoNESN6CawEZ+DnBJiHVdLFqfT6LBunt2OSMfdLcwTKRPbYu
         PZmFYTdOzhDeJeCY+OZqSlBgzKa4aIKUekB9YJPU6jcgVhLrtsrYqJa2ll+O195LP8Eo
         r9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xh7ygJkmCFosm++mxzgG5yyD/OscriXelXv44rdvluw=;
        b=sKH0g4rnzWSSFEOmNSvUBSzZUtNxKlK4MNi17rpZfqBILyKYseCRqONDCcX9mJg0sm
         nWTOICiq/vVb+wGWQ2mzK6GwQi5wdrfAWC2UB++3++M7qXouOrzwmG7QEqLWEy+4rtiO
         J6K7g4SqNI35arMliAI2MZsIVDz2WLY4ngZIrJxNh79hy7uNoK41awZQCg2oyCnR0TRM
         ZZONT9ynGZZ9ICxC/bsKx37Nl2DKrBSZUgDwBt0w3+WyimpFpJHJDOuAb75ksmsKTkJK
         7wuWvS8jPgzT7DUTB/mVd0Byu5ML3AQlLhF7+SO7A0KW6OV+HnU0Eor7uyBz5mJN5aPm
         unQg==
X-Gm-Message-State: AOAM532QVA/Ii1IoBzMuYQ94Qiygj4zzs+IF+OL7ncPNre+D8FxQk1Ll
        MWJjclwyYj6DVS61h8up2gHp8e+/Axdc2Eb1vQ==
X-Google-Smtp-Source: ABdhPJyYS+8oZjtM4PQR/C4hZ1n/HWdolh9OR1+vV89uMQ55qvep9ZMWJVjFUm/JlyAW94x6BMqZy3Ner73XBluXNSc=
X-Received: by 2002:a19:4a4e:: with SMTP id x75mr2042044lfa.70.1593182444933;
 Fri, 26 Jun 2020 07:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com> <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org> <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
 <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
 <CAEJqkghJWGsLCj2Wvt-yhzMewjXwrXhSEDpar6rbDpbSA6R8kQ@mail.gmail.com>
 <20200626133959.GA4024297@kroah.com> <CAEJqkgiACMar-iWsWQgJPAViBBURaNpcOD4FKtp6M8Aw_D4FOw@mail.gmail.com>
In-Reply-To: <CAEJqkgiACMar-iWsWQgJPAViBBURaNpcOD4FKtp6M8Aw_D4FOw@mail.gmail.com>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Fri, 26 Jun 2020 16:40:18 +0200
Message-ID: <CAEJqkgg4Ka8oNL7ELoJrR0-Abz3=caLns48KyDC=DQcym6SRvA@mail.gmail.com>
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

Am Fr., 26. Juni 2020 um 15:51 Uhr schrieb Gabriel C
<nix.or.die@googlemail.com>:
>
> Am Fr., 26. Juni 2020 um 15:40 Uhr schrieb Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>:
> >
> > On Fri, Jun 26, 2020 at 01:48:59PM +0200, Gabriel C wrote:
> > > Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
> > > <nix.or.die@googlemail.com>:
> > > >
> > > > Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
> > > > <nix.or.die@googlemail.com>:
> > > > >
> > > > > Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
> > > > > >
> > > > > > On 25. 06. 20, 0:05, Gabriel C wrote:
> > > > > > > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > > > > > > <gregkh@linuxfoundation.org>:
> > > > > > >>
> > > > > > >> I'm announcing the release of the 5.7.3 kernel.
> > > > > > >>
> > > > > > >
> > > > > > > Hello Greg,
> > > > > > >
> > > > > > >> Qiujun Huang (5):
> > > > > > >>       ath9k: Fix use-after-free Read in htc_connect_service
> > > > > > >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> > > > > > >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> > > > > > >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> > > > > > >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > > >>
> > > > > > >
> > > > > > > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > > > > > > while working fine on <5.7.3.
> > > > > > >
> > > > > > > I don't have myself such HW, and the reported doesn't have any experience
> > > > > > > in bisecting the kernel, so we build kernels, each with one of the
> > > > > > > above commits reverted,
> > > > > > > to find the bad commit.
> > > > > > >
> > > > > > > The winner is:
> > > > > > >
> > > > > > > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > > > > > > Author: Qiujun Huang <hqjagain@gmail.com>
> > > > > > > Date:   Sat Apr 4 12:18:38 2020 +0800
> > > > > > >
> > > > > > >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > > > > >
> > > > > > >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > > > > > > ...
> > > > > > >
> > > > > > > Reverting this one fixed his problem.
> > > > > >
> > > > > > Obvious question: is 5.8-rc1 (containing the commit) broken too?
> > > > >
> > > > > Yes, it does, just checked.
> > > > >
> > > > > git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
> > > > > v5.8-rc1
> > > > > v5.8-rc2
> > > > >
> > > >
> > > > Sorry, I read the wrong, I just woke up.
> > > >
> > > > We didn't test 5.8-rc{1,2} yet but we will today and let you know.
> > > >
> > >
> > > We tested 5.8-rc2 and it is broken too.
> > >
> > > The exact HW name is:
> > >
> > > TP-link tl-wn722n (Atheros AR9271 chip)
> >
> > Great!
> >
> > Can you work with the developers to fix this in Linus's tree first?
>
> I'm the man in the middle, but sure we will try patches or any suggestions
> from developers to identify and fix the problem.
>
> >
> > I bet they want to see the output of 'lsusb -v' for this device to see
> > if the endpoint calculations are correct...
> >
>
> Working on it. As soon the reporter gives me the output, I will post it here.
> I've told him to run it on a broken and one working kernel.

That is from a good kernel with reverted commit
https://gist.github.com/AngryPenguinPL/07c8e2abd3b103eaf8978a39ad8577d1

That is from the broken kernel without the commit reverted
https://gist.github.com/AngryPenguinPL/5cdc0dd16ce5e59ff3c32c048e2f5111

This is from 5.7.5 kernel, I don't have yet a 5.8-rc2 package with the
reverted commit.
