Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78A441413F
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhIVFcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhIVFcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:32:19 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF0FC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:30:49 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dj4so5285727edb.5
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mN1NN5IAzxhGkknG+jYLu+obwMIPkutmhLZ+ditcU3I=;
        b=sOW3suyzLAXgGpeEABFF6kqJBgIw2YGLN+2LzcfhwKRiI33AeL9HcCP0zolka5oIGQ
         l5IqpRE9iJDuenNNqaBTrsDv38/HDhxAI/XA+HaU7hEDtA4+mevl7wyar5o8NIE/ntix
         EDrJLlWQIDfsU57yCuWntSSn4BqJruWDjo5pxvok5t46IwYhca8OiImzILQ2n4z4jj9P
         4fyy5q1eaRJHbgaclr1vPRUB7VTt+rU79QGj2IglNP+kBE9QcdFTjLl36KHGtdJtCFJk
         ZfR6jpJs80TK1DFGa/PhqE9FK4f5IcgY98fu/j3PhvXs+/ocd9/Mc2AQMvi7wbPmmKcd
         f6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mN1NN5IAzxhGkknG+jYLu+obwMIPkutmhLZ+ditcU3I=;
        b=HQW7S32WX/paJ9h9X+po3mH/Hy5yMU0tANgObzW8DjIZBLcDRAwNXDlpfM2ckwvgTi
         8/UtU1Vm+0Qlpuk1xBN1Qyo0N0beyhInALNgVXbGX5HBAbYwd+uf7ozdZJJl6Scg5b+9
         1OfgbE34EIhXioPQJTWy8LLSQYF1M9RTUvVzdaRTiBFrUx25ljKVG1hlmd7/hwQ5E5o0
         kL4psuUHpWbKWG8rItQ7uPDZRpMJNaF0d2YnIKfEV2Vb9XtCIkhTNFf3w/SFIkcna1HK
         5ucnNjW5GpKql+8BUklL7mkK9xOA+TKHMo/jsV+nEvZQ10ZKNfh4Xbsx60ogI7Y7gN2r
         80kg==
X-Gm-Message-State: AOAM531JwoE0dwiuU0Ba5oFXnVQCcETEA+gc0u1i8zsSK+b2HHQVJ6OE
        V8csFrQONDf5/GS/RJ1EolyJKXj9apDyNMruavA7pA==
X-Google-Smtp-Source: ABdhPJxNSfdMzC7thHj4Z6kgwNi/idP3NyUcnzOVRkkDRfgXNoorNum/1Chu59vTrx51fI3enh3n+W3h9/b0Ic0do3Q=
X-Received: by 2002:aa7:db4d:: with SMTP id n13mr40507245edt.398.1632288648412;
 Tue, 21 Sep 2021 22:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163915.757887582@linuxfoundation.org> <a9ff4972-335f-5a3d-221d-6dcc294cd233@linaro.org>
In-Reply-To: <a9ff4972-335f-5a3d-221d-6dcc294cd233@linaro.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:00:36 +0530
Message-ID: <CA+G9fYvtMHUQhOgdLq6gcgjMS0utG3eR5+a9HBvduARE6LooBg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Sept 2021 at 10:25, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
>
> Hello!
>
> On 9/20/21 11:42 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.68 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.68-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro's test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> ## Build
> * kernel: 5.10.68-rc1
> * git: ['https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc', =
'https://gitlab.com/Linaro/lkft/users/daniel.diaz/linux']
> * git branch: linux-5.10.y
> * git commit: bb6d31464809e017d8cfd65963f6e802d7d1c66b
> * git describe: v5.10.67-125-gbb6d31464809
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-=
5.10.y/build/v5.10.67-125-gbb6d31464809
>
> ## No regressions (compared to v5.10.67)
>
> ## No fixes (compared to v5.10.67)
>
> ## Test result summary
> total: 164462, pass: 138894, fail: 765, skip: 23000, xfail: 1803
>
> ## Build Summary
> * arc: 20 total, 20 passed, 0 failed
> * arm: 578 total, 578 passed, 0 failed
> * arm64: 77 total, 77 passed, 0 failed
> * dragonboard-410c: 1 total, 1 passed, 0 failed
> * hi6220-hikey: 1 total, 1 passed, 0 failed
> * i386: 75 total, 75 passed, 0 failed
> * juno-r2: 1 total, 1 passed, 0 failed
> * mips: 102 total, 102 passed, 0 failed
> * parisc: 24 total, 24 passed, 0 failed
> * powerpc: 72 total, 70 passed, 2 failed
> * riscv: 60 total, 60 passed, 0 failed
> * s390: 36 total, 36 passed, 0 failed
> * sh: 48 total, 48 passed, 0 failed
> * sparc: 24 total, 24 passed, 0 failed
> * x15: 1 total, 1 passed, 0 failed
> * x86: 1 total, 1 passed, 0 failed
> * x86_64: 77 total, 77 passed, 0 failed
>
> ## Test suites summary
> * fwts
> * install-android-platform-tools-r2600
> * kselftest-android
> * kselftest-arm64
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
> * prep-tmp-disk
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
