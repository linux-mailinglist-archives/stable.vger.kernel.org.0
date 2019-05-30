Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905F72FFA4
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfE3PwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 May 2019 11:52:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3PwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 11:52:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC4A0307D915;
        Thu, 30 May 2019 15:52:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B09BD60BE1;
        Thu, 30 May 2019 15:52:20 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A402D1806B0E;
        Thu, 30 May 2019 15:52:19 +0000 (UTC)
Date:   Thu, 30 May 2019 11:52:18 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <1322148527.22739552.1559231538978.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190530145529.GA28396@kroah.com>
References: <cki.7068F1D41D.IXWVR9HG1P@redhat.com> <20190530145529.GA28396@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8E_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l=094.19.47-rc1-011862f.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.205.23, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2OIEZBSUw6?= Test report for kernel 4.19.47-rc1-011862f.cki (stable)
Thread-Index: ARMfANzdbiHi33lvsXNkx47MZVny+g==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 30 May 2019 15:52:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Thursday, May 30, 2019 4:55:29 PM
> Subject: Re: ❎ FAIL: Test report for kernel	4.19.47-rc1-011862f.cki (stable)
> 
> On Thu, May 30, 2019 at 12:08:51AM -0400, CKI Project wrote:
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: 9c8c1a222a6b - Linux 4.19.47-rc1
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> > 
> > One or more kernel tests failed:
> > 
> >   aarch64:
> >     ❎ Boot test
> 
> Is this something to worry about?
> 

Hi, it looks like the kernel panicked:

[   10.407341] Internal error: Oops: 96000004 [#1] SMP 
[   10.412208] Modules linked in: 
[   10.415254] Process swapper/0 (pid: 1, stack limit = 0x(____ptrval____)) 
[   10.421946] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.47-rc1-011862f.cki #1 
[   10.429330] Hardware name: Cavium ThunderX CRB/To be filled by O.E.M., BIOS 0ACGA023 11/22/2018 
[   10.438017] pstate: 80400005 (Nzcv daif +PAN -UAO) 
[   10.442803] pc : __dev_printk+0x38/0xa0 
[   10.446629] lr : _dev_info+0x5c/0x68 
[   10.450193] sp : ffff000009bfba00 
[   10.453496] x29: ffff000009bfba00 x28: 0000000000000000  
[   10.458800] x27: ffff000008f40584 x26: ffff0000090d8018  
[   10.464104] x25: ffff000009023060 x24: ffff810ff77d7800  
[   10.469407] x23: ffff0000095f7008 x22: 0000000000000000  
[   10.474710] x21: ffff000009bfba50 x20: ffff000008de8b50  
[   10.480014] x19: ffff8007ffd770a8 x18: 0000000000000000  
[   10.485317] x17: 0000000000000000 x16: 0000000000000000  
[   10.490620] x15: 0000000000000010 x14: ffffffffffffffff  
[   10.495924] x13: ffff000089753adf x12: ffff000009753ae7  
[   10.501227] x11: ffff000009564000 x10: ffff000009bfb7a0  
[   10.506530] x9 : 00000000ffffffd0 x8 : ffff0000086c6ab8  
[   10.511834] x7 : 6620676e69626f72 x6 : 00000000000003f4  
[   10.517137] x5 : ffff000009bfbab0 x4 : ffff000009bfba80  
[   10.522441] x3 : 00000000ffffffd0 x2 : ffff000009bfba50  
[   10.527744] x1 : 63697665642f3d48 x0 : 0000000000000006  
[   10.533047] Call trace: 
[   10.535484]  __dev_printk+0x38/0xa0 
[   10.538962]  _dev_info+0x5c/0x68 
[   10.542183]  efifb_probe.part.3+0x10c/0x8dc 
[   10.546356]  efifb_probe+0x1d0/0x1d4 
[   10.549922]  platform_drv_probe+0x58/0xa8 
[   10.553921]  really_probe+0x224/0x3b8 
[   10.557572]  driver_probe_device+0xe4/0x138 
[   10.561745]  __driver_attach+0xe4/0x150 
[   10.565571]  bus_for_each_dev+0x70/0xa8 
[   10.569395]  driver_attach+0x30/0x40 
[   10.572960]  bus_add_driver+0x1a8/0x288 
[   10.576785]  driver_register+0x64/0x110 
[   10.580610]  __platform_driver_register+0x54/0x60 
[   10.585305]  efifb_driver_init+0x20/0x28 
[   10.589218]  do_one_initcall+0x3c/0x1ac 
[   10.593047]  kernel_init_freeable+0x2c8/0x36c 
[   10.597394]  kernel_init+0x18/0x114 
[   10.600872]  ret_from_fork+0x10/0x18 
[   10.604439] Code: f9404661 39400680 5100c000 b40001c1 (f9400023)  
[   10.610596] ---[ end trace 6130592880ff7916 ]--- 
[   10.615240] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b 

A newer commit (4.19.y:ce4f69c2c1a5) was tested on the same machine and didn't
have any issues (you should have a report for that too) and I can't find any
other boot issues for stable kernels in the execution history of the machine
either. Whether it's a one-off weird issue or a real bug with the commit is
a question I lack experience to answer but I hope the additional information
will help you out.

The same kernel booted fine on the other ARM machine it was tested on so it's
definitely not an ARM-generic issue.


Thanks,
Veronika

> thanks,
> 
> greg k-h
> 
> 
