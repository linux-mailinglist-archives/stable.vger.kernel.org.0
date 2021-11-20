Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15C2457EF2
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 16:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhKTPaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 10:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhKTPaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 10:30:25 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0040C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 07:27:21 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id b5-20020a9d60c5000000b0055c6349ff22so21507340otk.13
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 07:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upm4Wumw3TuBFn621J2n4MFc2tW7m52KB2YgwqHKakI=;
        b=ojiMCAY93qndskXz+jqEm7LZUV+sW66SDuBt5yC+bKgEtLTrIayoXaQvcj9963jqsD
         NbcddTjHzBJBGbDpKrHKk/W5QCLHk+Jw+bjU0kJlk3wkBcHdDQPckMBXe35ifEzbSvzl
         au7nQSpLp1tdx5VpjtxiW5nVXWWMLHmnezqw7Pbf+dKoJ8+CGKPtQmb7g3UiYmWWzbfB
         bz6UfewXkVhAuwzDmZb5zuAro5G4o6fwAEhJ5deNGVAR2YKU0eCBiZpXyqihtMRtEHvo
         xjDU5nW1/1rSJ+dgoItg0S0NpMUVe+QxvO4ckk/bJU2QeFblXrD1+AD5zXmtanFc2Y68
         O7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upm4Wumw3TuBFn621J2n4MFc2tW7m52KB2YgwqHKakI=;
        b=YTieoQeX2L75uTciouspfRNEQwBCKkuxUNsa+8IUACcLY2ZNygI2Up3oUI53qik9Tm
         SOIbY9x7xDk+hoebbnQi06ufsOlqAsGmT7sPDEdv3LC0CR7+FNSOBzCw0BIH90SpynQi
         RGwUtEusvcWFL3naE4c2Q6Wr3i6kqW7J8sdG3QopFXfi0QyEvKIrGEMV4oHH2AZYVOK+
         0fRrPMyOqvihI0K8XcQLcu6TRholI/mPQoF1VPwOadOBqfMma66qT1wsEBNzCeZ3NwUk
         yktqAfjJNCPrkSa1yjnwEEgmm0hPcgdvDW7GLfQAWkhs3+IIXa4XDsqtLF4d+BNDFo/R
         45aA==
X-Gm-Message-State: AOAM532trH0hRXTi7/FMT4S1YvMXr3AEYhPv7cVXNa8cJv5D5c5ZvJcR
        7W3xG4ORT0b5glNYGcXP+JukvARUZvJ2qw==
X-Google-Smtp-Source: ABdhPJxFz8gnGvJUt+Pu/A36Zf1u9fEfu4oSUjoRPZeFR7IT1HmcDS4brraS5JG2g1w8VwAJFy0WVw==
X-Received: by 2002:a05:6830:1092:: with SMTP id y18mr11761903oto.119.1637422040763;
        Sat, 20 Nov 2021 07:27:20 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.83])
        by smtp.gmail.com with ESMTPSA id 3sm709933oif.12.2021.11.20.07.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 07:27:20 -0800 (PST)
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211119171443.892729043@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <106740f9-4efc-f1ac-fd42-bf8afc994333@linaro.org>
Date:   Sat, 20 Nov 2021 09:27:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 11/19/21 11:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.81 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.10.81-rc1
[...]> Peter Zijlstra <peterz@infradead.org>
>      x86/iopl: Fake iopl(3) CLI/STI usage
[...]

Results from Linaro's test farm.
Regressions found on x86_64 and i386, on iopl. Here's an excerpt of the selftest:

   [    0.000000] Linux version 5.10.81-rc1 (oe-user@oe-host) (x86_64-linaro-linux-gcc (GCC) 7.3.0, GNU ld (GNU Binutils) 2.30.0.20180208) #1 SMP Fri Nov 19 19:48:55 UTC 2021
[...]
   [  170.351838] traps: iopl_64[2769] attempts to use CLI/STI, pretending it's a NOP, ip:400dde in iopl_64[400000+2000]
[...]
   # selftests: x86: iopl_64
   # [FAIL]	CLI worked
   # [FAIL]	STI worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0xed failed
   # 	child: set IOPL to 3
   # [RUN]	child: write to 0x80
   # [FAIL]	CLI worked
   # [FAIL]	STI worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0xed failed
   # [OK]	Child succeeded
   # [RUN]	parent: write to 0x80 (should fail)
   # [OK]	outb to 0x80 failed
   # [OK]	CLI faulted
   # [OK]	STI faulted
   # 	iopl(3)
   # 	Drop privileges
   # [RUN]	iopl(3) unprivileged but with IOPL==3
   # [RUN]	iopl(0) unprivileged
   # [RUN]	iopl(3) unprivileged
   # [OK]	Failed as expected
   not ok 7 selftests: x86: iopl_64 # exit=1

The baseline kernel (v5.10.80) exhibited this output:
   # selftests: x86: iopl_64
   # [OK]	CLI faulted
   # [OK]	STI faulted
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0xed failed
   # 	child: set IOPL to 3
   # [RUN]	child: write to 0x80
   # [OK]	CLI faulted
   # [OK]	STI faulted
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0x80 worked
   # [OK]	outb to 0xed failed
   # [OK]	Child succeeded
   # [RUN]	parent: write to 0x80 (should fail)
   # [OK]	outb to 0x80 failed
   # [OK]	CLI faulted
   # [OK]	STI faulted
   # 	iopl(3)
   # 	Drop privileges
   # [RUN]	iopl(3) unprivileged but with IOPL==3
   # [RUN]	iopl(0) unprivileged
   # [RUN]	iopl(3) unprivileged
   # [OK]	Failed as expected
   ok 7 selftests: x86: iopl_64


## Build
* kernel: 5.10.81-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: ed689bd1df46a07911fffa509cd06c5ec7beb9c1
* git describe: v5.10.80-22-ged689bd1df46
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.80-22-ged689bd1df46

## Regressions (compared to v5.10.80)
* i386, kselftest-x86
   - x86.iopl_32

* qemu_x86_64, kselftest-x86
   - x86.iopl_64

* x86, kselftest-x86
   - x86.iopl_64

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## No fixes (compared to v5.10.80)

## Test result summary
total: 91125, pass: 77560, fail: 574, skip: 12243, xfail: 748

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
* powerpc: 54 total, 46 passed, 8 failed
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


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org
