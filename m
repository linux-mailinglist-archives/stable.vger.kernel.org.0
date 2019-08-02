Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FB88005D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfHBSrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 14:47:13 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33498 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfHBSrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 14:47:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id x3so53735493lfc.0
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 11:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X3+bNZXgvXEGNlG2ziTE6HCZ1bNSEqqO3Mh6qezFir0=;
        b=adZrvhxNLzGBMLQsqkOa+TnMajVtpWXt4efpN08v3bVc5lh9COZ5cQjCHxDgyRvVbe
         5R+zYBjwO58w+1Z1nif0DPIUtLP4JE15hvwJdvju7adOVTl5kVbeNvI+LqFyYUSpe7zN
         yate4S4oPZnq93KGN47NrQIUXCdmee4T8e1XNmhNoSKcIEEATNmETvgAYYp+vIRHFKe7
         LDIlELYohPMjIm/QKNfC2yQfzB7sjdVW6ri9VgX9DJ+PubOrRfsE6DX8ddcuWheK/nBm
         aTm0SkQGRcHOqWK8iKS2BjBO0NINSFrFazPseNDdcI6okPhjZeAghU/klHwkxrO0dEPv
         M0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X3+bNZXgvXEGNlG2ziTE6HCZ1bNSEqqO3Mh6qezFir0=;
        b=UDVT9IZ9IjlL/D+KDxjNOvkkirX1xOP74dtA95EqnltQ+fhkCWz4QrnwVHqdRs3yf1
         Kb8SvkwW0ONeUXczbTGXlVMPRFGTyH0C9xQbUlLxolYp1PlrcY2zR7ZKN/hJM/mafG01
         NKFvPoyYfm1n9NQd3xzJ7lL7JAQvRqW51Oa08H4vsPUvRxfrXAlxj4pRg+zPtrUkYXVs
         empifpNdBVig0k03uy+jZPaH4JVyvKee8bET7g5OXv9LQhzFCPurseDnsZm2TEHcfdJU
         Sl/TwT6x9fMOksEqEHQahghC/pFFYnpfKaPwYkl5+HYEcxiqI9EGIN6JUDJbvUttVg7g
         dgvg==
X-Gm-Message-State: APjAAAXTJNNXYq6mwqfbyzQ21A4vgfHv1K2TTbLf3rW7IZCsuCcq2o0V
        qq4PWQ4EKWPp62C21K4fWT5Bs1tFUJBEEm3tcfuIUQ==
X-Google-Smtp-Source: APXvYqwZLta6ERudg+ktKleH4LZn4FrKyTVrri74LPomNmbZQziWx4WrhWKoYmv0NnKdwVgTRiy2RvY+eG9S7mQmVlM=
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr28295756lfp.99.1564771626906;
 Fri, 02 Aug 2019 11:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190802092238.692035242@linuxfoundation.org>
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Aug 2019 00:16:53 +0530
Message-ID: <CA+G9fYsxEw5H8eRiddWBJ2S894KTEVGrVo_B2gHdZ+X10WpZ5w@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/223] 4.9.187-stable review
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

On Fri, 2 Aug 2019 at 15:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.187 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.187-rc1.gz
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

kernel: 4.9.187-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 5380ded2525da1be5103e3f0f33129dcbffa3add
git describe: v4.9.186-224-g5380ded2525d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.186-224-g5380ded2525d

No regressions (compared to build v4.9.186)

No fixes (compared to build v4.9.186)

Ran 23662 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
