Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52BC24A452
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 18:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgHSQtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 12:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgHSQtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 12:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571F220882;
        Wed, 19 Aug 2020 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597855791;
        bh=1lnEeQo/Jow30sIBxsxYgpysYSvONpVLDnIsPNLuFdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gdoeav0VsaaKHE/9Xn+KSL892mZ3neD4PwQLvRMysCTI0TOCOmMm54FL+M8GHSrHO
         eMB5SEDFGsRHZIFIhQPZn1KQTr8AcWRXw97OxxU4O9OHo2/b3aBh4Y2NsrKY4gQKxl
         aH+fmHzN7M167mcJY/4iyCOMBUmbl6UnB6koSq/4=
Date:   Wed, 19 Aug 2020 18:50:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        David Arcari <darcari@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.8.2-ad8c735.cki (stable)
Message-ID: <20200819165013.GB3698439@kroah.com>
References: <cki.81A545788B.TQBX9O8LVS@redhat.com>
 <3774b716-4440-f6c7-0c9b-60d3b599196e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3774b716-4440-f6c7-0c9b-60d3b599196e@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 11:54:18AM -0400, Rachel Sibley wrote:
> 
> 
> On 8/19/20 11:48 AM, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >              Commit: ad8c735b1497 - Linux 5.8.2
> > 
> > The results of these automated tests are provided below.
> > 
> >      Overall result: FAILED (see details below)
> >               Merge: OK
> >             Compile: OK
> >               Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/08/19/612293
> > 
> > One or more kernel tests failed:
> > 
> >      s390x:
> >       ❌ LTP
> > 
> >      ppc64le:
> >       ❌ LTP
> > 
> >      aarch64:
> >       ❌ LTP
> 
> For both s390x/aarch64 failures looks like we're missing the following kernel fixes for stable:
> 
>      1	<<<test_start>>>
>      2	tag=ioctl_loop01 stime=1597824830
>      3	cmdline="ioctl_loop01"
>      4	contacts=""
>      5	analysis=exit
>      6	<<<test_output>>>
>      7	tst_test.c:1245: INFO: Timeout per run is 0h 05m 00s
>      8	tst_device.c:88: INFO: Found free device 0 '/dev/loop0'
>      9	ioctl_loop01.c:85: PASS: /sys/block/loop0/loop/partscan = 0
>     10	ioctl_loop01.c:86: PASS: /sys/block/loop0/loop/autoclear = 0
>     11	ioctl_loop01.c:87: PASS: /sys/block/loop0/loop/backing_file = '/mnt/testarea/ltp-4l1XyCNbu8/h6pPv5/test.img'
>     12	ioctl_loop01.c:57: PASS: get expected lo_flag 12
>     13	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
>     14	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 1
>     15	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
>     16	ioctl_loop01.c:75: PASS: access /sys/block/loop0/loop0p1 succeeds
>     17	ioctl_loop01.c:91: INFO: Test flag can be clear
>     18	ioctl_loop01.c:57: PASS: get expected lo_flag 8
>     19	ioctl_loop01.c:59: PASS: /sys/block/loop0/loop/partscan = 1
>     20	ioctl_loop01.c:60: PASS: /sys/block/loop0/loop/autoclear = 0
>     21	ioctl_loop01.c:71: FAIL: access /dev/loop0p1 fails
>     22	ioctl_loop01.c:77: FAIL: access /sys/block/loop0/loop0p1 fails
>     23	
>     24	HINT: You _MAY_ be missing kernel fixes, see:
>     25	
>     26	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=10c70d95c0f2
>     27	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6ac92fb5cdff
> 
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_aarch64_redhat%3A958531/tests/LTP/8699601_aarch64_1_syscalls.fail.log
> 
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/08/19/612293/build_s390x_redhat%3A958533/tests/LTP/8699609_s390x_1_syscalls.fail.log


That doesn't make much sense as 10c70d95c0f2 ("block: remove the
bd_openers checks in blk_drop_partitions") was in the 5.7 kernel release
(and 5.6.11) and 6ac92fb5cdff ("loop: Fix wrong masking of status
flags") is in the 5.8 kernel release.

So if you were testing 5.8.2, those hints aren't that relevant :)

thanks,

greg k-h
