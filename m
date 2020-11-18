Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E232B7C31
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgKRLOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRLOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:14:54 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2E3C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:14:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id i19so2171298ejx.9
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v8QVDEN0MxWn6PzNLIaqoY33HCYsL2Iu5yFSMIaGI+E=;
        b=UVHwcy1az0vs8mU+n/hWwhhdGtLza0BCAiOr6ibacGyE46FMyTMajj63wwhxVLCCte
         jB33O4Au5Zk0pUqUFUu6jt3llKzDogtqni4ABbg9jarjVs7As+kzMbc0N1uX+l/+wE/F
         xAqtym3hV7oZmo5DFBElNk0B1ax/Q7Wo7/9bhYdpWg5thkOzrJn8D9/jcMWu9RcodJSs
         iJZ3XFn28hseSg+XaBGvsLBV8x+lg14Y27OmAYyWV+k1diHeTtDb5m6GIfNliua9/1Fi
         LmOVfCDZLyoPkIpII37epdCMJ9lJcgNc+YCjWqtptotOMkCc7OQAkEtdXGOQvIlvBycw
         3AqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v8QVDEN0MxWn6PzNLIaqoY33HCYsL2Iu5yFSMIaGI+E=;
        b=kOBnoHicwLSnvRF8Kp7r0EQWJuadY+eknoTnDj3aN5GvvZ0fpXTCwYDB+QKLyhmoVV
         jKSaYDy1LZrarhbxryi/H5BQfhLnPVrAh4ODBkYXQ9qL8fEVOk8OPFPajPC6sizSXEv3
         ANRLHGZBFcRY6afNOpaoaVdmsmTD6vYOp+FGkh8Lgs/whIboKUiR7S0ypY/cTLPKcYEi
         Ic3Y55AAJloKlzVe9tt7u0WfWEHTavKtAAGqterTJAgF725kh3sCdxS5qSTrA9NhB+26
         2HiuhWcUjUN9B1NI3E9wSaDlXO5Lo7/TWPg5Mv6nwcY0PQnlX10b9kxJoLkblmr/jC0M
         Artw==
X-Gm-Message-State: AOAM532bBdrGY0ClmbIBTfLDj/oZlDtZNtQdhnVkzFW2ZtHgXnzlVx7C
        Ig4pt3GR/eyWMfNBrQYbHW2742n3gVpDMC+F2TaKpg==
X-Google-Smtp-Source: ABdhPJxYScWnwyUbTtmajl3qA+LCanooEYrMZj5WA0e3teb66bmO3v2Co0Z5VZ75e6z2t2L+17CCcZpY2wndAoyipBk=
X-Received: by 2002:a17:906:7043:: with SMTP id r3mr22665998ejj.287.1605698092189;
 Wed, 18 Nov 2020 03:14:52 -0800 (PST)
MIME-Version: 1.0
References: <20201117122109.116890262@linuxfoundation.org>
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 16:44:40 +0530
Message-ID: <CA+G9fYuforEx_P431OaUFXDZm1iAdp0jk5C7TiNsUDK+qNYY8w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/78] 4.9.244-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.244 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.244-rc1.gz
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

NOTE:
qemu_x86_64-clang-10 boot failed with below error.
* We are not booting on real hardware.

PANIC: double fault, error_code: 0x0
Kernel panic - not syncing: Machine halted.
http://ix.io/2Ezr

Summary
------------------------------------------------------------------------

kernel: 4.9.244-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: d3e70b39d31a36dd7611410e535bd0762f3824f9
git describe: v4.9.243-79-gd3e70b39d31a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.243-79-gd3e70b39d31a

No regressions (compared to build v4.9.243)

No fixes (compared to build v4.9.243)


Ran 40883 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* perf
* v4l2-compliance
* ltp-cve-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
