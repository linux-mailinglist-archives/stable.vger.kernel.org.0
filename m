Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2733D677BA
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 05:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGMDD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 23:03:28 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46817 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfGMDD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 23:03:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id z15so3375482lfh.13
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 20:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TMNtLMJniKZIF2vD1cj/K0N1QXHSi3Kt7aGchL21lQc=;
        b=MKMjk0KvezQL02z+t0dn2XHPHqvj3nTc8gAFgXXZVnv4iZWpki5xz1KZvji6IG6ZAB
         3D0/rk2RMUdC0zI8Hr18zflupTTYSHDJiRhw6dsmMdlIupnNiv7mSp3l4zPgBX6xo4ya
         3uh2GduWESo06qrxdGdtaF6AZc1DaIxZPHHF1nSxwS3gLVkq3PujucFfWa/BVAvjvbmw
         kH1MzXU8Sr5mMEYGAj5tet4kHYdZ8VRWoxBS8nn7s+AqT+snTx07KeaQXa62c6B9P66U
         5/iD+uyL+PRN9eVcr5wNVSj1UbjKgBHghUgdRhcX/Vd8c8qgjPQaSVzhtmZlDBhP57rl
         NJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TMNtLMJniKZIF2vD1cj/K0N1QXHSi3Kt7aGchL21lQc=;
        b=A2M+k0hN2a0DxrwvKIi/FrqaSGhGhJLIbEMXGvlzL2QO9qU3jKSQUR+muhSQIgnrQl
         wvRv7O27ZeX+DXKVf+9dehccIqNcp9VENptcdHT8SqYymciekTG2x2W1BFQaWwNk+8Ow
         6/dp/10jzLkHfvzEl8KlRzHJisNFmmTLP+/N9pXSHOAga/0NRo/xbUXrVmnmfvRXvK4X
         nEj9qoF/rbuF3wKwFzyky09GGVqX5LHWvAVQwWdsewRWjFBedI1rHtgvcBABwen1Ysr0
         gKeuuRV2iw3pUMlE2SCSP/TjxhCkCzJoJU6A6l0EGfPPWsN4ctnZh96UKF2nJcrBD8Vk
         xhOw==
X-Gm-Message-State: APjAAAUa2NCaY1W64gyLO2McPsiyfhSN6h1c+/kGmHrbzHo5dZUiCf4e
        tcU5Mrgd5aeAWBjLvSwx2WL3OWYzD5vXEDPJNLI7SA==
X-Google-Smtp-Source: APXvYqzWBZQJDNk/v9cOV8yqVxwjErJjm7ts6UZ9Osn55aIgGY2Pph54sIo6uAAHel4TkxDH+NlmvmZKW5lqzONOPkg=
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr5690500lfp.99.1562987005857;
 Fri, 12 Jul 2019 20:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190712121628.731888964@linuxfoundation.org>
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 13 Jul 2019 08:33:14 +0530
Message-ID: <CA+G9fYsyWA+cY=mEY4VjPh9D8P8CV6pua=s827Zrc4dRFscSMA@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
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

On Fri, 12 Jul 2019 at 17:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.18 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.18-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: de182b90f76d9beac11a216bcdbe52542014de24
git describe: v5.1.17-137-gde182b90f76d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.17-137-gde182b90f76d

No regressions (compared to build v5.1.17)

No fixes (compared to build v5.1.17)

Ran 22803 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
