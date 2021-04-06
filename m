Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC1E355994
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 18:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhDFQuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbhDFQus (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 12:50:48 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C739C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 09:50:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so9663046wml.2
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 09:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=orjH0hQ9HeoMhNK3fIHQIYnmq8OuAa4jfLCH5jfbaO4=;
        b=TfEgVBp+kHtOZk/plHhNJySfzVnp2uTARZ3ZtDJpmEqeYJjjTbGsHVPWSfFqfTGDhk
         GjcwlJn+vARNt2xkHHX0M4fugeudi8v/8QooVnJ9ScCD44iHvca9Qf4qpFXXUgopHrq5
         u65Z2Q3PggjCyF1C96sCInyI9wgCngoyVzgWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=orjH0hQ9HeoMhNK3fIHQIYnmq8OuAa4jfLCH5jfbaO4=;
        b=bHe1lmIt56g57nUzxTJwv0DEjtGSbpCBJaGZOTsJHA0+rL3SZ54fsEWT+eiuaUxYqG
         sni2ObOgmMRFDodPHj62f0//idk/P3Of6yNUM96VzYpfd8TWPMto9BpUhvKib9XjKLoj
         qh5mzf0YpNIUz+blzJFpLtYnDjgU7aTkk8wmxnsvE/Mq2RZOxUg7UQA1nC0dIx3m9q+b
         btN16d9IlL1fstrB/nwSfuIDB/r9lVgeIp+GoMgEZ+xAJlY3KPFVA9gP3O2F4WEcgGx9
         omPm8NfNl/W2QRhcSYT0SW2vpVaQ7ioAWSFsKjT3KzKPM3i8x5Y3nfb8rOENdoOaiTUQ
         P4/w==
X-Gm-Message-State: AOAM533gmJu7KhPUkvDHrWu1l2jpqFAPA2hzGwleHI6lngPUaQdbY3Ev
        sfm3ZBBOYzpfPgMqqjO+9pmlMt1521gQOHbys8a4MTYHCpQJSw==
X-Google-Smtp-Source: ABdhPJw654vcLb1G8NUlmh9q0h9VZiqngT0nnhhqEUO8ZPSqDdcKTuhqvR5PP4H8h2V5O42JWDK7KjrEXjpH8XDjmg8=
X-Received: by 2002:a1c:400b:: with SMTP id n11mr4936946wma.167.1617727834822;
 Tue, 06 Apr 2021 09:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAAjnzA=HhDQj_jLCcMGggZoAtP397vgbiMV_7POG20uVPYqpNw@mail.gmail.com>
 <YGwjFaZCNgC+16kO@kroah.com>
In-Reply-To: <YGwjFaZCNgC+16kO@kroah.com>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Tue, 6 Apr 2021 09:50:23 -0700
Message-ID: <CAAjnzAmKULV5bU8eG4n_cPXRhCar3QgvMO2AhWwuF5sy-p1XYQ@mail.gmail.com>
Subject: Re: DO automated testing - Linux 5.10.28-rc1 - 28 pass, 0 errors
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This means: "5.10.28-rc1 was tested and we saw no failures". I will
add a simple english description to the email template for next RC.

I can certainly add a Tested-by tag to the template.

Thanks for the feedback I'll get these changes going for the next RC.

On Tue, Apr 6, 2021 at 2:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Apr 05, 2021 at 02:41:43PM -0700, Patrick Mccormick wrote:
> > commit 948d7f2d279feceb51bcdedb5eb8ce0af60045ce (stable_rc/linux-5.10.y)
> > Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date:   Sat Apr 3 13:52:16 2021 +0200
> >
> >     Linux 5.10.28-rc1
> >
> > ---
> >  (01/28) ltp.py:LTP.test_nptl:  PASS (6.72 s)
> >  (02/28) ltp.py:LTP.test_math:  PASS (1.90 s)
> >  (03/28) ltp.py:LTP.test_hugetlb:  PASS (0.07 s)
> >  (04/28) ltp.py:LTP.test_ipc:  PASS (20.08 s)
> >  (05/28) ltp.py:LTP.test_uevent:  PASS (0.05 s)
> >  (06/28) ltp.py:LTP.test_containers:  PASS (36.90 s)
> >  (07/28) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
> >  (08/28) ltp.py:LTP.test_hyperthreading:  PASS (71.17 s)
> >  (09/28) kpatch.sh:  PASS (12.62 s)
> >  (10/28) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
> >  (11/28) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
> >  (12/28) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
> >  (13/28) perf.py:PerfPriv.test_perf_record:  PASS (4.78 s)
> >  (14/28) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
> >  (15/28) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (8.75 s)
> >  (16/28) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
> >  (17/28) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.57 s)
> >  (18/28) perf.py:PerfPriv.test_perf_stat:  PASS (3.23 s)
> >  (19/28) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
> >  (20/28) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
> >  (21/28) kselftest.py:kselftest.test_size:  PASS (0.02 s)
> >  (22/28) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
> >  (23/28) kselftest.py:kselftest.test_sigaltstack:  PASS (0.02 s)
> >  (24/28) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
> >  (25/28) kselftest.py:kselftest.test_user:  PASS (0.03 s)
> >  (26/28) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
> >  (27/28) kselftest.py:kselftest.test_kvm:  PASS (13.57 s)
> >  (28/28) kselftest.py:kselftest.test_timers:  PASS (554.55 s)
> > RESULTS    : PASS 28 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
> > 0 | CANCEL 0
> > JOB TIME   : 737.14 s
>
> Nice, what does this mean?  ANd do you wish to provide a "Tested-by:"
> tag for this?
>
> thanks,
>
> greg k-h
