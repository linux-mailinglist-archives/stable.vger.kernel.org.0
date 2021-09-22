Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99F7414291
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhIVHYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 03:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbhIVHYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 03:24:16 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9545BC061756
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:22:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id o59-20020a9d2241000000b0054745f28c69so177610ota.13
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lzll4cRNXDRFDbAupcKPyXGfLya7s2LN80MzbRtzcvA=;
        b=GEPq1+GbvkAj87ol54KJcAuhTLKzNilrla9Tie9i0bxfYothUY0d6wHX5io3y/G2Ap
         y9e8D9g3IRWAXlBYMN3ACOOWH0IsNoGSmdkv0Cyc8MAQhWCcxqIvG+DUytuNv4MYQ4Lv
         I/Yb/2qreQoizQ0bNSj4XuJGWauqTMi/rKxAYc0g0lbtYEzRZOnF8vZy7xf6MSdh3IyE
         fSycZGmVt3v3tF9U0MxFq6II88rXPrN5qjsdvF28xzr/+ks5t6M/muQcSXNIBzEU2eyy
         apgCdpkHdT6UyUlw/uynGigp6+FjKxqAK8ahBRQO1DuzaQvBo3pqhtjQSltz57Fe1I2+
         HDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lzll4cRNXDRFDbAupcKPyXGfLya7s2LN80MzbRtzcvA=;
        b=j30UwljXIOdOAdXEbKDCAsqgVQzUB0vi5wSbCebo4Cj89q5eBG9K4tlQymmNVg3ulG
         IB6ARhsHv9XRp44+Q7lRj9Lpadz1y6KALHTL4DsRj0JK/nWBal3G6+HI6ekvVJDmad3H
         svr+8ncVT+eZIZin/VrCypYa/cuDsmPCv7r3XPP5qxolexOTnjA38A00UDZ401cBfq5V
         RSYhlgn+IhiUf3707MJXIp7DDDkSUIHuUkW4DuIJyaQH6IUFLaLEZlkhEWdERE41DDXg
         dBuRnx2vUwgV/YaAtsXsUHRSdmMmNM1QjDF4SUeICppLq3wThq8pVUyV3TURGa/MfO11
         wedQ==
X-Gm-Message-State: AOAM530KVl15Owk1X0XAm0DZ9OEuXFpeby0oMPw3MqCTzh0gluBRm8wN
        1CLKK0i95sXsY/F8AEnk4+YnpD5QJI+VzDEuOMHang==
X-Google-Smtp-Source: ABdhPJycENrYjMW1kmQbh3OEqt25riUEbWQgpMqWMmCfo3BaZtCFScSc6WDvELmJarOLj5329TX8wbZwJwRLN+fqui0=
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr29961398otj.208.1632295365782;
 Wed, 22 Sep 2021 00:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163912.603434365@linuxfoundation.org>
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 12:52:34 +0530
Message-ID: <CA+G9fYv7g=n-hJq0OnyRekSB3vQGyauJHRpDOdG_avxxdPWzrA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/133] 4.4.284-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sept 2021 at 22:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.284 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.284-rc1.gz
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
* kernel: 4.4.284-rc1
* git: https://gitlab.com/Linaro/lkft/users/daniel.diaz/linux
* git branch: linux-4.4.y
* git commit: 3e654ce9098d7e6341862e3a72035ac2208c6abc
* git describe: v4.4.283-134-g3e654ce9098d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
83-134-g3e654ce9098d

## No regressions (compared to v4.4.283-127-g3fa85dfc6cd8)

## No fixes (compared to v4.4.283-127-g3fa85dfc6cd8)

## Test result summary
total: 40455, pass: 32170, fail: 181, skip: 7098, xfail: 1006

## Build Summary
* arm: 128 total, 128 passed, 0 failed
* arm64: 33 total, 33 passed, 0 failed
* i386: 17 total, 17 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 17 total, 17 passed, 0 failed

## Test suites summary
* [
* fwts
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
