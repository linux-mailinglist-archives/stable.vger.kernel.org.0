Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4965B35AB9B
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 09:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhDJHXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 03:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhDJHXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 03:23:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC66C061762
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 00:23:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id sd23so3395547ejb.12
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 00:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pxsiXwY3IcRQP28MQOmKHACLTeC0HfUH2blDc/pNfTc=;
        b=bLL9HyOYqBSS1G6yaDokTQRtqjvfA9l+YLZGSy6iFwCnUrRi8E/7pCf8hQNVkP6RZu
         7Sme/IER/zZ0A4RKyeLXcEHkuOR0Smn1oQ33iAdbefS+zOG9aWsDLuaxWJhmEGHXclG3
         ylaTae0mNl8C4DnA9EeL6JIWm9TecfdJmQiBRj2hcxmS7iPquA1erbTHW6Jz7vUq+5tR
         Ks3p0KspNUKqhvUOucBsNuhyu90mnFul8Vj/eWBHkHMEHR+nowaSVb1aeheTq3TdVd0r
         xfO5xqakAhCA2VqH6Xj1dF3//5VxV4np2S9o4UNK9EBtKlq+1HFVVt4vzYt47oPE0rxV
         vEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pxsiXwY3IcRQP28MQOmKHACLTeC0HfUH2blDc/pNfTc=;
        b=nZNLMkLNMuBBMXAndke8HBfC3Rs2a359Iu3hMOBlV3GlR0fi5M6XWlD1vShNDgzUZR
         TLa2fdL9Ai9akagcXl7a6gMktADTK/gV43Gdal0ZOTbXPQg2QcytZEZl42KEONKBz9dE
         /PujVsv33E/eh/w82XbGD6wreLvwFPGZoGJw/qnxt2dMUh0PIblF2B5sInMuF5dELmZW
         hFldJhYiGvv0vlgywty0kc85PNtAumUPdvG3mAGoh/C1WONVwYFjS9nL8Ngf6qugnOb7
         KhaG9Slfda71jL5XvP3QowAVWonI0iJnfas2epQ9h2PxMXxPZWmmgqAiHTBl7W2Rr1Yg
         /l0g==
X-Gm-Message-State: AOAM531KbtfT7+jW7DUM7hhRpLUxzfbi7YCB4CXkmpXe+OLI6d4zt1c4
        DAptNJ5/CQqXcqQMKMr5jHNyXFkU0faP5u2z18My6w==
X-Google-Smtp-Source: ABdhPJxKMsc/8tJR9aUFSy3nYLzzMnGBIwJreJDcLyTDQgAJaZzKrEzhvgkxMR6hXiiKi1IoBTU1veSyf8brHgKbtjk=
X-Received: by 2002:a17:906:9605:: with SMTP id s5mr19663204ejx.287.1618039403472;
 Sat, 10 Apr 2021 00:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095304.818847860@linuxfoundation.org>
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 12:53:11 +0530
Message-ID: <CA+G9fYv7CQRTtyR5OPbkg-HJQ-C0yXWAt9L4fSJHnncEfRnSXQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Apr 2021 at 15:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.29-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.29-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 18f507c37f338c5d30f58839060d3af0d8504162
* git describe: v5.10.28-42-g18f507c37f33
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.28-42-g18f507c37f33

## No regressions (compared to v5.10.28)

## No fixes (compared to v5.10.28)


## Test result summary
 total: 76017, pass: 63668, fail: 2017, skip: 10100, xfail: 232,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 24 total, 24 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
