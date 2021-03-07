Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226813302DE
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCGQL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 11:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhCGQKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 11:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4481F650F7
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615133455;
        bh=cwwfcaRvez2W+YLTYPHGS9f6HNGFpbiqWLV+hK+yqpM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mm4tam5G0eg7RKtZZQKkf/l3B3oVV6tjtYL+4QVZTBTnNY5LIJ8yqoF/mdgh6s8M0
         aR/isOxbnRkw40OEbusInUZuwadiKbmOHuSV1gmZptFRIS7+tSpPeZ81N1FawcONOi
         5kDzZjlj34BkZ52Tnjm5VDPrgQmhcZbJnpdFuuD00M6oslgqIGIa+zk7WK/D1qW0ZQ
         GwRVTCTtqb20usueTEDrDVus02WxjYwQEmlrty+5rBGuM7Rrf5XXfYiS5Wn2F6rh8w
         3sFsvcR/XDv5Hvs6OxR3xbj81ZeYydJgucrI73Dl4WT2/6P5rxQ7Xh88xGgEeFAoo5
         q0EMW2p4vnSAg==
Received: by mail-ot1-f49.google.com with SMTP id n23so1212544otq.1
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 08:10:55 -0800 (PST)
X-Gm-Message-State: AOAM533YWO4J6CTnEa18IMm2MaagMe35UTTVLuNHVc3xFrJbdorY382z
        7TAEM53JbsDBWJPdkZmU8l3kVopdbyVNmD/Kqrg=
X-Google-Smtp-Source: ABdhPJxCyw1W4mIBp9ocK96o1ZqAAzTl2bzqDCW+on8KH2EPv9kekl3MFBAs5iAG7GZtTLHh1ktM95ZIIiR9kMFqWrg=
X-Received: by 2002:a9d:503:: with SMTP id 3mr6907540otw.77.1615133454620;
 Sun, 07 Mar 2021 08:10:54 -0800 (PST)
MIME-Version: 1.0
References: <20210307150040.GB28240@qmqm.qmqm.pl> <YETvOfBpfGrzewmt@kroah.com>
In-Reply-To: <YETvOfBpfGrzewmt@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 7 Mar 2021 17:10:43 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
Message-ID: <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
Subject: Re: stable: KASan for ARM
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(+ Russell)

On Sun, 7 Mar 2021 at 16:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Mar 07, 2021 at 04:00:40PM +0100, Micha=C5=82 Miros=C5=82aw wrote=
:
> > Dear Greg,
> >
> > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> > are 7a1be318f579..421015713b30 if I understand correctly. They are
> > not normal stable material, but I think they will help tremendously in
> > discovering kernel bugs on 32-bit ARMs.
>
> Looks like a new feature to me, right?
>
> How many patches, and have you tested them?  If so, submit them as a
> patch series and we can review them, but if this is a new feature, it
> does not meet the stable kernel rules.
>
> And why not just use 5.11 or newer for discovering kernel bugs?  Why
> does 5.10 matter here?
>

The KASan support was rather tricky to get right, so I don't think
this is suitable for stable. The range 7a1be318f579..421015713b30 is
definitely not complete (we'd need at least
e9a2f8b599d0bc22a1b13e69527246ac39c697b4 and
10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 as well), and the intrusive
nature of those changes means they are definitely not appropriate as
stable backports.

--=20
Ard.
