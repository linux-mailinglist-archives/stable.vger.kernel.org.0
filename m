Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF9459AC8D
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiHTI1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344414AbiHTI1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:27:21 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8915EBBA7A
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:27:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o22so8077814edc.10
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=JrqMBHE8Y8s8z3OGnNSizMNZY+3dcPB6aIc4DL1jVDg=;
        b=twIUq00Y1zciqnfpIq6CK2hx3j6laacR53xQFxiX++QUh2WeZdUcoSwliZZLX6RUhY
         vb5mtfb73qaUbokQ0usaHlcJRhxT6VIKQVmoMk4Du3pgjgB8beeKG8MGAroU0neHvYS0
         pZiWH3vmKBpYaAsvXM7rDE/T9nQPEoZx5Gy1BGQf+1Gj9kwLJNH3M5SW7cbjTCKM5aC4
         NZu6EAB6Q4PLGbVpXl47tGSs/E7GT+1R3bqaOXrIAJsrUmHJ3s/GwSlpMd8Bf+xQbLgN
         gpq30vys3ubJAr+yFPeb0PfCbLSNyDc5aMmbJZab19iFwJywrD+0e3GcGSrhHr8JDHw/
         Fx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JrqMBHE8Y8s8z3OGnNSizMNZY+3dcPB6aIc4DL1jVDg=;
        b=o9NIqA0AlpZnFzjkUl9wGubXhYGhnPr9HWyoRtfOTGhoacRTPLOxaUZWolUwlRnpLx
         vrybNLCa4ER0NjuvS+G4z+dqatjkLh3ezWLJqchhHD42Ka0uz8wUxaJwEal4pxCSyLoc
         ql0RuMr8Ut/eYBxhi4u0plsGx3GWXQF6jSMGhszqnm24w/Tiyvgkj5q3niJS4Re5HNyp
         GtH6p2A7KMolvdGO3O05XV+bOuQ1YiR6p1kE+UavRU4QZNpQDMD0lP2YnkFEDYheChdj
         ix6HD7ah6AfSQz+kJ1arsAaC6Jns+Be5HC+wIicdT/o8As2O67ENwzJ43RMuBqLySgmJ
         6bPA==
X-Gm-Message-State: ACgBeo0UV/CFaVXzjLIKSSitiRrwVdUjKCo7RLeO08m5Zt32IwDGiv6A
        Xdm7IhjdxuN0NIV01S5CDZ0jnyzuBeaVB00TfN/Yzg==
X-Google-Smtp-Source: AA6agR5csdidIYTyhrqeNb/E42Fq8Yhs+8IBZWqPfLFpKDf0eSeIu+aGzL0J5V5Scq3fzjIhW8L08uwZX2Ab1uT44aQ=
X-Received: by 2002:a05:6402:353:b0:446:2d2c:3854 with SMTP id
 r19-20020a056402035300b004462d2c3854mr6324461edw.193.1660984037959; Sat, 20
 Aug 2022 01:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153711.658766010@linuxfoundation.org>
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Aug 2022 13:57:05 +0530
Message-ID: <CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022 at 21:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Following regression found on s390.

> Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>     kexec_file: drop weak attribute from functions

The s390 defconfig build failed on stable-rc 5.15 with gcc-11 and clang.


arch/s390/kernel/machine_kexec_file.c:336:5: error: redefinition of
'arch_kexec_kernel_image_probe'
int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
    ^
include/linux/kexec.h:190:1: note: previous definition is here
arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
unsigned long buf_len)
^
1 error generated.


## Build
* kernel: 5.15.62-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: b79f9f8ea7ab2be6f724e8cde6db2a3fb057f62e
* git describe: v5.15.61-15-gb79f9f8ea7ab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.61-15-gb79f9f8ea7ab

## Test Regressions (compared to v5.15.61)

* s390, build
  - clang-13-defconfig
  - clang-14-defconfig
  - clang-nightly-defconfig
  - gcc-10-defconfig
  - gcc-11-defconfig
  - gcc-9-defconfig

## No metric Regressions (compared to v5.15.61)

## No test Fixes (compared to v5.15.61)

## No metric Fixes (compared to v5.15.61)

## Test result summary
total: 140859, pass: 124026, fail: 701, skip: 15336, xfail: 796

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 311 passed, 3 failed
* arm64: 77 total, 75 passed, 2 failed
* i386: 65 total, 59 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 14 passed, 12 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 70 total, 68 passed, 2 failed

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
