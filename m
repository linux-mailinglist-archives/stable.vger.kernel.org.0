Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CE05ABF15
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiICNOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 09:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiICNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 09:14:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D54193E6
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 06:14:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id qh18so8705028ejb.7
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 06:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=F+Za+bVxoJ2qusi4UmH++V7NfEM2meNlpn8UUqwE6qI=;
        b=paFLYX1kwoxAyT869Bw8wkzUB8Q1PBXs3/jl5Br8UGVFXCadJvan6cQUQWF787cCCg
         NI8ltrE+nKdMbLbqslwm1aZEHOCZhcK/RpaL5YExp15rWhKdwG/PRkFqzGp1EWPY6hSy
         5EL2IZNZL6HB8hGMziaaEDEP8I4/EGqbchhwKoFnzxmsXMTbl6UFwKJPDymNWtQ9UezA
         SStFDYFWkGalChfTDrlvP4qJ/Zp6g1yPXq0LlkGhWomfQTaswEStE+l39wbi/bIjCnuG
         2gR7UYIGQlkNCtcvFcNdXM1kX4wkctKgzM3/nfkiw+knorMZaZzeczBL4x34IOPfZ/2z
         ItWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=F+Za+bVxoJ2qusi4UmH++V7NfEM2meNlpn8UUqwE6qI=;
        b=gadmZpQO9rUMxcKby00iaalBY6mjiYeXtt9WXbq9ORkOMYJcWhbNQbp1mu1VIhfrNH
         Y/NRmfzKo4HAmsg24B13TPK3mGXf5+1Q3YQzoKHjBifqzULoqYqbAF9zEEyPt9icDsIF
         sRiLlSbXtwtYevFhqaZS4L+1hyJKWxelC6IIq23wn8GSibCZHc7JLyp0itLm/Q/VgbD+
         U6RNZ6r7+aMZr/iYQvGMdfD1D0GB2g6l/0/b0Ud0aPW9UGRjxaUIPWml2X09PMHVS0G3
         fEm1J1kQGj5/Ypv4ip/yOiz9SqmmXSL+0dXcoPqbPhTH61PfKOaAocGhHw8HgSuLZ2HG
         DNCw==
X-Gm-Message-State: ACgBeo3z1vdOATCou76JjuE4K5RpuugI+9jYX401ojevO2hpGpl6+tRA
        0CcJWuHhtidr4FqIb2lPTVw35TIZCFskO7ZtiPQvUw==
X-Google-Smtp-Source: AA6agR65NoF1634E52NQkS/MxliU2YmP37btEDPpJpL1eg/dTr5pT04R25YPZv7IkZm/iFL3HqNeSv94lFbbHf7hk/s=
X-Received: by 2002:a17:907:3188:b0:741:4bf7:ec1a with SMTP id
 xe8-20020a170907318800b007414bf7ec1amr24144494ejb.448.1662210883603; Sat, 03
 Sep 2022 06:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220902121358.773776406@linuxfoundation.org>
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Sep 2022 18:44:32 +0530
Message-ID: <CA+G9fYvJmdoZkgXUN95YUNBFER3U29Q_Ggr-44-6HgiPuRMs0A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/42] 4.14.292-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2 Sept 2022 at 17:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.292 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.292-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.292-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 3eabc273fb30895fa15e9a0381c946b9d826b51d
* git describe: v4.14.291-43-g3eabc273fb30
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.291-43-g3eabc273fb30

## No test Regressions (compared to v4.14.291)

## No metric Regressions (compared to v4.14.291)

## No test Fixes (compared to v4.14.291)

## No metric Fixes (compared to v4.14.291)

## Test result summary
total: 84645, pass: 73321, fail: 727, skip: 10171, xfail: 426

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 281 total, 276 passed, 5 failed
* arm64: 50 total, 47 passed, 3 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

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
