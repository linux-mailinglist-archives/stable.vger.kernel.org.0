Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36D812832
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 08:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfECGzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 02:55:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36864 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfECGzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 02:55:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id b12so4355893lji.4
        for <stable@vger.kernel.org>; Thu, 02 May 2019 23:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8uvEev8OEJSKiqMfUu7nupOCG5+qPkoDHo3MegtTKpc=;
        b=MbypdYe3hHevkcNm3qZEX6SiMkB/0T4Kq9NaFnMcm1oNtt/iri3njYzkp03+TNZTiE
         765v5ZERux8jDdHOVimnbUvv5WoKZZmIZ35ZXqd7fOldJuG8tPaocoITMs4e592t3gEM
         SrH23pCEzmSn5BFzfTHZZVKjPSrDIERerkIiX7pUIsgvYRsy4FHO7pNp5V+FpmVBv8k5
         GeEdZFgPvoHFF4OB+B0yHXB8m4xTS93zywNU2VO4Qoa3ICE3TXECsUlQLDbu7MS+j5n0
         yRi5wZUvVhl7s2zmsMscheQi0onIor5BhVgaZix0133mry66fXQv+Pmnc67cS36bHhaa
         s2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8uvEev8OEJSKiqMfUu7nupOCG5+qPkoDHo3MegtTKpc=;
        b=NPun43ig+68FYQbW8V5CU6k+0Ff497ViVBHIAGUV219GUosm9zN5wJdQvW0sud+1IO
         6PhhWDz0B+bE9O+SkiklCeM49atmckC3AfjdeCmrZvuqKIV+ovEuw7IvhV++RRWyajuO
         aAWhRiXB1esTpb3K2AKcOw7aYApl/pjzBJIOX2Wh6+fC9q77rgcpntwzBMvezwwR4EZE
         o2HV5eUXbRt+dCIARWhgXwyuQyH7izbDbOuW7KGPTMEeUOKLUfHngI5XnGQi02XiOB6j
         gPfEGMr4YGrjlYQ1Fp4hqV1ZSdv2hK+/2Jwaz9B6cZTMwIBd4p8VkeMrxWZdeey5fG1g
         4EQA==
X-Gm-Message-State: APjAAAXkejkD9wV3f2iI+LIsj5fVWXCeHISBx834a1NxY99ttgFl3tYC
        UyU83WDMZaEvGmh9yTPhEGt/UzhAdO4Pb1gLmC4TrA==
X-Google-Smtp-Source: APXvYqy3oHrQEAy0Ec5a/CDBI12pjIJj9AddzOAKNi7WumWeUmoV5tEG0ZZARs4J+XJm26mAejLWkix6cvcn2OjUIMA=
X-Received: by 2002:a2e:9689:: with SMTP id q9mr4005261lji.194.1556866539449;
 Thu, 02 May 2019 23:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190502143323.397051088@linuxfoundation.org>
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 May 2019 12:25:28 +0530
Message-ID: <CA+G9fYspsUatix7BpCnwzDLkLEO+VkZs4JJh3mmkN+XEzSynvA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/49] 4.14.116-stable review
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

On Thu, 2 May 2019 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.116 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 04 May 2019 02:32:06 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.116-rc1.gz
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

kernel: 4.14.116-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: a4aa5bff075214a024ba945abb791813e33860ac
git describe: v4.14.115-50-ga4aa5bff0752
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.115-50-ga4aa5bff0752

No regressions (compared to build v4.14.115)

No fixes (compared to build v4.14.115)

Ran 21683 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
