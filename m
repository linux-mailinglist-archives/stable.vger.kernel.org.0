Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD92445E75
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 04:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKEDNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 23:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhKEDNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 23:13:12 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472D1C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 20:10:33 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r10-20020a056830448a00b0055ac7767f5eso11176885otv.3
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 20:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=so4nsX1lXJFQb35p8revitMJL/1wWrTjn3/v1Nu1RjU=;
        b=nfMRXfFDdP10e3yMQGY+EtcnRyzXW/9SpY8/To64KOtSx0KWytmlT2donHbe6sKGfp
         1ReGjJxSrw8bjAUYrKknHyvN+y4KkF6SRybFWMsh9xKmS1uzz7jDWW+DwZJvGpIePEEQ
         QgDgMwo6nJm3NwpN8EZulfH5k6WS/zgWnM63ZaiM7Q8NBqLKmkqUFhnH4b1L9PlcrDR3
         NdIWpKkpC5Nl8mLjw7sVOyfPRxp6+T6yVdBevurXyOJj4uEdZXy1mXsoTYMIjhFOCL6m
         U2HC24P8h0doFSvIj0OA1egiRG2WMOSY9TLT7XaGkwa32Dt4fummJeHH5I68xiVr8E/g
         LIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=so4nsX1lXJFQb35p8revitMJL/1wWrTjn3/v1Nu1RjU=;
        b=kcqJzn9my0A99HMe7VFrlho7861Y0shsAO1QfhAYAlsGyjSqzlxPDZnstGlDYRGfQy
         xOVm/cvwO3B7hCItVBamN6poFEzuusMs3shBjxaNkWZxMhaB80NydGsKSaGe9ADDlAoV
         MJGf6mZ+DVWkFqT9nY50SZn01bjjnFhYXUu2+PYO/3e9R4v22pQIm9ItS1PPjch0zRpX
         fvaCp1S1HKMOpw30/H52bKSKXJEMULtuRKtmQ3SdVSsioL4j9yQQgE2rT2pddzqXFh+E
         vLKj6fxINgPxZ0tNokWmvklClSs34FxCZ2CJmqExzmV42zgpopRLuDfHHay/MvF/CvgH
         seLA==
X-Gm-Message-State: AOAM531mjTGpHmVYxkF1qlhDlW4rq+lKbkAob7YKkQYWgXZSMVYRdiw1
        bHZyEDhq4qgFsOGGa4IggQJMtjOaNOobVwes
X-Google-Smtp-Source: ABdhPJzMey1z1x3XkS7OK2c5e9r3V8Lb3qenvMGUxDREC0JMxUfO3hmNhvytVtLcLBm7vVYT9QXwYg==
X-Received: by 2002:a9d:6b84:: with SMTP id b4mr39849412otq.327.1636081832628;
        Thu, 04 Nov 2021 20:10:32 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id l7sm1812145oog.22.2021.11.04.20.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 20:10:32 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/16] 5.14.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20211104141159.863820939@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <66c808f7-bdeb-a509-8209-3584843dbb8a@linaro.org>
Date:   Thu, 4 Nov 2021 21:10:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.14.17-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 05ed8d6b833a25cb7b38026ed8f584dbdce21ec2
* git describe: v5.14.16-17-g05ed8d6b833a
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14.16-17-g05ed8d6b833a

## No regressions (compared to v5.14.16)

## No fixes (compared to v5.14.16)

## Test result summary
total: 95590, pass: 80826, fail: 1113, skip: 12783, xfail: 868

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 268 passed, 22 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
