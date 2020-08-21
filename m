Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F824D1C7
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHUJxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgHUJxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 05:53:24 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF26C061385
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 02:53:23 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id r197so257998vkf.13
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 02:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mqdF4DU9Fq0gDTPH8UgXtcco5abUWNAad4E1i3Fz1IQ=;
        b=KU23PN172J+CZc5BbS4Jy6R+NT636uXbvWCWiHVQkmKwkfh/mUK+9arz5mELEsZROX
         QbjGgFT/Kqd0pkpmOMBfB2CFFFxegUSVY0LlwYmN1t+bOy3VYGr2M8jG34O0ouejEWue
         3g/KLuLFVSuDbta5+7PtuvkuqS5s15i8hLfwDXo4saverhirNEQC+9dydZNwxWvU4vUr
         0dMLuWGsaDwZrufPNqgwvRt+NRxCr9Ri3xhwmTakONJoub87FR9WFeEdW7tVHA6MuZj+
         BZqrWlTBbSZk7kga9Z9hwShW72JPkRm1s2FBTy+zS8HJio8fJ0s4BD7AkQkMhJfdW4HU
         q4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mqdF4DU9Fq0gDTPH8UgXtcco5abUWNAad4E1i3Fz1IQ=;
        b=n9OVrYTlSAWOGqvpR2Yc28ixIhkg5W34WuBXXYxk2fxFPvLoJg7BsLK7sY5mUqfOQ9
         9wJHm+Yaq+cBWcy5BKH6KVrf3MY47VViQOX4+cy4O6qZLOLm+DiCMTgeA9pQQ4hY6K1u
         2c4yJ0G+M98YpwTAupkR87LlxzmtIDjFQTAfORtyUkf66OJZDLpsjaSKnKbLArqZHxaR
         aD1bguvk7J5hP0FGhGLLgGPStFHQ0UQaNXso8/hdVDWJ/NFCHuGGIq9OkxYk7F1VWqq6
         EKjmeqpLGy6i/Ny4nd3OIHqj38pb9676/IKid86RiACUEM24L0819wrlBvVc3wfKCoSz
         KRQQ==
X-Gm-Message-State: AOAM532j2kv8VMcZl+jxeTFLjh4TCiZCwgiBc/8UUya9OaRZP19JDlU4
        co4nGQGXT1gWfI22r2onvH4zpLvOgtzoA5G7YRPOYA==
X-Google-Smtp-Source: ABdhPJyQEswyIdMCighk/Q8aG0xznm4gyr1xexhr8haTDjldgnUnKYlq10/pu4REc4KPzQ9yhk7lWFMDRxSYAbom6vg=
X-Received: by 2002:a1f:a256:: with SMTP id l83mr991966vke.78.1598003602721;
 Fri, 21 Aug 2020 02:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200820092125.688850368@linuxfoundation.org> <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
 <20200820150848.GA1565072@kroah.com> <CA+G9fYu9r8wfWVLmyMC+bbnCbJH1Zzr7ps_4N0coybYEUenUaw@mail.gmail.com>
 <CA+G9fYv=aMoHJs2ToyhPyG13qmcN6o26MHW=zKnJwmevyKCo3g@mail.gmail.com>
In-Reply-To: <CA+G9fYv=aMoHJs2ToyhPyG13qmcN6o26MHW=zKnJwmevyKCo3g@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 Aug 2020 15:23:11 +0530
Message-ID: <CA+G9fYu==XteDhGytOvZ2cPjNB1rddNzfJ435eLxAMuhQKVuOA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, danieltimlee@gmail.com,
        masahiroy@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 23:26, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Thu, 20 Aug 2020 at 22:09, Naresh Kamboju <naresh.kamboju@linaro.org> =
wrote:
> >
> > On Thu, 20 Aug 2020 at 20:38, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Aug 20, 2020 at 07:49:06PM +0530, Naresh Kamboju wrote:
> > > > On Thu, 20 Aug 2020 at 15:47, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 4.4.233 rele=
ase.
> > > > > There are 149 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-revie=
w/patch-4.4.233-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git linux-4.4.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.233-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 1c57f0a7ac3845a9f81f463bcd28d926afaa86a7
git describe: v4.4.232-150-g1c57f0a7ac38
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.232-150-g1c57f0a7ac38


No regressions (compared to build v4.4.232)

No fixes (compared to build v4.4.232)

Ran 7413 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* network-basic-tests
* v4l2-compliance
* ltp-syscalls-tests
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* perf
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.233-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.233-rc1-hikey-20200820-795
git commit: 00f7a2d07eefd72ddbc7179ea7b911111d8d7df0
git describe: 4.4.233-rc1-hikey-20200820-795
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.233-rc1-hikey-20200820-795


No regressions (compared to build 4.4.233-rc1-hikey-20200819-792)


No fixes (compared to build 4.4.233-rc1-hikey-20200819-792)

Ran 715 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
