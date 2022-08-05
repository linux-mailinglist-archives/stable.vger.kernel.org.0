Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A330B58B2C4
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 01:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiHEXeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 19:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiHEXeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 19:34:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FEA1A81B;
        Fri,  5 Aug 2022 16:34:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275MSlj2018537;
        Fri, 5 Aug 2022 23:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=h9cQ0TArqytu4x6GHJTgAu71+hUKwZPKMdpV02aTnUI=;
 b=IXXEQDUxuPUkTlW3A7veZoKqDPdBNSn1p0qHCjHxFvvN4LMxDnFU6HdoXGJmNROWOeeI
 Pfgfuc8SHTjYPPIty/xjeiXhsFOFlOct/n7lgt8/jS0ITFid4vg/vWg4btQUSI//TSLx
 rHGdaqwiPDYstkprdH7UA6yL393rLEmMwEd5l6MQV7UiTFgNk2GcpLeCdky+JjEfNGyi
 BlaJnohU2uKvZBuKmRq5f1JlwVCsroF5W+Ezu3siNyMmg1JpL0naOeeKZjZI/dtb7jMk
 OWStdjE77EAraciXHfPhoQoA16LdRpZVtfYpO18c/TqVRjdiHdnqaKIrUD6LhcNRYWnN rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvha0m4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 23:34:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 275JjbnB000950;
        Fri, 5 Aug 2022 23:34:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57updkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 23:34:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJHsQq83AEMKilS7nwioV7yUJ/OgLFken5TiTYCfJEHBuVuUaY2f9NjIGzSow+GhqpW+C2KISiKtvCy2tEgxHJXKbmTAAzM2pub6mQvV26pamoXGNN06t5Iu/c+i7iLx+fghL34cQBh5qFwH/avEXKhm9jz4Atwmecy/d5ZD3z1qOqstmSXsr2YJRNWRgZwD7hh/oycZisHtNNEfprxWygSR6ibH9rTU/5M5Z15OIfCvEIbYRQxCjXxPkYa0SRWnY0he8Uc0Whg5ViYp2BRx+qnNmO62uPx8ePHqyKiRLCHbj94l1Vh+7ehW4Np81OVNXhFlsPPTU//x0pA7QHB3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9cQ0TArqytu4x6GHJTgAu71+hUKwZPKMdpV02aTnUI=;
 b=kmj28INV17FmjlRJJ4NfXP2cFEKo/VC5Cbz9Ca7u/wUe9sQsDZ2dKwHdCw+O1bdk/ekWgtsuW6FI6Q6a9vIcZnGmayiy4C0SlmRvtVljD5sKBQ/zaiKvpTeNMJIfBI8E0XP/H8jVG8Exyr/i5jvR7BX6Zg8EjZgoEvft5hZGGwZY9l22vN5NSRTzNDy3T4VsF4a9LRRUMOpzfqFMu0Sp/RkQfteg6eUZPPHVsrkoIyveneoTyju7NvacfWPmYln4COmb/RheELh0jOZ6yv32idRY7LE1aQeDE2iY5Yb9oUe9LfkMAVmL2dXIa0uKxtaKPioV+xbPqQkrkLOZrMn0Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9cQ0TArqytu4x6GHJTgAu71+hUKwZPKMdpV02aTnUI=;
 b=BWR8RiODxRL5ZC8Ythhf8E+PSiSGR+pHLGBTiNRQ8VE09EOhRDeCRzOawKGG7ObPENQ6hIB41PGoFZNHE0yViWkWCbzEvsl4UyNA3D6u7AwwwpkL2vnTO0gaCkDYq3e1ZirCx3tgBupDngEk/vkMpexS1OVkQekE6LdW3ZyZPmU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DM8PR10MB5464.namprd10.prod.outlook.com (2603:10b6:8:25::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 23:33:59 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 23:33:58 +0000
Date:   Fri, 5 Aug 2022 16:33:56 -0700
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
Message-ID: <Yu2o5DUncFywbPFS@monkey>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
 <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey>
 <Yu2kK6s8m8NLDjuV@xz-m1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu2kK6s8m8NLDjuV@xz-m1.local>
X-ClientProxiedBy: MW4PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:303:16d::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 591a9116-0ecd-424a-b8ee-08da773af859
X-MS-TrafficTypeDiagnostic: DM8PR10MB5464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3Iz8noEjI89XVUdwCwYwA1c0UK0xWSBmilq09dBfFLX9x8LKbhZx3Jrd/6gHEZj6NKDqUvraASjrfx6kyPT/ykwwYmYzrhl/rO7+1QzsOjbIcb5GMvVrjH0BC+HJ0nzZEHW9Abgh2aerJqBs63zmF75/lkxuBbzmOWbX/0JyrCT4nCfde9e0YrVFK66op0nlEHHicc1MnWphEwu+iWjz/ZzxEV1MTpiLaEq9t0opdwL32409iQf70M5YrtYKJzU81rGHDdQFGvQ9J84T2KzG/jhxQCj99Cadn+n0Igk3Lhk5d5r1zkd/5+jrkSUuo5ORBt3sHtmH0RZuIiQ1iPS81TGK/K0j+XgUwZKQR1BzQcNv8FG7+rKaFkCZzBrcpxBPF010XWP8DXjAWXfYBXWXExncZk4N9fV82o9hIZOZ++hLirXHjisKXsunO2DIZZOPN25CxfaabeQIU2yT5MmfVjSe5D0GdkoqDl9xkeyU5Nj8aiSgRD80OU67wsUE5bdScitfFqm7sxnkIrkdEo/5W67sA2jL9yiiSxAwH0KBubJRLwWirxV1T/msAsLVLAGvOWJhdt7nx3e5tLzgKlN5PowZABGIyljveHKCpr5JVDPxhvNYX4gM0MemQ8FXyMCPtWVD7Bb6CFgI+gpiSZE/WwWbWWRDBvKnzRnEsa/S32wX8yfII13ZORXfScAH+/I5PT4kJjoG7WAIxcA8W7CSQKg01FQsQHBbd1PBL/ov3U6O6BWAPJTe4iw3D9/tRfUrNq+md+NMY4LfYZ2BcCanA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(396003)(376002)(346002)(39860400002)(8676002)(4326008)(6916009)(5660300002)(66476007)(66556008)(66946007)(316002)(33716001)(44832011)(2906002)(8936002)(86362001)(38100700002)(6486002)(478600001)(966005)(41300700001)(54906003)(83380400001)(53546011)(26005)(6512007)(9686003)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hq8dvdwi45WthZBBx5uhhZrZc1XQm748cGU47M0uv/qo1a+bAkv05LL6aYZ6?=
 =?us-ascii?Q?3vz/SM7kyeU46s+9qSrR38dc0yRKOPgKDZME9zpNyMTYjObuX7nZfTFU2Wkr?=
 =?us-ascii?Q?RQu2+mZwKBXh3rHvauzWz+AORDyq9PMGwWSQjU4pNp5RL6P5LcK1tuGSQWW/?=
 =?us-ascii?Q?6NVZsA3ec3XZ6MY0dd+EHI1Rrwz4Ux6V7AU6NL0G+KoGzAIGf2aFeEux1lxd?=
 =?us-ascii?Q?Y9rMmPaFWGwuZKAKTJtl8hFSupKKpKs9IiQRSyzuOSQvrvZMdmzf/3LPjHlE?=
 =?us-ascii?Q?OrfKlI9gnQnNfJsaKDcv2ZyYFVdd2QZ3QoWcaKscBI38vrzAX7mZDxyCG6+a?=
 =?us-ascii?Q?V9WHkR2qplzBOQW56SATfAelqI0fApGM4IznSIVGIg8b40T5rlU0rwHu9uem?=
 =?us-ascii?Q?2+HHwPdadZm233bpArR+VJzDztvPEdeJYmsQzft1R6zrtlhlUg8P1TQd99O6?=
 =?us-ascii?Q?/VDsnwiHswgCg2gPOiT8kyopRS0smhABAzwPxuu5JcoUUmJLoePTHTLXVdNW?=
 =?us-ascii?Q?RYkq39LgcqVnrup7WyXpGLJ/KcS8V9/kC4SJpFSGeK6Jn0gf/gLE9DYhXywC?=
 =?us-ascii?Q?/3jjA39S+Ybgl8nrSYqefynhs7H15SwG3Cnf+0Azh+QBAIoiXNXqQMZuq+eD?=
 =?us-ascii?Q?tv2xQBybQclWiy5fckmfzMymNYCJwqJe2eI5Zs3A02bRnT2qojJxhVcZ7keq?=
 =?us-ascii?Q?HgII0CQZZDsVHzuoLw5E2S3HeWKehSVmZLZT0MK51U5QOMCYh48Qbm57aCIZ?=
 =?us-ascii?Q?8gmLFo0Ps8NHl6mpF4Cvq3sGHJN2HdoU2/j4HiWBrRE76So2xBWl5II6Iifm?=
 =?us-ascii?Q?i0PHqtompE3d25JEQrCkVB9HpV8kjV4On/ZlAJj14Ev/8G2f792x1rRTV1hN?=
 =?us-ascii?Q?jOnqI2eCdA1uf0vo/Ag2pYKI1jT6X/sFXgYHHxc4wMf0qYIcNIQ1SB1AeCni?=
 =?us-ascii?Q?Ko1UICQ4PtU0Msb5wVmgKdHBHjpZjCOs/pvHsnUuqN80mfaol/EyUiouBJld?=
 =?us-ascii?Q?KcC/0JOMJALCzHnu7nOxWsD7m22qzvdy4c07c893gGZNiy/DDQReiYbfi88I?=
 =?us-ascii?Q?8PXDgi1lPXDnrvTm8LulO/a+HoOCldHfOABTZpq9xt8UDHJxnPxaO9ZpTkOo?=
 =?us-ascii?Q?/zSpSoLvDnUGwwnVsEC2FufEeUmeN7bEi2LrECz7rVbv2xlH6jBpo8LgVS2A?=
 =?us-ascii?Q?Vsw159utAKwV+0vwtzH1xQbrGzEpLCj9bm15pm84cKDMIh6zJwQ2Cgf83h7V?=
 =?us-ascii?Q?4OVLwpLIjyIrVdOUPSVsxywxvcTYRVQ5cKmxnIAs+fx4PNuahdozaXZKq9h5?=
 =?us-ascii?Q?KcyazoZkVTpqPsg40MzaO6txDg9sgdjJJKgd4w9Uekmk+7YVLlGTnBHfxL/m?=
 =?us-ascii?Q?RdAWfE6wTsZb/imdL5u1lgFhtGaWlmafDnllnA9OVjQhJ0XhpKtSxCblLjjh?=
 =?us-ascii?Q?tHUns4kiNw3Bw0mSA6c4Z6LrQ19oQp7fvAcSOwUo1QasacsDmjPovUwAXiPa?=
 =?us-ascii?Q?+UQS4zQWLmszlwbNgwe4DKnzRW2vhEWDEvSgy/K88uK3y6ktX1cbQv+4+3RX?=
 =?us-ascii?Q?DciKUH1uapJ1ipYX3MOimJKxqs0UKMm9lHZh6/6ZLFcsnXQvQCSK4XAgrcA3?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591a9116-0ecd-424a-b8ee-08da773af859
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 23:33:58.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFcmHYXONPh4/k7l0OfZEPPZd/JpwzxIx8vAzfsohGm9YWCbqQ21H5cQcD3H7SrXM3i1t4wejSEzy/XI4ueW+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_12,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050104
X-Proofpoint-ORIG-GUID: WGEQue964tMV947DSmUT1d2Rgtb_dYCa
X-Proofpoint-GUID: WGEQue964tMV947DSmUT1d2Rgtb_dYCa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/05/22 19:13, Peter Xu wrote:
> On Fri, Aug 05, 2022 at 01:48:35PM -0700, Mike Kravetz wrote:
> > On 08/05/22 20:57, David Hildenbrand wrote:
> > > On 05.08.22 20:33, Mike Kravetz wrote:
> > > > On 08/05/22 20:25, David Hildenbrand wrote:
> > > >> On 05.08.22 20:23, Mike Kravetz wrote:
> > > >>> On 08/05/22 14:14, Peter Xu wrote:
> > > >>>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
> > > >>>>> diff --git a/mm/mmap.c b/mm/mmap.c
> > > >>>>> index 61e6135c54ef..462a6b0344ac 100644
> > > >>>>> --- a/mm/mmap.c
> > > >>>>> +++ b/mm/mmap.c
> > > >>>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> > > >>>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> > > >>>>>  		return 0;
> > > >>>>>  
> > > >>>>> +	/*
> > > >>>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
> > > >>>>> +	 * support softdirty tracking.
> > > >>>>> +	 */
> > > >>>>> +	if (is_vm_hugetlb_page(vma))
> > > >>>>> +		return 0;
> > > >>>>
> > > >>>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> > > >>>> hugetlb but here it's explicitly forbidden.
> > > >>>>
> > > >>>> Could you explain a bit more on why this patch is needed if (assume
> > > >>>> there'll be a working) patch 2 being provided?
> > > >>>>
> > > >>>
> > > >>> No comments on the patch, but ...
> > > >>>
> > > >>> Since it required little thought, I ran the test program on next-20220802 and
> > > >>> was surprised that the issue did not recreate.  Even added a simple printk
> > > >>> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
> > > >>> We were.
> > > >>
> > > >>
> > > >> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
> > > >>
> > > > 
> > > > No, Duh!
> > > > 
> > > > FYI - Some time back, I started looking at adding soft dirty support for
> > > > hugetlb mappings.  I did not finish that work.  But, I seem to recall
> > > > places where code was operating on hugetlb mappings when perhaps it should
> > > > not.
> > > > 
> > > > Perhaps, it would also be good to just disable soft dirty for hugetlb at
> > > > the source?
> > > 
> > > I thought about that as well. But I came to the conclusion that without
> > > patch #2, hugetlb VMAs cannot possibly support write-notify, so there is
> > > no need to bother in vma_wants_writenotify() at all.
> > > 
> > > The "root" would be places where we clear VM_SOFTDIRTY. That should only
> > > be fs/proc/task_mmu.c:clear_refs_write() IIRC.
> > > 
> > > So I don't particularly care, I consider this patch a bit cleaner and
> > > more generic, but I can adjust clear_refs_write() instead of there is a
> > > preference.
> > > 
> > 
> > After a closer look, I agree that this may be the simplest/cleanest way to
> > proceed.  I was going to suggest that you note hugetlb does not support
> > softdirty, but see you did in the comment.
> > 
> > Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
> Filtering out hugetlbfs in vma_wants_writenotify() is still a bit hard to
> follow to me, since it's not clear why hugetlbfs never wants writenotify.
> 
> If it's only about soft-dirty, we could have added the hugetlbfs check into
> vma_soft_dirty_enabled(), then I think it'll achieve the same thing and
> much clearer - with the soft-dirty check constantly returning false for it,
> hugetlbfs shared vmas should have vma_wants_writenotify() naturally return
> 0 already.
> 
> For the long term - shouldn't we just enable soft-dirty for hugetlbfs?  I
> remember Mike used to have that in todo.  Since we've got patch 2 already,
> I feel like that's really much close (is the only missing piece the clear
> refs write part? or maybe some more that I didn't notice).
> 
> Then patch 1 (or IMHO equivalant check in vma_soft_dirty_enabled(), but
> maybe in stable trees we don't have vma_soft_dirty_enabled then it's
> exactly patch 1) can be a stable-only backport just to avoid the bug from
> triggering.

It looks like vma_soft_dirty_enabled is recent and not in any stable
trees (or even 5.19).

Yes, I did start working on hugetlb softdirty support in the past.
https://lore.kernel.org/lkml/20210211000322.159437-1-mike.kravetz@oracle.com/

Unfortunately, it got preempted by other things.  I will try to move it up
the priority list.
-- 
Mike Kravetz
