Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89D19BCBC
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387565AbgDBHct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:32:49 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33071 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgDBHct (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:32:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id f20so2189511ljm.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 00:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KCRvXmznyUru0bfTbtl4BOGmXSWydWSvDGeo1jLZGE4=;
        b=jT68wIMnkD5BYeB9SAi/0kb6KFG/QhGf0CduAmwTrQpDPwT0N+wFDQ0OEb81JMvHSJ
         ArNdMQPrY61lV9u/d7sRJ+ifBt+tH7mY9P3RKv7FNRM3P+9NeJU7GG6t1zuOYjQ/AqHz
         OSvmpQzG8R8TKksCX71UApVMh0XNaImeY8rD1LEcy4gxlE+VoiFiXkPQGnDrTurlnPEh
         A+hfUFjhSWpWkaVnqfINK1j2LGAOyLv/OqZZIZ0QUB0ElCVr+dUj7FZzWILJtVo30zQt
         CxzFCHvOwmEIe6lbaoogIqwcY3UrKO37Hgnn+XL5a7hY939tuXhLSg7d3sGPFtm7t1OH
         PU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KCRvXmznyUru0bfTbtl4BOGmXSWydWSvDGeo1jLZGE4=;
        b=TdXQtZ79fC1C5vBB3dqq+OGjwQyHv1MS/ez/uUWM7MGt5+wHXX0enzXGqXgDe3RohE
         LlE9GYuryB7h34zeAMuU6Hzz/kpgJX78Ith8DhW4KZVOO+AEXUB3A2NcegS3TC6dvqWX
         W3oDqygKzyXWuLKhCs2CmFmv/yUoO01YVynO9t6pGGELYjJLjh62/hL5/E1uCu9Vxarx
         n46C1zyHZmL650pqTrznLGDCQv3su/giJiM5TfB/Ne5E0MAL2wEk9tg4VeWSv339a9rE
         6CCNXwE7l52HLyuNYZWioB9eoW8T/Ul4zR9aoIYj03zUVDjJ31DYqRExb2fvUzIDZrTL
         ICdg==
X-Gm-Message-State: AGi0Pua8wbdHvQQQ4ikEgwKEvklmP90nfpj6ORjZZNzKqo91rV6T9L0J
        VU26b5rmLpezFA+9pqejm5pYCCPUpzVLQbzuNQ6Adw==
X-Google-Smtp-Source: APiQypIbwgpPJFbYeng+8S0ZbPhuz9yyXh7XXaRadj01ToK6KPTk9RDdvXIGjvDKk1m7fKrotdSA7eXafJ97vPnrxLw=
X-Received: by 2002:a2e:a495:: with SMTP id h21mr1183615lji.123.1585812766658;
 Thu, 02 Apr 2020 00:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161512.917494101@linuxfoundation.org>
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Apr 2020 13:02:34 +0530
Message-ID: <CA+G9fYtWSxUcLUahdoCq9rFHn+0L_+MnZ72DZ3h0utTu75+iow@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/91] 4.4.218-rc1 review
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

On Wed, 1 Apr 2020 at 22:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.218 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.218-rc1.gz
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

kernel: 4.4.218-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 2d26509e19e30e927f01e298d1ce71dadc5ec33a
git describe: v4.4.217-92-g2d26509e19e3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.217-92-g2d26509e19e3

No regressions (compared to build v4.4.217)

No fixes (compared to build v4.4.217)

Ran 25708 total tests in the following environments and test suites.

Environments
--------------
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cpuhotplug-tests
* spectre-meltdown-checker-test
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native

Summary
------------------------------------------------------------------------

kernel: 4.4.218-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.218-rc1-hikey-20200401-681
git commit: 8cfe8e5827549778e493ffadf6ed59a020a03830
git describe: 4.4.218-rc1-hikey-20200401-681
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.218-rc1-hikey-20200401-681


No regressions (compared to build 4.4.218-rc1-hikey-20200331-679)


No fixes (compared to build 4.4.218-rc1-hikey-20200331-679)

Ran 1355 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
