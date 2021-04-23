Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68FF3695B9
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhDWPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhDWPLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEDD6113D;
        Fri, 23 Apr 2021 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190658;
        bh=YGMR4t5USOuaW99kmW6ZErKiGaVhxyhBvFyt5f1cxFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F6ZWWGNGx+wFhBjGD+PZDECpd1zH5pOD3Kh5XyALG/4yNDvmnPQ6soYRpyPICPQ3u
         7pbSxtjQNkOqCHe0gx7Po/q70oKDlf5E+IFWvSR9CwaD5MDk43LvCmwP2EnpoYmIqr
         WqaQGAOsyAJUDZiQE6is0XJZz59ZQkG7AIGBCwdI=
Date:   Fri, 23 Apr 2021 17:10:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Patrick Mccormick <pmccormick@digitalocean.com>
Cc:     Fox Chen <foxhlchen@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILjgOPEl8bva4xU@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <607dbd93.1c69fb81.b1943.240a@mx.google.com>
 <CAAjnzAn9vrQHzVzOX9_VbBHznyanpbmc5uHCDCDVa+Vib7708A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAjnzAn9vrQHzVzOX9_VbBHznyanpbmc5uHCDCDVa+Vib7708A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 12:16:19PM -0700, Patrick Mccormick wrote:
> We ran tests on this kernel:
> 
> commit 32f5704a0a4f7dcc8aa74a49dbcce359d758f6d5 (HEAD -> rc/linux-5.10.y)
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu Apr 15 16:44:09 2021 +0200
> 
>     Linux 5.10.31-rc1
> 
> No problems found.
> 
> Hardware tested on:
> 
> model name : Intel(R) Xeon(R) Gold 6248 CPU @ 2.50GHz
> 
> Specific tests ran:
> 
> ok 1 ltp.py:LTP.test_nptl
> ok 2 ltp.py:LTP.test_math
> ok 3 ltp.py:LTP.test_dio
> ok 4 ltp.py:LTP.test_io
> ok 5 ltp.py:LTP.test_power_management_tests
> ok 6 ltp.py:LTP.test_can
> ok 7 ltp.py:LTP.test_input
> ok 8 ltp.py:LTP.test_hugetlb
> ok 9 ltp.py:LTP.test_ipc
> ok 10 ltp.py:LTP.test_uevent
> ok 11 ltp.py:LTP.test_smoketest
> ok 12 ltp.py:LTP.test_containers
> ok 13 ltp.py:LTP.test_filecaps
> ok 14 ltp.py:LTP.test_sched
> ok 15 ltp.py:LTP.test_hyperthreading
> ok 16 ltp.py:LTP.test_cap_bounds
> ok 17 kpatch.sh
> ok 18 perf.py:PerfNonPriv.test_perf_help
> ok 19 perf.py:PerfNonPriv.test_perf_version
> ok 20 perf.py:PerfNonPriv.test_perf_list
> ok 21 perf.py:PerfPriv.test_perf_record
> ok 22 perf.py:PerfPriv.test_perf_cmd_kallsyms
> ok 23 perf.py:PerfPriv.test_perf_cmd_annotate
> ok 24 perf.py:PerfPriv.test_perf_cmd_evlist
> ok 25 perf.py:PerfPriv.test_perf_cmd_script
> ok 26 perf.py:PerfPriv.test_perf_stat
> ok 27 perf.py:PerfPriv.test_perf_bench
> ok 28 kselftest.py:kselftest.test_sysctl
> ok 29 kselftest.py:kselftest.test_size
> ok 30 kselftest.py:kselftest.test_sync
> ok 31 kselftest.py:kselftest.test_capabilities
> ok 32 kselftest.py:kselftest.test_x86
> ok 33 kselftest.py:kselftest.test_pidfd
> ok 34 kselftest.py:kselftest.test_membarrier
> ok 35 kselftest.py:kselftest.test_sigaltstack
> ok 36 kselftest.py:kselftest.test_tmpfs
> ok 37 kselftest.py:kselftest.test_user
> ok 38 kselftest.py:kselftest.test_sched
> ok 39 kselftest.py:kselftest.test_timens
> ok 40 kselftest.py:kselftest.test_timers
> 
> Tested-By: Patrick McCormick <pmccormick@digitalocean.com>

Thanks for testing and letting me know.

greg k-h

