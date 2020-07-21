Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5309227C74
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgGUKFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 06:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgGUKFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 06:05:02 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A80FC061794
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 03:05:02 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id d198so10075294vsc.1
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 03:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DZxYe5F17/UOWPF6juw9B6bodvCKqZ8eb70Nj76RBOQ=;
        b=Z+OWQYN4GeYyvQh2sT0ZPpBL9rs3ALi2SinMwePZUJrslKEg126Nubmsq0pckNPJkJ
         G901hFrBh18W50WAQ7wbTkPUEskaxzXdqqitYbYHmwllRmm9wWjGDvhr4SxXZ31A2VNG
         qXOJN0rKkrBwgpSSOnDqd+O9+kmIyAN/u6OYMkFM7HVc3+HgDusMcExpuGsvjHTeNkGm
         FTMOrkkIIlmE7kC4X1D/BUxpUNlN8GS44fR8avHN4UlAzWr+yAxjna7vHvirKEwdF8CE
         koEZivgJ0FhTM85zgQag+BWr+LQG2YYNEZlX9W1oXGDj8PA6WAtOF4VZzj1fKVyxgn7q
         jYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DZxYe5F17/UOWPF6juw9B6bodvCKqZ8eb70Nj76RBOQ=;
        b=J+aVYRH2+iFfj4P6FkEcvl1IunWMeBhVEzRjJypjJvmDi+0rbcK7hbZaNOWmW9b6cd
         dSJL4HCbh6OU2ID4VRUJoWjPVQJiWfa7DQ6hPRWCCt5+ciNiS9qNR/+fl/sGD/NzX1vx
         FDAHaQ0E5w06yyktNcAAI3ijRe56yEMs+XFENJQbWyNxaSClR0Vv7oyIyOU4habCYrzS
         axbdV3+hc/d417P1FMXoEM1yyb+IFnTFqht2jiWTFU3sQXjmPlAWEy5VcHs/KIvvw14u
         8hS91tW0k4cLkAj5o+ME3JKKpx1zHfSa9W4ZSAROUKWLJqlfVzIU77kWSELptB2XZQcn
         dqTw==
X-Gm-Message-State: AOAM532q4PWbSwaC2VRdmEn/861x2tj9PqpLp5LavO/vAnu5OHtvDR/e
        Jst+9Vh3clv2UxowR8jaexnTbJpF4i6KRTQyCCR7Kw==
X-Google-Smtp-Source: ABdhPJx9BMPVcvTz2IGb981toraC3zQUry/Y/3hz9GX+NHDG8dzhVtgCtqeX3yjz6NdF+BoO/CeZXYPkUsG1ECTkRgg=
X-Received: by 2002:a05:6102:14d:: with SMTP id a13mr19344739vsr.142.1595325901421;
 Tue, 21 Jul 2020 03:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200720152820.122442056@linuxfoundation.org>
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jul 2020 15:34:49 +0530
Message-ID: <CA+G9fYt_HQbAVT8obg59CkOTpHh=gYyQdjcx8PeMdo2Ba-A+Dw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/215] 5.4.53-rc1 review
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

On Mon, 20 Jul 2020 at 21:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.53 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on arm and arm64 (Juno-r2)

perf test cases failed
  perf:
    * perf_record_test
    * perf_report_test
    * Track-with-sched_switch (ignore intermittent failure)

Bad case:
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf-lava-test.data ]

when it was pass it prints number of samples like below,
Good case:
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.004 MB perf-lava-test.data (46 samples)=
 ]

steps to reproduce:
# perf record -e cycles -o perf-lava-test.data ls -a  2>&1 | tee perf-recor=
d.log

Link to full test:
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.52-216=
-g95f1079149bd/testrun/2969631/suite/perf/test/perf_record_test/log

test case:
https://github.com/Linaro/test-definitions/blob/master/automated/linux/perf=
/perf.sh

Summary
------------------------------------------------------------------------

kernel: 5.4.53-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 95f1079149bd5596df492ff3dd12dacdd264e0ea
git describe: v5.4.52-216-g95f1079149bd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.52-216-g95f1079149bd

Regressions (compared to build v5.4.52)
------------------------------------------------------------------------
  perf:
    * perf_record_test
    * perf_report_test
    * Track-with-sched_switch (ignore intermittent failure)

No fixes (compared to build v5.4.52)

Ran 36089 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
