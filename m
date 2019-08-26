Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1509C879
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 06:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfHZElM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 00:41:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57266 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729100AbfHZElM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 00:41:12 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7Q4cIeS029297;
        Sun, 25 Aug 2019 21:40:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zJ3r1xpE1hsF0IqfRA2SlX19uMbsWKzwNPED8N3WqI0=;
 b=mnfoxMTXNVFkkNXuS/FZYJxyPHfk0p0rWCbu/eusBv19ZTgNHRkId+1IJS8XRdowS3Sw
 iY1TnGugZuFq+8dK42wlb7SliATzC7MR26rizKsk6KoEuXd8ZL6fRfFmL7kNvtfiuQpZ
 HXUlKJX885Yo5a9fMypD2u2d901WoYoYtbg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uk3sn4tex-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 25 Aug 2019 21:40:25 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 25 Aug 2019 21:40:24 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 25 Aug 2019 21:40:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3R1+XX8hdWi12W91Ht9KILS7RQIyP9+38UBSYDGjdtJOMCpfV6rtH2rC734CMbHzEwsI4mHuyPP9GqO8Czi276cqKsWag0WdW9tzIWeu/7x2GR4QRn/6wDkWmjgG+9rvTnFVwkbIbIxvWGqKt3tesTSMR9cBqarohm+EYEb5jHcbR0X1PDAJ4BnAB3xOzLr/FktFseCydUzEfVd4dk9c/ghqrM+fF9wwx2VVMRetKflHiTnzNvC2P2MAK/etDnAwR1bKHYkldndSEbnqaJPtOTqbT+//Rl8OT/Z5po2nENO+zmtHNSL6J5vF6QuYcJlNECjeaB7WvTBPrgVA7WyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ3r1xpE1hsF0IqfRA2SlX19uMbsWKzwNPED8N3WqI0=;
 b=NVSIhBzTkRPdhgVhBgpH6psTbGAAjZofu3SMfl9FOaHOpoS7cqTnYmMBBoHgJXEhboeCk+TGERwMKTz+HirpvNcLunHvHWQsdLEUdChLa6UhzKwIz2MFa2oOiKhqec5TorNvRI0kxgChn6rrl3o24KliAsGfJTVWdWpd2LJ93iJbRaOCY2dLdMCE/vTEZ2x5bvGfU9tUO7XetD0mY+e4Wo1EmFQAWUjhef4RpREIKDUc3R9N/upVW5Q/Ii0snVkrlAAy1El8FaR5WMdPnMgbcRf8fDtDh15sUaQ9cnNmqCOjYkgze5ZC9vdxBxmdJbSQFOPMY6+56Fv27MeiJZe1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ3r1xpE1hsF0IqfRA2SlX19uMbsWKzwNPED8N3WqI0=;
 b=R+0vsGrDYqvRtRyynxty3tNtJz5QWKp//4Ih0n9F8uMYkYoWhoqF9kv6fM5dwAnhqYuaJu17qBpzpc+o1mamKrlhzu2lrnXy0LiCp0OGGTxvpMPabRqYtylJdp0VXFn5jd4l9OEZHhpmYpxfctz0MUQAgiCHEaLuEkxqakU/DR4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1952.namprd15.prod.outlook.com (10.175.8.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 04:40:23 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.020; Mon, 26 Aug 2019
 04:40:23 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "sbsiddha@gmail.com" <sbsiddha@gmail.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Topic: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Thread-Index: AQHVWXL45hcGbMxBFEmxITCR8fhmlKcIeZ6AgARkOQA=
Date:   Mon, 26 Aug 2019 04:40:23 +0000
Message-ID: <164D1F08-80F7-4E13-94FC-78F33B3E299F@fb.com>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
In-Reply-To: <20190823093637.GH2369@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::56b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3bf2984-2de2-46db-3f11-08d729df8234
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1952;
x-ms-traffictypediagnostic: MWHPR15MB1952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1952EC92CDD2102298D002D6B3A10@MWHPR15MB1952.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(376002)(39860400002)(366004)(199004)(189003)(71190400001)(186003)(6436002)(71200400001)(86362001)(81156014)(81166006)(6512007)(8676002)(5660300002)(76116006)(8936002)(33656002)(36756003)(6486002)(50226002)(57306001)(66946007)(66556008)(64756008)(6116002)(66446008)(2501003)(2906002)(76176011)(66476007)(486006)(6246003)(2616005)(476003)(25786009)(46003)(446003)(102836004)(110136005)(99286004)(4326008)(229853002)(54906003)(305945005)(11346002)(14454004)(256004)(316002)(478600001)(7736002)(53936002)(53546011)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1952;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BfDcR1TxRlpREtQBpBH9goJmjlna27bjso9bJKK43bXWsJqXyJAKQNsq894/VeFQGS2jDcQOKVU9E5vs0Eces9snGaaZGmAE6l/G//lefD3n5AZQ+dhkEGiKKv5aBr/vfZmWeWLlA/caO+BzxmKNs0QBlsZPvkpT3+RFZBQEJLp9jbztaJZqA0s8Eg/OZ4YnrGoviq897dpR/hhrhGpWsInTfpoiEXkIOzhIjiWA73PnKrjfU/+bZtZX+Q8Bt93wWC4AGD+L2yiO/y+b5ZV808kJeZM+zcUxHSMNrAhF3baw+cGpSb16DAGLTzNNXj2OzJH0boR4SG1IcVsa1U4Ls8ookfe1dZrEwMSaCNgOhuX6iAUFxpxuWmZVAkVTRQfrSBnvib9IM0W8it5aSEO8IkezjpfGq4E7Lp+sZ7DSwVo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD68C27445FA53479B507173F2FC3246@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b3bf2984-2de2-46db-3f11-08d729df8234
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 04:40:23.3573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNO7kCSk2A40h5DwTvV5/XrffHYCdw5w7SVwMf7LIIXCYC2lm9jSJO9wyPcg3SJ4K6yQOc/dnPVfT95LRHNQJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_02:2019-08-23,2019-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908260049
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc: Steven Rostedt and Suresh Siddha

Hi Peter,=20

> On Aug 23, 2019, at 2:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Thu, Aug 22, 2019 at 10:23:35PM -0700, Song Liu wrote:
>> As 4k pages check was removed from cpa [1], set_kernel_text_rw() leads t=
o
>> split_large_page() for all kernel text pages. This means a single kprobe
>> will put all kernel text in 4k pages:
>>=20
>>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>>  0xffffffff81000000-0xffffffff82400000     20M  ro    PSE      x  pmd
>>=20
>>  root@ ~# echo ONE_KPROBE >> /sys/kernel/debug/tracing/kprobe_events
>>  root@ ~# echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
>>=20
>>  root@ ~# grep ffff81000000- /sys/kernel/debug/page_tables/kernel
>>  0xffffffff81000000-0xffffffff82400000     20M  ro             x  pte
>>=20
>> To fix this issue, introduce CPA_FLIP_TEXT_RW to bypass "Text RO" check
>> in static_protections().
>>=20
>> Two helper functions set_text_rw() and set_text_ro() are added to flip
>> _PAGE_RW bit for kernel text.
>>=20
>> [1] commit 585948f4f695 ("x86/mm/cpa: Avoid the 4k pages check completel=
y")
>=20
> ARGH; so this is because ftrace flips the whole kernel range to RW and
> back for giggles? I'm thinking _that_ is a bug, it's a clear W^X
> violation.

Thanks for your comments. Yes, it is related to ftrace, as we have
CONFIG_KPROBES_ON_FTRACE. However, after digging around, I am not sure
what is the expected behavior.=20

Kernel text region has two mappings to it. For x86_64 and four-level=20
page table, there are:=20

	1. kernel identity mapping, from 0xffff888000100000;=20
	2. kernel text mapping, from 0xffffffff81000000,=20

Per comments in arch/x86/mm/init_64.c:set_kernel_text_rw():

        /*
         * Make the kernel identity mapping for text RW. Kernel text
         * mapping will always be RO. Refer to the comment in
         * static_protections() in pageattr.c
         */
	set_memory_rw(start, (end - start) >> PAGE_SHIFT);

kprobe (with CONFIG_KPROBES_ON_FTRACE) should work on kernel identity
mapping.=20

However, my experiment shows that kprobe actually operates on the=20
kernel text mapping (0xffffffff81000000-). It is the same w/ and w/o=20
CONFIG_KPROBES_ON_FTRACE. Therefore, I am not sure whether the comment
is out-dated (10-year old), or the kprobe is doing something wrong.=20


More information about the issue we are looking at.=20

We found with 5.2 kernel (no CONFIG_PAGE_TABLE_ISOLATION, w/=20
CONFIG_KPROBES_ON_FTRACE), a single kprobe will split _all_ PMDs in=20
kernel text mapping into pte-mapped pages. This increases iTLB=20
miss rate from about 300 per million instructions to about 700 per
million instructions (for the application I test with).=20

Per bisect, we found this behavior happens after commit 585948f4f695=20
("x86/mm/cpa: Avoid the 4k pages check completely"). That's why I=20
proposed this PATCH to fix/workaround this issue. However, per
Peter's comment and my study of the code, this doesn't seem the=20
real problem or the only here.=20

I also tested that the PMD split issue doesn't happen w/o=20
CONFIG_KPROBES_ON_FTRACE.=20


In summary, I have the following questions:

1. Which mapping should kprobe work on? Kernel identity mapping or=20
   kernel text mapping?
2. FTRACE causes split of PMD mapped kernel text. How should we fix
   this?=20

Thanks,
Song



