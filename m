Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095EE2E65DB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389569AbgL1QFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:05:42 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:35694 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389092AbgL1N1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 08:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609162225; x=1640698225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ftlPI5G3/HUaSm/+09ChGRzqsUVJGEtqR0NhmlfXAlU=;
  b=ZOrohLmVoVs0ECg02dyuCDfZdCfTBBbbH1OhviNzrA1P85HZeCDtWEwm
   fd5J+cDrlw7Xj2yQ/PyquH9VBfZmjJvqFCJND/xfrHULAr4voNvonHR1F
   ikFFrUkJ45GLH/g4ydsiTHPZG7vMSoyjtyv7poHE8Jc9Xqz4EKoeArGXB
   sw57baPdAkVzusI1m/dRkm21IzQC72MfstD3QLVk85cLrdHlsLdVRNE5L
   72B+gp59Yol2RoHd6I5Cgqt0qqbDUl0KMqdXBP+qy2ZWAGHLIc8q+8cOD
   dXWsp59XHXC8KrV7zaQKYahO9JPFXHzo5Se0I6gD3rvwwJUedmxzKmt+2
   A==;
IronPort-SDR: g6+AIpzAnoVwOILr+rXzeBN87jCUgTKbdofXMCaEXpvHf6t6N4Ky8lZL7nyyYpG8tijXs/XcRY
 Q8fve/oUBof3PY7XA7qkVnj27GpXt7ZdG3d9l6yPFNhCwH631dnnxUsBHl6U6uYCatBqCGi/zM
 Idw7lA9aippETG2N5dHl2zgckbbpfui0KPsFqz4J1oRdaQfeyE5UyFFRJpi7NaKB+0msblDGwN
 Y1o3LBQqleksZqanizk38seOdHmsl/fN8BwxZ/gpaf40YpoFWEnAatzfhXsTyrqm+q8feW45jt
 Tyo=
X-IronPort-AV: E=Sophos;i="5.78,455,1599494400"; 
   d="scan'208";a="259988267"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 28 Dec 2020 21:28:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1Cq9nx7qB+QTQrdGWQSsAT8Y6JgNU3rvou+Z3H77tFEsA9MmqI9QovgrCZQVDDBpvJuGykhIDZcILi7Kae5xPlwoYGu8j76euxUxSKIb0AOhZqEyNKksdJJiA21KMMg/eoMEs775pIIMqUnw2cG2d2hR+SEFADPnFHMy7emAqFJIoF+ew3+b6m1d+SkIS9K7if68H2DUsebofGa1LSDTivXv5H68o7BNDO9fftJiysIIuXSKZOw7PlLnMm1zhP5QqXu/XVfsLH/dL43lR4OW8ZWcpO2fcqWuizfmBGfpPKDZRvWcJu3HIcK7Vg7pLIWkYuQKgZQ0MIA3G5WVkltLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP8A3JwJAInjgb1RinXtXuIL+o444MrRK+xSMy2VeiY=;
 b=Fiv9JXIOekeTIDAJ2w7cer11+MGFkPN7hQK5jmgLe3yCUlAYSlzRmoRPmCEF8ZP3JqdBcaKzKW+m9bjs2DUlraNGVeVFczZcdMXQFdcfbZQ3Fka7AYK7tSl7hArEFz0V29sWy0LuYnKdQ5eP+6mLM6eNiVdpeIMM0Cc9ERywu8kpsRXxuPlWgjClCIqM21UpIWQhl9ivdjwr67QeyrFqrhm+f1hCzbnHPkYyXV8jib1tcKZN5WT2Up5FN9nym5kp3aQ0DDfGV8L5w+Ne+U0GEvn0LLNgM75eTMSe49LBroxBCXlwr7Eoir9lVhPVoQn4l6n1DbWLB7TMbofZ5smHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP8A3JwJAInjgb1RinXtXuIL+o444MrRK+xSMy2VeiY=;
 b=zu3joiX7GDxN36lE0nkceYQ6iOEBJHa/uK04R13y7NP1gJEzvhrqeBdNUSiotAhvNwgOq5WFVON5pDZnBx0KzRddgrG6NC2LOmagnrFU03kOWNil7nZIOPtLw/HkvM/8SUaZ85v51Dqtpd4SRZ7VTLJZqzmmKNs/5HTG9Qr73vg=
Received: from BYAPR04MB3800.namprd04.prod.outlook.com (52.135.214.148) by
 BYAPR04MB5734.namprd04.prod.outlook.com (20.179.57.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.29; Mon, 28 Dec 2020 13:25:52 +0000
Received: from BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::c8dc:d967:993c:f009]) by BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::c8dc:d967:993c:f009%5]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 13:25:45 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
CC:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 1/1] kasan: fix memory leak of kasan quarantine
Thread-Topic: [PATCH v2 1/1] kasan: fix memory leak of kasan quarantine
Thread-Index: AQHW1G9W95n02sH0LEqBxChzRCKGrqoMkQQA
Date:   Mon, 28 Dec 2020 13:25:45 +0000
Message-ID: <20201228132544.kfwha2gtjmfy3jhc@shindev.dhcp.fujisawa.hgst.com>
References: <1608207487-30537-1-git-send-email-Kuan-Ying.Lee@mediatek.com>
 <1608207487-30537-2-git-send-email-Kuan-Ying.Lee@mediatek.com>
In-Reply-To: <1608207487-30537-2-git-send-email-Kuan-Ying.Lee@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd1d83cc-9c65-4759-8ef2-08d8ab341555
x-ms-traffictypediagnostic: BYAPR04MB5734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5734E476BE3DDBA6F737ED6AEDD90@BYAPR04MB5734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kk3czO9DHnTQA8mKvm2Q36G7mM7N1Sr40b2DekX30tgTRCtxKzgvjAc0lGVxJRwvOVV0u3xbcXJofRyMDiO38swTkIUrIzoHfciV8e/7iVHbsuMqWJkUOYXaCmYMDLOTmG5rbngD2GhIXyJSczRf7DWs1oMJ/92O/dW0RclSfSb5ymWHcGcxjEjiVxvEKJwvdEN1oot9RF24z2ZM+zQixbnQ8Y4C98wtCoc3EfaIYXxZ0icBqsOosHBtjopghmKptZzlAheovxReUZr5npNG5+cUWK9x+kEnmdxJGkLwhvo3smdp56f6DgkqLozexH1VA1V00VLzk/yRglcAvNaGr5etN7z+ymXQKDPi8BH/4t0DvEw0MndzTuNeXIGpm0Cl8bTEzzri1TbAUepOsFBCLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB3800.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(6486002)(8676002)(9686003)(2906002)(5660300002)(1076003)(86362001)(7416002)(76116006)(478600001)(6916009)(66556008)(54906003)(4326008)(64756008)(6506007)(6512007)(91956017)(71200400001)(8936002)(44832011)(66446008)(186003)(26005)(83380400001)(66946007)(316002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4LQECd+9kYZ8HJfG8JDAa5BB+9mXLW+fw2mL2b3GX4vur2y301I4buii681+?=
 =?us-ascii?Q?k2dtmxysE8da0xPuG8dhxx9dWNOsAonBbUU1tQOwY18zO3ryaP2VWCJX1XaP?=
 =?us-ascii?Q?X07d66evZ6Q3njRIHKzoUjMQusO/+uzv1LloemshdcRyYa1vxUpXrRykXdCm?=
 =?us-ascii?Q?rArFkmoVYev1F67a9yRsN3gid2d5XMlXfTyqgJfQRxt41QS4h0+zunUuMxV7?=
 =?us-ascii?Q?HQ5U/SfjsVb5x4uFM35LSqwlzg2kHCGeiV0gtdFeowWs3mP4Jm/Tbnx6Ouue?=
 =?us-ascii?Q?OVvy23DG+FTSb3BEV1oIOoDeKmQCs00RVpsBw4WPL/ygzu09Qnppv3Zi9AuP?=
 =?us-ascii?Q?aplxJCxM61f5IN0h8NfjOblnjsDgvjX2z+64YA5vyHKgvosVvFMddmh0IXiw?=
 =?us-ascii?Q?k+mTm68zmt9h+fKWPKJkCKybFPcUDKj8jGyNBg4lRhzUcijE2MWLWvyojGb2?=
 =?us-ascii?Q?bBvcFnxziKASfkhlVVMoOLQvkMSaRI1Bddz25Bv1LXej1TX0Rm3X4j7y8AUf?=
 =?us-ascii?Q?bT+lMGMv92oCZwk7KsVPKIsaBb2RC32Ww8sut31ZuBOu9do18se6Yqn81tvm?=
 =?us-ascii?Q?0SzGznbgUFcDkXXtObq97Y1l6yZtseuS+w61RTitPPrsOftbTyqttnKHwntE?=
 =?us-ascii?Q?Fo5Mafu886A7DYd3KftFjdT1HfLN6ONi6ZWluThnysQmHk0+6/HwuaXTDR9v?=
 =?us-ascii?Q?03Um8KdhfVjDNYDT+UaFDBbJnBLPP/IdiV+Hk+EEkYNEC/zxjhREqU6gGRf7?=
 =?us-ascii?Q?C1w2luimxtcOFCJyzAMtoWeAU3KvUrDYRQZwfnIC9w32t1w1zcvmr/F+/wNO?=
 =?us-ascii?Q?8fll952vUJ2xTcdLYw6TAXnxptKu6L7Wcbff2OTIY4NRCdHQlsPvPgtXZkJZ?=
 =?us-ascii?Q?Hy+aB3kq9508SNZKwu5eeuOMr5/O81r2CXcV+TifgsooGl4IoQNpJvTZUHAZ?=
 =?us-ascii?Q?wDdnThFB/L9F9P+wgqktUdKRhdK8i4QAtyXN9h31yBRh2hrrxG2mPzfokOTr?=
 =?us-ascii?Q?b6Jo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <710A060DF92D4C46A2E0529A47E5C366@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB3800.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1d83cc-9c65-4759-8ef2-08d8ab341555
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2020 13:25:45.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aOYtAfbfSPIfSCoVHoDtbAiTpOZ8k5QmuJU3/UunOZ3xl5wI2fz1PmaQq1ZFjP8cW973AMmeKhXdBu7PwtqgYqNgo9CgRbX54+u3emh9HI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5734
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Dec 17, 2020 / 20:18, Kuan-Ying Lee wrote:
> When cpu is going offline, set q->offline as true
> and interrupt happened. The interrupt may call the
> quarantine_put. But quarantine_put do not free the
> the object. The object will cause memory leak.
>=20
> Add qlink_free() to free the object.
>=20
> Fixes: 6c82d45c7f03 (kasan: fix object remaining in offline per-cpu quara=
ntine)
> Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: <stable@vger.kernel.org>    [5.10-]
> ---
>  mm/kasan/quarantine.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
> index 0e3f8494628f..cac7c617df72 100644
> --- a/mm/kasan/quarantine.c
> +++ b/mm/kasan/quarantine.c
> @@ -191,6 +191,7 @@ void quarantine_put(struct kasan_free_meta *info, str=
uct kmem_cache *cache)
> =20
>  	q =3D this_cpu_ptr(&cpu_quarantine);
>  	if (q->offline) {
> +		qlink_free(&info->quarantine_link, cache);
>  		local_irq_restore(flags);
>  		return;
>  	}

I ran blktests with kernels v5.10.0 and v5.10.3 enabling KASAN, and observe=
d a
BUG message [1]. The BUG can be recreated with a test case which hotplugs C=
PUs
during I/O to dm-linear device. The stack trace in the message indicates me=
mory
leak was detected when slab of dm-linear bio set was destroyed.

I bisected and found the commit 6c82d45c7f03 ("kasan: fix object remaining =
in
offline per-cpu quarantine") triggers the BUG message. I also tried this fi=
x
patch by Kuan-Ying and observed that it avoids the BUG message. I suppose t=
he
fix is required for v5.10.x. Confirmation by kasan maintainers will be
appreciated.

I took following steps to recreate the BUG message:

1. Create dm-linear device on top of HDD (dmsetup create).
2. Run blktests' test case block/008 using the dm-linear device.
3. Remove the dm-linear device (dmsetup remove)

When I repeat the steps, the BUG message is often observed at the step 3.

I repeated the steps with v5.11-rc1 also, and did not observe the BUG. With
v5.11-rc1, quarantine_put() returns bool. Then I think the fix patch is not
required for v5.11, probably.

Wish this report helps for the fix.

[1]

[  151.201998] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  151.212580] BUG bio-3 (Not tainted): Objects remaining in bio-3 on __kme=
m_cache_shutdown()
[  151.222321] ------------------------------------------------------------=
-----------------

[  151.234933] Disabling lock debugging due to kernel taint
[  151.241634] INFO: Slab 0x0000000010690f30 objects=3D36 used=3D3 fp=3D0x0=
0000000e7351615 flags=3D0x17ffffc0010200
[  151.252558] CPU: 6 PID: 1996 Comm: dmsetup Tainted: G    B             5=
.10.3 #21
[  151.261520] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 3.0 04/24/=
2015
[  151.270070] Call Trace:
[  151.274029]  dump_stack+0x9a/0xcc
[  151.278844]  slab_err+0xb7/0xdc
[  151.283505]  ? do_raw_spin_lock+0x115/0x240
[  151.289220]  ? rwlock_bug.part.0+0x90/0x90
[  151.294833]  __kmem_cache_shutdown.cold+0x36/0x19f
[  151.301182]  kmem_cache_destroy+0x5d/0x110
[  151.306822]  bio_put_slab+0xd3/0x180
[  151.311952]  bioset_exit+0xa5/0x100
[  151.316989]  cleanup_mapped_device+0x5e/0x310
[  151.322886]  free_dev+0xb8/0x210
[  151.327665]  __dm_destroy+0x2e0/0x470
[  151.332872]  ? dm_blk_report_zones+0x2b0/0x2b0
[  151.338877]  ? _raw_spin_unlock+0x1f/0x30
[  151.344481]  dev_remove+0x223/0x2f0
[  151.349565]  ctl_ioctl+0x384/0x970
[  151.354572]  ? remove_all+0x90/0x90
[  151.359677]  ? find_held_lock+0x2c/0x110
[  151.365211]  ? free_params+0x30/0x30
[  151.370401]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[  151.377181]  dm_ctl_ioctl+0xa/0x10
[  151.382224]  __x64_sys_ioctl+0x127/0x190
[  151.387800]  do_syscall_64+0x33/0x40
[  151.393017]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  151.399713] RIP: 0033:0x7f6fe944338b
[  151.404947] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff =
ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd ba 0c 00 f7 d8 64 89 01 48
[  151.426499] RSP: 002b:00007ffd00632f08 EFLAGS: 00000202 ORIG_RAX: 000000=
0000000010
[  151.435871] RAX: ffffffffffffffda RBX: 00007f6fe9523f30 RCX: 00007f6fe94=
4338b
[  151.444829] RDX: 0000561f9b938440 RSI: 00000000c138fd04 RDI: 00000000000=
00003
[  151.453812] RBP: 00007f6fe9560494 R08: 00007f6fe9562de0 R09: 00007ffd006=
32d70
[  151.462808] R10: 0000000000000000 R11: 0000000000000202 R12: 0000561f9b9=
36c40
[  151.471820] R13: 0000561f9b938470 R14: 0000561f9b9384f0 R15: 0000561f9b9=
38440
[  151.480836] INFO: Object 0x00000000f6e5c796 @offset=3D5824
[  151.488063] INFO: Object 0x00000000a14f36d2 @offset=3D6720
[  151.495274] INFO: Object 0x000000005bfef957 @offset=3D9856

--=20
Best Regards,
Shin'ichiro Kawasaki=
