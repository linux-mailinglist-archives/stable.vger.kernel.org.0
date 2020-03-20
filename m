Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0EF18C7A3
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 07:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgCTGqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 02:46:25 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46851 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgCTGqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 02:46:24 -0400
Received: by mail-lj1-f196.google.com with SMTP id d23so5179921ljg.13
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 23:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mPcdBOc2e7QemTON3231cBaF7A2u4c4EVPB/7RmcEYE=;
        b=lidyN2vQfWlC9sdLeeICXwLS713yjLv+CvybuJQDAp9Zhw/mkZ+sFywenXbJQ7yze6
         smb4pU0ioEzy3TaYxg1xIm5HVKCOsRcbUCZnr87BSs1IzfYByb9LFjE5GkGTQTJJaoc0
         LXu4dlLLopvx/tZRS2vTbgmbGO5VugTopYeejuzMvVWdySNvMPcnX+c7dgzd6pfgev1g
         Uw1+jfEQH5FRl9XA5cocz+7i2tYhklEZ6EVbwpHY8qMCdED5cJcKiqyAtKdNBv3X0x48
         JC1e2J+n7SwRJPIbPHxE4vMVUOU5VV0ArrjsIzFtE6KDgwmSqp+6Axs9xgQLxaC+mV9L
         D4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mPcdBOc2e7QemTON3231cBaF7A2u4c4EVPB/7RmcEYE=;
        b=my0z4aELQPcPJrjmZPXXz12z0rsIL2O74N+5MuPVYfCNyz/g3SQ0yJVbHms0bqTUEM
         h5zBqiJ5MjMrsZryCpzIUfdl6M4J2IN9cBBb6/lOXkpXMxVA60K8vAIF5pPx6MlDsV1A
         U/O3C9RiqNv/lV8kF5LorX/9WQz9AEGdvXj52tg/pAIbY21bvLAp4tFCCB8BxQhy+k4S
         smIPL6JHbz1cumTwUlde+m6rDjGoaHlJ08RukZKfvZUjuG5RxQnD2CvlYOcVqVnfdyhN
         KDsNWruiut8RWvDP5etPQgUnhJP6f4axAkjoO+292vByaE67NxvfpJVpH/GusTag1nnF
         Z8tQ==
X-Gm-Message-State: ANhLgQ2CLWAcqeGXgDtkV5xsVjq4eY/cQG/Lgg6Ytmqymo5Sbs0Zcg1V
        6ENFf5m1ouGp65FVOcyob1trl9yBiTZM4mntMXM/Wg==
X-Google-Smtp-Source: ADFU+vsqpDlcqiWB9q7KKygyItU4Exl6qjK6jMFgelmsKNY/72LeqCgDirfwawAsH2k/PhKwtF75WuehnpoiQ2S9ty0=
X-Received: by 2002:a2e:9256:: with SMTP id v22mr4339595ljg.38.1584686782411;
 Thu, 19 Mar 2020 23:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200319150225.148464084@linuxfoundation.org>
In-Reply-To: <20200319150225.148464084@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Mar 2020 12:16:11 +0530
Message-ID: <CA+G9fYvOQ=oibqFZ=zffqj-c5mcjW2Bew2rVHg=FPs2mHxb_ug@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/64] 5.5.11-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Mar 2020 at 20:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.11 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Mar 2020 15:02:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
The arm64 dragonboard-410c and arm beagleboard x15 device running
stable rc 4.19.112-rc1, 5.4.27-rc1 and 5.5.11-rc2 kernel popping up
the following messages on console log continuously. [Ref]

[   15.737765] mmc1: unspecified timeout for CMD6 - use generic
[   16.754248] mmc1: unspecified timeout for CMD6 - use generic
[   16.842071] mmc1: unspecified timeout for CMD6 - use generic
...
[  977.126652] mmc1: unspecified timeout for CMD6 - use generic
[  985.449798] mmc1: unspecified timeout for CMD6 - use generic

Summary
------------------------------------------------------------------------

kernel: 5.5.11-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 0d188a9d230a850b4267cda97de8a26bda4a1399
git describe: v5.5.10-65-g0d188a9d230a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.10-65-g0d188a9d230a

No regressions (compared to build v5.5.9-217-g0d188a9d230a)

No fixes (compared to build v5.5.9-217-g0d188a9d230a)

Ran 24198 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- nxp-ls2088
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
* libgpiod
* linux-log-parser
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* kselftest
* network-basic-tests
* libhugetlbfs
* ltp-cve-tests
* ltp-dio-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none


ref:
https://lkft.validation.linaro.org/scheduler/job/1299759#L4052
https://lkft.validation.linaro.org/scheduler/job/1299760#L4017
https://lkft.validation.linaro.org/scheduler/job/1299762#L3992
https://lkft.validation.linaro.org/scheduler/job/1299762#L3993
https://lkft.validation.linaro.org/scheduler/job/1299763#L4006
https://lkft.validation.linaro.org/scheduler/job/1299764#L3982
https://lkft.validation.linaro.org/scheduler/job/1300003#L4398

--
Linaro LKFT
https://lkft.linaro.org
