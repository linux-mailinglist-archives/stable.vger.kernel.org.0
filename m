Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B39D250
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfHZPJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:09:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5342 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730995AbfHZPJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 11:09:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7QEoge2021842;
        Mon, 26 Aug 2019 08:08:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=E9gLohgp+44EL1sJIgx684fogNDAXGwjtAE5greLQUk=;
 b=AhtZPSaceaDn+NePQq6CNmP+2Og3PfpyBGQG+RDKYQsWlVMC/EM4xftCo3kH3OKacFqp
 eiOcIB4o8PiOq/hBo6uJcQX0254NjyfZtHs61Ro3lBNLExJoJuUa22odLpV+s19Knuf8
 tMiPx3gtSC7xSSIbr8MjOhJ66OOrPphB4mM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ukmwdmhmf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Aug 2019 08:08:48 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 08:08:47 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 26 Aug 2019 08:08:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4rC90ZQJpdHORUvK+LcFrmAWpOOKUNDeKJY6wIXf11SJz81UOgOsy8uGevEGZvzAN3Aq10kSWV5IXuiqWyuqidkvF5yC+znUw47b7CawwXsJ2GuNg4pgqIhgJYVSobR98tbtieC6cMvtS6FydtTvWHP2EGYSQlJRdt7LSBmuuBiRyJHZgSwcZrdzxrIije7Yw7763bRTBq6dw340WxSYDXnXucCfTvutE1Z9adf165mgphzHIdhkgSpS5U36ZaSZ6+dnR8jRV/ib8cZXUI0wfL0Gfj4KZ8npzjAHAg9rFiCcu/Bjkku5BprspvCH6PCeQYcpfRFQuSyu9Sa0WiUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9gLohgp+44EL1sJIgx684fogNDAXGwjtAE5greLQUk=;
 b=Z93lo2wFMcL4ia+6f4RRQf0x5iv8ecmxvqCq9AXy6EjoU1IXTfRgB+OeCP8j6bXKUwTu53DOA4so7T1VYhpXYVSbAPYGj0uolNfAwAI1SyR9+fsbRg9vnfyDyEC39sGAC9Fog4mfIgCn/kDdC1gw1klwIKewlGnAAdS8GdPyGyyUh+dnooDhVKPUXlzVNJzeHvw295DZ2T0XrdIRF3loEJ4ojUJvXuGF5ZzyysQ34B545Egi9pN2/jgypajE7xPD9uCSzU8f4JgM1K0Qd7xhXMkvtu/65seAosCFZd7Tjmieof1fh+VI1twbBebJfNXzteFRABcfJHBCdcQ9IBRxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9gLohgp+44EL1sJIgx684fogNDAXGwjtAE5greLQUk=;
 b=TlbDVYRdZYViEQO5uLnpov9fbnnxnpWlWQ12xmhmShKa6PLbf9YatEjv8+x8+WpNisluC50ibpPTFhFkCjExONp79AZH5NKQ55PYGl/bXjQuIZ8LHYNzw/7hHsnq3NtyfSYzp6kP4pAjZTwlDx7B+VXNPO7N2d/E7PS0F1STk4E=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1536.namprd15.prod.outlook.com (10.173.233.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Mon, 26 Aug 2019 15:08:46 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 15:08:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        "sbsiddha@gmail.com" <sbsiddha@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Topic: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Index: AQHVWXL45hcGbMxBFEmxITCR8fhmlKcIeZ6AgARkOQCAAE74AIAAYJqA
Date:   Mon, 26 Aug 2019 15:08:45 +0000
Message-ID: <0A94F7AA-7ECE-4363-B960-41F644CFE942@fb.com>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
 <164D1F08-80F7-4E13-94FC-78F33B3E299F@fb.com>
 <20190826092300.GN2369@hirez.programming.kicks-ass.net>
In-Reply-To: <20190826092300.GN2369@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::7fd4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b54e8fd-50dd-4050-27a0-08d72a374ac1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1536;
x-ms-traffictypediagnostic: MWHPR15MB1536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB153626214FB065B39E7F91FDB3A10@MWHPR15MB1536.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(8936002)(76176011)(81166006)(81156014)(8676002)(7736002)(36756003)(2906002)(6116002)(305945005)(86362001)(66446008)(64756008)(6486002)(2616005)(6916009)(50226002)(76116006)(229853002)(66556008)(66946007)(6436002)(46003)(71190400001)(71200400001)(57306001)(478600001)(186003)(14454004)(66476007)(14444005)(256004)(54906003)(33656002)(6512007)(53546011)(6506007)(99286004)(446003)(102836004)(5660300002)(4326008)(53936002)(316002)(476003)(6246003)(486006)(11346002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1536;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 92gs5wxDamNmmcF/tm3tO+xCps87zZ0l7VCNA7CELPxM+LJVr28ps1xZuMSOrHMQV6GpgXLcsPoXGD+PmZxjoLdTx3nydN1/6sJlLLxkzcvrYChrnp3JOHPIVqCr3JdaEBApEYsvCqK1wiu2OzwhOMnxOAXiG40inqKg/idCwBq7Cxngk4amV31Ch50AUEpsxNql2/I2IcGyU+bG/4cRvW4nocp3YrXZpc2GLCmSrai4fuo3o7psIYxNeBwVpF8nKpaq0cB+r+AXyPA8EDurTxlULuGvPokzgVu2YleOZMC/a65qatnzHtqQB5nyuyztbRkb2/vkOdrdspwMJ303HU0HciXa2Z2pK3yFakC87rpqSA7D2L+aH3aLwQuaK+fk7//HzpzBbecncREBE+F2JttvxA+NY/YBXtxTEe65n2Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <544B2A942A90EF4A8BFB49C5319B6FFC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b54e8fd-50dd-4050-27a0-08d72a374ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 15:08:45.9935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CdJWB4hsMqn+CxTrqafmUBWNfkk6CWqeZe6c8GCQv9GbbewVBl9+Iby4CavHr0y13wpqo9Lsvhw5CIQIDmsFrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1536
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_08:2019-08-26,2019-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908260157
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 26, 2019, at 2:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> So only the high mapping is ever executable; the identity map should not
> be. Both should be RO.
>=20
>> kprobe (with CONFIG_KPROBES_ON_FTRACE) should work on kernel identity
>> mapping.=20
>=20
> Please provide more information; kprobes shouldn't be touching either
> mapping. That is, afaict kprobes uses text_poke() which uses a temporary
> mapping (in 'userspace' even) to alias the high text mapping.

kprobe without CONFIG_KPROBES_ON_FTRACE uses text_poke(). But kprobe with
CONFIG_KPROBES_ON_FTRACE uses another path. The split happens with
set_kernel_text_rw() -> ... -> __change_page_attr() -> split_large_page().
The split is introduced by commit 585948f4f695. do_split in=20
__change_page_attr() becomes true after commit 585948f4f695. This patch=20
tries to fix/workaround this part.=20

>=20
> I'm also not sure how it would then result in any 4k text maps. Yes the
> alias is 4k, but it should not affect the actual high text map in any
> way.

I am confused by the alias logic. set_kernel_text_rw() makes the high map
rw, and split the PMD in the high map.=20

>=20
> kprobes also allocates executable slots, but it does that in the module
> range (afaict), so that, again, should not affect the high text mapping.
>=20
>> We found with 5.2 kernel (no CONFIG_PAGE_TABLE_ISOLATION, w/=20
>> CONFIG_KPROBES_ON_FTRACE), a single kprobe will split _all_ PMDs in=20
>> kernel text mapping into pte-mapped pages. This increases iTLB=20
>> miss rate from about 300 per million instructions to about 700 per
>> million instructions (for the application I test with).=20
>>=20
>> Per bisect, we found this behavior happens after commit 585948f4f695=20
>> ("x86/mm/cpa: Avoid the 4k pages check completely"). That's why I=20
>> proposed this PATCH to fix/workaround this issue. However, per
>> Peter's comment and my study of the code, this doesn't seem the=20
>> real problem or the only here.=20
>>=20
>> I also tested that the PMD split issue doesn't happen w/o=20
>> CONFIG_KPROBES_ON_FTRACE.=20
>=20
> Right, because then ftrace doesn't flip the whole kernel map writable;
> which it _really_ should stop doing anyway.
>=20
> But I'm still wondering what causes that first 4k split...

Please see above.=20

Thanks,
Song

