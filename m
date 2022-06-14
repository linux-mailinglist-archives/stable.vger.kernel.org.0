Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC42754AB3D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 09:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiFNHzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 03:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355566AbiFNHxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 03:53:22 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF12A615F
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 00:52:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w2so13817844ybi.7
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 00:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oullFNTbBD6Sv8yzTExdhaIVhpqJeaJx6Shc3dyLza8=;
        b=lazpJZG73XQAfR4LK+blnlE4Pn3QszQvIN5NRNTe/5lwNM0uvlzuhy3s1a6afAy4cw
         fPGqZmusiyhNYYL+mP1upNX5rngeFCMQ/e9QwuMR+ow8f45emTRo4hr+TmXcm7/dJAJh
         JiKPrTYsCKP0e+q1ACrfxTooAiT+Y/ybGoJVsdoK/S0LI+K4/0QK/aANbyrLf8BX1lwF
         6AFEc55N1wEO5f2+GV2YB93rf8mUo92K71D9k4fdFPZh+tq2T3RBdTAWjTafseq6uqoF
         8wNYsN1TK5ZY8EVPSwx7/1Nb1FqAwMCF3IRx1H1vohpV1xKxyInOZa0vBIQWP5ehSqs2
         YDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oullFNTbBD6Sv8yzTExdhaIVhpqJeaJx6Shc3dyLza8=;
        b=jxWsnxXerTcOp69hj9oe8HAtW32Z18jViWbAf1KH5f+FJNgqvFcptybq4kvxZl6BJ+
         yj5j2etQa4x1mhJ3Ovlvsav1MsiIDsKqYeAfTf7WBvAIPtI+esKOS9NSEB2LDMTc3q3m
         b+v3bi9gFdQPS+weGquefZchrP8D0HPiu0nQicTU7qYL9Z3dQ6RjWFL9pEHtH3wAhA0w
         j+c6PS+L+G29BpfHfz3AurfyT4zf6Ql0S6Wvdt6iG4dZtEdTHhvxgmLn5IP2qSAuqJIu
         5uU7wtT9dKnXZXgHzEDNNVdzyytr8LFnbKzc3sWUgIwPjVr1ER47rDnzN1jBNzjyZsJp
         5hpA==
X-Gm-Message-State: AJIora9WVrF3YoFNCzbL0BH2kQd4xL+B5ZtLOI25TS1TMs1yXVeJSPmD
        UMx4TR5MU3k640n6Yx5ZpwoAoVtwIX4gDvqqWlHdiQLDwP64IRTi
X-Google-Smtp-Source: AGRyM1tTeGRFgC+mWsIqDuzVjW0nKTutKIH1HGH0xgoLaSNYazUTdH85vTQ3VTGlUEuZXcGs0gKPPgf8/hyuS2c0kU0=
X-Received: by 2002:a25:a286:0:b0:664:862a:f693 with SMTP id
 c6-20020a25a286000000b00664862af693mr3422774ybi.389.1655193140745; Tue, 14
 Jun 2022 00:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220613094840.720778945@linuxfoundation.org>
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 13:22:09 +0530
Message-ID: <CA+G9fYua7K0REdj80LRuqbVkmRGsWQKKQ-s7csDR_ftoRrNzBw@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/167] 4.9.318-rc1 review
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

On Mon, 13 Jun 2022 at 15:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.318 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.318-rc1.gz
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
* kernel: 4.9.318-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: bb08155cd0997415c865f2def1e3c09686546cee
* git describe: v4.9.317-168-gbb08155cd099
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
17-168-gbb08155cd099

## Test Regressions (compared to v4.9.317-109-g3f34965b10c5)
No test regressions found.

## Metric Regressions (compared to v4.9.317-109-g3f34965b10c5)
No metric regressions found.

## Test Fixes (compared to v4.9.317-109-g3f34965b10c5)
No test fixes found.

## Metric Fixes (compared to v4.9.317-109-g3f34965b10c5)
No metric fixes found.

## Test result summary
total: 95213, pass: 83457, fail: 193, skip: 10418, xfail: 1145

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
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
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
* ltp-smoke
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
