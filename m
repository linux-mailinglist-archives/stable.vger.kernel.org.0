Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D372345BCC
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 11:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCWKUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 06:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhCWKUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 06:20:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF16C061756
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 03:20:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y6so22815687eds.1
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 03:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YAOD2k3cNTJSwk9m0CYU6SDfn4jX1ojbJ8sUQ1I/0cM=;
        b=lO4rUzwPJfavXkB2+0Z6ZiwqC0isn1q9zSbfIBhP8pVv+Dp/MusSFbKWXAMpLDWeWK
         0x4D7hEWEII39oFRCFmIU1kOQQYcqi2eb9HWEvw48vxxdtOesUvrIAm02kd6PtteR99t
         9CxbDHLgfEs4el9Ho2c3PF6gATiwr/2NMJWt9tsDMwr/5apbbt1YpkmB8aC8KG1TQtjU
         46xngpvvhSfUqK7tUQg8oTT9qOK2Q43gKhe2phXodBROsYRAm0Rt82sDizBnfOES/YKf
         SbsYZyaDdpux7aRjC6kF0DSEGJx2y1AKpNnHmq1QPAoQv/rfweQDwSyFyqsdsJHnlbyj
         jf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YAOD2k3cNTJSwk9m0CYU6SDfn4jX1ojbJ8sUQ1I/0cM=;
        b=nusEONqUO0+qYFSDzNQMcg/fG+lsw88krzXsFXvMONm0tSgdZoDu6JwK7Z4lZKCqf8
         xBoDGir+4hlyLfgq5C7jDAnROtd2ptQuUtu+0r0W8Yz28csmguseS+MF3eiAJabE5i/b
         f0qDciAA/DcKyyMNvfR7EV8hqlnTREJ5BjipMydf9rXJ0YDT1Iu7/0uxuPie2p2JE3JZ
         V43qA2xUPRXUks0ho4R0Q+46fKWSLto6wFxBhRhbbauZSIhEkU4nr8tMlgfuDRuxmbg3
         +ZTUAopzys6IXi8XheLVisnIIGUHGB0LO6dQS5zxDHPhi7GP77fEUhHB5SRaSVkd+hC2
         /QIQ==
X-Gm-Message-State: AOAM532DDRyv7A8QtCXAMPCAxQ1InJse9TvS63WBo2s62ju8JqJZWKIK
        HUuYPNrbfUdkP9IgafMYpeW51OZf5LzbS9XJy0uDNmsowlsCQygN
X-Google-Smtp-Source: ABdhPJxqEvWFJdvgaGdb3OuaR1JOuw5MP7iT+mq0shdzqzxXH3S87eGe43lRy2VG8RnXWCDjakJdIyzls7YdYpVVok4=
X-Received: by 2002:aa7:dc04:: with SMTP id b4mr3806679edu.221.1616494822201;
 Tue, 23 Mar 2021 03:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121922.372583154@linuxfoundation.org>
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Mar 2021 15:50:10 +0530
Message-ID: <CA+G9fYtUFWMWy-pTxtLzYbHWA8mUU+d=kPEOpChTmxo08b2ReA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.108 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.108-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.108-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 5094cb203da71ac5da8f1715dec97fe69fbfb326
git describe: v5.4.107-61-g5094cb203da7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.107-61-g5094cb203da7

No regressions (compared to build v5.4.107)

No fixes (compared to build v5.4.107)


Ran 60075 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* perf/Zstd-perf.data-compression
* v4l2-compliance
* fwts
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-rseq
* kselftest-tc-testing
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* kselftest-kexec
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-vm
* kselftest-x86
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* igt-gpu-tools
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
