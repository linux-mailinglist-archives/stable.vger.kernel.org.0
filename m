Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D78562DDC
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiGAIWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbiGAIVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:21:35 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2C970AF9
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 01:21:18 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p128so1595662iof.1
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 01:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lp7VNnqm2tf0ddBrHuILheNLPsX4Zh0bZVJc7ezqPQ=;
        b=qM9lBtt4aM8D9O+ReKl19L6tjvm78755wjRhkKSItdHTkVYaMAFAtyY5tZZrErnYmy
         0xY8B7Xa57NM/7qGUzhSwPKg3DiRl8mF43HwUQ3dkq/dJ/zVLZAPkV7ifNADkm/+0HUp
         7KbgYAjmZ7pwY5ZmSKCGwX415gbyjO/5ia8FrWhBRFY9JmDkh1/5Nes+mrDHMRD8II2D
         X3UnJh9ajTH8EF4tABgQQim68KDFrj/B8XB3ZLNoQuL4/ctAoO74ca5yr0b4SHZ0LZAp
         hNbMYT9ekDYdXRE4Jm+Z3KKHkpfAsJM3Z2zgltVQtLtFoTXju3WisGpru/W6dFYulgn6
         J/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lp7VNnqm2tf0ddBrHuILheNLPsX4Zh0bZVJc7ezqPQ=;
        b=32lOMY9BsLjte8L7CjxgRlTo/oGUTaRgZYodh792plhN0LkS6kxK8n7phQWa5fkChs
         G+rNvEc4z5aqZYdaAWlilgwnBkn8AlldGNBp5g+/cwYbaMja8SI4U6veSNi+O1Cr4ZMk
         gS0FhIcdEu6plYjJ3oe0dVt6OOfoYwe5q4RwXyB/Qf8F0ykBIjPiYvFKoG2YTjZnvcA5
         SlZUDsUfcwp3ziVrFBGWtWd/HyrxAx2A74kCBeJRjoX/BUAJEXx7yekRiX8aikHdsJ1L
         9nUr85QfnpAOvBONr/PTEDk955RbGXybneJs/8T+RfOg6GaYAj83j9DLEaP9wuToD0Fk
         YtCw==
X-Gm-Message-State: AJIora+omZXa1KCIUnuJFqPB5cG3J1P0BsQxpg/OpGsSdtlS7byW8jPZ
        sCkp5NVPs0NL8tifz6cxrO1+zW0N2sl9v9aSvAxCYQ==
X-Google-Smtp-Source: AGRyM1vus3sKVluFrejHJJBjZZtbigf1Q7Cfsq1JuXjTrS1UalvATAnT6LtvpoFO0XPvatIoYnfOR7Em+iRka76y+n0=
X-Received: by 2002:a5d:8f96:0:b0:675:573e:6eb5 with SMTP id
 l22-20020a5d8f96000000b00675573e6eb5mr7014355iol.144.1656663676780; Fri, 01
 Jul 2022 01:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220630133232.433955678@linuxfoundation.org>
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 1 Jul 2022 13:51:05 +0530
Message-ID: <CA+G9fYuxx3wdLXiKhYAPEs-g6uxPn-OsyaiHQOvjuegVEShgMg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/35] 4.14.286-rc1 review
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

On Thu, 30 Jun 2022 at 19:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.286 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.286-rc1.gz
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

NOTE:
while building arm and arm64 kernel Image the following warning noticed
on stable rc 4.19, 4.14 and 4.9 branches.

WARNING: modpost: Found 1 section mismatch(es).

Build link:
https://builds.tuxbuild.com/2BIbl6QeikBHKOcW7R8EWkanT1N/

## Build
* kernel: 4.14.286-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: f1dcd28ff18404d41b501785ed86299b263953d7
* git describe: v4.14.285-36-gf1dcd28ff184
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.285-36-gf1dcd28ff184

## Test Regressions (compared to v4.14.285)
No test regressions found.

## Metric Regressions (compared to v4.14.285)
No metric regressions found.

## Test Fixes (compared to v4.14.285)
No test fixes found.

## Metric Fixes (compared to v4.14.285)
No metric fixes found.

## Test result summary
total: 101427, pass: 89678, fail: 203, skip: 10715, xfail: 831

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 287 total, 281 passed, 6 failed
* arm64: 51 total, 47 passed, 4 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 33 total, 33 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 49 total, 47 passed, 2 failed

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
