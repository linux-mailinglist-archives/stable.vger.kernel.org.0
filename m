Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC253F7C50
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 20:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhHYSiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 14:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238896AbhHYSiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 14:38:21 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BF7C0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 11:37:35 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q39so627713oiw.12
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 11:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fksqrl/EKTvc+T71UeqbK4Yia1R5rWUE7suZNTqICPA=;
        b=qCQEul6GuvYDlHDyYvO2uyNCbNqo0DnUvUPM9q12v9tPio0orozfSeYdYRGoOIzUe1
         Vi8mYJMkBs1uij25tAzrIVF3cIuHn0ILEL9kRCqv0h3SPU2SEC82frTiQlfg0TxJ0O7U
         GMjFsmRIxZnZNQXvtIuuTu07iBUrs+thrXVdxIgCCfxaPboHdMUY2vXbKlCwEDgb0HlU
         oPwT58w+1qHD5jiGXstRnagJy2GSuHXoxef8XG2Lr5Xa/9ujPuAI2o5ev+yo1BgDEiLD
         9WkaWrJJu6j23ynyvP4/oWk5miI3uHZVzZbDoWl4TqSRxxn5A2i5U+IhZcRBfSyiO+1n
         K3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fksqrl/EKTvc+T71UeqbK4Yia1R5rWUE7suZNTqICPA=;
        b=Z6zRRBKQD9VIDkzMrNYI31nYYn1uk2BYlwaUaFQb3jMA4KAm/guMnfEl5B6SSXy7hm
         NMebqcUI1A+OrslAzXvMNuWbysCvNqbZpFeUL2VCj/n7KI79vIB9TWGis2/TgkrEmXzs
         j4vYBtDgDeqME0jKSEtHtZFfJ82IL4kdnJU13yP20G+dXRf0ZXNs1sS1EEqIlYuf2SrK
         Rq45E/fqyikA5RYiJ+MNMc4wA0V3dUWJ9iB0GEL8dskkt3qQGcIhDdcoNS7gmgVxVTbG
         Fck6VZAt0ZZcxBfq/WSZLlwjLEAz95rmyAoFIjkYfQLq5Id2ogue9dOlA2g+Gel3XKWL
         wNrA==
X-Gm-Message-State: AOAM531d2QSghMztlCdK2DwEvo/A2Lx26IpaMxjl9PgZX5rhdY59Wa77
        v9dRFixBB6rC/zM0QZGyOsT8Nw==
X-Google-Smtp-Source: ABdhPJxCNUFBAJl5+rk9YbxA13B2YdGZK5KV8ss3m9TjQZSewtUelNxkVwNNMvHwr6CZXDR2euBDNg==
X-Received: by 2002:aca:1703:: with SMTP id j3mr7873726oii.116.1629916654409;
        Wed, 25 Aug 2021 11:37:34 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.75.147])
        by smtp.gmail.com with ESMTPSA id s198sm124758oie.47.2021.08.25.11.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 11:37:34 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/61] 5.4.143-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        akpm@linux-foundation.org, shuah@kernel.org, linux@roeck-us.net
References: <20210824170106.710221-1-sashal@kernel.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <676a023e-507c-5cef-b7a3-6f8ecd6a68ca@linaro.org>
Date:   Wed, 25 Aug 2021 13:37:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 8/24/21 12:00 PM, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.4.143 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:01:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.142
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.143-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: 3b97ed8d226facd9905f634982238e5a93b4481c
* git describe: v5.4.142-61-g3b97ed8d226f
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.142-61-g3b97ed8d226f

## No regressions (compared to v5.4.142)

## No fixes (compared to v5.4.142)

## Test result summary
total: 72157, pass: 60155, fail: 594, skip: 10483, xfail: 925

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 225 total, 225 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 16 total, 16 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
