Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252C1364A53
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhDSTRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241383AbhDSTRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 15:17:03 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D38C061761
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 12:16:33 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n127so7031443wmb.5
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 12:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WcKlbg8XWr1l7r5RtBQgG+Imcs5h7Ka/u6EAeRHnZV4=;
        b=Sd473G6kcWgifkDo935PzLg8IQYV+nP3L6DncLgiEXaQIEaureaVJFg5sEBBmoM1dq
         Q+mgA+TTDMDXgqKt27N9O/ziXg1LfWasiqTgDE29JCdkjUV8B0b9uPuyQr3e93bN510z
         B/YQ/dHudivfpnC2raWyjLmQLx1HvI1k2dbZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WcKlbg8XWr1l7r5RtBQgG+Imcs5h7Ka/u6EAeRHnZV4=;
        b=ItyzrlXVCYE3WT5m4jwgvpAKXMLgCeIIE8DuCclt0XG7AzWAosJL0avRXnlA0Rf/TS
         xiuEjChkNa5o6M+gMkscYAAPQDjiR0yFxBH9aO32kI0TzfdBcbjCIbxpOJfz2wztLASP
         gFPZgptYDVUzX3cJvyrJFy/P2+7e5mnzFUVhg1N6OTuOpBW/94adLi7ZzL0fJkX5QkbO
         2/894fyZqZ0Q59LwDP/NxpsjhxMfHCi92ZEgT6v40D9jM0+HVM8ZnjMdfxSvTCED4eUJ
         8WS8Y8L6oeG+922HuhyYkeFUol5XtlAakhEDnXoOnt+FPODc3zPGcgsMdTKYGJEmlMJe
         a5yg==
X-Gm-Message-State: AOAM533G7du4T3E7rSswKlqg+AAapoLLfLaMHMwvM6hPmRXjl9O7frdv
        y6grn3WHpEpuNr2Z9lNFIgE1dBEF9gQoGQfAYlHSDw==
X-Google-Smtp-Source: ABdhPJz1SvJ1laNeSW/6G8pNhZBP23YYaiLff/AU4jKKz5mTBSsxFB9Ze7uTXilN5jfjPSzIXtoEL3DoxQPOaBNB8QQ=
X-Received: by 2002:a05:600c:2148:: with SMTP id v8mr537789wml.167.1618859791712;
 Mon, 19 Apr 2021 12:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130527.791982064@linuxfoundation.org> <607dbd93.1c69fb81.b1943.240a@mx.google.com>
In-Reply-To: <607dbd93.1c69fb81.b1943.240a@mx.google.com>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Mon, 19 Apr 2021 12:16:19 -0700
Message-ID: <CAAjnzAn9vrQHzVzOX9_VbBHznyanpbmc5uHCDCDVa+Vib7708A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
To:     Fox Chen <foxhlchen@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel:

commit 32f5704a0a4f7dcc8aa74a49dbcce359d758f6d5 (HEAD -> rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu Apr 15 16:44:09 2021 +0200

    Linux 5.10.31-rc1

No problems found.

Hardware tested on:

model name : Intel(R) Xeon(R) Gold 6248 CPU @ 2.50GHz

Specific tests ran:

ok 1 ltp.py:LTP.test_nptl
ok 2 ltp.py:LTP.test_math
ok 3 ltp.py:LTP.test_dio
ok 4 ltp.py:LTP.test_io
ok 5 ltp.py:LTP.test_power_management_tests
ok 6 ltp.py:LTP.test_can
ok 7 ltp.py:LTP.test_input
ok 8 ltp.py:LTP.test_hugetlb
ok 9 ltp.py:LTP.test_ipc
ok 10 ltp.py:LTP.test_uevent
ok 11 ltp.py:LTP.test_smoketest
ok 12 ltp.py:LTP.test_containers
ok 13 ltp.py:LTP.test_filecaps
ok 14 ltp.py:LTP.test_sched
ok 15 ltp.py:LTP.test_hyperthreading
ok 16 ltp.py:LTP.test_cap_bounds
ok 17 kpatch.sh
ok 18 perf.py:PerfNonPriv.test_perf_help
ok 19 perf.py:PerfNonPriv.test_perf_version
ok 20 perf.py:PerfNonPriv.test_perf_list
ok 21 perf.py:PerfPriv.test_perf_record
ok 22 perf.py:PerfPriv.test_perf_cmd_kallsyms
ok 23 perf.py:PerfPriv.test_perf_cmd_annotate
ok 24 perf.py:PerfPriv.test_perf_cmd_evlist
ok 25 perf.py:PerfPriv.test_perf_cmd_script
ok 26 perf.py:PerfPriv.test_perf_stat
ok 27 perf.py:PerfPriv.test_perf_bench
ok 28 kselftest.py:kselftest.test_sysctl
ok 29 kselftest.py:kselftest.test_size
ok 30 kselftest.py:kselftest.test_sync
ok 31 kselftest.py:kselftest.test_capabilities
ok 32 kselftest.py:kselftest.test_x86
ok 33 kselftest.py:kselftest.test_pidfd
ok 34 kselftest.py:kselftest.test_membarrier
ok 35 kselftest.py:kselftest.test_sigaltstack
ok 36 kselftest.py:kselftest.test_tmpfs
ok 37 kselftest.py:kselftest.test_user
ok 38 kselftest.py:kselftest.test_sched
ok 39 kselftest.py:kselftest.test_timens
ok 40 kselftest.py:kselftest.test_timers

Tested-By: Patrick McCormick <pmccormick@digitalocean.com>

On Mon, Apr 19, 2021 at 10:27 AM Fox Chen <foxhlchen@gmail.com> wrote:
>
> On Mon, 19 Apr 2021 15:05:11 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
> 5.10.32-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
>
> Tested-by: Fox Chen <foxhlchen@gmail.com>
>
