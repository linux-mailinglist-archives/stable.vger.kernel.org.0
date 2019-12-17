Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D3D122EB2
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfLQO2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 09:28:40 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43188 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbfLQO2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 09:28:39 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so11149525ljm.10
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 06:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F8HPujqvxFcV77ysH2tsQiu4oWY4tr7fPjbjFjGXPDs=;
        b=rxp1sZh9Qz80/ywK57Z+LFj3wuXgM3gCAON9FWQpN7Q9JxbSLZsaqkRNp73ph8WC3Z
         CLauEU3X/lca019m9QAg3q+NyWjqTCdVysum3ugCEMJ8Dfkn3hoaMOCalqt7KKO100tn
         lCslB3/TG+/VVL04aYiA6NxiSlNixetm6yiamQPs1DNQ1IUah2qz879Q4FeHNbasPIgj
         XcUsCzdx+VLP70cn13Ooe12hBLtHHg9e3MDw0v4zMg+gP+Rr1yzrJfOixMNmgzuDn1ee
         4Cw3jZ0RUY268LbmDsdH9PsTnKqhcKdcarTVi7r1ZjyQDupAYM9BjLQYyNKAryiiEPWZ
         L5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F8HPujqvxFcV77ysH2tsQiu4oWY4tr7fPjbjFjGXPDs=;
        b=YPUUKfNaLcN3r174XYu3s+uFzaXX6FgOuIKvmTECahCOWmwGFh3OO/rEg64mUfXpXF
         tdLRaFEhHbia5spNgiP5B6cAu0KUITqlwtmAtauVPpe2oLDs6PVLpd5scEaQCN2kL6au
         9kIWu3F5xjEsXPNjmmmh3PBE262ps08c/OjUyN2hr7H3BdMfFYkDZHgbt6zF3cmhPbhH
         Csxe1LQbd3JHOJeHkT2gQqkB3gdzE5nl9/8YrPmC+rYoCDCiQ7i3/JHWt7v9gI8cCMqc
         fvuYmEzACsouq+w10bJKHqbMKF3p0kPUJcKC0t6l8JKs3NK2c1C+FxLknVn8EUKB/8vO
         5ioA==
X-Gm-Message-State: APjAAAV0gWnVJBzczqlrFfZ1uXPx2FGML+kYb2hkxQAh12sjBt+Yr1s9
        RqoO0PVoVJnuourpACRtJi4UU6yiEEbTMPNutkvUvA==
X-Google-Smtp-Source: APXvYqxuV0Ka+crAITk182kukahRjSR+uBkpXzJRRpave7ybb4E87y1B/rGBfVLyPtWaNm1oxAjki8scZYzpyHIa0jA=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr3430618ljd.227.1576592917601;
 Tue, 17 Dec 2019 06:28:37 -0800 (PST)
MIME-Version: 1.0
References: <20191216174848.701533383@linuxfoundation.org> <20191217090548.GA2801817@kroah.com>
In-Reply-To: <20191217090548.GA2801817@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Dec 2019 19:58:25 +0530
Message-ID: <CA+G9fYunRMLr8Fi7S7FTXK1dskE_w10=5XdE7Ew__HDFvHy_2Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
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

On Tue, 17 Dec 2019 at 14:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> There is a -rc2 out now to resolve some reported issues:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.159-rc2.gz

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.159-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 66745e000c837d52e736de131726a861c6ea1ebf
git describe: v4.14.158-268-g66745e000c83
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.158-268-g66745e000c83

No regressions (compared to build v4.14.158)

No fixes (compared to build v4.14.158)

Ran 23039 total tests in the following environments and test suites.

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
* ltp-containers-tests
* ltp-cve-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
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
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
