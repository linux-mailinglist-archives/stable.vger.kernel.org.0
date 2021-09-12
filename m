Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0831407B2C
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhILAvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 20:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhILAvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 20:51:17 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C49AC061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:50:04 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id q11-20020a9d4b0b000000b0051acbdb2869so7967359otf.2
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 17:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UCKbYQVg0NrkLl33TYXRb+O3kd6Aizcbcz5L6Wd9Lqs=;
        b=I+2Fg+vKIJAzjIuGAfeS3d6ARwuc+iuhT6pqF8hXeNeCyA2fOyJDhyqjl5tUh0uN8S
         7qzACKzuOSAWjJj+TsY5JqGQRe+JM1O1r48v8GUCibZ8fnhsX17bHV4GsrivR2FeI0It
         SKSU/uhK3M+yk5/H0rMf8C5EIL446LheK82Y25z4zM3u4Og40ilx6qMJG+/qAB1EJEPA
         Yx046EtNMJ0Yd3DBPK2TsrQG83xFWwT5EPGLf9S6BAccK5ULhREVmR/fEssf3tqed3g0
         pqptVSJFVYIdy+lFL4Ugvm/B0pMONlrQB4jXj+iPljMtfQdc8NDI6RobjIuCOQmnDmNf
         pwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UCKbYQVg0NrkLl33TYXRb+O3kd6Aizcbcz5L6Wd9Lqs=;
        b=QbkuSlAYoQgsuPrCUd8O2gN2A8ki6InuhGpH+WpcJEgXkhBY2lQLL9elF0+yHLzsHx
         WnB/7OAq68nHO3395xQNR/geV9mMBUTykr7hDdEhgLX+XDnTE3DAVAD1uIC1cd7CRY6X
         p25/HC0XFLABnV/Il75dUzd9Dm773XFpZFpoqO+O2S555rmpFL7D/57gnVEz4kAPkoWa
         S8FK45+Si0aurks0fxx9OtpNMt2aZVOTZ8GWMqZRZe3Iil0Anog4ud7S/vlaVDb/Osyf
         WMsfNpTbb/Zf8rypKyT4xmhx/fIGZnu20HmUZgDV+FlY+Yxo5l0h6LMR1FD6yvlrXLxn
         GNFw==
X-Gm-Message-State: AOAM5316oGKE2nha3tSa8B+5o+rLJ/21jPOzzzHTm156z0eySvnPoEVW
        2kAqFLObwJX7mA7tG63GXqb1Xg4JYZOOU9Ge
X-Google-Smtp-Source: ABdhPJzOyfU1cfuJXyRDxHgkVM2ERzOtFcEGejlWR9EB9DOIajTcvASHHZTnG53jLjPUKfEAfkyPiQ==
X-Received: by 2002:a9d:609e:: with SMTP id m30mr4043738otj.38.1631407803698;
        Sat, 11 Sep 2021 17:50:03 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id a23sm787515otp.44.2021.09.11.17.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 17:50:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210910122917.149278545@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <b27a6529-ae0e-bb5f-daf4-503e1535523b@linaro.org>
Date:   Sat, 11 Sep 2021 19:50:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/10/21 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
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
* kernel: 5.4.145-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: c7a4f9e9970a3255ff44d518561096c2e4b3a5e0
* git describe: v5.4.144-38-gc7a4f9e9970a
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.144-38-gc7a4f9e9970a

## No regressions (compared to v5.4.144)

## No fixes (compared to v5.4.144)

## Test result summary
total: 84479, pass: 69774, fail: 753, skip: 12910, xfail: 1042

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
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
