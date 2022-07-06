Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD7567FBE
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGFHWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiGFHWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:22:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B7B13E0A
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 00:22:22 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h85so13266446iof.4
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 00:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LWP0EkYAFx4PugNtgV/U+l7margof7tLaaJFsktZvHc=;
        b=JIud/HruAF050J0/GoKoXx2odR25dkkMlotf7RE3iqKX+v+pIo1HFItO5WbLLXvv/i
         qtIWlIWKpwtS4vEocGK5/q4JLhtr1DA54Y1Smq6dvt6sorWi19UboU7kIVx3rpip2obx
         zmBTf4MRKIUb7tAdAepx12yUF5w/3AlVy7WV9vi4T916UBSw+HOyUjKtE5aThWeQ+IWD
         oZ7s1Nz7WGjZwvWrTxMuaGzIZiQm0klAlV8gwaJtYdqOoEEFtx5gtVN1xuNvo1ZQLcJX
         hCEMhsmVskNbrN1sXzN4Bkfuhz7AloZ1mLh1gmrEzVzdnJlgbqqFcNNCZq90fOQAMm9K
         3pNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LWP0EkYAFx4PugNtgV/U+l7margof7tLaaJFsktZvHc=;
        b=LzmQ7lyAyK4qZSnLYI8PTxCzt4L8wVXClAfKvwxF4S+DzlV3o1GoBjqsMuLkK4+EA6
         C9R4Dt//svf9UVGAJ+c6FlDpFgO8LdEOJdwvogsjYfSrpr83kLVTvLElpQ2YdlVqepGF
         d3QtApPWNahTSb+4ykUeQOu+/TwYhDKtYjvRxep0y/HiPLAwrb73Sxm050O/sTkY696Q
         J5O/MnuQAqnhHm+Pr6fNpRkwgsrvQ3nRzpwxJx5qKomjI5S6/28S5uz/rySK0ENwuYO/
         G2Jppap12WnlKpUNsRUTI3VIvNzuR0EQzvTvdNquY82DNsyVSJIBono58nL2gzv4eQq2
         GHhA==
X-Gm-Message-State: AJIora/KXuFgx/ubfK8MDzJmxE0Nm59F2Go0JYlyT1XNvLkrOfXn4UkS
        lYxuemnxCC7W818T59rBqkiuI/sxLHdepoDbYtSmHw==
X-Google-Smtp-Source: AGRyM1sEh47KM3KJC7RAjJ+mTtr0GQ3oNgmwTFHyuENbfpMfO5Nos4e7w/P7r1qzDI6XZzF+yTi1nfdbdaDPrmNDmY4=
X-Received: by 2002:a5d:8f96:0:b0:675:573e:6eb5 with SMTP id
 l22-20020a5d8f96000000b00675573e6eb5mr21303689iol.144.1657092141532; Wed, 06
 Jul 2022 00:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115606.333669144@linuxfoundation.org>
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:52:10 +0530
Message-ID: <CA+G9fYt4H-976bCxr+BnhKi45M6zWXppJidXeSHJUvsxYG_3zA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/29] 4.14.287-rc1 review
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

On Tue, 5 Jul 2022 at 17:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.287 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.287-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.287-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 2e9431cf011af1ed9fe42d59f296ce27ef8647a4
* git describe: v4.14.286-30-g2e9431cf011a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.286-30-g2e9431cf011a

## Test Regressions (compared to v4.14.286)
No test regressions found.

## Metric Regressions (compared to v4.14.286)
No metric regressions found.

## Test Fixes (compared to v4.14.286)
No test fixes found.

## Metric Fixes (compared to v4.14.286)
No metric fixes found.

## Test result summary
total: 109881, pass: 96367, fail: 208, skip: 11789, xfail: 1517

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 286 total, 281 passed, 5 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 26 total, 23 passed, 3 failed
* mips: 33 total, 33 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
