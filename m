Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F402C95EE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 04:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgLADkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 22:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgLADkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 22:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606793965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkOrNjqoifoUDvU0bqaHgBumSg0zWPEJVy7dymJZ6/8=;
        b=FehCR6dbuz5D5+vNk/j3M+uWMT7T7W1REdlBbi+uk/cOB7yPmebtXMMXN1HZVdp3bbmpBO
        JfhKlq5nGbBQzR4fTif16PgiOeHZYWU00/jddp2ztiiOO+BkOImrSbO3W041peYbU/B/Ou
        Rz61G0IwgTroF0gHhj+5ispsb8lPWXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-yb3-FueTOhCqehdQhxSfow-1; Mon, 30 Nov 2020 22:39:21 -0500
X-MC-Unique: yb3-FueTOhCqehdQhxSfow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90F6A817B82;
        Tue,  1 Dec 2020 03:39:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6268160854;
        Tue,  1 Dec 2020 03:39:20 +0000 (UTC)
Received: from zmail26.collab.prod.int.phx2.redhat.com (zmail26.collab.prod.int.phx2.redhat.com [10.5.83.33])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E84B4BB40;
        Tue,  1 Dec 2020 03:39:20 +0000 (UTC)
Date:   Mon, 30 Nov 2020 22:39:20 -0500 (EST)
From:   Xiumei Mu <xmu@redhat.com>
To:     CKI Project <cki-project@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     skt-results-master@redhat.com, Rachel Sibley <rasibley@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        David Arcari <darcari@redhat.com>, stable@vger.kernel.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org
Message-ID: <498412291.60269669.1606793960061.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.F19CB7B77D.VRP8CBG6KH@redhat.com>
References: <cki.F19CB7B77D.VRP8CBG6KH@redhat.com>
Subject: =?utf-8?Q?Re:_=F0=9F=92=A5_PANICKED:_Waiting_for_review:_Tes?=
 =?utf-8?Q?t_report_for_kernel_5.9.11_(stable-queue)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.9]
Thread-Topic: ? PANICKED: Waiting for review: Test report for kernel 5.9.11 (stable-queue)
Thread-Index: UCqmga6nYXOB+UwI5lTrTNqralvfEg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: skt-results-master@redhat.com
> Cc: "Yi Zhang" <yi.zhang@redhat.com>, "Xiong Zhou" <xzhou@redhat.com>, "R=
achel Sibley" <rasibley@redhat.com>, "Xiumei
> Mu" <xmu@redhat.com>, "Jianwen Ji" <jiji@redhat.com>, "Hangbin Liu" <hali=
u@redhat.com>, "David Arcari"
> <darcari@redhat.com>
> Sent: Sunday, November 29, 2020 11:32:43 AM
> Subject: =F0=9F=92=A5 PANICKED: Waiting for review: Test report for kerne=
l 5.9.11 (stable-queue)
>=20
>=20
> =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> =E2=94=82 REVIEW REQUIRED FOR FAILED TEST                               =
=E2=94=82
> =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> =E2=94=82 This failed kernel test has been held for review by kernel    =
=E2=94=82
> =E2=94=82 test maintainers and the CKI team. Please investigate using   =
=E2=94=82
> =E2=94=82 the pipeline link below this box.                             =
=E2=94=82
> =E2=94=82                                                               =
=E2=94=82
> =E2=94=82 If the test failure is related to a non-kernel bug, no action =
=E2=94=82
> =E2=94=82 is needed. If a kernel bug is found, please reply all with    =
=E2=94=82
> =E2=94=82 your assessment and we will release the report.               =
=E2=94=82
> =E2=94=82 For more details: https://docs.engineering.redhat.com/x/eG5qB =
=E2=94=82
> =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>=20
> Pipeline:
> https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/-/pipeline=
s/618811
>=20
> Check out if the issue is autotriaged in the dashboard:
>     https://datawarehouse.internal.cki-project.org/kcidb/revisions/7444
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: 6d1358afba7c - drm/amd/display: Avoid HDCP initializa=
tion
>             in devices without output
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: PANICKED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?p=
refix=3Ddatawarehouse-public/2020/11/28/618811
>=20
> One or more kernel tests failed:
>=20
>     x86_64:
>      =F0=9F=92=A5 Networking socket: fuzz

The test case is socket fuzz test, no reproducer, and no vmcore.

The Call Trace is here:
[15358.193947] can: controller area network core (rev 20170425 abi 9)=20
[15358.195259] NET: Registered protocol family 29=20
[15358.852499] list_del corruption. next->prev should be ffff9a927074d550, =
but was ffff9a922773e360=20
[15358.853108] ------------[ cut here ]------------=20
[15358.853108] kernel BUG at lib/list_debug.c:54!=20
[15358.853108] invalid opcode: 0000 [#1] SMP PTI=20
[15358.853108] CPU: 1 PID: 252559 Comm: kworker/1:3 Kdump: loaded Tainted: =
G          IOE     5.9.11 #1=20
[15358.853108] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15358.853108] Workqueue: cgwb_release cgwb_release_workfn=20
[15358.853108] RIP: 0010:__list_del_entry_valid.cold+0x1d/0x47=20
[15358.853108] Code: c7 c7 30 97 3e 85 e8 3b 4c fe ff 0f 0b 48 89 fe 48 c7 =
c7 c0 97 3e 85 e8 2a 4c fe ff 0f 0b 48 c7 c7 70 98 3e 85 e8 1c 4c fe ff <0f=
> 0b 48 89 f2 48 89 fe 48 c7 c7 30 98 3e 85 e8 08 4c fe ff 0f 0b=20
[15358.853108] RSP: 0018:ffffbbf101347e40 EFLAGS: 00010092=20
[15358.853108] RAX: 0000000000000054 RBX: ffff9a927074d540 RCX: 00000000000=
00000=20
[15358.853108] RDX: ffff9a927fc67060 RSI: ffff9a927fc58d00 RDI: ffff9a927fc=
58d00=20
[15358.853108] RBP: 0000000000000206 R08: 000000000000468c R09: 00000000000=
00b12=20
[15358.853108] R10: 0000000000000000 R11: ffffbbf101347cdd R12: 00000000fff=
fffff=20
[15358.853108] R13: ffff9a927074d400 R14: ffff9a9244067000 R15: ffff9a92707=
4d6a0=20
[15358.853108] FS:  0000000000000000(0000) GS:ffff9a927fc40000(0000) knlGS:=
0000000000000000=20
[15358.853108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15358.853108] CR2: 00007f74a76990f8 CR3: 0000000020be4000 CR4: 00000000000=
406e0=20
[15358.853108] Call Trace:=20
[15358.853108]  percpu_counter_destroy+0x24/0x80=20
[15358.853108]  wb_exit+0x4d/0x90=20
[15358.853108]  cgwb_release_workfn+0xa1/0x140=20
[15358.853108]  process_one_work+0x1b4/0x370=20
[15358.853108]  worker_thread+0x53/0x3e0=20
[15358.853108]  ? process_one_work+0x370/0x370=20
[15358.853108]  kthread+0x11b/0x140=20
[15358.853108]  ? __kthread_bind_mask+0x60/0x60=20
[15358.853108]  ret_from_fork+0x22/0x30=20
[15358.853108] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15358.853108] ---[ end trace e621d981e1857d7e ]---=20
[15358.853108] RIP: 0010:__list_del_entry_valid.cold+0x1d/0x47=20
[15358.853108] Code: c7 c7 30 97 3e 85 e8 3b 4c fe ff 0f 0b 48 89 fe 48 c7 =
c7 c0 97 3e 85 e8 2a 4c fe ff 0f 0b 48 c7 c7 70 98 3e 85 e8 1c 4c fe ff <0f=
> 0b 48 89 f2 48 89 fe 48 c7 c7 30 98 3e 85 e8 08 4c fe ff 0f 0b=20
[15358.853108] RSP: 0018:ffffbbf101347e40 EFLAGS: 00010092=20
[15358.853108] RAX: 0000000000000054 RBX: ffff9a927074d540 RCX: 00000000000=
00000=20
[15358.853108] RDX: ffff9a927fc67060 RSI: ffff9a927fc58d00 RDI: ffff9a927fc=
58d00=20
[15358.853108] RBP: 0000000000000206 R08: 000000000000468c R09: 00000000000=
00b12=20
[15358.853108] R10: 0000000000000000 R11: ffffbbf101347cdd R12: 00000000fff=
fffff=20
[15358.853108] R13: ffff9a927074d400 R14: ffff9a9244067000 R15: ffff9a92707=
4d6a0=20
[15358.853108] FS:  0000000000000000(0000) GS:ffff9a927fc40000(0000) knlGS:=
0000000000000000=20
[15358.853108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15358.853108] CR2: 00007f74a76990f8 CR3: 0000000020be4000 CR4: 00000000000=
406e0=20
[15359.150252] sock: process `socket' is using obsolete setsockopt SO_BSDCO=
MPAT=20
[15378.513070] NMI watchdog: Watchdog detected hard LOCKUP on cpu 3=20
[15378.513070] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15378.513094] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G      =
D   IOE     5.9.11 #1=20
[15378.513095] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15378.513095] RIP: 0010:cpu_idle_poll.isra.0+0x36/0xf0=20
[15378.513096] Code: 48 7b 66 66 66 66 90 e8 18 25 5c ff fb 66 66 90 66 66 =
90 65 48 8b 1c 25 c0 7b 01 00 48 8b 03 a8 08 74 0b eb 1c f3 90 48 8b 03 <a8=
> 08 75 13 8b 05 08 cb cd 00 85 c0 75 ed e8 e7 23 5e ff 85 c0 75=20
[15378.513097] RSP: 0018:ffffbbf100087ef8 EFLAGS: 00000202=20
[15378.513098] RAX: 0000000000204000 RBX: ffff9a927f720000 RCX: 00000dfaa48=
4f7cd=20
[15378.513098] RDX: ffff9a927f46e070 RSI: 00000dfaa484f7cd RDI: 00000000000=
00000=20
[15378.513099] RBP: 0000000000000003 R08: 00000dfaa484fc38 R09: 00000dfaa48=
4f2ed=20
[15378.513099] R10: 0000000000000005 R11: 000000000001f865 R12: 00000000000=
00000=20
[15378.513100] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000=20
[15378.513101] FS:  0000000000000000(0000) GS:ffff9a927fcc0000(0000) knlGS:=
0000000000000000=20
[15378.513101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15378.513102] CR2: 00007f0f00017198 CR3: 000000006d8cc000 CR4: 00000000000=
406e0=20
[15378.513102] DR0: 0000000000420810 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15378.513103] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400=20
[15378.513103] Call Trace:=20
[15378.513103]  do_idle+0x44/0x270=20
[15378.513104]  cpu_startup_entry+0x19/0x20=20
[15378.513104]  secondary_startup_64+0xb6/0xc0=20
[15384.392107] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [modprobe:=
439666]=20
[15384.392107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15384.392107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOE     5.9.11 #1=20
[15384.392107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15384.392107] RIP: 0010:smp_call_function_many_cond+0x289/0x2d0=20
[15384.392107] Code: e8 7c 07 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b fe ff =
ff 48 63 c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 f3 90 <8b=
> 42 08 a8 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44 89 f7=20
[15384.392107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15384.392107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15384.392107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15384.392107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15384.392107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15384.392107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15384.392107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15384.392107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15384.392107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15384.392107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15384.392107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600=20
[15384.392107] Call Trace:=20
[15384.392107]  ? invalidate_user_asid+0x40/0x40=20
[15384.392107]  ? invalidate_user_asid+0x40/0x40=20
[15384.392107]  on_each_cpu+0x2b/0x60=20
[15384.392107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15384.392107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15384.392107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15384.392107]  change_page_attr_set_clr+0x9e/0x190=20
[15384.392107]  set_memory_ro+0x26/0x30=20
[15384.392107]  module_enable_ro.part.0+0x5f/0xb0=20
[15384.392107]  load_module+0x20a7/0x2550=20
[15384.392107]  ? ima_post_read_file+0xca/0xe0=20
[15384.392107]  __do_sys_finit_module+0x9c/0xe0=20
[15384.392107]  do_syscall_64+0x33/0x40=20
[15384.392107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15384.392107] RIP: 0033:0x7f267dc3130d=20
[15384.392107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15384.392107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15384.392107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15384.392107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15384.392107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15384.392107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15384.392107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[15412.392107] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [modprobe:=
439666]=20
[15412.392107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15412.392107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOEL    5.9.11 #1=20
[15412.392107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15412.392107] RIP: 0010:smp_call_function_many_cond+0x289/0x2d0=20
[15412.392107] Code: e8 7c 07 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b fe ff =
ff 48 63 c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 f3 90 <8b=
> 42 08 a8 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44 89 f7=20
[15412.392107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15412.392107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15412.392107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15412.392107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15412.392107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15412.392107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15412.392107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15412.392107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15412.392107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15412.392107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15412.392107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600=20
[15412.392107] Call Trace:=20
[15412.392107]  ? invalidate_user_asid+0x40/0x40=20
[15412.392107]  ? invalidate_user_asid+0x40/0x40=20
[15412.392107]  on_each_cpu+0x2b/0x60=20
[15412.392107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15412.392107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15412.392107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15412.392107]  change_page_attr_set_clr+0x9e/0x190=20
[15412.392107]  set_memory_ro+0x26/0x30=20
[15412.392107]  module_enable_ro.part.0+0x5f/0xb0=20
[15412.392107]  load_module+0x20a7/0x2550=20
[15412.392107]  ? ima_post_read_file+0xca/0xe0=20
[15412.392107]  __do_sys_finit_module+0x9c/0xe0=20
[15412.392107]  do_syscall_64+0x33/0x40=20
[15412.392107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15412.392107] RIP: 0033:0x7f267dc3130d=20
[15412.392107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15412.392107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15412.392107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15412.392107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15412.392107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15412.392107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15412.392107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[15440.392107] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [modprobe:=
439666]=20
[15440.392107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15440.392107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOEL    5.9.11 #1=20
[15440.392107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15440.392107] RIP: 0010:smp_call_function_many_cond+0x287/0x2d0=20
[15440.392107] Code: 76 08 e8 7c 07 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b =
fe ff ff 48 63 c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 <f3=
> 90 8b 42 08 a8 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44=20
[15440.392107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15440.392107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15440.392107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15440.392107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15440.392107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15440.392107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15440.392107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15440.392107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15440.392107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15440.392107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15440.392107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600=20
[15440.392107] Call Trace:=20
[15440.392107]  ? invalidate_user_asid+0x40/0x40=20
[15440.392107]  ? invalidate_user_asid+0x40/0x40=20
[15440.392107]  on_each_cpu+0x2b/0x60=20
[15440.392107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15440.392107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15440.392107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15440.392107]  change_page_attr_set_clr+0x9e/0x190=20
[15440.392107]  set_memory_ro+0x26/0x30=20
[15440.392107]  module_enable_ro.part.0+0x5f/0xb0=20
[15440.392107]  load_module+0x20a7/0x2550=20
[15440.392107]  ? ima_post_read_file+0xca/0xe0=20
[15440.392107]  __do_sys_finit_module+0x9c/0xe0=20
[15440.392107]  do_syscall_64+0x33/0x40=20
[15440.392107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15440.392107] RIP: 0033:0x7f267dc3130d=20
[15440.392107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15440.392107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15440.392107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15440.392107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15440.392107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15440.392107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15440.392107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[15468.392107] watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [modprobe:=
439666]=20
[15468.392107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15468.392107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOEL    5.9.11 #1=20
[15468.392107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15468.392107] RIP: 0010:smp_call_function_many_cond+0x28c/0x2d0=20
[15468.392107] Code: 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b fe ff ff 48 63 =
c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 f3 90 8b 42 08 <a8=
> 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44 89 f7 e8 0c 08=20
[15468.392107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15468.392107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15468.392107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15468.392107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15468.392107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15468.392107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15468.392107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15468.392107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15468.392107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15468.392107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15468.392107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600=20
[15468.392107] Call Trace:=20
[15468.392107]  ? invalidate_user_asid+0x40/0x40=20
[15468.392107]  ? invalidate_user_asid+0x40/0x40=20
[15468.392107]  on_each_cpu+0x2b/0x60=20
[15468.392107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15468.392107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15468.392107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15468.392107]  change_page_attr_set_clr+0x9e/0x190=20
[15468.392107]  set_memory_ro+0x26/0x30=20
[15468.392107]  module_enable_ro.part.0+0x5f/0xb0=20
[15468.392107]  load_module+0x20a7/0x2550=20
[15468.392107]  ? ima_post_read_file+0xca/0xe0=20
[15468.392107]  __do_sys_finit_module+0x9c/0xe0=20
[15468.392107]  do_syscall_64+0x33/0x40=20
[15468.392107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15468.392107] RIP: 0033:0x7f267dc3130d=20
[15468.392107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15468.392107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15468.392107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15468.392107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15468.392107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15468.392107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15468.392107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[15496.392107] watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [modprobe:=
439666]=20
[15496.392107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15496.392107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOEL    5.9.11 #1=20
[15496.392107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15496.392107] RIP: 0010:smp_call_function_many_cond+0x28c/0x2d0=20
[15496.392107] Code: 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b fe ff ff 48 63 =
c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 f3 90 8b 42 08 <a8=
> 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44 89 f7 e8 0c 08=20
[15496.392107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15496.392107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15496.392107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15496.392107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15496.392107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15496.392107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15496.392107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15496.392107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15496.392107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15496.392107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15496.392107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00600=20
[15496.392107] Call Trace:=20
[15496.392107]  ? invalidate_user_asid+0x40/0x40=20
[15496.392107]  ? invalidate_user_asid+0x40/0x40=20
[15496.392107]  on_each_cpu+0x2b/0x60=20
[15496.392107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15496.392107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15496.392107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15496.392107]  change_page_attr_set_clr+0x9e/0x190=20
[15496.392107]  set_memory_ro+0x26/0x30=20
[15496.392107]  module_enable_ro.part.0+0x5f/0xb0=20
[15496.392107]  load_module+0x20a7/0x2550=20
[15496.392107]  ? ima_post_read_file+0xca/0xe0=20
[15496.392107]  __do_sys_finit_module+0x9c/0xe0=20
[15496.392107]  do_syscall_64+0x33/0x40=20
[15496.392107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15496.392107] RIP: 0033:0x7f267dc3130d=20
[15496.392107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15496.392107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15496.392107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15496.392107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15496.392107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15496.392107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15496.392107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[-- MARK -- Sat Nov 28 20:20:00 2020]=20
[15509.735110] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1=20
[15509.735110] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15509.735110] CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G      =
D   IOEL    5.9.11 #1=20
[15509.735110] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15509.735110] RIP: 0010:cpu_idle_poll.isra.0+0x36/0xf0=20
[15509.735110] Code: 48 7b 66 66 66 66 90 e8 18 25 5c ff fb 66 66 90 66 66 =
90 65 48 8b 1c 25 c0 7b 01 00 48 8b 03 a8 08 74 0b eb 1c f3 90 48 8b 03 <a8=
> 08 75 13 8b 05 08 cb cd 00 85 c0 75 ed e8 e7 23 5e ff 85 c0 75=20
[15509.735110] RSP: 0018:ffffbbf100077ef8 EFLAGS: 00000202=20
[15509.735110] RAX: 0000000000204000 RBX: ffff9a927f724b80 RCX: 00000e1b069=
062c3=20
[15509.735110] RDX: ffff9a927f46e070 RSI: 00000e1b069062c3 RDI: 00000000000=
00000=20
[15509.735110] RBP: 0000000000000001 R08: 00000e1b069066a3 R09: 00000e1b069=
05ce9=20
[15509.735110] R10: 0000000000000005 R11: 000000000001f865 R12: 00000000000=
00000=20
[15509.735110] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000=20
[15509.735110] FS:  0000000000000000(0000) GS:ffff9a927fc40000(0000) knlGS:=
0000000000000000=20
[15509.735110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15509.735110] CR2: 0000000001543ec8 CR3: 0000000020be4000 CR4: 00000000000=
406e0=20
[15509.735110] Call Trace:=20
[15509.735110]  do_idle+0x44/0x270=20
[15509.735110]  cpu_startup_entry+0x19/0x20=20
[15509.735110]  secondary_startup_64+0xb6/0xc0=20
[15509.736107] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2=20
[15509.736107] Modules linked in: can mlx4_ib ib_uverbs ib_core mlx4_en mlx=
4_core nls_utf8 isofs snd_seq_dummy minix binfmt_misc nfsv3 nfs_acl rds tun=
 brd overlay fuse exfat vfat fat loop n_gsm pps_ldisc ppp_synctty mkiss ax2=
5 ppp_async ppp_generic slcan slip slhc snd_hrtimer snd_seq snd_seq_device =
sctp snd_timer snd soundcore authenc pcrypt crypto_user sha3_generic salsa2=
0_generic n_hdlc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g=
race nfs_ssc fscache rfkill sunrpc iTCO_wdt intel_pmc_bxt gpio_ich coretemp=
 iTCO_vendor_support kvm_intel kvm irqbypass ipmi_ssif pcspkr hpilo bnx2 ac=
pi_ipmi hpwdt lpc_ich ipmi_si ipmi_devintf ipmi_msghandler i5000_edac i5k_a=
mb zram ip_tables xfs radeon i2c_algo_bit drm_kms_helper cec ttm serio_raw =
drm ata_generic pata_acpi hpsa scsi_transport_sas [last unloaded: dummy]=20
[15509.736107] CPU: 2 PID: 439666 Comm: modprobe Kdump: loaded Tainted: G  =
    D   IOEL    5.9.11 #1=20
[15509.736107] Hardware name: HP ProLiant DL360 G5, BIOS P58 07/10/2009=20
[15509.736107] RIP: 0010:smp_call_function_many_cond+0x289/0x2d0=20
[15509.736107] Code: e8 7c 07 4c 00 3b 05 ca 2f 6f 01 89 c7 0f 83 0b fe ff =
ff 48 63 c7 49 8b 16 48 03 14 c5 00 59 47 85 8b 42 08 a8 01 74 09 f3 90 <8b=
> 42 08 a8 01 75 f7 eb c9 48 c7 c2 a0 8e 86 85 4c 89 fe 44 89 f7=20
[15509.736107] RSP: 0018:ffffbbf100dc7ba0 EFLAGS: 00000202=20
[15509.736107] RAX: 0000000000000011 RBX: 00000000000313c0 RCX: 00000000000=
00000=20
[15509.736107] RDX: ffff9a927fc313c0 RSI: 0000000000000000 RDI: 00000000000=
00000=20
[15509.736107] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15509.736107] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000=20
[15509.736107] R13: 0000000000000003 R14: ffff9a927fcab400 R15: 00000000000=
00008=20
[15509.736107] FS:  00007f267db07740(0000) GS:ffff9a927fc80000(0000) knlGS:=
0000000000000000=20
[15509.736107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[15509.736107] CR2: 00007f267dc9c220 CR3: 0000000037d0a000 CR4: 00000000000=
406e0=20
[15509.736107] DR0: 0000000000000001 DR1: 0000000000000000 DR2: 00000000000=
00000=20
[15509.736107] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400=20
[15509.736107] Call Trace:=20
[15509.736107]  ? invalidate_user_asid+0x40/0x40=20
[15509.736107]  ? invalidate_user_asid+0x40/0x40=20
[15509.736107]  on_each_cpu+0x2b/0x60=20
[15509.736107]  __purge_vmap_area_lazy+0x5d/0x690=20
[15509.736107]  ? find_exported_symbol_in_section+0x45/0xd0=20
[15509.736107]  _vm_unmap_aliases.part.0+0x104/0x140=20
[15509.736107]  change_page_attr_set_clr+0x9e/0x190=20
[15509.736107]  set_memory_ro+0x26/0x30=20
[15509.736107]  module_enable_ro.part.0+0x5f/0xb0=20
[15509.736107]  load_module+0x20a7/0x2550=20
[15509.736107]  ? ima_post_read_file+0xca/0xe0=20
[15509.736107]  __do_sys_finit_module+0x9c/0xe0=20
[15509.736107]  do_syscall_64+0x33/0x40=20
[15509.736107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9=20
[15509.736107] RIP: 0033:0x7f267dc3130d=20
[15509.736107] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3b 7b 0c 00 f7 d8 64 89 01 48=20
[15509.736107] RSP: 002b:00007ffeb0520438 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139=20
[15509.736107] RAX: ffffffffffffffda RBX: 000055ac2ca54ed0 RCX: 00007f267dc=
3130d=20
[15509.736107] RDX: 0000000000000000 RSI: 000055ac2b6f96a6 RDI: 00000000000=
00000=20
[15509.736107] RBP: 0000000000040000 R08: 0000000000000000 R09: 00000000000=
00000=20
[15509.736107] R10: 0000000000000000 R11: 0000000000000246 R12: 000055ac2b6=
f96a6=20
[15509.736107] R13: 000055ac2ca54ce0 R14: 000055ac2ca54ed0 R15: 000055ac2ca=
55040=20
[-- MARK -- Sat Nov 28 20:25:00 2020]=20



>=20
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this
> message.
>=20
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more
> effective.
>=20
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> _________________________________________________________________________=
_____
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 4 architectures:
>=20
>     aarch64:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     ppc64le:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     s390x:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     x86_64:
>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
>=20
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>=20
>   aarch64:
>     Host 1: https://beaker.engineering.redhat.com/recipes/9115542
>=20
>        =E2=9A=A1 Internal infrastructure issues prevented one or more tes=
ts (marked
>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectur=
e.
>        This is not the fault of the kernel that was tested.
>=20
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesyste=
m fio test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue sch=
eduler test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm rai=
d_module test
>=20
>     Host 2: https://beaker.engineering.redhat.com/recipes/9115541
>        =E2=9C=85 Boot test
>        =E2=9C=85 ACPI table test
>        =E2=9C=85 ACPI enabled test
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory: fork_mem
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking: igmp conformance test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - transport
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =E2=9C=85 pciutils: update pci ids test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 storage: SCSI VPD
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 Firmware test suite
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 kdump - kexec_boot
>=20
>     Host 3: https://beaker.engineering.redhat.com/recipes/9115727
>=20
>        =E2=9A=A1 Internal infrastructure issues prevented one or more tes=
ts (marked
>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectur=
e.
>        This is not the fault of the kernel that was tested.
>=20
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesyste=
m fio test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue sch=
eduler test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm rai=
d_module test
>=20
>     Host 4: https://beaker.engineering.redhat.com/recipes/9115861
>        =E2=9C=85 Boot test
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9D=8C xfstests - ext4
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9D=8C IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - filesystem fio test
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - queue scheduler test
>        =F0=9F=9A=A7 =E2=9C=85 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9C=85 Storage: swraid mdadm raid_module test
>=20
>   ppc64le:
>     Host 1: https://beaker.engineering.redhat.com/recipes/9115549
>        =E2=9C=85 Boot test
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9D=8C xfstests - ext4
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - filesystem fio test
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - queue scheduler test
>        =F0=9F=9A=A7 =E2=9C=85 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9C=85 Storage: swraid mdadm raid_module test
>=20
>     Host 2: https://beaker.engineering.redhat.com/recipes/9115548
>        =E2=9C=85 Boot test
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory: fork_mem
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =E2=9C=85 pciutils: update pci ids test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>=20
>   s390x:
>     Host 1: https://beaker.engineering.redhat.com/recipes/9115547
>        =E2=9C=85 Boot test
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>        =F0=9F=9A=A7 =E2=9D=8C Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9C=85 Storage: swraid mdadm raid_module test
>=20
>     Host 2: https://beaker.engineering.redhat.com/recipes/9115546
>        =E2=9C=85 Boot test
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory: fork_mem
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - transport
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>=20
>   x86_64:
>     Host 1: https://beaker.engineering.redhat.com/recipes/9115543
>        =E2=9C=85 Boot test
>        =E2=9C=85 ACPI table test
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory: fork_mem
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =F0=9F=92=A5 Networking socket: fuzz
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - transp=
ort
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: update pci ids test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Firmware test suite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basi=
c netfilter test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite te=
st
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 kdump - kexec_boot
>=20
>     Host 2: https://beaker.engineering.redhat.com/recipes/9115545
>=20
>        =E2=9A=A1 Internal infrastructure issues prevented one or more tes=
ts (marked
>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectur=
e.
>        This is not the fault of the kernel that was tested.
>=20
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Frequency Driver Tes=
t
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Idle Test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupowe=
r/sanity test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesyste=
m fio test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue sch=
eduler test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm rai=
d_module test
>=20
>     Host 3: https://beaker.engineering.redhat.com/recipes/9115544
>        =E2=9C=85 Boot test
>        =F0=9F=9A=A7 =E2=9C=85 kdump - sysrq-c
>        =F0=9F=9A=A7 =E2=9C=85 kdump - file-load
>=20
>     Host 4: https://beaker.engineering.redhat.com/recipes/9115908
>=20
>        =E2=9A=A1 Internal infrastructure issues prevented one or more tes=
ts (marked
>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectur=
e.
>        This is not the fault of the kernel that was tested.
>=20
>        =E2=9C=85 Boot test
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Frequency Driver Tes=
t
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Idle Test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupowe=
r/sanity test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesyste=
m fio test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue sch=
eduler test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm rai=
d_module test
>=20
>     Host 5: https://beaker.engineering.redhat.com/recipes/9116655
>        =E2=9C=85 Boot test
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9D=8C CPU: Frequency Driver Test
>        =F0=9F=9A=A7 =E2=9C=85 CPU: Idle Test
>        =F0=9F=9A=A7 =E2=9D=8C xfstests - ext4
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - xfs
>        =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
>        =F0=9F=9A=A7 =E2=9D=8C IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - filesystem fio test
>        =F0=9F=9A=A7 =E2=9C=85 Storage block - queue scheduler test
>        =F0=9F=9A=A7 =E2=9C=85 Storage nvme - tcp
>        =F0=9F=9A=A7 =E2=9C=85 Storage: swraid mdadm raid_module test
>=20
>   Test sources: https://gitlab.com/cki-project/kernel-tests
>     =F0=9F=92=9A Pull requests are welcome for new tests or improvements =
to existing
>     tests!
>=20
> Aborted tests
> -------------
> Tests that didn't complete running successfully are marked with =E2=9A=A1=
=E2=9A=A1=E2=9A=A1.
> If this was caused by an infrastructure issue, we try to mark that
> explicitly in the report.
>=20
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests
> are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or
> are
> being fixed.
>=20
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven'=
t
> finished running yet are marked with =E2=8F=B1.
>=20
>=20

