Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B468ABB6
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 02:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfHMABL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 20:01:11 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42712 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfHMABL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 20:01:11 -0400
Received: by mail-ot1-f67.google.com with SMTP id j7so21057224ota.9
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 17:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p0AOP8Yrv517oAy+z8eqLHkuVHbpsfARBIOBtFI/77c=;
        b=LU714YqX04T/rSPqkdb6Ol4GUQwirBOxZ+RaJpDqpnZ3De8cWn89fh2tpY9q2j8PjS
         jRScNjNowTA7zwXbksqAVnHRNngjRWV27t/Tj4ju3zjjj5DA3AzbEGoQuzed54XFTRdG
         A4BnUqtlaeB16i7acPoPc1tivM2osDm+fDmUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p0AOP8Yrv517oAy+z8eqLHkuVHbpsfARBIOBtFI/77c=;
        b=ew5NAT2SOdA9V//0X8xbgzcM26fG+TW5p0dKz9ttxpkURaR5W0J+vNh9XbAoFozCux
         KwIqbMU3v9AADY15QzsZcvqzgOwoXYKzy5L+uyFhAspmq+qLdMa94jSHFUUy8WC2UkXq
         ecTNHDfXmpnqw0Sl871EGF2UJOkvmfaHmSL+6uIWYBqeG4c5AWSMElYBm3t9GNAijROF
         zldqiTyXr2BESEigZANHYktPwFyi1a/QocchEpixD9qjs6Nez34I1id9oZgqzIPq75ew
         GKG8/kAOjD8cP4zBnvnqiGc87Yfwfntk7O2sJhKGQFlTgEdhQTcTYltObw8gbbhe066A
         JEyQ==
X-Gm-Message-State: APjAAAUzOn9KALiHM3z0DOr9fb1GVC6s3T3byYTi0vPSahovdRinBJnX
        Th3aXpaMVyWEnoJ1eLN9Wa/uiQBZq7w=
X-Google-Smtp-Source: APXvYqzv0HY9eSnb6oPFdP3Qvf154YYso107CmpucLiNv+wMGiCh9oH3ruWlfbgLPvf362R7Y4JnRA==
X-Received: by 2002:aca:720c:: with SMTP id p12mr1184976oic.128.1565654470402;
        Mon, 12 Aug 2019 17:01:10 -0700 (PDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id j6sm1582029otq.16.2019.08.12.17.01.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 17:01:09 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id r20so15997468ota.5
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 17:01:09 -0700 (PDT)
X-Received: by 2002:a6b:cac2:: with SMTP id a185mr6294914iog.142.1565654468939;
 Mon, 12 Aug 2019 17:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124935.819068648@linuxfoundation.org> <20190805124936.105953796@linuxfoundation.org>
 <20190805144506.GB24265@amd>
In-Reply-To: <20190805144506.GB24265@amd>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 12 Aug 2019 17:01:02 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XwEOcgWope5=s2oPAUFXhc082kaaaBRGATM8gGsT-cAA@mail.gmail.com>
Message-ID: <CAD=FV=XwEOcgWope5=s2oPAUFXhc082kaaaBRGATM8gGsT-cAA@mail.gmail.com>
Subject: Re: [PATCH 4.19 03/74] ARM: dts: rockchip: Make rk3288-veyron-mickeys
 emmc work again
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Aug 5, 2019 at 7:45 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Mon 2019-08-05 15:02:16, Greg Kroah-Hartman wrote:
> > [ Upstream commit 99fa066710f75f18f4d9a5bc5f6a711968a581d5 ]
> >
> > When I try to boot rk3288-veyron-mickey I totally fail to make the
> > eMMC work.  Specifically my logs (on Chrome OS 4.19):
> >
> >   mmc_host mmc1: card is non-removable.
> >   mmc_host mmc1: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
> >   mmc_host mmc1: Bus speed (slot 0) = 50000000Hz (slot req 52000000Hz, actual 50000000HZ div = 0)
> >   mmc1: switch to bus width 8 failed
> >   mmc1: switch to bus width 4 failed
> >   mmc1: new high speed MMC card at address 0001
> >   mmcblk1: mmc1:0001 HAG2e 14.7 GiB
> >   mmcblk1boot0: mmc1:0001 HAG2e partition 1 4.00 MiB
> >   mmcblk1boot1: mmc1:0001 HAG2e partition 2 4.00 MiB
> >   mmcblk1rpmb: mmc1:0001 HAG2e partition 3 4.00 MiB, chardev (243:0)
> >   mmc_host mmc1: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
> >   mmc_host mmc1: Bus speed (slot 0) = 50000000Hz (slot req 52000000Hz, actual 50000000HZ div = 0)
> >   mmc1: switch to bus width 8 failed
> >   mmc1: switch to bus width 4 failed
> >   mmc1: tried to HW reset card, got error -110
> >   mmcblk1: error -110 requesting status
> >   mmcblk1: recovery failed!
> >   print_req_error: I/O error, dev mmcblk1, sector 0
> >   ...
> >
> > When I remove the '/delete-property/mmc-hs200-1_8v' then everything is
> > hunky dory.
> >
> > That line comes from the original submission of the mickey dts
> > upstream, so presumably at the time the HS200 was failing and just
> > enumerating things as a high speed device was fine.  ...or maybe it's
> > just that some mickey devices work when enumerating at "high speed",
> > just not mine?
> >
> > In any case, hs200 seems good now.  Let's turn it on.
>
> Ok, so this was tested in v4.19; good. But AFAICT it is queued to
> 4.14, too... which may not be good idea unless it was tested there...?
>
> Plus.. if this fixes stuff, that there are other configurations in the
> dts that do not work. Should they be disabled or something?

In general I don't have a good answer for you, but:

* The fact that nobody noticed that things were pretty broken here
implies that probably nobody is regularly testing mickey on upstream
and presumably nobody is testing mickey on stable, so likely it
doesn't matter a whole lot.

* The original mickey dts was from "Thu Dec 3 16:55:40 2015 +0100"
based upon kernel 4.4.  That means there were 10 kernel revisions
between it at 4.14.  If I had to guess without testing, I'd guess that
4.14 is still better off with this patch than without.

-Doug
