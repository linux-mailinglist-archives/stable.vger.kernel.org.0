Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5300E57B400
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 11:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiGTJjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 05:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiGTJjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 05:39:18 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB0C6559A
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 02:39:18 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10d867a8358so1162743fac.10
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 02:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DD7Gy47eZmDdlcr3oCOZCFWSuRJZKngE4pmzwm7Ub8g=;
        b=HBVa1pvZhThE00QsD/ZS00A40Erwp+UxGQIUZWVvkrfo8W8xFhA4jBWNUbcSSpjfEE
         ezO4DZSCsgVw/k+mFcWndu32v0w/JpEwNfyI4SjlDK6bjz+PzYV3QoCV1RqtO1LH7N8m
         fMOb2UWbQCgBqWtXKmjDDyF+rTy6WW3bYnYkv+FIo8v3vKUzvopMInPK/drwUlgvxY0m
         R3QiYLwKCmqdf38KSmEF5IwkSYuTjkRcsyZFMEUcjeS/3/Cy+0VhPCECmikiu5svHDKh
         xiIhOUJ+fm+r3gqiuXoQYfcFNlWELVxHHEdMvRWbHI01kndvUIZxZIASQyuw3kqfXohJ
         lK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DD7Gy47eZmDdlcr3oCOZCFWSuRJZKngE4pmzwm7Ub8g=;
        b=SuQdvBeyNl6liv69ZnPvuciNQdlj3/f6FG+MB/sc4Ce0ZIHbpeiOImwz2k4f7KFROq
         ZuVIIzTnb7vceuQELnLVcdWk0zOtOLHXH/E2Y5HkUqLzp6zWuR37leDHBGsb7VQdtDvd
         Iu/P1+6d59WwYLtZju7tmiTQ5Lkg6GD9/eUE9fxYZrcEP5edeFrozPUo2np8RZvdggDW
         +n+2BaHApNKC+kPzlo1pwb9RbVa8B0RJ8gXbh033ela3T7HAt8bvlljViJQBLmWcF4oV
         JVORW0wgXOyGbvTfi8tBjKAPTa1PKvz1oIx8l66MXvSv8RU2zsOqHmUS2ZjorHeLLz9B
         PyAg==
X-Gm-Message-State: AJIora8dwm+qpaP/1Xshp9xqcgjCkD4a9Ak/J/qpC7xsetBxUquCMUFE
        Ie76f6S5BP7kBCAXiZxhgLlMUdPsBSpnUC8nH6KGeg==
X-Google-Smtp-Source: AGRyM1sYPCmJ9ZxfRS8mlBIu2BUYWCd7jmzNEG2LuJhGvD+pj8n8VyM3aSuZhdqWUfGfzwWXGoWDTOCFF8/B1yWayHE=
X-Received: by 2002:a05:6870:218c:b0:10c:2898:a3ed with SMTP id
 l12-20020a056870218c00b0010c2898a3edmr1999061oae.168.1658309957154; Wed, 20
 Jul 2022 02:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114626.156073229@linuxfoundation.org>
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 15:09:05 +0530
Message-ID: <CA+G9fYt=WAV2SPz1iWaj5DbwW45XOARY9JR57z9Z6_vGbh2JEA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/112] 5.10.132-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.132 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.132-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.132-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 024476cf51e88407e84736ff298652322459beb5
* git describe: v5.10.131-113-g024476cf51e8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.131-113-g024476cf51e8

## Test Regressions (compared to v5.10.131)
No test regressions found.

## Metric Regressions (compared to v5.10.131)
No metric regressions found.

## Test Fixes (compared to v5.10.131)
No test fixes found.

## Metric Fixes (compared to v5.10.131)
No metric fixes found.

## Test result summary
total: 135505, pass: 122210, fail: 509, skip: 11957, xfail: 829

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

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
