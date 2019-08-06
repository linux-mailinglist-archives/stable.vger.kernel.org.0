Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628D182B86
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 08:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfHFGSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 02:18:03 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46609 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbfHFGSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 02:18:03 -0400
Received: by mail-lf1-f67.google.com with SMTP id z15so55762568lfh.13
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 23:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EEmlxWyQzOJj//2lGwGhq4m0Emv9Oy8LIbvfdstw+p8=;
        b=GM3YVbNL40k1iQvFtDnzwiZWHa5lbQlXOusvVb2Ac8zfGfrp2SFOJg1DyAWisl7dDO
         LNL4pjhHmyENltx8G025dSEszr5qtOsYCjVi+B07SYjwyTmuR7hmAHWyQrdxC7CSdhG1
         LgsxiPhG8WvXtwVL0E4ma7WFk/iCOnPQYCubq8vUAxzEwYjhJIK2fbZoB+Nh3EygcHaI
         bI1JOLop4yZCdZe4JNrXZ9ZNUlNVQn6cqLqPtxDN9wdxETat9kerg8RcRzNgE04NpArk
         mtwG5rgdJ1nPfa7tkCDmuolZnZiljwjYMh8SuEF5Oiz+38SxKwKF1gdj87UdsmAckSbE
         V5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EEmlxWyQzOJj//2lGwGhq4m0Emv9Oy8LIbvfdstw+p8=;
        b=jVjsbwOffKGyd9T55tJCFDYOuVbGRVCpS1maSylM2L7qj5dM2ub38oYlgyfXeUlSgV
         tbA4rkkazdnI+/MfFHke6KYr9SLqHD8tHlh1HR9AlC8zyzK14n/SpztazkLlyvVzRNoA
         WtRf3zlHynf2tq+EAF3TAnrEGFSC5fgkFUVFpR5OXOpbUFSY9cw4IbSCV/A9ADSaEFtF
         u1MOEMX1T7WzxmcPqNPDF2+nHYwxfq4lvtCAbNTiHlUz+8oNmkLXdAqyeDLfq+i5eXGM
         GseC8g+aMPOxOMbzyMw+Xy8N+sMhQVNNhmtPuySlZh6OUt4iMDaEUp0Nd7HR0sA5NsSq
         STuA==
X-Gm-Message-State: APjAAAXtSW3QZP5yQVl6qKK1bIopnjPI6pqm+qKBMxq3H91hLogo9coB
        XWYqh1dKXksnKklMLfGoXjRM2d+AcNtAbzUFcXTHQQ==
X-Google-Smtp-Source: APXvYqzfrsziaXa5Sk8jlxmm++BZd7kV1wMBQLi46wsoFMvoIfNgtOx8FvX3zgAnCzVsCzQVsDzw4q2OkIamSBkHdog=
X-Received: by 2002:a19:750b:: with SMTP id y11mr1034625lfe.99.1565072280952;
 Mon, 05 Aug 2019 23:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124951.453337465@linuxfoundation.org>
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Aug 2019 11:47:49 +0530
Message-ID: <CA+G9fYsbLHkmg8en+WJ00pO-TO+z7ZQXprNP4CAc+_cgC_koGA@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/131] 5.2.7-stable review
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

On Mon, 5 Aug 2019 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.7 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.7-rc1.gz
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

kernel: 5.2.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 22499a2919399df3cd619a46afd6a90a731892f0
git describe: v5.2.6-132-g22499a291939
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.6-132-g22499a291939


No regressions (compared to build v5.2.6)

No fixes (compared to build v5.2.6)


Ran 24113 total tests in the following environments and test suites.

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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
