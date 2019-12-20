Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17F71276D8
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 08:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLTH7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 02:59:05 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33735 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfLTH7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 02:59:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so1011648lji.0
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 23:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5LWA4PQE7gS1mCBR2NDvStJfINrh3qsGURJJxMiT3u4=;
        b=T1OAEeYUJZ5uDfoAaru8+r7aLESYI0S5MYrcTBD1ICORjXg1OFrcqjqTM0SzFpzTSC
         qSNQB7vhcyjdfJdtfCLmGicD4TLnmeL4ApY6+OpVZwbE2IN21klGd8AwjgI5jqGNzUJf
         3B9tjHEzzg9c5RSeMtb9SRi+Z8NOFJEAHXGguO3N830d2zQ4JNXYw+a4C5d3bvpFeQvQ
         FMlOHq9oULFOpHCdNz9/Xcf/vvLldxzayXWYvoIyeARh/w/FfDirS+dPgdHpaXFiUdem
         1A9eswIz1t2tETUs9i8Vzvvv+V1seqdQNemahDImK7nQNuGIk9NJI9aEkOEEu33s+rWp
         sWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5LWA4PQE7gS1mCBR2NDvStJfINrh3qsGURJJxMiT3u4=;
        b=PagsgPlchubtnrfzlAPG0jeTWdpzdaXXi5/t/8aojokO4GBszhLsFKOslKpDYL+R2u
         ukXc7LAEtAX5S9yv6dMLMiT4NI+kcv5EOjh9sl4JigS+N4Is4eIp97yBgRhkwKxNxEBy
         cei+iy+aozQUq+PPVIMHkCI73YJU2xXgcLi0VG6HcYttD4pMOhOHtSn15LqSinPtHDBh
         oyetIEVKZ12VYhdttRP4f5sUn/GBEa6+2HNzkDaZElh+jC2ES3YfQc7i8Z/R6ygZjF6I
         JAqsm8ruLqBSlJlzHWEhrbAmbkzH/Mvgyyw40Akq1R8gHNVj1I4TbmhWLXBycfMXGCx4
         XaYg==
X-Gm-Message-State: APjAAAVpYXEXWnak50GEEp8GseFvrmD1UlEGLt1Q+4owpEu5N+2/NRa1
        OAy15sslmN5DNG0Ma34UTdF6FDoWLOOJPeclR5+MJA==
X-Google-Smtp-Source: APXvYqw3iLLc7jxcyoPkSv+vzYGrKUJbkhRPfjnMeBSeA8HO9a5U8v4C6p4ql9iQ2Rn/C7n3sgTnjLKF2/YmQC9i4ro=
X-Received: by 2002:a2e:a0c6:: with SMTP id f6mr8712071ljm.46.1576828742070;
 Thu, 19 Dec 2019 23:59:02 -0800 (PST)
MIME-Version: 1.0
References: <20191219183150.477687052@linuxfoundation.org>
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Dec 2019 13:28:50 +0530
Message-ID: <CA+G9fYsnQxo8JPyPv2Zm2Ms0Cf5bT1hqXk3MmZ0p3W5k-a5-4A@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/162] 4.4.207-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Dec 2019 at 00:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.207 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.207-rc1.gz
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

kernel: 4.4.207-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 9fe78e96326d85ca140930f72dbce8b198001210
git describe: v4.4.206-163-g9fe78e96326d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.206-163-g9fe78e96326d

No regressions (compared to build v4.4.206)

No fixes (compared to build v4.4.206)

Ran 16802 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.207-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.207-rc1-hikey-20191219-637
git commit: edc1100c367e3d8ec1489ada9ebd94f1024d0f51
git describe: 4.4.207-rc1-hikey-20191219-637
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.207-rc1-hikey-20191219-637


No regressions (compared to build 4.4.207-rc1-hikey-20191219-636)


No fixes (compared to build 4.4.207-rc1-hikey-20191219-636)

Ran 1566 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
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
