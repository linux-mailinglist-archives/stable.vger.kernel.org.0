Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABBF10D9B9
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 19:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfK2Ssb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 13:48:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44654 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK2Ssb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 13:48:31 -0500
Received: by mail-lj1-f196.google.com with SMTP id c19so5929870lji.11
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 10:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QcqoECSYUxhYpSdN4wxMXBNEGCg39mo2IFh0nw6OKSQ=;
        b=jZ7BIhgm8UD72PSplPNHz0eyDEVCVP5JMySvDokGjNSX+z5vDPQmPoeDGTLjwXiV9F
         EFnZgkvXyj6Qpq0NfPlBPKTwf2Le3DGB7/40nlUQ1m5BTk1+jeNbqXMWaFErdAVXl+gk
         9ILn86Uv/Mt7uH6h+6yxEyoI3mhdm8CnnfYFjh9hI+zADEerHm8n/28lIiXMWLIL0UF3
         KMzh14KuX1CieIVz+uYIsMy9O3iN6O4Boo+kAs8gawbAjRWeHtgfcDwtxjyioFdEXS+G
         /Tip0pH9AUYIWDGDcp9iZpCYbFFNn6MyWMje7rWqedlJnVMSY2f+vkf3SgXdKPO2dQvg
         7xFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QcqoECSYUxhYpSdN4wxMXBNEGCg39mo2IFh0nw6OKSQ=;
        b=GIiOEM9VV41ATLPZIxm7kbGgtdoIhuwEH8FRXAdTKpwDMhz8jxlhhSxvjVfPA0mF1u
         z8F6nbR+F5OTZNMGgUB4NlhUcSfkczOulLYc7usX44aHe/o/t9cAbMmSecqlsxqLjYAk
         W5EaxQAV1ZdGoMIKlEhVRjwVogmZSaqErXwiV0xsJNKWPscyODMb4xomEW5PCJbCH7pG
         hkXAC7eXVYRG+Ojw60gCa61nhXYj0DnErfn88H3Lsnuzc0cIgsA6IPNAhagX+jkCxO7Z
         fdzINQt71MaWYdwc7UEw1xxO6kIHb+ObxwDb9NkuomSInz6uymcrd60VU3ABzIUmK0Hq
         o5nw==
X-Gm-Message-State: APjAAAXb6bf1rEBKg+LPGV6eST0P96h/BWOZrvJ/rHUQR18t6CXJL0Du
        jRZe/iq2zWgpnmup3f2wGyNZ2eG52/tJpsAtnyBdXA==
X-Google-Smtp-Source: APXvYqyvVrld8vyHgVdXiWcIMSoaNJOGFRE9mApbWiRASu/dsO82pQLDOtIdNyuCNYdsR7YSY+JdGmc1XpHxEIio6Hg=
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr10137lji.20.1575053309059;
 Fri, 29 Nov 2019 10:48:29 -0800 (PST)
MIME-Version: 1.0
References: <20191127203049.431810767@linuxfoundation.org> <20191129103637.GA3692623@kroah.com>
In-Reply-To: <20191129103637.GA3692623@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Nov 2019 00:18:17 +0530
Message-ID: <CA+G9fYsUTrzt+q+D-wFagqVQFn+voP4dM7HdY+F+UxQx7c1pXg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
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

On Fri, 29 Nov 2019 at 16:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 27, 2019 at 09:28:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.157 release.
> > There are 211 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.157-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> > and the diffstat can be found below.
>
> I have released a -rc3 version now:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.157-rc1.gz

you mean -rc3 link,
https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-r=
c3.gz

> that should have the i386 issues fixed, as well as all other reported
> issues.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.157-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 36dea990ac35ede053b2c69d91cc480b19fbb7dd
git describe: v4.14.156-205-g36dea990ac35
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.156-205-g36dea990ac35

No regressions (compared to build v4.14.156)

No fixes (compared to build v4.14.156)


Ran 24559 total tests in the following environments and test suites.

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
* linux-log-parser
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
