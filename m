Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297AD30029
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 18:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfE3Q1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 12:27:16 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35049 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfE3Q1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 12:27:16 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so5535005lfg.2
        for <stable@vger.kernel.org>; Thu, 30 May 2019 09:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bcgcWgAyzI4wAMncBYoxjWmRoluq1i/e3trlgUy2IJ8=;
        b=RNktRFBlwcjGyYnbw3SlhETA+ckBoUlLX1aqAYKYzFAqR/LmYJVdb6zbRDztX4bVZR
         xMxFtfUJ958V/utMqciXOq/0nkU3VIRxmKanWKEeCYWO3TBn3TdwKy8x0BY3o/hPboZg
         Qaqc5tlvq0T0U2TU11Fdw+cKF6vucPHiZh0m9ESWfqrWc8ZV4pE4rIMo5yW/6ea96oHv
         ePSImUavQYJWKu9aib7UKT8uwW3xa4m2TKNbvcFsW/1I3CNkX2sF8LUUjGjkZP5qcsf+
         W5slPKsIzo+FHfwiSVn29OaLyqdUghysHthp0PK0y26OiUB+dcqKK1hKbp+72xa9GHAF
         kkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bcgcWgAyzI4wAMncBYoxjWmRoluq1i/e3trlgUy2IJ8=;
        b=YTkpv9dih962okXEbQT3rT+smTjQXO6/rEuTkcgdx2/eSyoWZczSO0UPtv1cV4LfYg
         6gdz8cJsCbJAQjhpMQD9DlhbdoQfKJKMSI5JW+0qBqLK9OhGAe8dNYlU6svSeEU4lUyw
         6aRIUhToF+BLgFRLI2lsS3u1FKIjicjlB78lXXyEygzCxHLcl22XpDRxhwqsYkDQVd13
         nk70SIblrz8MGk4/vBURM3IFT42xvUlX5/LiAmsBPIB8POkeQJ64MsiJOzIuK9PuZym3
         L2ZZ4ao9wGKtmRaluSrao+eXOhvPbAWJReNyOp4y5ESBBsgaYpMUuZ+Fhp9dq2GWsFaL
         0x+A==
X-Gm-Message-State: APjAAAX4SXiPv13rjSfxvDPP6gs/UUkYZ64JJLi0iCEzqmrHyv0oNV8Y
        n/g64tLg+h+KYBUtCRpuHfFim40pBmKvWPBTLecaug==
X-Google-Smtp-Source: APXvYqydY4ZuyQWHYbcBdwdAWkev+5Azw5+28aPegnVHkirUji7qVs1ZDH5C7jRMtA00wwMOi6t+7VP3lC8jhpm6vI0=
X-Received: by 2002:a19:488e:: with SMTP id v136mr2524437lfa.192.1559233634141;
 Thu, 30 May 2019 09:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030432.977908967@linuxfoundation.org>
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 30 May 2019 21:57:02 +0530
Message-ID: <CA+G9fYuZo54ui8A_Zy=N3kL5gyFbF9KwO2EYF417xU8FQwWb3Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/128] 4.9.180-stable review
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

On Thu, 30 May 2019 at 08:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.180 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 01 Jun 2019 03:02:06 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.180-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.180-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 545b59ea794cfbac3646ccfab4a34c9f7753621e
git describe: v4.9.179-129-g545b59ea794c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.179-129-g545b59ea794c

No regressions (compared to build v4.9.179)

No fixes (compared to build v4.9.179)

Ran 18444 total tests in the following environments and test suites.

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
* kselftest
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
* ltp-open-posix-tests
* network-basic-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
* prep-tmp-disk

--=20
Linaro LKFT
https://lkft.linaro.org
