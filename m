Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316F01C26EA
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgEBQVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728353AbgEBQVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 12:21:17 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E86C061A0E
        for <stable@vger.kernel.org>; Sat,  2 May 2020 09:21:15 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d25so6146064lfi.11
        for <stable@vger.kernel.org>; Sat, 02 May 2020 09:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RX8j+eMX7l/I4yu6EXxXCXjENTwEgKOL12QRsPeepnk=;
        b=Ca5x4+lL0TXL6rtdMD8M/5G0NMMGqc2U0q37cm6ZSEjzNCyzaMDeQ7JWTllA54Veel
         qB4EieDr7AnAjIOaomrfPamq0HySp+xlvdKQy1DBnuFEkncwLWGDxLRtW7e2E2FtMF6F
         q6i2uLDIShE9/htg9NtUhQcg9KrUk1WL3k3A14pY8f1TJZQTcDbqibrDkyhzW7W8nSvS
         lL0G52OOxBr2Akgleu+Q+8IoiwY5VOWHYWGbahe4Y3UDiFgzPTlLWu5x22yOrxThawDo
         iaYxKTUfpFUzD8YX6ouri+KwSlp7Z0d0zbPR9Z/i/yBvB2z2s8kQsFKa73FXkVk90bDA
         2TSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RX8j+eMX7l/I4yu6EXxXCXjENTwEgKOL12QRsPeepnk=;
        b=bY7vChfcVQUUFv/0ChxMnV+Za2gkhEx7e6P0hEIy2Rbg7ZqPFeJAYcweTVjx5xoL6w
         NpThhojnm8nv0CKFXSzjoq+bWGkRYH5tjZgYCUooJetwe55NN7qCiNn9EehfPsHR0Bf8
         uRw6+MythrW4EBKpKDhZCox90ZQ5JorklM7ElK6K7n9ueNbsWmhSEtYOAGeP0Sp7qp3i
         Ivi2QJTQtR1B7YUqABc9PVXshwk19zpB+aNUUsAPJBUVkIFIxVm2ecTn8gKQ+fo2KhAe
         /uv6WyRz7nPz0uFmcDPhoYUSVYva5WF6KUSiFMYlKtjQdYtIzERbMuqC69GY0lGmRNAU
         0JtA==
X-Gm-Message-State: AGi0PuZM/icGh4vZKunafjcmoK+ObDQ2/Byy2UgoOps1VIDz+mmmup1l
        YetBO1fxhLhG4jtAGDzDzKpHjsyEAJQRjEoTcsFZXGbxKwosNg==
X-Google-Smtp-Source: APiQypIoY+z7MsrMDeF3c5PUJ3mNeNxQdXYhWlIEBCpY43BaMe0NNUp3Ai81VzjDhtXxECbeCNsTZuUe8J4P8lIQlAQ=
X-Received: by 2002:a19:4883:: with SMTP id v125mr5911231lfa.95.1588436473656;
 Sat, 02 May 2020 09:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200502064240.568495432@linuxfoundation.org>
In-Reply-To: <20200502064240.568495432@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 21:51:01 +0530
Message-ID: <CA+G9fYs2Cpkiy2EWnmjWfitCXJOzEDztBRFt9UY+O4=KgtvrzA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/70] 4.4.221-rc2 review
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

On Sat, 2 May 2020 at 12:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.221 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.221-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.221-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: f63f49c39d5187cb67e54f3f76dfa7b985ecee90
git describe: v4.4.220-71-gf63f49c39d51
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.220-71-gf63f49c39d51

No regressions (compared to build v4.4.220)

No fixes (compared to build v4.4.220)

Ran 16978 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* network-basic-tests
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2800

Summary
------------------------------------------------------------------------

kernel: 4.4.221-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.221-rc1-hikey-20200501-708
git commit: 6875f6cda49cc47e389b07560d3d140972014da5
git describe: 4.4.221-rc1-hikey-20200501-708
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.221-rc1-hikey-20200501-708


No regressions (compared to build 4.4.221-rc1-hikey-20200430-707)

No fixes (compared to build 4.4.221-rc1-hikey-20200430-707)

Ran 1677 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
