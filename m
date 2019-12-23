Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A3412990C
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfLWRDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:03:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4852 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:03:42 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNGuLdf009060;
        Mon, 23 Dec 2019 09:03:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kheSxJkWd07gX1DrmjGRY8ShW53Y3gQpJMqi2hsBwVo=;
 b=dV283hFt11mn1kaM0JKXZbjpwY6XIADw/pMN/QC82SUgcm9gNUKyKTICOQewMsz/J/u+
 XkGg//0S60NDUwfa6b4A0e4yuB90IHwpHzpVWtEY7G7evRdlkzWYEolCjG42pA7J5v2r
 VM+uVbZ24jP+9p9v8DZdnbYjwZxjWkhiEmA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x2410d4a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 09:03:37 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 23 Dec 2019 09:03:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Dec 2019 09:03:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RShTFKaCUlkSsDiDBgbr39VYTO+3vdsUFMNcLmGrBXluUU1tfz6ZNiGj6xTH/g8ZeuHlgmx78BLkQG/dKHI9XIilpGoSrhhy3B/fAKHp5DplQgrQL4ZSP88phbAaNGRwCEkT8vCzJDQbvLHqEj9AzwPUlnATqTnIgPQrb067VtElB8shatkeD2/Vf66rMi6CcAhFY4Nj5pKwXLPG04EfZu3bgsrrjlEIJ2MwqgBeOUZwEwp11+clbFghk635P60RDQfw1N3tJxVM1UESlKPber4I0s9lZ7vK7xeCNoaI+vpqxJoqJdkc950FK5/Vms/AeIV4Zzzmp5NLslK8+uTt+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kheSxJkWd07gX1DrmjGRY8ShW53Y3gQpJMqi2hsBwVo=;
 b=L6hadTYmmJuJ/NV1YYQslXsgs4r+1fCAs3/7gbfz+PwqzEMwIwdu50QcnoiK1aQ9n0xwCnzFsOLJpFXALVmbA+47GmJGmQaPO5ND4zgJgiwxi0PX5Op+fnmlhxFMvMtQktnZaq/3gdnw+4ftX8S1lbPAOZ7jOyZz3vFaB0C3sCUs/+lOAcmvtP8DhuvxAZVy0Yq+KhwXioPCIkKv+LogRUFuswGhabFKNnS1T+RUuf0MIGCU4d2iyz4t4fZPEsskn1euw1P17LlvKbSDEaqZ0YZEptCqeCD5dlSu54dWdoW9MLaFX24R1uD0Nc9hIRGN9MN5T4thbA77x7kqb1ArDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kheSxJkWd07gX1DrmjGRY8ShW53Y3gQpJMqi2hsBwVo=;
 b=WqKgDWNwo2alTKIftw9Vn/Krh0J//LkChKYP4yzRjWhut/tT0VZKk0DtLx/Dvj3buc8RfuGo18wrlwQkoBASGmacqJJlK715xLPNHy/FGQNUG0RrKNha9fed/XB0WVGyFvUv6jIZArmFb1zB21/xEpr8Ox8XWGSZkBNOdYt23NA=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB3110.namprd15.prod.outlook.com (20.178.239.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 17:03:34 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 17:03:34 +0000
Received: from localhost.localdomain (2620:10d:c090:180::902) by CO2PR07CA0071.namprd07.prod.outlook.com (2603:10b6:100::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 17:03:33 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm: memcg/slab: fix percpu slab vmstats flushing
Thread-Topic: [PATCH v2] mm: memcg/slab: fix percpu slab vmstats flushing
Thread-Index: AQHVtu3MQmrM9ps/eE+CZL/MYRsSm6fCwqsAgAU1RAA=
Date:   Mon, 23 Dec 2019 17:03:34 +0000
Message-ID: <20191223170328.GA18255@localhost.localdomain>
References: <20191220042728.1045881-1-guro@fb.com>
 <20191220093132.GE20332@dhcp22.suse.cz>
In-Reply-To: <20191220093132.GE20332@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0071.namprd07.prod.outlook.com (2603:10b6:100::39)
 To BYAPR15MB2631.namprd15.prod.outlook.com (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::902]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fdc4be1-1674-4217-4499-08d787ca0b80
x-ms-traffictypediagnostic: BYAPR15MB3110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3110E1157FED2FC2BB5C2EAEBE2E0@BYAPR15MB3110.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(366004)(136003)(54534003)(189003)(199004)(81166006)(8936002)(81156014)(16526019)(54906003)(316002)(69590400006)(478600001)(8676002)(9686003)(71200400001)(55016002)(52116002)(186003)(4326008)(7696005)(86362001)(6506007)(1076003)(33656002)(66556008)(66446008)(66476007)(64756008)(5660300002)(2906002)(66946007)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3110;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C3nPxflh1AD8CtK+yINHtbD2vX415+ntJYQ7q4PAV+lUtYqdd37Kqn5qeB45FSUC/76a5YRW3tzKlw+0RRknyD6GCeeuqXQcQG0gU8Kt8m+EsDC2N3+S5S4dkj170T9fOh4WJMnVAalc19qID1g1q+IkH4dgpSTHGeUstdUzfRbXWEOvn+VigTsi1lScKjZFLcG4uI3wDUwDZGyIAAxcuhyj0Su5umtmbIDGOEWaracNIIXqfknXNZG/f0539OrFI9yT91h5nCBxjxikrP+IZA3+H0rnL1gJN05ICdwvyBBSwy7fcf95I0MhZLnaPOxbX0ei/lKfslfihFCvIgeAvfsY70qW26SAmNomvABw4EfeS/UsgnmSToHNfaav3ZmPUwu4bEDYAf2w7Bs37sGO6zptp+scpJIYqtiXZ8E7uw+7TXEsFXwkzeCi6egpeflSvtnnH9H5vgj9FcMP22JjLQKwU1g7khu1p4OHxDLyniDApN1dSYTqTw+0LgYzOtgFqMTIjM8D8u1UzpEIvlQkfQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0EE3877AA754E24AA00CF60212B78338@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdc4be1-1674-4217-4499-08d787ca0b80
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 17:03:34.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qlIMBVOifG59+MJrITN8XiSlWhax+0Oqo0DCaOnd07420Biz1+OvuYfW0WVQ8Bep
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3110
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_07:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230144
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 10:31:32AM +0100, Michal Hocko wrote:
> On Thu 19-12-19 20:27:28, Roman Gushchin wrote:
> > Currently slab percpu vmstats are flushed twice: during the memcg
> > offlining and just before freeing the memcg structure. Each time
> > percpu counters are summed, added to the atomic counterparts and
> > propagated up by the cgroup tree.
> >=20
> > The second flushing is required due to how recursive vmstats are
> > implemented: counters are batched in percpu variables on a local
> > level, and once a percpu value is crossing some predefined threshold,
> > it spills over to atomic values on the local and each ascendant
> > levels. It means that without flushing some numbers cached in percpu
> > variables will be dropped on floor each time a cgroup is destroyed.
> > And with uptime the error on upper levels might become noticeable.
> >=20
> > The first flushing aims to make counters on ancestor levels more
> > precise. Dying cgroups may resume in the dying state for a long time.
> > After kmem_cache reparenting which is performed during the offlining
> > slab counters of the dying cgroup don't have any chances to be
> > updated, because any slab operations will be performed on the parent
> > level. It means that the inaccuracy caused by percpu batching
> > will not decrease up to the final destruction of the cgroup.
> > By the original idea flushing slab counters during the offlining
> > should minimize the visible inaccuracy of slab counters on the parent
> > level.
> >=20
> > The problem is that percpu counters are not zeroed after the first
> > flushing. So every cached percpu value is summed twice. It creates
> > a small error (up to 32 pages per cpu, but usually less) which
> > accumulates on parent cgroup level. After creating and destroying
> > of thousands of child cgroups, slab counter on parent level can
> > be way off the real value.
> >=20
> > For now, let's just stop flushing slab counters on memcg offlining.
> > It can't be done correctly without scheduling a work on each cpu:
> > reading and zeroing it during css offlining can race with an
> > asynchronous update, which doesn't expect values to be changed
> > underneath.
> >=20
> > With this change, slab counters on parent level will become eventually
> > consistent. Once all dying children are gone, values are correct.
> > And if not, the error is capped by 32 * NR_CPUS pages per dying
> > cgroup.
> >=20
> > It's not perfect, as slab are reparented, so any updates after
> > the reparenting will happen on the parent level. It means that
> > if a slab page was allocated, a counter on child level was bumped,
> > then the page was reparented and freed, the annihilation of positive
> > and negative counter values will not happen until the child cgroup is
> > released. It makes slab counters different from others, and it might
> > want us to implement flushing in a correct form again.
> > But it's also a question of performance: scheduling a work on each
> > cpu isn't free, and it's an open question if the benefit of having
> > more accurate counters is worth it.
> >=20
> > We might also consider flushing all counters on offlining, not only
> > slab counters.
> >=20
> > So let's fix the main problem now: make the slab counters eventually
> > consistent, so at least the error won't grow with uptime (or more
> > precisely the number of created and destroyed cgroups). And think
> > about the accuracy of counters separately.
>=20
> So this is essentially a revert, right? I have to say I was not a great
> fan of bee07b33db78 in the first place.

I have to admit, you were right!

>=20
> > v2: added a note to the changelog, asked by Johannes. Thanks!
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Fixes: bee07b33db78 ("mm: memcontrol: flush percpu slab vmstats on kmem=
 offlining")
> > Cc: stable@vger.kernel.org
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>=20
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
