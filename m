Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7844140E2
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 06:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhIVE6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 00:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVE6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 00:58:01 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6240CC061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:56:32 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t189so2666697oie.7
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 21:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jP9lcgUeHpyPPMmTrWILA9tLIIhLjcy/Gf6ZBx4JooQ=;
        b=Iu5+pS6qsZTbO3gpRejZNOmRsuCWd5TF6bmNVeQDvP5yFJBg6HdjjRLmXvNfuvYntH
         WSlRS+8iegArZnC7sXjMvyocGagW0aGB9WempeysWM43NMiOoo2FuETCgfhOFHQdvhek
         TXVunS/oHW0YGtrt14t9lLBTqrw0O+EU5lKij5T2CNBWAZZsEj2gJHoRZ+JhFcVemWDA
         AnzSqHyxZfmlnXt1TmuxNzIHMdEPakDwTJZWOkt6EvXFBnaX1Q1rQDBWe8NfQBSw7NBg
         PI5Lkdqup9OaVG0ULoL7/4TQ+5hyFTZboCpgaIUIVFDvcKwZKwRNhCiAosTpnx/jXSxk
         Ui2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jP9lcgUeHpyPPMmTrWILA9tLIIhLjcy/Gf6ZBx4JooQ=;
        b=YnTZkiEbLEACDkVhqKwE861+xpyOkTnY1sf8oe5PzcAM2WSETGV9QsKLRXNILpDZC7
         r6k1GFlqYU62niEBtCx5FeyhbQ9hCZmLTVpfXXJE5AGcPRVEN6CK+kppOy3gUV0QncWD
         cRy2gRXXVUOHx0TO2n8NngUIyv2kJy1GhjjqNxIwdbOunVHCpOyD6XBO8nIrjZDZ29by
         r39qa/buWQ+qFjqo3SEPD7D+m6zmdraAk404bW4YhsR6UEeZXiILjlNL0UTfw8tvs/vC
         dmblN/2yewq3vXl15iILfT73jQZr6dUJjCtMpDThDBBVWqryAhmzAl6JIqk+DG2Q2yGx
         6ZZA==
X-Gm-Message-State: AOAM533EPzdDwZ8CANjRjiQWEKe9mu0f0py/qBx09JDn1k6Ul9zFJbKd
        0g8iIqlST0y2hUKGF1ARmnq/oQ==
X-Google-Smtp-Source: ABdhPJxAoPegtevDLZFnPWtBl0EYPEbQ5ygwNdifKpY3/K0UoNzirGqNcbuaWGY8o3+V3vwawHcszQ==
X-Received: by 2002:aca:e142:: with SMTP id y63mr6702006oig.112.1632286591787;
        Tue, 21 Sep 2021 21:56:31 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id r64sm297969oib.14.2021.09.21.21.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:56:31 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210920163931.123590023@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <b3c63009-3b09-6b00-d688-fcc6fce21a71@linaro.org>
Date:   Tue, 21 Sep 2021 23:56:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/20/21 11:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.4.148-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: 9f540728b6a345a2a70420f891d351c4397d3849
* git describe: v5.4.147-261-g9f540728b6a3
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.147-261-g9f540728b6a3

## No regressions (compared to v5.4.147)

## No fixes (compared to v5.4.147)

## Test result summary
total: 81694, pass: 67304, fail: 635, skip: 12557, xfail: 1198

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
