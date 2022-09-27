Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5905EBEF5
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 11:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiI0Jsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 05:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiI0Js3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 05:48:29 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29991B56DD
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 02:48:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a26so19523816ejc.4
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 02:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=82vvennylnV0/4KhbaFd6LeDxxoTfGU6HgqN3gksU9o=;
        b=yeGFqCkqdFrM/cmPOVql/W7DdkZLtyuiKZ4Wb7jLhfJZbajs4TI3ByeZtXNTWE65VJ
         OWbduUPWG6frWj6s3RIce0+S+8H86N+EZh4ewL0a5fDvfmDx7W/4k6h5vs/XsHi15WRy
         ei+2aYGT0vGRRXNCEnpCLDyKNler1mF3K4NZSfo0hF4K0gMT5h1FcGrrnLADvtYs3GH9
         kQDl85MN10rttrMYfzuG8u5obFbnTItQGgiXbxTxXjaVYeGiTTcU59wWZ7EFMLATssC/
         WepmD9utMon85UT5ZircBQRgOJd/cv7THnDOXNIxeC5z9Q/TMZHaUTbpZ56+vMRjPhx4
         emng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=82vvennylnV0/4KhbaFd6LeDxxoTfGU6HgqN3gksU9o=;
        b=3wTsOIF+gA5tLvot4wfSzB7bX+TeTab7QQ2dGyswPfLGUMbkYsWrDE4C5uFjMH9W53
         rerklu4FoL5oAvlKiX+x46ADU0UH9PJDCtQRzVu3vLPPCFehaYoMxggiTem4UYekErzZ
         GnHwekeHR8h1CDbAo6eIAlcpyIjfpCxkBvi+uAUHD+y8ptRd4ZngGvNFKX/f+UH8r6W0
         SorAWz8tlqjMe7YNR79E0sqly5L5AyEF4zRZNWVYxHJWmMH5hD11kZZGIzIRD4GuEJB+
         aCcXbdcvBK3qhvKR/5UB0XCSl+sjfvrNgAcuol05TNVYwnHMCBtWZ5QzoqL3QYmdF4s+
         VzXA==
X-Gm-Message-State: ACrzQf3Ew3yUQRqRL7UT8z6/nPTsIg5QU31cIKpnecZjrlSO4mQEgT4e
        qNcJLayMJg4H4OWXl9WRg1WU0DIYTNZf+NJg1IxoTQ==
X-Google-Smtp-Source: AMsMyM62vIKawhwOB4lXBRto1UjiPfVQNGAvHUnT5B0AUe8TI4uB0kESXuYo6LlL2PvDa2Xdr51kh0bj9J+lIQW81XQ=
X-Received: by 2002:a17:906:fd85:b0:77b:b538:6472 with SMTP id
 xa5-20020a170906fd8500b0077bb5386472mr21630738ejb.48.1664272106530; Tue, 27
 Sep 2022 02:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163546.791705298@linuxfoundation.org>
In-Reply-To: <20220926163546.791705298@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 15:18:14 +0530
Message-ID: <CA+G9fYu6DQvRuD8b1C93qWjfJJrVGUatvatX0ij9nzZhkcf7uQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/115] 5.4.215-rc2 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.215 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.215-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following powerpc mpc83xx defconfig with new gcc-12 build warnings.

kernel/extable.c: In function 'sort_main_extable':
kernel/extable.c:37:59: warning: comparison between two arrays [-Warray-compare]
   37 |         if (main_extable_sort_needed && __stop___ex_table >
__start___ex_table) {
      |                                                           ^
kernel/extable.c:37:59: note: use '&__stop___ex_table[0] >
&__start___ex_table[0]' to compare the addresses
arch/powerpc/boot/main.c: In function 'prep_initrd':
arch/powerpc/boot/main.c:107:25: warning: comparison between two
arrays [-Warray-compare]
  107 |         if (_initrd_end > _initrd_start) {
      |                         ^

## Build
* kernel: 5.4.215-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: e5e9eb4c04aab7d1ee7e7ed3020a07e23faad938
* git describe: v5.4.214-116-ge5e9eb4c04aa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.214-116-ge5e9eb4c04aa

## No Test Regressions (compared to v5.4.214)

## No Metric Regressions (compared to v5.4.214)

## No Test Fixes (compared to v5.4.214)

## No Metric Fixes (compared to v5.4.214)


## Test result summary
total: 84880, pass: 74669, fail: 616, skip: 9225, xfail: 370

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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
