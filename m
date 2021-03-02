Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDBD32AEF2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbhCCAKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382758AbhCBKN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 05:13:28 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D91C06178B
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 02:12:37 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id dx17so6586010ejb.2
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9emZJGXSfS3CBcoV3moek0dr0o68xi0UvE5qBXpPUXA=;
        b=fr17Px/Z62oKFGYJ/W88x9bOoKKpT/UW7LHPP7GzTTUryspn3cBwYenB6BbxirCW3r
         XOCtCtIgvkezeRYYTG0m9S7vRfZb0U+NKoF9KTGtjklJjsgD06NXphU1asP1hXb6Kp+D
         ekVH4pz2whvgusZscWvubpgcqi5Qw0KtAuMgKCmoDoLitRb/PNvLqpI6ca+hE3rr6HUS
         fJRzAqiD31DYBZ4MSH19AliggrS3qJgAn/NMD4/rAXQksEax49z1TQWGk/SiZQhuNuVN
         gXXJ97iZwOrOaD1D6BLA1BXmzAR2zDnTP3W9yBOerDdyJC9OI3l6n29fxZo0vOU6UXKA
         KiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9emZJGXSfS3CBcoV3moek0dr0o68xi0UvE5qBXpPUXA=;
        b=McsBBVn75htHLdLdJ2h0bAiSOly5ZCsJ4gHfyW5b/DkYomU7Rg4jSHE8hG5Av0ZAWQ
         g0KblsG05kTtFtPF5qZ6KAmgwsZd5yD3ej8Hph+2538ThiBWaKvm5T7dW0Gun9A2aLtE
         QsXzaCzK26XiK8fIRlINu5zjgdim+MYhDTzRa110CxByqGMAv5Qk5m8Pq3Wc6bV9lRaC
         GqWUk5iqKaOY1z080dSivOhkJ+AXYA/WRvRNuM8j7S+j+oet4GFgMFPvdpTulbhd20Qw
         9WDHFs8yg8mWBKuEW1E8uqDcGetfStqxAI8ncXD3b51MvrgCxLPQWCKUwTm64fWz6MWv
         231w==
X-Gm-Message-State: AOAM532Pg+NBtaxB9Uk+y5AbHded1LyGNRGqOEd9yd4ToIKghLqPJPS+
        mJDX9uZfCJoSsHX+8zGQlCT/lGz+TObnGOXLJPZ80A==
X-Google-Smtp-Source: ABdhPJygHRWR6muKo1EKip/CdEc4MkfpNRQJIYTz00eMsp1q2b55BBcAgn3jRL2LvNtMSRKUwCewGi/MkwTQZskjB/0=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr20268094ejo.247.1614679956551;
 Tue, 02 Mar 2021 02:12:36 -0800 (PST)
MIME-Version: 1.0
References: <20210301193642.707301430@linuxfoundation.org> <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
 <CA+G9fYsivUPRRQgMXpnA_XdXH8i2wx_DPH70t+6OzHkjOaswrg@mail.gmail.com> <YD4L57LQb8Nh/A85@kroah.com>
In-Reply-To: <YD4L57LQb8Nh/A85@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 15:42:25 +0530
Message-ID: <CA+G9fYtbYENvUk8z78k3OHj5cULbd5Tc3Dfew0EE6sKfndOJxA@mail.gmail.com>
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

5.10 Failed
5.11 Failed
5.12 PASS

This LTP pty hangup01 PASS Linux mainline and linux next.

- Naresh
