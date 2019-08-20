Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415BC965D8
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfHTQGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:06:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726717AbfHTQGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:06:06 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KFnobm004554;
        Tue, 20 Aug 2019 09:05:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=If66QaEQSLNceea86j1WT0DnyltAlVduRJVfmvuWcdw=;
 b=B6Ic+tmreSTmrXXIGC1TcnQQvQMgKTBNv4wZ/B/ssUqXUaspyh4AiUUikw0eKRTZbwSB
 DA8zqF1hoOXMpotYC31dNqvupIwztLqZTlr1aa68KZQaBXQsoURzlwlL5Q3/TGcrKBZu
 6+bxW0UpGwSX0rHSQqQeXumQYE0hEy0pMZ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ugjxd8ccw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Aug 2019 09:05:48 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Aug 2019 09:05:47 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 09:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GECa1CRLsxEHC3EFeW5xTK6NPsmm+Xor2qhHHe8ovmT4vTMS+OlR1cE7mQyJOIUYoo7rHsd+ZB+RMnBeEBckadPwIlxsvJcmUn3dg3X81vkmLyrA5HIKEqqvO/sl/0JzXrqDPAYCjJiWXaBhFylgNN0BD78Ivare/z9VQuzf/3L4HJde22wWp8/tt0QkFm6EyDOCP9oyvNAywZorXJvOeSt1RMntmYmyWLr37nuabik5A3v5VdAv4ooNXh7b3oLEtdJJoqCN1yWp0kT0hPQhbb2TIGKUcxgoTX+MZKmZM2CmS6XFXOKUjQ4EeQAcmiI2fc/2q9hMHn9dXaJkMhMnvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If66QaEQSLNceea86j1WT0DnyltAlVduRJVfmvuWcdw=;
 b=LKLSz3V/g7NUtsMDE9s/ekoiknB5EpUzowZIsfRAesIRUqHBuu7E8jVSPjruHhIc6YWNVmu0DU0sZeBwYMHyG6BihFpX9WPPk47drQtxsx1hfE4wkNC9o4LzJFxRNVlzOJjFbTK4KiXAH+/j7a4VcPKruU2NOwjW0YUXz2rS5N8nucsnOnI8FsB2t4hFshRZ6LmFOrvGF/EKIBTVNUgO304XD1GtOUkILJTJZ81gUCyDM05urBKNBIjwsQ9YTBC5/3xzahZmm+SRuqs2tUnqXTgs6DmzeSaheKGPoVRejesYOA4jD5hlvjxI/0NxtIE7kpLzutK0vq/EI5WV4Am2/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If66QaEQSLNceea86j1WT0DnyltAlVduRJVfmvuWcdw=;
 b=NY226oIEy4+x2AaUG3sRP3Ypjlk5tTBkS6qzWnBnXa7h8hrLL/jfsJ1hQOQmJpwvSMnlVsjM3hSC4NsgCRL73BpFojui/rbDqNsDfCOvYKNM4how21UyGHlRPLEsE/sAwpHu94CZMhXXF/OHaZW3aUOTBWUvxrBZXr2b3cES3mo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1375.namprd15.prod.outlook.com (10.173.233.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 16:05:46 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 16:05:46 +0000
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
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracED/kAgAAEv4CAAAEbAIAAHhOA
Date:   Tue, 20 Aug 2019 16:05:45 +0000
Message-ID: <CCFAB5E0-263E-4D9F-92A5-51922EF5998C@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <e7740427-ad09-3386-838d-05146c029a80@intel.com>
 <520249E9-1784-4728-88D7-5A21DFE17B8E@fb.com>
 <463379e3-5a31-5064-dd02-ea2fe149fa7e@intel.com>
In-Reply-To: <463379e3-5a31-5064-dd02-ea2fe149fa7e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:8c4e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17687d25-8bfe-44ac-66d7-08d7258842a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1375;
x-ms-traffictypediagnostic: MWHPR15MB1375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1375EAEE82A13D6D8F976C53B3AB0@MWHPR15MB1375.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(39860400002)(366004)(199004)(189003)(102836004)(478600001)(71190400001)(14454004)(71200400001)(99286004)(76176011)(14444005)(66946007)(4326008)(81156014)(6486002)(64756008)(76116006)(256004)(66476007)(6512007)(8936002)(229853002)(25786009)(50226002)(6436002)(81166006)(66556008)(66446008)(8676002)(186003)(5660300002)(486006)(6916009)(53936002)(6246003)(446003)(57306001)(6116002)(2906002)(6506007)(53546011)(11346002)(36756003)(86362001)(54906003)(46003)(7736002)(305945005)(316002)(33656002)(476003)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1375;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tn3iLESiiYjG3cDAVp5aNItL2nXW/8uloVv8gwCmGjwOM8hxZO82akiOt6sWDGmu7FIsg2utk3JVa/fVyoF17BKYFV3Objbw7q28M1t+L3YvZ4IJn9KHXYc+XrpqkGBlsbARkvzKmLCn5DIHdY0RfqnM4rmREF4PZje65mGfUTTAmgbsvGs11keZg6J9P3qMniW4f1bLzjfDhPYB08+nXE6SVv8u8qtxF8PnQe4c6slv1fwjZ7MIgfTTAx7AkQkVBLtAcHt5ntJqmGaX048z5P9hEF8S4uolkc1wgDZO/ra/TEtJ8/mgplK9189d1DtURxtfj8XPQ+3ekngep0z19Vfjjk/64kLwa1t7fISTUAISU086tUaZAi0vet9ywIqQ+JHzuxf/vO8xjFKQNupokzgsy4j8cTMLoMKOGn0TcNI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <867AF1B8D022F5428B01A990A62E7921@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17687d25-8bfe-44ac-66d7-08d7258842a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 16:05:45.8306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nQrW9FRZRlJ28bU4lcVACMJsXNDpHbMOJyuM1OBHkIpPUEAMs7GRx6wKGwWduTulAsouySMfIs4j2IdelCvm+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=862 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200149
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 7:18 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 8/20/19 7:14 AM, Song Liu wrote:
>>> *But*, that shouldn't get hit on a Skylake CPU since those have PCIDs
>>> and shouldn't have a global kernel image.  Could you confirm whether
>>> PCIDs are supported on this CPU?
>> Yes, pcid is listed in /proc/cpuinfo.=20
>=20
> So what's going on?  Could you confirm exactly which pti_clone_pgtable()
> is causing you problems?  Do you have a theory as to why this manifests
> as a performance problem rather than a functional one?
>=20
> A diff of these:
>=20
> 	/sys/kernel/debug/page_tables/current_user
> 	/sys/kernel/debug/page_tables/current_kernel
>=20
> before and after your patch might be helpful.

I believe the difference is from the following entries (7 PMDs)

Before the patch:

current_kernel:	0xffffffff81000000-0xffffffff81e04000       14352K     ro  =
               GLB x  pte
efi:		0xffffffff81000000-0xffffffff81e04000       14352K     ro            =
     GLB x  pte
kernel:		0xffffffff81000000-0xffffffff81e04000       14352K     ro         =
        GLB x  pte


After the patch:

current_kernel:	0xffffffff81000000-0xffffffff81e00000          14M     ro  =
       PSE     GLB x  pmd
efi:		0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE=
     GLB x  pmd
kernel:		0xffffffff81000000-0xffffffff81e00000          14M     ro         =
PSE     GLB x  pmd

current_kernel and kernel show same data though.=20

Thanks,
Song

