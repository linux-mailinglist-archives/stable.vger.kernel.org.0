Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF2336D42
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 08:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhCKHrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 02:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhCKHrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 02:47:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17638C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 23:47:14 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id c10so44097836ejx.9
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 23:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uj3xwXeznlGuhWIJQOpKBD7DMgpQl0/VxDQzp9PPcZE=;
        b=r9jFHJoJHOW69H7vFMIXJv3Qt5eWpVQIoqRlR1mxSpm3FFBjl4rdw9HoX5It6Fm25Q
         FABefxSZULSyVEMF3BlD8a4/WUJZR0VZsTp6ApRphkzm1BlwQM/3lF/900mQWAxxOYWc
         6JCPclv4P2boAvv1MHUMYwYliVNzVwnDXByoh3myb3LDNEEe8BICuT5efnguG9u0kSE3
         xpG0Gs9edw7gcz/XZXVYaED0Kn25IrqRnmnR2dYgeTj/dWcfWY4hkC78uy2SgDddfD+0
         adSxpP+ywiwniMYKT13Ho5IiY7gMKs2Mt6q1Y/aWMP2ro10exJzModbALtSmDBbnBtKC
         T/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uj3xwXeznlGuhWIJQOpKBD7DMgpQl0/VxDQzp9PPcZE=;
        b=XsHoPPRAZNSrnVD8FhRLUNO/wOfSgqNanHh7ueyuNT2IpWFt8ZHxq4YWHXioR+ozyb
         eB0HA3FU1I/ahZydrr8hHeuAgCHKUutJ6NjMOeWHYI7ZLniv815JQueXNt77CFhEmiiM
         qUOVZ59/1BWZAger3T/gQ6eLecm7AEKa9UjPLtlfsRLfC35kQvI1d7FqPXWypww7Ygqu
         CiLaTEKUnZhVBkGKXD5J8u5g5WFikrqfYZIyshCmt7JF/z4m2uh8pBsAWvo25IzALZuZ
         C84olsX8/mEjFvgh50prf8IbHVnDdEmzg0ft3yDgJiePLvrRtSGSjH9aV5nqnbc2KMSY
         11aA==
X-Gm-Message-State: AOAM533JZFdbZ8RLyO+6ILcls8857fcFcqRI1Yd2DZTxeUVJ5U7Ezn8P
        g7/fsv1s5Fjsq5zaLWlW9IU/tFBUUszsWiUEUW+B9Q==
X-Google-Smtp-Source: ABdhPJwKPefWsKGZZxs7UnWbyk9IdA7m58jjd7+srXXSw7E3n08pE8VihPqh0FkYdhXZt3hqInPxuTftr3fEJWQZmwY=
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr1880420eja.287.1615448832419;
 Wed, 10 Mar 2021 23:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20210310132319.708237392@linuxfoundation.org>
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 13:17:01 +0530
Message-ID: <CA+G9fYuHNa0mKM0ySnNywXMbVscN5Tb8aMrzJ2KRn-w5ZsodJw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/39] 4.19.180-rc1 review
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

On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.19.180 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.180-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.180-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: fffeea4063954b09866c112dad21a991ba52a914
git describe: v4.19.179-40-gfffeea406395
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.179-40-gfffeea406395

No regressions (compared to build v4.19.179)

No fixes (compared to build v4.19.179)


Ran 50816 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-kvm
* kselftest-lkdtm
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
