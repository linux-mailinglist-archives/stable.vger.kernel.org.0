Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B40502AD6
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbiDONUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 09:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiDONUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 09:20:53 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419A8A94FA
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:18:25 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso5337421otf.12
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=td7LjSR726ZccHOymevWbGuZzI3AlOnnFkfv65W9Y+g=;
        b=MJQuc6h3yjFY5nsUYHtKgfH9eLe2U+Lz1awg39GDb/E81XvbIdbcefYUTVzQy3pzNc
         kgte8rNzDtEAKzQbGnSv0fdEnJ5yM7RVRde4mdC5h8It3j9L1BxZBxVeBFYFE4vP61Gw
         GYvLyv6BrbVulLAtyMx2zeg0ukRHXtTrZeiHXBKvNwZYaQgC5Xt744GnSIH0T2TdIGfE
         hJ4wQpejRHwMc3CqiFj1pXMvRog835nwoEoXC86GdNpSEvr8YitDn7VVTEl9e6brIOkx
         mgA0OefHCTkKwYdPdW7cUE8sWx22EWW3vqCcPdxagT7EPtOxzrbWuK+J5o7mM7CPSEnO
         EfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=td7LjSR726ZccHOymevWbGuZzI3AlOnnFkfv65W9Y+g=;
        b=Ngms0oHzHKUIfHyYBDIQblLvyj76F8UScTUl3vNYlVyS91c5mfQ/q+zMnVCwzW4yMS
         /g2+BxbBwGy+Bg0JXZRrm6r90b0dm8w7RsfC68NUFANi9a5G1qf3H4hm7Gs1a+pIYIG9
         EfZgvijXvJu/LCurAJoHJdmJ07eFYAjmwzGCptK40HhB8Fb0PeKpa4h1Xj+7/WpoOD/I
         /kiMf6o8pdFJV7nJD9G18tmBO98F78Pm2R1rhSDUqAM2WAcwQeiSqE2OGf7Mp04Z9MHC
         c5sFo4K4lFm2rIBoWDwoH5s5OaeX2FwYtk5MxmZLw8FF9zo6PcYPlRqIUASyGeM7CwTy
         B1wQ==
X-Gm-Message-State: AOAM532OyfXigBq6zFHO+iR8Yh03wXvSzYORypczi5STqkn/hnNuXWtH
        nEbpt2PJH3sRSToqOduVPxcj1w==
X-Google-Smtp-Source: ABdhPJxtw7meuMjIomFejZJ0oZASE2HKGAFmos3vU7+e/kVXtA0dLKyPo9m5DNVxpEI821L8Uq9nhQ==
X-Received: by 2002:a05:6830:105:b0:5b2:4276:e03b with SMTP id i5-20020a056830010500b005b24276e03bmr2578465otp.162.1650028704547;
        Fri, 15 Apr 2022 06:18:24 -0700 (PDT)
Received: from [10.90.244.38] (static-121.206.189-220.alestra.net.mx. [189.206.121.220])
        by smtp.gmail.com with ESMTPSA id u14-20020a4ad0ce000000b0032174de7c2csm1128478oor.8.2022.04.15.06.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:18:24 -0700 (PDT)
Message-ID: <d635ca14-84b0-6b75-0f1e-5bbcf843acee@linaro.org>
Date:   Fri, 15 Apr 2022 08:18:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 000/475] 5.4.189-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220414110855.141582785@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 4/14/22 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.189 release.
> There are 475 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.189-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git branch: linux-5.4.y
* git commit: 894dcf9d89fbc5bbc2c65827aaf7febc12fe19ca
* git describe: v5.4.188-476-g894dcf9d89fb
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.188-476-g894dcf9d89fb

## No Test Regressions (compared to v5.4.188)

## No Metric Regressions (compared to v5.4.188)

## No Test Fixes (compared to v5.4.188)

## No Metric Fixes (compared to v5.4.188)

## Test result summary
total: 90063, pass: 74104, fail: 1138, skip: 13360, xfail: 1461

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf/Zstd-perf.data-compression
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
