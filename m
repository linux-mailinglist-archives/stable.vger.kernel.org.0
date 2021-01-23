Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB7E3013B3
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 08:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhAWHVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 02:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbhAWHVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 02:21:50 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2382C06178B
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:21:09 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f1so9083472edr.12
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CGtGRtHvVc2vq9qslOnc13oZNyNbSp48zyAtqvmuPNI=;
        b=XqY86WbyuV+R2a3vPyMtV/h9CpWR5l2eNCbtXOtszb7UqxbdzgOIvOwHGo6rN0tGkg
         Ol3UVg20CHIePoP8T7STvRyiq4JHsaYMS0KwTrFtFcDZ2BMrFmE8dRCwjqeQplg9Efbb
         ufHYD+gJhGo+nAUpJGGU1dkCUr17QqCqmA0MfpBCOzLHASjw7UOeThtnmTs1jvY+v2/T
         ec862CyadAAd38YuGQz256KDstWEbLDDa+pqRwHNYVQgHzBrk+HxGU8fNGXGGB99bPYP
         yb8TMZ6YqClHEyD+rsbbkR1nu9knYuiMDgZKbfNM7viK8etuHVcE3v4c7TuU5qkn/Ou+
         rrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CGtGRtHvVc2vq9qslOnc13oZNyNbSp48zyAtqvmuPNI=;
        b=qjVwoBbaDFLZndU1srXJvIjEMskXyHWixw1iZsSyi4Zpaj8Ik4QOOy7aNE1oVYYP6v
         fEpebDdMcUUWcm3kSp+C+Bz6+Ies8e6saLv+rQI2MXIqinP2lOJaEPBuDrdjZWE9lDOZ
         XZ7v46sT8EEJaua+KeV0s+jiE2FaDLqXjtXEjSHcCTfSh5xDDmILkjuJFofsHuosw9e3
         /SvlyCtkeoh0CqlaXjXN4pP8B9/fM96oA3sphtNd+De5OzCwpjvoln5dp7nuTAPBJ90+
         MJoiRd7pJ23zB+HV/pyAFbEti+Y9RJstuYgF6yRJQKAZNnXp8lRmsEBfei84uCsOHig+
         S83g==
X-Gm-Message-State: AOAM531RdLAbWWod0xGpRFu11b68dElSmaoiuJjS0e3mjxz/3SipQ8TR
        r/RQg+369YXFVb4m4sE1UIzKs0bdi69RAEGvg5w0RA==
X-Google-Smtp-Source: ABdhPJyzviu96ybZJejCF+APUROEP42NYDjs1HX1N1IDPWAOniJ6G5zUzUqU80+/rcpP/jPmER3qDGp9DcyB0qXLclY=
X-Received: by 2002:a05:6402:26c9:: with SMTP id x9mr1942589edd.365.1611386468338;
 Fri, 22 Jan 2021 23:21:08 -0800 (PST)
MIME-Version: 1.0
References: <20210122135731.921636245@linuxfoundation.org> <CA+G9fYtSJa2TTqBGgcbFXUPR7Qo8QzqVvMTXevqmP+ZCAHmLLw@mail.gmail.com>
In-Reply-To: <CA+G9fYtSJa2TTqBGgcbFXUPR7Qo8QzqVvMTXevqmP+ZCAHmLLw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 12:50:57 +0530
Message-ID: <CA+G9fYtsh2fvg60sNR_2N2oxYFs1hMVCoD=XH+8W3kNYHvizmQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/22] 4.19.170-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 23 Jan 2021 at 11:34, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.170 release.
> > There are 22 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.170-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 4.19.170-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-4.19.y
> git commit: 6cb90163efb77ad3afe6d40720f0b7cdd0a94812
> git describe: v4.19.169-23-g6cb90163efb7
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.=
19.y/build/v4.19.169-23-g6cb90163efb7
>
>
> No regressions (compared to build v4.19.169)
>
>
> No fixes (compared to build v4.19.169)
>
> Ran 46904 total tests in the following environments and test suites.
>
> Environments
> --------------
> - dragonboard-410c - arm64
> - hi6220-hikey - arm64
> - i386
> - juno-r2 - arm64
> - juno-r2-compat
> - juno-r2-kasan
> - nxp-ls2088
> - qemu-arm64-clang
> - qemu-arm64-kasan
> - qemu-x86_64-clang
> - qemu-x86_64-kasan
> - qemu_arm
> - qemu_arm64
> - qemu_arm64-compat
> - qemu_i386
> - qemu_x86_64
> - qemu_x86_64-compat
> - x15 - arm
> - x86_64
> - x86-kasan
>
> Test Suites
> -----------
> * build
> * install-android-platform-tools-r2600
> * linux-log-parser
> * ltp-containers-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-mm-tests
> * ltp-tracing-tests
> * perf
> * fwts
> * kselftest
> * kvm-unit-tests
> * libhugetlbfs
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * network-basic-tests
> * v4l2-compliance
> * ltp-controllers-tests
> * ltp-fs-tests
> * ltp-open-posix-tests
> * ltp-sched-tests
> * rcutorture
> * kselftest-vsyscall-mode-native
> * kselftest-vsyscall-mode-none
>
> --
> Linaro LKFT
> https://lkft.linaro.org
