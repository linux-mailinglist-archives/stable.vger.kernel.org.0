Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7771595FC4
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfHTNR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:17:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbfHTNR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:17:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDETZr013265;
        Tue, 20 Aug 2019 06:17:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YRUAljc/UQ1UkWtZt4Z3OXFdujriJ28IZs62dAAePaY=;
 b=Pq5ZClKbH3H+zrFiHJOGu6goC5o19mj3PAbGTb+2vhlYOL/+V5dlBWRaASDkeIbz66yt
 Wo4errzY2vK3+wp8DfgoPxG4rYw+B6unqk0P9wIef6tZD5WLoC42wtatChAFXaIDNH+o
 ToEnNk9OuOcupO+9Zk42h02Ac5h2xG2G/eo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugemngptg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 06:17:05 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 06:17:04 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 06:17:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQu8ZI6xP8TAbLBy5CxFEfVNXEormR3/j/1D4+VdTlMeMf3jMxZlzCCgEspxjSsKiafiG8YErDooMMq3Wq/+3Bu4WdGGpDs7Z8ZQ3Zjs6NlQekWohU3TO0STW5uvDuF4wmosqnIuA59X9XCM12SQ36NP1KJTxAL9RGCrqMxzuNd6rZ7/hpB4DFmmamBiEh1p2Kse1w9tsipNYn1IxkAowC4aLN0eI1MEigpj4Va1aHfZFnYovnoyT10Fi/QhuJysOrEZVvorWMhQl9W9WnPZ9FUZMPzfSNT8sjk6gc6p7hOGX16CtrkU0FrtTLVbCahf5tiMO4gO6LbGL43JcD1WGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRUAljc/UQ1UkWtZt4Z3OXFdujriJ28IZs62dAAePaY=;
 b=IXzfVyvck2/y+kSn5MURlCymoIQPm89MJ2qNUOosfoOVvChc2YfYD4gV4dTuoGxgoXwvu3ZBLl7331YYbLz0ibZbHVeH6dQNGLOQ4Mjy8wEDY9OqKVrXxaI88XINfLJc8rrqOZIzuCCpC6O6SQ4v+9HKU4zL1EXgz7Z+5wb+wGxxFXTW2cwLrRcoxU4zMGOb0qJrr6BWXiJwgqLzyQOWS3YB5Rq2rL1/cRNWKBmggsOIQk4T2KyLXheNrtm2gs6IAImyDwM/92IBRMCe6mdScwJ6olidjjn5iYORRIsG5FvgrZ0Ne8dvCdeTQE19N+SBrvgXonn4MDztAcq/4Xojtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRUAljc/UQ1UkWtZt4Z3OXFdujriJ28IZs62dAAePaY=;
 b=ZFBY4gNz2qqQGtRlHw8+JmiP7Y1URh1Zi26BiGd+JfvPVtci5CF4nC+Y4RtRtXqp7Aw5zq2i4h7iPsAnCBJCm7wH1dN/wB1q9k8CgKtrhQEPj80gDjJHYNV3Ttx4/FJeFMdJCCpdE0Ea4zIhU+H5/PTt2upP49+JZE8PoC/hLco=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1757.namprd15.prod.outlook.com (10.174.96.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 13:17:02 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:17:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracDwFyAgABEZoA=
Date:   Tue, 20 Aug 2019 13:17:02 +0000
Message-ID: <6A23C1AE-B447-4273-A451-38D458085C02@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <alpine.DEB.2.21.1908201106260.2223@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908201106260.2223@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f412]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72e39f53-fdd1-480c-5748-08d72570b0b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1757;
x-ms-traffictypediagnostic: MWHPR15MB1757:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1757B4C519396C33148E055CB3AB0@MWHPR15MB1757.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(486006)(478600001)(229853002)(66476007)(66556008)(64756008)(66446008)(76116006)(66946007)(50226002)(6506007)(25786009)(6436002)(71190400001)(6512007)(53936002)(6486002)(14444005)(256004)(6246003)(6916009)(71200400001)(4326008)(5660300002)(33656002)(53546011)(2906002)(446003)(476003)(11346002)(14454004)(8936002)(316002)(99286004)(2616005)(36756003)(46003)(57306001)(81156014)(86362001)(186003)(54906003)(81166006)(7736002)(8676002)(102836004)(6116002)(76176011)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1757;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UfylfUC5S5Q74rf2MzEoGGPTqU0pDlaGsNP4xWE5nEVVDt1fhKQbMOY0CEVWWMocT03uAfZu0lFITngJ2IOiEoSmHX7KH9QMSwNqcd2hImdb8d/nC67qkeZiJe+3SZSwjBP75tc/EVRHxKrLMqiSCY+uczcLaP3Vrc9ju1Pn9Mi+bQBqkoBCzH40G9mioaFfm6evJBjr4hdFqgAkq8xCPEV6smEvF818qcJokz7oSdBog9Sj7pEnynJ9XST6kgoqesy5UnOsdKudSlKCD5BCPgPx/WeF13enKwhSz9rc9tBq2I1XdTj0J6bkhBOvminEjuv4mLBd7z2EzM3sWBh7Sr0yD+RL+RQbMLJYs5SIQ/CZIEEL6zwlaJVNIe0h9xscCac8OolKCtLQVIMJFS6mL24Wl8bhJIqe+Eq+58yMLeA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6475E0209E0ED48BFFC12D99DC757C7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e39f53-fdd1-480c-5748-08d72570b0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:17:02.5454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9WUydOEVTvl5HUP3IODwv48zCpMWooZlbSFdtPRueIFiXhMkJD28FwmjsC4tPpOkGB34hY69Q4WMdFz70uXjIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1757
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=900 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200140
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 2:12 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Tue, 20 Aug 2019, Song Liu wrote:
>=20
>> pti_clone_pgtable() increases addr by PUD_SIZE for pud_none(*pud) case.
>> This is not accurate because addr may not be PUD_SIZE aligned.
>=20
> You fail to explain how this happened. The code before the 32bit support
> did always increase by PMD_SIZE. The 32bit support broke that.

Will fix.=20

>=20
>> In our x86_64 kernel, pti_clone_pgtable() fails to clone 7 PMDs because
>> of this issuse, including PMD for the irq entry table. For a memcache
>> like workload, this introduces about 4.5x more iTLB-load and about 2.5x
>> more iTLB-load-misses on a Skylake CPU.
>=20
> This information is largely irrelevant. What matters is the fact that thi=
s
> got broken and incorrectly forwards the address by PUD_SIZE which is wron=
g
> if address is not PUD_SIZE aligned.

We started looking into this because we cannot explain the regression in=20
iTLB miss rate. I guess the patch itself explains it pretty well, so the=20
original issue doesn't matter that much?

I will remove this part.=20

>=20
>> This patch fixes this issue by adding PMD_SIZE to addr for pud_none()
>> case.
>=20
>  git grep 'This patch' Documentation/process/submitting-patches.rst

Will fix.=20

>> Cc: stable@vger.kernel.org # v4.19+
>> Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32=
 bit")
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> Cc: Joerg Roedel <jroedel@suse.de>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>> arch/x86/mm/pti.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
>> index b196524759ec..5a67c3015f59 100644
>> --- a/arch/x86/mm/pti.c
>> +++ b/arch/x86/mm/pti.c
>> @@ -330,7 +330,7 @@ pti_clone_pgtable(unsigned long start, unsigned long=
 end,
>>=20
>> 		pud =3D pud_offset(p4d, addr);
>> 		if (pud_none(*pud)) {
>> -			addr +=3D PUD_SIZE;
>> +			addr +=3D PMD_SIZE;
>=20
> The right fix is to skip forward to the next PUD boundary instead of doin=
g
> this in a loop with PMD_SIZE increments.

Agreed.=20

Thanks,
Song

