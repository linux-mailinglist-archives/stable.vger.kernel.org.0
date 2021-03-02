Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD732AEF4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhCCALB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382782AbhCBKQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 05:16:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0A9C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 02:15:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id jt13so34218255ejb.0
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 02:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MpgdEY+xkJdsoRX59VzkePVcPoFPaD3OZG7TYDRW4KU=;
        b=q66k2buIJldsnHIt6TmO9TJrxPJTcGOMHfKWA3WCAouMGR3WMo6B1zOIXj+5dyCPgU
         Erzg6/W683GesDNNNQmv7RT/bTEnndnfV8LQi4GA/MZgq2wyq83WLjGgoabkHXJLTd0+
         nSefuvXOD4AXnHIBm25McxuQeA8JTVFa1Nv5WVaSL8umn9cPbmNzfnYe7hXSXvONWO5B
         fLsmN9hJPAELZB0gTNNnkJK+J4w4Abt3pWXQ7L0IKyc20evQzDQuByWKmTvH3AKR2b6P
         YYrLStCfOny5+3bbHRw31rZ5iFf+KdrgiivY1heV973Eu1a/02hD1p0egRG8snj6X8Bk
         fidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MpgdEY+xkJdsoRX59VzkePVcPoFPaD3OZG7TYDRW4KU=;
        b=tVAZUfUDwYuc8zI+cBXymOMZjpnGoniEKuCrwyXoIYqFHUi45FMdw6DDzeVky3sqEo
         BXFwatxeV/rdjD8KuTikMW/YVmGwB1gZhCKrECxvKQVTQs7wtYwbP3Ei4V5zFNymi4Ws
         q7VlZ4mE6n8MNhFA719881fUTpRmC2abqigZGeZBkayx29P7rySVL/laE5bWC6AWB9iS
         n5BGmLPe5eOL9iWYD1nB3q8Qa80sYOKTfbcm0tgrbpaexFu/g2QMePiJKSFu5bvrsFkQ
         7stzBf1Rf46u4c2ta/UFOkEaSTUaGdj2P9SibJlTbTl6e2wFcs7hdxyfIp83GRh27e+T
         N0FA==
X-Gm-Message-State: AOAM530ImUdOSx3ndk8c8LgS9JJ29Saj63vEwYZ81P4hsNIAEaiKKGeJ
        79VbcHA4DJ8hn1Mru0ivlO8MN4kmhojLvTkMvxr13w==
X-Google-Smtp-Source: ABdhPJwlLd0mNZbGEtX9E/pIytMCFYrh0qNifxpn5diBNusJ17Ap1GHoboVpaKamYOneEv6/1WANMx+miaF3e88roFk=
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr20045311ejb.503.1614680124240;
 Tue, 02 Mar 2021 02:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20210301193642.707301430@linuxfoundation.org> <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
 <CA+G9fYsivUPRRQgMXpnA_XdXH8i2wx_DPH70t+6OzHkjOaswrg@mail.gmail.com> <YD4L57LQb8Nh/A85@kroah.com>
In-Reply-To: <YD4L57LQb8Nh/A85@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 15:45:13 +0530
Message-ID: <CA+G9fYsuLBo86PVUGVx=w6w8t9UCmNw+Co53_g_suE_my9Mmug@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jirislaby@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021 at 15:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 02, 2021 at 03:20:32PM +0530, Naresh Kamboju wrote:
> > Hi Greg and Linus,
> >
> > On Tue, 2 Mar 2021 at 12:45, Naresh Kamboju <naresh.kamboju@linaro.org>=
 wrote:
> > >
> > > On Tue, 2 Mar 2021 at 01:21, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.10.20 releas=
e.
> > > > There are 661 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/=
patch-5.10.20-rc2.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > Results from Linaro=E2=80=99s test farm.
> > > Regressions detected on all devices (arm64, arm, x86_64 and i386).
> > >
> > > hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> > >
> > > This failure is specific to stable-rc 5.10 and 5.11.
> > > Test PASS on mainline and Linux next kernel.
> > >
> >
> > I have reverted these two patches and the test case got PASS
> > on Linux version 5.10.20-rc2.
> >
> > hangup01 1 TPASS : child process exited with status 0
> >
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: implement read_iter
> >
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: convert tty_ldisc_ops 'read()' function to take a kernel po=
inter
>
> Odd.
>
> Is 5.12-rc1 also failing with this test as well?

No.
Test PASS on v5.12-rc1.

- Naresh
