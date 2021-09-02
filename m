Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E853FEFAC
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhIBOsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 10:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhIBOsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 10:48:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EABC061757
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 07:47:32 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ia27so4951117ejc.10
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3iSqlQ/ZK7ej3EgME7wgA6neQcA0t8xpPoHGdJFmKws=;
        b=KXkwS+++0r7fEjFg2TNH76VwQiYENXwpvlgnBbgDP4CHN8InzCTBkIcPRiYSQooGLq
         url3jbr31iRcFtsfAQsFzQz8kqaIXyNOduJNo2z+Y+JGxMGVYWZb3K8BXCt0LnOfCDYv
         3jY01JKZ1GMXAbydMif8nQA4JwV5pAP24wtSR4fBkep0/OS3Ef2MiSy5IITWACmNnWmZ
         LLSt8y/4TIt6vsZXLLyd+YpwBGIZG43j5u0m834kr+oFr/TVE8UFQffxhlvkvWloY4E6
         uY9zvEnVwlIaYxYUEPhUzPdzhC7FT+HQckY4ONE3g43FcbIdSZLsKTGrrh0vtwrrHoFb
         R1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3iSqlQ/ZK7ej3EgME7wgA6neQcA0t8xpPoHGdJFmKws=;
        b=AxOhA3b8FF6zuWth/ciDRM0kJPlTiKi8asLX8OSsJu5MUQ0K7mErhLXkxLJ3rb9fQu
         EfCr+8R4ovvdJmWo0/qXOKRJMUETh3qQiMxnOqpj9JNw9IgeM0oZwtSkq/UyG2fdwsCN
         rs/EdOYMSMDF3Z+KsCyPDyHrRZi/yR/UhCbj4XX5S8m5JhgU9Po7eHhTyST7mEb2FTAf
         yYrr+qj4rUs63y21oSp4lJAv1MdSA8MBVDP2Y2WZ+2ayzmiUSW+rhx/T2FmkIawTvJ2z
         p4zWH3WZYxl4qy+m4gcu/PJrd6ymMSsIPHHPD6t/tmnUQWKlmRWYgEUqbZ8oGbRhMmsc
         +OZQ==
X-Gm-Message-State: AOAM530WV4sekuTr8QPJTxBJ27jYzyrne0iqwIFUMv478Z081XMdx57m
        eyZxqro3UFsPFtB7qicwX1XlQw8cS4f3HQ3RpKSbRw==
X-Google-Smtp-Source: ABdhPJxl6e1pbmRDpPaHV3/ARZv+hnd5d3DHYn2gMiQk/sb1dX7govEf48du4nht8BaHJ4UIoXO53b9QxyIzZZyP0YI=
X-Received: by 2002:a17:906:68c2:: with SMTP id y2mr4249459ejr.18.1630594050694;
 Thu, 02 Sep 2021 07:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122250.752620302@linuxfoundation.org>
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 20:17:19 +0530
Message-ID: <CA+G9fYvnv_U=smgN34uX2uox95+T_iLhTG_QZeO_Zn4d2twVbw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/33] 4.19.206-rc1 review
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

On Wed, 1 Sept 2021 at 18:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.206 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.206-rc1.gz
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

## Build
* kernel: 4.19.206-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: fc1fd7aed81d18bc92d0e096033e11161cea98aa
* git describe: v4.19.205-34-gfc1fd7aed81d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.205-34-gfc1fd7aed81d

## No regressions (compared to v4.19.205-20-g0ec64a47cbb1)

## No fixes (compared to v4.19.205-20-g0ec64a47cbb1)

## Test result summary
total: 80130, pass: 64266, fail: 784, skip: 13234, xfail: 1846

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 41 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
