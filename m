Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4832218EDF7
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 03:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCWC0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 22:26:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:23752 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgCWC0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Mar 2020 22:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584930368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KA8i33OE3crakW63RTYEJl6zGvV0gUsyDfsUtbp2Eu0=;
        b=hF1E+xS+KODjfP9FQmDWKpVz+JN09VK/RGjBIJzzvBEnAUoXe0L/iMmQpuCsrqAGIarkzo
        a/w9TdVWtuQS0kq9DMcosk4955XRzrNbULtZ8wko29aDYxHgBggMCmmEjI2c6HXGSJ2SyL
        CszRzs4t06kiC7S94VG03esCWHahsSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-oQ8E0ntNOKWkdG7SH2caag-1; Sun, 22 Mar 2020 22:26:05 -0400
X-MC-Unique: oQ8E0ntNOKWkdG7SH2caag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EA3213F7;
        Mon, 23 Mar 2020 02:26:04 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940299081F;
        Mon, 23 Mar 2020 02:25:58 +0000 (UTC)
Date:   Mon, 23 Mar 2020 10:25:57 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.11-6df57ed.cki (stable-queue)
Message-ID: <20200323022557.vm3hlc3ndggp5yws@xzhoux.usersys.redhat.com>
References: <cki.D9E02DA05E.6L1W61X8RG@redhat.com>
 <20200323015828.GS4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200323015828.GS4189@sasha-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 22, 2020 at 09:58:28PM -0400, Sasha Levin wrote:
> On Sun, Mar 22, 2020 at 11:50:11PM -0000, CKI Project wrote:
> >=20
> > Hello,
> >=20
> > We ran automated tests on a recent commit from this kernel tree:
> >=20
> >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git
> >            Commit: 6df57ed14ddf - Revert "drm/fbdev: Fallback to non =
tiled mode if all tiles not present"
> >=20
> > The results of these automated tests are provided below.
> >=20
> >    Overall result: FAILED (see details below)
> >             Merge: OK
> >           Compile: OK
> >             Tests: PANICKED
> >=20
> > All kernel binaries, config files, and logs are available for downloa=
d here:
> >=20
> >  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3D=
datawarehouse/2020/03/22/500600
> >=20
> > One or more kernel tests failed:
> >=20
> >    ppc64le:
> >     =E2=9D=8C LTP
> >=20
> >    aarch64:
> >     =E2=9D=8C Boot test
> >=20
> >    x86_64:
> >     =F0=9F=92=A5 xfstests - ext4
>=20
> So I go in the xfstests___ext4/ directory to see what paniced, right? I
> don't see panics in those logs...

It's in the x86_64_3_console.log

[  247.623251] BUG: kernel NULL pointer dereference, address: 00000000000=
00000=20
[  247.631021] #PF: supervisor write access in kernel mode=20
[  247.636848] #PF: error_code(0x0002) - not-present page=20
[  247.642579] PGD 0 P4D 0 =20
[  247.645402] Oops: 0002 [#1] SMP PTI=20
[  247.649292] CPU: 2 PID: 1897 Comm: kworker/2:40 Tainted: G          I =
5.5.11-6df57ed.cki #1=20
[  247.659192] Hardware name: IBM System x3250 M4 -[2583ECU]-/00D3729, BI=
OS -[JQE168BUS-1.09]- 09/17/2014=20
[  247.669580] Workqueue: cgroup_destroy css_killed_work_fn=20
[  247.675506] RIP: 0010:bfq_bfqq_move+0x21/0x160=20
[  247.680462] Code: c0 c3 0f 1f 80 00 00 00 00 0f 1f 44 00 00 41 55 41
54 49 89 fc 55 48 89 f5 53 48 89 d3 48 39 b7 a0 00 00 00 0f 84 22 01 00
00 <83> 45 00 01 48 89 ef e8 a3 87 ff ff 85 c0 0f 85 d7 00 00 00 80 bd=20
[  247.701415] RSP: 0018:ffffb61340e87db0 EFLAGS: 00010086=20
[  247.707242] RAX: 0000000000000000 RBX: ffff99d9b1dd8000 RCX: 000000000=
0000000=20
[  247.715202] RDX: ffff99d9b1dd8000 RSI: 0000000000000000 RDI: ffff99d9b=
1dda000=20
[  247.723161] RBP: 0000000000000000 R08: 000000003b9aca00 R09: ffff99d9b=
1d87300=20
[  247.731123] R10: 0000000000000000 R11: ffff99d9b1d87300 R12: ffff99d9b=
1dda000=20
[  247.739083] R13: ffff99d98492d1b0 R14: ffff99d9b1dda3f0 R15: ffff99d98=
492d098=20
[  247.747044] FS:  0000000000000000(0000) GS:ffff99d9b7c80000(0000) knlG=
S:0000000000000000=20
[  247.756073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  247.762481] CR2: 0000000000000000 CR3: 000000023060a005 CR4: 000000000=
01606e0=20
[  247.770441] Call Trace:=20
[  247.773170]  bfq_pd_offline+0x87/0xf0=20
[  247.777254]  blkg_destroy+0x52/0xf0=20
[  247.781143]  blkcg_destroy_blkgs+0x4f/0xa0=20
[  247.785710]  css_killed_work_fn+0x4d/0xd0=20
[  247.790181]  process_one_work+0x1b5/0x360=20
[  247.794651]  worker_thread+0x50/0x3c0=20
[  247.798733]  kthread+0xf9/0x130=20
[  247.802234]  ? process_one_work+0x360/0x360=20
[  247.806899]  ? kthread_park+0x90/0x90=20
[  247.810983]  ret_from_fork+0x35/0x40=20
>=20
> --=20
> Thanks,
> Sasha
>=20

--=20
Murphy

