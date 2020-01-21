Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F58144805
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAUXHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 18:07:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38259 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUXHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 18:07:55 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so3769928lfm.5
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 15:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dITQVLbK/NPk07lly0JDaiOTyqI9WjCMwk1K5x1ixns=;
        b=pbbkCNagoNPKQVRuecBzJBjgVkMwC3T8eXhuNVHXF1JxZWvItp8DUs/Uv7Bxxz8Ssr
         R71k+N0WgOIxko4jD4rWOZUMnaZNdk10C1DCXzt+KL1+hU/3fzBmW32VXBEfHdVYuX/3
         LKrhQEipQb1FE4aVAKClwxbRn1pfRzV++182l/374+6JjsXjyAKxr/rvS5zmi/TKW91y
         0h8KkFCbmBRA+ebLjpb3RYYjqWCMB82ab/aId8jj9Dkm1hnwLzFN97x5geM150M52Trk
         +EbJQBytpZ034FWUtWkhPPFmbNJ8hO4tbV1QOrDMraKwQjFbMnWTYqoCrtGaPrr1A0T2
         RbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dITQVLbK/NPk07lly0JDaiOTyqI9WjCMwk1K5x1ixns=;
        b=Iisz2bsp65IJXM6uMjb8kCJUPsXm0w64AyUrJni9jItja6UGhOcLajuKiEQ82/WGKQ
         jKNmPhDkqPjOoH3+hNk6E/Z2/g21vpZprjmY4He0dz0t8Xlo9jPuPoMjMiHkxJTw7UgA
         wQ3GcRnhPVzKjfl+RQIR3HruFdSpn9UemBw29Q2Dh+mcPuHRIcmi1DsLyGKA9CfdN9GY
         7bxCaGfn57qh4Ii2d68U33p4tZLwu5X590U2zeSlbb3JmXWhaJ010YfNa9t4fjuAjj4y
         sO5URVz99tD60/Th5NNP1Z0ch3RnH5TpMjnHIyWIX2MKwIKjWvXvUqnYZMeHkdWM8bQj
         xRHQ==
X-Gm-Message-State: APjAAAVbjd2mhv4uQ/W31IjPz0d1YdF3aFAA7ql4vCRoABmMB1Aw84M9
        nUQZ1bSw9KD65gjwt0NviqLi1EH2qiwfhOL1xbJlRQ==
X-Google-Smtp-Source: APXvYqyj4/tOipEE+F2MUs1QSBgROTa4tMvk+HoF2kn0F3V3ikXHUkztp/0DBT91QRMn0PioTFWz5rNuwRla5vtIVDE=
X-Received: by 2002:a05:6512:7c:: with SMTP id i28mr68769lfo.131.1579648073334;
 Tue, 21 Jan 2020 15:07:53 -0800 (PST)
MIME-Version: 1.0
References: <20191230120021.32630-1-jagan@amarulasolutions.com>
 <20200109074625.GE4456@T480> <CA+G9fYvKw7ijk-vxA58SR_d0_-3_in28uFG5H6pikypgDpAHPQ@mail.gmail.com>
In-Reply-To: <CA+G9fYvKw7ijk-vxA58SR_d0_-3_in28uFG5H6pikypgDpAHPQ@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 21 Jan 2020 17:07:41 -0600
Message-ID: <CAEUSe79LAxmMf31bt3hoEfUH3k3tqg=41mxy4yVJkYRTpw4k_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6q-icore-mipi: Use 1.5 version of
 i.Core MX6DL
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 20 Jan 2020 at 23:22, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
> The following dtbs build error noticed for arm build on stable rc 4.19 br=
anch.
>
> # make -sk KBUILD_BUILD_USER=3DKernelCI -C/linux ARCH=3Darm
> CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc O=3Dbuild dtbs
>  #
>  ../arch/arm/boot/dts/imx6dl-icore-mipi.dts:11:10: fatal error:
> imx6qdl-icore-1.5.dtsi: No such file or directory
>     11 | #include "imx6qdl-icore-1.5.dtsi"
>        |          ^~~~~~~~~~~~~~~~~~~~~~~~
>  compilation terminated.
>  make[2]: *** [scripts/Makefile.lib:294:
> arch/arm/boot/dts/imx6dl-icore-mipi.dtb] Error 1

This failed again on the latest 4.19.98-rc1 from
linux-stable-rc/4.19.y. Looks like it's missing 37c045d25e900 ("ARM:
dts: imx6qdl: Add Engicam i.Core 1.5 MX6") from mainline.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org



> On Thu, 9 Jan 2020 at 13:16, Shawn Guo <shawnguo@kernel.org> wrote:
> >
> > On Mon, Dec 30, 2019 at 05:30:19PM +0530, Jagan Teki wrote:
> > > The EDIMM STARTER KIT i.Core 1.5 MIPI Evaluation is based on
> > > the 1.5 version of the i.Core MX6 cpu module. The 1.5 version
> > > differs from the original one for a few details, including the
> > > ethernet PHY interface clock provider.
> > >
> > > With this commit, the ethernet interface works properly:
> > > SMSC LAN8710/LAN8720 2188000.ethernet-1:00: attached PHY driver
> > >
> > > While before using the 1.5 version, ethernet failed to startup
> > > do to un-clocked PHY interface:
> > > fec 2188000.ethernet eth0: could not attach to PHY
> > >
> > > Similar fix has merged for i.Core MX6Q but missed to update for DL.
> > >
> > > Fixes: a8039f2dd089 ("ARM: dts: imx6dl: Add Engicam i.CoreM6 1.5 Quad=
/Dual MIPI starter kit support")
> > > Cc: Jacopo Mondi <jacopo@jmondi.org>
> > > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> >
> > Applied all 3, thanks.
