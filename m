Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F352354F53
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 11:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhDFJBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 05:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236131AbhDFJBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 05:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DDF261380;
        Tue,  6 Apr 2021 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617699666;
        bh=RtfVoEJ8GqP10123q4N3biR5gVu85bbil7LY6A7ks9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e3rV72/7N7MreILRXySQHfaHTrSYm55/AXEzqejD8ElrugJl0tJfNTTPctOq6JYFZ
         7WsN2d7loq81iZFmc5SDotf9bx0ptnxVLv3psNtsrMUw6ZeQiN4xI8/96f0o9E1ZI/
         10owpwIDhEn/S0VjVfk1SYpTuFE9lfKJELAny7nA=
Date:   Tue, 6 Apr 2021 11:00:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Patrick Mccormick <pmccormick@digitalocean.com>
Cc:     stable@vger.kernel.org
Subject: Re: DO automated testing - Linux 5.10.28-rc1 - 28 pass, 0 errors
Message-ID: <YGwjFaZCNgC+16kO@kroah.com>
References: <CAAjnzA=HhDQj_jLCcMGggZoAtP397vgbiMV_7POG20uVPYqpNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAjnzA=HhDQj_jLCcMGggZoAtP397vgbiMV_7POG20uVPYqpNw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 02:41:43PM -0700, Patrick Mccormick wrote:
> commit 948d7f2d279feceb51bcdedb5eb8ce0af60045ce (stable_rc/linux-5.10.y)
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat Apr 3 13:52:16 2021 +0200
> 
>     Linux 5.10.28-rc1
> 
> ---
>  (01/28) ltp.py:LTP.test_nptl:  PASS (6.72 s)
>  (02/28) ltp.py:LTP.test_math:  PASS (1.90 s)
>  (03/28) ltp.py:LTP.test_hugetlb:  PASS (0.07 s)
>  (04/28) ltp.py:LTP.test_ipc:  PASS (20.08 s)
>  (05/28) ltp.py:LTP.test_uevent:  PASS (0.05 s)
>  (06/28) ltp.py:LTP.test_containers:  PASS (36.90 s)
>  (07/28) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
>  (08/28) ltp.py:LTP.test_hyperthreading:  PASS (71.17 s)
>  (09/28) kpatch.sh:  PASS (12.62 s)
>  (10/28) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
>  (11/28) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
>  (12/28) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
>  (13/28) perf.py:PerfPriv.test_perf_record:  PASS (4.78 s)
>  (14/28) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
>  (15/28) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (8.75 s)
>  (16/28) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
>  (17/28) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.57 s)
>  (18/28) perf.py:PerfPriv.test_perf_stat:  PASS (3.23 s)
>  (19/28) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
>  (20/28) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
>  (21/28) kselftest.py:kselftest.test_size:  PASS (0.02 s)
>  (22/28) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
>  (23/28) kselftest.py:kselftest.test_sigaltstack:  PASS (0.02 s)
>  (24/28) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
>  (25/28) kselftest.py:kselftest.test_user:  PASS (0.03 s)
>  (26/28) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
>  (27/28) kselftest.py:kselftest.test_kvm:  PASS (13.57 s)
>  (28/28) kselftest.py:kselftest.test_timers:  PASS (554.55 s)
> RESULTS    : PASS 28 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
> 0 | CANCEL 0
> JOB TIME   : 737.14 s

Nice, what does this mean?  ANd do you wish to provide a "Tested-by:"
tag for this?

thanks,

greg k-h
