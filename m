Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1923818EA83
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 17:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgCVQiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 12:38:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41204 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgCVQiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Mar 2020 12:38:07 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02MGJUuq004501;
        Sun, 22 Mar 2020 09:38:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=93eGoM5j14iqBymyAYYsIhCTaLPrCh3N2s06DEi/2AM=;
 b=U5IKcEaXXbeufeEw3aH+RstFj9e3YYHCJHg+37fUBdCKaSlLxMiYV6dFIxLlCbCCd/32
 RGVmsCZvknK69c8kh6VfczzQZ4XttBggaOlayPGT7tRF7lutDYyzPhbglgRCpCIsBzCG
 Y6aYadZ+m4rCqlhhMPGEkhcZGFeue5i4W0c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ywgnnmc01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Mar 2020 09:38:02 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 22 Mar 2020 09:38:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8NKd3xDIm3UfLSsC+47rWk+GaMwYjj59aIICPmsRlT5UsU8vp5Ba4L3iFKOgVPvJp12ErQsJbnCRWnAEs2FciW8zo9Wecwb1e4KiuO/cnA/6qteidtTYa546jta6rzF67dvei49DJ5bmfb1sBqFgYFiIV8y48ZPNc0c6aMR2WVzBiQAHfHflaKAeAhE9KBftyGGKhnzfNB+GUKxDHkOmcwpOL14pxyHZ+BkUqcGWU5Kam0OfXq2NVNLnM2DVJ9anTJHsCkQxQvyB1vv5mcAnKmsdIYWpZv7bX3Z6pYYvyZZ1o1VTNmyAv/7JsLvvvvXzbOS04wCwBUfdW3eUE02+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93eGoM5j14iqBymyAYYsIhCTaLPrCh3N2s06DEi/2AM=;
 b=h1Z3FpxE8iSnoQNPUp1uEHIpbhzXxokfsC6N01J7UC6OGND5FK/1CWZmklXH2k1y0+IWEF+zImrG5cO39I2w2JOGgbsoYbJn2rb1UmU9nrcT5roSzv+wbnZoJ2M3vo2gSti3wmKkPa1LK0I6QrKzZiELux/jgUQffdxpetKlgGY3VkrbAzRICFhZmt1xZVBSzdyS+FrB7wg4UXs0cjIBDvDtvQH1lfKokCJk75knFrCKu1HL5RkUspjkK7Vf1yz1fg7d4hg0x1tfSJIJJa8hyP8DY2Her0lUu0lKYXO5qDw469YSGtzPZW4XNr/pnf7TRVSpd17FV0o8FWDqxXdreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93eGoM5j14iqBymyAYYsIhCTaLPrCh3N2s06DEi/2AM=;
 b=VlHIoBTCVUHuuAqTU44szCSMgResGNJOZ18KWxlm5gG9IXJQ3zaV2swUAgiXY6YCw23vwnlBb1RYG9wqYdzyRNi3vQhN6vLdeSNb9/HXq5dEGwLZXmetVSD6C78qVbYLjmrbgFkR6Ia0CUZeO1lZfLDSnMhj7pYIRDEkx0Xu/zg=
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2389.namprd15.prod.outlook.com (2603:10b6:a02:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Sun, 22 Mar
 2020 16:37:42 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275%7]) with mapi id 15.20.2835.021; Sun, 22 Mar 2020
 16:37:42 +0000
Date:   Sun, 22 Mar 2020 09:37:38 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various stack
 implementations
Message-ID: <20200322163738.GA3898@carbon.dhcp.thefacebook.com>
References: <20200303233550.251375-1-guro@fb.com>
 <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
X-ClientProxiedBy: CO2PR04CA0129.namprd04.prod.outlook.com
 (2603:10b6:104:7::31) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:5fb3) by CO2PR04CA0129.namprd04.prod.outlook.com (2603:10b6:104:7::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Sun, 22 Mar 2020 16:37:41 +0000
X-Originating-IP: [2620:10d:c090:400::5:5fb3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d440943b-8112-4e15-047d-08d7ce7f57b7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2389:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB238902E3EC65F7F706BD0AC8BEF30@BYAPR15MB2389.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0350D7A55D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(52116002)(86362001)(33656002)(186003)(6506007)(1076003)(2906002)(4326008)(966005)(9686003)(478600001)(66946007)(16526019)(8676002)(6666004)(54906003)(8936002)(66476007)(7696005)(81166006)(55016002)(316002)(66556008)(5660300002)(81156014)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2389;H:BYAPR15MB4136.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKA0KYve980Kiq7N7U8qz/8BePDnK5rS4ZHju0ULt0EQQoNlqx9RKF4GlhikvnwWYfQD2WTAR92ntfEXDpu+uyxkOjL+9xWu+HXvIapLPK1SNwY4eEwZG4Ry8kEHh2pt5gIE3DBnAnZZCiDOwHdRO0JMuyxjowE8uTAQGkQ61J67gn5Q7o4p4rSxifmh42pBRUe+5J3Vi5DpVNielM6pNg0uPw/9shGULW7Am08eFvmW1m5rx7VhnwTHnLhz1QLZ+AEZIW9/bo83pI43zlrRZSqut5DW+qXZHvDaE+SNJNRzvcup20IEl50satcPIZgyJPy8CU8gfz8LbZr1r3DhhTwJOmmM0rIg2qZhF1vYteVikbzZfOUFaiQOcgAdBAROp+rvoLlOGhlFqt2lMvD5MsTZBPDM9cnaZcr2zQqGHbhtWW5e9TZaBT08A4AVnHlnaYVgGbGs4ovXPIQiHKdyxFZ0ZicHZ6YRR62OHxm4hq23t9mOtJnDTgcuFgPIkPAciVp18j5rp7N/KCdGQJSEIw==
X-MS-Exchange-AntiSpam-MessageData: n1lmOpGvPv5RTHlP5Cbods4zXDkR/HWktpfcIApVMexyFJ4DJYrvqbqYIygoAcuRMrnEptqG68FiuXcmD/G0w8STVSS6mxels5L2mqI876ihUKjpbA//WL+xZiCKy+Z8Fy3VD46uPYCTuZ51hCYj1FWXdEp5+v4l33Ji0pE4FQDw5kps3NxjzzMczf4ZcF3y
X-MS-Exchange-CrossTenant-Network-Message-Id: d440943b-8112-4e15-047d-08d7ce7f57b7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2020 16:37:42.7562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRhToz9oHrkjb+psW6V8ylEWrd2nbt8c7vGAZ7klztv0lvjcXIYuUR1Wg1q/NGpd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-22_05:2020-03-21,2020-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=2
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003220099
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 04:48:56PM -0700, Andrew Morton wrote:
> On Tue, 3 Mar 2020 15:35:50 -0800 Roman Gushchin <guro@fb.com> wrote:
> 
> > Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio
> > the space for task stacks can be allocated using __vmalloc_node_range(),
> > alloc_pages_node() and kmem_cache_alloc_node(). In the first and the
> > second cases page->mem_cgroup pointer is set, but in the third it's
> > not: memcg membership of a slab page should be determined using the
> > memcg_from_slab_page() function, which looks at
> > page->slab_cache->memcg_params.memcg . In this case, using
> > mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
> > page->mem_cgroup pointer is NULL even for pages charged to a non-root
> > memory cgroup.
> > 
> > It can lead to kernel_stack per-memcg counters permanently showing 0
> > on some architectures (depending on the configuration).
> > 
> > In order to fix it, let's introduce a mod_memcg_obj_state() helper,
> > which takes a pointer to a kernel object as a first argument, uses
> > mem_cgroup_from_obj() to get a RCU-protected memcg pointer and
> > calls mod_memcg_state(). It allows to handle all possible
> > configurations (CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE
> > values) without spilling any memcg/kmem specifics into fork.c .
> > 
> > Note: this patch has been first posted as a part of the new slab
> > controller patchset. This is a slightly updated version: the fixes
> > tag has been added and the commit log was extended by the advice
> > of Johannes Weiner. Because it's a fix that makes sense by itself,
> > I'm re-posting it as a standalone patch.
> 
> Actually, it isn't a standalone patch.

It's true. I only meant it doesn't have to be a part of the slab accounting
rework patchset.

> 
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -776,6 +776,17 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
> >  	rcu_read_unlock();
> >  }
> >  
> > +void mod_memcg_obj_state(void *p, int idx, int val)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_obj(p);
> > +	if (memcg)
> > +		mod_memcg_state(memcg, idx, val);
> > +	rcu_read_unlock();
> > +}
> 
> mem_cgroup_from_obj() is later added by
> http://lkml.kernel.org/r/20200117203609.3146239-1-guro@fb.com
> 
> We could merge both mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
> and this patch, but that's a whole lot of stuff to backport into
> -stable.
> 
> Are you able to come up with a simpler suitable-for-stable fix?

I'll try.

Thank you!
