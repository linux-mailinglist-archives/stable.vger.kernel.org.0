Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEF0F2C10
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfKGKWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:22:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726866AbfKGKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 05:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573122170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uZNtSb5aGnwZhWBtofOFA98+k2dd2G9JlyZxf0g2Ts=;
        b=P/KkOQTv1SIPkxMRCKnxVDEZcsq8MZkI+Mr11SVlnRdwZUrBPa4Ikx+nV2xIWSsfODfiud
        9ouiH024qKQfi5Ds21BWDCGiMhPdKXFu0uv+0l2qOuDGmhCogmG475vzjoxXEAZ8ega82K
        jEcy/aWeTNFnwExzZlvT0O0QMAoA1b8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-c9Y52Pb5P0-qxgldMH-lOw-1; Thu, 07 Nov 2019 05:22:48 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CB68017DD
        for <stable@vger.kernel.org>; Thu,  7 Nov 2019 10:22:48 +0000 (UTC)
Received: from dhcp-12-139.nay.redhat.com (dhcp-12-139.nay.redhat.com [10.66.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4155E5D6B7;
        Thu,  7 Nov 2019 10:22:39 +0000 (UTC)
Date:   Thu, 7 Nov 2019 18:22:35 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Jianwen Ji <jiji@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191107102235.GR16190@dhcp-12-139.nay.redhat.com>
References: <cki.7C65793389.02658IUR51@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cki.7C65793389.02658IUR51@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: c9Y52Pb5P0-qxgldMH-lOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 08:56:04PM -0000, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a patchset that was proposed for merging into t=
his
> kernel tree. The patches were applied to:
>=20
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux.git
>             Commit: 37b4d0c37c0b - Linux 5.3.9
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
>   https://artifacts.cki-project.org/pipelines/268208
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C Networking socket: fuzz

From the call trace this doesn't like a network issue...

[10171.661351] NET: Registered protocol family 5=20
[10171.935836] NET: Unregistered protocol family 5=20
[10172.056312] NET: Registered protocol family 5=20
[10172.086044] BUG: Unable to handle kernel data access at 0x29f54ed8fb2aa7=
57=20
[10172.086068] Faulting instruction address: 0xc0000000006d7a28=20
[10172.086082] Oops: Kernel access of bad area, sig: 11 [#1]=20
[10172.086104] LE PAGE_SIZE=3D64K MMU=3DRadix MMU=3DHash SMP NR_CPUS=3D1024=
 NUMA PowerNV=20
[10172.086119] Modules linked in: appletalk(+) netrom bluetooth ecdh_generi=
c ecc atm smc ib_core mpls_router ip_tunnel af_key nfc rfkill pppoe pppox p=
pp_generic slhc psnap llc kcm ieee802154_socket ieee802154 fcrypt pcbc rxrp=
c rose ax25 can mlx4_en mlx4_core nls_utf8 isofs kvm_hv kvm minix binfmt_mi=
sc nfsv3 nfs_acl nfs lockd grace fscache sctp rds brd vfat fat btrfs xor zs=
td_compress raid6_pq zstd_decompress loop tun ip6table_nat ip6_tables xt_co=
nntrack iptable_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_connt=
rack nf_defrag_ipv6 nf_defrag_ipv4 overlay fuse sunrpc bnx2x vmx_crypto at2=
4 mdio regmap_i2c tg3 crct10dif_vpmsum ipmi_powernv ipmi_devintf ofpart pow=
ernv_flash opal_prd mtd rtc_opal i2c_opal ipmi_msghandler ip_tables xfs lib=
crc32c ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper crc32c_vpmsum sy=
scopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirk=
s i2c_core [last unloaded: dummy]=20
[10172.086377] CPU: 124 PID: 1324763 Comm: kworker/u258:0 Not tainted 5.3.9=
-fd272dc.cki #1=20
[10172.086420] Workqueue: writeback wb_workfn (flush-253:0)=20
[10172.086442] NIP:  c0000000006d7a28 LR: c0000000006d7f00 CTR: c0000000006=
d38a0=20
[10172.086477] REGS: c000201ac2807380 TRAP: 0380   Not tainted  (5.3.9-fd27=
2dc.cki)=20
[10172.086501] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 440082=
48  XER: 00000000=20
[10172.086539] CFAR: c0000000006d7a70 IRQMASK: 1 =20
[10172.086539] GPR00: c0000000006d7f00 c000201ac2807610 c000000001771f00 c0=
00001fe9a5d800 =20
[10172.086539] GPR04: c000001fe9314e68 0000000000000000 0000000000000000 00=
00000000000270 =20
[10172.086539] GPR08: c000001fea935800 c000001fe9a5d898 29f54ed8fb2aa71f c0=
00201cae364cf8 =20
[10172.086539] GPR12: 0000000000000040 c000201fff67c400 c00000000015adc8 c0=
00001fc5177248 =20
[10172.086539] GPR16: 0000000000000000 0000000000000000 0000000f00000204 00=
2d444552414853 =20
[10172.086539] GPR20: c000000000fe9618 c000201c57118580 0000000000000000 c0=
00201cac3bdb70 =20
[10172.086539] GPR24: 0000000000060800 c000001fc7a71800 c000201c76a64c00 c0=
00201c98f63200 =20
[10172.086539] GPR28: 0000000000001aee c000001fc7a71800 c000201c978f67c0 c0=
00001fc7a71800 =20
[10172.086782] NIP [c0000000006d7a28] bfq_find_set_group+0xa8/0x140=20
[10172.086816] LR [c0000000006d7f00] bfq_bic_update_cgroup+0x130/0x2f0=20
[10172.086849] Call Trace:=20
[10172.086868] [c000201ac2807610] [c0000000006d79e0] bfq_find_set_group+0x6=
0/0x140 (unreliable)=20
[10172.086906] [c000201ac2807640] [c0000000006d7f00] bfq_bic_update_cgroup+=
0x130/0x2f0=20
[10172.086942] [c000201ac2807710] [c0000000006d2bdc] bfq_init_rq+0x11c/0xb3=
0=20
[10172.086976] [c000201ac28077e0] [c0000000006d3a38] bfq_insert_requests+0x=
198/0x12e0=20
[10172.087013] [c000201ac2807940] [c0000000006a5274] blk_mq_sched_insert_re=
quests+0xb4/0x1d0=20
[10172.087061] [c000201ac2807990] [c00000000069e720] blk_mq_flush_plug_list=
+0x260/0x330=20
[10172.087097] [c000201ac2807a20] [c00000000068ed58] blk_flush_plug_list+0x=
168/0x190=20
[10172.087122] [c000201ac2807a90] [c00000000068edb4] blk_finish_plug+0x34/0=
x50=20
[10172.087156] [c000201ac2807ab0] [c000000000483400] wb_writeback+0x200/0x4=
70=20
[10172.087179] [c000201ac2807b70] [c000000000485228] wb_workfn+0x4f8/0x5c0=
=20
[10172.087203] [c000201ac2807c80] [c000000000151f6c] process_one_work+0x26c=
/0x510=20
[10172.087217] [c000201ac2807d20] [c000000000152298] worker_thread+0x88/0x5=
c0=20
[10172.087231] [c000201ac2807db0] [c00000000015af14] kthread+0x154/0x1a0=20
[10172.087266] [c000201ac2807e20] [c00000000000bed8] ret_from_kernel_thread=
+0x5c/0x64=20
[10172.087300] Instruction dump:=20
[10172.087319] e8e9489a 38e7004c 78e71f24 7c63382a 2c230000 418200a0 352300=
98 40820048 =20
[10172.087347] 48000068 60000000 419e0008 e949ff68 <e94a0038> 2c2a0000 4182=
0060 7d4a382a =20
[10172.087397] ---[ end trace ce87155ebd82719c ]---=20

[10172.239286] =20
[10232.098595] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:=20
[10232.098617] rcu:  124-...0: (0 ticks this GP) idle=3D45e/1/0x40000000000=
00000 softirq=3D65648/65648 fqs=3D3000 =20
[10232.098636]  (detected by 102, t=3D6002 jiffies, g=3D822369, q=3D4669)=
=20
[10232.098651] Sending NMI from CPU 102 to CPUs 124:=20
[10237.669520] CPU 124 didn't respond to backtrace IPI, inspecting paca.=20
[10237.669537] irq_soft_mask: 0x01 in_mce: 0 in_nmi: 0 current: 1324763 (kw=
orker/u258:0)=20
[10237.669550] Back trace of paca->saved_r1 (0xc000201ac2806fe0) (possibly =
stale):=20
[10237.669572] Call Trace:=20
[10237.669579] [c000201ac2806fe0] [c000201ac2807080] 0xc000201ac2807080 (un=
reliable)=20
[10237.669593] [c000201ac2807020] [c0000000006d28b8] bfq_exit_icq_bfqq+0x68=
/0x220=20
[10237.669627] [c000201ac28070d0] [c0000000006d2a9c] bfq_exit_icq+0x2c/0x50=
=20
[10237.669639] [c000201ac2807100] [c000000000693734] put_io_context_active+=
0xc4/0x120=20
[10237.669674] [c000201ac2807140] [c00000000012ebf4] do_exit+0x764/0xe10=20
[10237.669685] [c000201ac2807200] [c00000000002a90c] oops_end+0x16c/0x1a0=
=20
[10237.669697] [c000201ac2807280] [c000000000075738] bad_page_fault+0x118/0=
x1d0=20
[10237.669720] [c000201ac28072f0] [c00000000007f218] do_bad_slb_fault+0x88/=
0xa0=20
[10237.669744] [c000201ac2807310] [c000000000008904] data_access_slb_common=
+0x174/0x180=20
[10237.669779] --- interrupt: 380 at bfq_find_set_group+0xa8/0x140=20
[10237.669779]     LR =3D bfq_bic_update_cgroup+0x130/0x2f0=20
[10237.669827] [c000201ac2807610] [c0000000006d79e0] bfq_find_set_group+0x6=
0/0x140 (unreliable)=20
[10237.669864] [c000201ac2807640] [c0000000006d7f00] bfq_bic_update_cgroup+=
0x130/0x2f0=20
[10237.669924] [c000201ac2807710] [c0000000006d2bdc] bfq_init_rq+0x11c/0xb3=
0=20
[10237.669946] [c000201ac28077e0] [c0000000006d3a38] bfq_insert_requests+0x=
198/0x12e0=20
[10237.669981] [c000201ac2807940] [c0000000006a5274] blk_mq_sched_insert_re=
quests+0xb4/0x1d0=20
[10237.670016] [c000201ac2807990] [c00000000069e720] blk_mq_flush_plug_list=
+0x260/0x330=20
[10237.670051] [c000201ac2807a20] [c00000000068ed58] blk_flush_plug_list+0x=
168/0x190=20
[10237.670086] [c000201ac2807a90] [c00000000068edb4] blk_finish_plug+0x34/0=
x50=20
[10237.670120] [c000201ac2807ab0] [c000000000483400] wb_writeback+0x200/0x4=
70=20
[10237.670153] [c000201ac2807b70] [c000000000485228] wb_workfn+0x4f8/0x5c0=
=20
[10237.670187] [c000201ac2807c80] [c000000000151f6c] process_one_work+0x26c=
/0x510=20
[10237.670222] [c000201ac2807d20] [c000000000152298] worker_thread+0x88/0x5=
c0=20
[10237.670245] [c000201ac2807db0] [c00000000015af14] kthread+0x154/0x1a0=20
[10237.670278] [c000201ac2807e20] [c00000000000bed8] ret_from_kernel_thread=
+0x5c/0x64=20
[10237.670313] watchdog: CPU 19 self-detected hard LOCKUP @ _raw_spin_lock_=
irq+0x60/0x100=20
[10237.670314] watchdog: CPU 19 TB:5287683334232, last heartbeat TB:5281606=
533730 (11868ms ago)=20
[10237.670314] Modules linked in: appletalk(+) netrom bluetooth ecdh_generi=
c ecc atm smc ib_core mpls_router ip_tunnel af_key nfc rfkill pppoe pppox p=
pp_generic slhc psnap llc kcm ieee802154_socket ieee802154 fcrypt pcbc rxrp=
c rose ax25 can mlx4_en mlx4_core nls_utf8 isofs kvm_hv kvm minix binfmt_mi=
sc nfsv3 nfs_acl nfs lockd grace fscache sctp rds brd vfat fat btrfs xor zs=
td_compress raid6_pq zstd_decompress loop tun ip6table_nat ip6_tables xt_co=
nntrack iptable_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_connt=
rack nf_defrag_ipv6 nf_defrag_ipv4 overlay fuse sunrpc bnx2x vmx_crypto at2=
4 mdio regmap_i2c tg3 crct10dif_vpmsum ipmi_powernv ipmi_devintf ofpart pow=
ernv_flash opal_prd mtd rtc_opal i2c_opal ipmi_msghandler ip_tables xfs lib=
crc32c ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper crc32c_vpmsum sy=
scopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirk=
s i2c_core [last unloaded: dummy]=20
[10237.670339] CPU: 19 PID: 1213 Comm: xfsaild/dm-0 Tainted: G      D      =
     5.3.9-fd272dc.cki #1=20
[10237.670340] NIP:  c000000000d1ea70 LR: c0000000006ce1e8 CTR: c0000000006=
ce140=20
[10237.670341] REGS: c000001fffcd3d70 TRAP: 0900   Tainted: G      D       =
     (5.3.9-fd272dc.cki)=20
[10237.670341] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 440024=
22  XER: 20040000=20
[10237.670344] CFAR: c000000000d1ea98 IRQMASK: 1 =20
[10237.670345] GPR00: c0000000006ce1e8 c000001fe9d8b7b0 c000000001771f00 c0=
00001fc7a71bf0 =20
[10237.670346] GPR04: 0000000000000000 0000000000000001 c000001fe9d8b910 c0=
00001fea934000 =20
[10237.670348] GPR08: 0000000000000000 000000008000007c 0000000080000013 c0=
00000001799cf8 =20
[10237.670349] GPR12: c0000000006ce140 c000001ffffe9a00 0000000000004000 00=
00000000000000 =20
[10237.670351] GPR16: c000000001a385a8 0000000000000000 0000000000001001 00=
00000000010000 =20
[10237.670353] GPR20: 0000000000000000 0000000000000000 000000000078c9e0 00=
0000000000c000 =20
[10237.670354] GPR24: 0000000000008000 c000001fe9314ef4 c000001fc7a71bf0 c0=
00001fe9314e68 =20
[10237.670356] GPR28: 0000000000000000 c000001f6d1f2940 c000001fc8d679f0 c0=
0000000179bd00 =20
[10237.670358] NIP [c000000000d1ea70] _raw_spin_lock_irq+0x60/0x100=20
[10237.670358] LR [c0000000006ce1e8] bfq_bio_merge+0xa8/0x1f0=20
[10237.670358] Call Trace:=20
[10237.670359] [c000001fe9d8b7b0] [c000001fe9d8b7f0] 0xc000001fe9d8b7f0 (un=
reliable)=20
[10237.670360] [c000001fe9d8b7f0] [c0000000006ce1dc] bfq_bio_merge+0x9c/0x1=
f0=20
[10237.670361] [c000001fe9d8b870] [c0000000006a4de8] __blk_mq_sched_bio_mer=
ge+0xa8/0x1d0=20
[10237.670361] [c000001fe9d8b8d0] [c00000000069da58] blk_mq_make_request+0x=
e8/0x780=20
[10237.670362] [c000001fe9d8b980] [c00000000068d1ac] generic_make_request+0=
xdc/0x380=20
[10237.670363] [c000001fe9d8ba00] [c00000000068d4a8] submit_bio+0x58/0x250=
=20
[10237.670364] [c000001fe9d8bac0] [c00800000d7f35a8] _xfs_buf_ioapply+0x3e0=
/0x4b0 [xfs]=20
[10237.670364] [c000001fe9d8bbf0] [c00800000d7f37b0] __xfs_buf_submit+0xc8/=
0x2d0 [xfs]=20
[10237.670365] [c000001fe9d8bc30] [c00800000d7f4020] xfs_buf_delwri_submit_=
buffers+0x138/0x300 [xfs]=20
[10237.670366] [c000001fe9d8bcd0] [c00800000d843090] xfsaild+0x2a8/0x980 [x=
fs]=20
[10237.670367] [c000001fe9d8bdb0] [c00000000015af14] kthread+0x154/0x1a0=20
[10237.670367] [c000001fe9d8be20] [c00000000000bed8] ret_from_kernel_thread=
+0x5c/0x64=20
[10237.670368] Instruction dump:=20
[10237.670369] 7c2004ac 2c290000 40820018 a12d1180 39290001 b12d1180 4e8000=
20 60000000 =20
[10237.670371] fbe1fff8 f821ffc1 3fe20003 3bff9e00 <7c210b78> e93f0000 7529=
0010 41820014 =20
[10237.670392] watchdog: CPU 56 self-detected hard LOCKUP @ _raw_spin_lock_=
irq+0x64/0x100=20

