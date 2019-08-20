Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653A196229
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 16:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfHTOOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 10:14:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729803AbfHTOOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 10:14:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7KEBa12030051;
        Tue, 20 Aug 2019 07:14:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EwFN9YOHUTCQbCa6oovMNvAqHxlkw9CBt9iQ+FEWKpg=;
 b=SzXPZGectzS9ajlq4ee7jMCKfu+cWQ8lBg23NsxIRa6ylhQUXI86pTu4l4YhWZZBW9QN
 bBUXnFQkimH9cxk96mG4zgLI+MvVaatjFSy6bUWhKmP/bBBhRg1PwKzHvUGVUaLevVNb
 JO0gZdOaiBH2KqnkSTXcQDFvlBOIJnWsqOw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2ugebqh1ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 07:14:15 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 07:14:13 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 07:14:13 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Aug 2019 07:14:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/Wz3QWj5gpLvUnFXA+DKRW6rBSW7AxTksavKxdn6FuTpyawxwNzWNqhLm5RUbWM2O5NgiIY4fSXcEgQ2Q+SpmnXD6NldYDPJya2m55r9EbO2hcD/e+DGj4VUuAJL6u96eLE5p57h405h2r0qr+xkpferJhX9Fd7gtcXyrhFrjB6Y3SfQOiMdaPZlZfM4mcPnJ8oP/4LmjcrriZ1XupHZSUbyew5KaHsEvgkuPcKD29HGRkNUMxdO+JWCCmAeEvCXkYMtypLN0mvEojk2y4frq0bgWm2qjvl51r6ZtOTnzBQetgh6NeattkW7NAYmFNFaTpSH2fys8D9QAq1QTKGWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwFN9YOHUTCQbCa6oovMNvAqHxlkw9CBt9iQ+FEWKpg=;
 b=SFz25CofPc01JHB6SzxWjZiuIRnigSnwS/5UVqc64rl6txegSVUzWLZGSM6DF5jkr0qCxlQu7mDKMPvZhsVQ+IXSK9fKS36II6sOFCs5xBfbEIBJmUj+hMMoh+CgMS2+1vw/KdUkFl4OXCHuIxMEH9EX6JLtycUIGze2i7yB5T8XsYqMQhf3iVAYjuTmGGEnov7vloyTzFM1l3EPq4uxJFwY2lsBAiSWpLbIJCI/hGGfzYX6NThK7PnobViK3FWp3hVWr0kKioE8BMECXj4I9p8mJCFvKnqujrj4i/civEWIln8/YUeIkneutc3AMuO/hqqk7v36xe4Pc7MwJXRHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwFN9YOHUTCQbCa6oovMNvAqHxlkw9CBt9iQ+FEWKpg=;
 b=SQBh/onts2OlV4Jw1/2yPBhR7o2rNEJPmOBxrPVGm676qyxy+CJ+qN9ySeWLcHzVpLHRURzN6Y4H8JXG/p5zcDhsB7d2yox9zrC/3ZQ+nb79E3EjBz9XOjsk4cCc6+YQLwt1e4gp7EXA+Ai2PRLKV+w6bchMAqZ3mjj+71AQVh4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1519.namprd15.prod.outlook.com (10.173.234.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 14:14:10 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 14:14:10 +0000
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
Thread-Index: AQHVVywgQMe0L9XqWkSJYmnWEvsfracED/kAgAAEv4A=
Date:   Tue, 20 Aug 2019 14:14:10 +0000
Message-ID: <520249E9-1784-4728-88D7-5A21DFE17B8E@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
 <e7740427-ad09-3386-838d-05146c029a80@intel.com>
In-Reply-To: <e7740427-ad09-3386-838d-05146c029a80@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f412]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60626cab-ea37-4425-bd2c-08d72578abc4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1519;
x-ms-traffictypediagnostic: MWHPR15MB1519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB151928838FFBA1971C3F2EDCB3AB0@MWHPR15MB1519.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(39860400002)(396003)(376002)(189003)(199004)(36756003)(7736002)(99286004)(6116002)(46003)(14454004)(6512007)(6246003)(446003)(11346002)(476003)(2616005)(76176011)(6486002)(64756008)(478600001)(6436002)(76116006)(66446008)(66556008)(66476007)(66946007)(86362001)(8936002)(5660300002)(256004)(8676002)(71200400001)(71190400001)(57306001)(229853002)(486006)(54906003)(2906002)(50226002)(316002)(186003)(102836004)(14444005)(6506007)(6916009)(33656002)(53546011)(53936002)(81166006)(81156014)(25786009)(4326008)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1519;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LLBckdHH1xRpwM6uuDV8i3js6IwAWCvqTt0vbZKtj1CL8qSr+zYMwCyyMa3M/CH/bst8mgilRaF5w3Hh3I4pOpxXnAo7YtsH30h+54Gt38g2UilWWK+7kS9ljqJiBn/KdzKmnniDdJMFKITtW5e+gtw8hVbvQmbdayWlsGGcWqyNasV+G3M1ttY3YP7fJj95YbdKMAgDIPnC8K4kOGfjdxLSnZdmRhRNVP+i7psD4f9PGfl6DIX4V6qk877cfpzUyBpycdCXAtzI03lAtT6Wr63fnx/ZiV6XZRdmwL4cvxVD7oN+U9EOqZ1CpiITFBrxBdC7QpqETZd9iNsbs542buAJMxLuQkLU7zxyCVVICg4uhU74fBaBa8tUKHJoTjiZczo67J0LNXFFVI2mX1j8MMkuWUEWz+pmc0FFypE4CVk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79D026E569F0AA46B482192DD9973000@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 60626cab-ea37-4425-bd2c-08d72578abc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 14:14:10.2985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqzwCjLO1Elr0SE4H+Q94NsHuKHtJSLD6IsfWEB596pLdYurJDkknyjZhmQmn+MA3lHbaR/is7hWm9twvrN3cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1519
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=980 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200144
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 20, 2019, at 6:57 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 8/20/19 12:51 AM, Song Liu wrote:
>> In our x86_64 kernel, pti_clone_pgtable() fails to clone 7 PMDs because
>> of this issuse, including PMD for the irq entry table. For a memcache
>> like workload, this introduces about 4.5x more iTLB-load and about 2.5x
>> more iTLB-load-misses on a Skylake CPU.
>=20
> I was surprised that this manifests as a performance issue.  Usually
> messing up PTI page table manipulation means you get to experience the
> jobs of debugging triple faults.  But, it makes sense if its this line:
>=20
>        /*
>         * Note that this will undo _some_ of the work that
>         * pti_set_kernel_image_nonglobal() did to clear the
>         * global bit.
>         */
>        pti_clone_pgtable(start, end_clone, PTI_LEVEL_KERNEL_IMAGE);
>=20
> which is restoring the Global bit.
>=20
> *But*, that shouldn't get hit on a Skylake CPU since those have PCIDs
> and shouldn't have a global kernel image.  Could you confirm whether
> PCIDs are supported on this CPU?

Yes, pcid is listed in /proc/cpuinfo.=20

Thanks,
Song
