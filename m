Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB02E44DBB8
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhKKSrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbhKKSrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 13:47:19 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD26EC061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:44:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so27882295edd.10
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VI6SG8jp9Q0ipx0iOq/j7H0ARXMUhCuktm9ozcxJySY=;
        b=pNT9reS7363H+OP4J5rOpJ9dWe0+hgMF7XTHmuq5xjOXQw36ddKw/L33XrlGfwDrgP
         T4ChJELO6UnRW5amptKzdw9Dt9w7Ypji5rwddWptZWtuQLsfp9d5sBwuKG1Jkv4s85hp
         mYKHKHRxAQX6NCcz5uxKD4+9UtBo9+dw29+BBbO8pG5X69sPCHdJsgtlyezxghYtkBO1
         I7baPs9l3YPwHlAVzQ5YcAVkkrK6g8hsIy3aYPKJTPrCzqJgUZgVlxkHozt4dDXr6O18
         eUWLB5u/j0O3CfkPCuobe2rdRNyPNI/H66Jt5OgHczKgczpRnUMqt55LiVJXw+q6bLjF
         i7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VI6SG8jp9Q0ipx0iOq/j7H0ARXMUhCuktm9ozcxJySY=;
        b=RmkrThFVxwG6yrEJkC+FYjomCEgmc1CNMEfsPufjuQI6sn3QK0ZeXh8xjwcedvu/oR
         0tyeLOOeL+o5VObUmxErGrvlPt1EwmuXhyboZ7Ib+IYxb/i7432xRYdUIPzQEKcQgIL/
         fAkSFuiwgXP1Gk4GcHq1ywBqwA9lotUGVD0/VmMvf2eGWsFr5GAsyZR1R56MPhsCsX0I
         Bg8vzPZLb/71AM+I7bqNh66VbXMMM7Hyj4+eWc13v8Z5yHIHTS3Ei5McDAWbHU+DYk9s
         u/7Zw8d7FORaWhhm/csfV0mAazdtc0zaF5CVehHSoI2NzCYllAsIK7lhODc7TiOAtlTI
         2o7g==
X-Gm-Message-State: AOAM533YMj9AZLoQ3qtNmsRfqKx2n4vUp5jdBSzPyZQ0Lla06sFzd7fk
        llikardnQt878fExcKh9ZKmgfQfviUJbHFLOwiEI6g==
X-Google-Smtp-Source: ABdhPJxMawge1bY/85rRHG/hzrOjTFgkJ/Y+5H4TdIyn7TOJJLoskkSwZxvSvSi3v6wuCENwi2/RZG7y3WLenlQCjcA=
X-Received: by 2002:a05:6402:2815:: with SMTP id h21mr12766093ede.288.1636656268170;
 Thu, 11 Nov 2021 10:44:28 -0800 (PST)
MIME-Version: 1.0
References: <20211110182001.257350381@linuxfoundation.org>
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 12 Nov 2021 00:14:16 +0530
Message-ID: <CA+G9fYvnHTY815vgrcEXDvuzmKOP2i67-+8sONdc6vOEQmAnWA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/19] 4.4.292-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Nov 2021 at 00:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.292 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.292-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.292-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 17cdd7c2c6dc2863ed141af8f99ff09851164bc6
* git describe: v4.4.291-20-g17cdd7c2c6dc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
91-20-g17cdd7c2c6dc

## No regressions (compared to v4.4.291-3-g59c6c12a4647)

## No fixes (compared to v4.4.291-3-g59c6c12a4647)

## Test result summary
total: 38927, pass: 30852, fail: 150, skip: 6960, xfail: 965

## Build Summary
* arm: 129 total, 106 passed, 23 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-membarrier
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
