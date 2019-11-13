Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE43FB5F9
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKMRJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 12:09:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbfKMRJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 12:09:43 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xADH0agB014987;
        Wed, 13 Nov 2019 09:08:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AV150CMhEZJfztroqUWG6iYTfcMr4oTZyRwZXVJXG/o=;
 b=pY4iiW2eG6YoEJA8AyPNZPJHty7/L1idTbNA7lZvxhfjJiNnz/yafHNXSTB6vcptgZ8N
 EeSZYwNIJ60y3ULztQIe7l9JuDLm1ik06tbzOXsy+6xzS5+7at4uHhgetlvzJgnnmVe7
 XxQv2nrzNxOxYk3mvmBxrw+RYsjLdIlNP1Y= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w7prjgmp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Nov 2019 09:08:31 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 13 Nov 2019 09:08:30 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 13 Nov 2019 09:08:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lck35ah2BfHCsawtXOFQCSvJXKIGtsx8mKe5/PteTChtvdtWFdyKjwhD/A+0qDFXLctYR2fUOLTzyHw10xfBvjge953sfv/hV4GpyBa71T/BMUK0jr0o2MzLmRXz5SF0chDDkn9Z6GU/O+4NPAUXOGUb54yxxQgX1GCituAV+t4F01/rcimAhpQh6CP9dynimn8E2SweWtaj8BO+5fumhs9HrHySiQwrrPVS0hAT+tADJB/RHs5efrw2k6krFdKq+6jh4dezyGog3DVAflPX25GEYcQuxHxQDGNZrEi/jpcyYfZc+iOz7TIpBzrpkMZFmyYpImspKFB5PLx45vxQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV150CMhEZJfztroqUWG6iYTfcMr4oTZyRwZXVJXG/o=;
 b=fQfnGSqtX81Kv3URcFHA9og+nY0HpUkhjFlpz+VRaAlBdmIoxHHBilrrR0tv8wTiHA/65Ylly+qWICD3NhLS5UhyvfvmlAl8MRIxRneRFoNwOX+NjB5UMVs0J7b5BjYqt+atspZTF0YvDi28W5jXFWhLnksFI6iVUFnKuVCbN6XRVyeeqxVBm6SwZ+StFqTScAOrwaV3F1dndZJ9NIt8zNZBASdxlWp7PyiUFDyC4oi5fuVxRJysb9VVEbvupBWlo1+JJTSLHrOvbM5ZujSYPFQrWNPLKbbTO1znmFcP27g2PD3Aa9XfJw8/zUwHzZtTsj2Nc59oBY1zJi//Olv8vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV150CMhEZJfztroqUWG6iYTfcMr4oTZyRwZXVJXG/o=;
 b=ii66yd42ZXGAU58KLM3ZaEmpDSfAdrgGpplguPcxzuUW6+ryoOgfTePMwapDSCuTxXwfo26pEXz903rWsnJWdcqySpjz57Y2UtM5ye6g6iUI1RKRPDRIZadQhEVG6wgM8WZOUAemVB/ndh329fbfF70lM/oEquo+SNjChh6pIPk=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2852.namprd15.prod.outlook.com (20.178.221.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Wed, 13 Nov 2019 17:08:29 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0%6]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 17:08:29 +0000
From:   Roman Gushchin <guro@fb.com>
To:     =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny@suse.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Topic: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/KeJVScAgAAK2IA=
Date:   Wed, 13 Nov 2019 17:08:29 +0000
Message-ID: <20191113170823.GA12464@castle.DHCP.thefacebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
In-Reply-To: <20191113162934.GF19372@blackbody.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0052.namprd10.prod.outlook.com
 (2603:10b6:300:2c::14) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::14bb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e663491-3b6f-49fb-d017-08d7685c1aa8
x-ms-traffictypediagnostic: BN8PR15MB2852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB28520515048202CE75F47224BE760@BN8PR15MB2852.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(39860400002)(376002)(366004)(189003)(199004)(8676002)(52116002)(76176011)(81156014)(478600001)(386003)(102836004)(81166006)(256004)(14444005)(2906002)(186003)(25786009)(316002)(4326008)(6116002)(6506007)(1076003)(71190400001)(66946007)(8936002)(71200400001)(6916009)(54906003)(305945005)(486006)(86362001)(6512007)(11346002)(14454004)(5660300002)(446003)(33656002)(229853002)(6486002)(6246003)(66446008)(66556008)(64756008)(9686003)(46003)(66476007)(99286004)(6436002)(476003)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2852;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bRSx2SJKkfmLczaA1PP59a4qImitf8rSCBn8PIvl4LcU+zS2/RgpMMpkRfAhyjNGSWPjNbOrPegd0dRcUGx5UUzGqXUBnVgR1Iaa9v4qXvftET7fY+00ovHCQCiepVgYoM+8lgcNh05WsLFDnuYQvMQJWwF/AWcgPpEde6pj7dnR0FUJyU+N2iSs4KBFDp7sxCNe4PcUlHfhsCN3LEODoHMztSFRzd5qHKveGxVlvfGM8+C69YxEpS1s7ttBvDi26PDVAwHBQ5BYJ0q5HpcZ6ElISWogVEjcQ/vep9mOjTf2slveMOdIQ5+CIlaNUBTPeMjQX2WXv4xa/Qf7ryeDMTqVRNEsHMm/wxi+lt4HP+ppuinsQVCybBbuIuwJaN6ZwUs7bMPXGZ7ctGl1gQ+6QL9TfDlzs+F+OjaHB4uXRuanB1WHe+99etLe/KlQ8i2E
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <976747A0B33EBD4A92BBDD26F233AC3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e663491-3b6f-49fb-d017-08d7685c1aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 17:08:29.2613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mIsgv7w1Jn1P+txumkm88km72Ko6QMN7C4ZJ0MpOwWBZZxA4o4uxpwCNPCkK6M+d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2852
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-13_04:2019-11-13,2019-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130148
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 05:29:34PM +0100, Michal Koutn=FD wrote:
> Hi.
>=20
> On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin <guro@fb.com> wr=
ote:
> > Let's fix it by switching from css_tryget_online() to css_tryget().
> Is this a safe thing to do? The stack captures a kmem charge path, with
> css_tryget() it may happen it gets an offlined memcg and carry out
> charge into it. What happens when e.g. memcg_deactivate_kmem_caches is
> skipped as a consequence?

The thing here is that css_tryget_online() cannot pin the online state,
so even if returned true, the cgroup can be offline at the return from
the function. So if we rely somewhere on it, it's already broken.

Generally speaking, it's better to reduce it's usage to the bare minimum.

>=20
> > The problem is caused by an exiting task which is associated with
> > an offline memcg. We're iterating over and over in the
> > do {} while (!css_tryget_online()) loop, but obviously the memcg won't
> > become online and the exiting task won't be migrated to a live memcg.
> As discussed in other replies, the task is not yet exiting. However, the
> access to memcg isn't through `current` but `mm->owner`, i.e. another
> task of a threadgroup may have got stuck in an offlined memcg (I don't
> have a good explanation for that though).

Yes, it's true, and I've no idea how the memcg can be offline in this case =
too.
We've seen it only several times in fb production, so it seems to be a real=
ly
rare case. Could be anything from a tiny race somewhere to cpu bugs.

Thanks!
