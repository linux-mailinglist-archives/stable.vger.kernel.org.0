Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70366301372
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 06:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbhAWF6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 00:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWF6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 00:58:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56913C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 21:58:07 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g12so10726984ejf.8
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 21:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1DRHwewnrHRhl2lTMgBYeG2ca3eHenJpXDrlJ4uCygE=;
        b=ajxyEalxfr67m7gO/vv1gh8bsVk5fDqZohI8cFqpSD54xQ5coLDgigZ+vMla4mdV39
         sh81EDmtWCnoaOjnzk4XAGfNcgeW8sr0q+J58RGiwtQmVD+qeFXYgAzLPaa83t2JYO03
         qEhMJTSpZ15gOQIi+eGG5yzHVThODbyAx7NbmLMcvCAILt2aAD6w0NzN6SOy9YfhLq7z
         8uB7j2/feMDrIFdRZAleVyZm5ZrwjRcSOtjPQ265dCjIm9Isms4Umkf/7OLWxTvrS3eU
         n3LVw3g46AAQqUGH2s7+gjXpWaFqidD5MFC6W9C5VNZECFjonTEa0SEMfhotPW5ln2Fh
         HfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1DRHwewnrHRhl2lTMgBYeG2ca3eHenJpXDrlJ4uCygE=;
        b=oxH/SFi47t5vTKHiynuLMFzFyaQwOg5u9xi/SuACJNXpBUgCUs/G4ix4hSPQ+TE+fl
         dpAkuSIiMWu5FICN8CwarmyKFCDkRO3PwLgNql3/XYr+D8BbJFqZ3QJxFcKmaQFj3Lyr
         EvZ2A3GxznP6N6FPJkb8M4As9eDimV5ZJ+KZgblMtjQUAAeoqDAZQHL4o4zjevRRmAcO
         8T5l914WfZZY7Yl3Iyo2Bl8VQSCs2kD6g9f9u7hqwvSXucsENoJRXkmMxjNlU6OEgM+5
         D+yDJN4JPW3+PCh5YHcv9JcZeovyqjyj6GbLucFA0B1WbqDBmnIa/69g3uwfsa0vPyDx
         7A2w==
X-Gm-Message-State: AOAM532pZSpn0x5Jbgo+anc6dVim78M85X4fubKB3QRoeS2OonDatcHq
        XGMqHMiaEobiy9T2mhnRMtFJ2w11DHrKoFd31S4o8A==
X-Google-Smtp-Source: ABdhPJxB8GYrzCyR0qFlfQfw+LoLPdvUX377pLWuE6GmrEm5pKqcSgKJp8qNV+WwyjqVwurocX7tOpVUmHOPEMndm5Y=
X-Received: by 2002:a17:906:4443:: with SMTP id i3mr4922157ejp.133.1611381485916;
 Fri, 22 Jan 2021 21:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20210122135733.565501039@linuxfoundation.org>
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 11:27:54 +0530
Message-ID: <CA+G9fYtr3QveGHTdx9qrLS6W=AfF+vU_nxuE-SnChued5ruWbQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/33] 5.4.92-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 at 19:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.92 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.92-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.92-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: eb6c2292de97c5c4e51d98767b4c7acaef0522ec
git describe: v5.4.91-34-geb6c2292de97
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.91-34-geb6c2292de97


No regressions (compared to build v5.4.91)


No fixes (compared to build v5.4.91)

Ran 53090 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
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
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* fwts
* kvm-unit-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-open-posix-tests
* ltp-sched-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
