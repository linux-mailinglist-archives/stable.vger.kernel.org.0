Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA35F90A0
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 14:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKLN2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 08:28:05 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38619 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfKLN2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 08:28:05 -0500
Received: by mail-oi1-f193.google.com with SMTP id a14so14746111oid.5
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 05:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xgS1y/QHvwCZ5sjpMxBy7mjRARQgXnaQTp3ERHXATik=;
        b=kcbeO50JEcdNg0Pw0LEC6np76Jdau2Kt/RVNxJqhN+Zm1BftSorl81kFxfhsvq14Pz
         qMdBYXP/n1FC0bUG9YYZOAcoohj9pEI3/GA7gBrff40WbbLiCtZ3+/O3frpQ5zuNi9U6
         2oDn9K4EtmKjhcumjwFRRYmSojuQFXE06sCWt0/u92D5H8qD1Kek7uGsVe2H6GzN37WR
         IGfkkKYbZc2EMvromBeXID4CmmdoOcJIm6XUELSmBZsVC/1Pws2gf5+z36UMrRy3FKVH
         Sby2HoK2ElNJnTMjw9QxTVJYS9ebVIZkV8GjOhReUgkvd2xBq/hPgK6uy/ItN8cm7y7G
         l3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xgS1y/QHvwCZ5sjpMxBy7mjRARQgXnaQTp3ERHXATik=;
        b=o1+D2+vaW/4Jb1PRHll38ZU/5Od6QtCs9WptpJEwzoRTtLDdysEzFF0WfDZXOL938e
         yVSiaDDcFIM4mj5pKO8EdRRe/vmR5omS6dcZQqh+pJM9vBfguz2EDUV3PbZxybOlOpSX
         UF5CAcif7Ftfw9TwTz5QxNrRwGgERpnSjHl6knw7mqrqFOKqXWMFEhN/sVIB5r/H21rN
         RsmycFDoWeelU4eG50BhXLAgu8IMQWWCCIMpGsWsq806MbfEmKRyn+8SJzF7YAuGnctS
         cr3fs5Qa8Sh6eRG9/t6jRtAsmYm5NFFxWtKzebIOh7LfcPIt8NHANvCyGKv3Y2ObrsBd
         dBYw==
X-Gm-Message-State: APjAAAV+9wTsjWp65Vf0ppVxVrMabRgSAkJJw8dcHzTUmxk3WyWendsf
        o0XRHPY1PO4eR//+GqPZJd/viOOMytxgxuO5jfbZwg==
X-Google-Smtp-Source: APXvYqx6P4E8F+B6CNZl1GqtAqaB2TmVKdqSNhAm/eGudHq4qNyeJOK+tD1sUL3CMxIHEHIpsgYEcQ8Q9q7Cq2ChHjE=
X-Received: by 2002:aca:b10b:: with SMTP id a11mr4107736oif.138.1573565284430;
 Tue, 12 Nov 2019 05:28:04 -0800 (PST)
MIME-Version: 1.0
References: <20191111181246.772983347@linuxfoundation.org> <20191112052741.GA1208865@kroah.com>
In-Reply-To: <20191112052741.GA1208865@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Nov 2019 18:57:53 +0530
Message-ID: <CA+G9fYuf=WM_uEnixJmd7mx8LWy3THgVEcZu5H4yfD-U1thqQQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/43] 4.4.201-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Nov 2019 at 11:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Nov 11, 2019 at 07:28:14PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.201 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.201-rc1.gz
>
> -rc2 is out:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.201-rc2.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.201-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: ca1d1b5f0f2acd3d552c3c74f44d984d06f2d595
git describe: v4.4.200-43-gca1d1b5f0f2a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.200-43-gca1d1b5f0f2a


No regressions (compared to build v4.4.200)

No fixes (compared to build v4.4.200)

Ran 19919 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
