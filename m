Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768F129F286
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgJ2RFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 13:05:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42054 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbgJ2RFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 13:05:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09TH4fvt013366;
        Thu, 29 Oct 2020 10:05:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=zsMV4Taa7Gyc29DJSveIeWUYppgNCnS/j+MfHtSBDg4=;
 b=PlQz9QLHNOoMxUkoYr8hTjtwzB8gw4S4AUV5SAKq++0XmkrZOH+ULJOHFCet/a2VcjcZ
 l2UqxYSRAgcqIMv8drn2E0aDXdKnDee7EugSlgLP1VZ5Pbk+IHnjSNYEAwa4l61Qq7nZ
 JOE9SHOFSv0UCYFsuzbkuTF0Ubrrjtleodc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34fxyxs71k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 10:05:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 10:05:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4ncevR5av70nj9vHO98ru/4Ioee0OQs9VqT3XqreQNVur0kxDEe/qYtF2AAJXKxpSUBG0nUmv3sSRTWF9sGF9SMZuyo2E5/qwFpcKj3bX1icZ1HtQTJjzV/4NLOAEHfDP/oNFuc4tfU6aum+my3YIQmU3zsIxU5hnpkRVeq5UITCHwVB9CTpUm8bK6pI30ZoE3VOyMkunpu8D0XxiIlyTOVJq8yv/XQePoU7WlCPxSDY/2mX9k0Jz9Av1cif03mcdPwJbLs19VTer3nl2iH6yPX7aWiIHViIxaeZX0aLSEuvMguKk5lrjDuRZrF2t6huCjziJo2yq7IjQDR6IA4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLm2MMz41tQmPR4KVk26ZpAWwJx8VYQG8qKwodR8oro=;
 b=Y4iK+rQrWJfCMXEs4/SpkpyNUEv/zojmJ3HxiNR0XhyFF7taj7XdQifCQ+M5pKq+tqzAsxGl4Pd2pMojGZ1XJM7Gwauy//QFj+ylVmpufodDrSf4KYgHei0dEPOK+wIJ0zc8vU46RpAAB54InG6/cn15mOR6Di6WD6Cm6c7MaV4QDgScKEx+3gc3ncfOTqoarg0zOJKUu3oSDLFOPvzCV99ZgsbylN6ToMzEA0DiXD3XD/VTr+GV1SIYqAnbTdwKDryq6M0NTBpCSSYe3DfV77rzxihPtZVliOgvmz+M5e+XizVrOnA/xXrmMiz4lP27+3w36397pZhlIsiQTzec+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLm2MMz41tQmPR4KVk26ZpAWwJx8VYQG8qKwodR8oro=;
 b=aSbRp0Bd0/81eJ3BsUojLYjTsm+z4PMZnLx2NlnKrwvy9+yz1rFHW6MrqLwp3XthjnvXWANfI1Lq0BN6lN+SU0VbuFNWhn9KGCJXCAFyoRgKOJ69FwnaYViwAuJwg1Sw5lC5/zReWVzHZ9uBIE0NLooNVb27mYRXhzRLDJ33EYo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2392.namprd15.prod.outlook.com (2603:10b6:a02:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 29 Oct
 2020 17:05:28 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2%5]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 17:05:28 +0000
Date:   Thu, 29 Oct 2020 10:05:23 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <ltp@lists.linux.it>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm: memcg: link page counters to root if
 use_hierarchy is false
Message-ID: <20201029170523.GH827280@carbon.dhcp.thefacebook.com>
References: <20201026231326.3212225-1-guro@fb.com>
 <20201029153921.GC9928@blackbook>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029153921.GC9928@blackbook>
X-Originating-IP: [2620:10d:c090:400::4:cadf]
X-ClientProxiedBy: MW2PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:907:1::32) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::4:cadf) by MW2PR16CA0055.namprd16.prod.outlook.com (2603:10b6:907:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 29 Oct 2020 17:05:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78cfff62-a227-4a7d-5bb3-08d87c2cd5b7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2392:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2392E3D46DB699D89C2C745ABE140@BYAPR15MB2392.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dG9bHpeH+vmT5b48hxAtjnmYSAg65ZhqDTaGJDjJAZU/7GjwGZ5FGI+Afm0oduMylgdB5AJ5X9nXsx6mkEPaNxF67VcNp8ME8HK+Uteud9mWm2eQ/3aZ6gpjU2fXVZHZRTZ/Z+BZkOiXOmQZJsEyyQoZwAuBfQvHaI3ed0yTKTitosEAywLu3neMsm+zL1T5S0GbCwJzw7vVYMg/eKLAppdSBctQLQaTiGHv1IP2NY19vu+W+ExXl98u3x2K7onBOqoswX7PexT3/x4Scep5fHJM7u19QMESpzeo95tW4CmvinZXxSExNZ6xs/4g+EjiIyxta/VmwFCUW+p2zqGH5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(6916009)(7416002)(8676002)(8936002)(2906002)(9686003)(4326008)(33656002)(6666004)(86362001)(66556008)(66476007)(66946007)(478600001)(16526019)(52116002)(7696005)(6506007)(186003)(316002)(1076003)(83380400001)(55016002)(5660300002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ikqcKQhk6EcI4lZFYdMrLWFQVa7LMtDpMeZoUaGkWthwFMm8ryPejsIqJBHwJwN31wZCqSszacyROuW3syMfOzYf57jyvFpV2anpKjBN4F9Ku8uJEqzNjlA3Eyez9glSdSztLHE0S+9NmvUuAKTAYHSY5LB6Hl/lZDd86jrPk4qwBo/k8hhTxvLXNnZgxQkhQf51MsNMHEd77c5AeV/qXTGG5ikPHEPIWVhKfypeV9EYQRoZhB8VkJv6vxM+nFvNOF8qs06fbdyBRYVO3KoyhtfvZI3c4RPy2HjQWQ9XPaAbePZOVSrpChUY5WHyhg2CsjU9MkieTemdadpVmi6JLcRgW4CGoejDJYXoK8SfnyqIH+TvDYn2sUm9sq8xNYrztakbh/GTojIzFYz5J1Ve+SAgl+RdVWqjq7JqIdZVKSqm3X1gKq2fZ/VPKjdW6vNJfB5CZ6OwOIYQeFQqwkgupRg6tZvktxQr5b46snWFs27YNwmU13Si7ZiMcbTh2MDXOIs+GMalWAO+rUSSYlzCFmHXN8KRtt/qKpIrh8LnRru++qG/iZacM5pIGJF+X39IAozKzP0Bc8KJY42PvRKg8Z4XcmUmbqecMEMrQWWtclySe8OhtneBGDh3FWjXgnB1Yp6we24VJhy4IGCmvB/K7dt3TmJ5nd9GnIJrK6ltZL4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cfff62-a227-4a7d-5bb3-08d87c2cd5b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 17:05:28.2082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEiM4LaX6UBTry0FXvnTNR95CnS4gYXM84lBKGTQmdVJYDCpL5lNKUl4u5XcVO11
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_11:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 04:39:21PM +0100, Michal Koutny wrote:
> Hi.
> 
> On Mon, Oct 26, 2020 at 04:13:26PM -0700, Roman Gushchin <guro@fb.com> wrote:
> > Please note, that in the non-hierarchical mode all objcgs are always
> > reparented to the root memory cgroup, even if the hierarchy has more
> > than 1 level. This patch doesn't change it.
> > 
> > The patch also doesn't affect how the hierarchical mode is working,
> > which is the only sane and truly supported mode now.
> I agree with the patch and you can add
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
> 
> However, it effectively switches any users of root.use_hierarchy=0 (if there
> are any, watching the counters of root memcg) into root.use_hierarchy=1.
> So I'd show them the warning even with a single level of cgroups, i.e.
> add this hunk

It's only partially true. The main difference between the hierarchical and
non-hierarchical mode on the following simple example

    /
    |
    A
   / \
  B   C

is whether A's memory limits are applied to B, and this is not gonna change.
However you're right, it will change some root cgroup's numbers.

> 
> @@ -5356,12 +5356,11 @@
>  		page_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
>  		page_counter_init(&memcg->tcpmem, &root_mem_cgroup->tcpmem);
>  		/*
> -		 * Deeper hierachy with use_hierarchy == false doesn't make
> +		 * Hierachy with use_hierarchy == false doesn't make
>  		 * much sense so let cgroup subsystem know about this
>  		 * unfortunate state in our controller.
>  		 */
> -		if (parent != root_mem_cgroup)
> -			memory_cgrp_subsys.broken_hierarchy = true;
> +		memory_cgrp_subsys.broken_hierarchy = true;
>  	}
>  
>  	/* The following stuff does not apply to the root */
> 
> What do you think?

I think it's in a good direction of deprecating the non-hierarchical mode.
Shakeel did propose it too.

I'd also change the displayed message to something similar to we print
for kmem.limit_in_bytes:
    pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
    		 "Please report your usecase to linux-mm@kvack.org if you "
		 "depend on this functionality.\n");

Thanks!
