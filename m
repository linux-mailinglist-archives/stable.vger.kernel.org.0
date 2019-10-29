Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68CE8449
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbfJ2JWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732566AbfJ2JWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:22:03 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384B720717;
        Tue, 29 Oct 2019 09:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340921;
        bh=8BiMjOGTMq9nHMWR/FS/EwUhfbFwcT1DTXawpfCaO1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LBhg6rxTzjRjbf0SRWlEV15dPGdJve3+4R7nUWePsTTNPMNaR9IMQJRL3rMfSaHX8
         jdL1HD/aC91WK0C3QzRNGg1yCBZUmjlX1er6wfrfegmbyjqO8MyuVMOfRAWPXB9MGd
         ADT0fSQZhrolkUooVCzFqeYLsshwG+PBThcZq3ko=
Date:   Tue, 29 Oct 2019 10:21:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, deepa.kernel@gmail.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, guaneryu@gmail.com,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191029092158.GA582092@kroah.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com>
 <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 05:11:26PM +0800, Murphy Zhou wrote:
> On Tue, Oct 29, 2019 at 09:08:55AM +0100, Greg KH wrote:
> > On Tue, Oct 29, 2019 at 03:33:18PM +0800, Murphy Zhou wrote:
> > > On Tue, Oct 29, 2019 at 10:55:34AM +0530, Naresh Kamboju wrote:
> > > > On Tue, 29 Oct 2019 at 07:33, CKI Project <cki-project@redhat.com> wrote:
> > > > >
> > > > >
> > > > > Hello,
> > > > >
> > > > > We ran automated tests on a recent commit from this kernel tree:
> > > > >
> > > > >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > >             Commit: 96dab4347cbe - Linux 5.3.8-rc2
> > > > >
> > > > > The results of these automated tests are provided below.
> > > > >
> > > > >     Overall result: FAILED (see details below)
> > > > >              Merge: OK
> > > > >            Compile: OK
> > > > >              Tests: FAILED
> > > > >
> > > > > All kernel binaries, config files, and logs are available for download here:
> > > > >
> > > > >   https://artifacts.cki-project.org/pipelines/253188
> > > > >
> > > > > One or more kernel tests failed:
> > > > >
> > > > >     ppc64le:
> > > > >      ❌ xfstests: ext4
> > > > >      ❌ xfstests: xfs
> > > > >
> > > > >     aarch64:
> > > > >      ❌ xfstests: ext4
> > > > >      ❌ xfstests: xfs
> > > > >
> > > > >     x86_64:
> > > > >      ❌ xfstests: ext4
> > > > >      ❌ xfstests: xfs
> > > > >
> > > > 
> > > > FYI,
> > > > The test log output,
> > > > 
> > > > Running test generic/402
> > > > #! /bin/bash
> > > > # SPDX-License-Identifier: GPL-2.0
> > > > # Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
> > > > #
> > > > # FS QA Test 402
> > > > #
> > > > # Test to verify filesystem timestamps for supported ranges.
> > > > #
> > > > # Exit status 1: test failed.
> > > > # Exit status 0: test passed.
> > > > FSTYP         -- xfs (non-debug)
> > > > PLATFORM      -- Linux/aarch64 apm-mustang-b0-11 5.3.8-rc2-96dab43.cki
> > > > #1 SMP Mon Oct 28 14:23:22 UTC 2019
> > > > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1 /dev/sda4
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda4
> > > > /mnt/xfstests/mnt2
> > > > 
> > > > generic/402 - output mismatch (see
> > > > /var/lib/xfstests/results//generic/402.out.bad)
> > > >     --- tests/generic/402.out 2019-10-28 12:19:13.835212771 -0400
> > > >     +++ /var/lib/xfstests/results//generic/402.out.bad 2019-10-28
> > > > 13:13:55.503682127 -0400
> > > >     @@ -1,2 +1,4 @@
> > > >      QA output created by 402
> > > >     +2147483647;2147483647 != 2147483648;2147483648
> > > >     +2147483647;2147483647 != -2147483648;-2147483648
> > > >      Silence is golden
> > > >     ...
> > > >     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out
> > > > /var/lib/xfstests/results//generic/402.out.bad'  to see the entire
> > > > diff)
> > > > Ran: generic/402
> > > > Failures: generic/402
> > > > Failed 1 of 1 tests
> > > > 
> > > > Test source:
> > > > https://github.com/kdave/xfstests/blob/master/tests/generic/402
> > > > 
> > > > Here is the latest test case commit,
> > > > 
> > > > generic/402: fix for updated behavior of timestamp limits
> > > > 
> > > > The mount behavior will not be altered because of the unsupported
> > > > timestamps on the filesystems.
> > > > 
> > > > Adjust the test accordingly.
> > > > 
> > > > You can find the series at
> > > > https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897c2fb4debc
> > > 
> > > Yes, stable trees need this series to pass the test.
> > 
> > I do not understand, what "series"?  Can you provide the exact git
> > commit ids that I need to apply to the stable tree to resolve this?
> 
> Linus tree:
> 
> cba465b4f982 ext4: Reduce ext4 timestamp warnings
> 5ad32b3acded isofs: Initialize filesystem timestamp ranges
> 83b8a3fbe3aa pstore: fs superblock limits
> 8833293d0acc fs: omfs: Initialize filesystem timestamp ranges
> cdd62b5b07e8 fs: hpfs: Initialize filesystem timestamp ranges
> 028ca4db0a6e fs: ceph: Initialize filesystem timestamp ranges
> 452c2779410a fs: sysv: Initialize filesystem timestamp ranges
> 487b25bc4be9 fs: affs: Initialize filesystem timestamp ranges
> c0da64f6bb67 fs: fat: Initialize filesystem timestamp ranges
> cb7a69e60590 fs: cifs: Initialize filesystem timestamp ranges
> 1fcb79c1b218 fs: nfs: Initialize filesystem timestamp ranges
> 4881c4971df0 ext4: Initialize timestamps limits
> d5c6e2d5188d 9p: Fill min and max timestamps in sb
> 22b139691f9e fs: Fill in max and min timestamps in superblock
> 42e729b9ddbb utimes: Clamp the timestamps before update
> f8b92ba67c5d mount: Add mount warning for impending timestamp expiry
> 3818c1907a5e timestamp_truncate: Replace users of timespec64_trunc
> 50e17c000c46 vfs: Add timestamp_truncate() api
> 188d20bcd1eb vfs: Add file timestamp range support

That really looks like a new feature, not a bugfix for something, right?

thanks,

greg k-h
