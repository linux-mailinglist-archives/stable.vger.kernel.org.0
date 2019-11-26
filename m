Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9847B10A41F
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKZSmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 13:42:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfKZSmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 13:42:23 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQIcOCo001022;
        Tue, 26 Nov 2019 10:42:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=d1+eTZWmdRxcBjWGUl9mE62ATVh8x7428Dv8H3hN+7k=;
 b=cjqOc8ZRYBZggNmLIdal1bqHU4EnqMtteMUdch/hkcBlfLOtVSGC7En5OoOy9Ypn4WST
 5gtESQxKoH4knd700d4MkYWUx8Xe6P9Kpn/tfJkF6d1rK3j9Hq7hnCHxpj/umdxAPptb
 SXpATLuHHsF6nxNsu0rIndEcGDvnWFtMucc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wh52h9ktj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 10:42:15 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 26 Nov 2019 10:42:02 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 10:42:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqierHmhLRxlEC2jDojgE4EKYB1nZF1hnRnF2QOcdQrUxSzIlDvSS+3jvdbNC8Kab+dtInLoIEixIeU3qfO6xToBh9q1FuctwAPD01iTURF9ucR+m9A8lMfHk68eMfkm/qY6btT9DsZOkRdJtsbnzzDt/wuSLDeGy4MdOrVI/flapMuSKUovuvHEV21dV8Pnzc6HzeC2M8x4UpP1pOi238isutTIJ1FVeyKYV7bdR7RmtYOIhiz7BZnu09pR0WR4ikLd7zIoYeqyhFedhjKSn1e2N+HB/5A8UEXCtTJv50yHeZb+TY7Yd2N3QZfH/pwdp0+dH5lqSI00xfj0lcoT+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1+eTZWmdRxcBjWGUl9mE62ATVh8x7428Dv8H3hN+7k=;
 b=E51qwJ5yVQYjxsGYkN6SjHRZ2zdavXekwQ0uQi8TD/hCQpVqsx8FYD1aproeQLnFIExPys/vzyihcePCaJ7G1mqOw5y2YAIHNgLs/aayuXtZLHyGFdz3oTB8NYzOdORofFLr/1/1KlMkzPU66OU460uew4vwcrRNx35HMc5ej1KAODp0/NJVZPsrwlmtAB55uyyD+OjFmcA2xybbZIFZCH02ZEnJdItLnlYP/zek5ClS5rtzNhJKDYcUL1XM2Eh5i6RAhKfVMTFFvepzzeXnh16WnGOdAHHwo9WQN4ReE/54uYFFByz2mrlsq0xOp7jfQi7dPFTqtArPmlIxnysbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1+eTZWmdRxcBjWGUl9mE62ATVh8x7428Dv8H3hN+7k=;
 b=iiBcwr6PKOYQptWILbQX46cg1/Uwcs49qivVwogj0LphTGR8di4mXSyudFwfwisCIhIciKLjJ3pa5+huu967wIaZ6a81OU2gtsqiYB+VpuDlK2HeCnuyfrt6Y1/YkYvXqVDwuDUdZC/nI1Up2OUfj1Ii58OpwVo1ceAFS188YOE=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2740.namprd15.prod.outlook.com (20.179.137.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.22; Tue, 26 Nov 2019 18:41:41 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::50eb:bc03:b3de:375c%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 18:41:41 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Topic: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Index: AQHVo8HY/WnVvAZSgEqkb7BHNOXmHaedMHAAgACaToA=
Date:   Tue, 26 Nov 2019 18:41:41 +0000
Message-ID: <20191126184135.GA66034@localhost.localdomain>
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
In-Reply-To: <20191126092918.GB20912@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:300:93::27) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2d15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c5994e5-4d8d-4dc3-144c-08d772a0476b
x-ms-traffictypediagnostic: BN8PR15MB2740:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB2740ACD40FB441684851B9F9BE450@BN8PR15MB2740.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(376002)(39860400002)(136003)(189003)(199004)(51234002)(6246003)(46003)(186003)(5660300002)(8676002)(6116002)(7736002)(99286004)(33656002)(316002)(8936002)(54906003)(305945005)(52116002)(256004)(14444005)(81166006)(25786009)(45080400002)(76176011)(478600001)(446003)(4326008)(14454004)(71190400001)(71200400001)(11346002)(229853002)(6916009)(1076003)(9686003)(6512007)(6506007)(386003)(66446008)(86362001)(64756008)(102836004)(66476007)(66556008)(2906002)(66946007)(81156014)(6486002)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2740;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: npw2y6NcatccuU4tC/8MgFokUHeW7QZKbSIRo3P5SEQkfGBTwNQDhqgO1KdXxEo3zO+5wzRoHzHpoDDjDQR4VX5LXMIumIgp8oATzSLE2T58Ns2pcYSvWHCcS3GcxJrJh9JBiKvVB8Bbls/aPXgtFcaCLvgATnG+EIYgsHITk/zD4ckPVKc1wougKUlyeCrhRiWb4uaLRjtBMCMtzZ745I4TQ8mLb7ixsm4CoGZlbpYK02cdpB4GXRDUzn3jWU8Rf11pPqXRcxsNwBUlFV7qrUAw/S9ShGhsz1hwXrEN2FjMy3j/xbcAwmdZcUeXodB5qNq3nXFTwUapa4a+t87vBxMpSYRs4UO5uwjSWgWvI6GuC+kOYdTb8tppy7yNuqvt8MIC/u4W7EnQpOhUD5nfFKExvu1U0vDn3IKlIwfKpjpogCd+a7GuQm3WyJBDgYZkNUHLWyPgyuDMlKYmG0aSGQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA057AB0FF046B4785B6C430A935197A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5994e5-4d8d-4dc3-144c-08d772a0476b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 18:41:41.7066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OS59RwJlW3aJPZ6INqkyKYsK8NIYoNJO4+dcy1rj686lbn4nkfNQA6PQhEszXOaF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2740
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_05:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxlogscore=442 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260157
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 10:29:18AM +0100, Michal Hocko wrote:
> On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
> > Christian reported a warning like the following obtained during running=
 some
> > KVM-related tests on s390:
> >=20
> > WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0=
x50/0x58
> > Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp i=
p6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntr=
ack ip6table_na>
> > CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
> > Hardware name: IBM 2964 NC9 712 (LPAR)
> > Workqueue: events sysfs_slab_remove_workfn
> > Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58=
)
> >            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 003600810=
0000000
> >            0000001f00000000 0035008100000000 0000001fb3573ab8 000000000=
0000000
> >            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb=
3573b00
> >            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e00=
9263cd0
> > Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2=
046,0
> >            0000001529746848: 47000700            bc         0,1792
> >           #000000152974684c: a7f40001            brc        15,15297468=
4e
> >           >0000001529746850: a7f4fff2            brc        15,15297468=
34
> >            0000001529746854: 0707                bcr        0,%r7
> >            0000001529746856: 0707                bcr        0,%r7
> >            0000001529746858: eb8ff0580024        stmg       %r8,%r15,88=
(%r15)
> >            000000152974685e: a738ffff            lhi        %r3,-1
> > Call Trace:
> > ([<000003e009263d00>] 0x3e009263d00)
> >  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
> >  [<0000001529b04882>] kobject_put+0xaa/0xe8
> >  [<000000152918cf28>] process_one_work+0x1e8/0x428
> >  [<000000152918d1b0>] worker_thread+0x48/0x460
> >  [<00000015291942c6>] kthread+0x126/0x160
> >  [<0000001529b22344>] ret_from_fork+0x28/0x30
> >  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
> > Last Breaking-Event-Address:
> >  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
> > ---[ end trace b035e7da5788eb09 ]---
> >=20
> > The problem occurs because kmem_cache_destroy() is called immediately
> > after deleting of a memcg, so it races with the memcg kmem_cache
> > deactivation.
> >=20
> > flush_memcg_workqueue() at the beginning of kmem_cache_destroy()
> > is supposed to guarantee that all deactivation processes are finished,
> > but failed to do so. It waits for an rcu grace period, after which all
> > children kmem_caches should be deactivated. During the deactivation
> > percpu_ref_kill() is called for non root kmem_cache refcounters,
> > but it requires yet another rcu grace period to finish the transition
> > to the atomic (dead) state.
> >=20
> > So in a rare case when not all children kmem_caches are destroyed
> > at the moment when the root kmem_cache is about to be gone, we need
> > to wait another rcu grace period before destroying the root
> > kmem_cache.
>=20
> Could you explain how rare this really is please?

It seems that we don't destroy root kmem_caches with enabled memcg
accounting that often, but maybe I'm biased here.

> I still have to wrap
> my head around the overall logic here. It looks quite fragile to me TBH.
> I am worried that is relies on implementation detail of the PCP ref
> counters too much.

It is definitely very complicated and fragile, but I hope it won't remain
in this state for long. The new slab controller, which I'm working on,
eliminates all this logic all together and generally simplifies things a lo=
t.
Simple because there will be no need to create and destroy per-memcg
kmem_caches.

Thanks!
