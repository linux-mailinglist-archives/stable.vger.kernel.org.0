Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC60A2338DB
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 21:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgG3TRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 15:17:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728276AbgG3TRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 15:17:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06UJ4WJr004674;
        Thu, 30 Jul 2020 12:16:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RLSzkMd1eFNA9w5TYxKLieJyLd2sae91YdlANp+vySQ=;
 b=YlopX8QajVILwyW42DW53J0gmDNxJ1JyVP79o6raPY8/Aa56tmZ5oSg3Q4IOHQIgXVMW
 xw43wYMRgK32lXFMAdV49c/0rN4ohEFZGvJeitUIb6PRRIJUWl80t+vWxqD8TBkZkml/
 nkI0S7UUVngybKhYLWBnxysrof9rhAdydm4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32kgmsn4er-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 12:16:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 12:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xg5JKxyJW33uzL3XpiZdTcz3jWjgxvKjtlaLEV8x1o++1lQbfR0TwTL7A+Fl0p9CEWq5Ls7tUWZW90weFD7dfOK4Hd/1bzEeNbDeWeXy1SFrjhGMeiqlZaYurB+sThnHjwKaqBicM+HlZ5v0SSdM9KEWX/+8lLs98bh5fX8uRyYNnBE7EUafKj1BX669l2c72RzC975QYaus3UQ6ObnNjC1rusXpSL4+BJJapZA1ed4ndMe/HBtZARqtPlxqspXRQ8ScmISYx0TA2cQDdkJ/QD9F1MDo7URE8LUHHKXK5vdECIUX/C41ZT9hhfcrSJ5RhS/JWbWK59/CpTGM4IY8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLSzkMd1eFNA9w5TYxKLieJyLd2sae91YdlANp+vySQ=;
 b=nLXCvWxy5wKEl+FDogpplwElLhGgQ/NCRM+jznnXR5GK5C442/3L34moiNW1kWImerkmNo4DSkZ7Of4REf7MRVCQ0G8ZQjZdFaMkpsjOzlKHtAXaGIBdvCA2Jv9coy6qwQq++8yNRkCvCS7XdtNHkUGTyTQSzsUp50KkPv0bhqW7NGsyRLN5PuvDbcChtdXdVv5BWXzKfh3i6aTPMLzrB07hZ/NcpOOF+VgiZBnATyTHtyAeJQcZmTz8UY8agmBrFNgc/kHn+80fC/QV+QYRfqTHxfHzWqBlUuKTfgS9UVn/Ej8TpFimZSMudxIN1HcynVK05m3rdrRtYiEz3RTThw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLSzkMd1eFNA9w5TYxKLieJyLd2sae91YdlANp+vySQ=;
 b=UcdQPLp8JRuboolXSobFRUqhn1g/TADWEo3cq5+KAxWQATjp0KO/q4RR7a6S+vmNLykN/d57tNyZvrMAEJDKPUV3bJyvP7J45JX67RltNSmdvVtAbLywymQQqGTzoNCXJyRXtKvD8K+VuDT8caJZE1t0qFTfU7wsGkp2Ex1z/dc=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2600.namprd15.prod.outlook.com (2603:10b6:a03:150::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 30 Jul
 2020 19:16:21 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.017; Thu, 30 Jul 2020
 19:16:21 +0000
Date:   Thu, 30 Jul 2020 12:16:18 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] cma: don't quit at first error when activating reserved
 areas
Message-ID: <20200730191618.GA703407@carbon.DHCP.thefacebook.com>
References: <20200730163123.6451-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730163123.6451-1-mike.kravetz@oracle.com>
X-ClientProxiedBy: BYAPR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:a03:114::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:931) by BYAPR21CA0009.namprd21.prod.outlook.com (2603:10b6:a03:114::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.0 via Frontend Transport; Thu, 30 Jul 2020 19:16:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:931]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 342230e7-2a34-4f22-df1a-08d834bd0ad9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2600:
X-Microsoft-Antispam-PRVS: <BYAPR15MB260017898C8A7BA573FCCD43BE710@BYAPR15MB2600.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiFkxXFVtLk68YlrzH3Uyp65bRAN71gXCfEE2Z1U3qWTq7kdXbofnYWaU9nL4MV6r6vvGpy8bNvALQ65gjtgz2APWspn4oRfHRi8xDW6brjpNbECiVtscBngAG2bKe3aCmTzU5lCAdpF8mHNOf4esZxNfMPegCKukHKXoHiPupcQAmOsRD/04Bl3oxmYhwUciHRqVYHII1K+40re/uH/EhU7Pu+nr+E5TSQ8QixWsujRjZBPqRsxUz5UbVZHfmciV5VjZtsAZ/vv5z+qpsVbOzTVPbPR2HXdIhrFrR2ASWQXDK6M77gRpiF5rPzh8WuMADmZ2j3zbrAkHUHSjvh7nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(396003)(346002)(366004)(136003)(2906002)(186003)(16526019)(66946007)(83380400001)(8936002)(1076003)(4326008)(6506007)(54906003)(478600001)(8676002)(66556008)(66476007)(33656002)(316002)(5660300002)(6916009)(52116002)(55016002)(7696005)(9686003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3GYrhXaiTTrNUrhL8rMqNlyNTmD3V3GY/j7TBnYSFPgP2v4MT3IYtQ6fjzjfYAnzRTTt5NTllSdR2p/+kIo3Hh4/GPrkX6da1nOJLNvy2cIdKJZ+MSDvu8FEGTji5wZ4jEgmRWa7ZFzlwMbeHwjVqStysxK8tB45P7eUOWPjfkuZcax9ug/pI5bVfCVFS1ecW8T6Xqu1nU09lAz5KykFjJnch3GtgyOiJ7j2VY2olXVz0lfMB5L3rgDM2VtISjorIkuGIgxkJq13ggrmfgAbsimplU+yM1vjhqnsg6m8w1Bqr1rbIJ7f2NK3ut+L7/Cj1uVFjwr5sF1e7NC7GjvO/4bXynlHM6ReXZX+z8zvgHKrlvxrm6YyWkohHvAKPK+L9HC1Sd2crbG3p4vInpsbyE6/P+oh5y04d2by2sAPIs6/NRYO2jBWzmPWTNALDvVE/DbmucQ3KLm05nQ1t0bNqYPpRO/tWY2lUyQ3S9x4dxVF8BxPfrpMWoLiV+RZ73i7SCx3T3k79koB8oNgyLZ6HQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 342230e7-2a34-4f22-df1a-08d834bd0ad9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 19:16:21.1107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXMlSIXuWQzVTNPxrPd8P04o98jVBSLVJwJRv9rot4Iz2FjvJEQJ0kDKt3CWrI5Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2600
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_14:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300133
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 09:31:23AM -0700, Mike Kravetz wrote:
> The routine cma_init_reserved_areas is designed to activate all
> reserved cma areas.  It quits when it first encounters an error.
> This can leave some areas in a state where they are reserved but
> not activated.  There is no feedback to code which performed the
> reservation.  Attempting to allocate memory from areas in such a
> state will result in a BUG.
> 
> Modify cma_init_reserved_areas to always attempt to activate all
> areas.  The called routine, cma_activate_area is responsible for
> leaving the area in a valid state.  No one is making active use
> of returned error codes, so change the routine to void.
> 
> How to reproduce:  This example uses kernelcore, hugetlb and cma
> as an easy way to reproduce.  However, this is a more general cma
> issue.
> 
> Two node x86 VM 16GB total, 8GB per node
> Kernel command line parameters, kernelcore=4G hugetlb_cma=8G
> Related boot time messages,
>   hugetlb_cma: reserve 8192 MiB, up to 4096 MiB per node
>   cma: Reserved 4096 MiB at 0x0000000100000000
>   hugetlb_cma: reserved 4096 MiB on node 0
>   cma: Reserved 4096 MiB at 0x0000000300000000
>   hugetlb_cma: reserved 4096 MiB on node 1
>   cma: CMA area hugetlb could not be activated
> 
>  # echo 8 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] SMP PTI
>   ...
>   Call Trace:
>     bitmap_find_next_zero_area_off+0x51/0x90
>     cma_alloc+0x1a5/0x310
>     alloc_fresh_huge_page+0x78/0x1a0
>     alloc_pool_huge_page+0x6f/0xf0
>     set_max_huge_pages+0x10c/0x250
>     nr_hugepages_store_common+0x92/0x120
>     ? __kmalloc+0x171/0x270
>     kernfs_fop_write+0xc1/0x1a0
>     vfs_write+0xc7/0x1f0
>     ksys_write+0x5f/0xe0
>     do_syscall_64+0x4d/0x90
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: c64be2bb1c6e ("drivers: add Contiguous Memory Allocator")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>

Makes total sense to me!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
