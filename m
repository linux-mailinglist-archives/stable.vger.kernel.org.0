Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EEE209D0C
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 12:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404043AbgFYKs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 06:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403997AbgFYKs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 06:48:56 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7744C061573;
        Thu, 25 Jun 2020 03:48:55 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c11so2946154lfh.8;
        Thu, 25 Jun 2020 03:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogZcy9cOrOsNSfio7x0qys7hDFYRAcov2/q+DXfsFdA=;
        b=jHPCgI5BsMocvW8SV5RvHGKHe0HI4Dy/1Gyxos/+PhLsL57o0fWti0JL5Fe+5OVNeG
         tIbRkbBh8J6xllsyA2qrR3KPRYwRJpyP1xJOpnrAKxRruRnNFgP8sLXfFHajFiycrDpX
         HVcMtQ0ueugOWoog3+uQ239/i+aiQMC91qpv0MqMySdmLtX2mnm26Txa6vE/p9kx8DxI
         byJTmR9tuDbbAABZcgh+hGMyqvFWKQK2TuQw0mamkDULSbHK3NrW+N+NzYFuu+hfSBXz
         b8fJfMdmmYd7bo2h0zvy+CgmfYu1VM7tli+8dQMNoQqnGlN9I5aiZDmokAbWyq579N+D
         TpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogZcy9cOrOsNSfio7x0qys7hDFYRAcov2/q+DXfsFdA=;
        b=qK6jW/HgMwTz5sXNvyCjw8b95l5FKSQMq+RmQTvfDWAbkXwtOjCCqcSQT7f4rJPXIv
         hCQd0fuNJZCS13UMmMC2w0PBd8x0gQj7Od3cT9zhpVHDfjieHk/uWFKi3c9dgKZGhRJw
         YRUH0yYs01Hi7HFsz7oUGzARyvSQJWm8qixEg9NTAe6H18DpqW4cyMAesmBl6Az7V57n
         X4PqeT/oqkSF+EQ4k30MugR+qF3ObvVrbBu7G/DbNFKeVl9zhRmhFmuFTk9cq09KQKuB
         2F6+vH7H6h0vFv/c0lzfvOT9IoMPSrZ0sgYC4GDGoQkpLl/wS08qHKiA9e+BVp/vOiGe
         wEUg==
X-Gm-Message-State: AOAM533kbGKl1KNgvN4PabQN7LBCehNtf4Vaaue4HUgIYlHatEZAb+mb
        hHg/6WjSTBdV4rwzXCvpSdf4qQm7gpxHk8mkgg==
X-Google-Smtp-Source: ABdhPJxN6TcXzxevroPnEK30hW4CvRpq4wNyHg2zzEc9L6a6tpQB99E/XZmlSWjvnypBN6xOhTixBDoMK7EXnOFXEhY=
X-Received: by 2002:ac2:5443:: with SMTP id d3mr18103967lfn.121.1593082134255;
 Thu, 25 Jun 2020 03:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com> <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
In-Reply-To: <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Thu, 25 Jun 2020 12:48:27 +0200
Message-ID: <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
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

Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
>
> On 25. 06. 20, 0:05, Gabriel C wrote:
> > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org>:
> >>
> >> I'm announcing the release of the 5.7.3 kernel.
> >>
> >
> > Hello Greg,
> >
> >> Qiujun Huang (5):
> >>       ath9k: Fix use-after-free Read in htc_connect_service
> >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> >>
> >
> > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > while working fine on <5.7.3.
> >
> > I don't have myself such HW, and the reported doesn't have any experience
> > in bisecting the kernel, so we build kernels, each with one of the
> > above commits reverted,
> > to find the bad commit.
> >
> > The winner is:
> >
> > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > Author: Qiujun Huang <hqjagain@gmail.com>
> > Date:   Sat Apr 4 12:18:38 2020 +0800
> >
> >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> >
> >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > ...
> >
> > Reverting this one fixed his problem.
>
> Obvious question: is 5.8-rc1 (containing the commit) broken too?

Yes, it does, just checked.

git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
v5.8-rc1
v5.8-rc2

>
> I fail to see how the commit could cause an issue like this. Is this
> really reproducibly broken with the commit and irreproducible without
> it?

I can't see something obvious wrong either, but yes it's reproducible on his HW.
Kernel with this commit breaks the dongle, with the commit reverted it works.

>As it looks like a USB/wiring problem:
> usb 1-2: USB disconnect, device number 2
> ath: phy0: Reading Magic # failed
> ath: phy0: Unable to initialize hardware; initialization status: -5
> ...
> usb 1-2: device descriptor read/64, error -110
> usb 1-2: device descriptor read/64, error -71
>
> Ccing ath9k maintainers too.
>
> > I don't have so much info about the HW, besides a dmesg showing the
> > phy breaking.
> > I also added the reporter to CC too.
> >
> > https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea
> >
> > If you need more info, please let me know and I'll try my best to get
> > it as fast as possible for you.
>

Best Regards,

Gabriel C
