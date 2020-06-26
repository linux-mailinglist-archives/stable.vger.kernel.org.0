Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903220B0D8
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFZLt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 07:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgFZLt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 07:49:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C66C08C5DB;
        Fri, 26 Jun 2020 04:49:26 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g2so5012062lfb.0;
        Fri, 26 Jun 2020 04:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ss1mUQEA71hYwxYf3sh5BP88GR/cUANQn8zzc0btYbU=;
        b=O/LIwe/zc8JPp/jBjwpyYuXwWZv3UnSIM6MSWeU1kyXjXiqL3oDrijIhOcQHXMu/+g
         qu1ERd3JTYEEsUx2PhgFBtldsRa6LRIGvG0RnrBeZSHSUS+GAEdD5GapfHwMEARqQ/HS
         HmFzquwzaUUP8gYN8ul2l0nVgN0fekhv4WUPyXopbXGeY6UBR8cSP0DnC5CCga95DiQI
         yo5Krwgpx91r2ld92U2zPPUWoWLnVAEWMhjwSh1r3aYYcOXga1DnV29PcovLI9v9GNKb
         elUheNvKIHNCfFDMrY9XdS00AscTVaNPR7F0QjLAzJ8i78+q3zKqCWZL3CUMVA1xcCrL
         4R7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ss1mUQEA71hYwxYf3sh5BP88GR/cUANQn8zzc0btYbU=;
        b=SXiiz6JptBNlB8LtaE0cLyjwLTOsoyBB29gIutVjzJc4/79lHxhcRFsSklghjZJJ4r
         Hpq+rFqhwP0ro5UVkHYlGkFHaJCB+Q9ZjPNkV9snYawNU/3JL3XnTLWgy7wHNMJfxVcn
         ZxgNXZeQiUsj4d790VG7NLqJq6l2eXojRyFzRgusS7fGhNeECqunGOvWByCYPjqojzT4
         Tk+7rH439pebA6nmhQPmoOTrzKxZQFNqQVwELcT3IIoInfcPE3H7WTvTXnbbXdWY51XO
         TwXitdZLB48BIUoC+vxwVN/luY2zw7egwzso1hmXEEVrsP2f56spESyIKdHL08mfBB3o
         yG/Q==
X-Gm-Message-State: AOAM531B1jyqOwF8ZrTMuRVnMF2YX/i36c0Afecm1r0RDsPv4NQcaS/o
        jY+K6ZcsiY6dm4LLm2IN9TPSt7PxuHN+LW8dWw==
X-Google-Smtp-Source: ABdhPJzIEmOG6suuMShv0PXoi5S0Dx2fUmNIh9k3VNglBE5zGov/Q3DWWKLfrj2FC/OqDp7cDXXM/CnPylwaoRuEHms=
X-Received: by 2002:a19:7014:: with SMTP id h20mr1614176lfc.49.1593172165222;
 Fri, 26 Jun 2020 04:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <1592410366125160@kroah.com> <CAEJqkgjV8p6LtBV8YUGbNb0vYzKOQt4-AMAvYw5mzFr3eicyTg@mail.gmail.com>
 <b7993e83-1df7-0c93-f6dd-dba9dc10e27a@kernel.org> <CAEJqkggG2ZB8De_zbP2W7Z9eRYve2br8jALaLRhjC33ksLZpTw@mail.gmail.com>
 <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
In-Reply-To: <CAEJqkgj4LS7M3zYK51Vagt4rWC9A7uunA+7CvX0Qv=57Or3Ngg@mail.gmail.com>
From:   Gabriel C <nix.or.die@googlemail.com>
Date:   Fri, 26 Jun 2020 13:48:59 +0200
Message-ID: <CAEJqkghJWGsLCj2Wvt-yhzMewjXwrXhSEDpar6rbDpbSA6R8kQ@mail.gmail.com>
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

Am Do., 25. Juni 2020 um 12:52 Uhr schrieb Gabriel C
<nix.or.die@googlemail.com>:
>
> Am Do., 25. Juni 2020 um 12:48 Uhr schrieb Gabriel C
> <nix.or.die@googlemail.com>:
> >
> > Am Do., 25. Juni 2020 um 06:57 Uhr schrieb Jiri Slaby <jirislaby@kernel.org>:
> > >
> > > On 25. 06. 20, 0:05, Gabriel C wrote:
> > > > Am Mi., 17. Juni 2020 um 18:13 Uhr schrieb Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org>:
> > > >>
> > > >> I'm announcing the release of the 5.7.3 kernel.
> > > >>
> > > >
> > > > Hello Greg,
> > > >
> > > >> Qiujun Huang (5):
> > > >>       ath9k: Fix use-after-free Read in htc_connect_service
> > > >>       ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
> > > >>       ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
> > > >>       ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
> > > >>       ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > >>
> > > >
> > > > We got a report on IRC about 5.7.3+ breaking a USB ath9k Wifi Dongle,
> > > > while working fine on <5.7.3.
> > > >
> > > > I don't have myself such HW, and the reported doesn't have any experience
> > > > in bisecting the kernel, so we build kernels, each with one of the
> > > > above commits reverted,
> > > > to find the bad commit.
> > > >
> > > > The winner is:
> > > >
> > > > commit 6602f080cb28745259e2fab1a4cf55eeb5894f93
> > > > Author: Qiujun Huang <hqjagain@gmail.com>
> > > > Date:   Sat Apr 4 12:18:38 2020 +0800
> > > >
> > > >     ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
> > > >
> > > >     commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.
> > > > ...
> > > >
> > > > Reverting this one fixed his problem.
> > >
> > > Obvious question: is 5.8-rc1 (containing the commit) broken too?
> >
> > Yes, it does, just checked.
> >
> > git tag --contains 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
> > v5.8-rc1
> > v5.8-rc2
> >
>
> Sorry, I read the wrong, I just woke up.
>
> We didn't test 5.8-rc{1,2} yet but we will today and let you know.
>

We tested 5.8-rc2 and it is broken too.

The exact HW name is:

TP-link tl-wn722n (Atheros AR9271 chip)

> > >
> > > I fail to see how the commit could cause an issue like this. Is this
> > > really reproducibly broken with the commit and irreproducible without
> > > it?
> >
> > I can't see something obvious wrong either, but yes it's reproducible on his HW.
> > Kernel with this commit breaks the dongle, with the commit reverted it works.
> >
> > >As it looks like a USB/wiring problem:
> > > usb 1-2: USB disconnect, device number 2
> > > ath: phy0: Reading Magic # failed
> > > ath: phy0: Unable to initialize hardware; initialization status: -5
> > > ...
> > > usb 1-2: device descriptor read/64, error -110
> > > usb 1-2: device descriptor read/64, error -71
> > >
> > > Ccing ath9k maintainers too.
> > >
> > > > I don't have so much info about the HW, besides a dmesg showing the
> > > > phy breaking.
> > > > I also added the reporter to CC too.
> > > >
> > > > https://gist.github.com/AngryPenguinPL/1e545f0da3c2339e443b9e5044fcccea
> > > >
> > > > If you need more info, please let me know and I'll try my best to get
> > > > it as fast as possible for you.
> > >

Best Regards,

Gabriel C
