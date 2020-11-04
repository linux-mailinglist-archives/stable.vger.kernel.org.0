Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB682A612F
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgKDKGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgKDKGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:06:51 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86DEC061A4A
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 02:06:50 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j24so28874689ejc.11
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 02:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3TaXtXs3xZiP56tEU01ifiqy3+is8ac1K/K3ycqOg/s=;
        b=QHWqh3ajJg6ht/+Vf1g7tm0KtRQJKXWUhj9EamxC8Yj9d52zYfGg6WtWjyJfXBAzkN
         59zlMIPDlK/zjoGUPe0Uid0tJY4YjQsL9Aq16p4WJeVKT+j4BsFUopoazcC3/fBsoJ5I
         /VCWPaxBFOHNlOi6G4KBstagoowRdcElEUt6k67bqtKJ47cLEBkvXHSKmjA14ehnuw4d
         RJguqSF6uke/lzFm5n5zCzCGKqJasqZYYKvCRuPjpCq/aVG6jgOKRsN8NPQ5Cq6ftW9e
         5t+hYXf1SLA56Ci+PQ0/HxUiOkmzDS2NlEi93krTg4O8oj2AApnI219wpqnnZw7BM8D/
         q3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3TaXtXs3xZiP56tEU01ifiqy3+is8ac1K/K3ycqOg/s=;
        b=WaKx0PMghqG8HXrEX9ThxGGle9ZquCp3fsgQITq+nKLrmz6LeIZS05EiGzUHT1D5k8
         XsaFoO0p+FXpLARa4atfY+MU7nDI812D/1dagkQY25uT7YpGunXtuxZd9em+8hz+/jUr
         PIgU4Ox1MU7xDWi2InFneKGQlPYCY9SxNTE6NQ345M1QMsejVG5SaUJ7X8Tsz7U88XcV
         gaTUo6HzDT9772YPAYNPcea/PJPkEkWU74WiS0utffv/6VrnewGrgetrp3MM7BCe2wjc
         CWYFbS6shK+XXWwQ65Gk/MrgP/ZwKlPOUg4CHcCEzGhZIAVA82nMPciW7dAT1nIapeaH
         Zg4A==
X-Gm-Message-State: AOAM530Q1yKTUerkP+x8n2Cz5mbM536Gj4WW4i4NNLzAVgRB/nEsakeM
        w7gHxTM/ehfxAuV1oWeR6iiWQSAZO2L7Z3IZrV/y2Q==
X-Google-Smtp-Source: ABdhPJxPoMES71jQZ6OqHxJNlK05yFiYsV3+2PFb8Vc0qvP6AnDYzz6onuSfPWIN7aeugK90GcvNzhc6cPC3G82ZHXw=
X-Received: by 2002:a17:906:39ce:: with SMTP id i14mr25129695eje.170.1604484409335;
 Wed, 04 Nov 2020 02:06:49 -0800 (PST)
MIME-Version: 1.0
References: <20201103203249.448706377@linuxfoundation.org>
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Nov 2020 15:36:38 +0530
Message-ID: <CA+G9fYs_LAk-vXYHeNxWGMHPYVi4DH=oZyJTcC=ioDNUR-C+4w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/214] 5.4.75-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Nov 2020 at 02:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.75 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.75-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.75-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 1b513bf286096f9c66fc386cdc5e038980db8863
git describe: v5.4.74-215-g1b513bf28609
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.74-215-g1b513bf28609

No regressions (compared to build v5.4.74)

No fixes (compared to build v5.4.74)

Ran 37086 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- nxp-ls2088-kasan
- qemu-arm64-kasan
- qemu-x86_64-kasan
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
