Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A41B65D7
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 23:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWVGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 17:06:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDWVGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 17:06:15 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NKJOrM027957;
        Thu, 23 Apr 2020 14:06:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WVdWiusoAWEIj9Dq8KOrrMYyu6HBYyhlluEErry/LF0=;
 b=V+zEG12lxOog4/fNqaxHHhWJzYa5LQXVWv3zceP/2R/sfoF9+rRhRiORBWuGGu0l/8so
 6pVf7250SQevxGvMbebW1904gtWhSC5NGE2J/xbMpxUCRI/Z4/E/l0vcn+1077SC4KOF
 o6pmsWpQ27sFAJ5ASckpW+zIkm5kzAFHK8U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30jq4jhe5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Apr 2020 14:06:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 14:06:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCFo6Z6pBVSrlexRwfq/GTJ4ew3WeOefNKXOJSrsCyd3PUym9nQmPSjbv/p8Zsq/bbzZIcMAsSPEZJ/lCFCN/JTqn/+Pp1xHgHLH/ZIPr4dl4earkkEGq/3upnbI+6JsCJb86kezzANWEfRZCkrOZS0PZs3dydNF4zXEVzWbZ0vBYdIuTDF/cIZT0vQedNBUtZq1mqeUGjjQEldcuv81/+IQnf8nGc+BF+315ZA4+ak+LZyO0YfeZCrTFVi/IkdV1AZns0AjkFTU1SEtwZ7OB6lNEH/yJEFfQd2gFQP1uYx1Ex4SCBVPDxwSUV6FfE+rLTpiejBX7Ohldug2/Xy/rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVdWiusoAWEIj9Dq8KOrrMYyu6HBYyhlluEErry/LF0=;
 b=IW+3Qceyl8p/lqYxucVho7fW/8gFplDzYeWGMQORc8D5uKnaAwiKKs+fzUnVVA6tIEkmW2TmQG86dtl9jQnJYD+U/Ruf8yfyrSDpWHPybmi7Q6qcV2NZsa8yqaKrRP4SvoQnSau+J087PcD1xL0pkM/8M+cVkf+fUXYx/lOAHefuJVQ9LOozvD3oTWQ9k7WybDfsgRz5D7VEqjDIzlalUN40aqtPb0rhKdrVoC6rnlj5YWmGDW+tjIkkWIb62/up7KTEbKAD0I38F8gINnvglUmXWhx/n7P6mUKys32tOSXk611x3dIULW15fHJestLNl6kLPzekdJMCphuERWr2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVdWiusoAWEIj9Dq8KOrrMYyu6HBYyhlluEErry/LF0=;
 b=dfkbQiCw/vkCr9Bif9rjL8vEiEYoq3xNsdZQDvhRkNNFrXG20xBpw4pTkJKyMOXw1C+YZnbUGUxBM270qEjkVAJ5ZbM0HKv5sJlTaQVMIYdmDSkiM0b7zSRlrbIYvgpCuZPkeqBxW8XmAKF1ot2ttl+WcuUhrKwX8vw8THjKz4E=
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3368.namprd15.prod.outlook.com (2603:10b6:a03:102::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 21:06:08 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275%7]) with mapi id 15.20.2937.012; Thu, 23 Apr 2020
 21:06:08 +0000
Date:   Thu, 23 Apr 2020 14:06:04 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     <akpm@linux-foundation.org>, <mhocko@kernel.org>,
        <vdavydov.dev@gmail.com>, <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200423210604.GB83398@carbon.DHCP.thefacebook.com>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423061629.24185-1-laoar.shao@gmail.com>
X-ClientProxiedBy: MWHPR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:300:13d::33) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:925) by MWHPR20CA0023.namprd20.prod.outlook.com (2603:10b6:300:13d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 21:06:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:925]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 146ff854-945d-4e4a-2fbb-08d7e7ca24ee
X-MS-TrafficTypeDiagnostic: BYAPR15MB3368:
X-Microsoft-Antispam-PRVS: <BYAPR15MB336857A909BC6A8249103AACBED30@BYAPR15MB3368.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(136003)(366004)(39860400002)(396003)(376002)(966005)(5660300002)(1076003)(16526019)(186003)(7696005)(33656002)(2906002)(81156014)(9686003)(6506007)(52116002)(6666004)(6916009)(316002)(66476007)(8676002)(86362001)(66946007)(66556008)(4326008)(8936002)(55016002)(478600001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGe6A8S5J2SZ5kwtDUuL01IECYjdH7AUwc3O0mKVkAs8JeX+bFM08AHutnR/fSpaHt+M2EpiUDqpvxz95m9sKm+Tobs+raIiZF7kJ+DE6o53X8XK/0XZ0j4t1axvlk0SbgxvDW249oe0lNud6vtqp6Il4GTXwr4xnd8Tnr9zcastJKk9b6JeZuNh+zx0CfUQTccRJsZ+7JK5SeuNjEyvfsF6wga0MVldFa5/ULCivdNizj49J4L0LmGqdE7eZFNAjCoTLicr/OhVU3O6SD1AGzRR7c85G/pcJRNbDqdUVHsTEGJ13vyu3qlf6YEr8r2N/xCNttvdtCS/YrIXnaHDTrNDQFur7M8rJkS7I2E9jlnOydV13+xm7J4hLe/9u9SQTt/FtYdF4whSD8uL5Y5kzNhRgu2v8ary8i+cyVmYFgcayxaCS0KdA14CUwR048bFKjEQNY1Vp5K106XWR0Ntni5eD+aW9/Ej0lyjwD7bkQl+DBPoeBduFJcWPXpWGgJwEtrXcTCqzlV1mNl+r3EaXA==
X-MS-Exchange-AntiSpam-MessageData: qEAmZ50qNUvVyXtTlc2CaS1IVlz0mSDqLp0b8idLZXZjuFRys/BLWHP39KBlH6xFTupl7VE5nNZER+Pcl+Ux6NU6xxHgs7BlmTGCqk7zwSnrcDFFLPfx2mchUxBqKQwWGQ84nCZsxIOdRsJG3jIz/f/OSm69NTGEUMXqnMlDPI12uDScuRzqLWM8hHD7Vys6
X-MS-Exchange-CrossTenant-Network-Message-Id: 146ff854-945d-4e4a-2fbb-08d7e7ca24ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 21:06:08.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYdFzwv+Pu03ocrZrOpR8iGFrG49xwwY7GPiy1uYr2CC9I7vnl8poP0i9CIGv0FH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_15:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230150
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> This patch is an improvement of a previous version[1], as the previous
> version is not easy to understand.
> This issue persists in the newest kernel, I have to resend the fix. As
> the implementation is changed, I drop Roman's ack from the previous
> version.
> 
> Here's the explanation of this issue.
> memory.{low,min} won't take effect if the to-be-reclaimed memcg is the
> sc->target_mem_cgroup, that can also be proved by the implementation in
> mem_cgroup_protected(), see bellow,
> 	mem_cgroup_protected
> 		if (memcg == root) [2]
> 			return MEMCG_PROT_NONE;
> 
> But this rule is ignored in mem_cgroup_protection(), which will read
> memory.{emin, elow} as the protection whatever the memcg is.
> 
> How would this issue happen?
> Because in mem_cgroup_protected() we forget to clear the
> memory.{emin, elow} if the memcg is target_mem_cgroup [2].
> 
> An example to illustrate this issue.
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 800M ('current' must be greater than 'min')
> Once kswapd starts to reclaim memcg A, it assigns 512M to memory.emin of A.
> Then kswapd stops.
> As a result of it, the memory values of A will be,
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 512M (approximately)
>             memory.emin: 512M
> 
> Then a new workload starts to run in memcg A, and it will trigger memcg
> relcaim in A soon. As memcg A is the target_mem_cgroup of this
> reclaimer, so it return directly without touching memory.{emin, elow}.[2]
> The memory values of A will be,
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 1024M (approximately)
>             memory.emin: 512M
> Then this memory.emin will be used in mem_cgroup_protection() to get the
> scan count, which is obvoiusly a wrong scan count.
> 
> [1]. https://lore.kernel.org/linux-mm/20200216145249.6900-1-laoar.shao@gmail.com/
> 
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h | 13 +++++++++++--
>  mm/vmscan.c                |  4 ++--
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d275c72c4f8e..114cfe06bf60 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -344,12 +344,20 @@ static inline bool mem_cgroup_disabled(void)
>  	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>  }
>  
> -static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
> +static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
> +						  struct mem_cgroup *memcg,
>  						  bool in_low_reclaim)

I'd rename "root" to "target", maybe it will make the whole thing more clear.

I'll think a bit more about it, but at the first glance the patch looks sane to me.

Thanks!
