Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC696688
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfHTQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:38:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbfHTQi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:38:26 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KGZHqu020078;
        Tue, 20 Aug 2019 09:38:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7eWJHDeR6QJtcF9UlMyM8zCIBg6G3Ll8dyKjrb6dqnI=;
 b=eK0xShbqwPlA7+5NaSOoZsogwbo6P5vgJ7m6TIHv+TvCyrocdrH9b74sZ1iZ6R0EITNt
 vuP7JLfW3nB6N9gaVEn4SM3c3fAHf+8/XAK55AGCNYtbmGjKdrlFwPJDqcBpt1k7ABwj
 4PyOaLclJ0GJEppu6AFJtNYLVZIOBlDeyNM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugjxd8hvy-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 09:38:07 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 09:38:05 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 09:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEemo+163sHn0KiwEwc9nMRt9pKQpKqKyEXiwDiQU5EJ88C6mITFDCeDXN6i6cj1HaSi9dvv6K4UG4QYT4RtbbFQStt+xzLwTWcTMKCTswCkdnCwcPpdPgODiYFqogX48896rsauA4GBoRBrmFkFjUV3W7c1UM3WYFH8dK+dg62XXK1kjex7ZPAybtbbACL3jf3NgayrP1i2NtJI3VqRYeTYZRJepTDrTCb+d80x1sSh4kIX3HBSOvhiSLUPCRXiTB+Dy03AZnELklrQWMgrLXjGYlimFj5T9Is8wb9jSovzfwtA2qhCMkSRnYHjX3c4/DX7Cv6loLA+c0hhHZ4jNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eWJHDeR6QJtcF9UlMyM8zCIBg6G3Ll8dyKjrb6dqnI=;
 b=ju8Wxz/ESV5bc2RscR/o+kwaE9u8FOGh/4+71vPjYUAQx5JkxJrYjx6INA0B3Zc5AIViyTLSGfI8g00Rqji6i6ZkMPhEvHM/7ZgiRki+Owl8Qiei3gjPdskc0B9CHfMkYgd1DGwn5D/liW4xIpEVL638HCGcvcoUYWRoo3aA/k+E0G+edfvk2SuBTKT+9gNtie30/+5WnT007B00RiDinF02vYs7xrciGsEdONL/+60PrZqLfgf0r5s39c33XWeSn57neAaXP9rH5uAwRZAh/WVJxa7H+6IMmKmyPeXFo0CzxS6/f0wUDSad3UTdvXFN+StI3COdsF7hZ08RL/zDzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eWJHDeR6QJtcF9UlMyM8zCIBg6G3Ll8dyKjrb6dqnI=;
 b=aQyaiaKljD99mQVVeE5VOR4VwZ1xYqUso3su5dUt5R8yA5z89UT5163/azFc3nEmVARSXPTR+ZfZIuWDOZIPWzlau2594DiovSaFXUfslp6Qz9XxihVwRzljEZ9b6nOVCW1n8DA4805lp1E8NbB/mHxdTV3UhfGyCdw6pR+bBl4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1167.namprd15.prod.outlook.com (10.175.3.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 16:38:02 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 16:38:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracED/kAgAAEv4CAAAEbAIAAHhOAgAAJBIA=
Date:   Tue, 20 Aug 2019 16:38:02 +0000
Message-ID: <574AB6C6-2F2F-45CA-8B91-8EEF3D8ADAC4@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <e7740427-ad09-3386-838d-05146c029a80@intel.com>
 <520249E9-1784-4728-88D7-5A21DFE17B8E@fb.com>
 <463379e3-5a31-5064-dd02-ea2fe149fa7e@intel.com>
 <CCFAB5E0-263E-4D9F-92A5-51922EF5998C@fb.com>
In-Reply-To: <CCFAB5E0-263E-4D9F-92A5-51922EF5998C@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:8c4e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58c1661c-aef9-4db0-5ea6-08d7258cc4dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1167;
x-ms-traffictypediagnostic: MWHPR15MB1167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1167C72512F2A511CFC23224B3AB0@MWHPR15MB1167.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(189003)(36756003)(102836004)(8676002)(6916009)(81156014)(81166006)(8936002)(33656002)(14444005)(478600001)(256004)(76176011)(50226002)(71200400001)(71190400001)(186003)(46003)(54906003)(446003)(6512007)(86362001)(53936002)(99286004)(5660300002)(66946007)(66446008)(76116006)(66556008)(4326008)(66476007)(64756008)(6246003)(2906002)(57306001)(316002)(6116002)(2616005)(476003)(6436002)(229853002)(11346002)(6486002)(7736002)(53546011)(6506007)(25786009)(486006)(14454004)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1167;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ti7tVvDdoPPZwQnMq8nfgHc9qd+NgaUwYGDGbpJIFwE0Gz7JAJuaFN/olMPELLixT4d1qmsfF4fkDbGwhU5XLjtCa+hKYxFUX449RYKh486u/qiXKMZpKfvHEUaFJCJv8tioGxC0LxrlC82IO3yfhzqgPk7y2abUKTP3OFbxI8kSMEn4N3ikMukqql/BU3u/JJpnxNUuNkF+udaJjIwvhSTFdxZQYGvo/XRazrBjMLhyfgNQmvGwoxfpDqOw1n6sd8P3N5MCcg4CnRp0wv8Lo8VHcMH5RFRWCmDyjfi0wDGzile1Y6f0TybN3BuZxIb7RY5yCC2pwB9zQ9e8S/4D+2sORc/KSjIKi1OyJI4/d2RfB9tIQkyB9sQP4jDYUmGUuyg1lJHm3Zzds7t0uPfgmCRpT1HIes7OupxoxyGhMKw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0645C8082917364CB2B8EEFF23E90863@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c1661c-aef9-4db0-5ea6-08d7258cc4dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 16:38:02.3245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGlMrbVpuTjQEc9qMvrJfr1zpMNac6VEXSXM9KFRxZyGZyiMn9rSQ3s3/F/7mHrj4boss1hyMDkPVN6WgnL5qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1167
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=934 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200152
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 9:05 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Aug 20, 2019, at 7:18 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>=20
>> On 8/20/19 7:14 AM, Song Liu wrote:
>>>> *But*, that shouldn't get hit on a Skylake CPU since those have PCIDs
>>>> and shouldn't have a global kernel image.  Could you confirm whether
>>>> PCIDs are supported on this CPU?
>>> Yes, pcid is listed in /proc/cpuinfo.=20
>>=20
>> So what's going on?  Could you confirm exactly which pti_clone_pgtable()
>> is causing you problems?  Do you have a theory as to why this manifests
>> as a performance problem rather than a functional one?
>>=20
>> A diff of these:
>>=20
>> 	/sys/kernel/debug/page_tables/current_user
>> 	/sys/kernel/debug/page_tables/current_kernel
>>=20
>> before and after your patch might be helpful.
>=20
> I believe the difference is from the following entries (7 PMDs)
>=20
> Before the patch:
>=20
> current_kernel:	0xffffffff81000000-0xffffffff81e04000       14352K     ro=
                 GLB x  pte
> efi:		0xffffffff81000000-0xffffffff81e04000       14352K     ro          =
       GLB x  pte
> kernel:		0xffffffff81000000-0xffffffff81e04000       14352K     ro       =
          GLB x  pte
>=20
>=20
> After the patch:
>=20
> current_kernel:	0xffffffff81000000-0xffffffff81e00000          14M     ro=
         PSE     GLB x  pmd
> efi:		0xffffffff81000000-0xffffffff81e00000          14M     ro         P=
SE     GLB x  pmd
> kernel:		0xffffffff81000000-0xffffffff81e00000          14M     ro       =
  PSE     GLB x  pmd
>=20
> current_kernel and kernel show same data though.=20

A little more details on how I got here.

We use huge page for hot text and thus reduces iTLB misses. As we=20
benchmark 5.2 based kernel (vs. 4.16 based), we found ~2.5x more=20
iTLB misses.=20

To figure out the issue, I use a debug patch that dumps page table for=20
a pid. The following are information from the workload pid.=20


For the 4.16 based kernel:

host-4.16 # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE      =
   x  pmd
0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE      =
   x  pmd


For the 5.2 based kernel before this patch:

host-5.2-before # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE      =
   x  pmd


The 8MB text in pmd is from user space. 4.16 kernel has 1 pmd for the
irq entry table; while 4.16 kernel doesn't have it.=20


For the 5.2 based kernel after this patch:

host-5.2-after # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
0x0000000000600000-0x0000000000e00000           8M USR ro         PSE      =
   x  pmd
0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE     G=
LB x  pmd


So after this patch, the 5.2 based kernel has 7 PMDs instead of 1 PMD=20
in 4.16 kernel. This further reduces iTLB miss rate=20

Thanks,
Song=
