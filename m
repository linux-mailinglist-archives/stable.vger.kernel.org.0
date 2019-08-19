Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED8A94FC6
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfHSVUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 17:20:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728402AbfHSVUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 17:20:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JLK40N010019;
        Mon, 19 Aug 2019 14:20:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QWfM2Olb7uQqW8UJKVeRaHYQpHU/Kt1yx/pLSeeFZ/w=;
 b=joRnM+dJMqiv2BvZMYgNfuAeihOS73PBBw0mPhujx50/8ciOstASG2dvDlH40UnYdy+u
 DCDuObtxC7BqgkRR87uuNVoS30807J+PMxhWb5FF+j8dViCXPmXCvnkKzBUxVYMXiICH
 LLltWFVY1TsJ1nRF3xbRXYi+boaqfks9y6k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ufxh31h89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 14:20:41 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 19 Aug 2019 14:20:40 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Aug 2019 14:20:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHFTxkv9N2auaBxbeLJBr0dF27sR7DIp72gRx1HwhYABS2ElOf+ZPGW3g6eiFV+ZZ9ZReW8IMLrInxBYTcXxHVSz7aVKIZXrB04yl4MOoV6fuOMNKXgyfzPNQYsrJ8WqRopiS2XAWs2nONxFg89LQ1Imeh3Yfwc/H+xkUr2aVMjKc/Ca+gtq3o3c3MBvp2zoafe66r0CMo0AZJeW1fFyCbDlvaVsecorVQ90cTIBGB4SPLV+MORN9zRbK+cQYm2acYyTTL7zq9LTO13k+zHzkU9VkSvE+0bTgkLAAuYl3f0xkvA11n41LOT4yfoXzryq6d5NMN0P9fBH2/Q7tfvacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWfM2Olb7uQqW8UJKVeRaHYQpHU/Kt1yx/pLSeeFZ/w=;
 b=Xw5m7MAci7I/5UDz3+uqjtlY0bM4ajDnaNqy48RCWdqV8UqH661Agttm6M65/J8oyBYaD7U8qI2lxFxzwo/7i9/ppm/XKUE2KIRb0eUmsf6xS5K7gY+mTPxYK3vwSPNWnXQ5DzhfV6i0jqPldv08hYtK8EsYNLj9MDt+jVUPSgf4xJL/mhrGC4YUQqHbQ/5VjQDRNj9yPNp2/DHjcKOUJFOC2q0yF44+rVKJrNeULQwe1H54R7EtvgBZ2iYpFedUTEQoSAtNHdV6ptJyZhd16JVv9bq6P1xPMu7V4Vmoj5bRpid012Eicl+hg46l19YxeVtsQs6MpDpSXWg0FjTNMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWfM2Olb7uQqW8UJKVeRaHYQpHU/Kt1yx/pLSeeFZ/w=;
 b=Eh1SJOxhe1u0RhvkEUPCEYCaBnjsfv+OPMw83SdBPAOsmCnXhy6VTwlgavzkyfoAx4TFxVImnM4rPuG7fhr3Fcu6ayMVK6x9eiBIk3Ti8rIe0NyFrMiG9B16ZyN8n22x5rBQLNwAzaFoBpqD4iMjj8WuxqaYkGoXMnFihG+IBgQ=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB2394.namprd15.prod.outlook.com (20.176.66.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 21:20:38 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e%3]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 21:20:38 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
Thread-Topic: [PATCH] Partially revert "mm/memcontrol.c: keep local VM
 counters in sync with the hierarchical ones"
Thread-Index: AQHVVJVnJCTepTfXpE2m8ikuyJkTSKb+sAiAgAEGvYCAAFhFgIAC76oA
Date:   Mon, 19 Aug 2019 21:20:38 +0000
Message-ID: <20190819212034.GB24956@tower.dhcp.thefacebook.com>
References: <20190817004726.2530670-1-guro@fb.com>
 <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
 <20190817191419.GA11125@castle>
 <CALOAHbA-Z-1QDSgQ6H6QhPaPwAGyqfpd3Gbq-KLnoO=ZZxWnrw@mail.gmail.com>
In-Reply-To: <CALOAHbA-Z-1QDSgQ6H6QhPaPwAGyqfpd3Gbq-KLnoO=ZZxWnrw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0084.namprd02.prod.outlook.com
 (2603:10b6:301:75::25) To DM6PR15MB2635.namprd15.prod.outlook.com
 (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:4a49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7312defa-0880-4dd7-d8cf-08d724eb14f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR15MB2394;
x-ms-traffictypediagnostic: DM6PR15MB2394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB2394377EB26C4375DDC48865BEA80@DM6PR15MB2394.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(376002)(366004)(136003)(199004)(189003)(6246003)(25786009)(14454004)(478600001)(66446008)(66476007)(66556008)(53936002)(102836004)(4326008)(6916009)(229853002)(6486002)(5660300002)(6506007)(1076003)(66946007)(64756008)(6116002)(386003)(53546011)(14444005)(256004)(7736002)(305945005)(33656002)(476003)(486006)(71190400001)(71200400001)(316002)(99286004)(86362001)(186003)(81156014)(81166006)(8676002)(8936002)(52116002)(54906003)(9686003)(6512007)(446003)(2906002)(76176011)(6436002)(11346002)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2394;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QF3x/W1OP8EFyvHS4vbslBEJ9YHGAb7BhOBabLWkjLgU3q7me/S1+6U35flvq8LB8pydX0fR99NyUTbiNunYlK7DRagrqL6OLfYTofpdECdnotEI84Vi409ysFtoN8A0HCdPIZd7wNHCdyZpdrifPdOeCgkyulyXnRVE+h9eyNqTCOBIpB2xSvfvjy0PZ3ctQO3X2FFUvFo5PasG5O1HYf7g8U2A8iiopKIkhIcSJlxZi9DOI/tZjyk+KpJm4LuMkl42Apxa9+xo9RZ0LUpfZ6tdCfjR1TPW0T0b+MuTFIfOgeHD4Rr+d0/8nqRQ7kkZfZdJGhdVFImbxK2TGbJKTgCcfnG2dn1VfWYZdIcVvyatlu4b6Hat2P/EKrCELqjgCrjxw+7ydaR/2H4ZGsU5KembHLYDXNvJVqEHh4eXnic=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAF21E35EDBA8F48ACD70AD8B24500DB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7312defa-0880-4dd7-d8cf-08d724eb14f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 21:20:38.5768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jrg03qRK3p7jCog0hUHMoSg44FKvXI1h8QCIltk7bB+JhlknjuYfOKWARfhRHOLo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2394
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190213
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 08:30:15AM +0800, Yafang Shao wrote:
> On Sun, Aug 18, 2019 at 3:14 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Sat, Aug 17, 2019 at 11:33:57AM +0800, Yafang Shao wrote:
> > > On Sat, Aug 17, 2019 at 8:47 AM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sy=
nc
> > > > with the hierarchical ones") effectively decreased the precision of
> > > > per-memcg vmstats_local and per-memcg-per-node lruvec percpu counte=
rs.
> > > >
> > > > That's good for displaying in memory.stat, but brings a serious reg=
ression
> > > > into the reclaim process.
> > > >
> > > > One issue I've discovered and debugged is the following:
> > > > lruvec_lru_size() can return 0 instead of the actual number of page=
s
> > > > in the lru list, preventing the kernel to reclaim last remaining
> > > > pages. Result is yet another dying memory cgroups flooding.
> > > > The opposite is also happening: scanning an empty lru list
> > > > is the waste of cpu time.
> > > >
> > > > Also, inactive_list_is_low() can return incorrect values, preventin=
g
> > > > the active lru from being scanned and freed. It can fail both becau=
se
> > > > the size of active and inactive lists are inaccurate, and because
> > > > the number of workingset refaults isn't precise. In other words,
> > > > the result is pretty random.
> > > >
> > > > I'm not sure, if using the approximate number of slab pages in
> > > > count_shadow_number() is acceptable, but issues described above
> > > > are enough to partially revert the patch.
> > > >
> > > > Let's keep per-memcg vmstat_local batched (they are only used for
> > > > displaying stats to the userspace), but keep lruvec stats precise.
> > > > This change fixes the dead memcg flooding on my setup.
> > > >
> > >
> > > That will make some misunderstanding if the local counters are not in
> > > sync with the hierarchical ones
> > > (someone may doubt whether there're something leaked.).
> >
> > Sure, but the actual leakage is a much more serious issue.
> >
> > > If we have to do it like this, I think we should better document this=
 behavior.
> >
> > Lru size calculations can be done using per-zone counters, which is
> > actually cheaper, because the number of zones is usually smaller than
> > the number of cpus. I'll send a corresponding patch on Monday.
> >
>=20
> Looks like a good idea.
>=20
> > Maybe other use cases can also be converted?
>=20
> We'd better keep the behavior the same across counters. I think you
> can have a try.

As I said, consistency of counters is important, but not nearly as importan=
t
as the real behavior of the system. Especially because we talk about
per-node memcg statistics, which I believe is mostly used for debugging.

So for now I think the right thing to do is to revert the change to fix
the memory reclaim process. And then we can discuss how to get counters
right.

Thanks!
