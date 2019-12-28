Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8412BC5A
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 04:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfL1DAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 22:00:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfL1DAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 22:00:21 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBS2ubYc002372;
        Fri, 27 Dec 2019 19:00:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HSCXaNRK0yEb2kBOxbq9pnZr8QrqRDRf3xpT+PniV6g=;
 b=mgnIqYaaofXApGTw7fw5AAlECVoG/omIJoWRm1hJMN6B9bu8VEW1WXnI26134c0zqEuF
 9vdbO1r2LXzrtv7XGArudS4RnUP2OevvIHxupexedrqjS87f3+gK9T13AeezcrYValno
 bgAwPXRnKxHbO7Avp6vuLpdwirDWV27VbMM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x50yu5ppc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Dec 2019 19:00:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 27 Dec 2019 19:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReRhKjQK6Ub4hrH/zWFfsvfUOP/UMiagJeWMdJX9SP8lO8vvY2+zWAyshownW+tDkxVJLzeJP3YvrvMyYjZwHbicUn8FSUgYLuCDKOz2walOATJoMCmC5yeagXOAB+VT2Z5y70Bj87pXLO/P9brI7W/wGaatcIfCD43czO27n4y/qZmP9nJKJpv3FQ0KMO0qsYVQTWp8ghK2mB59iUZf+HPOyE0iw0MRUYSpNjTWX/fvCDkWCiHE6APaxS0y1WnwdU6akyKkPeDguOrFZFBwfuuV+9JFXI3965xHUnQGv8TQOE9zUDY6+d8xQjqY3iXi8itpt7fusOtLUxDUI8TmFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSCXaNRK0yEb2kBOxbq9pnZr8QrqRDRf3xpT+PniV6g=;
 b=e8Wg3hCB/0XiTlHcD6R+Vo1maj11j0aM8HFIwtmVTIy9ZBZvRyG7bEkkdBd1ou3TMM8f0X35TJky9DGiJ/FM15VPgAdbZ+JxogdFa6xUUAW0pcgP534xKtrUJOWlbV2u8ZfEbGXz49B5om5hcTSSjS0XaRCfrEpPqe3/wJvGh6BYbpHXLsOFROS+gAVtDbFQ7RR/MWhu6LGvRQl1jvPz0kwLsThBrP5REApgWK2eBb9PMRi2IneAJyl0S9Kxmy+EcQhlPHGIuM6cpHjhwu0c3NPyHe88e5/0O8wocqg2yqHu7hUqowpIUtm/dPTj7OimiUVkrb5BwLG51VjPilu0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSCXaNRK0yEb2kBOxbq9pnZr8QrqRDRf3xpT+PniV6g=;
 b=fCrxVQgGrQi/K/t6Bs5hcnJPC6l91oA2C7tAyZhC00EZ2nZZ3ye/lg38GrdGl9MFI7do9kpOpTpepymIcxhk3wRytbx1AuNg3D78W/fbRo07NRkYBDPh1v4K2FfaYJvryBxUCZEfvzgFQZhacs79pBJZdeTaUOKY5qBJC0Vit00=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB3239.namprd15.prod.outlook.com (20.179.59.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Sat, 28 Dec 2019 02:59:56 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2581.007; Sat, 28 Dec 2019
 02:59:56 +0000
Received: from localhost.localdomain (2620:10d:c090:180::d32e) by MWHPR1201CA0023.namprd12.prod.outlook.com (2603:10b6:301:4a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 02:59:55 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, memcg: reset memcg's memory.{min, low} for reclaiming
 itself
Thread-Topic: [PATCH] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Thread-Index: AQHVvLNbLK+Vure78kqR8d/QXQ5M5KfOpxSAgAAgZ4CAABTcgA==
Date:   Sat, 28 Dec 2019 02:59:56 +0000
Message-ID: <20191228025951.GA8425@localhost.localdomain>
References: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
 <1577450633-2098-2-git-send-email-laoar.shao@gmail.com>
 <20191227234913.GA6742@localhost.localdomain>
 <CALOAHbC_ifYcWsNqJ4889nHFeyasruaapO+0LM9UPDsSWiNA9Q@mail.gmail.com>
In-Reply-To: <CALOAHbC_ifYcWsNqJ4889nHFeyasruaapO+0LM9UPDsSWiNA9Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0023.namprd12.prod.outlook.com
 (2603:10b6:301:4a::33) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d32e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f277774c-84f3-492b-d2c7-08d78b4204de
x-ms-traffictypediagnostic: BYAPR15MB3239:
x-microsoft-antispam-prvs: <BYAPR15MB3239B7696F2C004F89E2AEB6BE250@BYAPR15MB3239.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02652BD10A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(376002)(346002)(136003)(199004)(189003)(9686003)(52116002)(7696005)(53546011)(478600001)(5660300002)(86362001)(6916009)(71200400001)(1076003)(8936002)(69590400006)(81166006)(8676002)(81156014)(55016002)(33656002)(54906003)(316002)(6506007)(66556008)(4326008)(186003)(2906002)(16526019)(64756008)(66476007)(66446008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3239;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NqvJ0pNNPjxy49tnWM4mCQb6wGp77L4Vf6KZdWrT0fIbwFLK6EUoAmveOvuZro4HbQogQtsqRjich/tV6PiLORuENk8JyxM8vX9nLfRp4D/O8FkasKlWuoNJZSp+VPrnUpU7Y/yQrPY+fYShVGxlTw8LNoe00UEwV7NIQbsOUWqxpJJ4d5pIgQrVs6F8FqvZYoMkdCKP5mkMtVuZnVtiSk6uVnCQZt4GeOOMD+n3dvur6H2Uaz8n8aTpaFab33ZP7eNBgxChDZYndJ/R9W7qiZMHlNOx5kxOPYgnWtuWIeH9fG68v1HuZ2uhSUF05Svmj+YDj7QKshirYnQeK6Q2imz2juvDA2rrPEHzBLm2QikmZv7Q8xGK9u2m30y4AHGJ/JhiuqCUuj01HhPrf1a3wVGofZY7iviFCmz21JU358K+ncIyjM3sWWABFV3BdljflnfHhdICAKO9qMO22nhi1Y4KGAVECRy5JW3S7bHCB+yExRdd7k8Y2sivcs8BfqTD
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23696161BA73E34A84D60B27FAB04AFD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f277774c-84f3-492b-d2c7-08d78b4204de
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2019 02:59:56.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27yebOQQZ+5HtCR2Xgq94AXkeC7zv834FSGMrBp/CMuPY3wtXuzD9cdl670Nn94K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3239
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_07:2019-12-27,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912280026
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 28, 2019 at 09:45:11AM +0800, Yafang Shao wrote:
> On Sat, Dec 28, 2019 at 7:49 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Fri, Dec 27, 2019 at 07:43:53AM -0500, Yafang Shao wrote:
> > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values=
 of
> > > them won't be changed until next recalculation in this function. Afte=
r
> > > either or both of them are set, the next reclaimer to relcaim this me=
mcg
> > > may be a different reclaimer, e.g. this memcg is also the root memcg =
of
> > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_co=
unt()
> > > the old values of them will be used to calculate scan count, that is =
not
> > > proper. We should reset them to zero in this case.
> > >
> > > Here's an example of this issue.
> > >
> > >     root_mem_cgroup
> > >          /
> > >         A   memory.max=3D1024M memory.min=3D512M memory.current=3D800=
M
> > >
> > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > this A, and it will assign memory.emin of A with 512M.
> > > After that, A may reach its hard limit(memory.max), and then it will
> > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > not calculate its memory.emin. So the memory.emin is the old value
> > > 512M, and then this old value will be used in
> > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > That is not proper.
> > >
> > > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclai=
m")
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Chris Down <chris@chrisdown.name>
> > > Cc: Roman Gushchin <guro@fb.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  mm/memcontrol.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 601405b..bb3925d 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -6287,8 +6287,17 @@ enum mem_cgroup_protection mem_cgroup_protecte=
d(struct mem_cgroup *root,
> > >
> > >       if (!root)
> > >               root =3D root_mem_cgroup;
> > > -     if (memcg =3D=3D root)
> > > +     if (memcg =3D=3D root) {
> > > +             /*
> > > +              * Reset memory.(emin, elow) for reclaiming the memcg
> > > +              * itself.
> > > +              */
> > > +             if (memcg !=3D root_mem_cgroup) {
> > > +                     memcg->memory.emin =3D 0;
> > > +                     memcg->memory.elow =3D 0;
> > > +             }
> >
> > I'm sorry, that didn't bring it from scratch, but I doubt that zeroing =
effecting
> > protection is correct. Imagine a simple config: a large cgroup subtree =
with memory.max
> > set on the top level. Reaching this limit doesn't mean that all protect=
ion
> > configuration inside the tree can be ignored.
> >
>=20
> No, they won't be ignored.
> Pls. see the logic in mem_cgroup_protected(), it will re-calculate all
> its children's effective min and low.

Ah, you're right. I forgot about this
    if (parent =3D=3D root)
	goto exit;

which saves elow/emin from being truncated to 0. Sorry.

Please, feel free to add
Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
