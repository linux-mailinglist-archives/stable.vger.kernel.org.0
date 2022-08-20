Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588B359ACAE
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344696AbiHTImJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344663AbiHTImI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:42:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148B48A6DB
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:42:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c39so8129961edf.0
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ntTjbxdUm3MDErKQAVjGnhDOTUmCLMXKB9v/vZjYPM0=;
        b=jScGbc/hd6xdg8aDGHhEvu5TS+/Wr3vfh5NqYz7htO8bZ9hx46Fo/wHFdVZUKEIL9M
         sXO6FLrWU6HeB5lrSMX4lb/9M8J7IPbKP72nvknHPZ+NPfNkFKMS/U/yR2BbY5TwHHZG
         SWsACWgBKrcDdHGQsYUBaFYSb4Q1Zud+RInaHfGNvHqs2UtyZ3ZxAK1BP350X3begZ/X
         vrrDm/suq9vRHraGmF9orvkUN5EqSrh77WgjN8cfYgkfcEt7YN9xXiDP89se01T4OFJV
         kJonLM1rSecK4etciKsg+D89FGnF1NnFaucefH68w+gzcciOs6RDzxJJm5MPRdouvE0M
         TIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ntTjbxdUm3MDErKQAVjGnhDOTUmCLMXKB9v/vZjYPM0=;
        b=2PCUJ/RGtK0hoGeGbDpR8f4BPTBXbqZC5g1wX0mbx6VGJzf63Yey+sep9Zw30yMLlQ
         D7wq6bgCb2u7ydXwqsTtiegQwMneAChhyQKfzefOOEnCeHwsX1hlWvn6Ul/bDsZ6sKEL
         oWwaluCCQ07//GWLtswaiVKhZeIksj+lCtezLFv5Jp3z3piH+VQRBeptWcKwqKiR0GAv
         ei0E5RrVkpwkCTBBcm/dzEQb2d2JcZRbepIyyOGGKPU01kSlaCfLphM7ZKmE7quuQc/k
         uUpMK8W/8Hg/Ak3cQKsPvBnkcleg1siduwie5xJS0B6VYIvvnxU+nx4aMPw3jZXrXtje
         cC4w==
X-Gm-Message-State: ACgBeo2Vw6V6yf5pDkk0YHEOuZCA3MHOvqlb6nyoLP+ybeEJwZDRK2Ud
        N73Rtk6rlcxflXxoMvNTkaxXK7IxVRb/p592h9+6CQ==
X-Google-Smtp-Source: AA6agR41qvT8f/ZiJdy/AN7TzVIRTzPPeBb4Yh6H5iyb6/c6RcclKSHPU05It49tFbCxb2i3g462rWsAs7Dzgx9jHF8=
X-Received: by 2002:aa7:d31a:0:b0:445:f4cd:b1c3 with SMTP id
 p26-20020aa7d31a000000b00445f4cdb1c3mr8712289edq.110.1660984924470; Sat, 20
 Aug 2022 01:42:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153829.135562864@linuxfoundation.org>
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Aug 2022 14:11:53 +0530
Message-ID: <CA+G9fYsj9ihvrUnMJ2zK-wLF6fcP6D6Kn7GRPqN3-BsrUVmr-Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
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

On Fri, 19 Aug 2022 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 545 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Following regression found on powerpc.

> Nicholas Piggin <npiggin@gmail.com>
>     KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers

The powerpc defconfig build failed on stable-rc 5.10 with gcc and clang.

In file included from arch/powerpc/kvm/book3s_xive.c:53:
arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_ipi' defined
but not used [-Werror=unused-function]
   42 | #define X_PFX xive_vm_
      |               ^~~~~~~~
arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
macro 'XGLUE'
    8 | #define XGLUE(a,b) a##b
      |                    ^
arch/powerpc/kvm/book3s_xive_template.c:606:14: note: in expansion of
macro 'GLUE'
  606 | X_STATIC int GLUE(X_PFX,h_ipi)(struct kvm_vcpu *vcpu, unsigned
long server,
      |              ^~~~
arch/powerpc/kvm/book3s_xive_template.c:606:19: note: in expansion of
macro 'X_PFX'
  606 | X_STATIC int GLUE(X_PFX,h_ipi)(struct kvm_vcpu *vcpu, unsigned
long server,
      |                   ^~~~~
arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_eoi' defined
but not used [-Werror=unused-function]
   42 | #define X_PFX xive_vm_
      |               ^~~~~~~~
arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
macro 'XGLUE'
    8 | #define XGLUE(a,b) a##b
      |                    ^
arch/powerpc/kvm/book3s_xive_template.c:501:14: note: in expansion of
macro 'GLUE'
  501 | X_STATIC int GLUE(X_PFX,h_eoi)(struct kvm_vcpu *vcpu, unsigned
long xirr)
      |              ^~~~
arch/powerpc/kvm/book3s_xive_template.c:501:19: note: in expansion of
macro 'X_PFX'
  501 | X_STATIC int GLUE(X_PFX,h_eoi)(struct kvm_vcpu *vcpu, unsigned
long xirr)
      |                   ^~~~~
arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_cppr' defined
but not used [-Werror=unused-function]
   42 | #define X_PFX xive_vm_
      |               ^~~~~~~~
arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
macro 'XGLUE'
    8 | #define XGLUE(a,b) a##b
      |                    ^
arch/powerpc/kvm/book3s_xive_template.c:442:14: note: in expansion of
macro 'GLUE'
  442 | X_STATIC int GLUE(X_PFX,h_cppr)(struct kvm_vcpu *vcpu,
unsigned long cppr)
      |              ^~~~
arch/powerpc/kvm/book3s_xive_template.c:442:19: note: in expansion of
macro 'X_PFX'
  442 | X_STATIC int GLUE(X_PFX,h_cppr)(struct kvm_vcpu *vcpu,
unsigned long cppr)
      |                   ^~~~~
arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_ipoll' defined
but not used [-Werror=unused-function]
   42 | #define X_PFX xive_vm_
      |               ^~~~~~~~
arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
macro 'XGLUE'
    8 | #define XGLUE(a,b) a##b
      |                    ^
arch/powerpc/kvm/book3s_xive_template.c:323:24: note: in expansion of
macro 'GLUE'
  323 | X_STATIC unsigned long GLUE(X_PFX,h_ipoll)(struct kvm_vcpu
*vcpu, unsigned long server)
      |                        ^~~~
arch/powerpc/kvm/book3s_xive_template.c:323:29: note: in expansion of
macro 'X_PFX'
  323 | X_STATIC unsigned long GLUE(X_PFX,h_ipoll)(struct kvm_vcpu
*vcpu, unsigned long server)
      |                             ^~~~~
arch/powerpc/kvm/book3s_xive.c:42:15: error: 'xive_vm_h_xirr' defined
but not used [-Werror=unused-function]
   42 | #define X_PFX xive_vm_
      |               ^~~~~~~~
arch/powerpc/kvm/book3s_xive_template.c:8:20: note: in definition of
macro 'XGLUE'
    8 | #define XGLUE(a,b) a##b
      |                    ^
arch/powerpc/kvm/book3s_xive_template.c:272:24: note: in expansion of
macro 'GLUE'
  272 | X_STATIC unsigned long GLUE(X_PFX,h_xirr)(struct kvm_vcpu *vcpu)
      |                        ^~~~
arch/powerpc/kvm/book3s_xive_template.c:272:29: note: in expansion of
macro 'X_PFX'
  272 | X_STATIC unsigned long GLUE(X_PFX,h_xirr)(struct kvm_vcpu *vcpu)
      |                             ^~~~~
cc1: all warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.137-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 623e70e98313ed8ce5eb6da1ec87e1471d4e6af6
* git describe: v5.10.136-546-g623e70e98313
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.136-546-g623e70e98313

## Test Regressions (compared to v5.10.136)

* powerpc, build
  - clang-13-defconfig
  - clang-14-defconfig
  - clang-nightly-defconfig
  - gcc-10-defconfig
  - gcc-11-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

## No metric Regressions (compared to v5.10.136)

## No test Fixes (compared to v5.10.136)

## No metric Fixes (compared to v5.10.136)

## Test result summary
total: 125787, pass: 110926, fail: 582, skip: 13467, xfail: 812

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 309 total, 309 passed, 0 failed
* arm64: 71 total, 69 passed, 2 failed
* i386: 60 total, 58 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 44 passed, 7 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 64 total, 62 passed, 2 failed

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
