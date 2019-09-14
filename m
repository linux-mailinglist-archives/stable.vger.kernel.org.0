Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12C9B29D9
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 06:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfINE24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 00:28:56 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33131 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfINE2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 00:28:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id a22so28964704ljd.0
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 21:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6fqgx63VOqDYCNdvOw0tw59tN2HQTbk3mErF+HxzwU8=;
        b=VpuTZYFJzG6MbOAORz/s1yxi3NnDLYSris0eK+rofPmTPPQTg52hT/M6oE7ZIMOlNO
         H8w5rT0DPq5FftFCrFjvYiWUbDfV4jDqvGY0NMh3ow9zk2q75tYVpioUdf/YNta+Q1d4
         p6ka+Ieop3hDxjqB9RrTuhGO03FpD/7Oy2SqIK/r78Xi6cinUNpZK1lmrPbS0SWl/JJa
         TXkNsn5Jt1dB8q+YYwRJNDINOdlmZUFwqFbQrfrmCW6tGRhPHZg0Wy44kl34mjRtUiJQ
         2CnvD1m8X6FSdh8mqGd79+A/Px8ikpMr0xNRTIu1xW6f2E/rGEwQVKtSwYnY2vzVCywc
         RoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6fqgx63VOqDYCNdvOw0tw59tN2HQTbk3mErF+HxzwU8=;
        b=Fa4msLBgjh6BBIkrhSznr1X9Bo6RgAjJqb6yJqND/02s8sbE+EMO8tAJ8BbNfDPU0i
         5D5gk2kIyMPqBAN3OxePzcnt2sjanIWHFU0pBQXDQrqocHjkGk/nuS5oFA4s84NNPo6b
         WAEW98hPgl0Op+DpMu018+NIf9FINZJCXuZizZ8wOhxXuC5dsxV19ygc3iVmvpxC0/8k
         +geAF1FbgpRsr7AIy6Sop2kJznyl9Iu89xGPjSHHalPRkdQfqy+S4WwH3bSVHFPO2JDU
         mRQ/5jWb/6i5JGIoGLjCHa+pie2T4CfOSuqxF3ioQbcFjl/c5tCy0kwxtdrAl9ZsPlVd
         swVw==
X-Gm-Message-State: APjAAAWt86uyodL9RKoNP/f/XfVI9tf0fIvmATQ65EjpSIkDEvr6lw5O
        kXfafTNNIluz5Ld/rDuj0fPeKmzIU4inMjlPn/eJxA==
X-Google-Smtp-Source: APXvYqxrtkzpc4NinDTqSSBWPcIIn2YwZLFpA9GSCrkT+j3zh43YT4NaLVb72vbrHk+mkhdKQvQOCRNnuCHCw2oZFpQ=
X-Received: by 2002:a2e:a17a:: with SMTP id u26mr31856397ljl.137.1568435333893;
 Fri, 13 Sep 2019 21:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130424.160808669@linuxfoundation.org>
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Sep 2019 00:28:42 -0400
Message-ID: <CA+G9fYsj_eTiMSmj-Dsw16hOG9o7DHDbkwuo8V-AToAj1=2_zA@mail.gmail.com>
Subject: Re: [PATCH 4.4 0/9] 4.4.193-stable review
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

On Fri, 13 Sep 2019 at 09:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.193 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.193-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.193-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 0a1ee44c69166b2750a62fdb079320a396dff30c
git describe: v4.4.192-10-g0a1ee44c6916
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.192-10-g0a1ee44c6916


No regressions (compared to build v4.4.192)

No fixes (compared to build v4.4.192)

Ran 20018 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-pty-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.193-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.193-rc1-hikey-20190913-557
git commit: e289b20abbc0882c0710519376b654c0df71b784
git describe: 4.4.193-rc1-hikey-20190913-557
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.193-rc1-hikey-20190913-557


No regressions (compared to build 4.4.193-rc1-hikey-20190913-556)


No fixes (compared to build 4.4.193-rc1-hikey-20190913-556)

Ran 1536 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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

--=20
Linaro LKFT
https://lkft.linaro.org
