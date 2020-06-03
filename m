Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7E41EC94A
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 08:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgFCGNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgFCGNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 02:13:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5B2C05BD43
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 23:13:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e4so1210345ljn.4
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 23:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xk20P2S7rDaUSDVCxxVxeXJ0wXIWFWiSC2tdp+gpqnA=;
        b=fsGluz86vOjHN2TBk7/t+PLrMaZOi9+uqgGmTsnkoQdc28EmAYL4vUmyrI1Yx+4r9v
         dc9hA378SMDasdLLSt7ed+YXpkCM+PQ27N06g3k5Y0rnIGfR81Fq80Vj0MYO8g9SBTxt
         B5d2A7eg62WtGZjEuQ6+xjGev3ubE0hFTJ8NzMfWpjQ7NzXRtVOK32KIw3QtTaQ7nRWk
         WNJ2rB9leySe6hSWTDOiPTu9xUnryNQVS5WzaFroFjlroZIwnPReQQr13Wl5e9kCV+t+
         GAGdkTK2bPbCfp391bf8sH/zhTp+mKjKFisqEm9BmoFBmgKJjCt7qWk3mUq1BnraSRYO
         UjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xk20P2S7rDaUSDVCxxVxeXJ0wXIWFWiSC2tdp+gpqnA=;
        b=dbta9+gCSEBAI/DwyDjWzQkhfq1YO4JxRjRSnAxk5KVuJNwkkpju/5fAEQdBXSiYPI
         ynQj8NFnu7mGLHqYVrFcUy19orhnzGVKctGvk+pGgZfFqB1pl9ORRsWQ/lwpKZPe26Qj
         48YpBqtMo4+T9GMFSZCvzw0VTjrb6jZbto4NO6dktAIJ+DKjSY4p2GjuqUyUB+lzfF6n
         F3iRC4HROzKT+ux+wJWC7C1xBWo931IHW3iPPU63mljHP/T80jGJDG85uFWllOq/hsM9
         DKlnewzZ3qFzFxJ1sf2NYhzpdkKnMmW7ptUiRLwohJ3m7vrfUntDL82iNH2+lhxpfW7F
         SP/g==
X-Gm-Message-State: AOAM533UdDAS6ke7kJDUeIa4PFTS+J93pcYPqONozcRO4n3Jp++CxTvt
        6AmoYLMwS6SCf35DbzSYQcp9+/ttxLAg6wCjAfLMHQ==
X-Google-Smtp-Source: ABdhPJx7/ynr7nesYDFxGz07duEAXFlWwMJoMBfkXUk50wTWbVm+zrhC5l4zwQj/Mj/wyO9X0MbnDFPlUTk/LMPDkBk=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr1205380ljj.102.1591164779850;
 Tue, 02 Jun 2020 23:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200602181325.420361863@linuxfoundation.org>
In-Reply-To: <20200602181325.420361863@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Jun 2020 11:42:48 +0530
Message-ID: <CA+G9fYsU+pP971z2sOjyJbW3jiiTa=TK+GJTCZ+-TF36krCepw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/55] 4.9.226-rc3 review
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

On Tue, 2 Jun 2020 at 23:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.226 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jun 2020 18:12:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.226-rc3.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.226-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: a836fd8c024d14989c7cbfb91040e805b093f1d7
git describe: v4.9.225-56-ga836fd8c024d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.225-56-ga836fd8c024d

No regressions (compared to build v4.9.225)

No fixes (compared to build v4.9.225)

Ran 25363 total tests in the following environments and test suites.

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
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-containers-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest/net
* kselftest/networking
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

--=20
Linaro LKFT
https://lkft.linaro.org
