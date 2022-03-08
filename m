Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C974D1149
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 08:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiCHHuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 02:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiCHHuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 02:50:11 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250482CC8B
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 23:49:15 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id u3so36081541ybh.5
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 23:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=40EmYTTIomeX7TzfIEe2vYYWMDzXTWiSdDEcMc062K8=;
        b=Cgidica2ibZa4w3fd+nNxtUlV77lQIYWY+MzdRZcrC45BLIMN+pF7/ZMc+9I2TUkiU
         W6xNxCGwNJ/t7S9ehf0y/y7z9qEZgz6SU13q08OMNJC1ld1oGalqd4soFERqcStGY6Tj
         3VnBauweev28twGB+GMguguP+ZRa+SmdOnPVd0jhq5ogAB3mjADviYGHs9s84NJ7pIlC
         5SNwurYE1ds06Na84fJu9TFy71IfZiIEHi0/7YSIgp+fhxTt2ozVb7+4qsIl2xIBQ8DY
         pTKwKleMFW62/eQ3KqONNTFInK6Tdf3XNccVN+ps4TgnJXalikv8BTPw6xMPKA+joddp
         iFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=40EmYTTIomeX7TzfIEe2vYYWMDzXTWiSdDEcMc062K8=;
        b=ZX8SmNFyujvK/5gDqJoYmwL392AEqbAGWJLFYr/TZkbuL/V2MQNZtO5nFS3MANaIoa
         zBNQmsguqAQh7QIfI5lhDi1FQYciMsztSIi3IBwtLR6+biTHoJe/wkzlnIA/32iO9+Bo
         QHI7tVVxfkVdp7mbgjMKbys//V5HS6KHi2hXRyvUugPx4IkZKVHuulxHLiBmRE54qfN3
         X9W4XuZTjH/GTvrXtGb3Z03o3T49dYqNPo9igx3HZVA+uZy2IR+ykLHVbEwZFMGc5EV1
         BRIBmJynZZsJ2IAFpqK8H5ZUA5bIflBFAOC+4+OM2jWGTjfgVo8TAHA+ywFERbWqHx71
         CpGQ==
X-Gm-Message-State: AOAM531tNy2jkdHO9fY172HkBhQQneIqCoPEmMk6rc5gB7gfQOf2k6BG
        xZ1WCMYgXhLwnlkhaGYrbqAnJuIlLdlVXM9EEZrgUA==
X-Google-Smtp-Source: ABdhPJyq17uBFCUdvAOi8orNnkSO+/W/4WH6LfCArQ71XExpFYKbWDWgeQ/STzuPpVjL57KHz9LTwht2a6ndzsFVfnY=
X-Received: by 2002:a25:5090:0:b0:628:b76b:b9d3 with SMTP id
 e138-20020a255090000000b00628b76bb9d3mr11412913ybb.128.1646725754118; Mon, 07
 Mar 2022 23:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20220307162207.188028559@linuxfoundation.org>
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 13:19:03 +0530
Message-ID: <CA+G9fYtwVyn5Y_hwmQi_wg5TkDj_TMD8AuvnY5Y0AYApq7PjWw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Mar 2022 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.27-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.27-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 7b9aacd770fa105a0a5f0be43bc72ce176d30331
* git describe: v5.15.26-258-g7b9aacd770fa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.26-258-g7b9aacd770fa

## Test Regressions (compared to v5.15.26-246-ged373242c999)
No test regressions found.

## Metric Regressions (compared to v5.15.26-246-ged373242c999)
No metric regressions found.

## Test Fixes (compared to v5.15.26-246-ged373242c999)
No test fixes found.

## Metric Fixes (compared to v5.15.26-246-ged373242c999)
No metric fixes found.

## Test result summary
total: 110908, pass: 93729, fail: 1108, skip: 14897, xfail: 1174

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 37 passed, 4 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
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
* ltp-ma[
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
* v4l2-compl[
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
