Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8743C567E41
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGFGRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiGFGRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:17:34 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236AD9FE8
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 23:17:33 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id m13so13202822ioj.0
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 23:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D0MFZJERcL+P29Ji4mUnFFqLhyFUqyJXrCCcoNg2Isw=;
        b=xH1zHkNfY56tiha2lnJpeCE1Gj/LTJU3tFF/hB5B0HPp9hNZmKR3NGZmV9Wu3Sdqcm
         mYZFWJcc5k1mDokwg92OzeeloY4Qo7VoszO6kazg/NghaDL05EAks+yZqKNJ1B+2Eawu
         9ChCOFkUVseVGTxn5iy1lEGpr4u8CwE03afrDTwBoOeohsiadQvwlqdbabKc9GRyXPr4
         LFDeaHuW4x4huS9kyLGBUgJfxUDiH6EhtAgGQEyTGyLpChztwlxxGfyo7cGkmB+/ygYp
         8sCu4IUQMSu67Q1q1zrrhFH9E/Xfg5HNp5nmxvqSf9OiBrsbM4n+CjY8s+1mLMlJQX/1
         JbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D0MFZJERcL+P29Ji4mUnFFqLhyFUqyJXrCCcoNg2Isw=;
        b=upGF6IIphElU+9KE6KospXUYS45v0ANdObVsFW3GPgXOHTpYCi46Er1Y9fwA0a4PoL
         FOFQ2jCIc0NIyVazjj7UxHKFF0+NWzjMI3b1V95WKrlnYMh7ld53GMebwL7e+jzAXUF0
         MuqeoKbhjjRjYut349LXMIfjMLgNlhE6pN8gT2gAjANWb7jHB2pXLPkwRackqxmxKQwC
         oe4OgHSzzs5pVsntSn3NZe+14Gvdg/Z7+oYzTn8i6REX33up884r/S2A7yWfL/PnKJqU
         aQ3UF7oGNlbgZTeA5aV1mZND4skFNdZe2HRVsudNv8bojjlsO43smD+jlQBLt+m/3l4z
         AdwQ==
X-Gm-Message-State: AJIora9rQQgtez9b5uCAxRN6p0WkEKuOHyj1/Gij+WQh3YfzwCtxzJh4
        rqL896Cmo1WVSkVfJ8/tTS5/tCHMtBH9hOcNIrG0PA==
X-Google-Smtp-Source: AGRyM1ta+NbdsODL7YWwCran+SLfN8R2CGT75dNKU24hPhihLdFIFfXHNHmFCLkIWXO3c0rx+xLyMwATIkzpJ7ipPIM=
X-Received: by 2002:a02:b90d:0:b0:33e:fe65:206f with SMTP id
 v13-20020a02b90d000000b0033efe65206fmr2744351jan.27.1657088252450; Tue, 05
 Jul 2022 23:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115618.410217782@linuxfoundation.org>
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 11:47:21 +0530
Message-ID: <CA+G9fYvvoRb_evuU36JCFHb5p64011u9XNAvFOR6aN7zCEYJyw@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
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

On Tue, 5 Jul 2022 at 17:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 7622cfa48fbd5dd4e0d25abab655ab754baea9a4
* git describe: v5.18.9-103-g7622cfa48fbd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.9-103-g7622cfa48fbd

## Test Regressions (compared to v5.18.9)
No test regressions found.

## Metric Regressions (compared to v5.18.9)
No metric regressions found.

## Test Fixes (compared to v5.18.9)
No test fixes found.

## Metric Fixes (compared to v5.18.9)
No metric fixes found.

## Test result summary
total: 123504, pass: 112003, fail: 540, skip: 10283, xfail: 678

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* lt[
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
* network-basic-tests[
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
