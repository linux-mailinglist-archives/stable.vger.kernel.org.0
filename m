Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8760B19203A
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 05:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgCYEuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 00:50:40 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40178 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 00:50:40 -0400
Received: by mail-lj1-f195.google.com with SMTP id 19so1048277ljj.7
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 21:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qiUPewOd/5czYbVwyunCDVVRVz+6K1hlh+LYVUDWDAI=;
        b=fyDxva++dKPVmJpMc1UNYixdtpptpLXNP0vne78JJoPfPQ5VqYYES+1hRvKsOBCksd
         bgm3MFOxlcQ74zK0nkE1O9UATNIaJw8yTnN2Q3WL+TebkfVBRpMTy4wQVto16x/bT0TY
         8pUOJOn6hOrWSfiWL5ATYD41GifiBkSt5qGoXhvBdONcrIvoqhtrWtOooZigLHFagpk1
         5GbDOwmzfnj80WxlUibRHU6lwE/d7CyPQ8ptBRyf8hVVDWMhJooZRMFMWnREDBP0+A3Q
         F1xMwFcwgvx+JB4hZjY7PGL4dKzx60jTmyCvsoMCeKveHom70mch/8TIl2PdORyVM7+F
         TdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qiUPewOd/5czYbVwyunCDVVRVz+6K1hlh+LYVUDWDAI=;
        b=lqETd7G84jrR40hkd6zt3jU6lfwmbbJ5VkGiiOGpErmZbBfz+I+d3ekFfO/m03oPKA
         hRivgYoIkya+B4z1TLs256V9dS45ZDAowOEX/7kIl+KTeU3FR34QADFzX0JjQVcf8yzx
         pqayRtKyysrogwX0reov8DoHtOV7ntZWWvnnSLH2hupAE80jiyIOTQ283cLEnp5pvPL/
         zhgCpIRKYDIyCkF4sbG2GLllKLfqO+j6Mk3kMbQpbF0Ps/J28djPoaR00z1nx+9Ir1Sp
         8+ByyTGfn2BEh35jXsLf/zXfdnIaVyOs6OxpuM6HtpyDx8vP5OHsrCpO9ceHx2kHo332
         dCQQ==
X-Gm-Message-State: ANhLgQ1Wg7n7tMEosnmtaA4OSFWkx+W3uT8iAVB1i5bSbmF89ZQyd/S0
        0Q5fa8gbI6JHK8Qvz7VawvhbkU4ik6tPn6OcceY/GBG/vX40OA==
X-Google-Smtp-Source: APiQypLumcneypmhNRcz5X0RuGTVan1NQ52SOXC/GITbzdZ5rJLcsDvYsWr1tJ1QnfJ17abPLYr/qRtv4JzKd2faAkE=
X-Received: by 2002:a2e:8015:: with SMTP id j21mr688744ljg.165.1585111837401;
 Tue, 24 Mar 2020 21:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200324130756.679112147@linuxfoundation.org>
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 25 Mar 2020 10:20:26 +0530
Message-ID: <CA+G9fYv5MoKj6OVmLe=nRZy23sKjiqBMbhoT6MTQ0gj7wCORng@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/65] 4.19.113-rc1 review
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

On Tue, 24 Mar 2020 at 18:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.113 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.113-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.113-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 69e7137de31c53890ed823aee0818a6a6563c445
git describe: v4.19.112-66-g69e7137de31c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.112-66-g69e7137de31c


No regressions (compared to build v4.19.111-44-gd078cac7a422)


No fixes (compared to build v4.19.111-44-gd078cac7a422)

Ran 24703 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
