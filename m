Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD56A254006
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgH0H7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgH0H7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 03:59:43 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3DAC06121A
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 00:59:42 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a13so2334545vso.12
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 00:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jeiL3ZW9Q24zFafIfqpEY6XXxnRcRe9B3BJI/CvcAhQ=;
        b=ttYlpAvibE09sv4g+jDnv4M/zYxxQixgtwgM7MBSfaIEVQvNUDWrjAgpK3fLoeqsyR
         S9OpTWW3Dfy8WdGmY3zTDpvMzcqs+6aXmYCncxKYdMAtCKYuBmoiJOOpV4+LvH/NklZe
         M0GSUW/o+AvCVrVBcen05ze89i7kXxihW+rf5lh3Zj+joS24t1Htjm4UDoJYO6QOm22v
         tlCITesDeE/pRPEoDBvP+Qd8fzqpHQuPd8O001xhIOTn2RmEHEhYhEq0v2pf33IG2KwA
         h7F0mrsxHhyeCK8dfC3V/qpPVJYC+6YSopVIOk0+mjmqZl+dZweI9O6INyZqNpZ//VlV
         9JMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jeiL3ZW9Q24zFafIfqpEY6XXxnRcRe9B3BJI/CvcAhQ=;
        b=J22l+DbKl/NtlY8ERu7+XkgD0gXKoL+Ju/mw8VwtQF015LI6SvlZexTCn8+EJiEZkk
         Yg7CgB/ORpg6juMoGA3hNRHqw7GaECGEonA4SaIGMfvxFuMRqJAYW40LmbkJUo7ar4p5
         kM3/l/xLRXG6EIreIgAO+iJYMV3fLDvpGRxtKNltbBLIjWVDDcnozqbeWDcsVzBhF7hS
         8ht6Q1DA331mpNaVrTvZ0Mf7wdw1ACtD1iJC/MOyYTxU85PEdhaircwTdQKxah67/nj6
         HbvncPGIyYcpnZn114PwbmkoeuWdZphhLOJ7LMutU0aJgn5xbNKz3lREbpoEDZ1mXIeY
         GRgQ==
X-Gm-Message-State: AOAM533vOTfe8uT5qJ6QRQHdrcIO0UPRBK4qDkMM+80aK9lSkVIsnh5D
        dsZs+NWWgdzZCQOMSwe3rEA11U15qExeq6CmTPz6mQ==
X-Google-Smtp-Source: ABdhPJxCm6wSkXTn/6+z1zNmjPuNxr2QFFQnnfsbZqpUeI8Ve+W4GOE+hozAhT2HfIOKhe4jgCSRDWxMTxSYatoQkU0=
X-Received: by 2002:a67:7905:: with SMTP id u5mr11518557vsc.179.1598515181832;
 Thu, 27 Aug 2020 00:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200826114911.216745274@linuxfoundation.org>
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 27 Aug 2020 13:29:29 +0530
Message-ID: <CA+G9fYtADJqfoq1gijs1DxOAnyQJTeN1T=ybaMCEH8e-059ZwQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/16] 5.8.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.5 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Aug 2020 11:49:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: a8485efcbc7066059480098954524ceee6afdfe3
git describe: v5.8.4-17-ga8485efcbc70
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.4-17-ga8485efcbc70

No regressions (compared to build v5.8.5)

No fixes (compared to build v5.8.5)

Ran 34357 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* v4l2-compliance
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
