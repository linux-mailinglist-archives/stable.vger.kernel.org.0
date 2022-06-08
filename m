Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88902543914
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiFHQb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 12:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245758AbiFHQbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 12:31:37 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516B2271462
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 09:30:41 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ff7b90e635so215010827b3.5
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7jCf9kh+w2wBvhpYWweJlGE2pIWfuHnKtDVg3jxSlSs=;
        b=XewhoJLSV2aHlXN82vIBql+c/rldTyuBBp7nO8lSWgl+NIg+tSBnRQeW5S8AhFwS/8
         +4Eg6crwP3m3gEKVKIVaWOYAoGWT1QqnuaBA5EoTZ1JfvZEaCWXy/DPj06ArQlXdSEvY
         wqJz4AvRY061Cs4h/gf2yKt2FJbUkFCpwqwgja70FQ9DxOgsfKw6zzmIJIdSncDzHVa6
         NBX9l3o+vv9pt1UgDhdPztOhSqRFonex7dLktwMhLKLkNserD5x4QVOjpZ9pl095/HSL
         Lxk4e2NgGQhdcAjjwLc+EaGz5OJSA6zg6HgzpEIfOJzic8/pkamFAGGUtky3G1l5VIqk
         F5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7jCf9kh+w2wBvhpYWweJlGE2pIWfuHnKtDVg3jxSlSs=;
        b=hBHuLmLNSJFlTwd+8aInyNaVfdIyMfcCHUq/kZXXvRRBd36tZw97KzSHKJ/ikHIgej
         9mPAEDlaK680heu/emgoTaCCggiGynP3GBvqG+AW2ZRozyov3/vfb70J/HCVlKyAfEcu
         L4x/lIxloqWcL4nNNl+ffTEvFnMEmS5JHsebC86mcx500Q+TWVN/9s2YHtEqtYHks0xw
         KU6GRHnAlmDzcINbsJssJw+03SIdzVPsneTfjoQhcAsW2eU0F5zROU+tPunTk+3ZhYZk
         B4P4FqPTH3z+n8yF1F9sQEDrS5fYLJ3zhYJVaAH4/gUWAflz4tgYxto25woO8B08xHlY
         BqZg==
X-Gm-Message-State: AOAM533fUdXmIBLbc6nMOMKSJLmwQKhsAo2ByvTAuinbk9RUew35CCTU
        5iu1lXp+q6jCV/q2/sBeNsBrVmVhOht31CIsbbgmMw==
X-Google-Smtp-Source: ABdhPJz+6NhqOhsX83adrCp/KtBqfF+yFjKShD9tyLaUf5ABu69f0tvaKKo92lokEoDtHksQKk9/yIGjll44uuCHIbA=
X-Received: by 2002:a81:7783:0:b0:2fe:e20c:5dd6 with SMTP id
 s125-20020a817783000000b002fee20c5dd6mr37144167ywc.441.1654705833171; Wed, 08
 Jun 2022 09:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164934.766888869@linuxfoundation.org>
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jun 2022 22:00:20 +0530
Message-ID: <CA+G9fYtvN5bB-o916NM1Nmr=ZsczbNXh-Z9NV1Uso6p7bHQf5A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Jun 2022 at 23:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.46 release.
> There are 667 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.46-rc1.gz
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
* kernel: 5.15.46-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 53f46ca17ebdfbda0ddab0ba7aaad7c9b2493f02
* git describe: v5.15.45-668-g53f46ca17ebd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.45-668-g53f46ca17ebd

## Test Regressions (compared to v5.15.43-213-g207ca688162d)
No test regressions found.

## Metric Regressions (compared to v5.15.43-213-g207ca688162d)
No metric regressions found.

## Test Fixes (compared to v5.15.43-213-g207ca688162d)
No test fixes found.

## Metric Fixes (compared to v5.15.43-213-g207ca688162d)
No metric fixes found.

## Test result summary
total: 135584, pass: 122903, fail: 248, skip: 11845, xfail: 588

## Build Summary
* arm: 17 total, 14 passed, 3 failed
* arm64: 20 total, 20 passed, 0 failed
* i386: 17 total, 12 passed, 5 failed
* mips: 4 total, 1 passed, 3 failed
* parisc: 2 total, 2 passed, 0 failed
* powerpc: 5 total, 2 passed, 3 failed
* riscv: 5 total, 5 passed, 0 failed
* s390: 5 total, 2 passed, 3 failed
* sh: 2 total, 0 passed, 2 failed
* sparc: 2 total, 2 passed, 0 failed
* x86_64: 20 total, 20 passed, 0 failed

## Test suites summary
* fwts
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
