Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB720DCD2C
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 19:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505626AbfJRR6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 13:58:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505601AbfJRR6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 13:58:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IGwcqg018561;
        Fri, 18 Oct 2019 09:58:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zwGtV2AIM2nK8eNn5DTM/iO2raHgtn3rF69mtVV4byc=;
 b=KiY8sJBlzeEZcJhTYxPnvv/S/ob4q6yz24XcZJXO7tlN/gyVq2kE9bM4dO1ECrEGlj6R
 Gv95xGF/iUilRNRTH7zvXlGJbBXm8FJn1LYuiLV88ZL7CRA1HOUbUlzDTMpk9Wxr4oP7
 Gj9aO8Vlsyo2xpvGLJV3gCTmmY08henC8fA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqeuqgu1e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 09:58:41 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 09:58:37 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 09:58:37 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:58:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQWT++soDYz3W/p05YS0OG4l2z7Vj1qZRedLOIA3FUlhsMvNaxdSCM/AdkIhFfNk1P3NXZ70z4x6+DTCT0LKDxYx0JS4ryL9qzbGM3I3U/qPad/KPkmJJO8Hr47UdEJep6fpD8D+8cRUX9vE5vyxovQFJyALtWhnxjRO4nf7Ycr89hqIBQ/uWeTkOx9NuSL4kp3oCS2fRnVGm/a37icr3m783kn6+sHK0ix2kgyLvd8P5tOAqs5LclzuyRJx7LShedKwHsMgSN94FNC6f4cHuAdiB7mjF5GSfaXb8qh5xzgQ2ceUXEDE8GEFUuJLiCwoSJjGRYHMbppmww0ZMWpyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwGtV2AIM2nK8eNn5DTM/iO2raHgtn3rF69mtVV4byc=;
 b=gCyUf7T6dI+lN7RvPicJRoNdGNI7aAj86QhGEOKvwcBkGY8KbeREnUvfY65leSyctEWQXrSbVczaD0riyLjs1jARnHdKWcl10UT9/hKishWNMahdF46lsvC5YreDYcb9FcsCO8/RL4p89iJXaxLRCvl3/qf3WHLBMOc3gEwOLI5iDXbaqhXIE5li3MvC2cP2PabRthhrpZEcvvEm71be2tpjhsH/6D/6C0oKK1khkOTH/JY0demmE+4G6ZuROkif1tuKguWcmXCjRcT1+7BFpri711F1WwItXzeSPcnzGkTvTADKEZnT+Vr9X5Pzws3hddifnrWgJQQf4CZqIVJ7KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwGtV2AIM2nK8eNn5DTM/iO2raHgtn3rF69mtVV4byc=;
 b=WusQvJha6TKzkqrmdk5sZuXuFGlNqaCZ1V9MfbVT7Tba7T6yvaHBVMfWFzC88XhehcrKv3VnyC2QR+LRtS3DjKFLaLXBTwLMqZjdabHMcvXg6xR/KpLFvy/L9TkgFyBsLBM9J7HtT+nTztev9RJ90sflFIQY8fCHiUgFcbfZMsg=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3137.namprd15.prod.outlook.com (20.178.221.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 18 Oct 2019 16:58:36 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0%6]) with mapi id 15.20.2347.023; Fri, 18 Oct 2019
 16:58:36 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com" 
        <syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: memcontrol: fix NULL-ptr deref in percpu stats flush
Thread-Topic: [PATCH] mm: memcontrol: fix NULL-ptr deref in percpu stats flush
Thread-Index: AQHVhdSBTd66mKXKnkOST1gIER/EqqdgnuGA
Date:   Fri, 18 Oct 2019 16:58:36 +0000
Message-ID: <20191018165831.GA6117@tower.DHCP.thefacebook.com>
References: <20191018165231.249872-1-shakeelb@google.com>
In-Reply-To: <20191018165231.249872-1-shakeelb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0046.prod.exchangelabs.com (2603:10b6:300:101::32)
 To BN8PR15MB2626.namprd15.prod.outlook.com (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::4581]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f4e8da3-f96a-4cf4-8cb7-08d753ec6a7c
x-ms-traffictypediagnostic: BN8PR15MB3137:
x-microsoft-antispam-prvs: <BN8PR15MB31376D23905AD65CD30F67EFBE6C0@BN8PR15MB3137.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(66556008)(305945005)(64756008)(66446008)(8936002)(66476007)(486006)(476003)(6436002)(6116002)(256004)(6486002)(46003)(7416002)(6916009)(6246003)(2906002)(6512007)(9686003)(66946007)(14444005)(229853002)(8676002)(81166006)(7736002)(81156014)(478600001)(186003)(5660300002)(1076003)(316002)(14454004)(6506007)(99286004)(4326008)(86362001)(386003)(76176011)(25786009)(52116002)(71190400001)(102836004)(54906003)(33656002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3137;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cA+MkHp73iTrbezOZGovyRpUrua+mG8umYnCOX2ZsUdwA8XSuPYUbYKJLOO10xT0o5BGJ9q14p40i803KH2daFGyByeSF+LaT2B1BIfvecJmsMf8IP+YIwsP4rJ39T3jh8t6tKO+rcajF8OJcg/KuvsV1aBI+KdqEG7qqEDciVwsNJWaumg8NMVZ/hbUgWmxdYUj8wpP+/NA5ELcUUvDc9MleFFEzvGeDJNDnHuY+BgmUW9Yd0s/iHWVyKpj3BygIk58pVdbNI2B6kTKPIHsSBgR7/cxVcfSnBBHfQ3ORoiBMVjjJQutxjkkCEMbFg59OZcQPaU5rVGrRI2fyOK9XKZq8udpelkQ7hvTo1HHB5SLQxtP2EioJ1PYJLPCjfyj1aOMWazFp0jIHUl7zePSbo4+qDjVhe5OGyOO6wAKGTQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63BAE348973C5A46A2584608C2AC3030@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4e8da3-f96a-4cf4-8cb7-08d753ec6a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:58:36.3237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0QsIgDlterK8w9RRY22FjjEKuz5tPOidG3dFRoA/35+p244wFjX+gsdBQuiisnX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3137
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180155
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 09:52:31AM -0700, Shakeel Butt wrote:
> __mem_cgroup_free() can be called on the failure path in
> mem_cgroup_alloc(). However memcg_flush_percpu_vmstats() and
> memcg_flush_percpu_vmevents() which are called from __mem_cgroup_free()
> access the fields of memcg which can potentially be null if called from
> failure path from mem_cgroup_alloc(). Indeed syzbot has reported the
> following crash:
>=20
> 	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003
> 	kasan: CONFIG_KASAN_INLINE enabled
> 	kasan: GPF could be caused by NULL-ptr deref or user memory access
> 	general protection fault: 0000 [#1] PREEMPT SMP KASAN
> 	CPU: 0 PID: 30393 Comm: syz-executor.1 Not tainted 5.4.0-rc2+ #0
> 	Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
> 	RIP: 0010:memcg_flush_percpu_vmstats+0x4ae/0x930 mm/memcontrol.c:3436
> 	Code: 05 41 89 c0 41 0f b6 04 24 41 38 c7 7c 08 84 c0 0f 85 5d 03 00 00 =
44 3b 05 33 d5 12 08 0f 83 e2 00 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 0=
0 0f 85 91 03 00 00 48 8b 85 10 fe ff ff 48 8b b0 90
> 	RSP: 0018:ffff888095c27980 EFLAGS: 00010206
> 	RAX: 0000000000000012 RBX: ffff888095c27b28 RCX: ffffc90008192000
> 	RDX: 0000000000040000 RSI: ffffffff8340fae7 RDI: 0000000000000007
> 	RBP: ffff888095c27be0 R08: 0000000000000000 R09: ffffed1013f0da33
> 	R10: ffffed1013f0da32 R11: ffff88809f86d197 R12: fffffbfff138b760
> 	R13: dffffc0000000000 R14: 0000000000000090 R15: 0000000000000007
> 	FS:  00007f5027170700(0000) GS:ffff8880ae800000(0000) knlGS:000000000000=
0000
> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	CR2: 0000000000710158 CR3: 00000000a7b18000 CR4: 00000000001406f0
> 	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 	DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 	Call Trace:
> 	__mem_cgroup_free+0x1a/0x190 mm/memcontrol.c:5021
> 	mem_cgroup_free mm/memcontrol.c:5033 [inline]
> 	mem_cgroup_css_alloc+0x3a1/0x1ae0 mm/memcontrol.c:5160
> 	css_create kernel/cgroup/cgroup.c:5156 [inline]
> 	cgroup_apply_control_enable+0x44d/0xc40 kernel/cgroup/cgroup.c:3119
> 	cgroup_mkdir+0x899/0x11b0 kernel/cgroup/cgroup.c:5401
> 	kernfs_iop_mkdir+0x14d/0x1d0 fs/kernfs/dir.c:1124
> 	vfs_mkdir+0x42e/0x670 fs/namei.c:3807
> 	do_mkdirat+0x234/0x2a0 fs/namei.c:3830
> 	__do_sys_mkdir fs/namei.c:3846 [inline]
> 	__se_sys_mkdir fs/namei.c:3844 [inline]
> 	__x64_sys_mkdir+0x5c/0x80 fs/namei.c:3844
> 	do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
> 	entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 	RIP: 0033:0x459a59
> 	Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> 	RSP: 002b:00007f502716fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> 	RAX: ffffffffffffffda RBX: 00007f502716fc90 RCX: 0000000000459a59
> 	RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
> 	RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
> 	R10: 0000000000000000 R11: 0000000000000246 R12: 00007f50271706d4
> 	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003
>=20
> Fixing this by moving the flush to mem_cgroup_free as there is no need
> to flush anything if we see failure in mem_cgroup_alloc().
>=20
> Reported-by: syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com
> Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releas=
ing memcg")
> Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasi=
ng memcg")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>=20
> ---
>  mm/memcontrol.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bdac56009a38..13cb4c1e9f2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5014,12 +5014,6 @@ static void __mem_cgroup_free(struct mem_cgroup *m=
emcg)
>  {
>  	int node;
> =20
> -	/*
> -	 * Flush percpu vmstats and vmevents to guarantee the value correctness
> -	 * on parent's and all ancestor levels.
> -	 */
> -	memcg_flush_percpu_vmstats(memcg, false);
> -	memcg_flush_percpu_vmevents(memcg);
>  	for_each_node(node)
>  		free_mem_cgroup_per_node_info(memcg, node);
>  	free_percpu(memcg->vmstats_percpu);
> @@ -5030,6 +5024,12 @@ static void __mem_cgroup_free(struct mem_cgroup *m=
emcg)
>  static void mem_cgroup_free(struct mem_cgroup *memcg)
>  {
>  	memcg_wb_domain_exit(memcg);
> +	/*
> +	 * Flush percpu vmstats and vmevents to guarantee the value correctness
> +	 * on parent's and all ancestor levels.
> +	 */
> +	memcg_flush_percpu_vmstats(memcg, false);
> +	memcg_flush_percpu_vmevents(memcg);
>  	__mem_cgroup_free(memcg);
>  }

Good catch!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you, Shakeel!
