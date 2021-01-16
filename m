Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285692F8C15
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 08:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAPHmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 02:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbhAPHmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 02:42:51 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6F6C0613D3
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 23:42:10 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h16so12043176edt.7
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 23:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mzN4ky5LJAN7o6Gjr7qou54ao7859x7d7VxUbl7+ufs=;
        b=YkJBOwJHaHjAm7z6A1iEysNQZBq88KDb1rzLGvSB2F2+8E5lsj1bVuciO0e8NqZLbs
         Mj269Ros9GUhAWURiw8JMYUvC30glm+nS7wa2dNvBZheA9acRP/RmbqTHnMshS+tm/1F
         OCLYI6wjzd/Esqkdf/K9s0H3IM2WsRPjsXmHh3gofi6v2Wy/LR95jsNBOkreNebBdH9y
         qG7YNmqr8VdxvXQ3MUQFftPEHzeUk8E/KCbBklGx2XHLtBc6dn1jVUr3aSeBxWxaHN7X
         xAXN8sA99Jy42FvzN+3ZQmg5r2GufUSs+okilJZdfJixFJNsj7VQenBWqYeTDqpVAZVW
         kABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mzN4ky5LJAN7o6Gjr7qou54ao7859x7d7VxUbl7+ufs=;
        b=J5yovsjKIZSSG/X/61H/wximsnh62O3/LWFmrdquZqHtKcLUyD34ebSOyoMnHLRH1T
         gX6sJfwQ6zrQJF2TmVA4fAVHLAwsgXgKkm4IubN24d28wkt0dA2bamsZnYGj5acv4UCu
         P54YD/HzPDNBfSpRcpreF4DGCkWp1D62+5MxmBW9fZCfDrREr+9zb8Evpyw5FsmDROIw
         eIZ6/Z2pLhtKyFBzjERMjXb+jSMM0nA12ZwN9a8jzgi0WwL01OBawbeIDwGM3oaHGT3E
         SVmBq4W/m4qcIuMEW4RYyzKxi+d1xDupqb2LVUoksvNq9hvNRaW9Gg4UI9kJ5eobf/3D
         k0bA==
X-Gm-Message-State: AOAM530FZN/yMP8tdbiLPdHz3lRGh5GI02XqLunDozL2vqcxjzWnFHM+
        J6Z0GLL0pthkKrYF0Bb4JYBHfxvMMOjtLiIfuhZtrcCpuLaRVfws
X-Google-Smtp-Source: ABdhPJx98zZX/lfMD1Q06Ungq2aMVYlrAiAr65UndZPhu8ilTzqKGkrBw3e3mMBnSf+bZiLMTiD5F8HXURBnLAnwurc=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr12570863edb.365.1610782929253;
 Fri, 15 Jan 2021 23:42:09 -0800 (PST)
MIME-Version: 1.0
References: <20210115121956.679956165@linuxfoundation.org>
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 16 Jan 2021 13:11:57 +0530
Message-ID: <CA+G9fYtasoYtaWr_BFQ3NFpLtRDQHNYjP6mVnakCaApZcPSG+w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/25] 4.9.252-rc1 review
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
> This is the start of the stable review cycle for the 4.9.252 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.252-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.252-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 5728b2608cec5ac986e96fec329c9afce3c6e6fd
git describe: v4.9.251-26-g5728b2608cec
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.251-26-g5728b2608cec

No regressions (compared to build v4.9.251)

No fixes (compared to build v4.9.251)

Ran 39849 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* install-android-platform-tools-r2600
* kvm-unit-tests
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
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* libhugetlbfs
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
