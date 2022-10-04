Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F835F3DA3
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJDIFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 04:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJDIF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 04:05:28 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6911E71C
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 01:05:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a26so27138538ejc.4
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 01:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iNoYsrtqv8GfdLeH0deF5pwIPIY4jt23MSCgbDKeD5A=;
        b=LGC1hUrwi33uqCgQgasWjx6xLVYwKI0yfj8leM5RskIach6XsPYF2nPC6EUqybPKMd
         TVApmxreM9THEIEsk7o1COtl6FtJB7D1Esh9o8BgJof+p9no9fapEa5yxWVHVsOybsgu
         uXzjO5n8rlPSFPNOejdxRBIGp152cjjyW+u4DZ8J+aGSgbEbwlxBZ6DWPF7tHBeUAjHv
         JiRodOAoNUzMMezv2FhB1Fe2lqTKYD38Db3ID8i7K3Br+pVi6GgtivxvWqN+XZR50zhV
         pJ9pqxdqvaFbM1AYVVcdio9Y4AVNEuNlErpXfbRgVJ36MaqJTXqzFsZjWepGLMDCwiMZ
         mMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iNoYsrtqv8GfdLeH0deF5pwIPIY4jt23MSCgbDKeD5A=;
        b=emW03rPbTIdJmj4BoBzSkdaocZ1fxbfPRHcunLXE5Xx5jzms7AToOWM8AaPzqtsDIm
         jKEjqwefx6uzgq2QFj4a/RZDZE+44m893BK33bXikbzU3aCT1f72ZXjaN9UMEWmoE759
         iSHOV8WQIZR1AH9J5rsJfvkZqZnkGC+vyDXPUHrbe3CcVKz8+jiN1C9pgrBnk81auFQn
         gLuZy60sDI9LQWRtDlxGLgw6gmuf/uDRR7/Q63t2V0oBM5ImTUGMY5otzvkg37nLd5gJ
         brHhUoDcKzStFsBqTyUvel6ZkHFaSzbkKYdSFRz/wmAZiFPDZrpcwkUjajE25rGkv+5z
         ekNA==
X-Gm-Message-State: ACrzQf3bzRY58boswuqlN1CHtp4J3NopFJpBslCUBCjwa2Z+KeO5fCRa
        4d7LcfTBFzv3jTFhJfx7GIHkZ2PNjzik5eR48Bst4A==
X-Google-Smtp-Source: AMsMyM4XPrPfHyHLsxlQur2O0VhGVz98c4oPgextNZSYmn0rAOPoi8Wb//Cb2/4Gi5jbyisjyEMYCqyr6k4VLq6a7fk=
X-Received: by 2002:a17:907:948e:b0:783:91cf:c35a with SMTP id
 dm14-20020a170907948e00b0078391cfc35amr18533235ejc.366.1664870721436; Tue, 04
 Oct 2022 01:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070721.971297651@linuxfoundation.org>
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Oct 2022 13:35:09 +0530
Message-ID: <CA+G9fYvj34XjumQhSXy74Z6-Www2zOngAc89_EPeHyv1SAXzxg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Oct 2022 at 12:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.72-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Regressions while building perf on arm, arm64, x86_64 and i386 as other
reported build log [1].

A part from that perf build failure, no new test failures found.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[1] https://builds.tuxbuild.com/2FcCmZZxrIrCmIDx2eq38erKAj8/

## Build
* kernel: 5.15.72-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: ['6b8312581f86c31858502556391330b10956a92b']
* git describe: v5.15.71-84-g6b8312581f86
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.71-84-g6b8312581f86

## Test Regressions (compared to v5.15.71)
* arm, arm64, x86_64 and i386 build
  - gcc-10-lkftconfig-perf

## No Metric Regressions (compared to v5.15.71)

## No Test Fixes (compared to v5.15.71)

## No Metric Fixes (compared to v5.15.71)

## Test result summary
total: 102006, pass: 90385, fail: 665, skip: 10658, xfail: 298

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 332 total, 324 passed, 7 failed, 1 skipped
* arm64: 70 total, 65 passed, 4 failed, 1 skipped
* i386: 61 total, 54 passed, 7 failed
* mips: 61 total, 56 passed, 5 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 68 total, 60 passed, 8 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 29 total, 26 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 66 total, 57 passed, 9 failed

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
