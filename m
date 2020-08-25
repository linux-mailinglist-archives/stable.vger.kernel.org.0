Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC13251175
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 07:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgHYF0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 01:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgHYF0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 01:26:11 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CEDC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 22:26:11 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id s81so2548542vkb.3
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 22:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oB+i7wMr0KfB72EjZ1LpLq/WO77f/RwcZzv58/vqEgQ=;
        b=KJ+kJnBUhtC+EU/lnfaRBtcxsb6wwOUgs0eeMukdCnJBjSds+CiMC0q+ymQZawsHe7
         5enE+fuJsht0gK9F/uKBSbH0J+muHKt5+oGzIQV52r5PJpi8Xz+z1qZ49kJK7avSLghY
         MkV1jco4wImjB97UHxVnuGhKedDeWFCNLCXxYNC0SZYga8OyLsUHSSxCF2/5CSWJD4LY
         bBT8sFMHctM01/asgUySlcNxtj/QVJHnXDjbOf0181MJ3SajC/9oCIvHOIuUX5SbPCB4
         Gh4OoborCKHVaQhE2+VkEzhq3hiFo4tpxx/WNKfxLN4SNRQnLfIEWgnQF+2W8OU1CZGD
         a0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oB+i7wMr0KfB72EjZ1LpLq/WO77f/RwcZzv58/vqEgQ=;
        b=r9OePjm3teS9SHE+WNufKO/WtkIipiLNtEZ/g3TcfdFQWwyqcOkjojzrfjrUv1jCnp
         Wtyn4W/6DuG0fXP+YdC0y/Uz3IjsarOEeB1DCZL+LuIsIF48tDvI643pbMVC/1yccuaq
         wR2zQKP+SKcx6NQM1puxMnAnhcFtNHlRuuVEL6yV44561udjPN8zd2WX9viyrBRRMA+Y
         h2tpSfZ5SAfn3WeIlbbr46Q40fxBqjfnTOqte5wNSSac8lDuVyZ60kYZHQU9tJ1j3o83
         6GskvYtwdgAR9j/tq0X5sUqT/Yb3vUEzWsn/QURp13p/Bj9pAOU4eXIFNlC5HqWmLKOY
         vdVQ==
X-Gm-Message-State: AOAM533H1J6nPwrHVVE7UDkABXgBs4QDUDky8gEnu+pPhaJJzJg1Z4pW
        W2o9MRH2DCKLn5iSjw46IexSd+E+O0koz+WDDLWv/A==
X-Google-Smtp-Source: ABdhPJzoskqzz2A8MRBsPq7T9cAENOn46jOiOkgnZKdRJFor9LZ6YhwTU+6lNmuu4fU1i88oxhTX1TKpNYpGl+xS92U=
X-Received: by 2002:a1f:eecb:: with SMTP id m194mr4451297vkh.40.1598333170253;
 Mon, 24 Aug 2020 22:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200824164745.715432380@linuxfoundation.org>
In-Reply-To: <20200824164745.715432380@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 10:55:58 +0530
Message-ID: <CA+G9fYuQ5+7HW_K2GieeAX3jubxqUXADd-7_Sx89ypyAmKUJgw@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
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

On Mon, 24 Aug 2020 at 22:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.4 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.8.4-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: ff3effda97baca98b891a29109810f88883045ac
git describe: v5.8.3-150-gff3effda97ba
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.3-150-gff3effda97ba

No regressions (compared to build v5.8.3)

No fixes (compared to build v5.8.3)


Ran 37993 total tests in the following environments and test suites.

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
