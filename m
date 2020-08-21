Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DD24DB24
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgHUQey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgHUQd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 12:33:28 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E5CC061575
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 09:33:26 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id v20so706398ual.4
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 09:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A/oKwkfb+xE2igh2JqvZd62SK5vd7DixPSCmGhlvK1k=;
        b=V4ONi0I9AyonItoyAW5bAn7URlmj2HhOUx8++1wxxTgr94yoWNKDPy/jOy5JKzkJds
         7tKHErCQpnD74nhcYdu09jHWIybsrgW2UQ0AA1kaKw3KdfGQOD6Iz8rwMCWrqTX8zx1K
         4cv1RVA7CaLd+Ws9eTBhpFvHdP1ezaAUp4HKrDzWi4FcpF7VCZWiKGy/M1AK4jYViFYW
         A+d/izcLkFj5V5rPvHbhKFRw2uzqAVRG+miIrt0NHLQ3zHJMS5jedmYIQqHEnZmgLOxD
         VwLxyfkvrFwwLA7JWQWDWoGGE442hlF9j9EnEFH3TREma2Sn/johYvEBfYbSV8Cyf6Iu
         Cxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A/oKwkfb+xE2igh2JqvZd62SK5vd7DixPSCmGhlvK1k=;
        b=E8Y+xr+Z0rJOj+th4VTKouZLlYZPZ4GwC8vruoB0iXC6R94qZfWKEjsIbbuI2xCiaQ
         umjZ0BpIjOe6ijMQI0QG9DI1evAHx0QKKTHe9UJW7fRp1s2DxQE4D531O5PDceAN6wDg
         lDMr6+F0bgMKj4suyZ4z5c1ggA0bafDOxcEsr/Gc9S5J0GVO4+qLpzAEuD/vii5N9sYB
         4SX/Cas36bKoMEZslUri8W11szefggioEznw0ZwP+ju9vxEALsgGNcGbQMuwRWQQPMz4
         7Rh8tcL9Wv6eTIllc8k77arPZMl9RWX47ahqPu02E1mf8TvMr49IZQRVApb4lBBnYdPX
         UdgQ==
X-Gm-Message-State: AOAM533dcyP0bPrSJWn5SgpxnCFn5H1DhDe8KS8z1OAzLKguSPqGD3m4
        pZmSMlEZwHaOmzXmXTd7r1QSLJPq3avd4r7SXmS+fA==
X-Google-Smtp-Source: ABdhPJyRGomSCWkNSAQh+1bafasZbt4z/W29crB8eERvEmKzieWFU+zXwDVBeZoMz3g0Y+NKUBquSQbgfLwNscyvo0M=
X-Received: by 2002:ab0:4029:: with SMTP id h38mr2196269uad.6.1598027602234;
 Fri, 21 Aug 2020 09:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091553.615456912@linuxfoundation.org> <CA+G9fYt+z3Cs9Cbf8HH8o59gsUkwjuKRCZmvQQ2K5OM_ydSRHQ@mail.gmail.com>
In-Reply-To: <CA+G9fYt+z3Cs9Cbf8HH8o59gsUkwjuKRCZmvQQ2K5OM_ydSRHQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Aug 2020 22:03:10 +0530
Message-ID: <CA+G9fYvGiOSBiCHpVGYXeXo3ZF3UDzj_Jy+_jqBD8CgwotS2hg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/152] 5.4.60-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 22:54, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Thu, 20 Aug 2020 at 15:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.60 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.4.60-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> > Herbert Xu <herbert@gondor.apana.org.au>
> >     crypto: af_alg - Fix regression on empty requests
>
> Results from Linaro=E2=80=99s test farm.
> Regressions detected.
>
> LTP crypto af_alg02 and cve-2017-17805 failed on stable-rc 5.4, 5.7 and 5=
.8
> branches on arm, arm64, i386 and x86_64.

Apart from the reported LTP crypto test case problem all other results
look good to me.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.60
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 77fcb48939fc863d9ba9d808fac9000959e937d3
git describe: v5.4.60
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.60

No regressions (compared to build v5.4.59)

No fixes (compared to build v5.4.59)

Ran 28522 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* ltp-commands-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-cve-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
