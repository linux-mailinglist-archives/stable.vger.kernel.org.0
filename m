Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62560E8869
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 13:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732363AbfJ2Mkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 08:40:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53448 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbfJ2Mkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 08:40:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572352840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z6MhSwjQX5ZAWaEVN8Kl0bDFwG+YfZPo+g01p2D7qyo=;
        b=I5Db5gj5iSuyHraCqwcnnABMVSMPiNP/RFsgfrNopRi3f6TwouSbA5VkgTxn2qysZil1pg
        wjDoXWvEfB9yupYBo0hVw/BbocpfCSv2c+KDI8ow2oq1iNAN6wOLPCMx9CSeLMnVWQmbDF
        ougm0dayrz7gNcNBX7A3iz22F5uIYG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-RRo9B12HMGyGKcLaeKdnjg-1; Tue, 29 Oct 2019 08:40:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64418801E64;
        Tue, 29 Oct 2019 12:40:36 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC7EC5C21E;
        Tue, 29 Oct 2019 12:40:30 +0000 (UTC)
Date:   Tue, 29 Oct 2019 20:40:29 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Murphy Zhou <xzhou@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        deepa.kernel@gmail.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, guaneryu@gmail.com,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com>
 <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com>
MIME-Version: 1.0
In-Reply-To: <20191029092158.GA582092@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: RRo9B12HMGyGKcLaeKdnjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 10:21:58AM +0100, Greg KH wrote:
> On Tue, Oct 29, 2019 at 05:11:26PM +0800, Murphy Zhou wrote:
> > On Tue, Oct 29, 2019 at 09:08:55AM +0100, Greg KH wrote:
> > > On Tue, Oct 29, 2019 at 03:33:18PM +0800, Murphy Zhou wrote:
> > > > On Tue, Oct 29, 2019 at 10:55:34AM +0530, Naresh Kamboju wrote:
> > > > > On Tue, 29 Oct 2019 at 07:33, CKI Project <cki-project@redhat.com=
> wrote:
> > > > > >
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > We ran automated tests on a recent commit from this kernel tree=
:
> > > > > >
> > > > > >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/g=
it/stable/linux-stable-rc.git
> > > > > >             Commit: 96dab4347cbe - Linux 5.3.8-rc2
> > > > > >
> > > > > > The results of these automated tests are provided below.
> > > > > >
> > > > > >     Overall result: FAILED (see details below)
> > > > > >              Merge: OK
> > > > > >            Compile: OK
> > > > > >              Tests: FAILED
> > > > > >
> > > > > > All kernel binaries, config files, and logs are available for d=
ownload here:
> > > > > >
> > > > > >   https://artifacts.cki-project.org/pipelines/253188
> > > > > >
> > > > > > One or more kernel tests failed:
> > > > > >
> > > > > >     ppc64le:
> > > > > >      =E2=9D=8C xfstests: ext4
> > > > > >      =E2=9D=8C xfstests: xfs
> > > > > >
> > > > > >     aarch64:
> > > > > >      =E2=9D=8C xfstests: ext4
> > > > > >      =E2=9D=8C xfstests: xfs
> > > > > >
> > > > > >     x86_64:
> > > > > >      =E2=9D=8C xfstests: ext4
> > > > > >      =E2=9D=8C xfstests: xfs
> > > > > >
> > > > >=20
> > > > > FYI,
> > > > > The test log output,
> > > > >=20
> > > > > Running test generic/402
> > > > > #! /bin/bash
> > > > > # SPDX-License-Identifier: GPL-2.0
> > > > > # Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
> > > > > #
> > > > > # FS QA Test 402
> > > > > #
> > > > > # Test to verify filesystem timestamps for supported ranges.
> > > > > #
> > > > > # Exit status 1: test failed.
> > > > > # Exit status 0: test passed.
> > > > > FSTYP         -- xfs (non-debug)
> > > > > PLATFORM      -- Linux/aarch64 apm-mustang-b0-11 5.3.8-rc2-96dab4=
3.cki
> > > > > #1 SMP Mon Oct 28 14:23:22 UTC 2019
> > > > > MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D1,reflink=3D1 =
-i sparse=3D1 /dev/sda4
> > > > > MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sda=
4
> > > > > /mnt/xfstests/mnt2
> > > > >=20
> > > > > generic/402 - output mismatch (see
> > > > > /var/lib/xfstests/results//generic/402.out.bad)
> > > > >     --- tests/generic/402.out 2019-10-28 12:19:13.835212771 -0400
> > > > >     +++ /var/lib/xfstests/results//generic/402.out.bad 2019-10-28
> > > > > 13:13:55.503682127 -0400
> > > > >     @@ -1,2 +1,4 @@
> > > > >      QA output created by 402
> > > > >     +2147483647;2147483647 !=3D 2147483648;2147483648
> > > > >     +2147483647;2147483647 !=3D -2147483648;-2147483648
> > > > >      Silence is golden
> > > > >     ...
> > > > >     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out
> > > > > /var/lib/xfstests/results//generic/402.out.bad'  to see the entir=
e
> > > > > diff)
> > > > > Ran: generic/402
> > > > > Failures: generic/402
> > > > > Failed 1 of 1 tests
> > > > >=20
> > > > > Test source:
> > > > > https://github.com/kdave/xfstests/blob/master/tests/generic/402
> > > > >=20
> > > > > Here is the latest test case commit,
> > > > >=20
> > > > > generic/402: fix for updated behavior of timestamp limits
> > > > >=20
> > > > > The mount behavior will not be altered because of the unsupported
> > > > > timestamps on the filesystems.
> > > > >=20
> > > > > Adjust the test accordingly.
> > > > >=20
> > > > > You can find the series at
> > > > > https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897=
c2fb4debc
> > > >=20
> > > > Yes, stable trees need this series to pass the test.
> > >=20
> > > I do not understand, what "series"?  Can you provide the exact git
> > > commit ids that I need to apply to the stable tree to resolve this?
> >=20
> > Linus tree:
> >=20
> > cba465b4f982 ext4: Reduce ext4 timestamp warnings
> > 5ad32b3acded isofs: Initialize filesystem timestamp ranges
> > 83b8a3fbe3aa pstore: fs superblock limits
> > 8833293d0acc fs: omfs: Initialize filesystem timestamp ranges
> > cdd62b5b07e8 fs: hpfs: Initialize filesystem timestamp ranges
> > 028ca4db0a6e fs: ceph: Initialize filesystem timestamp ranges
> > 452c2779410a fs: sysv: Initialize filesystem timestamp ranges
> > 487b25bc4be9 fs: affs: Initialize filesystem timestamp ranges
> > c0da64f6bb67 fs: fat: Initialize filesystem timestamp ranges
> > cb7a69e60590 fs: cifs: Initialize filesystem timestamp ranges
> > 1fcb79c1b218 fs: nfs: Initialize filesystem timestamp ranges
> > 4881c4971df0 ext4: Initialize timestamps limits
> > d5c6e2d5188d 9p: Fill min and max timestamps in sb
> > 22b139691f9e fs: Fill in max and min timestamps in superblock
> > 42e729b9ddbb utimes: Clamp the timestamps before update
> > f8b92ba67c5d mount: Add mount warning for impending timestamp expiry
> > 3818c1907a5e timestamp_truncate: Replace users of timespec64_trunc
> > 50e17c000c46 vfs: Add timestamp_truncate() api
> > 188d20bcd1eb vfs: Add file timestamp range support
>=20
> That really looks like a new feature, not a bugfix for something, right?

Looks a new feature to me.

Thanks,
Murphy

>=20
> thanks,
>=20
> greg k-h

