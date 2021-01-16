Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6513C2F8C19
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 08:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbhAPHsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 02:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPHsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 02:48:05 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B28C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 23:47:24 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id by1so10151578ejc.0
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 23:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z2djUeHW29PTHcAEATrXB6Rh6D3MKzCt0CW0H5NmlIE=;
        b=H4OO9pau+K++OnZfwglsrDV0vo0ZhkPRyorppHcHYRmwiOwAo7WfYKvkr6Ab5DITNo
         XQBc/WX0TWAvd9DNLoRfdIAvrGEgyR5GTTaKglL1Teb9JJO55rKiw+tqk89r2YGMFAWg
         lLAccA9s1AXDh3gKCSF3jQThFx1SCMvzsucewMUgzzCr5esmEoIpf6EtXi3hY5SfMtHY
         C7vlytO40ucCk8+A9CBL/SZTpMFTbahD3n0LKP7DNK85PksuyV4YktRYYnIZmphjQzMZ
         fKT2IojnTPU6XD+nHm4l5NPt0A2R+AooJH3BFLAiqV9QCgBrnUZe68HFIfhbtWVJurmr
         /CkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z2djUeHW29PTHcAEATrXB6Rh6D3MKzCt0CW0H5NmlIE=;
        b=n8FUE1XffgYh7eEtnaGwGosF6a/HETpq/EX5EkwkkA9VaOoCpDtPgCcvUBbCCSStqc
         LPxGWt7XlzqWRswdNQ2mlTjL1boTEGepJjNWGM7SugajpC6BEYaGyKN3ComoS85cZoYm
         CXivxmr9HZQbYmKEs3BlyB+F9xaspw1pOSXyMYnva7aT1Zkoh4l/p3ID2LkfOLgh1MvY
         gJSi61Ef4d/WzdxSzpEjYT6o8Q9P6AGVq6ViVlNru24ozCzFzh/OBT4hmjcHz4Mnpeun
         Q1djw26hd1s7cabP2eYH4EjNYfB04dTX5BPMFFBahFJ5bjTdq/oMBIcbiR5/P3u+trP+
         3gPQ==
X-Gm-Message-State: AOAM532AB0+8KpZQmcdkc3V6ovxv7tRXqp8SehaNYfSwPfZsqOood8dV
        xyDo99esD47e4T5YvEcZT5CRd8+BGfk/n7mAI5wdaw==
X-Google-Smtp-Source: ABdhPJxJWGoveSlfEPO/P1QYLiRauSD7iFf3lgyX9dShnuAWCrdE9QOfuqYum/ncQNlSFtpoEZlcVtQPVGn4fdEVpIs=
X-Received: by 2002:a17:906:1498:: with SMTP id x24mr11055946ejc.170.1610783243181;
 Fri, 15 Jan 2021 23:47:23 -0800 (PST)
MIME-Version: 1.0
References: <20210115121955.112329537@linuxfoundation.org>
In-Reply-To: <20210115121955.112329537@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 16 Jan 2021 13:17:11 +0530
Message-ID: <CA+G9fYtzpFF-Q9p5mDmcjjczVXvKgrqEWDjwk5eb=pz7UOrQ_w@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/18] 4.4.252-rc1 review
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

On Fri, 15 Jan 2021 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.252 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.252-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.252-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: bca740d5a2a15e70a7b3cba962dc1d27f26204f7
git describe: v4.4.251-19-gbca740d5a2a1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.251-19-gbca740d5a2a1

No regressions (compared to build v4.4.251)


No fixes (compared to build v4.4.251)

Ran 31040 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.252-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.252-rc1-hikey-20210115-897
git commit: 9a7f50b4ecb8e05511460280c4e43f3d9e7f01c1
git describe: 4.4.252-rc1-hikey-20210115-897
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.252-rc1-hikey-20210115-897


No regressions (compared to build 4.4.251-rc1-hikey-20210111-893)


No fixes (compared to build 4.4.251-rc1-hikey-20210111-893)

Ran 623 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
