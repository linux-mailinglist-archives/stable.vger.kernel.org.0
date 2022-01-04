Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4895483BB9
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 06:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiADFnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 00:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiADFnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 00:43:23 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA9FC061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 21:43:23 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id j83so86215208ybg.2
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 21:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vm6/Zt62JduFjSoyRThWnJ+HP0GA3YiirrJzHu9NgIk=;
        b=h1aTX21IVJCxzkvkd3itN1iM2p/6W+Y7H9fFmpoz6BLLRGRPJ2b4UPGp0BRhyc2/hB
         wThNUZAR7Dx5ek8x+S5uQHMoTKJt5vETRnva22aCZQCVOEaCPwNhRaAKlV2skpCl0d5d
         IPmnrKXl0MYiYHNH1eV57fgFMELg7GNjeViTrEgHYqwrlM/Yt4T1Db3MYdYgzS6yt2Bq
         aP6WZz7zSZESbXflAacm5z+XWV2BlexmSlpx7cRKRLbOWjAXqoPJ7c5V2CwzSuHlW+rz
         BCnwgEI9DrPRlZXgH+9PlAhQT86bKMqN0lZUyzu7EcUm7MqOxLVQYwOdvTiB9q9mQW+/
         w3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vm6/Zt62JduFjSoyRThWnJ+HP0GA3YiirrJzHu9NgIk=;
        b=LL0U+XGvKEexoYJ07AyZNrCRiBM1qTzcdZkGiHKLMKkeySJNwA+MCHrwiNUzOp1J0u
         Ssmm9gxs1tzRPGKGsPPAlKxWzm3S0jIB3j/NfFYMdAn9SjarRUDYlJodNKoaAPC/HoW0
         ZRBIYthYBM5OPouAmjBf5JAZxx/3k5LFT8djoalnNZrJ48yLuctIK0tjBygEYTTLoHbD
         5jV1gyGmYP8/Tu5b+H4MbFuWdFcpr07tx4bTIr6DMC+IhJzPIZnWwJXvvFpcWnp0H49x
         yeyFnqVio/fq9kHk4nlxUKjzM5V00mItkhlG1U7X9wX1wuepqvf5kWlOgG68tE7BymGK
         RkTg==
X-Gm-Message-State: AOAM5328mAGwY3MHC1h2HK1vMn8Ey1/VtTXoPSKQ5aLnrGL/p1xZwOvP
        bDgNQfnJ+iQGrMLGTXYablKDpEtK24Rk2bb141Fhug==
X-Google-Smtp-Source: ABdhPJwPARVd+0+sVAlTw8d4X9uif3evBq1+ZJvbQrt6UZPOITpB2/OgbHJAi5BmRzl/VwYm4lMdjYXywogZoec0eno=
X-Received: by 2002:a25:2a86:: with SMTP id q128mr12908245ybq.684.1641275002015;
 Mon, 03 Jan 2022 21:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20220103142053.466768714@linuxfoundation.org>
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 11:13:10 +0530
Message-ID: <CA+G9fYsvoBS6gMupnMcfcqBNjhWriSXYt1XgnAXiE5X24LPG8Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/48] 5.10.90-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Jan 2022 at 19:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.90 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.90-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.90-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 38b2ec850bfc4ecc2b202c3b232d5ac92bd4365e
* git describe: v5.10.89-49-g38b2ec850bfc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.89-49-g38b2ec850bfc

## No Test Regressions (compared to v5.10.88-77-g44b3abecd41b)

## No Metric Regressions (compared to v5.10.88-77-g44b3abecd41b)

## No Test Fixes (compared to v5.10.88-77-g44b3abecd41b)

## No Metric Fixes (compared to v5.10.88-77-g44b3abecd41b)

## Test result summary
total: 93907, pass: 80491, fail: 576, skip: 11894, xfail: 946

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
