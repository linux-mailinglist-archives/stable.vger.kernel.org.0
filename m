Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8C571CCF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiGLOfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiGLOeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:34:37 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0595BA165
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 07:34:10 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e5so7996734iof.2
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8Qgpcvn1YHDREufZBbmxZHbS2brMn0J4VUDssmHFods=;
        b=q4oeBlaVfxRB59zsPD0JlGgQLtYYZw7vPAgzl60Us73EtUrRq32o715vIJwBZmQIme
         hDzDQn0LUo8I/0ymNkltPD07MFqmPLU9OwQGG3b89gpSdBGjKVWr7xb2NDETwXJpRiei
         AOiM7RjEoN/tk6rdfkxetOTm4Y0t9jF7MC59a5Uv5t+sFPVfXakGXwhNmHIqHybUIkiX
         LHHIfH65bh4+vjPLI1R76e04I901jgYtiN2XWP7feNJ+EG5pb+e34/JOlU+aGMwO9SUO
         h74TrEghWrYO9g0TaPXlcS1yKc4VvADOnFozjJXotbfP9NTn1PL0fsjzBuupd+xpISw6
         Q+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8Qgpcvn1YHDREufZBbmxZHbS2brMn0J4VUDssmHFods=;
        b=t/kjnfnrsncJvqmAsaKPTxlw7pUvjCgiNI3G034BtIqTQwlNZ+xH5aN0x3hLFf/uUY
         Zf8BJWmzfe6NTih4wWpf5mkEHzwF4eylqiMjOAjonzzt/6Wkw1hABY8WwF+QoPUvAs3T
         iy+5Os4+bxs9WOiKWMkQh1WTu7B1SinXBTwc3mtprB1Pe4561kOVs9inVaXzgCQzymtD
         SilW60GRXhTsNHT9IcSUCqboIUOcbeG09QCT8JFu5oeYaLvn7sxH2STwQkvxXARd3VwV
         u5I6dvT2/d0DJcpM24simyk+eQaaMkRtrxI48x5SPwUrwa4HN+YGfC8OllQWiBamC7y7
         pcmg==
X-Gm-Message-State: AJIora85Bx5u1kYakcpp0Vaj0ywsiWpfOFjtkLaEerZW6zfEIRgjU/1+
        ahFbcNtuBRP4uZ0VrXutF/ZahSm8IjZdjl3CwAWTng==
X-Google-Smtp-Source: AGRyM1vDpGJnXqXo7v072Qxw+u+64rqLpWgz9srMYNBmnKBpSgOgYanod3X46hNRBgYNxpFvF+WKBUJiFAZbwctmWK4=
X-Received: by 2002:a05:6638:2a9:b0:33f:2d29:7546 with SMTP id
 d9-20020a05663802a900b0033f2d297546mr13683445jaq.27.1657636450269; Tue, 12
 Jul 2022 07:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220712071513.420542604@linuxfoundation.org>
In-Reply-To: <20220712071513.420542604@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 20:03:58 +0530
Message-ID: <CA+G9fYsnJfX430NbyTzBfiWFQZ23_703WzVdLYuBiCKS7cDtww@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
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

On Tue, 12 Jul 2022 at 12:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Jul 2022 07:13:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.54-rc3.gz
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
* kernel: 5.15.54-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 71721f5974f244f7563d10b616528059705e6237
* git describe: v5.15.53-227-g71721f5974f2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.53-227-g71721f5974f2

## Test Regressions (compared to v5.15.53)
No test regressions found.

## Metric Regressions (compared to v5.15.53)
No metric regressions found.

## Test Fixes (compared to v5.15.53)
No test fixes found.

## Metric Fixes (compared to v5.15.53)
No metric fixes found.

## Test result summary
total: 137871, pass: 124645, fail: 380, skip: 12150, xfail: 696

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 52 passed, 2 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
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
