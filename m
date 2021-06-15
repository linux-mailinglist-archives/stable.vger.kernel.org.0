Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F7F3A7BAF
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 12:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFOKZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 06:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhFOKZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 06:25:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FFDC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 03:23:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id my49so21708690ejc.7
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 03:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=usz2c56Y/wB4bto+kslcF/GgjVmyI3SGKASmM8Xx/Io=;
        b=wKGjX10p4qWqmLfJrTedvaRtB3EcWZp4IdTTIkXH4UzqSLnbltG6BZXyTil5tjlhpb
         vyvp0DRluxgeXMX5gELdjlISIgbTKz1H/1fScucOZlDBx3zFYSR9bKhHjA+59Em2pE9Y
         7jrI9OJaFqLv+w/8xmDNjPnyH3fsNt30T7hpoP8P9JvzJO6ZgQuG6aSBp908zYbwYuTk
         6QxmnozOCm32pIpMTgUAjep4MY2on78HRyaR1Cw+WYrRNLTK1CtvQcqtOtR+6BoBNUX/
         AnaeujsCCZ4v6IwTW5e1ACsLKvD/mPQew3Qb/vFXqdjZ6TexILk2mRHtlGh0TXziHNR5
         5y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=usz2c56Y/wB4bto+kslcF/GgjVmyI3SGKASmM8Xx/Io=;
        b=ipAyihiKs4ESTpvAfLeJySds5VU6JW/Y5Wd3kiijshNHrActeM4h27DWeGYpWAPkh3
         BkjM4kVOgI0MtpXj442mzGQCnFDElhwmQgE8JW0AkNS/DkJ25ldnxF8DwXZYjfB+h8Ya
         8DyIJTYJJW8tHo9JtQz9AP8HOGcGicqrfA2Q+iZVHkiiKNNAPNpGUjuPCjJfhdZ01GLH
         zf6o4EmOEqYk0mAxPIiMdt0QgQ5j4bP4U0QxtDh9qXgfwEz5AYHw0eejJcDJSd86gcrl
         hLC/N67ekleAn8N3kxElVe2uZLpEa0gdZwe2G48fGT6Enm0kXydVV1YBf6Sbl2udilEj
         dZ0g==
X-Gm-Message-State: AOAM532VmR7QGESYpsYO6wRoasjUkEVSOXKCIsHexQ6QBxp3X3pzXVeP
        V2JTKytAo7LJW1D1H+w2+lIUbc0q97n9nwXlyIIT+g==
X-Google-Smtp-Source: ABdhPJwuEB5SRBpNyjYskEwIC0fbNuMsMHmMWxrm2CG6Yui6DJrC1tjFcmy1pw3YxaPdVHy418atg5mYogyCj3asMEM=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr19581971ejb.170.1623752597414;
 Tue, 15 Jun 2021 03:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102641.582612289@linuxfoundation.org>
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 15:53:06 +0530
Message-ID: <CA+G9fYvsE8eAZ43c+K51=UvoERh6pZh6nf=wG1XyYnp8PAgg2Q@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/34] 4.4.273-rc1 review
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

On Mon, 14 Jun 2021 at 15:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.273 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.273-rc1.gz
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
* kernel: 4.4.273-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: c652289a55a0a8cf744f33b45528413e6adaf0cf
* git describe: v4.4.272-35-gc652289a55a0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
72-35-gc652289a55a0

## No regressions (compared to v4.4.272)


## No fixes (compared to v4.4.272)

## Test result summary
 total: 36565, pass: 29186, fail: 372, skip: 6230, xfail: 777,

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
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
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
* kselftest-x86
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
