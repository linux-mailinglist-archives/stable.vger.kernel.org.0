Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F60E2C202B
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 09:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgKXIiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 03:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbgKXIiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 03:38:54 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D05C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:38:54 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so27303092ejg.1
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E0c+uWTO4/NEXM6Uw93N6+Y1kNtkiOR85L95Obiq1Po=;
        b=EsrrJ0uNzGd7s1dOZN2xf0kpDDVMXXyAn6Z+WzjmYRA0rGfU16Cvr8g+XZ5BSyzhG3
         g4vb7b5CcWZZxqA5bss/h4omNEqr6BSkf0RYNTbAk8FooHtiyObi7sF0whUNcefSYo+2
         DtKKP9aMCfjYC7pn5Z+XniYaT1SRhnpDxLyiFX5DGTfhNInfMTZtN9975yIF0Fgp7e7x
         SwJ2+4XqyVeOqtk4Q/mOaDkxx1Nt8qxqYbbkhKnbD9qwc1wd9HjjQn3eQ6/0CHChFVgX
         hpLEkffbxuLrGchwAeuc2ZfgPxZWlnxlLR42rDTQqzRVf+uahkY3rxduYp2lSMQ80kqm
         /RkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E0c+uWTO4/NEXM6Uw93N6+Y1kNtkiOR85L95Obiq1Po=;
        b=DfrP4G+BVGxp3bpMIe15fkY1h5j/epalSy9iErneeMoStTukoL/lelyE7/40FwNYRj
         2TbA+aS6ctl5CteWxUdiFfQ9ehpBD610B4nSzrZHOLHetZlfHnDfCvmWBtydXdaeRKBe
         QgnU63HMZqg5YpeL48CZTrBN9Dx80cwHg/dafXYOaDD5K+7ycMlKvYxymq4k6a9R/+pn
         YkU9O0n6xFV75xInKLG5Icejnot2miMoaj6ZCE0wYJzpDgbDaDB+o5gdbtghuavHwJ5q
         KlruAZtbmNVSNyHD+8NQSqkV5d+7xlzAgOL261Aa+nVtDw0tLyZnFUPj+XCkD+0Eze90
         XYKA==
X-Gm-Message-State: AOAM532kdE2evwDKLM6fg1C8ql30hlrpMKBC3O5Sp8KY7krMo8ADl6VK
        nxFxzXWroojumB1kvm3RIQo56F56y0kYMCXz8h/RwXF4qE0wyBUL
X-Google-Smtp-Source: ABdhPJzQSJpvZxsojzWIRpr1KmaF/9YquaKYFCTLHD9hcOj/Nnq5X6Kv43FsbM7JQbVT3NIlqmoSZj+QYeqbKsIoJzk=
X-Received: by 2002:a17:906:6987:: with SMTP id i7mr3484399ejr.18.1606207133114;
 Tue, 24 Nov 2020 00:38:53 -0800 (PST)
MIME-Version: 1.0
References: <20201123121804.306030358@linuxfoundation.org>
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Nov 2020 14:08:41 +0530
Message-ID: <CA+G9fYucRX6Y66b5XeCq5c8T5DA4Hqg3BgGpZAAH4uFXELkrnQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/38] 4.4.246-rc1 review
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

On Mon, 23 Nov 2020 at 17:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.246 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.246-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.246-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 4524983a35968dbde7b8818db1dd43d7fb215742
git describe: v4.4.245-39-g4524983a3596
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.245-39-g4524983a3596


No regressions (compared to build v4.4.245)


No fixes (compared to build v4.4.245)

Ran 24777 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
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
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-containers-tests
* install-android-platform-tools-r2600
* kvm-unit-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.246-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.246-rc1-hikey-20201123-865
git commit: 0860acfef9117bf9726adb90dfc46cd717fddd3b
git describe: 4.4.246-rc1-hikey-20201123-865
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.246-rc1-hikey-20201123-865

No regressions (compared to build 4.4.245-rc1-hikey-20201120-861)

No fixes (compared to build 4.4.245-rc1-hikey-20201120-861)

Ran 1800 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
