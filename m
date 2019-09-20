Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9DFB934F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393018AbfITOls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:41:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44367 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393014AbfITOls (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:41:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so7280127ljj.11
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/xQU0I14POU1160/0iVOcIzVuskH7tOT6JeJXF9wHh8=;
        b=iLzcF1bC+A7Ay72n5F4STM04JWspeI8LAlSp0+5y3xx/ASpzrb9u/YBy2T86K+MLTp
         w4hUfC5jOkS/jvGhpe1DMoJT1Hz3IEiFLd4E0wP0+pqXvEyqICe5JCZeDYq3FahFeq24
         qQLIC5Jx/ms6y6IBysPIPL7e/HyaA0+dBjdVi45EdkaRbNCJGvhUeFuaYVdp3tXK/PhT
         MdFfrAUHcQ3parxYJmUYxmuBk7/KeuVp4P5pQ5BXAncruBnaAi03s3VTKQhF/nxe16T2
         JcLs0+SeZtEkdvkkTK1ud++wWdqcowUypVKoNEIM87Ms8byShC81wwJm7OqPapTHvUpP
         A7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/xQU0I14POU1160/0iVOcIzVuskH7tOT6JeJXF9wHh8=;
        b=djn4xZ9wGb3KTKZErNWqIxAiGSeEg+tCdbSlyOj3Ht9hHdMM3gtf08QUOX68/wjm6W
         DAWsRQAUh8YPMDLuvBqyu6nFHMvu3IMdGcOUz/2sTOD/Yr088K6n9qU03yHqXRcET/9w
         +zvSqO6l46kkVq131JRd8cWrmpgvJ+HYjN4xiA+7jfXKBvV85zx5kDpB+1Q6vdyl7fvO
         6bpxtCCHAZ9U3t6VEh8q/781uYxdqq0zV929UZ3F4iglovbbaxE2afTM4muxRMAMHCNN
         q4CyMbC/H3ak7btLWnuN1Sy+bPVt7vvCQwHxakeX1ZqHySd1ZUXCgNm8rYxbXGQ4ZtWY
         iEYw==
X-Gm-Message-State: APjAAAWstYCicFQ6rLqWiEEh/GA+ahsqvAFsu55PMnGrdg8V0kEmgKWw
        +nzan8azSxEglBXAw7nUi+2T2P23uZ6y3y3TbPtzvQ==
X-Google-Smtp-Source: APXvYqzrR41AiPf2yHALsv/Q9ZxssKyD6wNwc2On4OM6CIP/fvhDUmcGj68P8ub2ZY03APCL5lGodtepOml2+YY7Wgo=
X-Received: by 2002:a2e:94cd:: with SMTP id r13mr9418176ljh.24.1568990506087;
 Fri, 20 Sep 2019 07:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190919214657.842130855@linuxfoundation.org>
In-Reply-To: <20190919214657.842130855@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Sep 2019 20:11:35 +0530
Message-ID: <CA+G9fYtPMOK8WzhpQTMBZTtz3T9Hzf2aOusFDJF0cr0bKKo6cA@mail.gmail.com>
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
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
> This is the start of the stable review cycle for the 5.3.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.0
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t
git branch: master
git commit: 574cc4539762561d96b456dbc0544d8898bd4c6e
git describe: v5.3-10169-g574cc4539762
Test details: https://qa-reports.linaro.org/lkft/linux-mainline-oe/build/v5=
.3-10169-g574cc4539762


No regressions (compared to build v5.3-3662-g04cbfba62085)


No fixes (compared to build v5.3-3662-g04cbfba62085)

Ran 19661 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* perf
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
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
