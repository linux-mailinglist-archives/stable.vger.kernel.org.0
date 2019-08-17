Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E119129F
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 21:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfHQTOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 15:14:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQTOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 15:14:54 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7HJElJ5027860;
        Sat, 17 Aug 2019 12:14:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BmfWOtOM9Z0sce9BndRwfp4qcKBuqz+skKkRyA5zrwU=;
 b=pERXp3Rsxpu/jsV5ar6Hu4tr0SiV9zRawFZA7+8Fuz0feBWg7opJfYA8msWFChSCtRDv
 fEkBR8bs/R1Hz2hWEUqCoy69ePWMMBjT9oX7Np49NiLVP4dGItr2IjvIYdcsMzmZABtg
 qIFoRaf0eoxDQql2uiYJSoBPLJ0CJUyvspE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uecw7hp6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 17 Aug 2019 12:14:47 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 17 Aug 2019 12:14:45 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 17 Aug 2019 12:14:45 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 17 Aug 2019 12:14:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKkahBYH5pl8md0ed7MTxDy16ym73MC4YgjdidzFCCM66+D1WF6W+emPmFB2dllNkFHyWlXFgCcb1NJCIqpblyPfdy9MiPV7hSf+L9RRZOKodsGv+bZQR6Hi+D032dyav2/PiloSH8BcKEPer0uAfyR4MnZZ3h6k5GZ94+EOX8nTPoi6tqxb02NhpGg4shXfgXJ3sHGLaz1oAjxlGRMOqhhZM2k0sY6MPcEyBifDk0tqLq3brfN03yZzu7HfONEB/invauEwOt/6I0LR8QeuDIwREca7oJAkzQ65VvX7Jf02ITv9tTyRMjQx+bx2RRAweNc+GPQsZsnwC621J2Vd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmfWOtOM9Z0sce9BndRwfp4qcKBuqz+skKkRyA5zrwU=;
 b=TmlTbz5jDnvEz0xEucQLB1b6+5buUqjqJTjZl/KZkmBXpk2Ocfm+6GFiDjQEZTSsMdCLuSEzMmdGBrRGIF4kC0zAI7wpbfypyOOEG14OpXQf7HZJkC4HOpeKbydVDebQMWfttbM0iSdXI2cT79kRHsnHc9U2M4qOssrw/L6slxBf/RUudjroP8GV+FPQdP2imr07socuUZvXV4s0T3c/rjFGB46CSXUEGGb6GkjGDT6nQlm88K7iS9Ra5rHMnUXkwMhloXfd3f/uGTVafvEWa1z7igtD+FCP2QI6MUw55AG+LLpaRPIL9zn2M91MXBPyAYsORtgGOzf1Bf0CDLnU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmfWOtOM9Z0sce9BndRwfp4qcKBuqz+skKkRyA5zrwU=;
 b=MkF1/ZoK8bIb6KQnxVs8ZQNHYAar84kFYd+5A/UKtDMkggubESCTEFBUjZXAMGTr+K9LOgj/FDLEaf3zycegiRYetlDZw5ob9KzCngwYzLmw2nlCLZZgJmWmgGfiC/IBh9xxLKpACjCF+hDK4yEXBdxhzRT5m1bIR8LJOauoIzU=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB2923.namprd15.prod.outlook.com (20.178.230.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 17 Aug 2019 19:14:25 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e%3]) with mapi id 15.20.2178.018; Sat, 17 Aug 2019
 19:14:24 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
Thread-Topic: [PATCH] Partially revert "mm/memcontrol.c: keep local VM
 counters in sync with the hierarchical ones"
Thread-Index: AQHVVJVnJCTepTfXpE2m8ikuyJkTSKb+sAiAgAEGvYA=
Date:   Sat, 17 Aug 2019 19:14:24 +0000
Message-ID: <20190817191419.GA11125@castle>
References: <20190817004726.2530670-1-guro@fb.com>
 <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
In-Reply-To: <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0051.namprd18.prod.outlook.com
 (2603:10b6:104:2::19) To DM6PR15MB2635.namprd15.prod.outlook.com
 (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::61b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcf307cb-5bf6-414e-9fe1-08d723471d92
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB2923;
x-ms-traffictypediagnostic: DM6PR15MB2923:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB2923EDD56768E89F5B3F42E5BEAE0@DM6PR15MB2923.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(53546011)(6512007)(6246003)(71190400001)(1076003)(11346002)(6486002)(33716001)(446003)(5660300002)(66446008)(229853002)(99286004)(6916009)(8676002)(6506007)(102836004)(9686003)(386003)(4326008)(53936002)(52116002)(81156014)(81166006)(66476007)(33656002)(66946007)(256004)(76176011)(64756008)(66556008)(71200400001)(46003)(6436002)(8936002)(25786009)(86362001)(7736002)(2906002)(14444005)(186003)(54906003)(316002)(478600001)(6116002)(476003)(305945005)(14454004)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2923;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lIXp9MJ6nniAPxHezEkBw468nRpwFZf0gICqPychBc4KK7FOrEkAxjEx89PT3hVE/txSYiKYlizAXWIhaH+3V/r3RjIuf7UHAzQB9MwkaSrwSBlQK4Yh0HnvHCuFwTgpOe4UjjIKBxt32Ahk144eIIq9E6lfmiEHztH+aTl8/UXSB66MjaRTj43Oir3rHHkaWMr4gx2tATKbgBkjBeDCqZ0fTezav4bIYwO5WJvwLabl3pfjiBxbRQqSQRBgT9n6aXY6pJFe60bLf6Ns1zqHZ2wU8SDctK3enWFKlvRolZ60XZQudpyW40kB+CmtsjqUL2fTOr8YV08yqV3coUsA0Zg45OFkLbvajM4Q1I+qE6o6qdCDRd/tBAQi9HNpun70fwSdBSd0YHdwu/duTwnR9qpMpmmhz2FJCctl2rrPl+4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E825D8CE0F3047458EC30153B128DEF6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf307cb-5bf6-414e-9fe1-08d723471d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2019 19:14:24.7130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4WxoA6yVG7rwjZTG+AeF3zFZOAhUwh+2OHvgMUoHbQ94QHbB3DOeRF8XSvT09ID
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2923
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908170209
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 11:33:57AM +0800, Yafang Shao wrote:
> On Sat, Aug 17, 2019 at 8:47 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
> > with the hierarchical ones") effectively decreased the precision of
> > per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.
> >
> > That's good for displaying in memory.stat, but brings a serious regress=
ion
> > into the reclaim process.
> >
> > One issue I've discovered and debugged is the following:
> > lruvec_lru_size() can return 0 instead of the actual number of pages
> > in the lru list, preventing the kernel to reclaim last remaining
> > pages. Result is yet another dying memory cgroups flooding.
> > The opposite is also happening: scanning an empty lru list
> > is the waste of cpu time.
> >
> > Also, inactive_list_is_low() can return incorrect values, preventing
> > the active lru from being scanned and freed. It can fail both because
> > the size of active and inactive lists are inaccurate, and because
> > the number of workingset refaults isn't precise. In other words,
> > the result is pretty random.
> >
> > I'm not sure, if using the approximate number of slab pages in
> > count_shadow_number() is acceptable, but issues described above
> > are enough to partially revert the patch.
> >
> > Let's keep per-memcg vmstat_local batched (they are only used for
> > displaying stats to the userspace), but keep lruvec stats precise.
> > This change fixes the dead memcg flooding on my setup.
> >
>=20
> That will make some misunderstanding if the local counters are not in
> sync with the hierarchical ones
> (someone may doubt whether there're something leaked.).

Sure, but the actual leakage is a much more serious issue.

> If we have to do it like this, I think we should better document this beh=
avior.

Lru size calculations can be done using per-zone counters, which is
actually cheaper, because the number of zones is usually smaller than
the number of cpus. I'll send a corresponding patch on Monday.

Maybe other use cases can also be converted?

Thanks!

>=20
> > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync w=
ith the hierarchical ones")
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/memcontrol.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 249187907339..3429340adb56 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -746,15 +746,13 @@ void __mod_lruvec_state(struct lruvec *lruvec, en=
um node_stat_item idx,
> >         /* Update memcg */
> >         __mod_memcg_state(memcg, idx, val);
> >
> > +       /* Update lruvec */
> > +       __this_cpu_add(pn->lruvec_stat_local->count[idx], val);
> > +
> >         x =3D val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
> >         if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
> >                 struct mem_cgroup_per_node *pi;
> >
> > -               /*
> > -                * Batch local counters to keep them in sync with
> > -                * the hierarchical ones.
> > -                */
> > -               __this_cpu_add(pn->lruvec_stat_local->count[idx], x);
> >                 for (pi =3D pn; pi; pi =3D parent_nodeinfo(pi, pgdat->n=
ode_id))
> >                         atomic_long_add(x, &pi->lruvec_stat[idx]);
> >                 x =3D 0;
> > --
> > 2.21.0
> >
