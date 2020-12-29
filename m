Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A62E6F22
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 09:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgL2I4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 03:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgL2I4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 03:56:01 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11972C061798
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:55:21 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ga15so17285448ejb.4
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wN+0jnskwBLpDEBDq8zkMaLyVmxV+yCETRixXAWO7Jk=;
        b=egYRz/MbeClcmU/IQg+k9HLqOu9GYL9Hfimdg+a4UQJDHQOCY1zic/lMo8HuDt+YrX
         Kcu54wJLE6+QSlGblzZtInomEsNy9t89BQ7/33cbAVzEmkbu9BMPlvKoue6oMeGtuZqO
         tCU/MO53cx5I6eExF8Qhr9bWzE/gymbr67QrvjAdOuSmzZU3CrtPibXoR0l7Qd86DQpg
         RubocjZrScPd3emkUOFYczI8YemhL48Awxp9Ran+ZZ4Y7TPSMavaKy6QH6VHhQWW7rFt
         43OqqhMSVmUFcPQ5VkrXxlGqx/FWDtbkGL5dlFQUGo+EK0q/XREpgKTz2mKu/AtHJ7dW
         E2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wN+0jnskwBLpDEBDq8zkMaLyVmxV+yCETRixXAWO7Jk=;
        b=hHnN7kWy4jKylJfjH2ZMDxVb1PG7ELOltaFVsCJTBK0xTvYApYFeVR9wr/ynfC1s0c
         uMfXql71eETbwdszGmyD/z7zswsW1qm9OVNx4Dxk12rcMXggHMjk8kxXLEHQfmRXo7Iu
         LkTXq8tt9JEpzP/1CavEPtu2Ozyq21NSx9m4qWRIlDG0IhEWg4GOT75AXuo5ZlFnV9qR
         f9/5x+smmUnGSg3BP8x+uVwdTtnPTJntTI07XUbvHvI41C28Wz9mvNJI3sYtYZhw75wk
         MAgM7lfyHid4pbzE65rpLzU+jF82s/FWXTC1ZLDVD1PdHpC8iEjJ3EgUcI8RwhhgzNUw
         Zyxg==
X-Gm-Message-State: AOAM5327Syqsw9nsvbxWHqgFxGZjIZsV1g3hvS+NL1TOdxytQgrU9aaa
        Zy6smh7DGgn8v88S7fkd476RwRGVlRJZQcXfsc25Kw==
X-Google-Smtp-Source: ABdhPJwHWOKbx07rds9kUi2U82sU7Gzmsj9KmuTz/yN/bF5P71Gm/4j2TI7laJRo0zWb0J4LvvFtjoHT47uBw4L5jaU=
X-Received: by 2002:a17:906:4443:: with SMTP id i3mr42061835ejp.133.1609232119664;
 Tue, 29 Dec 2020 00:55:19 -0800 (PST)
MIME-Version: 1.0
References: <20201228124919.745526410@linuxfoundation.org>
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Dec 2020 14:25:07 +0530
Message-ID: <CA+G9fYu+AD_NY3cXBC88aw3nosmJeSS82Z+Ywe1djvGo7JV=TQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/346] 4.19.164-rc1 review
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

On Mon, 28 Dec 2020 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.164 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.164-rc1.gz
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

kernel: 4.19.164-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: c1838bdb8a07c9ea1120eb17b9b879246466e691
git describe: v4.19.163-347-gc1838bdb8a07
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.163-347-gc1838bdb8a07

No regressions (compared to build v4.19.163)

No fixes (compared to build v4.19.163)

Ran 45371 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* kselftest
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* fwts
* libhugetlbfs
* ltp-controllers-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-open-posix-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
