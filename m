Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569FB9BAD7
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 04:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHXCNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 22:13:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfHXCNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 22:13:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7O29YRM019059;
        Fri, 23 Aug 2019 19:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/oegRWb3ammnVvupQjrHMnCHszWE4ZQU+KbjiiXDi4M=;
 b=MROcyqGgk+lj/uhk8/kwir8AS8Q/5EWuUF1nBRguO4Xa0yCoCvELEY+3Nw4euM4IZNnb
 SAkjfWrjOJB0fd0y76LIcM9uRqeoIJzX85JQEI1egKGii/rGJV+PLOUMUFB/mIiYp6Nl
 nSqmwG+H2ZsUf3NOYrGsorAvzVq9k5o8rd4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ujrvygmqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Aug 2019 19:12:26 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 23 Aug 2019 19:12:25 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 23 Aug 2019 19:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6Ci3B89G2o8vqabLmgAXByAljSQJOuHkXdsMVctVLjlchxeBc+MmaCKnBIL6osQr8YGxJloRXcR7MMT8InanLO6ys4auNJR9YhDvpE/2LBDQ+u53wKcg8mH8aaHYqGuJtJtuhu8lwwsJmmjUQXCXMzP1yOs/b8lfF+10Y13Y3/QE3A/IBtVkVu9+4OnF8G97OB7L29UZ5jHLr9SyDNZak+v//4invUzwWd6vNkx967BxlBlUmjJXg54j35HxBnPpKxqOTOgUOeOvlpeGpRsEFL8JEv3HHWq7lnrVOWPpLyqLfqXeNrnNQKv4jqaFARLqBF1MhgmS4Eeu9cAIIVM1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oegRWb3ammnVvupQjrHMnCHszWE4ZQU+KbjiiXDi4M=;
 b=lgGd1M2snquuQjvImSbHsRpm9UGGirZC+L7y6xvZluvkTHs4c9QiQV26GaS27jK/RwxSVXGzruesbtXi0HHMlG2VJ1XDSTlFr/5MF7S0nGDVTWXQYauRnbc6ersKaLr/BXE9r1XyFilRG0vHRzyudl/+xRsY8SJV4HEOfO0Q37scVT7ApBqAg7MGqsDxhLwk8RbfxWuTsZGcrw5hQi8vIhqsIUCWZwHqNWwqyhAPCyMr07dE68cK5PYMYv23jjIBzZGQc7e99RLVtZr8cn2kZd5OSMviA3z4nSgW3y4JwUX4X4Egunu84/tXbalDYBfQc+pEmvkYQ2TSgasdQt5Lgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oegRWb3ammnVvupQjrHMnCHszWE4ZQU+KbjiiXDi4M=;
 b=RlvPu07tRhR/97EmUajtXhcryl0s6KnnDvQoW4RugjQUwjcnQlVA5LiWC+jQG+/odu3eGiUAfJFvlRFIUViZIzokMdC2Pk0ldT5XsdoX/LYatDbBJrQ7xepdtmzc4XNOPYU6RXB25MfeDL265drlYTw4pem3+NX5k8OUYi4l2Nk=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1552.namprd15.prod.outlook.com (10.173.229.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 24 Aug 2019 02:12:23 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 02:12:23 +0000
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
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Topic: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Thread-Index: AQHVV5U99G5SsRzRUkunOQ/1Fd5gD6cFYg0AgAAFmQCABCvpAA==
Date:   Sat, 24 Aug 2019 02:12:23 +0000
Message-ID: <33ED1189-0509-4F66-A96B-8CBD465889C3@fb.com>
References: <20190820202314.1083149-1-songliubraving@fb.com>
 <20190821101008.GX2349@hirez.programming.kicks-ass.net>
 <20190821103010.GJ2386@hirez.programming.kicks-ass.net>
In-Reply-To: <20190821103010.GJ2386@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::5e10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0dfc2b6e-f090-410c-fdbf-08d7283880ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1552;
x-ms-traffictypediagnostic: MWHPR15MB1552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1552D4BD5316081A44F1967AB3A70@MWHPR15MB1552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(366004)(396003)(376002)(199004)(189003)(53936002)(54906003)(81166006)(229853002)(25786009)(99286004)(86362001)(8936002)(6512007)(64756008)(46003)(66476007)(186003)(66556008)(81156014)(2906002)(66446008)(256004)(57306001)(76176011)(305945005)(66946007)(7736002)(6246003)(76116006)(36756003)(6436002)(6486002)(478600001)(4326008)(71200400001)(71190400001)(53546011)(5660300002)(102836004)(6506007)(6916009)(486006)(50226002)(6116002)(446003)(11346002)(33656002)(476003)(316002)(2616005)(8676002)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1552;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JA+LJ25coI9NI9Xe1AI/AqBZN5taFqcGAa3o3FkdgUtb6HjgRsXFP1YdD8xTcCGiA1QE4vOApmYOgvYuWyZ0jRRBDEOm3WjOFWrNEr1Wv0eV6M6ywwKt348noaJ5GopjGIDZkPTs/VlTYcRKK2CKrHlWTVaxRxZKhUGtidqFzaAbe5DquLibI3K/fZ+W9y4GGRzL/4rrOnf6vKNRrm4KJLPhoQhZ7UakrtZplCBeGxjYP8W2W7Eohd07BapMNwx5WydQcu47lB5TUYUJl55ktrqyUOQ3waWcKi6SfwhBMRvOfW4AZsI70iyGo3XcjAzXn017Rl1dql1X47mXLYPy6r+N0UytKKLdDvgntpQJY+zqliyLKEiN1aK/lAbbtnMru99xYoSfDhx62mE26gYM4a5u9Y2lB9OIOS0fxfyZ5YY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F92BCEE5473C2946834B98F4CCA6B9FD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dfc2b6e-f090-410c-fdbf-08d7283880ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 02:12:23.6788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYer2JhenY1uogzEGadhYxZTzKNEqxfK/pvcI7EReuOQCh0E2na3HARYT7MkOG60zNpHzz3+kLNHCNSLAJ8p5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-24_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=878 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908240022
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 21, 2019, at 3:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Wed, Aug 21, 2019 at 12:10:08PM +0200, Peter Zijlstra wrote:
>> On Tue, Aug 20, 2019 at 01:23:14PM -0700, Song Liu wrote:
>=20
>>> host-5.2-after # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
>>> 0x0000000000600000-0x0000000000e00000           8M USR ro         PSE  =
       x  pmd
>>> 0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE  =
   GLB x  pmd
>>>=20
>>> So after this patch, the 5.2 based kernel has 7 PMDs instead of 1 PMD
>>> in 4.16 kernel.
>>=20
>> This basically gives rise to more questions than it provides answers.
>> You seem to have 'forgotten' to provide the equivalent mappings on the
>> two older kernels. The fact that they're not PMD is evident, but it
>> would be very good to know what is mapped, and what -- if anything --
>> lives in the holes we've (accidentally) created.
>>=20
>> Can you please provide more complete mappings? Basically provide the
>> whole cpu_entry_area mapping.
>=20
> I tried on my local machine and:
>=20
>  cat /debug/page_tables/kernel | awk '/^---/ { p=3D0 } /CPU entry/ { p=3D=
1 } { if (p) print $0 }' > ~/cea-{before,after}.txt
>=20
> resulted in _identical_ files ?!?!
>=20
> Can you share your before and after dumps?

I was really dumb on this. The actual issue this that kprobe on=20
CONFIG_KPROBES_ON_FTRACE splits kernel text PMDs (0xffffffff81000000-).=20

I will dig more into this.=20

Sorry for being silent, somehow I didn't see this email until just now.

Song=
