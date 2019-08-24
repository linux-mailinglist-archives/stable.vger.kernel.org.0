Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC159BACF
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 04:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbfHXCLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 22:11:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725782AbfHXCLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 22:11:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7O29AWS000814;
        Fri, 23 Aug 2019 19:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B6RAgp2ZI3KYJOP7A4Gt07ypNEdiUCe3nrDAkBswM1A=;
 b=d/JUjQdizG9tSbN8qh+mnW0P0c+Asr92OqoAZwygNXVtjJTjIozztGsW2RW+UCIZ0598
 bL3uQ4i9Bg6Mt81o+MLNS1BPWAP5LpbsJj7YpkxyUGmt02t0IYbTIn17ncBmnLLyK1B4
 SQCfi+3pxUFWuPdUzfkD8HAPLMi+pV1n2fM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2ujmxmhnpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Aug 2019 19:10:17 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 23 Aug 2019 19:10:16 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 23 Aug 2019 19:10:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpyLj7i0tMZvwrxHXSHdl5FpSxIp6KrsYXx9sTDVnC22UbHQMcXj0w46SaBGuL++EC35bWVaqldChkZHF6mAQwjmXoQP2CStJRRmUoXKXOaFDU/67r2rl3AA8cjOyxuCsHNfF3HMZhF94M+nOUTCovez5cuN3BfyFjI6FJq5gYvAQGexrapVCJu9P7WK7V6xGRYADlNXlMUclXsBLCRaNFLjTClH78muFvSaKB/B4c4F3vGmrXkZ0smFHEhbRLZk8qyXasV/JredG8C4+qB172r9waL3rt0OSJ9AGjBplJ2ifmS/1DKJYKFzeIvN3MH4CeOgx1oAAxc1K0hCH4KO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6RAgp2ZI3KYJOP7A4Gt07ypNEdiUCe3nrDAkBswM1A=;
 b=WvIEhNW6Ezd+qhnw+0JNCwlLnn6O5AKXBBM46RD5bmN/lS68KsnIBAFBZA6vPFly2xB3oN3beuR8hWKdB2zHo40yv8fSLn2q5jDK5KcOSRDLPpoHwYLe853IALCNW3EbupHhCfS03SAAf5BFeXcxGEXni90VGQzxmc3dW2rGFivcHO/Hq2C9jtPApr4JcCg6PuMPziDIcNxGiWHpVh2PyhWhqaaVLy4CxOwCqCAMP5uGMIE5/29J9Efv7VLoI44vDbb4pUS2oEvCZ9dY20ELtRP0lnmEm5lJtUwltCA+JiNXDguwQyFOXlI03lgCtg6MsmYnZslhFkUZ3PEzLwmg0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6RAgp2ZI3KYJOP7A4Gt07ypNEdiUCe3nrDAkBswM1A=;
 b=Ri7W6rQRov566hC2RC/Ack5TmHx2GqzcIe9ju74O1Li32+/vgyr+HCbHfd+OYZr25L2T/SlJqU0EDNa0a3X04Eb9hhIv/5CcUMdKfsqt+d6OEHdLhei5NO7LSkfygjImbWYrwDCLhIoPrSbd/M0q5huVIByEk0FTcivHPl2WDe8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1552.namprd15.prod.outlook.com (10.173.229.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 24 Aug 2019 02:10:01 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 02:10:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Topic: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Index: AQHVV5U99G5SsRzRUkunOQ/1Fd5gD6cFWfUAgAAKAwCABBs5AIAAE7UA
Date:   Sat, 24 Aug 2019 02:10:01 +0000
Message-ID: <7DB70388-174A-4948-9CAA-4AE582F6FB53@fb.com>
References: <20190820202314.1083149-1-songliubraving@fb.com>
 <2CB1A3FD-33EF-4D8B-B74A-CF35F9722993@fb.com>
 <alpine.DEB.2.21.1908211210160.2223@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1908240225320.1939@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908240225320.1939@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::5e10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 398fe2b2-4286-4c6f-22bc-08d728382c1c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1552;
x-ms-traffictypediagnostic: MWHPR15MB1552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15520342149A94A7EC00D4E7B3A70@MWHPR15MB1552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(39860400002)(136003)(346002)(366004)(396003)(376002)(54534003)(199004)(189003)(53936002)(54906003)(81166006)(229853002)(25786009)(99286004)(86362001)(8936002)(6512007)(64756008)(46003)(91956017)(66476007)(186003)(66556008)(81156014)(2906002)(66446008)(14444005)(256004)(57306001)(76176011)(305945005)(66946007)(7736002)(6246003)(76116006)(36756003)(6436002)(6486002)(478600001)(4326008)(71200400001)(71190400001)(53546011)(5660300002)(102836004)(6506007)(6916009)(486006)(50226002)(6116002)(446003)(11346002)(33656002)(476003)(316002)(2616005)(8676002)(14454004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1552;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wOLUPp8K+ppVRDLTo/1Lt0agGVhlALQoOGKLdcAPFzyXouW0VPbTDYNESkx9FhAGAz4YcWDrEmTr7fV84gVItc3hCYj26NP9yPOocyBgntDoU32ReJbbjhEXfNjlWIb54bjPGtOmGson4d9g+OquP+uFcq5Tpsm1vfCyFE5JyRlWWsxzoYt7f1AyoV/uAsVq9Q27mqtIj7rEN6BSYcm1tNteI264/C/62OUnXGn5ch/RbObr3rhPQwOajUTUVoL1Ega4P5NmoRR65kKW/oJkYg5RVp7Euew1TlIUT9g3gemd/7sdAyIViJ8wa/V6krGsSgTmFCAChB8bj1JygmgGDiz+OnRqw9uIln0d7340HqZpzQMEFT5Mkqs0IOyWMfeghwe/Uw+ouQH/dxXiI8zKR6lNisXwjBihRlgf5sKoeH4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C49493F0BC3DC4C95744E1AA0A0AED7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 398fe2b2-4286-4c6f-22bc-08d728382c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 02:10:01.6826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ArzZouWCNxVQph1TyU9lf1d0WyIvl27ay5dJiLXCfxV+79B5rSGVuO0vSKgfWngEnljDKwrCxEO9MpTZR/ylmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-24_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908240022
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 23, 2019, at 5:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Wed, 21 Aug 2019, Thomas Gleixner wrote:
>> On Wed, 21 Aug 2019, Song Liu wrote:
>>>> On Aug 20, 2019, at 1:23 PM, Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
>>>> This behavior changes after the 32-bit support:  pti_clone_pgtable()
>>>> increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr=
 by
>>>> PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate becaus=
e
>>>> addr may not be PUD_SIZE/PMD_SIZE aligned.
>>>>=20
>>>> Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
>>>> in these two cases.
>>>=20
>>> After poking around more, I found the following doesn't really make=20
>>> sense.=20
>>=20
>> I'm glad you figured that out yourself. Was about to write up something =
to
>> that effect.
>>=20
>> Still interesting questions remain:
>>=20
>>  1) How did you end up feeding an unaligned address into that which poin=
ts
>>     to a 0 PUD?
>>=20
>>  2) Is this related to Facebook specific changes and unlikely to affect =
any
>>     regular kernel? I can't come up with a way to trigger that in mainli=
ne
>>=20
>>  3) As this is a user page table and the missing mapping is related to
>>     mappings required by PTI, how is the machine going in/out of user
>>     space in the first place? Or did I just trip over what you called
>>     nonsense?
>=20
> And just because this ended in silence I looked at it myself after Peter
> told me that this was on a kernel with PTI disabled. Aside of that my bui=
lt
> in distrust for debug war stories combined with fairy tale changelogs
> triggered my curiousity anyway.

I am really sorry that I was silent. Somehow I didn't see this in my inbox
(or it didn't show up until just now?).=20

For this patch, I really messed up this with something else. The issue we
are seeing is that kprobe on CONFIG_KPROBES_ON_FTRACE splits PMD located=20
at 0xffffffff81a00000. I sent another patch last night, but that might not
be the right fix either.=20

I haven't started testing our PTI enabled kernel, so I am not sure whether
there is really an issue with the PTI code.=20

Thanks,
Song



