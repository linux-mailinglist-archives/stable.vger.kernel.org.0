Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9870235D1AF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 22:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhDLUD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 16:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbhDLUD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 16:03:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CFCC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 13:03:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id 12so14192567wrz.7
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 13:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jixOXBBHgj1EhSS9YcOTcQ9sFDdAzdMBHo0O6SHLBI=;
        b=KD0v8icS18fQWVpJ1+cOZu/NWM4hyJiwQSBvoEv1xh+ARskvGfDO5A9E/H4uSdYzIK
         2BocS/XSjhJUpyHuv1IU5ufmmR5YJztn8Y6aEyzyzEFCtbIMNhYyFMONqGipzzzizYBk
         0BJp9F8xsg6WYDBcWK3rCx/03FKWLvbHEZjfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jixOXBBHgj1EhSS9YcOTcQ9sFDdAzdMBHo0O6SHLBI=;
        b=rcVBauT0Sk3k3Qv53GJLZJa9u7P3fDv4cuGlgPwIl2B0JSnbF9oLv/JaUdR9KFPovn
         Pfz+jh9ATM/QhZparkXVp5dfhYUntDUwhDogdSR3iJ9xtAURQZGSkEyaNRQXg1yH7izC
         AynXyxC/cHiKw8sQ1XBvI+HNfjnGHk3NeoKbfNt2McIDZlqRqMm9F4n3r/b2/Y8b5SgA
         Cq2ax5Vk6yc4qeOUd1VRebeNxz3EgY0b5LDVWcAw0vyEKObe4eJ8mW/8c/ej/VBlb0W3
         d2MvLQ5sxTDshbUh/9JMuIGeVewvP1hIeKABzdmIVqnI3VdYsBc2gnBOF7wZd1Ta1QA8
         lYxg==
X-Gm-Message-State: AOAM533OY3R2U/G+F1bznuwXNLILuEXoCszUenZDw8rx5j0msI3aTx/g
        fYWHdO/2j+n4T/uy3KBd8LBLSZFtlup3Iq8wWiZp6yCaDIg=
X-Google-Smtp-Source: ABdhPJy3IB6itkLrxnxO2C0SrYEgo8aPJoFz5IHnQpDigzr1STDOuCAh6nyprAsLIJ3tiqYZj1RT/2XEwz3hPX1qYYQ=
X-Received: by 2002:a5d:4682:: with SMTP id u2mr21617031wrq.167.1618257816295;
 Mon, 12 Apr 2021 13:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAAjnzAk3Ct=Sk06b6Zjf=s6-7xU_ThcH28pw4nhCKfjqPqn92w@mail.gmail.com>
 <YHFvJA8jhnujlfou@kroah.com>
In-Reply-To: <YHFvJA8jhnujlfou@kroah.com>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Mon, 12 Apr 2021 13:03:24 -0700
Message-ID: <CAAjnzAnG40A4mdDGUVcK_+LX=x+hHMVuenwnHxqEc=tQvC02Bg@mail.gmail.com>
Subject: Re: PASS: stable-rc/linux-5.10.y (v5.10.29-rc1)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No problem.

On Sat, Apr 10, 2021 at 2:25 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Apr 09, 2021 at 10:18:21PM -0700, Patrick Mccormick wrote:
> > We ran tests on this kernel:
> >
> > commit 18f507c37f338c5d30f58839060d3af0d8504162 (HEAD ->
> > rc/linux-5.10.y, stable_rc/linux-5.10.y)
> > Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date:   Fri Apr 9 11:53:03 2021 +0200
> >
> >     Linux 5.10.29-rc1
> >
> > 32/32 test passed, 0 failed, 0 errors, 0 warnings.
> >
> > Specific tests run:
> >
> > (01/32) ltp.py:LTP.test_nptl:  PASS (6.52 s)
> >  (02/32) ltp.py:LTP.test_math:  PASS (2.13 s)
> >  (03/32) ltp.py:LTP.test_hugetlb:  PASS (0.08 s)
> >  (04/32) ltp.py:LTP.test_ipc:  PASS (20.09 s)
> >  (05/32) ltp.py:LTP.test_uevent:  PASS (0.05 s)
> >  (06/32) ltp.py:LTP.test_containers:  PASS (36.76 s)
> >  (07/32) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
> >  (08/32) ltp.py:LTP.test_hyperthreading:  PASS (71.19 s)
> >  (09/32) kpatch.sh:  PASS (11.64 s)
> >  (10/32) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
> >  (11/32) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
> >  (12/32) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
> >  (13/32) perf.py:PerfPriv.test_perf_record:  PASS (4.74 s)
> >  (14/32) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
> >  (15/32) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (5.15 s)
> >  (16/32) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
> >  (17/32) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.50 s)
> >  (18/32) perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
> >  (19/32) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
> >  (20/32) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
> >  (21/32) kselftest.py:kselftest.test_size:  PASS (0.02 s)
> >  (22/32) kselftest.py:kselftest.test_sync:  PASS (0.46 s)
> >  (23/32) kselftest.py:kselftest.test_capabilities:  PASS (0.03 s)
> >  (24/32) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
> >  (25/32) kselftest.py:kselftest.test_pidfd:  PASS (13.06 s)
> >  (26/32) kselftest.py:kselftest.test_membarrier:  PASS (0.18 s)
> >  (27/32) kselftest.py:kselftest.test_sigaltstack:  PASS (0.03 s)
> >  (28/32) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
> >  (29/32) kselftest.py:kselftest.test_user:  PASS (0.02 s)
> >  (30/32) kselftest.py:kselftest.test_sched:  PASS (0.03 s)
> >  (31/32) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
> >  (32/32) kselftest.py:kselftest.test_timers:  PASS (554.44 s)
> > RESULTS    : PASS 32 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
> > 0 | CANCEL 0
> >
> > Tested-by: pmccormick@digitalocean.com
>
> Any chance you can make this a response to the -rc release announcement
> and provide the name correctly for the tested-by: line in the future so
> that I can include it in the release commit?
>
> thanks,
>
> greg k-h
