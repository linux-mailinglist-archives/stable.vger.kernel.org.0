Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2F295FD6
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfHTNTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:19:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729639AbfHTNT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:19:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDHVF8023693;
        Tue, 20 Aug 2019 06:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QSJMSUOkYU2F1gINAGrBbRT6okZp4LOcrVQ0wVrR6s4=;
 b=hHhcOFSNDEGWB0GgRSGiRrzFoN+kzM2HZLcfG6+NebNm7e7KntFWVbZtN7FB2T/+CJXs
 PPKO3Sqh1ZzZkHv10dgv2FgV5gYWWslu38/oeE46bIybnQNaNZ4U7oWhPFbthHtdy5Lv
 HZSbulp0UXQi2pL7t+cSDzrwh0815Khhwvg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugc4xs9d4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 06:19:12 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 06:19:10 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 06:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4mttKsolIUA7YSKPmSTzR3DOut9AneLrH6PS/LvMoSUfkY+qCWQNCyGoKAwROJZLBKEnmXcBVrI8wSZVvi7RayGMZ8fmQQyogNzKPI910z2nqqDzJOqTbngf1208Ek3Y9qvbLJHDj0V7vqihlg3jnzLBH55yBLTE5AQffdXMOECyp2y7zV0+rTmbfcxmnALOX5PAg3M8i/RlFAtfdZj4qAKcJkZwwOkV3km+VGVMOlmThHWQZwx4h+L5dZ1wDyZDpXRoQ5+Hr3Lx5RSb0ETWdqlm0b3eOdcf/uLAFDja53U1Ol9JHju9PH1JDXTaBdwypwzDpzugxro1UIoPctsLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSJMSUOkYU2F1gINAGrBbRT6okZp4LOcrVQ0wVrR6s4=;
 b=DZwDeOHq4e86zTCd0M4HG/sppfwXkHBjEtegCElSpvsOkc+XBgmSoGS5qLnNXw/DGNLViNbyQHHoXY43jZ1Yi3khsjNVIpwRuobnlFxJPOn+D1rrjgu0SnBjbRhpb1+3XAfvoWn8ienv7t9mLc5OcsPd9fqQ6m0PkKcz2VtfWrZbKhXtSgrVx2KOaXJv387492bIZHgqdCjf+IJukN5Do4MZJ9bpqyyGIh2zvkF3Yg5m+6GuKXyLqr9D23+WgfaDQ/NawjFyYtfsS4s9SLx9rumTdtXoPXrkNvVFZ2pBPLkBIrMZgzZ2rg3ybIF96rv/Dwy1WsFK8WVvnPUqTGKiMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSJMSUOkYU2F1gINAGrBbRT6okZp4LOcrVQ0wVrR6s4=;
 b=QH+Jcg4dYfnkNerFjRUXsnIvtswpt0R02GU2AE5u8ZqX90GSaJL9c0Dv6nmA5l3pY9syL4ESVCQM2rkQOtYd6jqxAe5sg6/3mix2fK9iUDDxQET77IOK61BKDqVV3Y5SjBaImATwfU700OZeooBtH4jUR5Iu6u3/8vEuls7ekA0=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1486.namprd15.prod.outlook.com (10.173.228.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 13:19:08 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:19:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracDzfeAgAA3YYA=
Date:   Tue, 20 Aug 2019 13:19:08 +0000
Message-ID: <8483292E-DAD0-4B75-8EB0-8EBEE3D067BB@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <20190820100055.GI2332@hirez.programming.kicks-ass.net>
In-Reply-To: <20190820100055.GI2332@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f412]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74027684-304b-466c-3799-08d72570fb84
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1486;
x-ms-traffictypediagnostic: MWHPR15MB1486:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1486959440BA0CF0B1BE7371B3AB0@MWHPR15MB1486.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(136003)(346002)(376002)(189003)(199004)(5660300002)(486006)(36756003)(6436002)(8936002)(71200400001)(54906003)(14454004)(71190400001)(2906002)(86362001)(316002)(57306001)(53546011)(6506007)(2616005)(102836004)(53936002)(229853002)(33656002)(99286004)(478600001)(6512007)(8676002)(6116002)(256004)(66946007)(186003)(50226002)(76116006)(81166006)(81156014)(7736002)(25786009)(305945005)(66476007)(66556008)(64756008)(66446008)(4326008)(6916009)(46003)(6246003)(76176011)(476003)(446003)(11346002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1486;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nk3s1Mdfd80CqYKy0M7TKhejj55+ILcnFSBIraCI7NX+e/EIfD4yIWhrtpfcKwP+O1NfYlAPXapKJRrjRNy9OBK4Ndw2jRMhPhOIojQZt+BDgNDq89R+AQvK0u/qwbXnCjKfj3QdN1DxNIVjHtHPEAkRRCE6Oye8TD5i5rQXnaHc+R7wyDajpIDnzTx89ToSsft5iLStAC3P6SXmcxGnA5Eeqy87vLGC/QrLyBjMoMsf9oDKsfQ5AtlSekRWaYEfCG0hXbhxMLQ2/BKGD88YKT2wfFlDhtvnXU9CP/i6Lh8Nb1au0sH43tzLQQggN+tDHsAeYb9joTrxA4PkXNuMYg7ETOrHr+QYciNTJJgvfm2LM2YeiNFkZxTQYE2q5eTQgZpRqytguFg1Az5dqndtZyGX11gvdmuwxxOCsVkuq1w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91099288E73293498CB2F2611ECDD1A3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 74027684-304b-466c-3799-08d72570fb84
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:19:08.1341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a7SAfubnQCl7/79+PglLPurMUUE0dq1ptZIE6yItatEBaXz9pveH57bDZI+KdIlYysUIfZUphlgpYOSoGCysGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1486
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=868 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200140
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 3:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Tue, Aug 20, 2019 at 12:51:28AM -0700, Song Liu wrote:
>> pti_clone_pgtable() increases addr by PUD_SIZE for pud_none(*pud) case.
>> This is not accurate because addr may not be PUD_SIZE aligned.
>>=20
>> In our x86_64 kernel, pti_clone_pgtable() fails to clone 7 PMDs because
>> of this issuse, including PMD for the irq entry table. For a memcache
>> like workload, this introduces about 4.5x more iTLB-load and about 2.5x
>> more iTLB-load-misses on a Skylake CPU.
>>=20
>> This patch fixes this issue by adding PMD_SIZE to addr for pud_none()
>> case.
>=20
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
>> 			continue;
>> 		}
>=20
> I'm thinking you're right in that there's a bug here, but I'm also
> thinking your patch is both incomplete and broken.
>=20
> What that code wants to do is skip to the end of the pud, a pmd_size
> increase will not do that. And right below this, there's a second
> instance of this exact pattern.
>=20
> Did I get the below right?

Yes, your are right.=20

Thanks,
Song

>=20
> ---
> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
> index b196524759ec..32b20b3cb227 100644
> --- a/arch/x86/mm/pti.c
> +++ b/arch/x86/mm/pti.c
> @@ -330,12 +330,14 @@ pti_clone_pgtable(unsigned long start, unsigned lon=
g end,
>=20
> 		pud =3D pud_offset(p4d, addr);
> 		if (pud_none(*pud)) {
> +			addr &=3D PUD_MASK;
> 			addr +=3D PUD_SIZE;
> 			continue;
> 		}
>=20
> 		pmd =3D pmd_offset(pud, addr);
> 		if (pmd_none(*pmd)) {
> +			addr &=3D PMD_MASK;
> 			addr +=3D PMD_SIZE;
> 			continue;
> 		}

