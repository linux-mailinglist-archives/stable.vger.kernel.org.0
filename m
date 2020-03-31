Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C008A19A180
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 23:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgCaV67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 17:58:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39032 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730589AbgCaV67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 17:58:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id i20so23657688ljn.6
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ASWQgDM1fMUxhFk44PFkEwhxYZS5MLv9LiUoOqvMRq4=;
        b=srZ0T2qBdICHEje2GWLDmdKHtMddm6FIfeVGZJmKzeA45HiQip3eUejK8zTW7L+MZB
         V6oF0ZnEoTwyCfgbWB9zf9+EWaECu3B7HH8xVrUzUI0WFaZupUzLUpgYL3pepyXGr5Yd
         INKk3rJN0quvjpj5zJcSwMRN1KS3VeBSHpan1HTbtWpHaqqpPctWFS7jbP2RVkcc/y8q
         eQ69T37IxxWw7dvg26mT4Ik0E4K69+qzq2zQKDzJdjkxJ2nVb39a7G/w+wkwHxabU7cr
         1dpUyOmyJek0RQPWY+ce1ElVOzzJB4i1dAcpGQFt55uQ0fA5BSBLPbHqOfT0F02xXtlx
         YzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ASWQgDM1fMUxhFk44PFkEwhxYZS5MLv9LiUoOqvMRq4=;
        b=JxngZUHu1bVfcKVW+8nTFp6q1GMDAnj7QwpyWEB/RXV9gwukSk79COrzjusu30hilK
         clKLWWVSY+9V3Z8vMR/REcQrqAdeDGeRWMkPzZJsvAiJefLoyXASbb7xi9TbM7IwNXhi
         qiK/QZttwp/RNdcbUftBo3OrMM4Ysbt4oaXSDTILjmcDXnre2oUSd6t3FE5F4sFmAP34
         2Ztq0uyUzVITbVEAifeueo3lj60Zj4nJmV7Su0QXtfyjhp4amFCXrDvEQqe0fkmS7H3D
         03J7cpCWTFd4thCvkOvExgCulWhwOA3VTwqGRtvUbYD2rl/Lud/HQAi2VucE9TmHMUSe
         u3+w==
X-Gm-Message-State: AGi0Pua8b4vJ5XqeGuDHZ+fND7gecynC1z6H75O6RlkH2G82x1rcdXEq
        uYQebN5mnhebohh38+ozZ4zWqALmw6fNPzMgiTpEHA==
X-Google-Smtp-Source: APiQypIZ8veeEDjo+lUgr3Zq7S4vlHJw0TnTGdwtsBU58jPUEpCq2YuEEkO4skn9Z6IWTFDrhl9WTNkCOFOrY/ZWNNE=
X-Received: by 2002:a2e:88cb:: with SMTP id a11mr11649036ljk.245.1585691935430;
 Tue, 31 Mar 2020 14:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200331141448.508518662@linuxfoundation.org>
In-Reply-To: <20200331141448.508518662@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 Apr 2020 03:28:43 +0530
Message-ID: <CA+G9fYuZbptMh+_2V+iV9=8exHXeqG4+Vs=bX6AA20rOKf_iQQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/156] 5.4.29-rc2 review
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

On Tue, 31 Mar 2020 at 21:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.29 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2020 14:12:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.29-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
selftests bpf test_verifier reports as failed due to below reasons,

#554/p jgt32 range bound deduction, reg op imm FAIL
#555/p jgt32 range bound deduction, reg1 op reg2, reg1 unknown FAIL
#556/p jle32 range bound deduction, reg1 op reg2, reg2 unknown FAIL

Since we are running v5.5 selftests on v5.4 branch kernel so not considerin=
g
as regressions. Where as same kernel version of tests PASS.

Summary
------------------------------------------------------------------------

kernel: 5.4.29-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: fae891585ecda7f340d1b290d12a36152d913632
git describe: v5.4.28-157-gfae891585ecd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.28-157-gfae891585ecd

No regressions (compared to build v5.4.28)

No fixes (compared to build v5.4.28)

Ran 32497 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-io-tests
* ltp-sched-tests
* network-basic-tests
* kvm-unit-tests
* ltp-cve-tests
* ltp-open-posix-tests
* ltp-fs-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
