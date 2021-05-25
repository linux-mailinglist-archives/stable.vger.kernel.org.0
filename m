Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF56390478
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEYPDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 11:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhEYPDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 11:03:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C276BC061756
        for <stable@vger.kernel.org>; Tue, 25 May 2021 08:01:49 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p24so46597201ejb.1
        for <stable@vger.kernel.org>; Tue, 25 May 2021 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ejdQ+/X8ls0MZMwwzEkM8mDBazIQOo8TlCXU8rFok+g=;
        b=rGWL7ApXB1MQnwJFWaNNJkTTK0kcwaeV2N3ka/WaaAq/vJu8IRNwoNZw5iGYXN8yLr
         VhofZ22mcoRU0QzLOuH62T0aVj5f/YOFo7AUPQLEFpquSUtDU1G1icAXuQq7wfxZCk+L
         h6vDlrvagB9egNkZwIHmjwuf/Y0g71i91vbehunAu505TYupPRaqAPRFk5r+GaB9FrFx
         Wr5kwncHp1db3OfPlrOrxVqtS9KSXtltOKZ4NRT/x/i5INYnnilt24aJuH70JjuR/k75
         hZmRf+1Oi3EhpRBb0bwQPxO5RWaCgmx9RSQ329oU8IjmTnYg95ur1RV/LOQVhO4fh/M/
         xLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ejdQ+/X8ls0MZMwwzEkM8mDBazIQOo8TlCXU8rFok+g=;
        b=YqZSn+7y2BgZihC0GkH1Wv0EyGhsCWmfOc+O+rxF40C9jxBTlAeoLTL5dbd3YrnqBm
         FotWyfq6RZFD4+PezU4/NVo7PgUec86jfiFnu8/Qluorl7eE+UZYFI56lG5zOwBb6p3C
         bfeTVBIm0GEpxL7F12124TUMndxakj/o8TNc2TJz0QB8jy87BchttQj4O0QUp/rzqzD+
         hMX0ovoYFNEE6CvCkYpWzOE9ZSXyO6ZYR7FNuDlB9oc1Xg7chiTArEXZPKyXtkU+0nS9
         Flb6pGGscltY1Cow3LCc/2+HWeEpgIMpfLVcx5xNO0AfQUlEc90qvmGqjvwwfkgyZkBB
         z8bQ==
X-Gm-Message-State: AOAM531BDjjvNdFy0K4bBCnRf2wN8bvPa2J6I04DkkzOLmehnw4gCiw7
        X/r5S0QCCftnxfmG3VbwZtnaZ7aG+34+qtePiEdywA==
X-Google-Smtp-Source: ABdhPJxGmy+HEiU0o8Dvu66PZodZAr6CMWGAE5HJxH3NjdGAm3srPxRF7imY56ydJfJswpdvy0n2liLW4qycg+ndks8=
X-Received: by 2002:a17:907:7355:: with SMTP id dq21mr29001007ejc.503.1621954908207;
 Tue, 25 May 2021 08:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152322.919918360@linuxfoundation.org>
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 20:31:36 +0530
Message-ID: <CA+G9fYuw9wcLt+1VqHLxfUSCEGDj2hiJ-Zu-KoBMiq79K-eDhg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/31] 4.4.270-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 May 2021 at 21:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.270 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.270-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.270-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: c86cdd4a598cef76d2ae9bff5bdcf6adcb605df5
* git describe: v4.4.269-32-gc86cdd4a598c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
69-32-gc86cdd4a598c

## No regressions (compared to v4.4.268-187-g9d2abc11d0b5)

## No fixes (compared to v4.4.268-187-g9d2abc11d0b5)

## Test result summary
 total: 40552, pass: 32443, fail: 719, skip: 6652, xfail: 738,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
