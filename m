Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A000417B818
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 09:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgCFIIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 03:08:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:58918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgCFIIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 03:08:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 25078AF73;
        Fri,  6 Mar 2020 08:08:40 +0000 (UTC)
Date:   Fri, 6 Mar 2020 09:08:38 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        LTP Mailing List <ltp@lists.linux.it>,
        Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: [LTP] =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.8-97453d9.cki (stable)
Message-ID: <20200306080838.GB14808@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <cki.AEA99E5519.SMAFL9TDK6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.AEA99E5519.SMAFL9TDK6@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> We ran automated tests on a recent commit from this kernel tree:

>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 97453d9b9b2b - Linux 5.5.8

> The results of these automated tests are provided below.

>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED

> All kernel binaries, config files, and logs are available for download here:

>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/05/473513

> One or more kernel tests failed:

>     s390x:
>      ❌ stress: stress-ng
>      ❌ LTP
Here it's 9 syscalls failed for "slept for too long" [1]
    28	tst_timer_test.c:310: FAIL: clock_nanosleep() slept for too long
    12	tst_timer_test.c:310: FAIL: nanosleep() slept for too long
    27	tst_timer_test.c:310: FAIL: poll() slept for too long
    22	tst_timer_test.c:310: FAIL: prctl() slept for too long
    25	tst_timer_test.c:310: FAIL: select() slept for too long
    76	tst_timer_test.c:310: FAIL: select() slept for too long
   126	tst_timer_test.c:310: FAIL: select() slept for too long
    22	tst_timer_test.c:310: FAIL: futex_wait() slept for too long
    53	tst_timer_test.c:310: FAIL: futex_wait() slept for too long

BTW it'd be interesting to see previous build. I searched for stable in jobs
[2], but there is no linux-5.5.y (I see linux-5.4.y).

Kind regards,
Petr

[1] https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/03/05/473513/s390x_2_LTP_syscalls.fail.log
[2] https://kernelci.org/job/
