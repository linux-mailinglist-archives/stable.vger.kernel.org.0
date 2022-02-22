Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019604BF5A4
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 11:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiBVKWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 05:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiBVKWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 05:22:45 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDD37F6F7
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:22:18 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id bt13so40029850ybb.2
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dOk3MW6B/NyVVBJL50jLGrFy/0FgLQ9TRGwL8yA7LU0=;
        b=METOVduD6uHu6BMO8sk2i7SCoqfdilltqQcI7QxNKXlT7nqp4bSWO4o4yWe2A8PVHx
         5iwwLgQDEOwTTP+CtKGZFQ34KaivpDdltSjDrteiibj9qw0nclmsWrTGu8BwayBySB69
         3yuLiV5rihRBCGZtr4WCpZRcG5y7W6xbj4cobUXtDfQhOqtw5RJudj7aXVaw/ti7lhw/
         ZsA4xhpIshbjKooh1jejWzJ86ZCAbTh9mxePPnkS0eGmDyOQuuf+iIqXQMM9i6zCBHaf
         5VdhpOGo3UdAqhZ2CDEgFvNLccUWuOzu5ajT+maNEgvQbTWbObZKCvOFqVJu4ZK1woH/
         8ZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dOk3MW6B/NyVVBJL50jLGrFy/0FgLQ9TRGwL8yA7LU0=;
        b=K0e6NdX88TbSxiYhIdncOSS/CP4/mIGl9/xy9mP3S6mW9Jyl6OrPWkgTK9x1p2Ligj
         wFI4tnGCzNk3P+S+LJidqYXBTQkqSffqd5ykLDu/cFjnRJIe0gP2Jq8mIxYUHDGvrkDc
         GV1fZqMy/HgYmS0giFvgZIcpA13VbTCkTm/AIFWTrp7jmJgbhmqtcdyriFRK5OS2+qDP
         aE+fpIl1IQSETMJiezdyflKjyEIT3sbhq/Y4EBUyisXMREIpFdcFWs+Wo8oTKQc/wCZY
         Gh+iKd49xEjYQ3kuAs7yQWSwbwyXzkOZMMeewzbdRweUT6GAxXrVTSSjW86880qOOZeB
         M6ZQ==
X-Gm-Message-State: AOAM531uP2CRkiwsmPBesS1oFqOlitzaYX3xhyNcJF/ZptK0DhIgiJvi
        sFekD0JluK1I2J/fqyXbIHPh/o8DcrepxLFXaSwN+A==
X-Google-Smtp-Source: ABdhPJzB7JI4/P47Q8uNd79mHnTr8BDnzB/ag9zVlrbSgxcpRkHYnHuDfRT0i2gmdQt6hG94EeaHHU3WUbM8H36y9KM=
X-Received: by 2002:a25:8c83:0:b0:621:8697:c27c with SMTP id
 m3-20020a258c83000000b006218697c27cmr22072849ybl.483.1645525337731; Tue, 22
 Feb 2022 02:22:17 -0800 (PST)
MIME-Version: 1.0
References: <20220221084908.568970525@linuxfoundation.org>
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 15:52:06 +0530
Message-ID: <CA+G9fYvSYEAdLODkuQi-F97pLZkJEiB-V7AqZHgMeYs1-gGbXw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Feb 2022 at 14:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.303-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.302
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: a09b2d8f61ea0e9ae735c400399b97966a9418d6
* git describe: v4.4.302
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.3=
02

## Test Regressions (compared to v4.4.299-114-g37c6a274092f)
No test regressions found.

## Metric Regressions (compared to v4.4.299-114-g37c6a274092f)
No metric regressions found.

## Test Fixes (compared to v4.4.299-114-g37c6a274092f)
No test fixes found.

## Metric Fixes (compared to v4.4.299-114-g37c6a274092f)
No metric fixes found.

## Test result summary
total: 56789, pass: 45632, fail: 280, skip: 9521, xfail: 1356

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

## Test suites summary
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
