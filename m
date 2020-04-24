Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038221B7B6C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgDXQWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:22:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgDXQWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:22:12 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OGJj8e008101;
        Fri, 24 Apr 2020 09:22:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=U+jURu/ME4WibFg2YveaZlKwGlJ+z6u9FrSKBpzlEMw=;
 b=HvGwRzzXjPNUZDCXwGn+197VeaqpyEvlnD84GIlIDEfKy/JsRg7vhl4vGQed8igOORsX
 dArDXMv6LdcYNmTYarbAJc8zwfwsGFsM2CAujlBH39KaQn7qWS7RFq+7BoJ1AzcdAjC+
 Zzue+3PijbYY1FeL4XqK8dSbWRYwcvZntZ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jwf0vv5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Apr 2020 09:22:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 24 Apr 2020 09:22:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AF0XtpTC4jMPpAlEClDBQimOm4L5pGlmdJ+2ZGZ230jyXn1jtzgxIdH29r9lorVDj8UahKUIW/zbpMK1J7ZJRTIqBnc4T69JIoLnhHU7F5dmOH8HQsU5r/PfEVlCKHFYJqZd33aW+K1/VsLrrRBdffpF67iImfO/ZpoE89rLCbBJ5pZzoSf8zuzzTjIGwA+Xz41LRYpQL6zK7AQGqvhgWiEE1LgZh42xMU79hOUI43C92GPvzbOyTnVv1A+UHha2S1ZqPUWzMeajB1MuNZrnTameNuBfHRAI8pOgGJL7oTCRNG4dyIHg6qdwfeGda1o2yRZjEIIQh87RUCJ/EZRRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+jURu/ME4WibFg2YveaZlKwGlJ+z6u9FrSKBpzlEMw=;
 b=kEhqbQXRvRtlQJsr8XE8M887iU6hOn8NI6W1CZt4zpKDfQQakMoSXf/iI3zLo8aj0bQoLd0Ek9hP4E5Y0AsUmHfKh5BSvGO9PvtyIcw0RQX2eDKHzP57dTYZMV5H5sx+N3GVwAvTMVFuUHWh6OeGP1NLVvfT87qqBWGVd5nmnJfbeSM2fMboC81WRXdkO4Cb2uYDPvvA4C+n8+YGCzpJGP0FPISwkK6pReWYf2FC9MD6iFNuwIveBJ+6jMHuw5MGUHNzU0Uudt8GtoZUg5Q1iNIkVZ1DbhnttMkbB7Gix0DKAfgOVK8b7ucJGox8W7IJOgBJZfkJ7N4Iyn0TMXlK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+jURu/ME4WibFg2YveaZlKwGlJ+z6u9FrSKBpzlEMw=;
 b=FraxOTTPTMs+eYwoQ7PFR7x4ASDo4gN49XpL5Xv3qYKjxM+lI+BmzkVhqv2OApYQbPCNFSLvxDP6Wd9TGiC4jXRZqNnjsEZmyxGa3lJLhHi0iG44uLn/c1YNcHlDKGMD+DdkLCea7UFPzA5Y3C0irFm6OAqxUiGtzbRstaMWEOU=
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2519.namprd15.prod.outlook.com (2603:10b6:a03:14f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 16:21:53 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275%7]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 16:21:53 +0000
Date:   Fri, 24 Apr 2020 09:21:48 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        <akpm@linux-foundation.org>, <vdavydov.dev@gmail.com>,
        <linux-mm@kvack.org>, Chris Down <chris@chrisdown.name>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424162148.GA99424@carbon.lan>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
 <20200424142958.GF11591@dhcp22.suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424142958.GF11591@dhcp22.suse.cz>
X-ClientProxiedBy: CO2PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:102:1::37) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.lan (2620:10d:c090:400::5:1ddb) by CO2PR04CA0069.namprd04.prod.outlook.com (2603:10b6:102:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 16:21:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:1ddb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b0682f-14c9-4012-9199-08d7e86b998d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2519:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2519BE87C8252B30E975851DBED00@BYAPR15MB2519.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(4326008)(6916009)(8676002)(7696005)(66556008)(6666004)(66946007)(478600001)(54906003)(55016002)(81156014)(9686003)(5660300002)(33656002)(66476007)(86362001)(52116002)(1076003)(6506007)(186003)(36756003)(8936002)(2906002)(16526019)(316002)(8886007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/u94YVQ31yy/owv8efuvuDKzDXvAwrbwnSXhP0PBYvTXrNnbGEYK+AnmIDiv3/xl1RWWZVgQB/oL4A45j6gF3Jd639KRQ7VPsgkI0QS21gwDbYSEbEH5vQU8nHJAU6WcTSGpTthquLush1qZfXsMTqVLee/PEaqvx7sRlrOMg3QUzrcTnmF1A4Kgy/hVfKspw9vmq0eESHLDHCSLs1OWrvZgHdfo3uDdwQXVn0nvd8BtVgtdaE0qyF7iFIO0m5lOTkDomdS+cMng5CFZkuN8JRrnvTGf/NcFwrbwXowZGYKAuGLSFgMJhx7/tNlgDY1ltQy7carYb9hGI+UfV9bK/H0JJwRKIaSjqoALnb3nCUtiPr71u7rXetQnxCKp3ob7rUYWFu/RJK+f+ftcZwqVgeGgInJL4S3cUo1v2jao6j8dWMCm8JnShJUZJtEzJEo
X-MS-Exchange-AntiSpam-MessageData: At+ZDDQr626gbgS2ruvY+Be10gZBJytp8hAm4m1B/kfrFzch/m/3DREa7mtAGGv9pZKjOgQJv62MvrELU6r1TFtZXiDsEws5kSsbN/iNnGzs4prz/h9R5+8oQxho7xkfLzWxPrcITk48qHlgn88+YA7Q+txEaGzGLYkL1DRLM8M+BS2xmbdjLzXbUeM64G1h
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b0682f-14c9-4012-9199-08d7e86b998d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 16:21:53.5668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jAEerd+uMH2KYT+JJNsdYePOlLHVsBC1LCpNv59ggxofZkkAy1VwzC8LQ5fvB3WI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2519
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_08:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240127
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:29:58PM +0200, Michal Hocko wrote:
> On Fri 24-04-20 09:14:50, Johannes Weiner wrote:
> > On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > > This patch is an improvement of a previous version[1], as the previous
> > > version is not easy to understand.
> > > This issue persists in the newest kernel, I have to resend the fix. As
> > > the implementation is changed, I drop Roman's ack from the previous
> > > version.
> > 
> > Now that I understand the problem, I much prefer the previous version.
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 745697906ce3..2bf91ae1e640 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> >  
> >  	if (!root)
> >  		root = root_mem_cgroup;
> > -	if (memcg == root)
> > +	if (memcg == root) {
> > +		/*
> > +		 * The cgroup is the reclaim root in this reclaim
> > +		 * cycle, and therefore not protected. But it may have
> > +		 * stale effective protection values from previous
> > +		 * cycles in which it was not the reclaim root - for
> > +		 * example, global reclaim followed by limit reclaim.
> > +		 * Reset these values for mem_cgroup_protection().
> > +		 */
> > +		memcg->memory.emin = 0;
> > +		memcg->memory.elow = 0;
> >  		return MEMCG_PROT_NONE;
> > +	}
> 
> Could you be more specific why you prefer this over the
> mem_cgroup_protection which doesn't change the effective value?
> Isn't it easier to simply ignore effective value for the reclaim roots?

Hm, I think I like the new version better, because it feels "safer" in terms
of preserving sane effective protection values for concurrent reclaimers.

> 
> [...]
> 
> > As others have noted, it's fairly hard to understand the problem from
> > the above changelog. How about the following:
> > 
> > A cgroup can have both memory protection and a memory limit to isolate
> > it from its siblings in both directions - for example, to prevent it
> > from being shrunk below 2G under high pressure from outside, but also
> > from growing beyond 4G under low pressure.
> > 
> > 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > implemented proportional scan pressure so that multiple siblings in
> > excess of their protection settings don't get reclaimed equally but
> > instead in accordance to their unprotected portion.
> > 
> > During limit reclaim, this proportionality shouldn't apply of course:
> > there is no competition, all pressure is from within the cgroup and
> > should be applied as such. Reclaim should operate at full efficiency.
> > 
> > However, mem_cgroup_protected() never expected anybody to look at the
> > effective protection values when it indicated that the cgroup is above
> > its protection. As a result, a query during limit reclaim may return
> > stale protection values that were calculated by a previous reclaim
> > cycle in which the cgroup did have siblings.
> 
> This is better. Thanks!

+1

and I like the proposed renaming/cleanup. Thanks, Johannes!

> 
> > When this happens, reclaim is unnecessarily hesitant and potentially
> > slow to meet the desired limit. In theory this could lead to premature
> > OOM kills, although it's not obvious this has occurred in practice.
> 
> I do not see how this would lead all the way to OOM killer but it
> certainly can lead to unnecessary increase of the reclaim priority. The
> smaller the difference between the reclaim target and protection the
> more visible the effect would be. But if there are reclaimable pages
> then the reclaim should see them sooner or later

I guess if all memory is protected by emin and the targeted reclaim
will be unable to reclaim anything, OOM can be triggered.

Btw, I wonder if this case can be covered by a new memcg kselftest?
I'm not sure it can be easily reproducible, but if it can, it would be
the best demonstration of a problem and the fix.
Yafang, don't you want to try?

Thanks!
