Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E203645A7A
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 14:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLGNK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 08:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLGNKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 08:10:53 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE0578F3
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 05:10:51 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o12so12582912qvn.3
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 05:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsLHBdKnFFD9xoYne3FhwA6YlwsQ45KU43rTHiw+YBc=;
        b=fm7sK96F3OVQuWPqvs/UoPQ98MqTjJjE+HbF1kfiIKygxiFQIfarXEHT3Wp8mzyKmy
         /WX+xn9EpdA1s4+QPcfS5E07ZPTinzLksqBzwskNMAtZttqF+I0A/8+7ihn5Q1TBCN1w
         UkPUJQ3tiSVs68xzntl65WyaO21I+LxMzcbx16t8dN84HefpI6MXCtXY0KI+aW1ApYuA
         5Tqh37vSj/fYP/NnalOn9nk6cdNPAId5exTW54wDbZGq/u/fepJMx5pK4rRqC222iSQ7
         MeAnh6wiBBtFXO5zLdOkQ52nSRZP5A5KrPxaYFcEEAuzNGt8QAZKmMLbL3rJOH0aQ5WF
         cP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tsLHBdKnFFD9xoYne3FhwA6YlwsQ45KU43rTHiw+YBc=;
        b=4NEp/YsC6G/atlLzwgkx1HheC9tpOEb72utJ6pjzLW0mVac+HtHTFUAcnoWaD1IyQr
         YbqB+C9SJ77Evh1kgM9YXh7n64MUxuUZjVO+Y61UgtiWCCe6DpZl7E3L1bsmqdzdMYQb
         /LrUVAkb6bcB94sKZctA/NKX4P6qoc49le027CBQ27u5H0VFmL60hoY2tTEK/+tDBYhX
         aQpoJIJ13UB/lRFqOPrhXjjok2sQGl9uOBOwzdk+sqZXlHK+RePjdnBHyrY3cyFnncQw
         5bYuUmsnLDAhu6JBwyiCs+13xtTPDeOlsezCOSOgpi7JkCE89l9lSHUQYPF4SJJaGrsk
         sCEg==
X-Gm-Message-State: ANoB5pkz2U4BCvRktJYipvHkk+S/vvyB7Olso6waWhkM5OI/yTcYf7Fw
        IIKx+bpAXMHxIcdSZwSJcuiwN0sTkR+ClFQ9tQd5EQ==
X-Google-Smtp-Source: AA0mqf5iXU8Nz6e2EmRbp9ZhR4aHLhWCSpzRjcKfnBu/hfvkq0kMvrHBMRthP+pKK2WWrEMg/K49DzTLxCXTnrYHqj4=
X-Received: by 2002:a0c:f947:0:b0:4c7:8c20:9ec1 with SMTP id
 i7-20020a0cf947000000b004c78c209ec1mr3861905qvo.91.1670418650763; Wed, 07 Dec
 2022 05:10:50 -0800 (PST)
MIME-Version: 1.0
References: <20221206124043.386388226@linuxfoundation.org>
In-Reply-To: <20221206124043.386388226@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 18:40:39 +0530
Message-ID: <CA+G9fYvaW4d54mH_G5uRoK5GhV9YH4cFvPidywptX=-+L6gL2A@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/63] 4.9.335-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.335 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.335-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.335-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 5e545e94a55985ee074b9d08e986e7a397e14a39
* git describe: v4.9.334-64-g5e545e94a559
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
34-64-g5e545e94a559

## Test Regressions (compared to v4.9.333-76-gce705e13578d)

## Metric Regressions (compared to v4.9.333-76-gce705e13578d)

## Test Fixes (compared to v4.9.333-76-gce705e13578d)

## Metric Fixes (compared to v4.9.333-76-gce705e13578d)

## Test result summary
total: 23340, pass: 20077, fail: 273, skip: 2462, xfail: 528

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 280 total, 277 passed, 3 failed
* arm64: 51 total, 46 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
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
* kselftest-x86
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
