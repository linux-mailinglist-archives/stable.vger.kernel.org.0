Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62E266A1C
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 23:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgIKVei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 17:34:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgIKVe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 17:34:28 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BLQIPJ023073;
        Fri, 11 Sep 2020 14:34:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dZPtpEpiDDY+U9ZTB/n+0Q1AVTCilDb8gWXE+auh69k=;
 b=nEck9LnPF3wjXsJO+x8zjMBoIDrAZW9jeCoc0Fp4TMAOUMjl1nCb8CbiHYHeNPLS1Bcw
 bV4YbBgTiH1ZvqH2r2fLf0b0MmrtFLydKiSZugyLNHdOwnpeYh89dX1OlsitaHsq60ZR
 PZEGlYWLK4cXLHLbGKT/T3GRoZZPPud+/34= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33fqw17p07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Sep 2020 14:34:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Sep 2020 14:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPls9MsN38fZ06bma3bqxPlaOhDqbrCkXbIjUrDfVLQZjKEIVqriIVTEOjXz3E+cfgeztbngEuBZGgn87SM1tACqy6vmPf3IWYqLFENDaeBbdpuxNI/z4/xaSSClpFB8Um2x6qPdQ7s/WL/dXgGW+3PID6Rt3OpjyShiCr1Ulip9vCAEGgVN0k+GE6qcWODSauowE7hAOoQ4cnMAzAi8pVTx5L9lMsUdnkp6Iz9LmipevHyFbGZHS/0pMXYdegaXU6iMbPwuxqcwj1P7JauypTljE37Vws5XegR44Whm1QqgBhDqnGTNp5ZJj8gnyXZqyU77StqwdnwobOQ+Yu2euQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZPtpEpiDDY+U9ZTB/n+0Q1AVTCilDb8gWXE+auh69k=;
 b=gmVHwnNqJnv6+wvmBOkEfbSJw6+Fys4J/a9Y8x3EJm2TDMULhww6r77bl7qHHG6nPLRFHOuTmsKJSrvtoj5yjFbg79zOOCrJPgLfcw9XVavW6xacj8mxqAZ3tzDKgY54DICbArozA8W/ZtdG80JAP1WWbVlCOH9Vq/1Cc9ClWNafEUHjCPRZyzMWXvU9JLA/vh9hLiwQmDmYWSABmcsuh7wSD66GEUJTHs/gc7TNx0PzTL/l2fH1Qdg1Bszn1H4HIyG8cOM3ukPNVFkqGObOjR5EARbLk+Xf+taYgVFm+/SDkEJiLCAAaUS/Y6R8bosj+CPF4PJvItxRaEmFKJt5yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZPtpEpiDDY+U9ZTB/n+0Q1AVTCilDb8gWXE+auh69k=;
 b=ad8NUCDDESMktDrR2smpliWqGPI3X8EPB7upbK6ileKEAsu60TVTaBY1aO3R58N86usZC5aWuPYEBb5X+B4oPExF4prC38Fn+f9WgbUs1GHgzviM+X1MqxvD7LXQdgIoeF4IZWfWe4jV04JyVoRCvsO/Dfl4Qy3b6IKkl4rJ77E=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3652.namprd15.prod.outlook.com (2603:10b6:a03:1f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 21:34:07 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 21:34:07 +0000
Date:   Fri, 11 Sep 2020 14:34:02 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: fix racy access to page->mem_cgroup in
 mem_cgroup_from_obj()
Message-ID: <20200911213402.GB1163084@carbon.dhcp.thefacebook.com>
References: <20200910022435.2773735-1-guro@fb.com>
 <20200910224309.GB1307870@carbon.dhcp.thefacebook.com>
 <CALvZod6VZLZ+ABqHK=Vv_S3m=OarSJf0ttGeAOKhw+1zGj65gQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod6VZLZ+ABqHK=Vv_S3m=OarSJf0ttGeAOKhw+1zGj65gQ@mail.gmail.com>
X-ClientProxiedBy: MWHPR1601CA0001.namprd16.prod.outlook.com
 (2603:10b6:300:da::11) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:44fc) by MWHPR1601CA0001.namprd16.prod.outlook.com (2603:10b6:300:da::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 21:34:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:44fc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b5b2726-fd00-42d5-6cb8-08d8569a6987
X-MS-TrafficTypeDiagnostic: BY5PR15MB3652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3652F180E9D9ECB2C3DE40D1BE240@BY5PR15MB3652.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMfu6AZZhIbhUYTLUOT+LLd8Ou5q266Pp8IICYMAdY/XXJuhC49Pz1k/FNc+eSxBLtXWNWFrzU/gGNrZcBoILJnSE/8sZaTtJhew88zhHgtFnbP4768FNDq87n05cLET6YBZpCgQOzcw/hdmu/KEXxFZbYWtJIMTn88dhvqzRHpIyi4C2YSfZ20eQmKyBvTXLSzVCSDMX9D8HjxkV3uKpuiTARch/N/+Axubx8VYnhgotlGK1gdGcc77ETj5NmH8N3xxV61V+jBhMJE/M765jwz/a9U+Rlm9yfL5slEzogKiA/Qm6fteKmfUSnw8fMUWKnNWglGD6WJpzWrKBL6aNCDSSRx5Kt+IO5Hc4XIvF5cpLVNXsBGDtw+Ep+WClsOc7pk8kTMsm4H/lfLnrIoeXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(366004)(396003)(4326008)(5660300002)(53546011)(6916009)(6666004)(33656002)(966005)(66476007)(66946007)(1076003)(66556008)(6506007)(86362001)(186003)(16526019)(83380400001)(478600001)(52116002)(9686003)(7696005)(54906003)(8676002)(8936002)(2906002)(55016002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: j/pB1XcBZCUb5+W7H2ZV+cO3vJbUo2gBbupt/I2MCb2c44lzlJWYfPOLTNgeO6UVUiJ+cBTb10tOu2vSunej81PEJbRQAJ+NQYVpuZYJ4eN4E/hEqwKdXO74sNw66X6B3CEMeotd5r9PWPRfOiV421cx5KtNSrZNlSIBmwrSTnE4RWM0qR/nxQlFiS7BQlePOZlyoMhv60sYJBON8Pwx6kCAF9WJvcJFTCU/na5mQxynsKYiH2JzyFmrdPog6m3oKFfFd+hd1/4TZZVpPIR6AbJ5FoUXNbWSP87KRowoUeJUg7jJ1Az10qX9QlFx+/RKWAp2ZlHFyU0Vj2cPcwO5hJj+3G/LlCvMr3J8wMvfzkIcV0Q+xgNRy6Zqu0VnD9J1C7I/3dL+5l9H+xdVJ3zgvWTXaVIzSMquWqfQHBdNZB4/ege5vY/ubRaKMVYcdzzKorTaLHm7Cj5HKnpWF7X0BgdVi4s/wWaEw1sngbZUUwjCoqiRdCGec5KkNoLIyMJFFWaZAmICndmrjLIQQrhYTGG8NlzxKpLZ8277JvGG7W6G8Nru9qqa6Iulw6bFgkrYGD9wDZYZYSvF39M79KlHpT1MhUNBBnMfWhGJ47J3WTPgpFfmuW7vIRcKaHaMmiMJXpWeG7MZkwTdHYh82z41OwL3i9hG1ymfvmY+Q9GDrzA=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5b2726-fd00-42d5-6cb8-08d8569a6987
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 21:34:07.1508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RUJufXjQF+U5h8VZxwCE1/G9xFC7jKCiwovvAKh4Jx02TcH4NAH58yQml9IdzP7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3652
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_12:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110175
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 09:21:49AM -0700, Shakeel Butt wrote:
> On Thu, Sep 10, 2020 at 3:43 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Forgot to cc stable@, an updated version is below.
> >
> > Thanks!
> >
> > --
> >
> > From fe61af45ae570b143ca783ba4d013a0a2b923a15 Mon Sep 17 00:00:00 2001
> > From: Roman Gushchin <guro@fb.com>
> > Date: Wed, 9 Sep 2020 12:19:37 -0700
> > Subject: [PATCH] mm: memcg/slab: fix racy access to page->mem_cgroup in
> >  mem_cgroup_from_obj()
> >
> > mem_cgroup_from_obj() checks the lowest bit of the page->mem_cgroup
> > pointer to determine if the page has an attached obj_cgroup vector
> > instead of a regular memcg pointer. If it's not set, it simple returns
> > the page->mem_cgroup value as a struct mem_cgroup pointer.
> >
> > The commit 10befea91b61 ("mm: memcg/slab: use a single set of
> > kmem_caches for all allocations") changed the moment when this bit
> > is set: if previously it was set on the allocation of the slab page,
> > now it can be set well after, when the first accounted object is
> > allocated on this page.
> >
> > It opened a race: if page->mem_cgroup is set concurrently after the
> > first page_has_obj_cgroups(page) check, a pointer to the obj_cgroups
> > array can be returned as a memory cgroup pointer.
> >
> > A simple check for page->mem_cgroup pointer for NULL before the
> > page_has_obj_cgroups() check fixes the race. Indeed, if the pointer
> > is not NULL, it's either a simple mem_cgroup pointer or a pointer
> > to obj_cgroup vector. The pointer can be asynchronously changed
> > from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
> > from a valid memcg pointer to objcg vector or back.
> >
> > If the object passed to mem_cgroup_from_obj() is a slab object
> > and page->mem_cgroup is NULL, it means that the object is not
> > accounted, so the function must return NULL.
> >
> > I've discovered the race looking at the code, so far I haven't seen it
> > in the wild.
> >
> > Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> 
> Is the caller list_lru_from_kmem() the concern or is this more about
> making mem_cgroup_from_obj() more future proof?

I was doing some refactorings around (see
https://lore.kernel.org/linux-mm/20200910202659.1378404-1-guro@fb.com/T/#t ),
and just noticed it from looking at the code. I'm not aware of any real life
consequences at the moment.

> 
> Also have you taken a look at [1]? I am still trying to figure out how
> that is possible.
> 
> [1] https://lore.kernel.org/lkml/20200901075321.GL4299@shao2-debian/

Hm, yeah, it's complicated. At the very first glance it looks like that the
obj_cgroups vector is placed onto the very same page it describes, or at least
it shares the kmem_cache with it, with some bad consequences. Could be something
SLAB-specific, newer saw anything like that with SLUB.
Or maybe it's completely unrelated and has been attributed to this commit
by mistake.

I've spent several hours running the provided test in a loop, but wasn't
lucky enough to trigger it. Did you try?

Thanks!

Roman
