Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F327B48430B
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiADOJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 09:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiADOJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 09:09:18 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A48C061784
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 06:09:18 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j83so89739084ybg.2
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 06:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dg7NwXj41AsQ/qJ5jdOtHVRpnjmX7NbUwhoahNpZzOc=;
        b=Qqm/5vsRBZsuI20C/AWeC0ISY/uxnS8zjKSG3JQDeBJstmzhnSqKnX7iwnV+UOTa6g
         GinDhxXcBWL8RMisk4EUrFyoEh5yvjiGEXGDFdLD++mGrPkDWqJ8Jkfoug617X9CyzYR
         q0yHgmNHXH5MKTmkjLmjJNFKV4zEiUP1v8iS+FnZSPQlgiwbK9Rp8t1GdcUWEh5j9PS4
         aJvgQGbL+/Kqs0q8XF6Jruj8sBjrykAKaJe5uI3lhJ667Ol/qp5E6cbEqCFxO2Z0JCbk
         3E5DGKxj5vnRCVKcdHkca+v0RKvhoD0QmVOpQxdhUBxVluw4lkFDkduNavPhUlE9+K53
         yt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dg7NwXj41AsQ/qJ5jdOtHVRpnjmX7NbUwhoahNpZzOc=;
        b=UNVjvWncxawkLYxWKlXJq5mXWh92B38QBpwwLcNoWS4AxOSU6rbNaFgDJ4+P592fTW
         dtx1scAWRES9BSWAQ/63MfuIUvxgKaziZlk4El+xeQmgaNlaFw/LalEKW8/Z1/nQQlLZ
         Oz55d4LnJYySh8ro4tnzPfJ/cqAhK2+hc5hz7yqZmEPculWVL/36j6lvc/xBsbvibmp4
         SL8jwBJmasT+OW7sMr+cDyMqQ7ittOt+LP/fYzmoj6weRepWXV4SSUl3DiBWzeVWd1VL
         f3JtQ8ChziHnYtOVG/bCLcHQloSGzyIrVkUZAjp7KHywpeF6w29zifbsHf+HcltESvNB
         OCVw==
X-Gm-Message-State: AOAM531J6DSoXcMxM4tZnZihdOnh/h6x5QtZcz0HoqYc85Dq4dfauw31
        BVxKiIfMuG8wkr7B9tArYqQU9c0NgEqP09nhr9nwg1VimxUjdA==
X-Google-Smtp-Source: ABdhPJxE/IEOtSQC3RMU88/ubuQL9ulhbbLbGM/fj20+oHHQqRCBNQhT/YxM88euY1aVWnNznh6IZD+qI1MrYA9tAoE=
X-Received: by 2002:a25:73c7:: with SMTP id o190mr11291559ybc.108.1641305357414;
 Tue, 04 Jan 2022 06:09:17 -0800 (PST)
MIME-Version: 1.0
References: <20220103142050.763904028@linuxfoundation.org>
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jan 2022 19:39:06 +0530
Message-ID: <CA+G9fYuA41RQZwOXCAyT0Hrw1Ga555EWwDH5LJf-X7QrG2s9Lg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/11] 4.4.298-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Jan 2022 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.298 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.298-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.298-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: a1c4d899b5013233346ba4f33d952c391f0fe7fb
* git describe: v4.4.297-12-ga1c4d899b501
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
97-12-ga1c4d899b501

## Test Regressions (compared to v4.4.297)
No test regressions found.

## Metric Regressions (compared to v4.4.297)
No metric regressions found.

## Test Fixes (compared to v4.4.297)
No test fixes found.

## Metric Fixes (compared to v4.4.297)
No metric fixes found.

## Test result summary
total: 32658, pass: 26026, fail: 62, skip: 5888, xfail: 682

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 30 total, 24 passed, 6 failed

## Test suites summary
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* packetdrill
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
