Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F353D4AD2D8
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiBHIKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348907AbiBHIKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:10:00 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662AC0401F4
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 00:09:59 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id g14so47484954ybs.8
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 00:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bLl0JJQpx3VT/7k/lVGpwYjdhHk/5YKncSo5G08KJEk=;
        b=DU5xsxyvI1jqnE8bKjY0OLS0NsSNgWai/ptCdWLK3TI4sOMi+6xU1VUhMmMJaNK5uj
         63tiX0PevGWIV8EzXLyAb1lGPFmCytd0TytasLdztgiEL957YpsWSKlLj/A0D6abc3/J
         Pyeth1VEA/sIZ+IdpIBhBAuQZ/PCngYYX+Jv+hrtlBM2ViP5vpUdaMp+tKKVZsxafvYI
         zRk6ruVDZ0J/6ZEychbXnmfNqC96lo/EsDVIQnS25VcezPgu1YvUXdJV9gpC5XO4Mydk
         hMtNQrWq6m9CLpTxpGNxyUr2GGyE/B61QhAaiN6ipJpYGYzWMY3IJK7VxZn9frPuIlUW
         dWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bLl0JJQpx3VT/7k/lVGpwYjdhHk/5YKncSo5G08KJEk=;
        b=S4mgEtzR9rAPfqsnfp6BXXqhA4vz2Q4oAq2PD1j3iLaAyW8R8iQq3w/6rZQbwMTIW9
         A5TFnJG5COc1Qq4ZQgoQiieGN56n2gg62ru+evFu6LD42Q6pcOmrws3928MAP4dx8PPa
         AnqxsKiwMLvZxFvBEAqconBneGbYWlYKj0j5yc3u8yXomMGOzCfpi86zulh/bY0gUq5w
         gNW/sVEfhZv1TOY8KZgazifvqR0Mpjs9VFFkHOTw7n7BxyFXUubZP8K5b4DCxKKDk4p2
         qRTCjyz6sTOI+zQymyASDOBGSUS6TMq+ltHl4qU/zreGw+Bq6EZTAzQlpzYlktTlWDS2
         nuQA==
X-Gm-Message-State: AOAM5307arQY+pQRGdnsoX/hilqi/g+Yx2Nl8634xN+17qDAn4TK812Q
        CVJwHPDzXhNkT/onsyPlgk5HO1hPmwNKz+9zo9dH6T7luu8CSw==
X-Google-Smtp-Source: ABdhPJwuuJv9wlhTlzweDM2oR2lT9WpraZTfba2ypaRff/IL5875UBTx7iLSnzCY7+nzuLvQb2whvn2VnVg9qfBeGgw=
X-Received: by 2002:a25:49c5:: with SMTP id w188mr3501478yba.200.1644307798270;
 Tue, 08 Feb 2022 00:09:58 -0800 (PST)
MIME-Version: 1.0
References: <20220207103753.155627314@linuxfoundation.org>
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 13:39:47 +0530
Message-ID: <CA+G9fYs5bPiAA0M0=sQvxCxVcaz1Y+bDb0zy1+5dCMOFJjshdw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
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

On Mon, 7 Feb 2022 at 16:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.178-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.178-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 3836147e31ee95815758c97dc5c319423774464d
* git describe: v5.4.177-45-g3836147e31ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
77-45-g3836147e31ee

## Test Regressions (compared to v5.4.177)
No test regressions found.

## Metric Regressions (compared to v5.4.177)
No metric regressions found.

## Test Fixes (compared to v5.4.177)
No test fixes found.

## Metric Fixes (compared to v5.4.177)
No metric fixes found.

## Test result summary
total: 92667, pass: 77078, fail: 737, skip: 13409, xfail: 1443

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 257 total, 257 passed, 0 failed
* arm64: 36 total, 31 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* kselftest[
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
