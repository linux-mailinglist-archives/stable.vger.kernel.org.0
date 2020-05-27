Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BFD1E3C30
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbgE0Iga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387811AbgE0Ig3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:36:29 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53DBC061A0F
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:36:28 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h188so13989533lfd.7
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QKsW+LhuFWLts/ySjADgQNoFzggmEchkHP7oLX/Do3w=;
        b=i6CaNHHWAemICJMG3E4jUdEtdfGKJczZRr1T4YUUhn3dMDDZfcQCPu5K8DYghAxn9Y
         oJuncuLRz7sn9Ddytod4rQFcggTYj4mwJneTvFyln+xXP3Uo9VChHBvSbkR4fz4HbYCj
         NqoQZKZzqkTkT+zhLuTlN5uqRL8NiROQmmJxtGhwgzpVBeTQzebf4XSl948CZSwP/ru/
         UgydlbV1zurvniK3QP6SKsZKyE2QYeT1B4altGQZaHFdaFJQptL/hge9U9rpwH+RFuFo
         Lfbihq/kmAyo+r8Rsyh77krZZDvr9x03Ggq9fdlmwknQbtq7Taml3bZKnte+32ptMxSn
         dzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QKsW+LhuFWLts/ySjADgQNoFzggmEchkHP7oLX/Do3w=;
        b=s90j4S5XDw2UF+g0RuZicgrYDs/2gAaDo86URX3+fAQzV04HLodFEI39TyQGv/AJBX
         Rts1My3rfueioVIiBpbTUrSNRaGj28Ujj3ilF9xBScW4Oq/4NLWi7i4rwdnfw1QWelrx
         nHT+fa3qwrlhYOVlgqSLWr9LIGxZiiC/xC7th8C/ueECPQHI26mUEEmkhqihnJw2Vp5k
         dhp7U5etyC40QOFsFohwaM7Al5MeR+2CSZpBYFdAEqLta/A2sZ746z6M+mtd6m2d9E4T
         VtKK5nZLLcK1e5N7BJrzHzAVgN8iUDpkNX4RWq3hagkU5VHyBs5JNPx2VPshOJqipCjY
         n1PA==
X-Gm-Message-State: AOAM5301E2VIRWnhf/lqBRKCNLjMhT+VnAk1yXfoTfZSea1mFTa1rlC9
        UGq7UcaSy3xFwfVrinnt/WCtVHLS7VJ4/6XqGBBCQQ==
X-Google-Smtp-Source: ABdhPJyqmBFhBjUEn3fuSHjl4enmpZNm21AwzDnEj+9k9X0lHcqmaCgAP5tTagvmwteflc4q7J2dFXwtq0Vpwp6THT0=
X-Received: by 2002:ac2:55b2:: with SMTP id y18mr2553554lfg.55.1590568587062;
 Wed, 27 May 2020 01:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200526183907.123822792@linuxfoundation.org>
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 May 2020 14:06:14 +0530
Message-ID: <CA+G9fYsZyFybO=M+5RDHi6vFXmuxC+My6YE_g9ur7mSJ3O0bKQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/59] 4.14.182-rc1 review
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

On Wed, 27 May 2020 at 00:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.182 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.182-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.182-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: ce8b534d70e21cb589da3731a1f61fabda583756
git describe: v4.14.181-60-gce8b534d70e2
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.181-60-gce8b534d70e2

No regressions (compared to build v4.14.181)

No fixes (compared to build v4.14.181)

Ran 25832 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2800
* linux-log-parser
* ltp-containers-tests
* ltp-fs-tests
* ltp-commands-tests
* ltp-math-tests
* ltp-syscalls-tests
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
