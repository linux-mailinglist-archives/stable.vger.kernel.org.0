Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06588583B69
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 11:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiG1JlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 05:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiG1JlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 05:41:03 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D013E9F
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 02:41:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ss3so2166067ejc.11
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 02:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XaNvgy+1H36IRcM7AA2Xwbajk022czzMS+90Wa7oW3M=;
        b=jYblao2xdRWipW13vVnDXLltc7VXnm/RC3o0aLU683Pl8BYeecapjUqIUXfmwUlSGu
         /tHklsM0PqVfgQztSY7YHwNFbEIJbxSbgpS/MVp8jW5YJi68UwJWUqTX8zSRnVW7Kvrw
         fEwcApWEUezdfwtmeq9M1XdsbUcptaD6kAG6DzTHVFkSI9LizFFn8DwbwBlwIZUBJju0
         7/BxwtxtWDP9NgNzhz276eg9swjzDPOiJDNs03x43fS6CIwgkluj9fowZY2+/3Mzbaca
         Ji6fmqdpLjGZaVPwdzt6gPeWdG8mJM5Lzr4PVMpQvPkPstgD9htaFc4x9i2kmamB1IH+
         LP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XaNvgy+1H36IRcM7AA2Xwbajk022czzMS+90Wa7oW3M=;
        b=HbfeI2B0KVkLT7x7yc+3X9s/99J/pajMHJAf8JdoIJPTu1yPabqAeLbyi1s8NwNGQj
         8rAWiXLf6XN+lsJz+nbRcOD/BqgxeCd77kt6v7cnfhOKlf+wF60kFTll9EowIBiqgS/1
         A55KpB+cQS/N/RpJFtOSR19mHDkg/dYb6seHXyUpKG5oFhIDj1EO2/E1ai3go145zHoj
         QupCYUjNud58vzMxFHMzT9458TFtoTZQ1o9k+cRw4HISihIw0VpOXxc0qp5OVgDpcfpg
         W11kJvCVW4NthNKPoGfPyQa9T5vHJweafUjRznZCYgFxXUJ8NESLSM6Gl6SSGI6NO3Qa
         IQNw==
X-Gm-Message-State: AJIora9pR43o5oV2Mb/Rp0mK51Wpy7klR/z7wnyng5H6bIaN9TmmSFur
        sNrH4W7o9skxJJ1tbYDjW1pm8DnMWruRsLHN+094aw==
X-Google-Smtp-Source: AGRyM1tOQ8M/osYWnQJOErj/AI1B/ST5/0zrasMiZKcmBcOAqVuS7XX8VMqPl6GEd1Vqevy6Uiim30H4iKNYfTmKuQY=
X-Received: by 2002:a17:906:7b88:b0:72f:d080:415 with SMTP id
 s8-20020a1709067b8800b0072fd0800415mr16027088ejo.169.1659001259232; Thu, 28
 Jul 2022 02:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161008.993711844@linuxfoundation.org>
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 15:10:47 +0530
Message-ID: <CA+G9fYveB+NVVi0+-u5=hT-5gm2f-deCiQ3wG5NbCPL6VWXUqQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/87] 5.4.208-rc1 review
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

On Wed, 27 Jul 2022 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.208 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.208-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.208-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 048552f118bf6191e9f2eb6f21b0c12f04f8f4dd
* git describe: v5.4.207-88-g048552f118bf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
07-88-g048552f118bf

## Test Regressions (compared to v5.4.207)
No test regressions found.

## Metric Regressions (compared to v5.4.207)
No metric regressions found.

## Test Fixes (compared to v5.4.207)
No test fixes found.

## Metric Fixes (compared to v5.4.207)
No metric fixes found.

## Test result summary
total: 123475, pass: 110463, fail: 392, skip: 11618, xfail: 1002

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 307 total, 307 passed, 0 failed
* arm64: 61 total, 57 passed, 4 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

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
