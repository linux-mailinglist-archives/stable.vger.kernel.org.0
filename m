Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0912924319E
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 02:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHMAEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 20:04:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59230 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbgHMAEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 20:04:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D01Lh6019792;
        Wed, 12 Aug 2020 17:04:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fG0AnXFF85SHPvfiA/aa8a0AjmK1NNCPan4wPBp2Qb0=;
 b=HuYpU5JWr9hGioSPO7FGWcRMA7UTIpOQ7QLkVG2xAqKmsmM+dKcRCKrRB8LjFd5wY2Mc
 QJJLndSBC/HRzQr6+vxXSWYkHed7BHNDIcE9ieHh3sTJ945F1VoiTuKrOBCqEFRQAJJ4
 aeaWN1jZtb6aPrHa1FKqP+rFmmKXq9Ei51Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kgpys0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Aug 2020 17:04:38 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 12 Aug 2020 17:04:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juH7wnr+axWubm3SM1RcrGlZttbZY72ppPhKs/m4SFgxSiGt1sHB9I1FEq5eKUBKMVHCLJmXUujUf6mSZhOff8n8laRzWW+gCvgWew+SxgCQWiTg6U61jqIwUUGoFR8aIyJo+i7reGN0vlYh6N0nWKYLOMo63/uggkEOHR1ctCN1rAzQmy350llUW3iANrtWMpp3iabmQK2uCUWh+T2lTLoEqB2Md00ljIY/kBhNUpeWLRYw441ezu/IwwqgjD4VIPWbuJFwvyZzl72Y/wTvzSwOs6OX/g8Z31tuzZ7+dE0G8QvAGeg28ZG2O9LW1EBnMIFss3E94Mc3DGzy/0Cv7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fG0AnXFF85SHPvfiA/aa8a0AjmK1NNCPan4wPBp2Qb0=;
 b=aZIKbF5yedQtNZkSOjI2cLW6K2R2SZoFM8858biA0Q6Dq9oh7JmdULdYhTkCVZETq0AK4p8ankWNgVJsiB4Mn7yq9e591u9Auuaa2+R6P7Y5rv0lPlbxuYAFDz1jZM7+iZwVpsSQf5AJif/RfdikZLZlzf0+pcbwlQhXnIaIDn1AW0J4NUtgPi1lrcvva3Qvamfa1GpXRvi1NuhsD9lB6Df5wxWH30QjQxzY4OYKrQ7A9Zvmo7J5t9CYT9/A7Apf4a70k6F9AUSUcBAV+LEOj609oNxTtvjDN4qLG9X8u2eg5xoK435GEtYRy+IvtuCsu2Y0puwC1V1wQNkDd1feTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fG0AnXFF85SHPvfiA/aa8a0AjmK1NNCPan4wPBp2Qb0=;
 b=Oix9XcW0aAkQGfdys5HdPJgJP3vmCX3g10QG54WIjbzFf8OfZn4BbPPhZKecl7ieRGIpuG8+gZIKjpGBb942h9iXXO0rcQm3PiHPJMsa4uDWKb1nZwXMNqSGGMiGZW2nGRi+uzvVtvGgewdIYEmXX4Xd9NJqL0s+6WvJ3BPyRRY=
Authentication-Results: soleen.com; dkim=none (message not signed)
 header.d=none;soleen.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3556.namprd15.prod.outlook.com (2603:10b6:a03:1ff::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 13 Aug
 2020 00:04:20 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3261.025; Thu, 13 Aug 2020
 00:04:20 +0000
Date:   Wed, 12 Aug 2020 17:04:16 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
CC:     Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Message-ID: <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
X-ClientProxiedBy: BY5PR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::25) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:a37) by BY5PR20CA0012.namprd20.prod.outlook.com (2603:10b6:a03:1f4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Thu, 13 Aug 2020 00:04:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:a37]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4acd705c-911f-4e67-76f1-08d83f1c6d7d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3556:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35565B2092B9BC1F1AE88D28BE430@BY5PR15MB3556.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiG0dZ0s8puC3CvMop5xU4BNmf5N1lDgXLvifR0fdPtyyxC5VJFhHug8G5W3jwDdOI3zIxUzH52dv8/oWMCTqpuR+XX5m4Jbh49IjZSzw3fT+OmfgwGKhbqF6czbQEZ8yhMcXQ+GKDN+Gdx6X1gXw/iX9ELQrYpL+vGu22OyWHW0cNEXL0uQz89d6lwXralWtD4RPxvQOpeIY4uRNB5sj+BizWyrCX2NUeMR8xLldLF1SCBjF9fRTMf1F94Rv1Ymr5EE4SXxeEgDnAKeOascnplc2d/P7NfYrhz8kMpwtTp8adBYbRkOENdWABmc9V3BTwCvtiHTsMfjA2KEtOfEKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(54906003)(6666004)(1076003)(16526019)(478600001)(186003)(52116002)(8676002)(66556008)(316002)(7416002)(66946007)(86362001)(33656002)(7696005)(9686003)(66476007)(5660300002)(8936002)(53546011)(6506007)(2906002)(55016002)(4326008)(83380400001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RCiEBDwspbsrvItvW1zqAxRKwJzk/KFCm2xUvefOI+m53bnJ121cpfgGyB/zrmfkOyaY/d9ziD4vezQ48/qCvGw5m7Bk9F5xk7tJNmRlzHNUb8tCIKHsd6TLcHBkHWJ+8tbtl2pXvE9yfmjUEPv2cunUAfCTYvNGeCYo0CNf+PXZu8qXiECs8ZBkMEl6Gx+G3s2rze3huxi0HGAU/rI5nrz73T0cTbPE+HjbWqqFPIWL/4hAm7obwMct5nkjwcuc2sLbkEDH//uQXIEf6AtE16wnb/teeaX5fNJwikhPq27eIs87G7x0s37b9bvAYHkR3csKAwIZKE+ccXpcZHOsI7bU62F4YaSmZpokFPoMCtIIkdWMIhycYM3CsxSkPFkIoHTdMK/g8lNiYZFrjH9IxqAhrTMmlzqHzjVIJkBQobp6JLplfso1q0MOaW2UgIxR0hduLrDv0uXvI6BExmgwI+qxLVOUJN+nzlef9NP7x0gaVR/be/lRlYXD9fo106VDzvIcuVvz54Lbjxj4gNbJ8foTFGdQsXo56G7/BpT7QGe0dVVpmi/e0si9PetcfLPbq0zPtRdCkZG6LXA5WPoXxpFbxHNs7vOHPlkKY6o2lUk++z4BEj8pBKL8tYFze30nF/TLw2XJ1jzJfYGeE5BOlhipQ0cB7PiwnAiZVJ7yfO4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4acd705c-911f-4e67-76f1-08d83f1c6d7d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2020 00:04:20.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/7iQkGbrJGE6aGr2VcnYQ5HKmCx/eoWgWlBQsCFmBgM3Eyy8ZfoQ/mJdSZ4cVBq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3556
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_19:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 suspectscore=5 clxscore=1011
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120152
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 07:16:08PM -0400, Pavel Tatashin wrote:
> Guys,
> 
> There is a convoluted deadlock that I just root caused, and that is
> fixed by this work (at least based on my code inspection it appears to
> be fixed); but the deadlock exists in older and stable kernels, and I
> am not sure whether to create a separate patch for it, or backport
> this whole thing.

Hi Pavel,

wow, it's a quite complicated deadlock. Thank you for providing
a perfect analysis!

Unfortunately, backporting the whole new slab controller isn't an option:
it's way too big and invasive.
Do you already have a standalone fix?

Thanks!


> 
> Thread #1: Hot-removes memory
> device_offline
>   memory_subsys_offline
>     offline_pages
>       __offline_pages
>         mem_hotplug_lock <- write access
>       waits for Thread #3 refcnt for pfn 9e5113 to get to 1 so it can
> migrate it.
> 
> Thread #2: ccs killer kthread
>    css_killed_work_fn
>      cgroup_mutex  <- Grab this Mutex
>      mem_cgroup_css_offline
>        memcg_offline_kmem.part
>           memcg_deactivate_kmem_caches
>             get_online_mems
>               mem_hotplug_lock <- waits for Thread#1 to get read access
> 
> Thread #3: crashing userland program
> do_coredump
>   elf_core_dump
>       get_dump_page() -> get page with pfn#9e5113, and increment refcnt
>       dump_emit
>         __kernel_write
>           __vfs_write
>             new_sync_write
>               pipe_write
>                 pipe_wait   -> waits for Thread #4 systemd-coredump to
> read the pipe
> 
> Thread #4: systemd-coredump
> ksys_read
>   vfs_read
>     __vfs_read
>       seq_read
>         proc_single_show
>           proc_cgroup_show
>             cgroup_mutex -> waits from Thread #2 for this lock.

> 
> In Summary:
> Thread#1 waits for Thread#3 for refcnt, Thread#3 waits for Thread#4 to
> read pipe. Thread#4 waits for Thread#2 for cgroup_mutex lock; Thread#2
> waits for Thread#1 for mem_hotplug_lock rwlock.
> 
> This work appears to fix this deadlock because cgroup_mutex is not
> called anymore before mem_hotplug_lock (unless I am missing it), as it
> removes memcg_deactivate_kmem_caches.
> 
> Thank you,
> Pasha
> 
> On Wed, Jan 29, 2020 at 9:42 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Jan 30, 2020 at 07:36:26AM +0530, Bharata B Rao wrote:
> > > On Mon, Jan 27, 2020 at 09:34:25AM -0800, Roman Gushchin wrote:
> > > > The existing cgroup slab memory controller is based on the idea of
> > > > replicating slab allocator internals for each memory cgroup.
> > > > This approach promises a low memory overhead (one pointer per page),
> > > > and isn't adding too much code on hot allocation and release paths.
> > > > But is has a very serious flaw: it leads to a low slab utilization.
> > > >
> > > > Using a drgn* script I've got an estimation of slab utilization on
> > > > a number of machines running different production workloads. In most
> > > > cases it was between 45% and 65%, and the best number I've seen was
> > > > around 85%. Turning kmem accounting off brings it to high 90s. Also
> > > > it brings back 30-50% of slab memory. It means that the real price
> > > > of the existing slab memory controller is way bigger than a pointer
> > > > per page.
> > > >
> > > > The real reason why the existing design leads to a low slab utilization
> > > > is simple: slab pages are used exclusively by one memory cgroup.
> > > > If there are only few allocations of certain size made by a cgroup,
> > > > or if some active objects (e.g. dentries) are left after the cgroup is
> > > > deleted, or the cgroup contains a single-threaded application which is
> > > > barely allocating any kernel objects, but does it every time on a new CPU:
> > > > in all these cases the resulting slab utilization is very low.
> > > > If kmem accounting is off, the kernel is able to use free space
> > > > on slab pages for other allocations.
> > > >
> > > > Arguably it wasn't an issue back to days when the kmem controller was
> > > > introduced and was an opt-in feature, which had to be turned on
> > > > individually for each memory cgroup. But now it's turned on by default
> > > > on both cgroup v1 and v2. And modern systemd-based systems tend to
> > > > create a large number of cgroups.
> > > >
> > > > This patchset provides a new implementation of the slab memory controller,
> > > > which aims to reach a much better slab utilization by sharing slab pages
> > > > between multiple memory cgroups. Below is the short description of the new
> > > > design (more details in commit messages).
> > > >
> > > > Accounting is performed per-object instead of per-page. Slab-related
> > > > vmstat counters are converted to bytes. Charging is performed on page-basis,
> > > > with rounding up and remembering leftovers.
> > > >
> > > > Memcg ownership data is stored in a per-slab-page vector: for each slab page
> > > > a vector of corresponding size is allocated. To keep slab memory reparenting
> > > > working, instead of saving a pointer to the memory cgroup directly an
> > > > intermediate object is used. It's simply a pointer to a memcg (which can be
> > > > easily changed to the parent) with a built-in reference counter. This scheme
> > > > allows to reparent all allocated objects without walking them over and
> > > > changing memcg pointer to the parent.
> > > >
> > > > Instead of creating an individual set of kmem_caches for each memory cgroup,
> > > > two global sets are used: the root set for non-accounted and root-cgroup
> > > > allocations and the second set for all other allocations. This allows to
> > > > simplify the lifetime management of individual kmem_caches: they are
> > > > destroyed with root counterparts. It allows to remove a good amount of code
> > > > and make things generally simpler.
> > > >
> > > > The patchset* has been tested on a number of different workloads in our
> > > > production. In all cases it saved significant amount of memory, measured
> > > > from high hundreds of MBs to single GBs per host. On average, the size
> > > > of slab memory has been reduced by 35-45%.
> > >
> > > Here are some numbers from multiple runs of sysbench and kernel compilation
> > > with this patchset on a 10 core POWER8 host:
> > >
> > > ==========================================================================
> > > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
> > > meminfo:Slab for Sysbench oltp_read_write with mysqld running as part
> > > of a mem cgroup (Sampling every 5s)
> > > --------------------------------------------------------------------------
> > >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > > --------------------------------------------------------------------------
> > > memory.kmem.usage_in_bytes    15859712        4456448         72
> > > memory.usage_in_bytes         337510400       335806464       .5
> > > Slab: (kB)                    814336          607296          25
> > >
> > > memory.kmem.usage_in_bytes    16187392        4653056         71
> > > memory.usage_in_bytes         318832640       300154880       5
> > > Slab: (kB)                    789888          559744          29
> > > --------------------------------------------------------------------------
> > >
> > >
> > > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
> > > meminfo:Slab for kernel compilation (make -s -j64) Compilation was
> > > done from bash that is in a memory cgroup. (Sampling every 5s)
> > > --------------------------------------------------------------------------
> > >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > > --------------------------------------------------------------------------
> > > memory.kmem.usage_in_bytes    338493440       231931904       31
> > > memory.usage_in_bytes         7368015872      6275923968      15
> > > Slab: (kB)                    1139072         785408          31
> > >
> > > memory.kmem.usage_in_bytes    341835776       236453888       30
> > > memory.usage_in_bytes         6540427264      6072893440      7
> > > Slab: (kB)                    1074304         761280          29
> > >
> > > memory.kmem.usage_in_bytes    340525056       233570304       31
> > > memory.usage_in_bytes         6406209536      6177357824      3
> > > Slab: (kB)                    1244288         739712          40
> > > --------------------------------------------------------------------------
> > >
> > > Slab consumption right after boot
> > > --------------------------------------------------------------------------
> > >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > > --------------------------------------------------------------------------
> > > Slab: (kB)                    821888          583424          29
> > > ==========================================================================
> > >
> > > Summary:
> > >
> > > With sysbench and kernel compilation,  memory.kmem.usage_in_bytes shows
> > > around 70% and 30% reduction consistently.
> > >
> > > Didn't see consistent reduction of memory.usage_in_bytes with sysbench and
> > > kernel compilation.
> > >
> > > Slab usage (from /proc/meminfo) shows consistent 30% reduction and the
> > > same is seen right after boot too.
> >
> > That's just perfect!
> >
> > memory.usage_in_bytes was most likely the same because the freed space
> > was taken by pagecache.
> >
> > Thank you very much for testing!
> >
> > Roman
