Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B8234CDFC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhC2K3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhC2K2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:28:52 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EEDC061574;
        Mon, 29 Mar 2021 03:28:52 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y18so11829673qky.11;
        Mon, 29 Mar 2021 03:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fo4u0e6RF3pczIEDkj+O0wutSwNJxQJ9lZsbpJLo1tM=;
        b=FMnQWfBfXrMfxqd2uEv0pi/ylHKOYLROpTYU6QDrtLjRIOejega9+pNIMaIXGq5zBO
         PzOryAO+jKQ6BM17hyY5ifg5NfogWQEh+r302s1KVnkNpx+a6XYAhCUxPWdSNWPIbw9L
         CZU1sacQ11YEddc6S6qtC+hGm+051ckeYC4cAnOBdIkRzIGPNcIzgz/wURwnF0xWvYEr
         1qeIPoiFGFvKi4CX9IOfjMJrT4wleN9E0LN2pUp6Lv64HAxLf6L8yJ1guvHrHN5/Oc+s
         O1Qe2ZKyJh/9luiO7j+lgA2yGwUJ1D4CiEMC9ri9Q/Tb46LFO1B1kcITGkNFimfzIhqT
         P55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fo4u0e6RF3pczIEDkj+O0wutSwNJxQJ9lZsbpJLo1tM=;
        b=blxAqUqPshXPfbCcC0dx5ocM1173eR6m+Ii8TM6YxaVNbhMeEJoIWgK/NAFQ+lPYKO
         ArH3MVpiTXybXTslbM+QeUSaJT8IcDxGr9TZockQsZlhFjnJw74LtnUtrZGjmtQbHzw2
         gy6BpHVZB+6lR76PcD5f8BpRnQ7ZHUpcd2bXkJ7zE4J1B38lV7W51IehbZ0s7rxXT6yO
         LsfInbRcbyRZsfvK/ZKH5mVlBDR8Y0W2K7We0TyEemEjy0w0OMvjL1Bbaiywum3zkeOa
         uUNqBinuzv6N/lt1yWmTfJEpoI7dS6BqI/5Q5Ba9vO422kf/i71VLi5U/r6b0Ga/DzFb
         nV/g==
X-Gm-Message-State: AOAM531elT2aLlvx3RuvRV1WMCfU+E/YBV/rAOu9iAip8xjTPQ0sR5ED
        ILgrwvc0K6Uk+oaMR+ZCxaREe2/o0U+pT4/NnWc=
X-Google-Smtp-Source: ABdhPJxlZUNtXxaNu+h4DjokcPw2CxalbLpbhlirbdUT7ra1G/4fsbz1XxkijXvTAILE2Y0K6n0grIw1meRnaIVktMM=
X-Received: by 2002:a05:620a:1388:: with SMTP id k8mr24244209qki.224.1617013731365;
 Mon, 29 Mar 2021 03:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210322015902.18451-1-yunqiang.su@cipunited.com>
 <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com> <20210329090058.GA6564@alpha.franken.de>
In-Reply-To: <20210329090058.GA6564@alpha.franken.de>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Mon, 29 Mar 2021 18:28:40 +0800
Message-ID: <CAKcpw6Vd6pCT2PB4pZATnEq8Y4pSj4cwNFZgg6yK6VjoeY+N-Q@mail.gmail.com>
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Bogendoerfer <tsbogend@alpha.franken.de> =E4=BA=8E2021=E5=B9=B43=E6=
=9C=8829=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:30=E5=86=99=E9=81=
=93=EF=BC=9A
>
> On Mon, Mar 29, 2021 at 01:09:18PM +0800, YunQiang Su wrote:
> > YunQiang Su <yunqiang.su@cipunited.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=
=8822=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8810:00=E5=86=99=E9=81=93=
=EF=BC=9A
> > >
> > > The MIPS FPU may have 3 mode:
> > >   FR=3D0: MIPS I style, all of the FPR are single.
> > >   FR=3D1: all 32 FPR can be double.
> > >   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-doubl=
e FPR.
> > >
> > > The binary may have 3 mode:
> > >   FP32: can only work with FR=3D0 and FRE mode
> > >   FPXX: can work with all of FR=3D0/FR=3D1/FRE mode.
> > >   FP64: can only work with FR=3D1 mode
> > >
> > > Some binary, for example the output of golang, may be mark as FPXX,
> > > while in fact they are FP32. It is caused by the bug of design and li=
nker:
> > >   Object produced by pure Go has no FP annotation while in fact they =
are FP32;
> > >   if we link them with the C module which marked as FPXX,
> > >   the result will be marked as FPXX. If these fake-FPXX binaries is e=
xecuted
> > >   in FR=3D1 mode, some problem will happen.
> > >
> > > In Golang, now we add the FP32 annotation, so the future golang progr=
ams
> > > won't have this problem. While for the existing binaries, we need a
> > > kernel workaround.
> > >
> >
> > We meet a new problem in Debian: with the O32_FP64 enabled kernel,
> > mips64el may also be affected.
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D983583
>
> hmm, raising this issue in this context before knowing more details,
> feels very trigger happy to me and this doesn't help accepting anything,
> jfyi...
>
> Could you please provide a link for downloading a golang binary, which
> would need this patch to run ?
>

For rootfs, you can download
   http://58.246.137.130:20180/debian-from/rootfs/buster-mipsel.tar.xz
or create by:
    sudo debootstrap --arch mipsel  --include golang-1.11-go \
                     buster buster-mipsel http://deb.debian.org/debian

For binary packages, you can download:
    https://packages.debian.org/buster/mipsel/golang-1.11-go/download

just chroot the rootfs and run:
    /usr/lib/go-1.11/bin/go
It will crash if kernel's O32_FP64 option is enabled.

> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]



--=20
YunQiang Su
