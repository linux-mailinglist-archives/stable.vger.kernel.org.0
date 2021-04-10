Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7447135AC70
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhDJJ0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhDJJ0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 05:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71585606A5;
        Sat, 10 Apr 2021 09:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618046759;
        bh=XfCcCS0Xdq3JYrHf71om/qLkINR0G+nwF09lnIq29TE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZW/TtfFTgOd3EwXUQG8V+cm/QD4eIORXmqfv2KJrIrKpdgJ08ybzhqqs8i2HQLc6f
         Yv6sPlzf6zzwmAaXurfH1G61pabifj7tYwJ4fWQBwXJfENQU2FMPlJwRqutfXQ1zo1
         2IbE9t2FH3kmrIkD3uCrxuARkAMdropf1CbaIYXw=
Date:   Sat, 10 Apr 2021 11:25:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Patrick Mccormick <pmccormick@digitalocean.com>
Cc:     stable@vger.kernel.org
Subject: Re: PASS: stable-rc/linux-5.10.y (v5.10.29-rc1)
Message-ID: <YHFvJA8jhnujlfou@kroah.com>
References: <CAAjnzAk3Ct=Sk06b6Zjf=s6-7xU_ThcH28pw4nhCKfjqPqn92w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAjnzAk3Ct=Sk06b6Zjf=s6-7xU_ThcH28pw4nhCKfjqPqn92w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 10:18:21PM -0700, Patrick Mccormick wrote:
> We ran tests on this kernel:
> 
> commit 18f507c37f338c5d30f58839060d3af0d8504162 (HEAD ->
> rc/linux-5.10.y, stable_rc/linux-5.10.y)
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Apr 9 11:53:03 2021 +0200
> 
>     Linux 5.10.29-rc1
> 
> 32/32 test passed, 0 failed, 0 errors, 0 warnings.
> 
> Specific tests run:
> 
> (01/32) ltp.py:LTP.test_nptl:  PASS (6.52 s)
>  (02/32) ltp.py:LTP.test_math:  PASS (2.13 s)
>  (03/32) ltp.py:LTP.test_hugetlb:  PASS (0.08 s)
>  (04/32) ltp.py:LTP.test_ipc:  PASS (20.09 s)
>  (05/32) ltp.py:LTP.test_uevent:  PASS (0.05 s)
>  (06/32) ltp.py:LTP.test_containers:  PASS (36.76 s)
>  (07/32) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
>  (08/32) ltp.py:LTP.test_hyperthreading:  PASS (71.19 s)
>  (09/32) kpatch.sh:  PASS (11.64 s)
>  (10/32) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
>  (11/32) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
>  (12/32) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
>  (13/32) perf.py:PerfPriv.test_perf_record:  PASS (4.74 s)
>  (14/32) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
>  (15/32) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (5.15 s)
>  (16/32) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
>  (17/32) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.50 s)
>  (18/32) perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
>  (19/32) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
>  (20/32) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
>  (21/32) kselftest.py:kselftest.test_size:  PASS (0.02 s)
>  (22/32) kselftest.py:kselftest.test_sync:  PASS (0.46 s)
>  (23/32) kselftest.py:kselftest.test_capabilities:  PASS (0.03 s)
>  (24/32) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
>  (25/32) kselftest.py:kselftest.test_pidfd:  PASS (13.06 s)
>  (26/32) kselftest.py:kselftest.test_membarrier:  PASS (0.18 s)
>  (27/32) kselftest.py:kselftest.test_sigaltstack:  PASS (0.03 s)
>  (28/32) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
>  (29/32) kselftest.py:kselftest.test_user:  PASS (0.02 s)
>  (30/32) kselftest.py:kselftest.test_sched:  PASS (0.03 s)
>  (31/32) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
>  (32/32) kselftest.py:kselftest.test_timers:  PASS (554.44 s)
> RESULTS    : PASS 32 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
> 0 | CANCEL 0
> 
> Tested-by: pmccormick@digitalocean.com

Any chance you can make this a response to the -rc release announcement
and provide the name correctly for the tested-by: line in the future so
that I can include it in the release commit?

thanks,

greg k-h
