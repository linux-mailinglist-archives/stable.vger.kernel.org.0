Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4E58AFB1
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiHESXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 14:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiHESXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 14:23:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BE6DF4A;
        Fri,  5 Aug 2022 11:23:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275H1E3W002662;
        Fri, 5 Aug 2022 18:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=0e3RGCuvUuxtF95iPMfvFX2Po5zRBFdpKuNuVnz2PRQ=;
 b=n3FcTAzXM4E8OE2zHQQ1x5cgj6LuEuL+9AU8RCaIJ4iaQ0/3Qy+rnQ5TkJA7dzAgFHxx
 tyO36HGX0na7OWiLByM7bOV5aayDy/FE/h/Zo9D+Am0tt9fTn4NT4G9U1Sdz7QIvt0G+
 WiJAbPW62gPXPZM4cjQLNkPm9V4PFKmg5MMJdC4TyYf5S9VipyKawkNvPtIcHtXff8Eq
 UbEy5NOFdNFIlA0f1L/O+NUt7o7CCk+zGErCF8x06MBz3ElS2MwFbEBTOSvy/TJMEQKY
 jaYnN6TkQevaOf0UYsR97vYflF0CqMC87uEixkM52OixPf2lUW/cGd9YOR05YbkYvmFR Vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cg3jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 18:23:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275GvaRr030891;
        Fri, 5 Aug 2022 18:23:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu35nw5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 18:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFIshoo26NlLYc1rrXTkqX2xCa7If/voNt3pV9cAZzUtkx++blcm3yWIqAMnQvYo0XBi/1Or6mdeMUZOOeNC1XYY+rCR8pwAEcUuQoV2fHBJZ8wqcvBUa7E9g1EjHAW69UTfDMJCkKqoWXWjar/hMd0nRiZE4JDW24eRmvqjJAumS/voGDKycJnih+cM+QRtTM23JD27+OFKhRfV8itItMe8WM4clqe+G83bGBIcTDOP6z9f3x7KVEcjcoF0+PljxghmTV/xTfpBU/8eeg7IAQCWZQ/qqIOYuMozV9cVC+L8Kf++NPak2lJP2zDSDTUdz0kTQEIFs0mGz6QM+eufJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e3RGCuvUuxtF95iPMfvFX2Po5zRBFdpKuNuVnz2PRQ=;
 b=n4rp7PonCG0VhoIgHu0BzvfC7d1XE9Ykc8QMVBeTMI66flCWXmeLcxrYeJgHh3tF3BUXwgxZo76uirKvT2joDJ9GHKy1InFKNUNnhhz4LVsW1hgbr+x7XHY6dZUrKGAVUlqchoJMiaWY28rEiQ6qtLFLjVA5JwzDBDVKSwQddFZEKPrW9PKzVGrn+1TDy7OCNa7ew0c9v3w8cgfWdt9njPWLYGgO3e1sUHWATtl/4OGP4Ulh3rkdZy+QoInREjmMOUrQKkx3jG4Y9bBx86lXrDkNfK5A50ppE9dmvPT+bZeZBJvjmGC/q/ENCYK5DhuL6czywOFyOrg0ojoCj5VeRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e3RGCuvUuxtF95iPMfvFX2Po5zRBFdpKuNuVnz2PRQ=;
 b=Fpx7Z8J/QGqaNXY4wL6EpWcGaoJWmsbRL/969yplzJ9L3R1cmwJ1IiaS662JJw2zEE1/QdA9T68oZUQOeNK9hPipdE82wHc6BI/jg7xYobAUX4GPSvG9EZxUaC53GM8m1XTSRNSL3BK/0GEPmh5WrOYH9uWH/PEPOCuIzfaHdtE=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN6PR10MB2477.namprd10.prod.outlook.com (2603:10b6:805:47::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Fri, 5 Aug
 2022 18:23:29 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 18:23:29 +0000
Date:   Fri, 5 Aug 2022 11:23:26 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Message-ID: <Yu1gHnpKRZBhSTZB@monkey>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu1eCsMqa641zj5C@xz-m1.local>
X-ClientProxiedBy: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87da9d8a-1c86-4b76-32f5-08da770f9879
X-MS-TrafficTypeDiagnostic: SN6PR10MB2477:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d4Q1WJ7NqVruwVgC1oxGlxevN4Fb8dQehLmKxzI4zQI1IJdRUzqRmaaE+YeUazX+GzoGzoN3Ywd3/DCx9UA2iHVKPRXNFvIXgigyHzsEeB0zIoX/+WnmCSzNKTd+igqPxvUQLrjS+co/dNOzwo7Rddm0KHC0AtV0jrI/pA62mhj7/YG8vWw+Q04eP+BLGvEVb7ry7KSI4PkV985Ia5S5aaYDgxOTnpDScrIGpglVPuykYNDKftTN//WSAngtz38TZp32zZDUw+IGoSJ4rWV18noAVbDKo7BV9ymD6Uhm7BjYe9oWi8Sf03Qs6xutVZylKwu4HPKgeOIqX/2v5hHFTJ/Z8MuotZ1BqtIB70xkKyE0kX/yA8siRI1MPeeNON1SGSuGMYxfrq+UJzRuaO9Z+mnEHzQ2B94JM5Vf5sDbOU/bQQAX7KNzOssS7IjXlFh4tcNqe/9ursc6zPfPtgKFvPQYunQRNioe8sNffJ3GdlQr8fCDeq5gri0Fuyg/lpfsmpcA69wY+k3ZzVGgVW2NzhAnZG+WqOvZsIfD4RoMSkdJ3bWA/lGh7MgwT/xzLjI52iZSoRigO+feAC1UKWCo1QdIHmrj3dwF7t5VMhc+AKpbzH/d272Wou06nqFM3PsgFWbOcOXqbWr+V2d+H8uaMjo1cBYOOy4mvMCDiVkn3lG2hICBsmsr00r8lq4xTJsJHyiVE7D4qlRIDDkLdVhEPz/YmytQa7Tvp2DAM1C9ItfSlilAfTllgxHBcUEUrZ4b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(39860400002)(376002)(346002)(366004)(396003)(6486002)(478600001)(4326008)(66476007)(6506007)(8676002)(316002)(53546011)(41300700001)(66556008)(6666004)(66946007)(6916009)(54906003)(86362001)(38100700002)(186003)(26005)(6512007)(9686003)(8936002)(5660300002)(2906002)(33716001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hYVN2MX1CCGFrCcJR9LapgATEEMCcnCd09RcKR6khvw2eWDhvghOE9iRFijp?=
 =?us-ascii?Q?o5VfCEzrU2pb4E65RyLWq2HSFBOmnC6FYWAt3mSn8b36py6HXG69pNDsiL6k?=
 =?us-ascii?Q?Lq6nvOjkqZQ/tte57gyx+HzLYagSgKZbTh5TnZc9hWSEA7AFKo6L1/OuKpND?=
 =?us-ascii?Q?SKn0GH4jMunqumeTRHI/1ma+VpdJkKaIu9MuHbbU2/UwmKFQPiOIKo22COL9?=
 =?us-ascii?Q?tWWvqv7SCOZ6XH2zA6pvq8ih0rKdJzSgIaBVNAepTGBnVNrp87zMJ4ZVB1Pr?=
 =?us-ascii?Q?xozDhXlhuhzKa9XwiYLiiUAU3bZ41ZNvLnSkFNdcbxloCarZhyd3ECA4fqNH?=
 =?us-ascii?Q?0V1aflML1OM2BPF1HwWa/wKIVudOQjiIO5sm6hAEJjnLo6lqqbZRUAmsweiO?=
 =?us-ascii?Q?7G2KrnT1QXpbQ3QwmzFFvAwHjVC2sc3nSGkt4id2sf5QFEYoD+ljGBHXwu7z?=
 =?us-ascii?Q?h+hKvS0a/3G2W0K/gdRXlbdZx/HC6Z/dVXu9wXYaBPDkrI8OZWXTAmy1/i9q?=
 =?us-ascii?Q?qdV+4hG+Qh9I1Zus2m5lIyu9xkS6fUqxduKbssgbLOtVfQC7Fl2DxAH97GUE?=
 =?us-ascii?Q?iMNyY2S8drajkNDNyYIXwdqHrCxX7+pf019jIZe0365Oyi9CWMTDhWp3FnLs?=
 =?us-ascii?Q?6b6TgZ4cftGtEqHoO8TTiUHS6CTBHDwDHGVEKcfxxSdUSQA3wYQVb8elTzWG?=
 =?us-ascii?Q?rp0wMETr/lKfguJm1L/JUXdKauRRNbg4fbEuFaPrZWuTANjahSJhEU+Wv6K1?=
 =?us-ascii?Q?cqOmS3jwIOYAujntXUw/sboBUveG9cjpSlYikZGl3Ga2zZHOjWhWT9u/2yPU?=
 =?us-ascii?Q?yK6H3m8A5u4L6KkGz3H0MScjnaYIOXyw4m39aQhkdgfxwvmBB2FG5OgJeVwZ?=
 =?us-ascii?Q?ftXUNjU7jmwbSlyyqo5G0tTxb06rJ420cVFAGKPo1yLajLZNPJrD+Isw4ksu?=
 =?us-ascii?Q?jx43AxxmmSNrq19/AKZ7hFLYfDYAM1eBlaLtiMXOetf3kr1ChYUH9vd5eX2q?=
 =?us-ascii?Q?v/Wmp0k+KIa7EIJbbjQ+QAdkeuLgU7pZ7+Cmy32hfOVzWAOKEucesZ47ECyx?=
 =?us-ascii?Q?R36n9mUvAmHpeHkgVAsqdRJyn03OUKbBRYnAJ3muUo0pdlhDh0JoxIlp9F/v?=
 =?us-ascii?Q?V560quH1Yjwes/Driney1j3wxtKfcPY1XMWag/2zMgD2yMpjOuvfffNgvaev?=
 =?us-ascii?Q?CaAkuvMWVe7XIQZcA4MmV/yN4cCQwcY/1jpJ6ibDNb7uR+/msUQOyp7kjx4X?=
 =?us-ascii?Q?LZvKgAPW6plC3EK0+vQI2x9JeasJdYYe9p7IYWmUc7hA3N1b9qan/x12M+ZE?=
 =?us-ascii?Q?kKLl/T5AsvLA4mFk4p+Ng847x16I00xaslKJ1oe7Al0vmgcxkdF0LCP9rQZ2?=
 =?us-ascii?Q?C09+a40Tl+4BHXrpUOJQlEq1CvoRWKqZFm4G5tOhsyyruJR10ZQDh7Y4Bp2L?=
 =?us-ascii?Q?nnY+H5/+7GA0vamLK3T9G6wrBiOmqdfeJOYo8wK2biUqA7YzvTfeg5fJXTgX?=
 =?us-ascii?Q?H68wlDoKvpUgjX+wdWO22VF0TXlHBz1993fy9FNGUEKK+ky4qkH8Zcbe7Qs3?=
 =?us-ascii?Q?G7ZV5Za7g77jPWbMiBAGnk9kZxI8SV8KacCGP6BREyUMjUDASWgEu7oX4+QP?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87da9d8a-1c86-4b76-32f5-08da770f9879
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 18:23:29.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJ5gXMI+K2FYZl6CbwGtA/jyS3WMV71QSjqNgBuMqf0EEuUp6c/yS2rOX6AuG0h0PpTMLQd82XBPoFkJNhGuDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_09,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=818 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208050085
X-Proofpoint-GUID: 5Swp-VW_jahSiWgCmOryZNXP3kdXvtkf
X-Proofpoint-ORIG-GUID: 5Swp-VW_jahSiWgCmOryZNXP3kdXvtkf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/05/22 14:14, Peter Xu wrote:
> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 61e6135c54ef..462a6b0344ac 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> >  		return 0;
> >  
> > +	/*
> > +	 * Hugetlb does not require/support writenotify; especially, it does not
> > +	 * support softdirty tracking.
> > +	 */
> > +	if (is_vm_hugetlb_page(vma))
> > +		return 0;
> 
> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> hugetlb but here it's explicitly forbidden.
> 
> Could you explain a bit more on why this patch is needed if (assume
> there'll be a working) patch 2 being provided?
> 

No comments on the patch, but ...

Since it required little thought, I ran the test program on next-20220802 and
was surprised that the issue did not recreate.  Even added a simple printk
to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
We were.

I can easily recreate with an older Fedora kernel.

Will be trying to understand why this is the case.
-- 
Mike Kravetz
