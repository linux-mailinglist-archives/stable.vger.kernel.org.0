Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E467311DD38
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 05:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfLMEt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 23:49:57 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41403 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731357AbfLMEt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 23:49:56 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so1149325ljc.8
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 20:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RjqECYszcPzuiZt/L0AxRI8ssRwksFUZbqaKQV1bL6Y=;
        b=ZydEJMcq/6d5EfUHgWKsFIDKFkXYlKfsy5uX9HkifdQOWLixUPRgMmqJap+/j6s+Iq
         iB3TJaHb5mggMmLkgpgCeOBUQIWOzZBg54ZTLJJLIH819bKi+N3jR1j/OdcgJ3C6CuAT
         8RAZLhtARApYBNTzvPtCO8RJVQDrmUc9U9IBHO57bWEJ2wDJCfI8DPdyKA9jDSfIHjeY
         VAyBVfBwpRmCUT1KAfoC074lW4gPQOQyOP3L7iSOtMbmJK1L8/1YpXv8dAJjs+qODEzz
         Ij/5pe/GXGy41wa2SXBXKzpabbrREpAYeaJA3XXlz9gnrJZsS5qkohPYYUV+jS530zKE
         3FlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RjqECYszcPzuiZt/L0AxRI8ssRwksFUZbqaKQV1bL6Y=;
        b=NViqyI4YCe7+Bp/dYOgE+uUYwDMa2qXhuG43Rqg86C1a8SAWa+3LuHVm/v2urRAu71
         uEPaS4Ns+eJzzCBstD0g4IZzowvf0OLJtlMoh+TYAHsGLJJ/UmvVqyFeGAk+Tj+xMua5
         sX0EEyMzRQW04FogN5/ltNUYjntJosHkvVwZmk6qVgeVTPtNLdQ2UZyVqS43WOwgCRO0
         HKGmiI2dbWze5gAL6vR+kTYhX0IA6YJeL9wXY69Q2yGcKJu27V68V7rL20eed7zMM/+C
         Gz7XpMT+6NMsXVcvu+Llj25AgmRgQV4kvzzY8WsBvpwnIT0CJTPhNWPcUhqPUlsC73BN
         zcwA==
X-Gm-Message-State: APjAAAWyF+GBC+g8YihPbv/EWU8TqqkDxw4/cGDHGz4FAPUcQ7sd5CUc
        flAk7Q7S0l6hH/AeUAl5y8TRV4bdKEYfPXMV8CKs+A==
X-Google-Smtp-Source: APXvYqzVZfwrAib+MkL2lbePl8L3T2AXPOH//B1Omcrvm7leLvsZEiXrbp2C9tVSKznw/eQFjmXBtLvjjknv9+i3fPU=
X-Received: by 2002:a2e:854c:: with SMTP id u12mr7853870ljj.135.1576212594365;
 Thu, 12 Dec 2019 20:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20191211150221.977775294@linuxfoundation.org> <20191212100433.GA1470066@kroah.com>
In-Reply-To: <20191212100433.GA1470066@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Dec 2019 10:19:43 +0530
Message-ID: <CA+G9fYsWs8feJ5uJZ_Jx-SR__zJZHwZhdVPWa+QOGMHVjBBsPw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
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

On Thu, 12 Dec 2019 at 15:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 11, 2019 at 04:04:51PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.3 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.3-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> > and the diffstat can be found below.
>
> I have pushed out -rc2 with a number of additional fixes:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.3-rc2.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.3-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 2d52a20a4c407f36814e9ebf0a64d73f74a690f6
git describe: v5.4.2-102-g2d52a20a4c40
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.2-102-g2d52a20a4c40

No regressions (compared to build v5.4.2)

No fixes (compared to build v5.4.2)

Ran 24491 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
