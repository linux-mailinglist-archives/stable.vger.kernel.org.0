Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BDD2EEB74
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAHCpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHCpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:45:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55266C0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 18:44:28 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v26so788212eds.13
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 18:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NS3ezHf4QCzMGW6WEzOGr6UnmAdwirkpgipq6BYO9fU=;
        b=ntZrM8I/p9FFhseyV9vPjRIl0DNC/zQseVL5Fb1CF7i57w+6aFlsXCQyafvceAXBfw
         g0/PICcvIs6aP9qjjXrG2iT4mxfmWJ1m7ssWaggYxyNmQqbnGSnztcuSMngWNoHYDQcm
         CQ+3v86/DHVS/gOuaFz0fnGZcgnn9QYIgHaYE3hKxYMS229hD300cU2LJARiLo/L2AhL
         hjE7fSV/3paKTTHi7JBsEvqQFtDug4sUDSmBdNbkjqd5xK1rwdwOXecbAT9bxmmPjTht
         l3mRI+fbw9wns5bzRuwThIw1c/DOE/a2kWi1GCOvL7St2XyVgBORmHQvDQcJwcFVY/B0
         By1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NS3ezHf4QCzMGW6WEzOGr6UnmAdwirkpgipq6BYO9fU=;
        b=U0DsoPeQrW1JHy6Xa5lqYROm0tg1DPgbIv0xr27wRG+pRKmlf3Z83FicF281O6y3uc
         RoupWEySdF+Gd/GZrSVS0I/zGmyKDV1hfZN+g4+8J7riCzxHVuFXNQzXeIkMHYab3Q9c
         NLbiWQfDfqpc25vitAM7FmgKGqJJBx2ME+Iq8XIEQWRhCi75kMYcsfCQ3ytm6m3mpHKh
         IAEOfexNlzxR/D1JjT+xB3hgpCr1FUeGe18mgbAYeAY7omQAZekufLtnybcWpbBwjDzc
         Io614s0x+DPeTRmjSBiBGr+FcBFbf/wdlTrkvCx/6UuMFZqzh10PAg1DFjwEfmHbmc3P
         xQWQ==
X-Gm-Message-State: AOAM530+le0nKEhqa7xWVaG8qSdwH3mbVc2C1y/k1eUTRWrRgDhhenGn
        IsPNvf9soVPkh7OtwVKowZgsb9oD46wuq/9tGQUJExq3E6Q9eYv/
X-Google-Smtp-Source: ABdhPJyDJSJngApTDCTJHOpdCD2VikUDdjPcmRUMathfS/hc48dxh9y6vNQ9GDUnsc8A/bQZZLEzSX9YugKunfiqQzU=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr3735885edb.365.1610073866935;
 Thu, 07 Jan 2021 18:44:26 -0800 (PST)
MIME-Version: 1.0
References: <20210107143047.586006010@linuxfoundation.org>
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 08:14:16 +0530
Message-ID: <CA+G9fYv4cXp=e5JEGTzx1qtBySO8KbvCCMKOpPQphBzDkCb9tQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/8] 4.19.166-rc1 review
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

On Thu, 7 Jan 2021 at 20:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.166 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.166-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.166-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 0f2782448d9a6522601ffabef0f3304a50d99857
git describe: v4.19.165-9-g0f2782448d9a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.165-9-g0f2782448d9a

No regressions (compared to build v4.19.165)

No fixes (compared to build v4.19.165)

Ran 47163 total tests in the following environments and test suites.

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
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* fwts
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
