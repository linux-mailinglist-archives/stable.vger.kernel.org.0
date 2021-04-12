Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B2135D1D3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 22:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhDLUNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 16:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhDLUNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 16:13:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E40C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 13:12:52 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 12so7518319wmf.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 13:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=OleDocO9DFMMFrV4AyijmeDt6xHHwR1XeHDKPQ6VgIo=;
        b=JdutsxkvvjIF1ooUKwSGEH4y4q+i7u6p3l3RCPfNNxmqnraDnJLtgHoPViZTede5sv
         PRpA32T6bZRuaGFAA1ihSE36L/S7L0QPWqqaBDHsquqpC7YTM77rsjyP2izKoNUf0q5V
         NtL1DtpD2+0A2mge+T99/+OhTSDcjug/aN8vE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=OleDocO9DFMMFrV4AyijmeDt6xHHwR1XeHDKPQ6VgIo=;
        b=G2fd/e73cNWlvGa1xQgch3pbN/5qFJAXzyQFi4tGzEY5QQ/J9/GFi9cO7TuL3l84ll
         ++80c0EDtmf/vrCIj6HtHcU0OziALKtRUtWVKtwvOA2FYZ0vEMDFMNe2e8VTXQaaCVDF
         jJMv6hsFWnHwFPCx66gnYKwSmuGEI3n7BW/BDL82fhpUDbQv1Ykqie7kZo5fnVcA0fgs
         3I3dGSJABp4RE3GgKZCtA4CElNnTJ725Hmt0mdFOObnxUxXTaCMkhm+tjJkF7zzXCgSP
         10rGL2FJs4L5/apxsPv7LDBrCdoxvzTfoyEQFsBHtlofZlukXkRm7Q9M5sIX0iAAxO7H
         yDpw==
X-Gm-Message-State: AOAM530Y6IvC0dqgu+6ruXI9TOQWDLwolE7HSAv1UfeKKCK6nV/yiWaE
        PwJ8K7tLGxyyiwGLQPCktvhysxmLmPEUglS2dRZtFZNQGYNs2Q==
X-Google-Smtp-Source: ABdhPJy5hdbZDu3KCwG1mDci2usLsnkiHPstHrNaGW3+VIkrmZemWCShraN1H7MdRvDlskT+5saFFSb+1XGA3eT2C34=
X-Received: by 2002:a05:600c:4f94:: with SMTP id n20mr744371wmq.18.1618258371123;
 Mon, 12 Apr 2021 13:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210412084013.643370347@linuxfoundation.org> <8fc3537b-1165-5cb6-2070-9068cccc22cd@gmail.com>
In-Reply-To: <8fc3537b-1165-5cb6-2070-9068cccc22cd@gmail.com>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Mon, 12 Apr 2021 13:12:40 -0700
Message-ID: <CAAjnzA=Ha5GDyJvO_PZRxjXA=AyHSBMmA2GUh4ea8PT_67NhYQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel:

commit 8ac4b1deedaa507b5d0f46316e7f32004dd99cd1 (HEAD ->
rc/linux-5.10.y, stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon Apr 12 10:40:10 2021 +0200

    Linux 5.10.30-rc1

32/32 test passed, 0 failed, 0 errors, 0 warnings.

Specific tests run:

 (01/32) 32ltp.py:LTP.test_nptl:  PASS (6.55 s)
 (02/32) 32ltp.py:LTP.test_math:  PASS (2.05 s)
 (03/32) 32ltp.py:LTP.test_hugetlb:  PASS (0.07 s)
 (04/32) 32ltp.py:LTP.test_ipc:  PASS (20.08 s)
 (05/32) 32ltp.py:LTP.test_uevent:  PASS (0.05 s)
 (06/32) 32ltp.py:LTP.test_containers:  PASS (36.71 s)
 (07/32) 32ltp.py:LTP.test_filecaps:  PASS (0.11 s)
 (08/32) 32ltp.py:LTP.test_hyperthreading:  PASS (71.18 s)
 (09/32) 32kpatch.sh:  PASS (12.59 s)
 (10/32) 32perf.py:PerfNonPriv.test_perf_help:  PASS (0.07 s)
 (11/32) 32perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
 (12/32) 32perf.py:PerfNonPriv.test_perf_list:  PASS (0.39 s)
 (13/32) 32perf.py:PerfPriv.test_perf_record:  PASS (4.71 s)
 (14/32) 32perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.31 s)
 (15/32) 32perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (6.86 s)
 (16/32) 32perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
 (17/32) 32perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.49 s)
 (18/32) 32perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
 (19/32) 32perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
 (20/32) 32kselftest.py:kselftest.test_sysctl:  PASS (0.19 s)
 (21/32) 32kselftest.py:kselftest.test_size:  PASS (0.02 s)
 (22/32) 32kselftest.py:kselftest.test_sync:  PASS (0.46 s)
 (23/32) 32kselftest.py:kselftest.test_capabilities:  PASS (0.03 s)
 (24/32) 32kselftest.py:kselftest.test_x86:  PASS (0.28 s)
 (25/32) 32kselftest.py:kselftest.test_pidfd:  PASS (13.01 s)
 (26/32) 32kselftest.py:kselftest.test_membarrier:  PASS (0.22 s)
 (27/32) 32kselftest.py:kselftest.test_sigaltstack:  PASS (0.03 s)
 (28/32) 32kselftest.py:kselftest.test_tmpfs:  PASS (0.03 s)
 (29/32) 32kselftest.py:kselftest.test_user:  PASS (0.02 s)
 (30/32) 32kselftest.py:kselftest.test_sched:  PASS (0.03 s)
 (31/32) 32kselftest.py:kselftest.test_timens:  PASS (0.09 s)
 (32/32) 32kselftest.py:kselftest.test_timers:  PASS (555.01 s)
RESULTS    : PASS 32 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
0 | CANCEL 0

Tested-by: Patrick McCormick <pmccormick@digitalocean.com>

On Mon, Apr 12, 2021 at 12:08 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/12/2021 1:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.30 release.
> > There are 188 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.30-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian
