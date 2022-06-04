Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA4453D81C
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbiFDSiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239429AbiFDSiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:38:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88A31274C
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 11:38:22 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a30so313554ybj.3
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 11:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zHfwLP7hQW43xSvl9KGTCD1BnMP71EkLiiC2CfT6hGM=;
        b=EdmwnY6AGx36X0E7apX9nCpJwYFU2N4iLVXshOWxAO9wyu4yUan4DdCIpwcbt+aS5O
         8I1s0DwU71jIh+8srBjEML/qiJaeKpfO1a4hSs4yJ3/is6NFzk6aRnPtJ95A+DUjZ0RR
         1fHmV2mxPSVu4IzZDX49TIqqz/HcxXyLhogdmfqOtkY4uc9OPlVU33yguL3tXQv7+YZw
         /x6u6kvFgt753YuWyLTGjLALbwD/+g3sCbFcGj7nI92QRiyyFz/hQPwhzWxbQLbJdLWB
         jAk+PaTHYNM004SbR0fus34Jwxgj+nq58V1bbS9fHzi0tPTMc93fwMljQ47+FZffrGQB
         WTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zHfwLP7hQW43xSvl9KGTCD1BnMP71EkLiiC2CfT6hGM=;
        b=b8/YjJeyrprot9AGFOQ/VEjgWym7ONoSZTS7UUjzdonvpXhh8UnA13ccULj/cor8d0
         8m/YIchoy0oktUnT1TH3+JphzdXpkffvuzlAOeKCI5PPMxza33RzN9lvYyPb23KIFbmC
         ghaiV4u3Orc5qMnhytVUUIszjqV9alQNgoLGnXZ8Gr9bw5LAIkHXl0rQCGfuRVAO01j4
         Uj/8AIy/qPhjwMqq6BXt8go7nlcqEAwhWCt4uQgB0oxXwzXrkh4MyMFpKF3yRNTFIOdg
         e9+idRbNqFbj1rUcpqunT6XqKY1j1sfMdaUJvnqja/gXvelrzEEitauJ/d9+U8W7LdIn
         b7Qw==
X-Gm-Message-State: AOAM532aZ6JH6OmsCbwFGTIhYLP0aik6PdUMTxumAT+CJQp2QOkVO/wv
        QYghOun0L7+IkNTVrUx2l7jD62bO/2OZWxqkNL/Vmw==
X-Google-Smtp-Source: ABdhPJxsTXWGivoVmXNd055fA6Zy0o+QlqNlZBs0KwlxXqm7C+pV7T9kqDtaXYCFVhCNP3sn2epd7d4dNFAOy9AoPMA=
X-Received: by 2002:a25:4c2:0:b0:65b:a2f7:f39 with SMTP id 185-20020a2504c2000000b0065ba2f70f39mr17564488ybe.592.1654367901729;
 Sat, 04 Jun 2022 11:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220603173812.524184588@linuxfoundation.org>
In-Reply-To: <20220603173812.524184588@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 5 Jun 2022 00:08:09 +0530
Message-ID: <CA+G9fYuqZ7N0ZZRWLWPpDrGgO2uUJG7q9eLH7dU2hJ40F82GXA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/12] 4.9.317-rc1 review
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

On Fri, 3 Jun 2022 at 23:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.317 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.317-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.317-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: d4fe7e19de86bdff48c8a88cd134353f1b08b566
* git describe: v4.9.316-13-gd4fe7e19de86
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
16-13-gd4fe7e19de86

## Test Regressions (compared to v4.9.316)
No test regressions found.

## Metric Regressions (compared to v4.9.316)
No metric regressions found.

## Test Fixes (compared to v4.9.316)
No test fixes found.

## Metric Fixes (compared to v4.9.316)
No metric fixes found.

## Test result summary
total: 107072, pass: 94088, fail: 132, skip: 11460, xfail: 1392

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 261 total, 255 passed, 6 failed
* arm64: 50 total, 39 passed, 11 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
