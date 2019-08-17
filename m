Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B512B912A6
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfHQTPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 15:15:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9958 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbfHQTPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 15:15:51 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7HJCfKu029936;
        Sat, 17 Aug 2019 12:15:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AXxYrdZTMKjWsJjah2Y6q0/+b31IPfJ2xAtd34l8h04=;
 b=CWZOtnGF26mV8p3GuGvYBdP2qoMJFi/jXoXZII7G1dgGKRGiVMRfJ9ui2c4IctLTr908
 D7IHBxufqkxo5I9nfO4smjOHA5Vy3blrksLfEIkxqZPKMaa5JRgOleRlZ1Xz7tD4UIB0
 02nBEh/jT9c7eIRATxV1DJYsq0ZcfGCYn6g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uegvjs29s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 17 Aug 2019 12:15:43 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 17 Aug 2019 12:15:42 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 17 Aug 2019 12:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMtTa3r4n374hb9sUfIvstiD1cZv2HcCUXnLENAZkL8sa3oSdiXDWRi6nycBV3pCsYD+k+6RCp7fveSLDdmxJ2HRxM0MNxUNilDAxtMTAfX4xuxKlo/ow9dkVDOZ6LsdnSkiC7GgQrbilOrybtFaXtqu5BqDklf20uMH4pZCuuO2uti1mMHA+vfKbqIaQizgGbl5b9P9q47MGWrfuUoSR82uIFvZytu9rs/23Lcmk3C0ZMVS7J8gZXFwKSgbxrUuJhy4k2On5NN0QVlQsptE4r+JxNU5tFLpgcZBm61bIEaUb+s5sFKjnZ4J0FmtHKtE/zGvAUmsZZe6fOvaKsv6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXxYrdZTMKjWsJjah2Y6q0/+b31IPfJ2xAtd34l8h04=;
 b=JNDvWTramQI8PyzXT4req93HYfCAYfDYFC7p1O1xmhGOWnima+zqvcl7+p10dq++72q2bzdFcH7kCb2gxGSqA4SIEzGNA0sZxRE9hd4OBsv01m911mvbiixtGwXEUbUcxxSb5CwDQhEQsrstfTgybypV1HRpiT9pz32+jDGzxIT128Ycr2v1bML0hnzRcplHUN7kLy1VCZlozttOU23AtD0oT4F71mG7R3mMcBAENbGTcPqwp8I1tyqftd1h8VIsqyhMYcurHNsAzWFniX30Bp7+X3lKq7MtL+LL0Vy1sa6Iw8xHueYG30UhPnSYWakiKq6RaAPt6GVyagoD37qakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXxYrdZTMKjWsJjah2Y6q0/+b31IPfJ2xAtd34l8h04=;
 b=ARuJCWry1yr+WBxINOoLMDutCV9CqQCh4ijl5fCKERyY6B0502aLhiCvdRuSAOfcx5MhnhlvbIZDREPxrNhq/FQ6He8//2YWz7RuwKcYxw9AhLHYuT/DZk2tIPtVG6kLyowncYmVIGy+kRuIOq/fvxITqMFBeZm+VHeoMvF4a0Q=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB2569.namprd15.prod.outlook.com (20.179.160.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 17 Aug 2019 19:15:23 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e%3]) with mapi id 15.20.2178.018; Sat, 17 Aug 2019
 19:15:23 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Greg KH <greg@kroah.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
Thread-Topic: [PATCH] Partially revert "mm/memcontrol.c: keep local VM
 counters in sync with the hierarchical ones"
Thread-Index: AQHVVJVnJCTepTfXpE2m8ikuyJkTSKb+4vkAgADUEgA=
Date:   Sat, 17 Aug 2019 19:15:23 +0000
Message-ID: <20190817191518.GB11125@castle>
References: <20190817004726.2530670-1-guro@fb.com>
 <20190817063616.GA11747@kroah.com>
In-Reply-To: <20190817063616.GA11747@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0012.namprd17.prod.outlook.com
 (2603:10b6:301:14::22) To DM6PR15MB2635.namprd15.prod.outlook.com
 (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::61b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dca784f-2915-4a71-6726-08d723474093
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB2569;
x-ms-traffictypediagnostic: DM6PR15MB2569:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB256919047E442BC54390229FBEAE0@DM6PR15MB2569.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(71200400001)(14454004)(54906003)(256004)(4326008)(53936002)(6246003)(76176011)(71190400001)(11346002)(33656002)(25786009)(478600001)(316002)(99286004)(81166006)(8676002)(81156014)(33716001)(8936002)(52116002)(6116002)(6916009)(6436002)(6306002)(305945005)(966005)(7736002)(229853002)(446003)(6512007)(5660300002)(66446008)(66556008)(66476007)(476003)(66946007)(102836004)(64756008)(46003)(386003)(6486002)(186003)(9686003)(6506007)(1076003)(2906002)(86362001)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2569;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EA9HJNQ87B94Qt3PbswCnJGYY/vKRCrAUF7ECPjak4TqQ46MwZQteUBZ52vx67p3w5vcBxPGwqfBaemCEgL7PMMqIo1sWTPqS0ghfAgOFcqA8GaaVXPVuEvcaujfVnnr4p2L3pGOw663EovPu55A23aBQ2qo3tlGPeMQV/jLpOtq672Q+LUr0hsct82C79Qf2DpRkb4kAkSEPEqpwRfO5gHhsYnPJXYkDM/zajkYbzkCUK7PbmAjXxnzTvzQu2GShoggW388B6Ur189J9JEEQoo+xLTQYR7joIymQExuDrYOu1+ZzGbLacl3wl0wfE5gCDe0KO34rUWm87RzCItgitV4iJrexS+2i9SVvpshfsr6NuHBBqcn4gVf2r3cmnpm/LmzqcHWB4tntOHoimDbVw7pd0tH0oGVhF+Cas6QlaI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0467F09FF93E174C859D845E827A4C37@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dca784f-2915-4a71-6726-08d723474093
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2019 19:15:23.1135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6mPtGVpZ0ZdJnOfRrtBxC28DNZjVrHiBTsKoXAXrXvLXC1Ikj28wJR///rX4BxrC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=760 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908170209
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 08:36:16AM +0200, Greg KH wrote:
> On Fri, Aug 16, 2019 at 05:47:26PM -0700, Roman Gushchin wrote:
> > Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
> > with the hierarchical ones") effectively decreased the precision of
> > per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.
> >=20
> > That's good for displaying in memory.stat, but brings a serious regress=
ion
> > into the reclaim process.
> >=20
> > One issue I've discovered and debugged is the following:
> > lruvec_lru_size() can return 0 instead of the actual number of pages
> > in the lru list, preventing the kernel to reclaim last remaining
> > pages. Result is yet another dying memory cgroups flooding.
> > The opposite is also happening: scanning an empty lru list
> > is the waste of cpu time.
> >=20
> > Also, inactive_list_is_low() can return incorrect values, preventing
> > the active lru from being scanned and freed. It can fail both because
> > the size of active and inactive lists are inaccurate, and because
> > the number of workingset refaults isn't precise. In other words,
> > the result is pretty random.
> >=20
> > I'm not sure, if using the approximate number of slab pages in
> > count_shadow_number() is acceptable, but issues described above
> > are enough to partially revert the patch.
> >=20
> > Let's keep per-memcg vmstat_local batched (they are only used for
> > displaying stats to the userspace), but keep lruvec stats precise.
> > This change fixes the dead memcg flooding on my setup.
> >=20
> > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync w=
ith the hierarchical ones")
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/memcontrol.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.

Oh, I'm sorry, will read and follow next time. Thanks!

>=20
> </formletter>
