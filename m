Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874CE457F5D
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 17:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbhKTQKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 11:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhKTQKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 11:10:12 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902D7C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 08:07:08 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v1so22667589edx.2
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 08:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dONUrPBQwEgXgwz1i2/FBCEms8zfe8jywFdMB4mBXn4=;
        b=p02MlVcnpAL59IC1CFThAJanmgBNwLNMFmClxr4XxyrmJIAJCiG4QEvcaeMhVux5KK
         PltstlpjhjeZGhySZdst1n/xCeLtTb28nS9CMQrtpnqJheuZ6+oGUpiQWukqMQFFcbhv
         3/HxF+qbxFBCV3uuM5FDNJyVBLvXDltHS4FbFc2+6RSEh0WUzjD82P0wKyRa9vHtxNBF
         6EoMZae0QC/fKJ0mSoOftz0BqAJLRWkoPH/y9Bl9l4IlqV18V0sPUHYFaKeJktaB6my5
         IDkrR4DWznO23uPFGvkBUeQqH3v9ncao3D4CmDRlZzpZo344/LhxQvfICeMdMI78LJ++
         ZCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dONUrPBQwEgXgwz1i2/FBCEms8zfe8jywFdMB4mBXn4=;
        b=XMwRZ/nwyc+HE9Rszk7dsf6irAo2UGEcNBQh6+oNtlXteWoDYt5U0BgmXGlGAAbMIn
         hlFCDA9Tgg5edEY79xwxKgP01OVa+/SpoMhzJbVsS1RrYZ7KSh6ani5yQUE6EBQ8yu4x
         KTD0OBwCRYvoOBx5YNP/FUPsGPDzyd525MWQ4/hJNyWHH8H01EFjfPb5HV+INVJAzfb6
         XAwuxwhMPud4jdDvaXtvNISAqtcp1049aMMGYxkwoZTCBwPwKk3l/t/056pO8LwBqDzu
         JXLYaBCelFofGTeMD9T1pXZA38Z/nsjjKY/+rLKTq7q02d4ErTAqKGMztIg4M8hv3KPh
         bX9w==
X-Gm-Message-State: AOAM532x6k9AYpOqt6lEc4jZhyU4LAjFvELkHjVtdfP5wWJQtjvKz24s
        gYbctugnOvSTp13DUv9ysxPD1BmMn21yQ6GxheKuSA==
X-Google-Smtp-Source: ABdhPJzu/dUAVr4ckZlvVgHmm7HoIdGr2Te9Xczlhu0xFEnuPIRlpGJ06pYxucIhNrkkwpJA6w87b+1dKb1sa4bYJHM=
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr20517745edc.103.1637424426738;
 Sat, 20 Nov 2021 08:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20211119171443.892729043@linuxfoundation.org> <106740f9-4efc-f1ac-fd42-bf8afc994333@linaro.org>
In-Reply-To: <106740f9-4efc-f1ac-fd42-bf8afc994333@linaro.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Nov 2021 21:36:55 +0530
Message-ID: <CA+G9fYv4s0oE4w5ushnLwYrC4=fWh6uK2_umnU15o2bEZWZt2g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        torvalds@linux-foundation.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        shuah@kernel.org, linux@roeck-us.net,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Ondrej Zary <linux@zary.sk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Peter Zijlstra
+ Thomas Gleixner
+ Borislav Petkov
+ Ondrej Zary


On Sat, 20 Nov 2021 at 20:57, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
>
> Hello!
>
> On 11/19/21 11:37 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.81 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.81-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >      Linux 5.10.81-rc1
> [...]> Peter Zijlstra <peterz@infradead.org>
> >      x86/iopl: Fake iopl(3) CLI/STI usage

This is due to  ^ new kernel code + old test case (Test case needs to
be updated)

> [...]
>
> Results from Linaro's test farm.
> Regressions found on x86_64 and i386, on iopl. Here's an excerpt of the s=
elftest:
>
>    [    0.000000] Linux version 5.10.81-rc1 (oe-user@oe-host) (x86_64-lin=
aro-linux-gcc (GCC) 7.3.0, GNU ld (GNU Binutils) 2.30.0.20180208) #1 SMP Fr=
i Nov 19 19:48:55 UTC 2021
> [...]
>    [  170.351838] traps: iopl_64[2769] attempts to use CLI/STI, pretendin=
g it's a NOP, ip:400dde in iopl_64[400000+2000]
> [...]
>    # selftests: x86: iopl_64
>    # [FAIL]     CLI worked
>    # [FAIL]     STI worked

This failure was detected on linux next and the later test case has been fi=
xed.
The Following patch could fix this problem across 5.10, 5.14 and 5.15.

Patch details,
---
selftests/x86/iopl: Adjust to the faked iopl CLI/STI usage

Commit in Fixes changed the iopl emulation to not #GP on CLI and STI
because it would break some insane luserspace tools which would toggle
interrupts.

The corresponding selftest would rely on the fact that executing CLI/STI
would trigger a #GP and thus detect it this way but since that #GP is
not happening anymore, the detection is now wrong too.

Extend the test to actually look at the IF flag and whether executing
those insns had any effect on it. The STI detection needs to have the
fact that interrupts were previously disabled, passed in so do that from
the previous CLI test, i.e., STI test needs to follow a previous CLI one
for it to make sense.

Fixes: b968e84b509d ("x86/iopl: Fake iopl(3) CLI/STI usage")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20211030083939.13073-1-bp@alien8.de



>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0xed failed
>    #    child: set IOPL to 3
>    # [RUN]      child: write to 0x80
>    # [FAIL]     CLI worked
>    # [FAIL]     STI worked
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0xed failed
>    # [OK]       Child succeeded
>    # [RUN]      parent: write to 0x80 (should fail)
>    # [OK]       outb to 0x80 failed
>    # [OK]       CLI faulted
>    # [OK]       STI faulted
>    #    iopl(3)
>    #    Drop privileges
>    # [RUN]      iopl(3) unprivileged but with IOPL=3D=3D3
>    # [RUN]      iopl(0) unprivileged
>    # [RUN]      iopl(3) unprivileged
>    # [OK]       Failed as expected
>    not ok 7 selftests: x86: iopl_64 # exit=3D1
>
> The baseline kernel (v5.10.80) exhibited this output:
>    # selftests: x86: iopl_64
>    # [OK]       CLI faulted
>    # [OK]       STI faulted
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0xed failed
>    #    child: set IOPL to 3
>    # [RUN]      child: write to 0x80
>    # [OK]       CLI faulted
>    # [OK]       STI faulted
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0x80 worked
>    # [OK]       outb to 0xed failed
>    # [OK]       Child succeeded
>    # [RUN]      parent: write to 0x80 (should fail)
>    # [OK]       outb to 0x80 failed
>    # [OK]       CLI faulted
>    # [OK]       STI faulted
>    #    iopl(3)
>    #    Drop privileges
>    # [RUN]      iopl(3) unprivileged but with IOPL=3D=3D3
>    # [RUN]      iopl(0) unprivileged
>    # [RUN]      iopl(3) unprivileged
>    # [OK]       Failed as expected
>    ok 7 selftests: x86: iopl_64
>
>
> ## Build
> * kernel: 5.10.81-rc1
> * git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git', 'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc=
']
> * git branch: linux-5.10.y
> * git commit: ed689bd1df46a07911fffa509cd06c5ec7beb9c1
> * git describe: v5.10.80-22-ged689bd1df46
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-=
5.10.y/build/v5.10.80-22-ged689bd1df46
>
> ## Regressions (compared to v5.10.80)
> * i386, kselftest-x86
>    - x86.iopl_32
>
> * qemu_x86_64, kselftest-x86
>    - x86.iopl_64
>
> * x86, kselftest-x86
>    - x86.iopl_64
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
>
> ## No fixes (compared to v5.10.80)
>
> ## Test result summary
> total: 91125, pass: 77560, fail: 574, skip: 12243, xfail: 748
>
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 259 total, 259 passed, 0 failed
> * arm64: 37 total, 37 passed, 0 failed
> * dragonboard-410c: 1 total, 1 passed, 0 failed
> * hi6220-hikey: 1 total, 1 passed, 0 failed
> * i386: 36 total, 36 passed, 0 failed
> * juno-r2: 1 total, 1 passed, 0 failed
> * mips: 34 total, 34 passed, 0 failed
> * parisc: 12 total, 12 passed, 0 failed
> * powerpc: 54 total, 46 passed, 8 failed
> * riscv: 24 total, 24 passed, 0 failed
> * s390: 18 total, 18 passed, 0 failed
> * sh: 24 total, 24 passed, 0 failed
> * sparc: 12 total, 12 passed, 0 failed
> * x15: 1 total, 1 passed, 0 failed
> * x86: 1 total, 1 passed, 0 failed
> * x86_64: 37 total, 37 passed, 0 failed
>
> ## Test suites summary
> * fwts
> * igt-gpu-tools
> * kselftest-android
> * kselftest-bpf
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-drivers
> * kselftest-efivarfs
> * kselftest-filesystems
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-ir
> * kselftest-kcmp
> * kselftest-kexec
> * kselftest-kvm
> * kselftest-lib
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-memory-hotplug
> * kselftest-mincore
> * kselftest-mount
> * kselftest-mqueue
> * kselftest-net
> * kselftest-netfilter
> * kselftest-nsfs
> * kselftest-openat2
> * kselftest-pid_namespace
> * kselftest-pidfd
> * kselftest-proc
> * kselftest-pstore
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-splice
> * kselftest-static_keys
> * kselftest-sync
> * kselftest-sysctl
> * kselftest-tc-testing
> * kselftest-timens
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user
> * kselftest-vm
> * kselftest-x86
> * kselftest-zram
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * linux-log-parser
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-containers-tests
> * ltp-controllers-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-nptl-tests
> * ltp-open-posix-tests
> * ltp-pty-tests
> * ltp-sched-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * ltp-tracing-tests
> * network-basic-tests
> * packetdrill
> * perf
> * rcutorture
> * ssuite
> * v4l2-compliance
>
>
> Greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org
>
> --
> Linaro LKFT
> https://lkft.linaro.org
