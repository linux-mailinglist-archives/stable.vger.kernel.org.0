Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85502112450
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 09:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfLDISd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 03:18:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29851 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbfLDISc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 03:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575447510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kln9bTRM88rOH9XNgyOqW2POVap1DkdUcpikqALovvg=;
        b=Kxm7Z2rzQIqmplHtCo1YdSbwjUFgK16Cri2X50KTVSchoc9oqPn96atmuzZFDtAkBsXwzj
        DGMxE6fRPOmMJiDYZfIkyAsuLfjIbgr9rD/FMFCNLCHdzJUZFzCOQTSchDGf96CGZd/bEk
        ulyS+K83mF9VSFY08jD7sfiTSFYGpYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-CxSctQxENd25Qf7T29R53w-1; Wed, 04 Dec 2019 03:18:27 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC87D800D4C;
        Wed,  4 Dec 2019 08:18:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B49E85C1B0;
        Wed,  4 Dec 2019 08:18:26 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B32E5BC03;
        Wed,  4 Dec 2019 08:18:26 +0000 (UTC)
Date:   Wed, 4 Dec 2019 03:18:26 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        William Gomeringer <wgomeringer@redhat.com>
Message-ID: <2014617876.14947317.1575447506379.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.E29F90E1D2.DNJBK7BQCI@redhat.com>
References: <cki.E29F90E1D2.DNJBK7BQCI@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.3.14-a8a1bb9.cki_(stable-queue)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.21]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.14-a8a1bb9.cki (stable-queue)
Thread-Index: gVawCuvmigoaW2KLXrng0YJd6pk3Qg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: CxSctQxENd25Qf7T29R53w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.=
git
>             Commit: a8a1bb9b6315 - platform/x86: hp-wmi: Fix ACPI errors
>             caused by passing 0 as input size
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://artifacts.cki-project.org/pipelines/322089
>=20
> One or more kernel tests failed:
>=20
>     x86_64:
>      =E2=9D=8C LTP
>      =E2=9D=8C Boot test
>      =E2=9D=8C Boot test
>=20

Boot tests look like false positives. LTP hit kernel oops:
  https://artifacts.cki-project.org/pipelines/322089/logs/x86_64_host_1_con=
sole.log

[ 2418.739440] LTP: starting request_key01=20
[ 2418.742799] LTP: starting request_key02=20
[ 2420.749042] LTP: starting request_key03=20
[ 2420.751635] encrypted_key: keyword 'update' not allowed when called from=
 .instantiate method=20
[ 2420.877090] encrypted_key: keyword 'update' not allowed when called from=
 .instantiate method=20
[ 2420.879700] encrypted_key: keyword 'update' not allowed when called from=
 .instantiate method=20
...
[ 2421.147659] general protection fault: 0000 [#1] SMP PTI=20
[ 2421.148884] CPU: 0 PID: 439814 Comm: request_key03 Tainted: G        W  =
       5.3.14-a8a1bb9.cki #1=20
[ 2421.150916] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011=20
[ 2421.152199] RIP: 0010:kmem_cache_alloc+0x75/0x220=20
[ 2421.153244] Code: 01 00 00 4c 8b 45 00 65 49 8b 50 08 65 4c 03 05 d9 ef =
d4 4b 4d 8b 20 4d 85 e4 0f 84 71 01 00 00 8b 5d 20 48 8b 7d 00 4c 01 e3 <48=
> 33 1b 48 33 9d 70 01 00 00 40 f6 c7 0f 0f 85 6e 01 00 00 48 8d=20
[ 2421.157370] RSP: 0018:ffffa22a80ae3d30 EFLAGS: 00010282=20
[ 2421.158530] RAX: 0000000000000000 RBX: bb86d0eb53aa6367 RCX: 00000000000=
003f9=20
[ 2421.160108] RDX: 000000000001cdad RSI: 0000000000000dc0 RDI: 00000000000=
2d680=20
[ 2421.161675] RBP: ffff8d7c3b01ae00 R08: ffff8d7c3ba2d680 R09: 000000003f0=
10000=20
[ 2421.163275] R10: 0000000000000004 R11: 0000000063736564 R12: bb86d0eb53a=
a6367=20
[ 2421.164854] R13: 0000000000000dc0 R14: ffffffffb442447b R15: ffff8d7c3b0=
1ae00=20
[ 2421.166449] FS:  00007f0ce5368600(0000) GS:ffff8d7c3ba00000(0000) knlGS:=
0000000000000000=20
[ 2421.168225] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[ 2421.169508] CR2: 00007fb3e59f8380 CR3: 000000013972e005 CR4: 00000000007=
606f0=20
[ 2421.171073] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[ 2421.172660] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400=20
[ 2421.174222] PKRU: 55555554=20
[ 2421.174851] Call Trace:=20
[ 2421.175410]  key_alloc+0x12b/0x450=20
[ 2421.176175]  request_key_and_link+0x256/0x6a0=20
[ 2421.177146]  ? keyring_alloc+0x70/0x70=20
[ 2421.178005]  ? key_default_cmp+0x20/0x20=20
[ 2421.178882]  __x64_sys_request_key+0xf4/0x190=20
[ 2421.179856]  do_syscall_64+0x5f/0x1a0=20
[ 2421.180695]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[ 2421.181814] RIP: 0033:0x7f0ce529a1ad=20
[ 2421.182624] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ab 5c 0c 00 f7 d8 64 89 01 48=20
[ 2421.186749] RSP: 002b:00007fff61b77af8 EFLAGS: 00000246 ORIG_RAX: 000000=
00000000f9=20
[ 2421.188407] RAX: ffffffffffffffda RBX: 00007f0ce5368580 RCX: 00007f0ce52=
9a1ad=20
[ 2421.189994] RDX: 00000000004132e2 RSI: 00000000004132c5 RDI: 00000000004=
13367=20
[ 2421.191576] RBP: 000000002647d069 R08: 0000000000000000 R09: 00000000000=
00000=20
[ 2421.193145] R10: 00000000fffffffd R11: 0000000000000246 R12: 00000000000=
6b605=20
[ 2421.194730] R13: 0000000000413367 R14: 00000000000186a0 R15: 00000000000=
043fb=20
<followed by more call traces>

