Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2AB407B29
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 02:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhILAuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 20:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbhILAue (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 20:50:34 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B25C061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:49:21 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so7929216otg.11
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z2Pe3b4SwlRKMgOlkS8oLjBODIJOoVQs8dZ7ECsnqGs=;
        b=IEUKRAcm6aj0e5ichwr0mCY7Id16sNt59Bf09oaZcLhvzpshxOE7Gcrg//ObWdU46k
         tlxjv+4ad0Lm72TzZKviMO9M1zlu/3aldi3cwyA8SSJNMNtNiPmdqHWL4DWPJBNCZqv7
         gtXqqwFV0cRhX5cbQs9AEBgRJcSuRtL+XOgYOEQQCMluKrT3li6BLuJbIUwJ4Yk8V1/I
         9uoNY0fjmwaCE5h0O617c4zj+g1D+3JnG7cncA3ST+EULxzqc4vODZHRYQLi6vaK9MYM
         4/TOTGgSI8bXMZkb/zfplmt5GndmOE41HOUn0nmCPss5J5jSnror8eODfxZNEbg0Boso
         CVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z2Pe3b4SwlRKMgOlkS8oLjBODIJOoVQs8dZ7ECsnqGs=;
        b=Wz2+pr5mcd/leC/WfroVZjvA8nM2W6dTLCTEvyjoNkrpnbCk5ypm/hB5/fcqMh5Cxq
         NtG3AHfdtsGhw86pMBeaTWuIY7O+IkfbQvYN1y+/NRpLszoyefpsnHcpLwIRp/Zc1jPk
         DIVJKRq6G/LGeu+WGTfM2/wrDaidA3d1iWGlPw1sdRf6+Y1NnEbxrL/K0XdT/MDv30w4
         YY7YebT5klGc2u2kL8FLjoScoz3Zw+rlyXHz/DOk4lJ7vLOtaR1ztsi4HUa6zkFSH8Cd
         Iv5FqjC1vR+45phyyMR71fs1itt5ZVryhwkLRr6bwVniLzk2Ah7mGVC2Qhk+Ma3P83dJ
         DFcA==
X-Gm-Message-State: AOAM533X+JKv26Mzq6mCfZKGAi26yoc/loEPfqzBzo3uRY4rezZ/taf5
        ozQmK3VdtyE56m3YhgfzetkX+A==
X-Google-Smtp-Source: ABdhPJzic/HopRBy6AIGYBq7mWJrD3YD1GMtkkTTK4sRpx11cp2GDG1fzMgrkLd69pRwpA3weRhTDw==
X-Received: by 2002:a9d:6a4b:: with SMTP id h11mr4087878otn.5.1631407761043;
        Sat, 11 Sep 2021 17:49:21 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id m6sm767063otf.52.2021.09.11.17.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:49:20 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/26] 5.10.64-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210910122916.253646001@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <d345fa07-4fb4-96ed-ad23-a377ee26c9e2@linaro.org>
Date:   Sat, 11 Sep 2021 19:49:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/10/21 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.64 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.64-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: 750f802d275892bf81c140338d6820d725399edc
* git describe: v5.10.63-27-g750f802d2758
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.63-27-g750f802d2758

## No regressions (compared to v5.10.63)

## No fixes (compared to v5.10.63)

## Test result summary
total: 85074, pass: 71767, fail: 472, skip: 11795, xfail: 1040

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
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-android
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
* timesync-off
* v4l2-compliance


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
