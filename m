Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96685962AA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiHPSs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiHPSs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:48:57 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D9B606A4
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:48:55 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gk3so20570144ejb.8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=umXdews0vq7L28/0LeGK6dqrIoN411edLeQ0zKnuS9Y=;
        b=PtQh7bKbVzOtclr+DCdG7crv3hM20tk7mUw1nkSKnFi3ZkE2bi7oWIBieYusld6ahY
         bLaPxh8/p+beH45uhV8H920EsXF0pvtQ1k7YW3rx8KTps4GTrZqmoTmVHcdnNS1XKLsI
         jz25rL/b2urCK2OyiRswuS2gQ13ThhFn7RpELLmib8RagsSa7BvQxzFKaRmAANbiS0sm
         ujSQsS5uNxW8xgRFFm0saxKSd0Q509LCAzeZexDyhQnzoY/JK5EsVt8siD1gUrmVaFDq
         ZurDZqow4XU+wffiQqgKoVpND4kL+JtXZ8bIy9XjXsc6mw8HFxB4hARl2Q5IwICIYV56
         MBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=umXdews0vq7L28/0LeGK6dqrIoN411edLeQ0zKnuS9Y=;
        b=2Rk01gew6R8oqApCLjVk5IQXc5M/f+bxkRwGRBNnj95ekdmRa3bh2yNv4Bv6LvbfkU
         5bffoseYtP8h4pZgBrmOsC7jzvfxOwc3L7lVaU8IMxjO5ibgBUnG8xeurGX2UbFTYmMr
         dKQidhDUdGEpJt9VYSew7QRtpYCXYxfaD07RMR+U3U7sITh4soAlo1PN1KJ/KDvYyd5q
         7SVP/z/rgL9VtVYPh0w3VC6OxJw4H9KFKJuQ90L9fFkTexCziR+w2NjwznvjRs8FBxLl
         QaUKf38LGmhuEA7sq3cuATOlM0E5wQD5N+DER3J2qDLhH7tKTnKtj75KNl+sdGaJMFgJ
         yRpQ==
X-Gm-Message-State: ACgBeo2+eip8ARo3+vu4uio3DzovriaE67r+k8Zks/wXZrSYFonfBUMg
        M3MoaNFHWjECQMVxuCIEBGxfHpZM85+2pz31VzI1Uw==
X-Google-Smtp-Source: AA6agR6LdGXLXGN8563S6AGxlBGb8lY9ZsngHkw+nNTWSBl6gob/bW44JB/jpjtqbmvRkQgWz/G3DQdFBnpYnsU+WI4=
X-Received: by 2002:a17:907:86ac:b0:731:5180:8aa0 with SMTP id
 qa44-20020a17090786ac00b0073151808aa0mr14443871ejc.366.1660675733743; Tue, 16
 Aug 2022 11:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124610.393032991@linuxfoundation.org>
In-Reply-To: <20220816124610.393032991@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 17 Aug 2022 00:18:42 +0530
Message-ID: <CA+G9fYuBFvr8yOTD3obkMkYjWtOF3u9HQ3Vk7ihQevrq61a1gA@mail.gmail.com>
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Aug 2022 12:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.2-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 6078b149fc3d1f553499f53f8615846b1836b768
* git describe: v5.19.1-1158-g6078b149fc3d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.1-1158-g6078b149fc3d

## No test Regressions (compared to v5.19-22-g8054ca350126)

## No metric Regressions (compared to v5.19-22-g8054ca350126)

## No test Fixes (compared to v5.19-22-g8054ca350126)

## No metric Fixes (compared to v5.19-22-g8054ca350126)

## Test result summary
total: 132125, pass: 118300, fail: 1369, skip: 12260, xfail: 196

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 66 passed, 2 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 59 passed, 2 failed

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
