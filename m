Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3E6CE37
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 14:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfGRMmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 08:42:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40139 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfGRMmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 08:42:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id m8so27152629lji.7
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 05:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oD5XEHM7kx3yyMtoXXSzAO3v41fm6Kmy/UcuiMgIOL0=;
        b=WbdqYjUCMs6tBv38XdWS8jEAPjbvmxT8BFqlOXRe2H2ZZy2gGuRmebYpTQkEMqaMDO
         mQ0gn7risnEs43Dy507iB3Klvtun7mwtM23eRiCS6Q1MgAlcKeAa1lAg4V1DsZMq2l01
         az5bhhoj8U8WIeZNqi9fm5yy2H2yjRZdoZkS+jC5K6Phq+5vTsUfMerY2HrSNFQisSyi
         JSNvVtg9zt+dv5L2KNItqZd030t99ywaRaaP2F2zv+ywa8yNiQzQwZReozLxwT6OaWsF
         z4w5CncjjzH6+czpUOlZGeLUNVO5XID9ygUS+12XiZpD/dMLDwWWqTNsKPL5NemMINSS
         L8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oD5XEHM7kx3yyMtoXXSzAO3v41fm6Kmy/UcuiMgIOL0=;
        b=qOWw3TG2ZbNM5scrXx96ETt/Oiw6yixu4TA2JpwanxRo7tnjFN0+OxFcIKAry/vtkS
         VXzEPffersuJTT+63ZY6AkmyZjNiAUsYL2rK/mX2pQaEkhvK6GgAqdLhOQNpImiyWtX5
         +v/l66N0vesLGQImPe3sG7sRQXttRzKpYAEkms9nRNeLp+zIUBYPJn7gZkTn/2IsDXjY
         Ji8g+7rDHwO94Vb6CGcq46S/2q+A1Iwdkf9of2HloL69+eo3yQYC1k2isjCWkLm+ybAp
         YkJJ2lq5W8RelhfwQjV91KfGlwNg/yNZpLoG6baQiJd0U6c5twyAC9hEDWefdnGkGQpq
         RWUw==
X-Gm-Message-State: APjAAAWxwYOOnFbJ1LTo/etz9f1MsZ5sHZIP9PHR7Y1naLDkxHPNlsfH
        YI0ShaJPJRp0fR7P4x7rtkS2GUJVEc6L5Q7aHsyZlQ==
X-Google-Smtp-Source: APXvYqxH66tL/Fn5fkuaZ0LSTxyIPpZlElb9j2DCmp7WgeI1hxLpc8MBFcsmg+yUYiQw69JUPCpJkWthVmng+B4l7Vg=
X-Received: by 2002:a2e:8495:: with SMTP id b21mr7607895ljh.149.1563453767877;
 Thu, 18 Jul 2019 05:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190718030030.456918453@linuxfoundation.org>
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Jul 2019 18:12:34 +0530
Message-ID: <CA+G9fYvXydEVdXBhLdagzj5gvxmdZgUkDQ8UFToRtb0UwH672g@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
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

On Thu, 18 Jul 2019 at 08:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.2.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: cc78552c7d92a2d16d8fba672a91499028fca830
git describe: v5.2.1-22-gcc78552c7d92
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.1-22-gcc78552c7d92


No regressions (compared to build v5.2.1)


No fixes (compared to build v5.2.1)

Ran 24019 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libhugetlbfs
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
