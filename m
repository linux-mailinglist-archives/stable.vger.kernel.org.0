Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00914B1400
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244816AbiBJRSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:18:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241008AbiBJRSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:18:40 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B627BA2
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:18:40 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id g14so17453249ybs.8
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y6jU5y+7ciw1kZFk2voVGn514q9KLRF2t/AdSLq2qd4=;
        b=kA+EU7zowAhr4Q6p3DR2WaQWW+nlLBUiWTFn/6iEG2XqIU0Jvua7ciIE+flrDSx7CH
         sDKhgfH4W8O+dNAJ2nev5wRYbAZEST6GDKboFkzjFB43X8M7zlX+QwfLa/vs1/EwIzL8
         I25oIP7rzbivJXAWZTNqJo/ySkuw1c5IhDHFz7IFIvb+xtSqtY+PrfvTDnSIYlhqtdjs
         TSglyzVe31PfFPTs3w4vLFzd543RzxMSqTuM8htpmRvYtTeis8o63HdsyVwAeo+tIyzn
         dv6dQvUgRIZQC3LD4TvOHX31y7nuwYywBeDeXJP+y2mbxbp2JUrn79Z1Wqk0QBrLjOfm
         nMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y6jU5y+7ciw1kZFk2voVGn514q9KLRF2t/AdSLq2qd4=;
        b=lpcaANc88TcvB3VYuwRugo2PmCtxlSJPH5e4kAlWXEizxy6CLcmpgcFbmU6zvQp1kc
         YJgHka2UCVaaF8A1fbqX82eX2Vzr4+VoUbUKxpdGCkXl7tXJ9VYFZz5BFi+jlfz7JWec
         rCMr336AINzfClKauR6UpnMXqjAd8KKe9y8yrfWZ0E4QokWb9M11ZxCKSLMQSci4PmZH
         /bcLZci1tk3iKfgtuPBs2w+i6k+bf376DG1l0rQMgiOCR1fUA+NZraPwlpGiBpjrSE/N
         OvpI63odh3EMkUcj6SuX5f3YNFTCK2d7t+lIjbRB6jSix5eYQW8Dwks8oq22Xmu7idu6
         f3mw==
X-Gm-Message-State: AOAM531/z8dw2eyIBMRA+oPeOADT09/pD5x2yJnJC2B/wW1kQ84VW0pr
        56jxejA8R00iwJTmG5N9WC78ILUcJZUpkhzy/1/OJw==
X-Google-Smtp-Source: ABdhPJyeRA3e502ZxR+L51J3Klgeehjbwyny/IdqqMZuHjSZtFufytlLUNoKGN3UeoZgnfritSbpsz/suGfpi2djVWk=
X-Received: by 2002:a25:49c5:: with SMTP id w188mr7757635yba.200.1644513519410;
 Thu, 10 Feb 2022 09:18:39 -0800 (PST)
MIME-Version: 1.0
References: <20220209191248.596319706@linuxfoundation.org>
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Feb 2022 22:48:28 +0530
Message-ID: <CA+G9fYv8ejt_OrujMXdUv3Hgc-BrSFpeZJYx+LEGZoj0eNPDSA@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
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

On Thu, 10 Feb 2022 at 00:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.229-rc1.gz
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
* kernel: 4.19.229-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 020dc380ec76524a264536664d516a5a4d7cd45d
* git describe: v4.19.227-90-g020dc380ec76
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.227-90-g020dc380ec76

## Test Regressions (compared to v4.19.227-87-gb06b07466af8)
No test regressions found.

## Metric Regressions (compared to v4.19.227-87-gb06b07466af8)
No metric regressions found.

## Test Fixes (compared to v4.19.227-87-gb06b07466af8)
No test fixes found.

## Metric Fixes (compared to v4.19.227-87-gb06b07466af8)
No metric fixes found.

## Test result summary
total: 61877, pass: 52177, fail: 270, skip: 8370, xfail: 1060

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 39 passed, 13 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-net
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
