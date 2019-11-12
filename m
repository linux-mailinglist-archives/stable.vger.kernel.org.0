Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510EBF9099
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 14:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKLN0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 08:26:33 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36053 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfKLN0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 08:26:32 -0500
Received: by mail-ot1-f68.google.com with SMTP id f10so14276242oto.3
        for <stable@vger.kernel.org>; Tue, 12 Nov 2019 05:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h7gNuS9p6cP0bmIhvsGxMeUDxcBC1KUmMQ3LFSAd6gw=;
        b=ULkqAdQFNZo3jskXqOoy1RAlkyzRdK6kMQK5jZEbuOQs23b00AYK8O262HJehfJ+f0
         eiWBYZK0TNPfN2d0Nryvqb0GBOnpYqrU3bu4RbE9S4PcxrxLrTk9oQjEnzcwnk6udXY4
         qe13l5l9/GnRfepfIMEApxF8YFawxqJGiglz1u7VFhDSNp9Zg+XPGIFpWY55BDE7pOQd
         1WnKq3WOrp+gT48gqEZuZjviVJxnTJZAJ1wW/fZsU/6OgZ49ke0F2OeMoXoqO8c3+ZAm
         VgN04hIZ+afoDgeg6EAx2svgVVuC0zengnNQYo+gusn4EmxDMYxNlboHzyubPG2UmfB8
         Bjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h7gNuS9p6cP0bmIhvsGxMeUDxcBC1KUmMQ3LFSAd6gw=;
        b=OyZZQdOrdEpk+vcDBTylRRBVXRdoFwUA8iiGYy7XjkXHkHC4Yo03jY/KpQ2WuowoEv
         IJtSeF2WkF4oE9ENU8LUX/cAucUbYpD452VuM01+sZCU864XXZz29eHaSRt0TsL5O3Tw
         7D23TQe2norR6r+SRZsrB7bqwz56vhG8IsWSiSS6g3gRUXjDw30r2p9yTG4aSzRwrNwM
         oo1ZPlnTFJkSR7Z2mX7HQmPAWsP9SjC0+llMIpZl8sWrNz6/uJOvuHuhA9bTLXm1EGDx
         g/s2GDJaouAmpSlWmaX+UGhgZ+cXTZXGIQDVT/UWQkcAJMDSvblWj7kynUMrADEKcpXA
         z8xA==
X-Gm-Message-State: APjAAAV8s3HxrNhXQ/FX2nhwDq+GnEnnBoWoevfMEZ+SJ9qHkIFJKDoS
        80WyAiGGZmluEPCaHFPYpUl4AUs4bLpX85p+wq6b/158vAs=
X-Google-Smtp-Source: APXvYqzkCDMR3BU1iW92LaoBF5oRAgEq1nnEl6n9d+XmKrd7Vs0fILuL5Poq1Zt5hVQ/4Do0bVZCH+/64Xp1J1Wozgc=
X-Received: by 2002:a9d:458a:: with SMTP id x10mr24581645ote.365.1573565191496;
 Tue, 12 Nov 2019 05:26:31 -0800 (PST)
MIME-Version: 1.0
References: <20191111181421.390326245@linuxfoundation.org> <20191112052822.GC1208865@kroah.com>
In-Reply-To: <20191112052822.GC1208865@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Nov 2019 18:56:20 +0530
Message-ID: <CA+G9fYto_RmYZo_bet1GijYGQ5TfPxJ9WpyfzU1PWw5vnPqjZw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
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

On Tue, 12 Nov 2019 at 11:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Nov 11, 2019 at 07:27:30PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.154 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.154-rc1.gz
>
> There is now a -rc2 out:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.154-rc2.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.154-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: fc7e45ae100f042a6f3e1cb7bf47c487b2d5bf3e
git describe: v4.14.153-105-gfc7e45ae100f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.153-105-gfc7e45ae100f

No regressions (compared to build v4.14.153)

No fixes (compared to build v4.14.153)

Ran 24216 total tests in the following environments and test suites.

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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
