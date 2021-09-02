Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C1A3FF0BD
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346122AbhIBQJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346072AbhIBQJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 12:09:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61688C061757
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 09:08:16 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jg16so2454030ejc.1
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S0ajZ2VNAYwDIqSVd1wT1W70FRDjI5EWvVquCfpXzsA=;
        b=SNZAw46IwZUsqZQAuD3hUXFtYWhFCgxlXIfgDhc3sa7uqqcH++MpOYZBn2Y7jc/TsR
         +L952bGZPvknst8nrqlr6w5h+9za0HjK1eB7d9jo8rSbDUGsCCLh9Rs+QyFSOHqTvtYv
         j+rnbIhT/34JC3b4RvLyS2idX2PCVkxUxjFL3Fd0A2J3T1PvMvF7WXT79qpZ+slfEKXD
         quM/KfbU0sYZ8niM1Br/1qyC/AYPmjgIzc5cyHimzJrr5GRQRVNUGELoH4nBfdlHT+xV
         BNtJCgPaw4QSx8dJeLDlCu27mGLWhRBqLXNL8aEtNoCMv0VhGhvUXdD6JA0yAAnIW/qp
         ThvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S0ajZ2VNAYwDIqSVd1wT1W70FRDjI5EWvVquCfpXzsA=;
        b=NVSAD5tlQ0rlbBOjc+im01R+JNFDRQFPOW8KCkxpeesgA2tUEWhUSAcrRrX8sUSVBH
         WUcbo7ABYWzAl9ZVMT6GC79y4QSL6sywkN+XX4IYeAac2VOajnuji4S98DLMolEOq00U
         1fd+NbOraUEagQt6dBjDNrvD7Re9DvsQ8llT9PqRrI9eEtXmiO2kQNw4LtRxtO1Re/ZH
         6CTPhrEEx000T0JrzGjLw8m+gEmjciJfHqQUnMzYJezONFCHoxWSxE0/+GEH9jb2XyVO
         Km3I+AGeN85IhEk6o1WGzAyYpwCE5v4QsKj3W8mBq8AdT8kQOIs51hKS5eXbqv5TWzE9
         2ADw==
X-Gm-Message-State: AOAM530cF4uSIPRmA6kF5/aFBFxI7AhhIH6JX1gQbD4juTt+zHG8I682
        P+/4I2x8hPEp7+FH28TlW5rEaz1whC8XGXm5cqlGMA==
X-Google-Smtp-Source: ABdhPJz7in+2dSrpTvKLUc9Ca/1jAX9Wr34OWEJUpo2Mc0xgpsGWKdkFKZhwMxgqg2KMRmqfGXSHZT/zAQPhJHtmWtk=
X-Received: by 2002:a17:906:68c2:: with SMTP id y2mr4637107ejr.18.1630598894804;
 Thu, 02 Sep 2021 09:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122249.786673285@linuxfoundation.org>
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 21:38:02 +0530
Message-ID: <CA+G9fYtL3sR7z5dG3uNSqHgoMHmOL-vMGm0sm-TsCR_-swZT9Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/23] 4.14.246-rc1 review
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

On Wed, 1 Sept 2021 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.246 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.246-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.246-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 8626d0e3c8af623e879dbd8b5f327f8adedd85c6
* git describe: v4.14.245-24-g8626d0e3c8af
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.245-24-g8626d0e3c8af

## No regressions (compared to v4.14.245-13-gcc28263d7625)

## No fixes (compared to v4.14.245-13-gcc28263d7625)


## Test result summary
total: 75373, pass: 59981, fail: 873, skip: 12600, xfail: 1919

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
