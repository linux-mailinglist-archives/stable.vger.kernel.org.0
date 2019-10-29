Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77D2E82FA
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 09:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfJ2IJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 04:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbfJ2IJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 04:09:00 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACBD720663;
        Tue, 29 Oct 2019 08:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572336539;
        bh=+uZ729Yuh8ZXqi6hHrHeAb43Xpjm4jGWzCGsls6cC8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SGZvWEbQYwl45eQz7FAflObXzHukV+dJPF6VY5QIZbLboEHk4sxmqTKRn3DTOyNXS
         AzQ9WyITzStqleoGIt9xTW0XydaEI+MDxn3N2BtqfN0v8qihFltv0nXAxErBDPms9m
         JZBVP3u5Cni1SX7R46lZybPfQ2imnk0O4+sXX3Cw=
Date:   Tue, 29 Oct 2019 09:08:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, deepa.kernel@gmail.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, guaneryu@gmail.com,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191029080855.GA512708@kroah.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 03:33:18PM +0800, Murphy Zhou wrote:
> On Tue, Oct 29, 2019 at 10:55:34AM +0530, Naresh Kamboju wrote:
> > On Tue, 29 Oct 2019 at 07:33, CKI Project <cki-project@redhat.com> wrote:
> > >
> > >
> > > Hello,
> > >
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >             Commit: 96dab4347cbe - Linux 5.3.8-rc2
> > >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: OK
> > >              Tests: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for download here:
> > >
> > >   https://artifacts.cki-project.org/pipelines/253188
> > >
> > > One or more kernel tests failed:
> > >
> > >     ppc64le:
> > >      ❌ xfstests: ext4
> > >      ❌ xfstests: xfs
> > >
> > >     aarch64:
> > >      ❌ xfstests: ext4
> > >      ❌ xfstests: xfs
> > >
> > >     x86_64:
> > >      ❌ xfstests: ext4
> > >      ❌ xfstests: xfs
> > >
> > 
> > FYI,
> > The test log output,
> > 
> > Running test generic/402
> > #! /bin/bash
> > # SPDX-License-Identifier: GPL-2.0
> > # Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
> > #
> > # FS QA Test 402
> > #
> > # Test to verify filesystem timestamps for supported ranges.
> > #
> > # Exit status 1: test failed.
> > # Exit status 0: test passed.
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/aarch64 apm-mustang-b0-11 5.3.8-rc2-96dab43.cki
> > #1 SMP Mon Oct 28 14:23:22 UTC 2019
> > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1 /dev/sda4
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda4
> > /mnt/xfstests/mnt2
> > 
> > generic/402 - output mismatch (see
> > /var/lib/xfstests/results//generic/402.out.bad)
> >     --- tests/generic/402.out 2019-10-28 12:19:13.835212771 -0400
> >     +++ /var/lib/xfstests/results//generic/402.out.bad 2019-10-28
> > 13:13:55.503682127 -0400
> >     @@ -1,2 +1,4 @@
> >      QA output created by 402
> >     +2147483647;2147483647 != 2147483648;2147483648
> >     +2147483647;2147483647 != -2147483648;-2147483648
> >      Silence is golden
> >     ...
> >     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out
> > /var/lib/xfstests/results//generic/402.out.bad'  to see the entire
> > diff)
> > Ran: generic/402
> > Failures: generic/402
> > Failed 1 of 1 tests
> > 
> > Test source:
> > https://github.com/kdave/xfstests/blob/master/tests/generic/402
> > 
> > Here is the latest test case commit,
> > 
> > generic/402: fix for updated behavior of timestamp limits
> > 
> > The mount behavior will not be altered because of the unsupported
> > timestamps on the filesystems.
> > 
> > Adjust the test accordingly.
> > 
> > You can find the series at
> > https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897c2fb4debc
> 
> Yes, stable trees need this series to pass the test.

I do not understand, what "series"?  Can you provide the exact git
commit ids that I need to apply to the stable tree to resolve this?

thanks,

greg k-h
