Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35137457B3F
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 05:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhKTEnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 23:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhKTEnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 23:43:22 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD4AC06173E
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 20:40:20 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso19812306otj.11
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 20:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6gLXJVToek7k//ooAXpCPkey71+iBvfDw8mG1naWf9E=;
        b=xdhSm7J7F8B92Xp6s6m3ctHu4oxa3K6DT5USE6rztaSG//Fu7TetBvHRtUTtfYhzYF
         vVx/TPBFksj1tagr243aMO3DQamc5XmoYMUoctYMid8u37h8jEMAAoDjSYNPIH32VRXX
         zxrqteSZYfDrI8Dybl5fsab+jtBxQphC/c6Tf2fkyd/L0C+wtw67/ybJ1EtT00TXrWeZ
         O3zYg/HzJAuPpZGfXfz6L8KeYnMHmaiwJOkETVz67enqcTLaDwp+zwBGfXvS1eU9c7T1
         yg+nVqaevZBOIt9L/hJCrjDC3ClAqRWZDDJMuQLtklTWLe0cPxxHfqo36LmdBggDsP5n
         0cBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6gLXJVToek7k//ooAXpCPkey71+iBvfDw8mG1naWf9E=;
        b=1LDZRBe/DZjPV+VqvSzGMUegKIS65/22U/64TpVtkFU9CjQSfQXhdHQFos9fLKgF5B
         cIcCJDUrmaEm8B6GIGaPucs4JoyveaXlPl4aEkp/namhU1uX/6eZ0nNN1QOqx36WTSvN
         xcpp+KA/3oo8+4Hthva7HAM4zY/mehtxaeeiYrY4uU8ikFIMMI6KSD/kk2VgCik5iOTt
         j0df8eOOSkBB6WpMGOB8MeFhjKZLQeAX05R4Z2jVqCuKWJ0AJD6Nva+KHDdRFL0Y7dFJ
         zuyxzw0+wSQLseKDaY3G7ksaHk9FdVXEQjc4cxAPrToBfdZCB6mlJ4XYuKFJfzX5Wd/v
         GWhw==
X-Gm-Message-State: AOAM531udxr5NPbUzRvoLxFGIMzVuBjfsZt5WIRZrw8sdI//zZOCwo1F
        GJPkGqolEhjduHHz4t6JYGedhZH2elH5Dg==
X-Google-Smtp-Source: ABdhPJwjQ6xnBXiqseH6HeM7sfTuagIIA0uQEz3gHl78mtsOLU9EIg21RvU8tmJgNuGM9aTZb+qqqg==
X-Received: by 2002:a05:6830:410a:: with SMTP id w10mr9353063ott.55.1637383219166;
        Fri, 19 Nov 2021 20:40:19 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id u28sm408102oth.52.2021.11.19.20.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 20:40:18 -0800 (PST)
Subject: Re: [PATCH 5.14 00/15] 5.14.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211119171443.724340448@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <0d04c150-4a38-b674-5dcb-891961cefaa5@linaro.org>
Date:   Fri, 19 Nov 2021 22:40:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/19/21 11:38 AM, Greg Kroah-Hartman wrote:
> --------------------
> 
> Note, this will be the LAST 5.14.y kernel release.  After this one it
> will be marked end-of-life.  Please move to the 5.15.y tree at this
> point in time.
> 
> --------------------
> 
> This is the start of the stable review cycle for the 5.14.21 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.21-rc1.gz
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
* kernel: 5.14.21-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 050eba56bb1eb0015d96d6ce8874ec81522d8f4a
* git describe: v5.14.20-16-g050eba56bb1e
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14.20-16-g050eba56bb1e

## No regressions (compared to v5.14.20)

## No fixes (compared to v5.14.20)

## Test result summary
total: 90168, pass: 75825, fail: 1035, skip: 12384, xfail: 924

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
