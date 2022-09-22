Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137815E5F32
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiIVKBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiIVKBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:01:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0B8AB4E6
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 03:01:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f20so12785078edf.6
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 03:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=J0qXhAwEzoWbz8NYi11IkHID2B4LQANK3dOrOzpzswM=;
        b=EokOGSnIK46rPF0cq5JkkwoxMv8EWDs4JGCatOPqqwqHOk7VVx5cN8Z4pR+ia19ty1
         VqbQSXqeshUYwMZ3zrCOl7xa1Ko5uzNEIMPgxPrjtsxjj41DS8jAO/bEcdDQ/as0CWRM
         nREFoJ1c8pSocKsEIwnMPLVEKtIQBV6T9xxvX/IQK/epJuPQz9hPJgQlyp1q+cHNC5QN
         SakGEbkKVrr2uXSo8Br/Q7V99tS7MtCVSQz/gAZPhJ52pPxBDEYWn3wo1+oSLvR6TtqG
         YA0T0qlFkn9yuqpyfIA+LIgVX/Kdh0EUzhpm1c21Qq3a3jZDWMXd6Zt4P7uJEInaI5cg
         TCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=J0qXhAwEzoWbz8NYi11IkHID2B4LQANK3dOrOzpzswM=;
        b=fqJJWJ0NIL6WPJsFpotzSdU2c+ih4L70YqIrtFYeCRFDy6LtojrpT1z8Xe+CXGDRZ/
         qfeRVgWW4as3Fph+5A0jS6hW3Jwmw0ajq4QEk4DzS1HDUYhY61alnJ9vRNpd5Lcck10t
         JlFHFTPsk8SXUTwOrJWy+JLjRxhq8/ABRGc9K2PLWl6+TcjcIxL4tHXeeASi5gb6xUck
         9kTaK/TMpmGN5Jw+sG94/a7yO5ou/KBb9ruCXuplEvt9XWH1f2MLnehaKVSbfCkMBB1e
         6KcGLZPi5nW5B+EiIakwizC6UT/Cj7y5vzAhDyuFWjjbyq1ONsavb+WJfqLgNuIqD5ji
         8rMw==
X-Gm-Message-State: ACrzQf3DpjIYbiJzQROfl7f7ailHoQWUrFoKJhchmuPrnh+drUvY+6c8
        3kWeei6BjA0Hd4gIqcsAi9CfzYr34LZbW/ldKAeY+Q==
X-Google-Smtp-Source: AMsMyM61YoKKgXD2TA5sZVWJ9BLcFHrwIAfLChpAAtUcovDLpwWQQCNKsZ+/eUBPUBz41TArDzkEfh374RGFsFLM0oI=
X-Received: by 2002:aa7:cb87:0:b0:43b:e650:6036 with SMTP id
 r7-20020aa7cb87000000b0043be6506036mr2455207edt.350.1663840862990; Thu, 22
 Sep 2022 03:01:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220921153646.931277075@linuxfoundation.org>
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 22 Sep 2022 15:30:51 +0530
Message-ID: <CA+G9fYs5BDHc2638p7br6-RzQzdJjxOOUvujyssy0bOWKOtLCg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Coiby Xu <coxu@redhat.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Michal Suchanek <msuchanek@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Sept 2022 at 21:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.70-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on arm64 allmodconfig builds failed.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* arm64, build failed.
  - clang-12-allmodconfig
  - clang-13-allmodconfig
  - clang-14-allmodconfig
  - clang-nightly-allmodconfig
  - gcc-10-allmodconfig
  - gcc-11-allmodconfig
  - gcc-12-allmodconfig

> Coiby Xu <coxu@redhat.com>
>     arm64: kexec_file: use more system keyrings to verify kernel image si=
gnature

Build errors:
---------------
arch/arm64/kernel/kexec_image.c:136:23: error:
'kexec_kernel_verify_pe_sig' undeclared here (not in a function); did
you mean 'arch_kexec_kernel_verify_sig'?
  136 |         .verify_sig =3D kexec_kernel_verify_pe_sig,
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                       arch_kexec_kernel_verify_sig


## Build
* kernel: 5.15.70-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 16d41e601858766935e69e3f9d62db810e5d277d
* git describe: v5.15.69-46-g16d41e601858
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.69-46-g16d41e601858

## Test Regressions (compared to v5.15.69)
* arm64, build
  - clang-12-allmodconfig
  - clang-13-allmodconfig
  - clang-14-allmodconfig
  - clang-nightly-allmodconfig
  - gcc-10-allmodconfig
  - gcc-11-allmodconfig
  - gcc-12-allmodconfig

## No Metric Regressions (compared to v5.15.69)

## No Test Fixes (compared to v5.15.69)

## No Metric Fixes (compared to v5.15.69)

## Test result summary
total: 106713, pass: 94034, fail: 687, skip: 11680, xfail: 312

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 63 passed, 9 failed
* i386: 61 total, 55 passed, 6 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 69 total, 66 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 30 total, 27 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

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
