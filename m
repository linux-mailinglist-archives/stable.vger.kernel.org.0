Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D323EF7CF
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 04:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhHRCDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 22:03:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbhHRCDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 22:03:08 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I20nMe023507;
        Tue, 17 Aug 2021 19:02:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HqBzTyIV/ZXBqw/1SbXafzlTTs8GqZw+b+nyOBmBopk=;
 b=N+TKNmcZ7MqRTuV7UVvGzMKiZZML3mgc2gAPkr7x7skV5Tnqkm9Tslg0Cq6vGK+SQiQp
 Y+P5S3wXp1uTquBHYinQ9+pYM8mXeamtQIKOgsDO5V5nyMi6j+aUuDOyUwWr1XzhDr/V
 DTyLXI/iDS+PCluTsT++1ft7LTFXGYG7XxI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ags1v007t-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Aug 2021 19:02:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 19:02:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0fAi8A1dl22ztvfXqHNNVd8t2ywf+IuhEcjPiUbQpwfS1QQh4A/waKwWUcOvjX9TaJ6kPBqTbJJavtL+hION750z46epTbeCmlJYaA4IQFjY0n7JnXnsX1Iy9aOtYes0RQlHNV026ECL6Dw6WzKLh/rh4EL3atACgs0jfGZcxvVJzXbc1+hXCkyK5GHGHgeDxrD3r2mNWm7GobzdWCG/T0PSsKCdGDhIpCZmIUXvqLppxeIAL8LCf0COx4GTiN7sFBxhF3mqyF5nXaDMtRqvouGP7Vnm3vpH8tXM3fmnGc7z6bGG7qKZ+oBmxz7IH6e6KECkHw8xE1n1qC7ny2ZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqBzTyIV/ZXBqw/1SbXafzlTTs8GqZw+b+nyOBmBopk=;
 b=U54zhZmU14P1R0UbpjwJyA/MoROtDcFAKPOOYxzgn3jjGDm6ZYXKi1gYKwI843aHuclOjcaGx+n/wuCAKk0bX1v0Ud5vG7hyRwqEDZFfk//a9rXLZt9ipBrBVAqo0dM6mdo7mlswUI4UGvW3MqWdsXzYQNEWi48NI1vp9CcOGF/84m9VhYTT+tqHInyNdrWxPwPekZICWyxdi8iSwHK11fbcY+tQsqvZKMuE2R09maDblDojdoFNKyqWOusout7iCcYtW7n9qvg5ZsPOvrxJnOa9wdn3JWEg0Qj3noLTSgQ9a3yiNOoK8BgwSUfLKCuA+eJyjxhB1YeqtKzDT6hB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2392.namprd15.prod.outlook.com (2603:10b6:a02:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 02:02:20 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::75be:c42b:c0d2:2565]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::75be:c42b:c0d2:2565%5]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 02:02:20 +0000
Date:   Tue, 17 Aug 2021 19:02:17 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Chen Huang <chenhuang5@huawei.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Wang Hai <wanghai38@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.10.y 01/11] mm: memcontrol: Use helpers to read page's
 memcg data
Message-ID: <YRxqKRYDmZEKU+MJ@carbon.dhcp.thefacebook.com>
References: <20210816072147.3481782-1-chenhuang5@huawei.com>
 <20210816072147.3481782-2-chenhuang5@huawei.com>
 <YRojDsTAjSnw0jIh@kroah.com>
 <a4c545a8-fff0-38bb-4749-3483c9334daa@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <a4c545a8-fff0-38bb-4749-3483c9334daa@huawei.com>
X-ClientProxiedBy: SJ0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:a03:331::35) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:8470) by SJ0PR03CA0090.namprd03.prod.outlook.com (2603:10b6:a03:331::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Wed, 18 Aug 2021 02:02:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe5011a3-0f1c-4647-4dc3-08d961ec3665
X-MS-TrafficTypeDiagnostic: BYAPR15MB2392:
X-Microsoft-Antispam-PRVS: <BYAPR15MB239206F8E005F02DCCFEAF12BEFF9@BYAPR15MB2392.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAL9aT2ccPnRl8kKhaDssQp94Q5vv8I/w4s0Mh99XxtQhpd8EQNWzqcUWEDxetSv6YelZRDhTpSyDBQCAP8KIdb76kSMzxK8egkLSsvZ+kqWZvW5H2RSuDwvun+HaDrP65ohh3vL7H2w7VOc+mhp4gB+2jKNiRdl6fnQ7yeI/IFcLrtw3MGy+vIhom3pb6vobn+QWmj0m2zxoHl1lLX7XudN8MpVy9uf9g4qefJwWIY8VI6mAq+398QvTSN0hOl6scE9oq4UE+OeR3ur7wGvqjaBrJTTIAd70an4z0k/VsQ0/EKAslQQHLVR8gqs63bUNu4zjZ5vSPKy/xFp2gI86SJ9lErL68dmqjA/aC3UaQ8cCgdOqBAgFb9+GDcByoC6b6PvYmWcNxdIhEbV9bVJxjJ6mFUDa/GgGC4Q6GUY/a8/oeDSJmXXh41yG2bgP21Wm5icGUDL7xQoQMTIlGnixmrEwBjepDZIHozkxyU7Prui+It4WgZ4q43vmlKzLvn3rDyUonPXEBYgKuAOqaYhVjxW51rsZo3xfXfvK9Toldm3QF1LiIwoFG3C+f4yxtiNIVG5QsG0G9C14B1ejlPDKTeQNTIAtytenDLrD0McOefeoZHQ1e7qLKsiao6gLbDBSadLwm+jAQ3Yt2sRlrC+ruAxMpS+K3oZUbhXJd1DgWpSSXvCBj/iyjvTK36B9faBHfmWIvoWtX70KCl/PDu0VEiEqJQhImcrjC5ZvkRiBg/8E/fUHMtpSHdw7gi4/58x8Wulu5qpSURk/NOKxFG8XITWeCGrk/a0dMO+9cOYurZgGThDSyMjSBssiAIH7M//
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(54906003)(5660300002)(478600001)(83380400001)(9686003)(4326008)(38100700002)(55016002)(6666004)(316002)(2906002)(86362001)(6506007)(966005)(66556008)(66476007)(8676002)(6916009)(7696005)(52116002)(186003)(8936002)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnNvNkRCa0lnRDlzbzRWSjdWUlpqOXBTSmlGNEhuRDlJOG0xajBwUC9CMzFG?=
 =?utf-8?B?UEM4VmxiaHJ3UEhZNXFzWWJ6RGk4QUVNeGpSamNuNTVkSE80Y1lJQk9Kcndu?=
 =?utf-8?B?ejNXZ2xaU3E2V2JYcHJkNkpmblJVQkE4dVk5Qk02OTQ5U1I2TlBsMUpqYTNz?=
 =?utf-8?B?T3F3SXV4OC9JeUZWYUwwaG1SNkpqM3RvZ1htN3MrSlVMZFRtbWZBME9sb2VB?=
 =?utf-8?B?S3NrVDc5K3lpaEZaWVgraEhGQzBCMWQ0UE5paE9LYlJJeGhzQ0QrbWFSajdG?=
 =?utf-8?B?bjRIR3hpWEVzRmtXMnROMm1oNnZmM0U2bndZZGt4NXRuaktxQ3ZiYlRVcXNV?=
 =?utf-8?B?SER2K003cW9Pait4QWlqdU1nUGRwdmJBeXAxYmhtc0tKUlBqVTM4WlhWMU1n?=
 =?utf-8?B?T01DVkFZTzJCZGNjUHAySTY5eGtQalRoL0Y5ZGNxMlNTdmJEcktXejF3Sk5R?=
 =?utf-8?B?YThMR1hrYkNwSXlrMDNlbUQ1RWRPYVp4VndEK055K3N6a2Znem9ZMmhEUTM3?=
 =?utf-8?B?eEZjMGpWaDI3YUI5ZEZBQ0l4UzJoSHA5WFcrMGZqckx4S1M1aHEzRDlsdmJN?=
 =?utf-8?B?aG9qYUoyeWtJNVYyd0d5Y0JXaWhLK0E4TXMybWMwL0VlUjc4OTZpckJlLzU4?=
 =?utf-8?B?T095ZFhyMW1yTUF6dW9MTkkzUzFYSkhMa2FHTjFWZ2ZvbDZQa2JHUlljK2dn?=
 =?utf-8?B?SWhMR3daeGJmVEZnNDY1QjliYkYzdjRoSTIraHhkQ1RXWUt1SVRCaVNIWldO?=
 =?utf-8?B?anNZVnQ3ZDJBUFZLd2NINjhlNi9WZ3lpRzV2OUdZbitRYUc2SmlkVElzMFZ2?=
 =?utf-8?B?K1FibWw1ZExBY09YZDZQVkJGVFRVZEtGaDdXMzN2Zzd0TW9Fd2FienFBNEpt?=
 =?utf-8?B?ZlV4dFRZdWdXOXJDQlNVb1VoL2hTZDRDY2tXMTJoY2hrZjcwNUpSR2dnRWhn?=
 =?utf-8?B?VUpXNDYyUnVvUW0rT2RDRDdIZWhaYlJ5TU56NTNrRnh4TG9EMmY5bnNFVHht?=
 =?utf-8?B?Wk0wcjJXTUtVdTJNcU5ZOTRGMm50aDBqNCsyc2g0RW5kb2ZDajg4akFPakg0?=
 =?utf-8?B?ckdrMkJ1b0VrdGhkZk9MbWl2S1QvblVmeVlaSm8vSWNSY1FYdTdjc2UwbzVR?=
 =?utf-8?B?YTdCT1lhMWV6cHJzL2x3NmJQWWxHM2F1OWJidXpKdWx2c3dPU0tpT2FYVVpT?=
 =?utf-8?B?RXY4cmhPN3VqdXJWQW9hcEdKUCs5TFJrcm9zVlVmN1B4SnRxV3R6Q2hVSGdI?=
 =?utf-8?B?Mzh3bWlIVHZKQUVFZjRkcWEzNlIvTDEvekJPNzhYa3FFcGRSUGM4Mk1rUnR6?=
 =?utf-8?B?UmZCci9lMVdjMXQxaHVudncrRUN6NXpGQ0xqbjltYTAxU1g4RkoxMmZJbjhL?=
 =?utf-8?B?QjVIaHJkd3NHK21ITkRHUkM4N1lGWkxtd0g4UWhpelBod0RMNGE4TEJycXN4?=
 =?utf-8?B?UVg2QjF5U1lrbVBWdUFEZ2xFY1pCbFdEc2Vhb2RKQjFucjNab3EyT2lQL2lR?=
 =?utf-8?B?S1J6RDMwd3RGZTg5dEdKOXNiSHBJckxRRWxlck0rWDVpTDNMdWJleDhUWkpB?=
 =?utf-8?B?M0d1eGZ2Nk02VnUxTlFzTDhOWEk2bGpQUHNsbVg1TExwc0UxT0pTenV0S2FP?=
 =?utf-8?B?SzRRQ2tjbUdyTEt4aHlWSnZqQXlWUW50L0FwUE92NFpBM2M3ZWV4VTZ3R0wx?=
 =?utf-8?B?NlJ1eXpRakhxSlVFT2x0L0xrZk9PNlNpK3VOSitLVlgrUnNwc3o1cVVqczZG?=
 =?utf-8?B?THFELzNmVnVDditVRStxTm40NTRUOGxLdWVFb05nUHJPZUZObjRWSHFjM2t1?=
 =?utf-8?B?bjJCVmYzTkszRThZMEFVZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5011a3-0f1c-4647-4dc3-08d961ec3665
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 02:02:20.5538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWLvq4wZUSwjVc09Bhua+i/hPorNtz8+5oEIF2zouFAYw2fizNsu3HtNqzomVG3K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: X49CCH8YgI5ZZlu6eXKp0jC2JcnwYYQp
X-Proofpoint-ORIG-GUID: X49CCH8YgI5ZZlu6eXKp0jC2JcnwYYQp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_09:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=900 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 09:21:11PM +0800, Chen Huang wrote:
> 
> 
> 在 2021/8/16 16:34, Greg Kroah-Hartman 写道:
> > On Mon, Aug 16, 2021 at 07:21:37AM +0000, Chen Huang wrote:
> >> From: Roman Gushchin <guro@fb.com>
> > 
> > What is the git commit id of this patch in Linus's tree?
> > 
> >>
> >> Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
> >>
> >> Currently a non-slab kernel page which has been charged to a memory cgroup
> >> can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
> >> flag is defined as a page type (like buddy, offline, etc), so it takes a
> >> bit from a page->mapped counter.  Pages with a type set can't be mapped to
> >> userspace.
> >>
> >> But in general the kmemcg flag has nothing to do with mapping to
> >> userspace.  It only means that the page has been accounted by the page
> >> allocator, so it has to be properly uncharged on release.
> >>
> >> Some bpf maps are mapping the vmalloc-based memory to userspace, and their
> >> memory can't be accounted because of this implementation detail.
> >>
> >> This patchset removes this limitation by moving the PageKmemcg flag into
> >> one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
> >> accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
> >> adds several checks and removes a couple of obsolete functions.  As the
> >> result the code became more robust with fewer open-coded bit tricks.
> >>
> >> This patch (of 4):
> >>
> >> Currently there are many open-coded reads of the page->mem_cgroup pointer,
> >> as well as a couple of read helpers, which are barely used.
> >>
> >> It creates an obstacle on a way to reuse some bits of the pointer for
> >> storing additional bits of information.  In fact, we already do this for
> >> slab pages, where the last bit indicates that a pointer has an attached
> >> vector of objcg pointers instead of a regular memcg pointer.
> >>
> >> This commits uses 2 existing helpers and introduces a new helper to
> >> converts all read sides to calls of these helpers:
> >>   struct mem_cgroup *page_memcg(struct page *page);
> >>   struct mem_cgroup *page_memcg_rcu(struct page *page);
> >>   struct mem_cgroup *page_memcg_check(struct page *page);
> >>
> >> page_memcg_check() is intended to be used in cases when the page can be a
> >> slab page and have a memcg pointer pointing at objcg vector.  It does
> >> check the lowest bit, and if set, returns NULL.  page_memcg() contains a
> >> VM_BUG_ON_PAGE() check for the page not being a slab page.
> >>
> >> To make sure nobody uses a direct access, struct page's
> >> mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
> >>
> >> Signed-off-by: Roman Gushchin <guro@fb.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >> Acked-by: Michal Hocko <mhocko@suse.com>
> >> Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
> >> Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
> >> Link: https://lore.kernel.org/bpf/20201201215900.3569844-2-guro@fb.com
> >>
> >> Conflicts:
> >> 	mm/memcontrol.c
> > 
> > The "Conflicts:" lines should be removed.
> > 
> > Please fix up the patch series and resubmit.  But note, this seems
> > really intrusive, are you sure these are all needed?
> >

Sorry for jumping in late.

I agree that the patchset is quite intrusive and I really doubt we
need to backport it. The main goal of my patchset was to enable
memory accounting for bpf maps (which can be mmaped to userspace).
I don't see why we need it otherwise.
Muchun's patchset unifies the treatment of non-slab kernel objects
(e.g. large kmallocs) with slab objects and prevents them to pin
dying memory cgroups. However the problem existed for years and
I doubt we need it in 5.10 so badly.

> 
> OK，I will resend the patchset.
> Roman Gushchin's patchset formalize accesses to the page->mem_cgroup and
> page->obj_cgroups. But for LRU pages and most other raw memcg, they may
> pin to a memcg cgroup pointer, which should always point to an object cgroup
> pointer. That's the problem I met. And Muchun Song's patchset fix this.
> So I think these are all needed.

Can you, please, be more specific here?

Thanks!
