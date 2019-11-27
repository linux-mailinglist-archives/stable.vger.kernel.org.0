Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7110B468
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 18:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfK0R1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 12:27:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46028 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726292AbfK0R1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 12:27:40 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xARHHcq0028054;
        Wed, 27 Nov 2019 09:27:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=avQ5hux9TpRTLoC5TqsshkrELAL/IQ1Kn4L6PffD9VI=;
 b=NZovrcXXUXCLgjNuG4hPbQXwnQMw9qcWZVu8+MgF30pkGWJPIGNUBnoVMuSDovMilc8i
 Ztkkdow7OUG152EZMYE+48uv0HiNX9iDBkmGnsmRmiaT1pbGAIboLR+fBLjs061PVfas
 zFYdvk1XxNGXySUjpnS84/mjCBgsCJc5mn4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2whcxpngy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Nov 2019 09:27:32 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 09:27:31 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 27 Nov 2019 09:27:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgWMJmfIpckLtHbNkOFrlijNDqhSAImo6iPw09o23krJYn4Y4FCmZQmVXFNbAmSZ8Zi1MSdtIsO6jzWjF7afwiyAAcU5U6O7bldYyy6REPydVuvxM5/I9OU2eSqx0CE24N7/lTEUqoyFhMplYmFuvNYp0eNFARY8dzbbJW+xNoZ+a9ft5bVgYxs8JjPUI/7RaM2/Z1zLyb+IigaUQoqYTOUArLtXMxb7k/AtPX+/lKJYB5zGJY4bCDNxwjo4fwkDOcY0Iv1aTKtaP9eEY6Pgu4hngVPQjXNaEebZJJxOvPBwBv3yfwdjLJezcWEghTjJneaIZdNe4pxB/vjmCwvu5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avQ5hux9TpRTLoC5TqsshkrELAL/IQ1Kn4L6PffD9VI=;
 b=AkTJIlg64zA+JUcigMMLp9IyjwgPvJRcFqVv372LvN9iVWbRwPdYNji2MkpHu23kj2Lk80YVCa54BFlfFjwt6lxyKekrbVb8lrRvGfPNbX/Fr1C2uYQUh3HjSD4T/6eW4dB08aa7/bMGB4luXRUDr6HuVIup5v1YC0SqD+oSu4rmzNejDumIrT5UuxUUDs0v02LD4P//nzVNTtBy99fPBL/mAHc0G13moPbc5ZPIQLbDEGEnmlwj0fa6rM1hzGJgyw9VcajQkb97EGcGS8FizyRYFt6I9A+2uY3VQZKx/w2ipClUYt4RrEeIQ2IA0kP/6+wZZvCPqDv183oEy0fSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avQ5hux9TpRTLoC5TqsshkrELAL/IQ1Kn4L6PffD9VI=;
 b=XJFuMMu9oQRral01ma2z+FcGTnZ7BNkv9/5ViIO5UmiO4l2VszdMKoyY6bqfOmboeYEcECfccr+CfnuRnJD4VME0ZnMIAmU62JFn3sa8RfORQsCnjctuLNNwl6BwdU23iNPJxzB+/fClEfgSHttBL+gQTldoPPYudQNMHZpkmK0=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3284.namprd15.prod.outlook.com (20.179.75.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 27 Nov 2019 17:27:29 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 17:27:29 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Topic: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Index: AQHVo8HY/WnVvAZSgEqkb7BHNOXmHaedMHAAgACaToCAASswgIAAUmsA
Date:   Wed, 27 Nov 2019 17:27:29 +0000
Message-ID: <20191127172724.GA67742@localhost.localdomain>
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
 <20191126184135.GA66034@localhost.localdomain>
 <20191127123225.GR20912@dhcp22.suse.cz>
In-Reply-To: <20191127123225.GR20912@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:300:6c::17) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::991a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94d1f737-0475-4b74-b61e-08d7735f143d
x-ms-traffictypediagnostic: BN8PR15MB3284:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3284A54C160CB0D6B14915D4BE440@BN8PR15MB3284.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(199004)(189003)(6506007)(386003)(4326008)(6486002)(256004)(102836004)(6512007)(9686003)(76176011)(52116002)(6436002)(8676002)(11346002)(86362001)(5660300002)(7736002)(186003)(305945005)(6116002)(229853002)(8936002)(81166006)(81156014)(25786009)(46003)(446003)(6246003)(478600001)(33656002)(66556008)(71190400001)(71200400001)(1076003)(6916009)(99286004)(66446008)(66476007)(64756008)(54906003)(66946007)(14454004)(2906002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3284;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZtOaT0QeJElsyHuSYZG97vJUbEfH4Hbl++b4UZKQ/xhjEt6ZasD+ifbWgjeelNPM/PSX1fMe+v9Kno4N6dj40L5PWdzRxEY/3e4iTyuJzSYOWmOsUKF44avNQhQAUDAiMxUDIcThFa77SAWDSlULB0nwhXDIber9DcJ/ch3yNbaQv3+0yZL2kveBtkWZ/K1fwhLQdN1ruPaUsZf2IZ9a2naAGNdM55FbDdrX/rMSp7OKgNaoL1pUvGlId8RxibGZoYKTLq1kCLm9XQw786VIQJyUYXyjNHh1EOscaH8JioZdB33FPfB4umy+bYXxJnySy8dw9Qh4Yq8Hjjf53Z3pYd6jkJjGq2Gb4iqH/ABR4cwauz5WY1UFcn4MlkSL4Q05rop5Lr6rf+iqHjVpV5rgbCr5pGGbypOE1VqU8Dtc9ArcsyTajVsVVDc5jMiuFq1v
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D13ABAE7CAB2FC49B02F73F764F5BAF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d1f737-0475-4b74-b61e-08d7735f143d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 17:27:29.7079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3H6Aji6FoRjAzunqrmRDFI+auY+UeA9N1X2oseD2b2XOPcjUk3l7kSG2/5v9Egf0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3284
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=634 impostorscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270143
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 01:32:25PM +0100, Michal Hocko wrote:
> On Tue 26-11-19 18:41:41, Roman Gushchin wrote:
> > On Tue, Nov 26, 2019 at 10:29:18AM +0100, Michal Hocko wrote:
> > > On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
> [...]
> > > > So in a rare case when not all children kmem_caches are destroyed
> > > > at the moment when the root kmem_cache is about to be gone, we need
> > > > to wait another rcu grace period before destroying the root
> > > > kmem_cache.
> > >=20
> > > Could you explain how rare this really is please?
> >=20
> > It seems that we don't destroy root kmem_caches with enabled memcg
> > accounting that often, but maybe I'm biased here.
>=20
> So this happens each time a root kmem_cache is destroyed? Which would
> imply that only dynamically created ones?

Yes, only dynamically created and only in those cases when destruction
of the root cache happens immediately after the deactivation of the
non-root cache. Tbh I can't imagine any other case except rmmod after
removing the cgroup.

Thanks!
