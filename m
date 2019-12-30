Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3312D209
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 17:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfL3Qek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 11:34:40 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35009 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfL3Qek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 11:34:40 -0500
Received: by mail-yb1-f194.google.com with SMTP id a124so14285699ybg.2
        for <stable@vger.kernel.org>; Mon, 30 Dec 2019 08:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SifrDRNuZI7FjGGbJzx9F32WU6UCkJPUxer3u46pdDA=;
        b=Z35wHsyiNpP4RlEFRxabnN4fXuzsizFg+xlvkcOZWkAsXoTppdGT9xoMcEjd35huJZ
         C+hvSJHTfqVcN2b9qaIV1hXlT4/TU+yvw9AUYGQZGO79zuSBnUZucz/PCzoXHgI/u+Gu
         IJdQXOcSS6EqM4JMh5sqBPNcNtOVXjbgqOg++zxGi6CeTA8p3KtYcE4Flzmx7krRbxPm
         PqI/5HdBPZWZgmE2lBdoKJHsWhfTAwKJgY+ys/KiEbJJmKtVL2TT3M0CaDYQGmRtMqmO
         DdYf/Ll4VMGVqNemtm5z5+pe31O+TD+fX68R4GK253AQ1p1vvPrzLEz+CQx50ywHiovl
         lcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=SifrDRNuZI7FjGGbJzx9F32WU6UCkJPUxer3u46pdDA=;
        b=B2pgd7bRXYnNzT+typQUHXJId3CPeX6jrSVz+X07vGA2dUi/ywl+3KbUPZHtXtihBv
         OHkb9AuuyXXyqwSaKSMxo1byb4oSP8Y/7LPRVuAPORyx2eKlwyc2lu9ApKT6O7qyMxxj
         nDB+5LQD6+tF/np7y9Mo1uTpKE03gAwm0xKDiZuPEF8ha6XVC0kAEWY/6xLXBzLLxATe
         tNBog1nfxS5M53Cw9Tt1wgDX9Lx1bkk/QE1MUzgDs8PjRfl4K2hD+w3EeT5EkVKoshxh
         to7hE3JydDsWcO0LeIGjWFubbz4xXEbPrCA9J3FKkzjPIbNkOi5x9AOr0LTJ9acEOhzf
         tTTA==
X-Gm-Message-State: APjAAAVoLvlRjHhzQGeZ2AVKEltyAqjUz9G5Eu/YM7sq7PPTlstUwZXT
        l2BnE9tGOiCY66BSEYBousJOBQ==
X-Google-Smtp-Source: APXvYqwVL1AGDxGOv9b+LmFFMDFhX73etoc+MAkFLDhsbdHVxQtSeRdSsqK9QQx6kco1isCoQm4JnQ==
X-Received: by 2002:a5b:38d:: with SMTP id k13mr23670721ybp.147.1577723679224;
        Mon, 30 Dec 2019 08:34:39 -0800 (PST)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id a189sm18679079ywh.92.2019.12.30.08.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 08:34:38 -0800 (PST)
Date:   Mon, 30 Dec 2019 10:34:37 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230163437.sz4mb5gh7ed2htfa@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20191229172702.393141737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.7 release.
> There are 434 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.4.y
git commit: 6bc086f94af53b930b413d3cc85fe11061b4a0a2
git describe: v5.4.6-436-g6bc086f94af5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.6-436-g6bc086f94af5


No regressions (compared to build v5.4.6)

No fixes (compared to build v5.4.6)

Ran 22880 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

-- 
Linaro LKFT
https://lkft.linaro.org
