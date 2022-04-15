Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC4502B36
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 15:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354112AbiDONq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244242AbiDONqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 09:46:55 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C182DDF86
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:44:25 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-d39f741ba0so8095793fac.13
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H6uC+E6X+NZtMZ9qxcUR8mekijY3ApRikEJ7kwgOoaY=;
        b=TN1yjtnXHqix4F1p8YqiAHjS3eqe8KnKLsT9vCo0mUG8GXHESpYH/kMDRUJVGPxjF2
         /5w6OAO86PCWDEXOpHRauygOQ/sS+N6rBTHE3GH+fn7kbFesZc+gsrEwxLsia+KTdZqb
         CIvuyCmhqmOwUQceDGmErNWZ4YLZJr1bWaSUALNuBdgl/ZPzsQzOyHEHkafTSYEMui4x
         wllR7NLQMKv6+ox62GOhrNPBQMg2viKXUFYweUZ5PDVW+fdV+uQGcKwkun2CeY/+MLq4
         TJ4XvgmZKIIsGHMXL3WwswJ9Oj3dt8owVoK6KSGJ2eGFYpq3qJrrB2EOA47WJrwsN123
         24Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H6uC+E6X+NZtMZ9qxcUR8mekijY3ApRikEJ7kwgOoaY=;
        b=YjkNfRV1u5D5dus8lYUDsD6K3khH69KzWWOyQ2jK9T1aU8bX5XWKeR6eYQuSxLaGgL
         S2LmfBO8lk61z7OTKLUndYZCzWdDrU5ziORf50LBL1GhThF7xMPq4fwMtYKSMJYadArl
         5vSbcwBcjsxfpRhPrQelfW5XQLvDNaKWd1ehE5KYtBs7x9xDB888i/3qpMmzQOoYjydu
         9xiHHvhin4mpCqGg143lWZBTKylX+Ov8d1Ffpc7ThkbH2BfhBRnb/uMwX4r8dqG1Gg0h
         CtPrZokppYUyAjuYUZjwLhcB3zsJ+MzaQfGGz24ARELwgGs+Z3BZo/Gmx0hRoHX7QIDD
         fcfA==
X-Gm-Message-State: AOAM531aXvnHj6rpniLPdg13U3R/bQetmhQJfkW1bsDUIJjbgZ6FSzaN
        NZ52hAHOGWZfYtDQwJ+kOgovSQ==
X-Google-Smtp-Source: ABdhPJzSjwldH2OrkdQ7mhy7CC8//fjnYVAfQAw/G9sHPghE5ti1TqalYMbcLmNY6Ou+IPV+0MfOBg==
X-Received: by 2002:a05:6870:59b:b0:e2:976c:7720 with SMTP id m27-20020a056870059b00b000e2976c7720mr1405630oap.16.1650030264243;
        Fri, 15 Apr 2022 06:44:24 -0700 (PDT)
Received: from [10.90.244.38] (static-121.206.189-220.alestra.net.mx. [189.206.121.220])
        by smtp.gmail.com with ESMTPSA id u14-20020a4aae8e000000b003332a47de0bsm1155173oon.20.2022.04.15.06.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:44:23 -0700 (PDT)
Message-ID: <6f590b27-e52d-a59d-ac55-3709554b5447@linaro.org>
Date:   Fri, 15 Apr 2022 08:44:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220414110838.883074566@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 4/14/22 08:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.238 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.238-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git branch: linux-4.19.y
* git commit: 3f08640122e30667d6aa2e90e4fa57f3d9f48ceb
* git describe: v4.19.237-339-g3f08640122e3
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.237-339-g3f08640122e3

## No Test Regressions (compared to v4.19.237)

## No Metric Regressions (compared to v4.19.237)

## No Test Fixes (compared to v4.19.237)

## No Metric Fixes (compared to v4.19.237)

## Test result summary
total: 86571, pass: 69522, fail: 1159, skip: 13859, xfail: 2031

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
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
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
