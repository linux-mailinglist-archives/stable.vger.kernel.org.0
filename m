Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA658382C
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 07:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiG1Fmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 01:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiG1Fmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 01:42:55 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB5556B82
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 22:42:53 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ez10so1248872ejc.13
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 22:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ttQBTfBPAuZC/QPk3IKhegjmv5hY3rggjF2R8MxwGiQ=;
        b=SLXyjq2CljaMgfGfZWUfDSyFvEK92Dy/MwXs/vnPvorgO6j5U/59OwbJS2swvY7QuN
         myA8m4OvkMFi42JfFXhLQ53eBQ9DN4xMfuE0iuAa2MqrxPGU9x5Tsr2KHU4ipqSb2G27
         KnMQtHs7xkMHG++7P/wjo+RkGwzX/QRJ5h9xZYXgmRiXgv8cUAjYr4cInO3qn2hMmeAa
         0OyybkrKd5DWFLVc0kzQfCL/Zn2SPV0g1tQfx9bMSX2AZbkabdmPQwbbWAzLA6bGLhy9
         AbQKhYmBHb0Z1KrNtvOtpef/O6MnhbpyRC/5EeaJ/hJIyP1TOTtMuiLRHMEMfXMhRfsa
         1qTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ttQBTfBPAuZC/QPk3IKhegjmv5hY3rggjF2R8MxwGiQ=;
        b=5MQSoCm/9JeQo5FtIr1iWBhx5w91uicaLJgN6kFmFFHh9Ax/yP1ELLZpc9/w94qiz1
         eO2at3C82QHvUqUnehyARoEqnHvY7hedzpMvAmQy4nNDwmjNX83M6YXKzUrNAp5SKZsa
         pSBgKdQzJQWZ2s5rcLsaYZvVSjCLDucujhDNyr7c0zpTXNu/T+I+oDLKs7ngKOGiN6vc
         vVZwmyWd6VmjlRn3hCEKkQ12tVSnYE1nnDiDqeh1p5mnbZ/ZLt1hzPUeyug5rDbKvo5K
         5sPaTscvqNU4q0YLKTLVs1n56zMk9B402cscVmPczW1e2VcKpKs+eud5qn5qSbQQKCCb
         m/1A==
X-Gm-Message-State: AJIora+E6NeoUgqfmt/HLgFa8H2v6tQpmzwY9c42CBFNSe+iqpmGox4T
        snOxHX9EVFHyU/D5mO8JXuWE2c0XJHrre1HKtzJY2A==
X-Google-Smtp-Source: AGRyM1smQmvhedkJJ69RHJuWTSM1EYN8J0z9GpsFezSupx8I6PR4ICzyNwMg+rUaX0py1TME18HGJeHIE4FbrF49l9U=
X-Received: by 2002:a17:906:7b88:b0:72f:d080:415 with SMTP id
 s8-20020a1709067b8800b0072fd0800415mr15488570ejo.169.1658986971998; Wed, 27
 Jul 2022 22:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161026.977588183@linuxfoundation.org>
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 11:12:40 +0530
Message-ID: <CA+G9fYuedr9ahpTRUYyVTF3W_Rr3KVhmO8_sZCGED7xKGs9R=w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
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

On Wed, 27 Jul 2022 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.58-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.58-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 6a9b4e0a656c73ff2dc9a24b5714c6afccff043c
* git describe: v5.15.57-202-g6a9b4e0a656c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.57-202-g6a9b4e0a656c

## Test Regressions (compared to v5.15.57)
No test regressions found.

## Metric Regressions (compared to v5.15.57)
No metric regressions found.

## Test Fixes (compared to v5.15.57)
No test fixes found.

## Metric Fixes (compared to v5.15.57)
No metric fixes found.

## Test result summary
total: 141611, pass: 127731, fail: 395, skip: 12661, xfail: 824

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 310 passed, 3 failed
* arm64: 68 total, 66 passed, 2 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 60 passed, 2 failed

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
