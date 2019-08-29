Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B19A2832
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfH2Uk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:40:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbfH2Uk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 16:40:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TKe8BT005546;
        Thu, 29 Aug 2019 13:40:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iGlhdaTjijsupVmGteNCVb/55SBkNSWK5mVb0IHyFTk=;
 b=AoyNTY731t5ybXRlKjApNrlN/VatykA9HT3d5oRsCJ4VJicvhpVM4gHBpCDTumd6rgTb
 SAiqDnJ29BAa/HdDn6NHrAAL4QCUGs2VPCIuFzFlRTbsiR+Bg9KRuhgYNeOVB9OkATZA
 dr8x5Ifpt90SL+cRRQZU0Wc3owuMtWvjg0o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2up503vk0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Aug 2019 13:40:18 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 13:40:16 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 13:40:16 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 13:40:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mvo2+hC/nxR4ms3re1TQWKOgiR0PSS+nk5GucnG2CDOmQvedeZMh9saETMIn9IPvg74ZmUQt5RvdPv5Z0Js87JgnCQa2g3+FZR0jKI1jtrmxtVns2vtrPebctsTd0SD6kPoyHPnCGxHoGHVyPvUm9ez9IOlWDBrW215TNWX3/QtiVwVhWLTttSb+MXB/7kCBrIkFAXNIgcysxrTpMEpSqf1KsaKRz+QI9+hFpWoRrzHotyqbH3qgUlmrD4sf9tfn5buTJ8qMUcXJJw9RN2b+kzDlS7MsjH475lb9G6wv2XAmary6qkDV24pxWsVGs9dVXYm0t/QwJ5zFF0UcGf5+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGlhdaTjijsupVmGteNCVb/55SBkNSWK5mVb0IHyFTk=;
 b=Ffc7Eb29/FFNtMZKJB9abTUL8q2i29YfL+Y8lG0VwH1pqIoGtk8LQdxK/1xiJwKpkBTfcyEtSZK117Uwa5l3jrHUm4lWbjqW2Fc3brz30yyxS5qaA4wpKIhuJ+DOTObLUGCKgPcCasxCYDBFaFVPCQ9+Iao/0hHBo/fk/lmL2G0DYGj+thPeNPGH1YUUuu1W5mQEqn4CdDqURw3dkHy3hpZ/aIqrHczuBpUbdNrD9ievKweQ0IxEh0kR+NGmgkgZKllWaCjFFVc6zkRDEI4FIEDDicd98eHTkNfdezbPaXajKWM5imqd/GTClavdge8qlf6m1oeX1v/P8b6yrnDXIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGlhdaTjijsupVmGteNCVb/55SBkNSWK5mVb0IHyFTk=;
 b=dLq3Xdjv8vxA4/zzGOM1XyXsTKnMUwC9RR4mGvlxwE5E6AwZcFOhJlkcEIW8Tg5n7fI39x+3CXzWllqE4ABJJOzl/nCBD9Wzar8QQfBvWiyYt1LOnn3DYc2NOXdTIV3NzAd1ci3MfqzWmFMRV3HxXHWjeR/2w3mxNFWRPvfDlIU=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB3529.namprd15.prod.outlook.com (10.141.164.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 20:40:15 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e%3]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 20:40:15 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush
Thread-Topic: [PATCH] mm: memcontrol: fix percpu vmstats and vmevents flush
Thread-Index: AQHVXqjp5b+utKUrO0KyNKqIuZmkt6cSlpQA
Date:   Thu, 29 Aug 2019 20:40:14 +0000
Message-ID: <20190829204010.GA10855@tower.DHCP.thefacebook.com>
References: <20190829203110.129263-1-shakeelb@google.com>
In-Reply-To: <20190829203110.129263-1-shakeelb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0021.namprd13.prod.outlook.com
 (2603:10b6:301:29::34) To DM6PR15MB2635.namprd15.prod.outlook.com
 (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:524d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 931e0a6a-772a-474d-5242-08d72cc1188f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB3529;
x-ms-traffictypediagnostic: DM6PR15MB3529:
x-microsoft-antispam-prvs: <DM6PR15MB35299151FD63C75C7B8C718EBEA20@DM6PR15MB3529.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(396003)(346002)(376002)(189003)(199004)(316002)(486006)(6246003)(305945005)(476003)(7736002)(4744005)(86362001)(6436002)(186003)(229853002)(8676002)(6512007)(53936002)(46003)(6486002)(11346002)(2906002)(33656002)(9686003)(256004)(446003)(6916009)(81156014)(81166006)(1076003)(71200400001)(8936002)(71190400001)(478600001)(54906003)(6506007)(66946007)(66446008)(66556008)(66476007)(64756008)(14454004)(25786009)(52116002)(76176011)(102836004)(6116002)(5660300002)(99286004)(4326008)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3529;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bYCvDSKzUnC58ijvUU3GYAwgIuDNRk/SX3FgKfgdOnqlI8PlskdYysONS0n8KctONYGtJr4D4oq/FahFCdmowm6vHJVdSEeuT0r22OOLfOdHvUXCgp3GSVfjQSlEy4RmBXhgu1hBh97WmaHEDAwg09yLt0BtWErvfn5ZyEKBQCe7Fp14O05BO1z5N4bg3G6ZhlEu4ZfQ8gwlcV9gsRzh7JzM9TyJ01EbPGXA1Zi4PGkAWbVTA/89Ao0rh1h4Z5Z5/Hw09xIjb/PJeqjh8CuDIaAkdvpYqGLAshUBoA/x7z1VamVIGF8GcCu4daM96z5Hu/SNKE6JcFkalsxtKRnJc50sVUOjjZFX2bkMDL59T9I7dwrRzHONFcJOMjsXEkbz/b/Ct4TzxL+4lmst3yy4a5NFxbhi62tfw3oKqmQz5k4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F7A785C160390043BDF996A2B0401765@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 931e0a6a-772a-474d-5242-08d72cc1188f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 20:40:15.1808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4aNYYz+2x4cfKdDadJOWH3c7RQWPV5miYEKiIWGfC9HD69K3+YFN3tPjdND5rWiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3529
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_08:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=716 spamscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1011
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290208
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 01:31:10PM -0700, Shakeel Butt wrote:
> Instead of using raw_cpu_read() use per_cpu() to read the actual data of
> the corresponding cpu otherwise we will be reading the data of the
> current cpu for the number of online CPUs.
>=20
> Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releas=
ing memcg")
> Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasi=
ng memcg")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <stable@vger.kernel.org>

Ouch, thanks Shakeel!

Acked-by: Roman Gushchin <guro@fb.com>
