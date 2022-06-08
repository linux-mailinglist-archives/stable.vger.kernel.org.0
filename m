Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF145431F7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbiFHNy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240523AbiFHNy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:54:26 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA0B99805
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 06:54:25 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r1so8046410ybd.4
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 06:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QffLOMVkq4vPGOpmsNiz3TpRhqQHTgTu4YdXcc6LKCA=;
        b=D9yWToWQN/B+5vQmx5zsbm1ZiYMjYstGza9HxeAzjnPSPfHdZGra3wOUA7LVYJxBRl
         qGXOUXd5tFSWbUPT1gOwsOOQbQtFePybdzlZeLN+tlIk070wCHEoGtoh/qOw+3Mtmlax
         POL/HF+z72OgtymNSsNkEiJRFSS5t/HjfmfLCV0ZhqmvwXVQM3xcQvi99lvFAMTHoO+u
         cTeKY63Iy0wCw3FJONb7JsqpqHNEMngrxpEjfXY7RveWTg+5dXv36djtn6DoWnU4coJR
         ocR1sJpxdzVW0zQ5E3oFUEdBIgbPq5HLPwOcJH7UqzWG9vJjoqJMxM3SJQH5YC40Vsh1
         vi5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QffLOMVkq4vPGOpmsNiz3TpRhqQHTgTu4YdXcc6LKCA=;
        b=D0fzam+LoWoyizxLb6W6UJAWQvtpRVe95UAhxJ9ZCQP+/z8HXy6wwKskpIkK8eKy+L
         DanD1nM3QMuHd2mzlfdB68A+QdxlBybltduUs/hOQZC1Jqn6oXDiJErQPoaOP2JtKu1j
         xIND1T8UEfIgoxYZ2RCwFxOaDoAZK9H7OJFyexzTci4ENMtzmZD1lac764vSPM+KWMxD
         BUvAep3m2+0iYqjI59TUtSIxB5qz+aZOzFQiADPXj9YwKTDAath7AlT1j6Jk0/cfI76w
         WCYnSuRAXEmcQHluDzOEd6PUsLxFrn+t5OEAVBxqri6EJqrdIDYVES7KXJ0nsGlSoCv2
         jlAw==
X-Gm-Message-State: AOAM532D4opHhBw+2PpryQTERHtVtNfWv1O0RxDQTieDQ1EzCuH2x2Sn
        TIhm34E1YUZt9cuxpJooeNSb2Jt+BIDEX5kzdJ+kMA==
X-Google-Smtp-Source: ABdhPJz4iF1FvuNuWOrkjJQFbgs3+fIz5GRDdVeYhPBRlNnFUguU8wgPyUKch+ezqzYSA+ke6pvHFtAtBAhGVnpiI9M=
X-Received: by 2002:a25:4705:0:b0:65d:43f8:5652 with SMTP id
 u5-20020a254705000000b0065d43f85652mr34234204yba.389.1654696464028; Wed, 08
 Jun 2022 06:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164948.980838585@linuxfoundation.org>
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jun 2022 19:24:12 +0530
Message-ID: <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Tue, 7 Jun 2022 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.14 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Regressions found on qemu_x86_64:
  - kunit/kasan [1]

Regressions found on qemu_i386:
  - kunit/kfence [2]
  - kunit/test_out_of_bounds_read

We will bisect and let you know more details about this reported problem.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v=
5.17.13-773-gd0f9b2818e1e/testrun/10038101/suite/kunit/test/kasan/details/
[2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v=
5.17.13-773-gd0f9b2818e1e/testrun/10038215/suite/kunit/test/kfence/details/

## Build
* kernel: 5.17.14-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: d0f9b2818e1e4d43847e10d6e5310a0c653cb18f
* git describe: v5.17.13-773-gd0f9b2818e1e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.13-773-gd0f9b2818e1e

## Test Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
Regressions found on qemu_x86_64:
  - kunit/kasan [1]

Regressions found on qemu_i386:
  - kunit/kfence [2]
  - kunit/test_out_of_bounds_read

## Metric Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
No metric regressions found.

## Test Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
No test fixes found.

## Metric Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
No metric fixes found.

## Test result summary
total: 134591, pass: 121555, fail: 447, skip: 11730, xfail: 859

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
