Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3508BB9346
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbfITOjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:39:48 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43436 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387551AbfITOjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:39:48 -0400
Received: by mail-lf1-f65.google.com with SMTP id u3so5215136lfl.10
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=94dTaQlxfmOLNaxOx5v2ZNWhpUPaHaSXDE601HqQIqc=;
        b=GZKcVwSmzEOfkfxUnBUilWyJFMqqKIAgoaEgEir/OsL7kPNuT/XkOZ2Xw2x/KWpPIi
         zBQj1koy5626C19f7a5q0g525xtKId98JiNysye6s4z6N2GMb1D+8kkmB3pGFwjku8A2
         Frhj19dN2VAzHanMfdGJncniOjFoKs3TrZfwzrENgBE1vFnEgdzpa4VdlhO1oW4X58NI
         0sX06YtkJH3K9vdeuwdrIhvTQULINBvz8i/9ziVISTElaACqBi4smiLGs1R0Wvm5Oo/J
         dxdxJzM03eqNAfz3/xZGBslRWyBieIRXiU01IADJWygNp0aUe1fGRHXbZsvaPGD013Uh
         k7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=94dTaQlxfmOLNaxOx5v2ZNWhpUPaHaSXDE601HqQIqc=;
        b=t5bdG972iTd1lx6oEp0lAXcyA521u5Q/HTpFq9aEg8HxxwhtW49jxCmuPhWosYrGhi
         nkgspAESiV3x0SZDe4KguwXEGgzWhUcnKDyrijEM3EfW/0D4AkYXXh9dmo14dXMueMqX
         AWuhe+jiK/bfX35istgF0mw6tanJuAUsIzxGgtUke0s9EHpWKYUMqFhRps49X3Id/lt1
         2c0JQTBCGenDjscwAfyBSOT3ngD2AO7AlSQH7ruq8WJBnk4FZAG4y4CdW23pNUQoVUp/
         6q4VS/OrIPfjlRo/x8siiEbescHj6N+SsaEcoYM1vZr7o0u0BDOOnV/g6NxFPIoPcOi1
         g5Rw==
X-Gm-Message-State: APjAAAUkzQuQHab2GeebXeT6VSE6aSUM6L2xuyLaLuq2kHabuBRFpUj1
        sZeDBKzq7/YObw05aE+WSfxHNAOGdGvSV1l7tiNMgQ==
X-Google-Smtp-Source: APXvYqyqbRuGkPj6OFmTuU8uJfNfEhKPx31JWIHMJC5OyWZR2rX71kcR+MpjiiB/VDo1Vs2o0KX7/TgFKT9IULwE0Uk=
X-Received: by 2002:a19:ef05:: with SMTP id n5mr8799713lfh.192.1568990386202;
 Fri, 20 Sep 2019 07:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190919214819.198419517@linuxfoundation.org>
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Sep 2019 20:09:35 +0530
Message-ID: <CA+G9fYvk=2Akfp1Xj=Xk6Q4UykQLQQVh5+Gv3TOwA0NiP-RgEw@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/124] 5.2.17-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Sep 2019 at 03:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 690411952b3d8cab079b16af04292f93643bb864
git describe: v5.2.16-125-g690411952b3d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.16-125-g690411952b3d


No regressions (compared to build v5.2.16)


No fixes (compared to build v5.2.16)

Ran 22493 total tests in the following environments and test suites.

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

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
