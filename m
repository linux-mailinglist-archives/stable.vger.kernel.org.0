Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B1152300D
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 11:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbiEKJ6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 05:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240654AbiEKJ57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 05:57:59 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E65918B11C
        for <stable@vger.kernel.org>; Wed, 11 May 2022 02:57:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s30so2948770ybi.8
        for <stable@vger.kernel.org>; Wed, 11 May 2022 02:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aqlUuH3Mogi7M0OT0eahUUYZoOsvHGZ6FB58g6kt7Gc=;
        b=hrNl55+ilJgq7oFkQ5rh7nP8b7/KHXi2LMl6uMB/Z+smZp+pzK9dIXTTFp3FNJhFTq
         ljrx+/d+AKlwUVN/vfAGvtze99puNYKsKsOBS+p72dq8IXGx55BmuI9UF8+YKBiRzeJ2
         Pkspx2Hd82ke9AjrR40NRQShK1LFjOuQDfzUO7YniwbzcY6kAduYL5TnfYGDkGiMQqSu
         4C5dQyV5QdH/ERk0xQm/YsGe/HXbkJjCgwleIIYAztm/HXwgAxnESCx7GenbMtIp9aaD
         ZLvFxfH5ZUNEAlHvIp7rAsXnMRNdmzYfIDTK2BAqdJdjtwXQd2CeTUzQTAQtfUA5v6/h
         N4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aqlUuH3Mogi7M0OT0eahUUYZoOsvHGZ6FB58g6kt7Gc=;
        b=rp8zL3aCB6j8CBQ2utwI9owFGBowHBwK4ZdBB8PknjjQEAFiy22x1gW+uVsC4b0seC
         4PwhaY31Avx4f7AeYMDZot+x2DS5rzwDB/AbOEZYq7xtva20yKM+hyX20C1nlKNzhUtF
         lW22F1pLXH9dEKbDfuirizkHzrdDMHECp+EMwrhEdq4+rqbxIIFMQOEjZBquuHj0b0dD
         CJ4JlfIyIS3FhyGfQYbSUX6anmX70SszmcFwZKjaOx8lQjqllp9vyUCqK+GtPktwlSsT
         PLAdX/aMxc3lQXIwMQcmyk8we2pSe44t5IDAoUYNCmvS+LzSOjXj391EOgUwTBl4juYz
         fx9w==
X-Gm-Message-State: AOAM531xRnt1O8FAsEUeec9DtZd1yyHn5NE1eMOl+DmAw6z1jygA2fuw
        HfNz0BxCBwS6DzoLy11Ncha0p8nYbZGeKNKm4wsloA==
X-Google-Smtp-Source: ABdhPJwSYL75bn/ktXErx0oAZKnHRhI/Qyh0cZ98CgW3AKClgDSY9J+SzfBLa9pUWvTseDbpseT2G/IEo01keBV8ClE=
X-Received: by 2002:a25:c012:0:b0:648:4912:7b9a with SMTP id
 c18-20020a25c012000000b0064849127b9amr23505071ybf.474.1652263074282; Wed, 11
 May 2022 02:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130733.735278074@linuxfoundation.org>
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 15:27:42 +0530
Message-ID: <CA+G9fYtFv0PVih2FxMUEO3Q--1VQQUsEQ2w6cNh3oH==Bk+rrQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 at 18:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.242-rc1.gz
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
* kernel: 4.19.242-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 71a9ee8b0cfdadb5c55e9205066a83286e709ca3
* git describe: v4.19.241-89-g71a9ee8b0cfd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.241-89-g71a9ee8b0cfd

## Test Regressions (compared to v4.19.241-79-ge28b1117a7ab)
No test regressions found.

## Metric Regressions (compared to v4.19.241-79-ge28b1117a7ab)
No metric regressions found.

## Test Fixes (compared to v4.19.241-79-ge28b1117a7ab)
No test fixes found.

## Metric Fixes (compared to v4.19.241-79-ge28b1117a7ab)
No metric fixes found.

## Test result summary
total: 84759, pass: 68003, fail: 1160, skip: 13643, xfail: 1953

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
