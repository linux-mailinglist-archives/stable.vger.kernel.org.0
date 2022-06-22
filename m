Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16688556F28
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 01:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359365AbiFVXcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 19:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359248AbiFVXcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 19:32:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5AA424AB;
        Wed, 22 Jun 2022 16:32:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MJ0tQ4027237;
        Wed, 22 Jun 2022 23:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=4OC9DW350JYqjTwsgx8AZe368ECzt8Q1+C8W/DNXJEM=;
 b=DHc7MPjwaLE5AIhewMpfYrqhtagKu7ukdSamG3nbxAQ+UZaG0QlmCdfooqYtZTjhQ4ve
 85XdlI4wH2DgPpb0XDYwOMW2CKs8REM8xiEGbr09Ch2O8+q8Kne6y2Jyd4slVhqg8CIk
 PSln7SlQJ7Sn+xKxt2wXR5+i/NiyVX6G8B3pwVFRglKWrByNR8TGpGBJx2NRBQcZOCqT
 as3hV0ZCJCwXbsOqgYYavbUTIMovDBEyhApIAJ12+AWmtDvwCDhrn2cbiposUODzHpaX
 cwA8PlLxB58x20X8vy+PV7ZfLXw/ghejUckx01leDomnOHdPyjF6uepimAsTToLo0Q/o Tg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kf9jcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 23:32:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25MNHJNs011687;
        Wed, 22 Jun 2022 23:32:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtf5e3yk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 23:32:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFxh2K4A/YGYiiApuZZ7P+2XBdlE+2NHlYvRWADorfOfQMqZwU2O4ach38ywIV2i3pAzzs2tKG5th0+f0PkcTeW9AxgOPEi+Mxh7eHAReo/Y40Vawlp4igLH8j4OnEUSgSxKJkOlTBCk2S+G6+Y3UBdBMQl/Xab0qUz1qis28n6G/JdXNfHi0jt453qyjKSqmcaipzDwccBRG3/CqHkoS6E1qaw98Q1VoWylnY8gxowRn2els2GGHSa/dbWS+TGa9D92azwOrlAen2/bKkSlKsZQ7vvb+j3YG7qne97pQEQzft4RGjbNrglwdveFegcvCsd99E0fxSsCqbfXhdhclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OC9DW350JYqjTwsgx8AZe368ECzt8Q1+C8W/DNXJEM=;
 b=P6++6BjFtvqAfbrkT9CUggwROJLXMO/vl1/TnEAArJX3K+BLHhk4QpCfXqDLHFpHXNIAAN3/BWmNnOTc03V14jt/s8HEHLLE+9XkXHD8tEIeZRaYIwS2F2oeELgKsQ+4z6h6g1vBBMPbi4vrOHuNAxUwpJutl0+ZGI0ccXIgA0jZ2HPOkVRqHS3d5sBBRjfSop0dQQJHyzMhJN5ej4kPZ7Eu0hTkHVNCSrTn9Y6Pcv3YJA8zW3QtYz9FZEHgGv/0cbtd/i9T81DRgUQpEOmzcAMq6mYZ9AE45QqEF5SE2Lj9TGEC4eWCg0gobW7N2nMgwo14bf4T+FIkUkb5OanHpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OC9DW350JYqjTwsgx8AZe368ECzt8Q1+C8W/DNXJEM=;
 b=FoDViTLvpozWLiqOj08vU4hHe4kwRpS5QjVrY0oYE7RfgbjGGJydadfL14zegruwchRBxYqcqidMZd6iC6vcdZjWYHKXH8J+cWNVrpKT1YkJc/3k7r6J5FYkhFGbwfPMu74LqrXs9NuX4n76klhkG22XAfhWFZZ120blrUEr6T0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Wed, 22 Jun
 2022 23:32:12 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%4]) with mapi id 15.20.5373.015; Wed, 22 Jun 2022
 23:32:12 +0000
Date:   Wed, 22 Jun 2022 16:32:09 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: sparsemem: fix missing higher order allocation
 splitting
Message-ID: <YrOmeTHagxHQqUxM@monkey>
References: <20220620023019.94257-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620023019.94257-1-songmuchun@bytedance.com>
X-ClientProxiedBy: CO2PR04CA0188.namprd04.prod.outlook.com
 (2603:10b6:104:5::18) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec34f996-9ac8-44be-378a-08da54a76e9b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4731:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4731864F731BC33E22962EA3E2B29@SA2PR10MB4731.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mVmn9t824uLCVqhJ+ZFLmdAXbBxFECzfz/GOvYDlejVMK7smm3Cis8/bdge8FBOv7ZWwo7L69QRsSed6sHhalAWOOcxK3h0YAFKFU30bzDkhHmvHUiL/+lZOK5Syb17LX382k+tHAv6yOxIKGlcGWnh6zZJFnq5vZ0vTAIJbbr4N8rEVL10nOViQRQiLNBfvECA8BTKpHyrFXVlk206iBZcQbb5yzcZH96Ah+LXOlay2qCqI2667yctx+0B8xfzYas4XkVPr2APEv5EWbEIKVJ/V/d0Dg7KvFk1RruGkKoR+vRtP8OUsTuZpcnxziJislAv/7MLTY4m/q+NhL2MeV8ky5zQXoebbcKSJ1ct79a7ycO4b7fCig7H8Aoo7wJwIspsROQtwWQZlsi04WReolP9UF2LhnD06Ca95PqpDgpMW/E9z5E3b53GFMa57TtVVdHizX/uWAXiTUdDTT5+hPDXsDSRdBYi4s2szW8Mo0QAnlswoQw7eZC3XyH7j+MuH2dUg1Wv2ik/ux1bU6F/LxZrnZrClXwfGmbvDMz8ojZeQOTFvjQ4PJOJRTPfyzpR4jBD3BLqAzX6AcEryekH1Aoukkz/rZDeCDej54SlhQn88d+xQb98HOvBBI6ShMLtUkje3VEvt6pGqyV1St8XYXUobiRzXR2ch9B7bLFqiqkcNR0Npvg0STvRJ2ol1qW+5LR244CJ1p+MXR9wTYBOWmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(396003)(39860400002)(346002)(366004)(136003)(86362001)(26005)(6506007)(66946007)(6666004)(2906002)(53546011)(66476007)(6512007)(8676002)(6916009)(316002)(66556008)(4326008)(478600001)(33716001)(6486002)(186003)(38100700002)(5660300002)(44832011)(8936002)(9686003)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CY8G8bHSKIVmOK+6VYieP5Rip6kkmkNw2ZGtReYoffzfH5Hx9LNIFvJqImeV?=
 =?us-ascii?Q?Tjsw8cPR2kPPcvrq2DSb9zn1V+5JWyttygHS5/rMtLUspzOykoY9RrTNQiBi?=
 =?us-ascii?Q?OswPVnaFF1d68QL/o4HmFGWY9tHZbb9RSbjSpRXu8yk+F8qQyjqwNr4QIu7R?=
 =?us-ascii?Q?C2U0h7a6k/9bsH3E0OeyODPTmVm3KHKv5nv9USTqTBYLJlosbGwmQHeRIQzu?=
 =?us-ascii?Q?neaXh+Xv3R3o8wwbdlmp0HKD7Gcqtn2a5JEhxtt+572sn1uRyAKdqAOZQP8I?=
 =?us-ascii?Q?Oa44jC/1ZWRZlk50cdJEy5QgRqCF/Yf1RwWmMF+ZL/96+SJG244/IZjh4Kwy?=
 =?us-ascii?Q?UoUggtmvUCxz8zEWv7JwmwaMu+CXZ6KyOyX2hwgxbVAS89U3mKz8RREA/ous?=
 =?us-ascii?Q?JdRj0Tt5SaPnQ4AKZQS5N9Ew7MIEvEBTBAPzehBW1yPYN22f7GYkfPAAvCfi?=
 =?us-ascii?Q?+osGIBITXKeD8/Tw0ESA+kmhi4Qp8g1gtGhexyHhe9Qytv0F84nBCQGXXMm8?=
 =?us-ascii?Q?9U8JxD1+8H0TIiscIvyG4BQNA7YL9XF3L9M8mAEK7/KvvYxoTqdgzDdTALi3?=
 =?us-ascii?Q?0rordk7icoZV8Gq9qIZZENYYj4GGn45XryGHzoqnnrdbtkK1hwHxL4VXC/nW?=
 =?us-ascii?Q?vXRYnuB23SiKju8YOQIk79tR2ZJ/o7bJVBfrAwOzsDeoAXMHrHqXO6fvQXAR?=
 =?us-ascii?Q?p5Fi2zASu3bBIHSRU2Z2b4+IjA3/exmb7WvdSyV60bsnRxMHDZHzaLUB2cQg?=
 =?us-ascii?Q?pxG14Yvua/mkj3TZYveLSBWSZzn1NTttu4ogLIJpNLlPuVeK5z/gSqGTtA1F?=
 =?us-ascii?Q?p+9qoCtfu9QA6NaiiupGTK9ZhdyIcSDPe54aKKiqqSY2ZVgp7EUJV26hOJol?=
 =?us-ascii?Q?Dqoocu/m53IHdwiBvwVIXDJIpUeIHDLlVwGHAig6Dw0RJqtD5KgtIvIiczBj?=
 =?us-ascii?Q?o78pNiMIvJa5X5xD7lzGAIgCVQheZ15N0ETlnntlqmhk6NbY4m96bVLcCZlG?=
 =?us-ascii?Q?EjMXzHbdryGLOqKyTMDe2jYYOlMF5cu97C5GcHWX2e6tORnL+dOxS/LIBYhz?=
 =?us-ascii?Q?4Ajb8mmTH6oROkGk9+AAjRRnLvjmS1fNxk99N8TTB/YdC4Cqzz0dbV29itpP?=
 =?us-ascii?Q?2cIVlVEalVlhvxNB29WbVCVLksNHcymFHXqtIy7B+foxqNrhZGk6CJ7QtkXH?=
 =?us-ascii?Q?dHwWz3PM6MAnfNa8OhWM0Ik54PNoix/bedG12yza3URxQMO4aNb5vUhcgXMl?=
 =?us-ascii?Q?Nl3u774979VTgthEJTPf4Q1uYrjCtNz9sEIz+mwW9RQqcQTIo8gVqQ3Mg2em?=
 =?us-ascii?Q?0PE5SMGCylWCOm69iNj7KSgrvIRV3Vu/okev/6+QEsR6KLPP5j6A9y5hmO/9?=
 =?us-ascii?Q?bgCP8i8+xIg+g0ScBlg0OTfxgIfPmc0zYwaEWmyWMFYuZXVpNanPfa0fcr4z?=
 =?us-ascii?Q?k51e61W7DPe31DzKcJELWdIhl4XxuXHpCGx5MJ51mLU/zT6jsBHmZEHaVuPS?=
 =?us-ascii?Q?JUgEI4nZJe6KkjXhJErR3GHxrey5ts3rOs16/cr2Er4udIdCCNCprU/kHSSK?=
 =?us-ascii?Q?nh0mKuHUKTOY5VbHAgEJ7bb/yNABgLhySBAthXvW0MRvItpGdx4m2/2rvNvT?=
 =?us-ascii?Q?+dt2JZ/v1sbQEppuMKEP9epoa+/rb8RarnrkA1Bb4UFCmazvHpdaEGH8B7oz?=
 =?us-ascii?Q?XTg248U8E05Sw2aqoO+oazgd5VuAl45uZE9mAf9FwEQiVqu7t00/jbb6aqf6?=
 =?us-ascii?Q?CM8RawZFcT5BsUIkNKaGD1jkBcpLz3I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec34f996-9ac8-44be-378a-08da54a76e9b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 23:32:12.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+LrUTkaYZejJ/qsVF/YzC510EMyzMXZcAzFAlAx5QHyydbofn0f1XiwxAx0u+rgeyF1Uk3ssRb5AZLJHKwtIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-22_08:2022-06-22,2022-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206220106
X-Proofpoint-ORIG-GUID: 9nup4YoHpgunUFwSneKvrRCzljP7Po5H
X-Proofpoint-GUID: 9nup4YoHpgunUFwSneKvrRCzljP7Po5H
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/20/22 10:30, Muchun Song wrote:
> Higher order allocations for vmemmap pages from buddy allocator must be
> able to be treated as indepdenent small pages as they can be freed
> individually by the caller.  There is no problem for higher order vmemmap
> pages allocated at boot time since each individual small page will be
> initialized at boot time.  However, it will be an issue for memory hotplug
> case since those higher order vmemmap pages are allocated from buddy
> allocator without initializing each individual small page's refcount. The
> system will panic in put_page_testzero() when CONFIG_DEBUG_VM is enabled
> if the vmemmap page is freed.
> 
> Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/sparse-vmemmap.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Thanks for fixing,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz

> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 652f11a05749..ebb489fcf07c 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -78,6 +78,14 @@ static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
>  
>  	spin_lock(&init_mm.page_table_lock);
>  	if (likely(pmd_leaf(*pmd))) {
> +		/*
> +		 * Higher order allocations from buddy allocator must be able to
> +		 * be treated as indepdenent small pages (as they can be freed
> +		 * individually).
> +		 */
> +		if (!PageReserved(page))
> +			split_page(page, get_order(PMD_SIZE));
> +
>  		/* Make pte visible before pmd. See comment in pmd_install(). */
>  		smp_wmb();
>  		pmd_populate_kernel(&init_mm, pmd, pgtable);
> -- 
> 2.11.0
> 
