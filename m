Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97760961D7
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 16:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfHTOBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 10:01:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729409AbfHTOBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 10:01:48 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KDw1So026017;
        Tue, 20 Aug 2019 07:00:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iM0mr5N+ad1TqY0TNnjkn+RN+LayFWmftemjkORCAZc=;
 b=TuRGeybVljcQjSniVsVbl/lngcQnGOWnBiN4zMKAFOhY/Frq0pfLPUvgp8FCdMa9FtFD
 yqNeG2lGc1XBVGqAkyoTteZW8EOhuZmnpL8ydfnP2gIBpz+LxkSQw6/sdP57xNb7OntX
 L7O79B6Xv9yN3kJnr4aZfRQcD3yCXYQGxB8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ug6dyag0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 07:00:33 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 07:00:31 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 07:00:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlJo01UR6a6t9BsR5WWKDPfqz0hB5hf1GZ0wSL6jVcNz3V0ICXVTHO+XDppmIwdJHmCWzEEjvyBIGZtVsnJBdEQUKi7gdEDo8/OIPALNpQCsU1e5yfusnHtqpjWr6TzCZqRXGxfyD7Q4U+T4nBYhM8CGiscYTjVRrls8MsCr8FKPGEZYDXMTxc+slJsMrzGhsT+z0nNr2/vV1Vmd0lj1caEbeEE+M76/blToRgno2OUQ8hn4WggfYADdDYrH9zwmXn2p0jcWz0K3qzRzUHXSMBi6ogX9yzqNry3ngXANKPSafkY68IGMQG5v16JsRDtIUKqEBHVZ+99hoHn+xME4hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iM0mr5N+ad1TqY0TNnjkn+RN+LayFWmftemjkORCAZc=;
 b=kgwafX0blhmQuhUjYdgvO40f8UJkdT/N5ToUbfhqtjJeZ4PeXpU+LtrrlIrnak8iPE/I3HvVYTAsQgmapcggn/U4MuxNz+sEMkXWLDC7uB6vlj+mGJXqXe4i5iFyjr+YTRP8cGTcFs/yIo0kEOFt7ojmOWkg0GT5RDCYybT5hL3P/UAP4zAvggb69MzGwVkKvjP0SBbvyGPOpwAhQAlTIxWbkCGVURo9pBTmolxZP8rLPd8ZDrTxy9WgjBxR7EhK7WVb7OsUe4fkpPoGdzwIHZZiuNw3L0HbWH5WRtjXAGuzoXkMlNkPyZM2Th5f3oHc4W4q6rOh5PvjVyYYLA3NaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iM0mr5N+ad1TqY0TNnjkn+RN+LayFWmftemjkORCAZc=;
 b=XmmDxI9G4fyuCZcRo5RenPxpq7U+4xFgKUxDPNnf/Dnc2iipU78c18bb96BTcUvn6VLnGJY8Gz+ObxobwXO2Dl05rtjOIiQSjKH2LaCM5Vm3/X4RMf1pozGKahp7b+HmD3PiKdEgMWHqnGm4tMN7hhJsRx7v51bSSnwmy5irmhg=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1360.namprd15.prod.outlook.com (10.173.228.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 14:00:28 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 14:00:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Rik van Riel <riel@fb.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr by
 PUD_SIZE
Thread-Topic: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracDzfeAgAAVLICAACLjgIAACZyAgAABQoA=
Date:   Tue, 20 Aug 2019 14:00:28 +0000
Message-ID: <9A7CA4D3-76FB-479B-AC7A-FC3FD03B24DF@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <20190820100055.GI2332@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
 <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
 <d887e9e228440097b666bcd316aabc9827a4b01e.camel@fb.com>
In-Reply-To: <d887e9e228440097b666bcd316aabc9827a4b01e.camel@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f412]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfedf659-b890-47fc-1612-08d72576c1c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1360;
x-ms-traffictypediagnostic: MWHPR15MB1360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1360FB1E72A5B60607F534C2B3AB0@MWHPR15MB1360.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(376002)(39860400002)(366004)(199004)(189003)(37006003)(66446008)(71200400001)(71190400001)(2616005)(5660300002)(446003)(66476007)(76116006)(11346002)(66946007)(64756008)(66556008)(54906003)(8936002)(14454004)(256004)(7736002)(102836004)(57306001)(186003)(316002)(53546011)(6506007)(25786009)(2906002)(486006)(305945005)(4326008)(476003)(86362001)(6636002)(6246003)(6436002)(6862004)(6512007)(50226002)(36756003)(229853002)(478600001)(6116002)(99286004)(8676002)(81166006)(81156014)(76176011)(46003)(53936002)(6486002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1360;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VnJ54wmupu4GduVjJC6otOTI0I6gGVshtqVbtrtReA9rl14MrO/pSH3rw2sZYSzvt0u699wI5k+ftwd1koW9qqhrIZxlRXPWKznqR+rrhJUCcrrGQD94FpcpSVGs7ftG0VNpKhlfYtwJ9uqGs4l4Kep82s61sjfQXxvRcfevUeXzaZ9W6lGMz5oWUd0Uwr2el8ub7A8WY9umnA36cnUs9ylFbfwN/KpnEcVDTwT/EqmtjFpupkyv/OXrAte3+h2oeLU0tX5hNSUn0JGhpQNO0mEL/nBlhjoUY9pWtSxiiNvuDFLcs1lTSNLUf0Ojp3CEVbk8gnYhoICuNOqXaRrWco8z4I5voa1eNUTBK/UMojfXTMchPi2mBzkqRuzNTSN4+bgofyOcVcp89zlIPB9x9zu60OMWAKC/F0TDR6MsMP8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF963077D262464DA0DF84381F93EDD6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bfedf659-b890-47fc-1612-08d72576c1c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 14:00:28.2136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uZHIcvMa26nqAlwGbDN+NZ/E6UXCUJQDoty9WcZD/gfdn7ZRVwQ6cKFlYhMJ9Vyf9Ru3gm5UvvVoozRa20/38Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=908 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200143
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 6:55 AM, Rik van Riel <riel@fb.com> wrote:
>=20
> On Tue, 2019-08-20 at 09:21 -0400, Song Liu wrote:
>>> On Aug 20, 2019, at 4:16 AM, Thomas Gleixner <tglx@linutronix.de>
>>> wrote:
>>>=20
>>> On Tue, 20 Aug 2019, Peter Zijlstra wrote:
>>>> What that code wants to do is skip to the end of the pud, a
>>>> pmd_size
>>>> increase will not do that. And right below this, there's a second
>>>> instance of this exact pattern.
>>>>=20
>>>> Did I get the below right?
>>>>=20
>>>> ---
>>>> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
>>>> index b196524759ec..32b20b3cb227 100644
>>>> --- a/arch/x86/mm/pti.c
>>>> +++ b/arch/x86/mm/pti.c
>>>> @@ -330,12 +330,14 @@ pti_clone_pgtable(unsigned long start,
>>>> unsigned long end,
>>>>=20
>>>> 		pud =3D pud_offset(p4d, addr);
>>>> 		if (pud_none(*pud)) {
>>>> +			addr &=3D PUD_MASK;
>>>> 			addr +=3D PUD_SIZE;
>>>=20
>>> 			round_up(addr, PUD_SIZE);
>>=20
>> I guess we need "round_up(addr + PMD_SIZE, PUD_SIZE)".=20
>=20
> What does that do if start is less than PMD_SIZE
> away from the next PUD_SIZE boundary?

Great point!

>=20
> How about:   round_up(addr + 1, PUD_SIZE)  ?

Yes. How about this?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D 8< =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

From 9ae74cff4faf4710a11cb8da4c4a3f3404bd9fdd Mon Sep 17 00:00:00 2001
From: Song Liu <songliubraving@fb.com>
Date: Mon, 19 Aug 2019 23:59:47 -0700
Subject: [PATCH] x86/mm/pti: in pti_clone_pgtable(), increase addr properly

Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
This behavior changes after the 32-bit support:  pti_clone_pgtable()
increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr by
PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate because
addr may not be PUD_SIZE/PMD_SIZE aligned.

Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
in these two cases.

Cc: stable@vger.kernel.org # v4.19+
Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bi=
t")
Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/pti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index b196524759ec..1337494e22ef 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -330,13 +330,13 @@ pti_clone_pgtable(unsigned long start, unsigned long =
end,

                pud =3D pud_offset(p4d, addr);
                if (pud_none(*pud)) {
-                       addr +=3D PUD_SIZE;
+                       addr =3D round_up(addr + 1, PUD_SIZE);
                        continue;
                }

                pmd =3D pmd_offset(pud, addr);
                if (pmd_none(*pmd)) {
-                       addr +=3D PMD_SIZE;
+                       addr =3D round_up(addr + 1, PMD_SIZE);
                        continue;
                }

--
2.17.1


