Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87B37ED87
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384123AbhELUiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359612AbhELSxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:53:34 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9055C061760
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:48:44 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g14so28313015edy.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3RmDL7EIZTWZ/B2GXBn8l6V8qil8i0g78OrUNzuJ15Q=;
        b=uV5SV6VWZxJU3E2LpGFmH/OT62UWjzQIP4RO9QcGdcZCxHyzVdsTwBXE08tRZOmzeB
         DnJHDoyODZG1OyFOtHqdmZvcwF0yBruNL0P1oSoUAPOFEVZsBrkssTp2RLGZJzhWj2rS
         +ooxmB1WUiJJn6YE9b9E6oE2MNroLTyB2kBfU7JdMMe/f3XLYwPQTQCQjtdoHIHgfkWo
         DMqFWk3oEXeHVuMGeNjxZmo7pgXhCK6tC00c4WiDuI6U2dEc1pG+ir2/G9gs2myL6dAM
         n6L1eN9OxJFdyGUZ/xTDUvKLXT6UZir1UX8zlIAnJ6q5MbL7xlgVRKJ6bHOa6+AmUXXR
         QjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3RmDL7EIZTWZ/B2GXBn8l6V8qil8i0g78OrUNzuJ15Q=;
        b=UzbjGsslDJbWPiTE+kpKFAP+IGzXfoEaXIbsM3qnEC2zMzpNqAjtiN6rdCAV16JevT
         mRRMMRZ5SMxJiXZFS4QeKdsZKPd9h2el2UXluIxXOLPNMt4Jdm9BEuQ9kCsmy1fGDzU6
         Qv3Y7C6iqZThSc14qpxNWZ6oU46PrmoAcCRT4q6XjPrEIh2fVUFevGAg0rFOiSzrqcec
         +M1qZNRms8dEjPUSag9lWgKHg14VSLPm+jyjw0lc+UpYgK8G1ssgVd1/E0hgnowxgJuC
         +UEbncHJWGGWS99dVM4+1cURVELwR8rychuAl1qDOb5oKS5b4KIKDi0kXQukJ5ux3Wec
         hLSg==
X-Gm-Message-State: AOAM532cpXdALQXFKKNoir0icTYNMP3dMipee/LoheGj4CXdWxgb2oDX
        +N0Sx4YUbtqMlDMPlg7FlXIq7ouapkuk1sx3RRSmQw==
X-Google-Smtp-Source: ABdhPJzDeWYGh4YnD9iEk0l21IsLSUTs81ND8mYmyduWdBlI80tiO28NJJtREUMrKsSD/fWAV/7bxyDjg/2eXSdeEbA=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr44656553edx.52.1620845323293;
 Wed, 12 May 2021 11:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144837.204217980@linuxfoundation.org> <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
 <YJwW2bNXGZw5kmpo@kroah.com>
In-Reply-To: <YJwW2bNXGZw5kmpo@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 00:18:32 +0530
Message-ID: <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021 at 23:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 12, 2021 at 10:53:04PM +0530, Naresh Kamboju wrote:
> > On Wed, 12 May 2021 at 21:27, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.12.4 release.
> > > There are 677 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > MIPS Clang build regression detected.
> > MIPS gcc-10,9 and 8 build PASS.
> >
> > > Maciej W. Rozycki <macro@orcam.me.uk>
> > >     MIPS: Reinstate platform `__div64_32' handler
> >
> > mips clang build breaks on stable rc 5.4 .. 5.12 due to below warnings / errors
> >  - mips (defconfig) with clang-12
> >  - mips (tinyconfig) with clang-12
> >  - mips (allnoconfig) with clang-12
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
> > CROSS_COMPILE=mips-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > clang'
> > kernel/time/hrtimer.c:318:2: error: couldn't allocate output register
> > for constraint 'x'
> >         do_div(tmp, (u32) div);
> >         ^
> > include/asm-generic/div64.h:243:11: note: expanded from macro 'do_div'
> >                 __rem = __div64_32(&(n), __base);       \
> >                         ^
> > arch/mips/include/asm/div64.h:74:11: note: expanded from macro '__div64_32'
> >                 __asm__("divu   $0, %z1, %z2"                           \
> >                         ^
> > 1 error generated.
>
> Does this also show up in Linus's tree?  The same MIPS patch is there as
> well from what I can tell.

No.
Linus's tree builds MIPS clang successfully.

- Naresh
