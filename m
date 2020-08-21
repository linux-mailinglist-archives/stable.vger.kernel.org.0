Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AEA24DADB
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgHUQ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgHUQ1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 12:27:54 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0538BC061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 09:27:50 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e14so1108557vsa.9
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/GcDocfNWlsHOofca1lhYyAuuxEgmTJVpd3FlNUUBGs=;
        b=qtoR1Xj5G0WZ8QL4GewEzAeautrks1sglx9h0y1XD/U/sV1H14gPJOVob+hAVyzuWi
         vmSZLuposmeZGaqsYSXnbCZZysqUqiz05bYTPi0leLztW/ALZvnR9Ro6vlgoClc6uLfk
         vTQIBihBwOXenWsbvw6wbQ3MSpzfut41VRbZGYr8KAaTdvWvz+dSeqlpC1y1ykWz4hyV
         5O8hg0p2KUFKKpfbugL5hqI/cLnYE88sTQOBduVEYi3nkDS0jrg35dRaT3NbqaImX6yL
         S5jQCU4gaoJJkLlye13gINEWui5oxga6Pfdg6Vaw13bKnF3SBn5Ap6sH95bOCC2MMFph
         FDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/GcDocfNWlsHOofca1lhYyAuuxEgmTJVpd3FlNUUBGs=;
        b=iMap8l/WBFdMx9le2/5+tN1nd8e5qLrHCStpXNFf83FQW/eJqYDIYLe6eYj9zkRTJl
         NPoD93/2ji7vqv+Ot9MPdCOHjeB6h/YlfRJtVz+wtKLUNgWEhcxPcfMThjigSMP+zyz8
         OASiSNpGUNYLOvvTe0Uq/wCd0uF/+u0qa63I4yutgHf+dY365pm8nI4nwzNsTvUQbg7D
         oaozpkhcyIRml019R2A7lKrFKKWKdpwD6fI5lrSQL8oZZikL7offGomoj5yaYZ4O12gG
         m/y3Tgn9BMRM17mNI21k6FJl6AuX4aFwh4SWk/EQtPKqM03JPmK1oXmq+vuMU9uDN2AF
         AoLQ==
X-Gm-Message-State: AOAM531VMEFmvlzhjoQwQe0lskWl66V2wcJVxzGb8EoqZVDTyn+X5lLF
        5V4i7n54ANTVJTpVe4e01ylfDvAcTJmFZ+2hYSTQjZiIar4vaaQe
X-Google-Smtp-Source: ABdhPJxfZTzNeoUJqcWkiwBAUzjPgoHL9IdOu6JvriTmuJqzvXBgTdaCMrHdKieuP6epggVQamjMxhTGw9Dnd6+U8cw=
X-Received: by 2002:a67:d84:: with SMTP id 126mr2497327vsn.69.1598027269072;
 Fri, 21 Aug 2020 09:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091606.194320503@linuxfoundation.org> <CA+G9fYuCgzAOZw6iM6sLwJP9=0wrO0WcTHLCQtEHWQB9=WCuSw@mail.gmail.com>
In-Reply-To: <CA+G9fYuCgzAOZw6iM6sLwJP9=0wrO0WcTHLCQtEHWQB9=WCuSw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Aug 2020 21:57:37 +0530
Message-ID: <CA+G9fYtQcFnyKMF2uE5WP5Fhk1E1MjymrsM1ZpChk0OJP+56vA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/204] 5.7.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 22:34, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Thu, 20 Aug 2020 at 15:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.17 release.
> > There are 204 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.7.17-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> > Herbert Xu <herbert@gondor.apana.org.au>
> >     crypto: af_alg - Fix regression on empty requests
>
> Results from Linaro=E2=80=99s test farm.
> Regressions detected.
>
> LTP crypto af_alg02 and cve-2017-17805 failed on stable-rc 5.7 and 5.8
> branches on arm, arm64, i386 and x86_64.

Apart from the reported LTP crypto test case problem all other results
look good to me.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.17
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 3f45898cffc4e386952f3e4821810500adccea1f
git describe: v5.7.17
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.17

No regressions (compared to build v5.7.16)

No fixes (compared to build v5.7.16)

Ran 32841 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* ltp-containers-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* v4l2-compliance
* libhugetlbfs
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* igt-gpu-tools
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
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
