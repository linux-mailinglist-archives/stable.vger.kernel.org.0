Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F0407B24
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 02:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhILAsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 20:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhILAsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 20:48:38 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D18C061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:47:24 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso7937821ots.5
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/LSLBmufQ5n0mtBnR6yg9irK8YpH1Tw+3gMEcTX5tUk=;
        b=gfYhuRDau0WrsLkp15hjefSf9s3uXbqnxwul/oMGl9OZcohOznW5PwsPo2ZRbmrwiX
         ZsSrSzhK0AHNMf3ngduQS903FcCtZ6pCsDJO/a13bz1JFv8mBztPVGAIjLULtzxrXagX
         dXVF3SXpVzzoVs8m7L126Z96gb5HD2ZwIKo0v1zaqmXtBYzMDctiy2fBN6fmsELg+pfr
         8Fp1SqFMe+zCapbftUNuuzJJ+8DyTfvdr3Aa/IvOKfky1a0aETjYwzitbWSCYCZ50Hgk
         CxXFMh1eW1PknQMjub/vNzugK/2dqLjnlWrzwnoj0ayYpBCpJRK3N2lM8i9WaylmShUC
         iKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/LSLBmufQ5n0mtBnR6yg9irK8YpH1Tw+3gMEcTX5tUk=;
        b=VYPUZsG4tgBUOW+Fh8Cjv9OLieqtPKTDGekEEHz23H+9k9nmLzs98NlGYYk+zs9+P8
         deeJp6Lm6MtlOw395Ar/3GegHZhrfj41gg7gIxAojPGID4L2Rhc5xBZdxlbYYoRO5zge
         gPH93qNN9YiWbWZVctH6BSQQTwXBSnkaSHG74lm/ryp1br+S2z5svmpT9EbE86qfRgnz
         DAY1iWMEcoOLs3IEodCTmqQSRghjtYINPDT8OlpKZoE/6YWHviYL79zWNs1MODpnpVVm
         xZUiQiTWWgPbw11nM6hLXEPT3i0Rkf9blnC8zbZ8YKROctJZRzpXiuULwRoTuxY8HUrr
         dYXQ==
X-Gm-Message-State: AOAM531oUrmwjDO1MRzAvVHkICnKjk6CU2cxx3zldk5mxg7i+j/sRENQ
        6rjyUAHXY3vh2jQaWNw3bTOuIg==
X-Google-Smtp-Source: ABdhPJzrB/VicrqvhOyp0Cd5J7qih+zesVQ23LM643Iz+Rqej9N3VDcDNDxGPz8gE+ypQGgmRXgLYQ==
X-Received: by 2002:a05:6830:794:: with SMTP id w20mr3915973ots.224.1631407644247;
        Sat, 11 Sep 2021 17:47:24 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id y16sm769236otq.1.2021.09.11.17.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:47:23 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210910122916.022815161@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <1c5ecc05-d759-74df-62e3-62d4cffdf41d@linaro.org>
Date:   Sat, 11 Sep 2021 19:47:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/10/21 7:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 08d4da79178d3d352115625b6aaa4eb58e173f0e
* git describe: v5.14.2-24-g08d4da79178d
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14.2-24-g08d4da79178d

## No regressions (compared to v5.14.2)

## No fixes (compared to v5.14.2)

## Test result summary
total: 85896, pass: 71970, fail: 1039, skip: 12121, xfail: 766

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 72 total, 70 passed, 2 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* kselftest-lkdtm
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
