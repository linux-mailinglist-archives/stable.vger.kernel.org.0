Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8CE828B
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 08:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfJ2Hdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 03:33:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbfJ2Hdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 03:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572334410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+JQaagmfKe/fneBkfD4UQR7vr9L5AoGK7+7f9TiQNM=;
        b=CobafMsr9YaKmB6H7a6dMBFK2jLejUfh10iq5MoFSdUFYkeBgZe3KgFW4BsqRCVRViSp4n
        mJJjM6QPRQrNNFkzivT+5OpdWQ2p08EZFLSpuJTu+AkCJHth+lJngpKzGtG7a867kncuUT
        41QmNrCSGp1dqNeBRV4ep35x/0vWd4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-g5F18trMOOOWiICQEEKHaQ-1; Tue, 29 Oct 2019 03:33:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06E441005500;
        Tue, 29 Oct 2019 07:33:26 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E6855D9C3;
        Tue, 29 Oct 2019 07:33:20 +0000 (UTC)
Date:   Tue, 29 Oct 2019 15:33:18 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     deepa.kernel@gmail.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>, lkft-triage@lists.linaro.org,
        guaneryu@gmail.com, CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc2-96dab43.cki (stable)
Message-ID: <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com>
 <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: g5F18trMOOOWiICQEEKHaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 10:55:34AM +0530, Naresh Kamboju wrote:
> On Tue, 29 Oct 2019 at 07:33, CKI Project <cki-project@redhat.com> wrote:
> >
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux-stable-rc.git
> >             Commit: 96dab4347cbe - Linux 5.3.8-rc2
> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >
> > All kernel binaries, config files, and logs are available for download =
here:
> >
> >   https://artifacts.cki-project.org/pipelines/253188
> >
> > One or more kernel tests failed:
> >
> >     ppc64le:
> >      =E2=9D=8C xfstests: ext4
> >      =E2=9D=8C xfstests: xfs
> >
> >     aarch64:
> >      =E2=9D=8C xfstests: ext4
> >      =E2=9D=8C xfstests: xfs
> >
> >     x86_64:
> >      =E2=9D=8C xfstests: ext4
> >      =E2=9D=8C xfstests: xfs
> >
>=20
> FYI,
> The test log output,
>=20
> Running test generic/402
> #! /bin/bash
> # SPDX-License-Identifier: GPL-2.0
> # Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
> #
> # FS QA Test 402
> #
> # Test to verify filesystem timestamps for supported ranges.
> #
> # Exit status 1: test failed.
> # Exit status 0: test passed.
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/aarch64 apm-mustang-b0-11 5.3.8-rc2-96dab43.cki
> #1 SMP Mon Oct 28 14:23:22 UTC 2019
> MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D1,reflink=3D1 -i spars=
e=3D1 /dev/sda4
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sda4
> /mnt/xfstests/mnt2
>=20
> generic/402 - output mismatch (see
> /var/lib/xfstests/results//generic/402.out.bad)
>     --- tests/generic/402.out 2019-10-28 12:19:13.835212771 -0400
>     +++ /var/lib/xfstests/results//generic/402.out.bad 2019-10-28
> 13:13:55.503682127 -0400
>     @@ -1,2 +1,4 @@
>      QA output created by 402
>     +2147483647;2147483647 !=3D 2147483648;2147483648
>     +2147483647;2147483647 !=3D -2147483648;-2147483648
>      Silence is golden
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out
> /var/lib/xfstests/results//generic/402.out.bad'  to see the entire
> diff)
> Ran: generic/402
> Failures: generic/402
> Failed 1 of 1 tests
>=20
> Test source:
> https://github.com/kdave/xfstests/blob/master/tests/generic/402
>=20
> Here is the latest test case commit,
>=20
> generic/402: fix for updated behavior of timestamp limits
>=20
> The mount behavior will not be altered because of the unsupported
> timestamps on the filesystems.
>=20
> Adjust the test accordingly.
>=20
> You can find the series at
> https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897c2fb4deb=
c

Yes, stable trees need this series to pass the test.

Thanks,
Murphy

>=20
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
>=20
> - Naresh

