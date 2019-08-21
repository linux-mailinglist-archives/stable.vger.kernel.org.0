Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F323D97656
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 11:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfHUJl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 05:41:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39816 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726351AbfHUJl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 05:41:57 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7L9YD2w012827;
        Wed, 21 Aug 2019 02:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=o42VHbyDUPPXb+FoPBNLqvpvgcikuNKU//952EfbtNE=;
 b=mNOon8y/FS0/Ny14cIoiFqtKR/FEuTLCXWP2CMoROLmhXwcinCw0NrSbE/JDQjg+0Mav
 3USr1NCRhC0GgIIzSB4pwefzrGW7JiXYE8Jr/1m+4gQoCn3CsuUJqEMptNrQsMGAGOD5
 oanviPv5d94Re8STtpcsT4O91k9lxfK8g0E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugwkv17x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 02:41:32 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 21 Aug 2019 02:41:30 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 21 Aug 2019 02:41:30 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 21 Aug 2019 02:41:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkPkultL9XzXAk4o0CgXLYEZz5AFk7nePg4bcLO1W8jPEHRM+LR/uj/2EBMblLuzh8S2UXg930Fe1T/CeBayeUqz2Vc0PGtx+iePchRlb94ob5MNS5P9ntbYSxsin7f1GikasUuS0k4pfDCcw19nFlzyWwZvrEqDpQA2pn1YJ3wY4MMAm/C1sgmlzzRQnhi5BkJ/NPSHecxl/4djzKk6t3anAP8hk4YJjznbJ9oX9ILynHpHw5hb7buECcrHCOiDSlm4LezS7u2b6bBstH/ErWlJ9CqKpScMnI3fN/TxWyrVy0U4Tp991Nj3pC3sJr09t8M/d1IjvNVP1Li2AXedhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o42VHbyDUPPXb+FoPBNLqvpvgcikuNKU//952EfbtNE=;
 b=AoWomoXlPZv1e0Jrcps+yBw5lT+ynefn4t4OJy8CIn/KstyLauQ8piN2ivKe9z5xGE9Y5JgGmRCaTHwghL2t9GB52UKem4rxxYk9MODLJwMDcGr8iBejz1KIMPnOnQ9wuEzbdGsJmXumrJ9kxJh/yDz3c4R5xTEUFPiCY6tGY83uyQCqrMk3FiJ6M+bSsLQOSyW+ONLzjvg2T6pamybmonOg9VkX9F8gkngYKnKhzlg2y7r6+a/mmWPiUoKN9Y1JHBmhDCMHsr3qxC1vuQUkXSN9OAPNvBusixAxwOhpUMcUEEjsrZ/pLqKIBhTjsOGqnQP1umokozgvNDbkPS/bBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o42VHbyDUPPXb+FoPBNLqvpvgcikuNKU//952EfbtNE=;
 b=Y5D9B1zyOrbIaQmRJFSyzGPP1tfaZb06sQQG7hDHxSdkAvwqhoRSYJITiSIZw8QyfhoZd638RdnvOWVVBl5Sh5zEGOIQcnkG2iP+mlUv97SNOqlR4j9kBOkKFhNcuFJo233n5tOHmFhIIdg1HJ/okH3UZJGqERdwKN8NzbN+1uw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 09:41:11 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 09:41:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Topic: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Index: AQHVV5U99G5SsRzRUkunOQ/1Fd5gD6cFWfUA
Date:   Wed, 21 Aug 2019 09:41:10 +0000
Message-ID: <2CB1A3FD-33EF-4D8B-B74A-CF35F9722993@fb.com>
References: <20190820202314.1083149-1-songliubraving@fb.com>
In-Reply-To: <20190820202314.1083149-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1e85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93c80bad-9466-44db-ec75-08d7261bb347
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1216;
x-ms-traffictypediagnostic: MWHPR15MB1216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB121603C5D9558E6262029F0FB3AA0@MWHPR15MB1216.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(39860400002)(396003)(189003)(199004)(76116006)(25786009)(36756003)(305945005)(8936002)(99286004)(6246003)(8676002)(50226002)(81156014)(81166006)(6116002)(46003)(476003)(186003)(5660300002)(486006)(316002)(4326008)(2616005)(6512007)(11346002)(446003)(53546011)(229853002)(71190400001)(71200400001)(33656002)(6506007)(256004)(57306001)(86362001)(66946007)(66556008)(7736002)(64756008)(66476007)(14454004)(110136005)(54906003)(76176011)(2906002)(53936002)(478600001)(6486002)(6436002)(102836004)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1216;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K0CB9/QZswrXoiDIGBiAuWe/iH+3qBTnygGmLzvoLXd442z8sOJxXCOIx4OKNcgCMDbg/dY+sq/YiFgdQMZIMkftVB5YS7gzSP8kpX54lmAtiv3VsfOnCt7/8140hELLrLCUy8UZu9i+LkmrU6SecGiaaQvwSDA7f3o31HdTyjM8c9FtnDEccFLHWO/vZUmT52zfUjToyyZXR0EkjEEmPzn2zyK5sfbVi35AUZJKI2NJ0WcKP7kQb/E+RRL+qgvX7+ZHzkwgmFmYUxL3p1KIe4Rj/XmwASZJsZ4XGL1X8+CLahAoTooWdzcHKQXU6/grz9adqclN8b2M1p1per8BN1FMlfQBcidT5lISvcZqgvV0eVsJwDb5Lm8mm+7wOHz1VHz5sQg47NXhPX9P3bAxJCDRXgX/9V2Ygyf9y0QAN4g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90F8CBDA3A0B90419D79D6E22F965BF5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c80bad-9466-44db-ec75-08d7261bb347
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 09:41:10.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MdxfRrT1tnirpMD7F4X4fVc/NF9eA4reAHiWJxZXC3WGTTkk7xhHICB8NDbLQrC2ceyRa9oGIDLyaB1IoFYdtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1216
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=968 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210104
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 1:23 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
> This behavior changes after the 32-bit support:  pti_clone_pgtable()
> increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr by
> PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate because
> addr may not be PUD_SIZE/PMD_SIZE aligned.
>=20
> Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
> in these two cases.

After poking around more, I found the following doesn't really make=20
sense.=20

Sorry for the noise.=20
Song


<nonsense>=20

>=20
> The following explains how we debugged this issue:
>=20
> We use huge page for hot text and thus reduces iTLB misses. As we
> benchmark 5.2 based kernel (vs. 4.16 based), we found ~2.5x more
> iTLB misses.
>=20
> To figure out the issue, I use a debug patch that dumps page table for
> a pid. The following are information from the workload pid.
>=20
> For the 4.16 based kernel:
>=20
> host-4.16 # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
> 0x0000000000600000-0x0000000000e00000           8M USR ro         PSE    =
     x  pmd
> 0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE    =
     x  pmd
>=20
> For the 5.2 based kernel before this patch:
>=20
> host-5.2-before # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
> 0x0000000000600000-0x0000000000e00000           8M USR ro         PSE    =
     x  pmd
>=20
> The 8MB text in pmd is from user space. 4.16 kernel has 1 pmd for the
> irq entry table; while 4.16 kernel doesn't have it.
>=20
> For the 5.2 based kernel after this patch:
>=20
> host-5.2-after # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
> 0x0000000000600000-0x0000000000e00000           8M USR ro         PSE    =
     x  pmd
> 0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE    =
 GLB x  pmd
>=20
> So after this patch, the 5.2 based kernel has 7 PMDs instead of 1 PMD
> in 4.16 kernel. This further reduces iTLB miss rate

</nonsense>

>=20
> Cc: stable@vger.kernel.org # v4.19+
> Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 =
bit")
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
> arch/x86/mm/pti.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
> index b196524759ec..1337494e22ef 100644
> --- a/arch/x86/mm/pti.c
> +++ b/arch/x86/mm/pti.c
> @@ -330,13 +330,13 @@ pti_clone_pgtable(unsigned long start, unsigned lon=
g end,
>=20
> 		pud =3D pud_offset(p4d, addr);
> 		if (pud_none(*pud)) {
> -			addr +=3D PUD_SIZE;
> +			addr =3D round_up(addr + 1, PUD_SIZE);
> 			continue;
> 		}
>=20
> 		pmd =3D pmd_offset(pud, addr);
> 		if (pmd_none(*pmd)) {
> -			addr +=3D PMD_SIZE;
> +			addr =3D round_up(addr + 1, PMD_SIZE);
> 			continue;
> 		}
>=20
> --=20
> 2.17.1
>=20

