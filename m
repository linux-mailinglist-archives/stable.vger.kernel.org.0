Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1772E6C23
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgL1Wzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729314AbgL1Tl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 14:41:56 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BSJemjD031984;
        Mon, 28 Dec 2020 11:41:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3jWrNH8bNIYlCChXjhVKfCvw+Hz/BLtjGtZCWgGWf28=;
 b=JBwXRUZv08A9l/+SaiyPLAFHICAeKA1mI28zJu9lcFCKFGyZ93iBzcsDlNzijdbRwDUf
 J3wibNyDUjxVGLlxrMUnqSPmxJTv6ANCArhEgSNIotwjuk95sGfBI3G+If8Yv0H454Lu
 xIOhhHZS8hvNeemFB2w3ltvojfZZUk7COa0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35pp3vmsck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Dec 2020 11:41:04 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Dec 2020 11:41:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8zDdiSv5EBZNLhcsi9VxxKVT0e55iE3rxLJY2uy7MiVkBUKL7K9rVEvM2Yc7prITwaPi0qTrT02jhK5wIeGu/XiWccFK1RPYzCsdMNGRjzPfD1hvbhuDOPaBqS0WrN8O1oGQtnCUJKhQFxCHiqIv1GRC4rUyXVmPWdXO5JGg3pzB6zvVjMhnwcmbAHXFxxHI39x7YmyljWuwKqKeD0+Cpxvs7ILpEsTmyjjnSWa1kHEiQFN0jCYUK8UP0i4lWt3F0BGY4upnrCy8rH4fN9nwLFOsZhW48p0/fTz/Y6/h4ueoeKQNW2hs0L3N4T+s2zSDIzvVk61VP+UXF5d/t3Zag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jWrNH8bNIYlCChXjhVKfCvw+Hz/BLtjGtZCWgGWf28=;
 b=bYr9+XIDWiY+UWbYKAF8Mzbq+vFEbGS4dQ0KPb/nfH4dmNcrDfOYSlDE/1zG1NpNn1t72QVKeMXFLSBhWOjeXqXAM5irfSu51TZAfdD0e3HGQOVeGqX0aA1KsIviG7Q/74YQ2bI7dp30OPzhrZIo4eHPQqv5RVYczMot6DEZOiPxezW+hPrj9ndmE8j/nLiULI2ROmw5Q7tIcbFfCRQqFxxjqFStnLJ0PlZ7Esb6dZAWliUb6rD8DUPw9u8BtUsLB5vVT22JmQEjQwsyrj4xxd1ZxQrdu/xwdkkSXKWnOLken2DjOpeR1pJFMscLMWJnwYYzd9ECbROdqqXZIFEnIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jWrNH8bNIYlCChXjhVKfCvw+Hz/BLtjGtZCWgGWf28=;
 b=WuQo+qCcpm2DK9HOXC4ImC3nuO6PegnUh65osYJNN+az++qNKyjkOdeUiLLwsnx190b8rCbVpWgvOiL0vWAoDlAjasJQTMLW4PV8ztqUsDQCqoreAbrxExvdiqatvOhIbZYjhrtS9OSnQn0mH9nNjBxPlti6wBOmL/zj8Yc7Zus=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2437.namprd15.prod.outlook.com (2603:10b6:a02:8d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.31; Mon, 28 Dec
 2020 19:41:00 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::ed8c:29c3:6ebf:3e66]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::ed8c:29c3:6ebf:3e66%5]) with mapi id 15.20.3700.031; Mon, 28 Dec 2020
 19:41:00 +0000
Date:   Mon, 28 Dec 2020 11:40:50 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: fix memcg file_dirty numa stat
Message-ID: <20201228194050.GA318614@carbon.dhcp.thefacebook.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201227181310.3235210-1-shakeelb@google.com>
X-Originating-IP: [2620:10d:c090:400::5:85a8]
X-ClientProxiedBy: MWHPR14CA0031.namprd14.prod.outlook.com
 (2603:10b6:300:12b::17) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:85a8) by MWHPR14CA0031.namprd14.prod.outlook.com (2603:10b6:300:12b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Mon, 28 Dec 2020 19:40:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef571b43-ddaf-451a-21ac-08d8ab68812a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR15MB243713173632E66637F81B51BED90@BYAPR15MB2437.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJp9/kW6o44O93jbYAzPR/nHKACzhPktPLakwitP2vi83Lwve09yYOesYBAn0YQ1dguIIug0XeKxQrunvI8OXolMc06Po6AvfYOgJzpLiI6NS3y3ezNWX4pTC5ycTSGcb06752d9NXkS5QJHWtu88VETkcDRMJ7rZRowme+1KC8TDccV0/hD+ckSwvsLBC/RmbaAjIrm3FQ6FpxyBwsEoFL2d+wsFiH+7ewXrxfhVlg0tlC2VfGzpiv9cDey0pM9jl1PptUIF+W80fsyC8Gcprah7vbq9O4wYXg9OWSfDf027DFQKuOhKsZG9DRpItdbOtlcKPRZHPNAMbWBaLNnwq1XwyMKIq5A0+x5ZEPKeDG+5bDUvdGFGjY8jdnGqzJMzJQofpNzz+ilmxtrecEP0vgrzLoBG2L/CKiRLKHQ+HiTI5teMZIaPhuOxPRCD9ni
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(33656002)(66476007)(66556008)(2906002)(9686003)(7696005)(52116002)(8676002)(7416002)(6506007)(1076003)(6666004)(8936002)(55016002)(86362001)(83380400001)(5660300002)(186003)(66946007)(478600001)(6916009)(316002)(54906003)(16526019)(4326008)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ngchmYf86gqwRypjeFyS7NRKG+jEKC+DVFKZiNWdfqky4jHvrcZxxbLxFC/S?=
 =?us-ascii?Q?oZt5cUlRuEv3+SBnAOAdnWmteFh5lfDD25MDqz78XVbqOT3VOdcOo8woEdXu?=
 =?us-ascii?Q?EX8nVT/pcC0a2FGAZJ9OiurVRUOPcnGJ8JTNZzXB5ImjetUkMWzoSPMmAKto?=
 =?us-ascii?Q?E6NioLm6Wvydx4WB7u58jPziPnY9Wp8mTm/g8wQWbQ/ZzDspGFQYZKqLl8NZ?=
 =?us-ascii?Q?LpAbnBvPHOSb8wL+mZj3Uh26ciH1bdnTdzut7tzxETyLp6SaMthxSRolX9X9?=
 =?us-ascii?Q?Nx/e2aF4mOhiQxTEqnTWp7/7BjLe0fdIscGupDhlzJEhm8R33j+klY4nR8B1?=
 =?us-ascii?Q?DLhLKYAdJskaTlcn06EiDJz5Lna+y5wVf5IT01Lex/hYc1l0vc6lHMPZ1rss?=
 =?us-ascii?Q?H3wdbX8ryNl/wGs4Z0akjvlN08bTF/b7cebk70R4AWsgcOAYRN4hXvaUOHdp?=
 =?us-ascii?Q?O7fOna1nmWNl5lSffrg6X2hcZrvecz9otYmgP3dfkbNoYqiee1WeQPpK5IdL?=
 =?us-ascii?Q?vxqQ6g4h+v098bKkHCOfQBt68msTbelcTnxsfEFQQo4tPEP9PSxknQLZ6NT2?=
 =?us-ascii?Q?wYRofjj84as1l31ahmjirQqrKKz7cvQaUwOOvpbWVPZxkjk+cFdbJkvxTScl?=
 =?us-ascii?Q?erQndsFA4/DdBF3yzSWLBJ7ts2VgVXNMRbSNbMA83YnnKbx+KCA009UtXu9d?=
 =?us-ascii?Q?6za47OSsuJp+mUQrcCEFXs8LNeEL5Q8F5MQEhHjEtVslDiq5P8EaM53i4I+B?=
 =?us-ascii?Q?6f27p8ubKnu9v7MFbhB+93//oWHTby6+XwZDlIOn+DaKSDMlURSzzsVr7Udj?=
 =?us-ascii?Q?GqmZRdcxFiwt/MEBCB8PKihSMekOOoqqlbv0jbB1pyvLcIyFy64AI1CGgC3n?=
 =?us-ascii?Q?IR4dzHOV3UKYdX4i4zkArkZ4YQJoPH5dgn8oJ1ZTF/cRnIZSVl+eMg+8wOMi?=
 =?us-ascii?Q?IvdzgSarPXZt9sQdLgNPcVkAiYbk75tHxuEUL80xftMZ/rwb2qGZ7cjk+mL4?=
 =?us-ascii?Q?tW4+vIhQtX6Kvpj2CzIC+FJZ+g=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2020 19:41:00.3816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: ef571b43-ddaf-451a-21ac-08d8ab68812a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehjuwFLcTt9YEfX3Dz4Bzch77pAOToYKNUztqKn7Gh8Xuqc+yRm0iAZwGAFLy/Lo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2437
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-28_18:2020-12-28,2020-12-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=989
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012280120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:13:09AM -0800, Shakeel Butt wrote:
> The kernel updates the per-node NR_FILE_DIRTY stats on page migration
> but not the memcg numa stats. That was not an issue until recently the
> commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
> for cgroup v2") exposed numa stats for the memcg. So fixing the
> file_dirty per-memcg numa stat.
> 
> Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!

> ---
>  mm/migrate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ee5e612b4cd8..613794f6a433 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
>  			__inc_lruvec_state(new_lruvec, NR_SHMEM);
>  		}
>  		if (dirty && mapping_can_writeback(mapping)) {
> -			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
> +			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
>  			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> -			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
> +			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
>  			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
>  		}
>  	}
> -- 
> 2.29.2.729.g45daf8777d-goog
> 
