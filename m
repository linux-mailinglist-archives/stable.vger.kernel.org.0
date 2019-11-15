Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4CDFE4B5
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfKOSPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 13:15:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfKOSPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 13:15:09 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFIDcn4011973;
        Fri, 15 Nov 2019 10:13:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NRVDovbvhpiU9C+OIZfCA3YxDopu2PTSb96qrOixXKk=;
 b=T7kYZWzepBwsLq0yS0ii14A6q0z/wSbgf9yJlgPcTOzpPCMxSHt7pJKWb72oPWQj3Vtn
 DazGr3RWPakiTH2TyxmyPKsThZpnNLh3VGp35BKK6eLMPbWaf1xH6hjWLJo+baXdZN7Z
 YvJf/fLbjrd9rP4grdyjGcIWsnpGXaRKyO8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8rge5kd7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 10:13:42 -0800
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 10:13:35 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 10:13:35 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 10:13:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmZY34D58yk7se1AtCLc1F2YYnZ63dIxSKRpudD6HO8kxrYdRgp1IFFjkOuNNirNIXn0scgtw7eFMicT30OfY1vvoA+XMY0i1uvy7m1hzAQ4VrK4JFLPgi404CQPBE0n1wqZAn7d+oMshlzCocafcjBL77H9AsIoM6oy101j4ojv7Vc3S/l7fiBV+yWrvr4CiP4sWcqgh0/Z/ekoO1KxAbTi8MFmNlUgNUf3BHqJ7OB0IemAY0Lm3K3Xng9xFoSKbDstFeMOQcR70kE2RQUy75MALnVbp2VOaAE9VzasFf7lyciiQ5z+4K1yxNSeUpKbblHyiWGXz38t7HvYBWRKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRVDovbvhpiU9C+OIZfCA3YxDopu2PTSb96qrOixXKk=;
 b=lFTohck2iyWltuftbcft2V75E2jJ2Id4/0tbk7GnfneWvSmaHTBrB5LJqDcXBU0MttZJxFkFRn9XpbhGQ93CzfKr8zIwgCLf0Ul/Bw7f3JRXPewarxtLjV8JPF3/287Fj2+853ZDtvQCvvHZh5UGPldFibLZ4UsVftInfH0PaF2HGX9KChSAyTo4kupb7LUIAhHhLjD1nmNmtXHqaqdfpQ8Z5pAmk9SnpycHoFsD8SVrIHrgq3a2d9edws4d47kAhX//qmsFIxv4AbZiUDFq+hH2YlMao0rS3fR/sYByoS3PxNDFUwk8PpSWukLjy0KgjMrgXA16cWpD+8hmkoQBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRVDovbvhpiU9C+OIZfCA3YxDopu2PTSb96qrOixXKk=;
 b=Mepz/1+0FOCSulgrmhi5Buo3BPm2dbi83Neq+NUVkS1XNki+cRvQmee6lwnfgBBkdF+gv7zwYatm7j5eq6Rb9gJZdF7W3yIFE5gojRVSvuXy9T5X7nMsGP4JdGjvDU1Kbh803WJjJlQSUmFKfjc5RbK1OIh67lVQAiW0oHAUtOY=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2835.namprd15.prod.outlook.com (20.178.219.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Fri, 15 Nov 2019 18:13:32 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::7cae:3a15:917d:83c0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::7cae:3a15:917d:83c0%4]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 18:13:32 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Topic: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/KeJVScAgAAK2ICAAbZBgIABgJEA
Date:   Fri, 15 Nov 2019 18:13:31 +0000
Message-ID: <20191115181322.GB27385@localhost.localdomain>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
In-Reply-To: <20191114191657.GN20866@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:102:2::47) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9012]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd24e0f2-756f-4783-2ff3-08d769f78517
x-ms-traffictypediagnostic: BN8PR15MB2835:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB2835D0E5C0C2878E8949801BBE700@BN8PR15MB2835.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(346002)(376002)(39860400002)(396003)(366004)(136003)(189003)(199004)(66556008)(102836004)(46003)(4326008)(6116002)(33656002)(9686003)(478600001)(8936002)(25786009)(86362001)(229853002)(6246003)(2906002)(66946007)(81166006)(316002)(446003)(5660300002)(6916009)(14454004)(476003)(71190400001)(486006)(305945005)(6436002)(8676002)(6486002)(99286004)(11346002)(6512007)(66446008)(7736002)(54906003)(76176011)(1076003)(71200400001)(6506007)(386003)(64756008)(52116002)(14444005)(186003)(256004)(66476007)(81156014)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2835;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MMzRDd2MniFjPuRsPcc06dGjrqtouk7UAd52XBjwwfy+Hjp2bCIwkKJiczqGsyU/fZ3TcW2ofsULRY8KvMtAihB8t/pooO/cyMcHlWkz4eDP52lyVSar8+oh2PLU5X3jCglgJZq/u1sN0OgRHW7v7YvTYV9KJ8F/9Av0mGp4f8osNbTWgK8kiHyg0cpBB410NvDJHk8deHKo2LOJ9nbIGpcHuCjZU17W5P+Cx0YzhsplW+fWcAf112sYnpagGdSuinNHpuffCAt+uRKJayI/FDppX7UX66IAFiFAzN2eSQ1bBxlEfQSJP0G5MZSi+Btux/FJVfYa3w9ZdetrJVIWn6PaHgSZX5tqOQxWxt6zBREVqj/CLaWSt0zfDJ1RLK3C2P4rNykoyEHtOFo6Ok0tpGDxjN3hAASOmBqdOYKCVeeaazn1z44RhNVXJzG9le+4
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6F24FB96FF5A3F4A9DB8C549060B5F60@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fd24e0f2-756f-4783-2ff3-08d769f78517
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 18:13:31.9395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 95RVB9UMi25S3QnxNG90rkpqM0afh/qRRhlNwbU6QTHSNC8lIv7uQcEG8+PzivdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2835
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_05:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150162
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 08:16:57PM +0100, Michal Hocko wrote:
> On Wed 13-11-19 17:08:29, Roman Gushchin wrote:
> > On Wed, Nov 13, 2019 at 05:29:34PM +0100, Michal Koutn=FD wrote:
> > > Hi.
> > >=20
> > > On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin <guro@fb.com=
> wrote:
> > > > Let's fix it by switching from css_tryget_online() to css_tryget().
> > > Is this a safe thing to do? The stack captures a kmem charge path, wi=
th
> > > css_tryget() it may happen it gets an offlined memcg and carry out
> > > charge into it. What happens when e.g. memcg_deactivate_kmem_caches i=
s
> > > skipped as a consequence?
> >=20
> > The thing here is that css_tryget_online() cannot pin the online state,
> > so even if returned true, the cgroup can be offline at the return from
> > the function. So if we rely somewhere on it, it's already broken.
>=20
> Then what is the point of this function and what about all other users?
>=20
> > Generally speaking, it's better to reduce it's usage to the bare minimu=
m.
>=20
> If it doesn't have any sensible semantic then I would argue it should go
> altogether otherwise we are going to chase new users again and aagain?

That's the plan: to audit all use cases and get rid of it where it's possib=
le.

> =20
> > > > The problem is caused by an exiting task which is associated with
> > > > an offline memcg. We're iterating over and over in the
> > > > do {} while (!css_tryget_online()) loop, but obviously the memcg wo=
n't
> > > > become online and the exiting task won't be migrated to a live memc=
g.
> > > As discussed in other replies, the task is not yet exiting. However, =
the
> > > access to memcg isn't through `current` but `mm->owner`, i.e. another
> > > task of a threadgroup may have got stuck in an offlined memcg (I don'=
t
> > > have a good explanation for that though).
>=20
> The trace however points to current->mm or current->active_memcg. Is it
> possible that we have a stale active_memcg?

It wouldn't cause a rcu stall.

Thanks!
